#' Get file extension
#'
#' @param file.path the target file path
#'
#' @return a string that corresponds to the file extension
#' @export
#'
#' @examples ext <- getExtension(file.path = system.file("extdata", "test.txt", package = "readepi"))
getExtension <- function(file.path) {
  splits <- unlist(strsplit(basename(file.path), ".", fixed = TRUE))
  extension <- splits[length(splits)]
  extension
}

get_base_name <- function(x) {
  ext <- getExtension(x)
  bn <- gsub(paste0(".", ext), "", basename(x))
  bn
}

detect_separator <- function(x) {
  special.characters <- c("\t", "|", ",", ";", " ") # look for other common sep
  sep <- NULL
  for (spec.char in special.characters) {
    if (stringr::str_detect(x, spec.char)) {
      sep <- c(sep, spec.char)
    }
  }
  unique(sep)
}

read_multiple_files <- function(files, dirs, format = NULL, which = NULL) {
  # filter out directories from files
  idx <- which(files %in% dirs)
  if (length(idx) > 0) {
    files <- files[-idx]
  }

  # defining rio package file extensions
  rio.extensions <- c(
    "csv", "psv", "tsv", "csvy", "sas7bdat", "sav", "zsav", "dta", "xpt",
    "por", "xls", "R", "RData", "rda", "rds", "rec", "mtp", "syd", "dbf",
    "arff", "dif", "no recognized extension", "fwf", "csv.gz", "parquet",
    "wf1", "feather", "fst", "json", "mat", "ods", "html", "xml", "yml"
  )

  # getting files extensions and basenames
  files.extensions <- as.character(lapply(files, getExtension))
  files.base.names <- as.character(lapply(files, get_base_name))

  # reading files with extensions that are taken care by rio
  idx <- which(files.extensions %in% rio.extensions)
  result <- list()
  if (length(idx) > 0) {
    tmp.files <- files[idx]
    tmp.bn <- files.base.names[idx]
    i <- 1
    for (file in tmp.files) {
      data <- rio::import(file) # , format = format, which = which
      result[[tmp.bn[i]]] <- data
      i <- i + 1
    }
    files <- files[-idx]
    files.base.names <- files.base.names[-idx]
    files.extensions <- files.extensions[-idx]
  }

  # reading files which extensions are not taken care by rio
  i <- 1
  for (file in files) {
    if (files.extensions[i] %in% c("xlsx", "xls")) {
      data <- readxl::read_xlsx(file)
      result[[files.base.names[i]]] <- data
      i <- i + 1
    } else {
      tmp.string <- readLines(con = file, n = 1)
      sep <- detect_separator(tmp.string)
      if (length(sep) == 1 && sep == "|") {
        sep <- "|"
      } else {
        sep <- sep[-(which(sep == "|"))]
        if (length(sep) == 2 && " " %in% sep) {
          sep <- sep[-(which(sep == " "))]
          if (length(sep) > 1) {
            R.utils::cat("\nCan't resolve separator in", file, "\n")
            i <- i + 1
            next
          }
        }
      }
      data <- data.table::fread(file, sep = sep, nThread = 4)
      result[[files.base.names[i]]] <- data
      i <- i + 1
    }
  }
  result
}


#' function to subset fields
#' @param data.frame the input data frame
#' @param fields the list of columns of interest
#' @param table.name the table names
#' @examples
#' \dontrun{
#' data <- subset_fields(
#'   data.frame = data.frame,
#'   fields = "id,data_entry_date",
#'   table.name = "dss_events"
#' )
#' }
#' @returns a list of 2 elements: the subset data frame and an integer that tells whether all fields were missing in the table (1) or not (0)
#' @importFrom magrittr %>%
#' @importFrom dplyr all_of
#' @export
subset_fields <- function(data.frame, fields, table.name) {
  checkmate::assert_data_frame(data.frame, null.ok = FALSE)
  checkmate::assertCharacter(table.name, len = 1L, null.ok = FALSE)
  checkmate::assert_vector(fields,
    any.missing = FALSE, min.len = 1,
    null.ok = FALSE, unique = TRUE
  )
  not.found <- 0
  target.fields <- as.character(unlist(strsplit(fields, ",")))
  target.fields <- as.character(lapply(target.fields, function(x){gsub(" ","",x)}))
  idx <- which(target.fields %in% names(data.frame))
  if (length(idx) == 0) {
    message("\nThere is no column named as: ", paste(target.fields, collapse = ", "), " in ", table.name)
    not.found <- 1
  } else if (length(idx) != length(target.fields)) {
    message("\nThe following fields were not found in ", table.name, ": ", paste(target.fields[-idx], collapse = ", "))
    target.fields <- target.fields[idx]
    data <- data.frame %>% dplyr::select(all_of(target.fields))
  } else {
    data <- data.frame %>% dplyr::select(all_of(target.fields))
  }
  list(data = data, not_found = not.found)
}


