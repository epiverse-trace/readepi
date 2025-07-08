

perform_replacement <- function(string, equivalence_table, to) {
  # detect the logical operators from the expression before the split
  r_operators <- names(
    unlist(sapply(equivalence_table[["r"]], grep, string, fixed = TRUE))
  )
  r_operators <- r_operators[!r_operators %in% c("|", "&")]

  # get the indices of the detected logical operators and
  # get their correspondent operator from the specified language or system
  idx <- which(equivalence_table[["r"]] %in% r_operators)
  target_operators <- equivalence_table[[to]][idx]

  # replace the R operators with the corresponding ones
  # TODO: fix the issue with handling the '%in%' operator
  for (operator in seq_along(r_operators)) {
    string <- gsub(
      r_operators[operator],
      target_operators[operator],
      string,
      fixed = TRUE
    )
  }

  # trim the white space
  string <- gsub("[[:blank:]]", "", string)

  return(string)
}

handle_in <- function(x) {
  splits <- unlist(strsplit(x, "%in%", fixed = TRUE))
  x <- splits[2]

  x <- gsub("\\'|\\)|c\\(", "", x)
  x <- gsub(",", ";", x)
  x <- gsub("[[:blank:]]", "", x)
  return(paste(splits[1], "%in%", x))
}

r_to_dhis2 <- function(var, equivalence_table) {
  # replace 'TRUE' and 'FALSE' by 'true' and 'false' respectively
  var <- gsub("TRUE", "true", var, fixed = TRUE)
  var <- gsub("FALSE", "false", var, fixed = TRUE)

  # replace '&&' and '||' by '&' and '|' respectively
  var <- gsub("&&", "&", var, fixed = TRUE)
  var <- gsub("||", "|", var, fixed = TRUE)

  # split by '&' or '|'
  splits <- unlist(strsplit(var, "&|\\|", perl = TRUE))

  # identify the splits that contains '%in%'
  idx <- which(grepl("%in%", splits, fixed = TRUE))
  if (length(idx) > 0) {
    splits[idx] <- as.character(vapply(splits[idx], handle_in, character(1)))
  }

  # perform operator replacement
  splits <- as.character(
    vapply(
      splits,
      FUN = perform_replacement,
      character(1),
      equivalence_table,
      to = "dhis2"
    )
  )

  splits <- paste0("filter=", splits)

  return(splits)
}


#' Convert R expression into SQL expression
#'
#' @param equivalence_table A data frame with the common R logical operators
#'    and their correspondent SQL operators
#' @param filter A string with the R expression
#'
#' @return A string of SQL expression
#' @keywords internal
#'
r_to_sql <- function(filter, equivalence_table) {
  for (i in seq_len(nrow(equivalence_table))) {
    if (grepl(equivalence_table[["r"]][i], filter)) {
      filter <- gsub(equivalence_table[["r"]][i], equivalence_table[["sql"]][i],
                     filter, fixed = TRUE)
    }
  }
  return(filter)
}

#' var <- "gender == Male && age > 5"
#' var_dhis2 <- transform_filter(var, equivalence_table, to = "dhis2")
#'
transform_filter <- function(var, equivalence_table, to = "dhis2") {
  # function to detect and replace R operators with their corresponding
  # operators from the language or system specified in 'to'
  # 'var' is the R expression
  # 'equivalence_table' is the equivalence table
  # 'to' is the name of the system or language

  #
  var <- switch(to,
                dhis2 = r_to_dhis2(var, equivalence_table),
                sql = r_to_sql(var, equivalence_table)
  )

  return(paste(var, collapse = "&"))
}


