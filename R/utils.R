#' Get the list of disease names for which cases data is available in a
#' given health information system (HIS).
#'
#' @param from The name of the HIS. Possible values are: sormas, dhis2, odk,
#'    redcap, global.health, goData
#' @param user_name The user name
#' @param password The user's password
#'
#' @return A vector of the list of disease names.
#' @export
#'
#' @examples
#' # get the disease names from SORMAS
#' sormas_diseases <- get_disease_names(
#'   from = "sormas",
#'   user_name = "SurvSup",
#'   password = "Lk5R7JXeZSEc"
#' )
#'
get_disease_names <- function(from, user_name, password) {
  from <- match.arg(from, choices = c("sormas", "dhis2", "odk", "redcap",
                                      "global.health", "goData"))
  # TODO: automate the process of fetching the disease names

  disease_names <- switch(
    from,
    sormas = sormas_get_diseases(user_name, password)
  )


  return(disease_names)
}




#' Download the data dictionary and API specification files of a given the
#' health information system.
#'
#' @param his The name of the health information system of interest
#' @param path The path to the directory where the downloaded files will be
#'    stored.
#'
#' @return Invisibly returns the path to the folder where the files are stored.
#'    When \code{path = NULL}, the files will be stored in the R temporary
#'    folder as: \code{dictionary.xlsx} and \code{api_specification.json}
#'    respectively.
#' @export
#'
#' @examples
#' # download the SORMAS data dictionary and API specification to the temporary
#' # R folder
#' download_folder <- download_api_docs(his = "sormas")
download_api_docs <- function(his, path = NULL) {
  checkmate::assert_character(his, len = 1, any.missing = FALSE,
                              null.ok = FALSE)
  # Every HIS has a URL from where the dictionary can be retrieved. We make sure
  # to have the URL for each API.
  dictionary_url <- switch(his,
    sormas = paste0(
      "https://raw.githubusercontent.com/sormas-foundation/SORMAS-Project/",
      "development/sormas-api/src/main/resources/doc/",
      "SORMAS_Data_Dictionary.xlsx"
    )
  )

  # The data dictionary and api specification will be stored in a temporary
  # directory if the user has not provided a path
  if (is.null(path)) {
    path <- tempdir()
  }
  file_extension <- strsplit(basename(dictionary_url), split = "\\.")[[1]]
  dictionary <- file.path(
    path,
    paste("dictionary", file_extension[-1], sep = ".")
  )
  if (file.exists(dictionary)) {
    unlink(dictionary)
  }

  download.file(
    dictionary_url,
    destfile = dictionary,
    method = "curl",
    quiet = TRUE
  )

  # Every API is documented automatically through the OpenAPI specification
  # file. This file provides the actual names of the endpoints that needs to be
  # used when sending a request. We download this file to match it with the data
  # dictionary to get actual endpoint names.
  api_specification_url <- switch(
    his,
    sormas = paste0(
      "https://raw.githubusercontent.com/SORMAS-Foundation/SORMAS-Project/refs/",
      "heads/development/sormas-rest/swagger.json"
    )
  )
  api_specification <- file.path(path, "api_specification.json")
  if (file.exists(api_specification)) {
    unlink(api_specification)
  }

  download.file(
    api_specification_url,
    destfile = api_specification,
    method = "curl",
    quiet = TRUE
  )

  return(invisible(path))
}