#' function to subset records
#' @param data.frame the input data frame
#' @param records the list of columns of interest
#' @param id.position a vector of the column position of the variable that unique identifies the subjects. If not provided, it will assumes the first column as the subject ID column in all the tables
#' @param table.name the table name
#' @returns a list of 2 elements: the subset data frame and an integer that tells whether all fields were missing in the table (1) or not (0)
#' @importFrom magrittr %>%
#' @examples
#' \dontrun{
#' sub.data <- subset_records(data.frame, records, id.position = 1, table.name)
#' }
#' @export
subset_records <- function(data.frame, records, id.position = 1, table.name) {
  checkmate::assert_data_frame(data.frame, null.ok = FALSE)
  checkmate::assertCharacter(table.name, len = 1L, null.ok = FALSE)
  checkmate::assert_vector(records,
    any.missing = FALSE, min.len = 1,
    null.ok = FALSE, unique = TRUE
  )
  checkmate::assert_number(id.position, lower = 1, null.ok = FALSE)
  not.found <- 0
  records <- as.character(unlist(strsplit(records, ",")))
  records <- as.character(lapply(records, function(x){gsub(" ","",x)}))
  id.column.name <- names(data.frame)[id.position]
  if (is.numeric(data.frame[[id.column.name]])) {
    records <- as.numeric(records)
  }
  m <- match(records, data.frame[[id.column.name]])
  idx <- m[!is.na(m)]
  if (length(idx) == 0) {
    message("\nThere is no subject ID named as: ", paste(records, collapse = ", "), " in ", table.name)
    not.found <- 1
  } else if (length(idx) != length(records)) {
    mm <- which(is.na(m))
    message("\nThe following records were not found in ", table.name, ": ", paste(records[mm], collapse = ", "))
    data <- data.frame[idx, ]
  } else {
    data <- data.frame[idx, ]
  }
  list(data = data, not_found = not.found)
}


#' function to read credentials from a configuration file
#' @param file.path the path to the file with the user-specific credential details for the projects of interest.
#' @param project.id for relational DB, this is the name of the database that contains the table from which the data should be pulled. Otherwise, it is the project ID you were given access to.
#' @returns  a list with the user credential details.
#' @examples
#' \dontrun{
#' credentials <- read_credentials(file.path = system.file("extdata", "fake_test.ini", package = "readepi"), project.id = "my_project_id")
#' }
#' @export
read_credentials <- function(file.path = system.file("extdata", "test.ini", package = "readepi"),
                             project.id = NULL) {
  checkmate::assertCharacter(file.path, len = 1L, null.ok = FALSE)
  checkmate::assert_file_exists(file.path)
  checkmate::assertCharacter(project.id, len = 1L, null.ok = FALSE)
  if (!file.exists(file.path) | is.null(file.path)) {
    stop("Could not find ", file.path)
  }
  if (is.null(project.id)) {
    stop("Database name or project ID not specified!")
  }

  credentials <- data.table::fread(file.path, sep = "\t")
  if (ncol(credentials) != 7) {
    stop("credential file should be tab-separated file with 7 columns.")
  }
  if (!all((names(credentials) %in% c("user_name", "password", "host_name", "project_id", "comment", "dbms", "port")))) {
    stop("Incorrect column names found in provided credentials file.\nThe column names should be 'user_name', 'password', 'host_name', 'project_id', 'comment', 'dbms', 'port'")
  }
  idx <- which(credentials$project_id == project.id)
  if (length(idx) == 0) {
    stop("Credential details for ", project.id, " not found in credential file.")
  } else if (length(idx) > 1) {
    stop("Multiple credential lines found for the specified project ID.\nCredentials file should contain one line per project.")
  } else {
    project.credentials <- list(
      user = credentials$user_name[idx],
      pwd = credentials$password[idx],
      host = credentials$host_name[idx],
      project = credentials$project_id[idx],
      dbms = credentials$dbms[idx],
      port = credentials$port[idx]
    )
  }
  project.credentials
}


#' function to check authentication details
login = function(username,password,base.url) {
  checkmate::assertCharacter(base.url, len = 1L, null.ok = FALSE, any.missing = FALSE)
  checkmate::assertCharacter(username, len = 1L, null.ok = FALSE, any.missing = FALSE)
  checkmate::assertCharacter(password, len = 1L, null.ok = FALSE, any.missing = FALSE)

  url = paste0(base.url,"/api/me")
  resp = httr::GET(url,httr::authenticate(username,password))
  httr::stop_for_status(resp)
  R.utils::cat("\nLogged in successfully!")
}

#' function to get the data element identifiers and names
get_data_elements = function(base.url,username,password) {
  url = paste0(base.url,"/api/dataElements?fields=id,name,shortName&paging=false")
  r = httr::content(httr::GET(url,httr::authenticate(username,password)),as="parsed")
  do.call(rbind.data.frame,r$dataElements)
}

#' function to get the datasets identifiers and names
get_data_sets = function(base.url,username,password) {
  url = paste0(base.url,"/api/dataSets?fields=id,name,shortName&paging=false")
  r = httr::content(httr::GET(url,httr::authenticate(username,password)),as="parsed")
  do.call(rbind.data.frame,r$dataSets)
}

#' function to get the organisation unit identifiers and names
get_organisation_units = function(base.url,username,password) {
  url = paste0(base.url,"/api/organisationUnits?fields=id,name,shortName&paging=false")
  r = httr::content(httr::GET(url,httr::authenticate(username,password)),as="parsed")
  do.call(rbind.data.frame,r$organisationUnits)
}

#' function to get the data element group identifiers and names
get_data_element_groups = function(base.url,username,password) {
  url = paste0(base.url,"/api/dataElementGroups?fields=id,name,shortName&paging=false")
  r = httr::content(httr::GET(url,httr::authenticate(username,password)),as="parsed")
  do.call(rbind.data.frame,r$dataElementgroups)
}



