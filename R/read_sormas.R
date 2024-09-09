#' Import data from SORMAS (Surveillance, Outbreak Response Management and
#' Analysis System)
#'
#' @param user_name The user name
#' @param password The user's password
#' @param query_parameters A list with the query parameters. Possible values
#'    are:
#'    \enumerate{
#'        \item disease: a character with the target disease name (required).
#'        \item uuid: a character with the target case id. Default is "all" to
#'            fetch all cases of the specified disease (required).
#'        \item since: a numeric used to specify the target date. Only cases
#'            reported from this date till now will be returned (required).
#'            Default is 0 to fetch cases from the first date.
#'            When a Date value is provided instead of a numeric value, this
#'            will be converted internally.
#'    }
#'
#' @return A data frame with the case data of the specified disease.
#' @export
#'
#' @examples
#' # fetch all COVID (coronavirus) cases from the first date
#' covid_cases <- read_sormas(
#'   user_name = "SurvSup",
#'   password = "Lk5R7JXeZSEc",
#'   query_parameters <- list(
#'     disease = "coronavirus",
#'     uuid = "all", # could take a vector of uuids
#'     since = 0 # cases from this date to now will be fetched
#'   )
#' )
#' @importFrom magrittr %>%
read_sormas <- function(user_name, password, query_parameters) {
  cli::cli_progress_step("Importing cases data from SORMAS...",
                         msg_done = "Successfully imported cases from SORMAS.",
                         spinner = TRUE)

  checkmate::assert_list(query_parameters, any.missing = FALSE, len = 3L,
                         null.ok = FALSE)
  checkmate::check_subset(query_parameters,
                          choices = c("disease", "uuid", "since"))
  checkmate::assert_vector(query_parameters[["disease"]], min.len = 1L,
                           null.ok = FALSE, any.missing = FALSE)
  checkmate::assert_character(query_parameters[["uuid"]], len = 1L,
                              any.missing = FALSE, null.ok = FALSE)
  if (!checkmate::test_numeric(query_parameters[["since"]]) &&
      lubridate::is.Date(query_parameters[["since"]])) {
    query_parameters[["since"]] <- as.numeric(
      as.POSIXct(query_parameters[["since"]])
    )
  }

  # check if the specified disease is accounted for in SORMAS
  disease <- tolower(query_parameters[["disease"]])
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
    query_parameters[["uuid"]],
    query_parameters[["since"]] # this is the date of interest. Remove the last
    #3 digits and use as.POSIXlt() to convert into Date.
    # Replace this with 0 to fetch all cases.
  )

  # authenticate the user
  # TO DO: account for other types of authentications
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
    query_parameters[["uuid"]],
    query_parameters[["since"]]
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
    case_name = paste(person_data[["firstName"]], person_data[["lastName"]],
                      sep = " "),
    sex = person_data[["sex"]],
    date_of_birth = person_data[["date_of_birth"]],
    case_origin = dat[["caseOrigin"]],
    case_type = dat[["caseClassification"]],
    case_epi_confirmation = dat[["epidemiologicalConfirmation"]],
    case_lab_confirmation = dat[["laboratoryDiagnosticConfirmation"]],
    case_clinical_confirmation = dat[["clinicalConfirmation"]],
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
    query_parameters[["uuid"]],
    query_parameters[["since"]]
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
  idx <- match(dat[["uuid"]], contact_data[["caze.uuid"]])
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

  return(final_data)
}