#' function to transform the value of the field option from the query parameters
#' query the ids, types, and some attributes of all tracked entities associated with the given organisation unit and program ids
#' query_parameters <- list(
#' paging = "true",
#'  # page = 1,
#'  pageSize = 50,
#'  order = "createdAt:desc",
#'  program = "IpHINAT79UW",
#'  orgUnit = "DiszpKrYNg8",
#'  orgUnitMode = "SELECTED",
#'  fields = c("trackedEntity", "trackedEntityType", "Gender", "First name",
#'             "Last name")
#')
#' query_parameters <- transform_fields(query_parameters, attributes_names)
transform_fields <- function(query_parameters, entity_attribute_names) {
  # NOTE: the `entity_attribute_names` argument is the data frame with the attribute names and ids made from the `get_entity_attributes()` function
  # NOTE: the `fields` of interest should be provided as a vector of fields

  # no need to modify the query parameter if the 'fields' of interest are not provided
  if (!("fields" %in% names(query_parameters))) {
    return(query_parameters)
  }

  # match the entity names to the provided field names
  fields <- query_parameters[["fields"]]
  idx <- fields %in% entity_attribute_names[["name"]]

  # when no attribute name is specified in 'fields', return the initial query parameters
  if (sum(!idx) == length(fields)) {
    query_parameters[["fields"]] <- paste(fields, collapse = ",")
    return(query_parameters)
  }

  # when 'fields' contains both metadata and attributes names, transform it
  if (sum(idx) == length(fields)) {
    new_fields <- sprintf("attributes[%s]", paste(fields, collapse = ","))
  } else {
    new_fields <- paste(fields[!idx], collapse = ",")
    entity_attributes <- sprintf(
      "attributes[%s]", paste(fields[idx], collapse = ",")
    )
    new_fields <- paste(new_fields, entity_attributes, sep = ",")
  }
  query_parameters[["fields"]] <- new_fields

  return(query_parameters)
}


# function to replace the attribute names by the attribute ids
replace_name_by_id <- function(expression, attributes_names) {
  # expression here is an atomic expression (Gender:EQ:Male)
  # attributes_names is the data frame with attribute names and ids

  # match the attribute name used in the expression to the list of attribute
  # names and get the index of the matching name
  idx <- which(unlist(
    lapply(attributes_names[["name"]], grepl, expression)
  ))

  # return an error if there is no match or multiple match
  if (length(idx) == 0 || length(idx) > 1) {
    stop("Incorrect attribute name provided.")
  }

  ## replace attribute name by id
  name <- attributes_names[["name"]][idx]
  id <- attributes_names[["id"]][idx]
  new_expression <- gsub(name, id, expression, fixed = TRUE)

  # trim white spaces from the input expression
  new_expression <- gsub(" ", "", new_expression, fixed = TRUE)

  return(new_expression)
}

# create the lookup table for operators
equivalence_table <- data.frame(cbind(
  r = c("==", ">=", ">", "<=", "<", "%in%", "!=", "&&", "||", "&", "|"),
  sql = c("=", ">=", ">", "<=", "<", "in", "<>", "and", "or", "and", "or"),
  dhis2 = c(":EQ:", ":GE:", ":GT:", ":LE:", ":LT:", ":IN:", ":NE:", "&", "|",
            "&", "|")
))



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

#' Match form names to endpoint names
#'
#' @param sheet_name A vector with the form names
#' @param endpoint A vector with the endpoint names
#'
#' @return A data frame with two columns with the correspondence between form
#'    names and endpoints.
#' @keywords internal
#'
#' @examples
#' download_folder <- download_api_docs(his)
#' data_dictionary <- file.path(download_folder, "dictionary.xlsx")
#' sheet_names <- readxl::excel_sheets(path = data_dictionary)
#' endpoints <- get_endpoints(his = "sormas")
#' res <- lapply(sheet_names, match_forms_to_endpoints, endpoints)
#' res <- data.frame(matrix(unlist(res), nrow = length(res), byrow = TRUE))
#' names(res) <- c("sheet_name", "endpoint")
#'
match_forms_to_endpoints <- function(sheet_name, endpoint) {
  patterns <- paste(
    c(tolower(sheet_name), gsub(" ", "", tolower(sheet_name))),
    collapse = "|"
  )
  idx <- grep(patterns, endpoint)
  if (length(idx) == 0) {
    x <- c(sheet_name, NA)
  } else {
    x <- c(sheet_name, toString(endpoint[idx]))
  }
  return(x)
}


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
