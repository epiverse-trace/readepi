#' Import data from SORMAS (Surveillance, Outbreak Response Management and
#' Analysis System)
#'
#' The function returns the following columns by default: \code{case_uuid,
#' sex, date_of_birth, case_origin, country, city, lat, long, case_status,
#' date_onset, date_admission, date_last_contact, date_first_contact, outcome,
#' date_outcome, Ct_values}. When needed, extra columns can be specified using
#' the \code{extra_columns} argument.
#'
#' @param user_name The user name
#' @param password The user's password
#' @param disease A character with the target disease name.
#' @param filter A list with the parameters needed to filter on rows. When
#'    specified, only records that meet these conditions will be returned.
#'    Default is \code{NULL}. Possible values are:
#'    \describe{
#'        \item{since:}{a \code{numeric} or \code{Date} used to specify the
#'            target date. Only cases reported from this date till now will be
#'            returned. The conversion between numeric to Date will be performed
#'            internally based on the requirement of the target HIS.}
#'        \item{sex:}{a \code{character} used to specify the gender of
#'            interest.}
#'        \item{country:}{a \code{vector} used to specify the countries of
#'            interest.}
#'        \item{city:}{a \code{vector} used to specify the cities of interest.}
#'        \item{outcome:}{a \code{vector} used to specify the outcomes of
#'            interest.}
#'    }
#'    Note that users can defined other filters than the defaults, provided that
#'    those columns will be part of the imported dataset.
#' @param extra_columns A vector used to specify the names of the additional
#'    columns to return. Default is \code{NULL}.
#'
#' @return A data frame with the case data of the specified disease.
#' @export
#'
#' @examples
#' # fetch all COVID (coronavirus) cases from the test SORMAS instance
#' covid_cases <- read_sormas(
#'   user_name = "SurvSup",
#'   password = "Lk5R7JXeZSEc",
#'   disease = "coronavirus",
#'   filter = NULL,
#'   extra_columns = NULL
#' )
#' @importFrom magrittr %>%
#'
read_sormas <- function(user_name,
                        password,
                        disease,
                        filter = NULL,
                        extra_columns = NULL) {
  cli::cli_progress_step("Importing cases data from SORMAS...",
                         msg_done = "Successfully imported cases from SORMAS.",
                         spinner = TRUE)
  checkmate::assert_vector(
    disease, min.len = 1L, null.ok = FALSE, any.missing = FALSE
  )
  checkmate::assert_character(
    filter, len = 1, null.ok = TRUE, any.missing = FALSE
  )
  checkmate::assert_vector(
    extra_columns, null.ok = TRUE, any.missing = FALSE
  )

  # The filters might depend on the API. The get_filters() functions is used to
  # construct the required filters for the HIS of interest.
  # TODO: get other opinions about the default columns on which to filter:
  # sex, country, city, outcome
  filters <- get_filters(his = "sormas", filter = filter)
  since <- filters[["since"]]
  sex <- filters[["sex"]]
  country <- filters[["country"]]
  city <- filters[["city"]]
  outcome <- filters[["outcome"]]


  # This variable stores the name of the columns that will be returned by the
  # function if the "extra_columns" argument is set to NULL.
  # It will also be used to reorder the final output such that the extra columns
  # will be the last columns.
  default_returned_columns <- c(
    "case_uuid", "country", "city", "lat", "long", "gender", "date_of_birth",
    "case_origin",  "case_status", "date_onset", "date_admission",
    "date_last_contact", "date_first_contact", "outcome", "date_outcome",
    "Ct_values"
  )

  # When some extra columns are required by the user, we will:
  # 1. check if they are not part of the default columns
  # 2. check which endpoint contains each of the extra columns from the data
  # dictionary. The identified endpoints will be queried to fetch the
  # corresponding data.
  if (!is.null(extra_columns)) {
    # identify the extra columns not part of the default columns
    idx <- which(!(extra_columns %in% default_returned_columns))
    extra_columns <- extra_columns[idx]
    if (length(extra_columns) > 0) {
      default_returned_columns <- c(default_returned_columns, extra_columns)

      # download the data dictionary and api specification files
      # they will be used to look for which endpoints contain the extra columns
      download_folder <- download_api_docs(
        his = "sormas"
      )
      data_dictionary <- file.path(download_folder, "dictionary.xlsx")
      api_specification <- file.path(download_folder, "api_specification.json")

      # TODO: identify the endpoints that contain the extra column (return a
      # data frame of 2 columns: columns - endpoint)
    }
  }

  # check if the specified disease is accounted for in SORMAS
  disease <- tolower(disease)
  sormas_diseases <- get_disease_names(
    from = "sormas",
    user_name = user_name,
    password = password
  )
  sormas_diseases[["disease"]] <- tolower(sormas_diseases[["disease"]])
  verdict <- match(disease, sormas_diseases[["disease"]])
  if (all(is.na(verdict))) {
    cli::cli_abort(c(
      x = "Incorrect disease name(s) supplied!",
      i = "Please run {.code get_disease_names()} to see the full list of \\
           available disease names."
    ))
  } else {
    if (anyNA(verdict)) {
      cli::cli_alert_warning(
        "{.code {disease[is.na(verdict)]}} not found in disease list. Please \\
        use {.code get_disease_names()} function to see the full list of \\
        disease names."
      )
    }
  }
  disease <- disease[!is.na(verdict)]

  # the base url to the test server
  # TODO: replace with the base url of the live server
  base_url <- "https://demo.sormas.org/sormas-rest"

  # construct the URL
  url <- file.path(
    base_url,
    "cases",
    "all",
    since # this is the date of interest. Remove the last
    #3 digits and use as.POSIXlt() to convert into Date.
    # Replace this with 0 to fetch all cases.
  )

  # authenticate the user
  # TODO: account for other types of authentications
  authentication_response <- authenticate(
    from = url,
    user_name = user_name,
    password = password
  )

  # perform the request and store the data from the 'cases' endpoint in 'dat'
  resp <- authentication_response %>%
    httr2::req_perform() %>%
    httr2::resp_body_json()

  # unnest the request response and convert it into data frame
  content <- lapply(resp, unlist)
  dat <- suppressMessages(dplyr::bind_rows(content))

  # retain only cases infected with the disease of interest
  dat[["disease"]] <- tolower(dat[["disease"]])
  idx <- dat[["disease"]] %in% disease
  if (length(idx) == 0L) {
    cli::cli_abort(c(
      x = "No cases found for the supplied disease.",
      i = "Please run {.code get_disease_names()} to check if you provided \\
           the correct disease name."
    ))
  }
  dat <- dat[idx, ]

  # convert the relevant date variables from numeric to Date
  dat[["outcomeDate"]] <- substr(
    dat[["outcomeDate"]], 1, nchar(dat[["outcomeDate"]]) - 3
  )
  dat[["symptoms.onsetDate"]] <- substr(
    dat[["symptoms.onsetDate"]], 1, nchar(dat[["symptoms.onsetDate"]]) - 3
  )
  dat[["hospitalization.admissionDate"]] <- substr(
    dat[["hospitalization.admissionDate"]], 1,
    nchar(dat[["hospitalization.admissionDate"]]) - 3
  )


  # fetch all person's details from the 'persons' endpoint
  # the 'uuid' column in 'dat' corresponds to the 'person.uuid' column in the
  # 'person_data'. By matching the two, we can fetch cases socio-demographic
  # data.
  url <- file.path(
    base_url,
    "persons",
    "all",
    since
  )

  authentication_response <- authenticate(
    from = url,
    user_name = user_name,
    password = password
  )

  resp <- authentication_response %>%
    httr2::req_perform() %>%
    httr2::resp_body_json()
  content <- lapply(resp, unlist)
  person_data <- suppressMessages(dplyr::bind_rows(content))

  # keep only persons with a corresponding uuid from the cases data frame
  # the person's uuid has a foreign key in the cases table. this is used to
  # match the cases to the person data.
  idx <- match(dat[["person.uuid"]], person_data[["uuid"]])
  person_data <- person_data[idx, ]

  # get the date of birth. We are not using the age given it comes into
  # different units. The age can be derived from the date of birth columns
  birth_day_cols <- c("birthdateYYYY", "birthdateMM", "birthdateDD")
  person_data[["date_of_birth"]] <- as.Date(apply(
    person_data[, birth_day_cols], 1, paste, collapse = "-"
  ))

  # get the case_name, sex, country, city, latitude, longitude from the
  # persons details.
  # 'case_name' is the combination of the first and the last names
  final_data <- data.frame(
    case_uuid = dat[["uuid"]],
    person_uuid = dat[["person.uuid"]],
    sex = person_data[["sex"]],
    date_of_birth = person_data[["date_of_birth"]],
    case_origin = dat[["caseOrigin"]],
    case_status = dat[["caseClassification"]],
    outcome = dat[["outcome"]],
    date_outcome = as.Date(
      as.POSIXct(as.numeric(dat[["outcomeDate"]]),
      origin = "1970-01-01")
    ),
    date_onset = as.Date(as.POSIXct(
      as.numeric(dat[["symptoms.onsetDate"]]),
      origin = "1970-01-01")
    ),
    date_admission = as.Date(
      as.POSIXct(as.numeric(dat[["hospitalization.admissionDate"]]),
                 origin = "1970-01-01")
    ),
    country = person_data[["address.country.caption"]],
    city = person_data[["address.city"]],
    lat = person_data[["address.latitude"]],
    long = person_data[["address.longitude"]],
    stringsAsFactors = FALSE
  )

  # fetch all contacts details from the 'contacts' endpoint where we can extract
  # contact tracing data such as 'date_first_contact', 'date_last_contact'.
  # the case 'uuid' column corresponds to the contact 'caze.uuid' column in the
  # contact data.
  # Note that not all cases have reported contact information
  url <- file.path(
    base_url,
    "contacts",
    "all",
    since
  )

  authentication_response <- authenticate(
    from = url,
    user_name = user_name,
    password = password
  )

  resp <- authentication_response %>%
    httr2::req_perform() %>%
    httr2::resp_body_json()
  content <- lapply(resp, unlist)
  contact_data <- suppressMessages(dplyr::bind_rows(content))
  idx <- match(final_data[["case_uuid"]], contact_data[["caze.uuid"]])
  date_last_contact <- contact_data[["lastContactDate"]][idx]
  date_last_contact <- substr(
    date_last_contact, 1, nchar(date_last_contact) - 3
  )
  final_data[["date_last_contact"]] <- as.Date(
    as.POSIXct(as.numeric(date_last_contact),
               origin = "1970-01-01")
  )

  # 'firstContactDate' might not be part of columns from the contact data frame
  # check before adding it
  if ("firstContactDate" %in% names(contact_data)) {
    date_first_contact <- contact_data[["firstContactDate"]][idx]
    date_first_contact <- substr(
      date_first_contact, 1, nchar(date_first_contact) - 3
    )
    final_data[["date_first_contact"]] <- as.Date(
      as.POSIXct(as.numeric(date_first_contact),
                 origin = "1970-01-01")
    )
  }

  # Add the Ct (cycle threshold) values from the lab test
  # Pathogen tests are linked with sample. The sample then is connected to a
  # case. From the pathogen test data, we can extract the Ct values and the
  # associated sample case uuids.
  url <- file.path(
    base_url,
    "pathogentests",
    "all",
    since
  )

  authentication_response <- authenticate(
    from = url,
    user_name = user_name,
    password = password
  )

  resp <- authentication_response %>%
    httr2::req_perform() %>%
    httr2::resp_body_json()
  content <- lapply(resp, unlist)
  pathogen_tests_data <- suppressMessages(dplyr::bind_rows(content))
  idx <- match(final_data[["case_uuid"]],
               pathogen_tests_data[["sample.associatedCaseUuid"]])
  final_data[["Ct_values"]] <- pathogen_tests_data[["cqValue"]][idx]

  return(final_data)
}
