#' Get the list of disease names from a SORMAS instance
#'
#' @inheritParams read_sormas
#'
#' @return A vector of the list of disease names in a SORMAS instance
#' @export
#' @examples
#' \dontrun{
#'   # establish the connection to the SORMAS system
#'   sormas_login <- login(
#'     type = "sormas",
#'     from = "https://demo.sormas.org/sormas-rest",
#'     user_name = "SurvSup",
#'     password = "Lk5R7JXeZSEc"
#'   )
#'   disease_names <- sormas_get_diseases(
#'     login = sormas_login
#'   )
#' }
#'
sormas_get_diseases <- function(login) {
  target_url <- file.path(
    login[["base_url"]],
    "diseaseconfigurations",
    "all",
    0
  )
  resp <- httr2::request(target_url) |>
    httr2::req_auth_basic(login[["user_name"]], login[["password"]]) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  content <- lapply(resp, unlist)
  disease_names <- suppressMessages(dplyr::bind_rows(content))

  # only return columns with the disease names and whether a disease is active
  # or not
  target_columns <- c("disease", "active")
  disease_names <- disease_names |>
    dplyr::select(dplyr::all_of(target_columns))
  return(disease_names)
}


#' Get case data from a SORMAS instance
#'
#' @inheritParams read_sormas
#'
#' @returns A data frame with the following eight columns: 'case_id',
#'    'person_id', 'date_onset', 'date_admission', 'case_origin', 'case_status',
#'    'outcome', 'date_outcome'. When not available, the 'person_id' and
#'    'date_outcome' will not be returned.
#' @keywords internal
#'
sormas_get_cases_data <- function(login, disease, since) {
  # Target the 'cases' endpoint to fetch all cases
  # construct the URL
  target_url <- file.path(
    login[["base_url"]],
    "cases",
    "all",
    since # this is the date of interest. Remove the last
    #3 digits and use as.POSIXlt() to convert into Date.
    # Replace this with 0 to fetch all cases.
  )

  # perform the request and store the data from the 'cases' endpoint in 'dat'
  resp <- httr2::request(target_url) |>
    httr2::req_auth_basic(login[["user_name"]], login[["password"]]) |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  # unnest the request response and convert it into data frame
  content <- lapply(resp, unlist)
  dat <- suppressMessages(dplyr::bind_rows(content))

  # retain only cases infected with the diseases of interest
  dat[["disease"]] <- tolower(dat[["disease"]])
  idx <- dat[["disease"]] %in% disease
  if (sum(idx) == 0L) {
    cli::cli_abort(c(
      x = "No cases found for the supplied disease.",
      i = "Please run {.fn sormas_get_diseases} to check if you provided \\
           the correct disease name."
    ))
  }
  dat <- dat[idx, ]

  # define the set of default columns to extract from cases data
  cols_from_cases <- c(
    "uuid", "person.uuid", "symptoms.onsetDate",
    "hospitalization.admissionDate", "caseOrigin", "caseClassification",
    "outcome", "outcomeDate"
  )
  names(cols_from_cases) <- c(
    "case_id", "person_id", "date_onset", "date_admission",
    "case_origin", "case_status", "outcome", "date_outcome"
  )

  # get their indices in the cases data and select them
  idx <- match(cols_from_cases, names(dat))
  if (all(is.na(idx))) {
    cli::cli_abort(c(
      x = "Cannot find the columns of interest from the {.emph cases} endpoint."
    ))
  }
  if (anyNA(idx)) {
    cli::cli_alert_warning(
      "{.field {cols_from_cases[is.na(idx)]}} not found for cases with the \\
      specified diseases."
    )
  }
  cols_from_cases <- cols_from_cases[!is.na(idx)]
  dat <- dat |>
    dplyr::select(dplyr::all_of(cols_from_cases))

  # convert date variables into ISO8601 format
  dat <- convert_to_date(
    dat,
    target_columns = c("date_onset", "date_admission")
  )

  return(dat)
}