#' Get the list of available endpoints from an API from the API specification
#' documentation.
#'
#' @param his A character that represents the name of the health information
#'    system.
#'
#' @return A vector of the endpoints found from the API specification document.
#' @export
#'
#' @examples
#' # get the list of endpoints from SORMAS
#' sormas_endpoints <- get_endpoints(his = "sormas")
#'
get_endpoints <- function(his) {
  checkmate::assert_character(his, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  # For a given HIS, we can download both the data dictionary and api
  # specification files. We can get the endpoints and their corresponding sheet
  # from these two files
  download_folder <- download_api_docs(his)
  api_specification <- file.path(download_folder, "api_specification.json")

  # Read the JSON file to get the endpoints
  api_specification_data <- jsonlite::read_json(
    api_specification,
    eval.expr = FALSE
  )
  split_path <- function(x) {
      unlist(strsplit(x, "/", fixed = TRUE))[[2]]
  }
  endpoints <- as.character(
    lapply(names(api_specification_data[["paths"]]), split_path)
  )
  return(unique(endpoints))
}

#' Get the field names from an endpoint
#'
#' @param his A character with the name of the HIS
#' @param endpoint A character with the name of the target endpoint from which
#'    you want to get the field names.
#'
#' @return A vector of characters representing all the fields found within the
#'    specified endpoint.
#' @export
#'
#' @examples
#' # get all field from the 'persons' endpoint in 'SORMAS'
#' fields <- get_fields(
#'   his = "sormas",
#'   endpoint = "persons"
#' )
get_fields <- function(his, endpoint) {

  # For a given HIS, we can download both the data dictionary and api
  # specification files. We can get the endpoints and their corresponding sheet
  # from these two files
  download_folder <- download_api_docs(his)
  data_dictionary <- file.path(download_folder, "dictionary.xlsx")

  # Every sheet from the dictionary file contains information about the data
  # found in the corresponding endpoint. We extract the name of these sheets
  # and match them to the endpoints.
  sheet_names <- readxl::excel_sheets(path = data_dictionary)
  patterns <- paste(
    c(tolower(sheet_names), gsub(" ", "", tolower(sheet_names))),
    collapse = "|"
  )
  idx <- grep(patterns, endpoint)

  # stop the process if there is no match between the endpoint and sheet names
  if (length(idx) == 0) {
    cli::cli_abort(c(
      x = "Specified endpoint does not have a matching sheet name from the \\\
        data dictionary.",
      i = "Use {.code get_endpoints()} to see the list of available endpoints \\\
        from your system of interest."
    ))
  }

  # continue with the identified sheet name
  sheet_name <- sheet_names[idx]
  fields <- readxl::read_xlsx(path = data_dictionary, sheet = sheet_name)

  # the data dictionary has multiple sections separated by empty lines. The
  # first section has the field names. The remaining sections contain the
  # field's descriptions. We will only return the field names from the first
  # section.
  # get the line number that separates the fields and their corresponding
  # data dictionary
  idx <- which(rowSums(is.na(fields)) == ncol(fields))[1]

  # only consider the field names - no need for the dictionaries
  fields <- fields[1:(idx - 1), ]
  fields <- fields[["Field"]]
  cli::cli_alert_success(
    "Matching sheet name for {.code {endpoint}} is {.code {sheet_name}}. It \\\
    contains {.code {length(fields)}} fields."
  )
  return(fields)
}

# match_dict_specs <- function(sheet_name, endpoint) {
#   patterns <- paste(c(sheet_name, gsub(" ", "", sheet_name)), collapse = "|")
#   idx <- grep(patterns, endpoint)
#   if (length(idx) == 0) {
#     x <- c(sheet_name, NA)
#   } else {
#     x <- c(sheet_name, toString(endpoint[idx]))
#   }
#   return(x)
# }
# res <- lapply(sheet_names, match_dict_specs, endpoint)
# res <- data.frame(matrix(unlist(res), nrow = length(res), byrow = TRUE))
# names(res) <- c("sheet_name", "endpoint")


#' Construct the list of parameters used to subset rows for the imported data
#' from the user-provided filters.
#'
#' @param his A character with the name of the target HIS
#' @param filter A list with the filters to apply on the imported data
#'
#' @return An updated list of filters with the user-specified parameters.
#' @keywords internal
#'
get_filters <- function(his, filter) {
  # TODO: determine the default columns on which to filter on: sex, country,
  # city, outcome
  filters <- switch(
    his,
    sormas = sormas_get_filters(filter)
  )

  return(filters)
}

#' Return the default list of data filtration options.
#'
#' @return A list with the pre-defined data filtration options.
#' @keywords internal
#'
get_default_filters <- function() {
  return(
    list(
      since = NULL,
      sex = NULL,
      country = NULL,
      city = NULL,
      outcome = NULL
    )
  )
}

#' Update the data filtration options with the user-specified values.
#'
#' @param defaults A list with the default data filtration options
#' @param filters A list with the data filtration options defined by the user
#' @param strict A boolean used to specify whether to not allow for other data
#'    filtration options than the defaults. Default is \code{TRUE}.
#'
#' @return A list with the updated data filtration options.
#' @keywords internal
#'
modify_default_filters <- function(defaults, filters, strict = TRUE) {
  extra <- setdiff(names(filters), names(defaults))
  if (strict && (length(extra) > 0L)) {
    stop("Additional invalid options: ", toString(extra))
  }
  # keep.null is needed here
  return(utils::modifyList(defaults, filters, keep.null = TRUE))
}