#' Get personal data of cases from a SORMAS instance
#'
#' @inheritParams read_sormas
#'
#' @returns A data frame with the following eight columns: 'case_id',
#'    'sex', 'date_of_birth', 'country', 'city', 'latitude', 'longitude'
#' @keywords internal
#'
sormas_get_persons_data <- function(login, since) {
  # fetch all person's details from the 'persons' endpoint
  # the 'uuid' column in 'dat' corresponds to the 'uuid' column in the
  # 'person_data'. By matching the two, we can fetch cases socio-demographic
  # data.
  target_url <- file.path(
    login[["base_url"]],
    "persons",
    "all",
    since
  )

  # send the request to get the persons data
  resp <- httr2::request(target_url) |>
    httr2::req_auth_basic(login[["user_name"]], login[["password"]]) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  content <- lapply(resp, unlist)
  person_data <- suppressMessages(dplyr::bind_rows(content))

  # create the date of birth column
  # get the date of birth. We are not using the age given it comes into
  # different units. The age can be derived from the date of birth columns
  birth_day_cols <- c("birthdateYYYY", "birthdateMM", "birthdateDD")

  # add 0 to months or days between 1 and 9
  add_0 <- function(x) {
    if (is.na(x) || nchar(x) == 2) {
      return(x)
    } else {
      return(paste0("0", x))
    }
  }
  person_data[["birthdateMM"]] <- unlist(
    lapply(person_data[["birthdateMM"]], add_0)
  )
  person_data[["birthdateDD"]] <- unlist(
    lapply(person_data[["birthdateDD"]], add_0)
  )

  # create the date_of_birth column
  person_data[["date_of_birth"]] <- as.character(
    apply(person_data[, birth_day_cols], 1, paste, collapse = "-")
  )

  # replace "NA-NA-NA" by NA in the date_of_birth column
  idx <- person_data[["date_of_birth"]] == "NA-NA-NA"
  person_data[["date_of_birth"]][idx] <- NA_character_

  # define the set of default columns to be taken from the 'persons' endpoint
  cols_from_persons <- c(
    "uuid", "sex", "date_of_birth", "address.country.caption",
    "address.city", "address.latitude", "address.longitude"
  )
  names(cols_from_persons) <- c(
    "case_id", "sex", "date_of_birth", "country", "city", "latitude",
    "longitude"
  )

  # get their indices in the persons data and select them
  idx <- match(cols_from_persons, names(person_data))
  if (all(is.na(idx))) {
    cli::cli_abort(c(
      x = "Cannot find the columns of interest from the {.emph cases} endpoint."
    ))
  }
  if (anyNA(idx)) {
    cli::cli_alert_warning(
      "{.field {cols_from_persons[is.na(idx)]}} not found for cases with \\
      the specified diseases."
    )
  }
  cols_from_persons <- cols_from_persons[!is.na(idx)]
  person_data <- person_data |>
    dplyr::select(dplyr::all_of(cols_from_persons))

  return(person_data)
}

#' Convert numeric values into POSIXct,then into Date
#'
#' @param data A data frame with the numeric columns to be converted into Date
#' @param target_columns A character vector with the name of the target numeric
#'    columns
#'
#' @returns A data frame where the specified target columns have been converted
#'    into Date
#' @keywords internal
#'
convert_to_date <- function(data, target_columns) {
  substract_and_convert <- function(x) {
    x <- substr(x, 1, nchar(x) - 3)
    x <- as.Date(as.POSIXct(as.numeric(x), origin = "1970-01-01"))
    return(as.character(x))
  }
  converted_df <- rbind(
    apply(data[, target_columns], 2, substract_and_convert)
  )
  rownames(converted_df) <- NULL
  data[, target_columns] <- data.frame(converted_df) |>
    dplyr::mutate(
      dplyr::across(
        dplyr::all_of(target_columns), ~ as.Date(as.character(.x),
                                                 format = "%Y-%m-%d")
      )
    )
  return(data)
}


#' Get contact data from SORMAS
#'
#' @inheritParams read_sormas
#'
#' @returns A data frame with the following three columns: 'case_id',
#'    'contact_id', 'date_last_contact', 'date_first_contact'. When not
#'    available, 'date_last_contact' will not be returned
#' @keywords internal
#'
sormas_get_contact_data <- function(login, since) {
  # build the URL to the 'contacts' endpoint
  target_url <- file.path(
    login[["base_url"]],
    "contacts",
    "all",
    since
  )

  # send the request to get the contact data
  resp <- httr2::request(target_url) |>
    httr2::req_auth_basic(login[["user_name"]], login[["password"]]) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  content <- lapply(resp, unlist)
  contact_data <- suppressMessages(dplyr::bind_rows(content))
  date_last_contact <- contact_data[["lastContactDate"]]
  date_last_contact <- substr(
    date_last_contact, 1, nchar(date_last_contact) - 3
  )
  contact_data[["lastContactDate"]] <- as.Date(
    as.POSIXct(as.numeric(date_last_contact), origin = "1970-01-01")
  )

  # select the columns of interest
  output_contact_data <- contact_data |>
    dplyr::select("uuid", "caze.uuid", "lastContactDate")
  names(output_contact_data) <- c("contact_id", "case_id", "date_last_contact")

  # 'firstContactDate' might not be part of columns from the contact data frame
  # check before adding it
  if ("firstContactDate" %in% names(contact_data)) {
    date_first_contact <- contact_data[["firstContactDate"]]
    date_first_contact <- substr(
      date_first_contact, 1, nchar(date_first_contact) - 3
    )
    output_contact_data[["date_first_contact"]] <- as.Date(
      as.POSIXct(as.numeric(date_first_contact), origin = "1970-01-01")
    )
  }

  return(output_contact_data)
}


#' Get pathogen tests data from SORMAS
#'
#' @inheritParams read_sormas
#'
#' @returns A data frame with the following two columns: 'case_id', 'Ct_values'
#' @keywords internal
#'
sormas_get_pathogen_data <- function(login, since) {
  # build the URL to target the 'pathogentests' endpoint
  target_url <- file.path(
    login[["base_url"]],
    "pathogentests",
    "all",
    since
  )

  # send the request to get the pathogentests data
  resp <- httr2::request(target_url) |>
    httr2::req_auth_basic(login[["user_name"]], login[["password"]]) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  content <- lapply(resp, unlist)
  pathogen_tests_data <- suppressMessages(dplyr::bind_rows(content))
  pathogen_tests_data <- pathogen_tests_data |>
    dplyr::select("sample.associatedCaseUuid", "cqValue")
  names(pathogen_tests_data) <- c("case_id", "Ct_values")

  return(pathogen_tests_data)
}


#' Download SORMAS data dictionary
#'
#' @param path A character with the path to the folder where the downloaded data
#'    dictionary should be stored. Default is `NULL` i.e. the data dictionary
#'    will be stored in `tempdir()`
#' @param overwrite A logical used to specify whether to overwrite to overwrite
#'    the existing data dictionary or not. Default is `TRUE`
#'
#' @returns A character with path to the folder where the data dictionary is
#'    stored. When \code{path = NULL}, the file will be stored in the R
#'    temporary folder as: \code{dictionary.xlsx}
#' @export
#'
#' @examples
#' # download and save the data dictionary in the default R temporary directory
#' path_to_dictionary <- sormas_get_data_dictionary()
#'
sormas_get_data_dictionary <- function(path = tempdir(), overwrite = TRUE) {
  checkmate::assert_character(path, len = 1, any.missing = FALSE,
                              null.ok = FALSE)
  # Every HIS has a URL from where the dictionary can be retrieved. We make sure
  # to have the URL for each API.
  dictionary_url <- paste0(
    "https://raw.githubusercontent.com/sormas-foundation/SORMAS-Project/",
    "development/sormas-api/src/main/resources/doc/", # nolint: nonportable_path_linter
    "SORMAS_Data_Dictionary.xlsx"
  )

  # The data dictionary and api specification will be stored in a temporary
  # directory if the user has not provided a path
  file_extension <- strsplit(
    basename(dictionary_url), split = "\\.", fixed = TRUE
  )[[1]]
  dictionary <- file.path(
    path,
    paste("dictionary", file_extension[-1], sep = ".")
  )
  if (file.exists(dictionary)) {
    unlink(dictionary)
  }

  utils::download.file(
    dictionary_url,
    destfile = dictionary,
    method = "curl",
    quiet = TRUE
  )
  return(dictionary)
}


#' Download the API specification file from SORMAS
#'
#' @inheritParams sormas_get_data_dictionary
#'
#' @return Invisibly returns the path to the folder where the file is stored.
#'    When \code{path = NULL}, the file will be stored in the R temporary
#'    folder as: \code{api_specification.json}
#' @export
#'
#' @examples
#' # save the SORMAS API specification into the temporary R folder
#' path_api_specs <- sormas_get_api_specification()
#'
sormas_get_api_specification <- function(path = tempdir(), overwrite = TRUE) {
  # Every API is documented automatically through the Open API specification
  # file. This file provides the actual names of the endpoints that needs to be
  # used when sending a request. We download this file to match it with the data
  # dictionary to get actual endpoint names.
  api_specification_url <- paste0(
    "https://raw.githubusercontent.com/SORMAS-Foundation/SORMAS-Project/refs/",
    "heads/development/sormas-rest/swagger.json" # nolint: nonportable_path_linter
  )
  api_specification <- file.path(path, "api_specification.json")
  if (file.exists(api_specification)) {
    unlink(api_specification)
  }

  utils::download.file(
    api_specification_url,
    destfile = api_specification,
    method = "curl",
    quiet = TRUE
  )

  return(api_specification)
}
