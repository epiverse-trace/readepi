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


#' Read multiple files, including multiple files in a directory
#'
#' @param files a file or vector of file path to import
#' @param dirs a directory or a vector of directories where files will be imported from
#' @param format a string used to specify the file format. This is useful when a file does not have an extension, or has a file extension that does not match its actual type
#' @param which a string used to specify the name of the excel sheet to import
#'
#' @return a list of data frames where each data frame contains data from a file
#' @export
#'
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


#' Subset fields
#'
#' @param data.frame the input data frame
#' @param fields the list of columns of interest
#' @param table.name the table names
#' @examples
#' \dontrun{
#' data <- subset_fields(
#'   data.frame = data.frame,
#'   fields = "date,sex,age",
#'   table.name = "covid"
#' )
#' }
#' @returns a list of 2 elements: the subset data frame and an integer that tells whether all fields were missing in the table (1) or not (0)
#' @importFrom magrittr %>%
#' @importFrom dplyr all_of
#' @export
subset_fields <- function(data.frame, fields, table.name) {
  checkmate::assert_data_frame(data.frame, null.ok = FALSE)
  checkmate::assertCharacter(table.name, len = 1L, null.ok = FALSE, any.missing=FALSE)
  checkmate::assert_vector(fields,
    any.missing = FALSE, min.len = 1,
    null.ok = FALSE, unique = TRUE
  )
  not.found <- 0
  target.fields <- as.character(unlist(strsplit(fields, ",")))
  target.fields <- as.character(lapply(target.fields, function(x) {
    gsub(" ", "", x)
  }))
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


#' Subset records
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
  checkmate::assertCharacter(table.name, len = 1L, null.ok = FALSE, any.missing = FALSE)
  checkmate::assert_vector(records,
    any.missing = FALSE, min.len = 1,
    null.ok = FALSE, unique = TRUE
  )
  checkmate::assert_number(id.position, lower = 1, null.ok = TRUE, na.ok = FALSE)

  not.found <- 0
  records <- as.character(unlist(strsplit(records, ",")))
  records <- as.character(lapply(records, function(x) {
    gsub(" ", "", x)
  }))
  if(is.null(id.position)){
    id.position=1
  }
  id.column.name <- names(data.frame)[id.position]
  if (is.numeric(data.frame[[id.column.name]])) {
    records <- as.numeric(records)
  }
  idx <- which(data.frame[[id.column.name]] %in% records)
  if (length(idx) == 0) {
    message("\nCould not find record named as: ", paste(records, collapse = ", "), " in column ", id.column.name, " of table ", table.name)
    not.found <- 1
  } else {
    data <- data.frame[idx, ]
  }
  list(data = data, not_found = not.found)
}


#' Read credentials from a configuration file
#'
#' @param file.path the path to the file with the user-specific credential details for the projects of interest.
#' @param project.id for relational DB, this is the name of the database that contains the table from which the data should be pulled. Otherwise, it is the project ID you were given access to.
#' @returns  a list with the user credential details.
#' @examples
#' \dontrun{
#' credentials <- read_credentials(file.path = system.file("extdata", "test.ini", package = "readepi"),
#' project.id = "TEST_READEPI")
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


#' Check DHIS2 authentication details
#'
#' @param username the user name
#' @param password the user's password
#' @param base.url the base URL of the DHIS2 server
#'
login <- function(username, password, base.url) {
  checkmate::assertCharacter(base.url, len = 1L, null.ok = FALSE, any.missing = FALSE)
  checkmate::assertCharacter(username, len = 1L, null.ok = FALSE, any.missing = FALSE)
  checkmate::assertCharacter(password, len = 1L, null.ok = FALSE, any.missing = FALSE)

  url <- paste0(base.url, "/api/me")
  resp <- httr::GET(url, httr::authenticate(username, password))
  httr::stop_for_status(resp)
  R.utils::cat("\nLogged in successfully!")
}

#' Get the data element identifiers and names
#'
#' @param username the user name
#' @param password the user's password
#' @param base.url the base URL of the DHIS2 server
#'
#' @export
#'
get_data_elements <- function(base.url, username, password) {
  checkmate::assertCharacter(base.url, len = 1L, null.ok = TRUE, any.missing = FALSE)
  checkmate::assertCharacter(username, len = 1L, null.ok = TRUE, any.missing = FALSE)
  checkmate::assertCharacter(password, len = 1L, null.ok = TRUE, any.missing = FALSE)

  url <- paste0(base.url, "/api/dataElements?fields=id,name,shortName&paging=false")
  r <- httr::content(httr::GET(url, httr::authenticate(username, password)), as = "parsed")
  do.call(rbind.data.frame, r$dataElements)
}

#' Get the dataset identifiers and names
#'
#' @param username the user name
#' @param password the user's password
#' @param base.url the base URL of the DHIS2 server
#'
#' @export
#'
get_data_sets <- function(base.url, username, password) {
  checkmate::assertCharacter(base.url, len = 1L, null.ok = FALSE, any.missing = FALSE)
  checkmate::assertCharacter(username, len = 1L, null.ok = FALSE, any.missing = FALSE)
  checkmate::assertCharacter(password, len = 1L, null.ok = FALSE, any.missing = FALSE)

  url <- paste0(base.url, "/api/dataSets?fields=id,name,shortName&paging=false")
  r <- httr::content(httr::GET(url, httr::authenticate(username, password)), as = "parsed")
  do.call(rbind.data.frame, r$dataSets)
}

#' Get the organisation unit identifiers and names
#'
#' @param username the user name
#' @param password the user's password
#' @param base.url the base URL of the DHIS2 server
#'
#' @export
#'
get_organisation_units <- function(base.url, username, password) {
  checkmate::assertCharacter(base.url, len = 1L, null.ok = FALSE, any.missing = FALSE)
  checkmate::assertCharacter(username, len = 1L, null.ok = FALSE, any.missing = FALSE)
  checkmate::assertCharacter(password, len = 1L, null.ok = FALSE, any.missing = FALSE)

  url <- paste0(base.url, "/api/organisationUnits?fields=id,name,shortName&paging=false")
  r <- httr::content(httr::GET(url, httr::authenticate(username, password)), as = "parsed")
  do.call(rbind.data.frame, r$organisationUnits)
}


#' Get indicator ID from indicator name
#'
#' @param metadata a list with the fingertips metadata
#' @param indicator_name the indicator name
#'
#' @return the indicator ID
#' @export
#'
get_indicatorID_from_indicatorName = function(metadata, indicator_name){
  checkmate::assert_list(metadata, any.missing = FALSE, len = 3, null.ok = FALSE)
  checkmate::assert_vector(indicator_name, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)

  indicator_name = unlist(strsplit(indicator_name,","))
  idx = which(metadata$indicator_ids_names$IndicatorName==indicator_name)
  if(length(idx)==0){
    subs = metadata$indicator_ids_names[grepl(tolower(indicator_name),
                                              tolower(metadata$indicator_ids_names$IndicatorName)),]
    if(nrow(subs)==0){
      R.utils::cat("\nCould not find specified indicator name.\n
             Below is the list of all indicator names in Fingertips.\n")
      print(metadata$indicator_ids_names)
      stop()
    }else{
      R.utils::cat("\nspecified indicator name not found but detected following similar indicator names:\n")
      print(subs)
    }
  }else{
    indicator_id = metadata$indicator_ids_names$IndicatorID[idx]
  }
  indicator_id
}


#' Get indicator ID from domain ID
#'
#' @param metadata a list with the fingertips metadata
#' @param domain_id the domain ID
#' @param indicator_name the indicator name
#'
#' @return the indicator ID
#' @export
#'
get_indicatorID_from_domainID = function(metadata, domain_id, indicator_name=NULL){
  checkmate::assert_list(metadata, any.missing = FALSE, len = 3, null.ok = FALSE)
  checkmate::assert_vector(indicator_name, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_vector(domain_id, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)

  idx = which(metadata$indicator_profile_domain$DomainID==domain_id)
  if(length(idx)==0){
    subs = metadata$indicator_profile_domain[grepl(domain_id,
                                                   metadata$indicator_profile_domain$DomainID),]
    if(nrow(subs)==0){
      R.utils::cat("\nCould not find specified domain ID.\n
             Below is the list of all domain IDs in Fingertips.\n")
      print(metadata$indicator_profile_domain %>% dplyr::select(c(DomainID,DomainName)))
      stop()
    }else{
      R.utils::cat("\nspecified domain ID not found but detected following similar domain IDs:\n")
      print(subs %>% dplyr::select(c(DomainID,DomainName)))
    }
  }else{
    if(!is.null(indicator_name)){
      indicator_name = unlist(strsplit(indicator_name,","))
      subs = metadata$indicator_profile_domain[idx,] %>%
        dplyr::filter(IndicatorName == indicator_name)
      indicator_id = subs$IndicatorID
    }else{
      indicator_id = metadata$indicator_profile_domain$IndicatorID[idx]
    }
  }
  indicator_id
}


#' Get indicator ID from domain name
#'
#' @param metadata a list with the fingertips metadata
#' @param domain_name the domain name
#' @param indicator_name the indicator name
#'
#' @return the indicator ID
#' @export
#'
get_indicatorID_from_domainName = function(metadata, domain_name, indicator_name=NULL){
  checkmate::assert_list(metadata, any.missing = FALSE, len = 3, null.ok = FALSE)
  checkmate::assert_vector(domain_name, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_vector(indicator_name, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)

  domain_name = unlist(strsplit(domain_name,","))
  idx = which(metadata$indicator_profile_domain$DomainName==domain_name)
  if(length(idx)==0){
    subs = metadata$indicator_profile_domain[grepl(domain_name,
                                                   metadata$indicator_profile_domain$DomainName),]
    if(nrow(subs)==0){
      R.utils::cat("\nCould not find specified domain name.\n
             Below is the list of all domain names in Fingertips.\n")
      print(metadata$indicator_profile_domain %>%
              dplyr::select(c(DomainID,DomainName)))
      stop()
    }else{
      R.utils::cat("\nspecified domain name not found but detected following similar domain names:\n")
      print(subs %>% dplyr::select(c(DomainID,DomainName)))
    }
  }else{
    if(!is.null(indicator_name)){
      indicator_name = unlist(strsplit(indicator_name,","))
      subs = metadata$indicator_profile_domain[idx,] %>%
        dplyr::filter(IndicatorName==indicator_name)
      indicator_id = subs$IndicatorID
    }else{
      indicator_id = metadata$indicator_profile_domain$IndicatorID[idx]
    }
  }
  indicator_id
}


#' Get indicator ID from profile ID and/or profile name
#'
#' @param metadata a list with the fingertips metadata
#' @param domain_id the domain ID
#' @param domain_name the domain name
#' @param indicator_name the indicator name
#' @param profile_name the profile name
#' @param profile_id the profile ID
#'
#' @return the indicator ID
#' @export
#'
get_indicatorID_from_profile = function(metadata, domain_id=NULL, domain_name=NULL,
                                        indicator_name=NULL,profile_name=NULL,
                                        profile_id=NULL){
  checkmate::assert_list(metadata, any.missing = FALSE, len = 3, null.ok = FALSE)
  checkmate::assert_vector(domain_id, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_vector(domain_name, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_vector(profile_id, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_vector(profile_name, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_vector(indicator_name, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)

  if(!is.null(profile_id) & !is.null(profile_name)){
    profile_name = unlist(strsplit(profile_name,","))
    idx = which(metadata$indicator_profile_domain$ProfileID==profile_id &
                  metadata$indicator_profile_domain$ProfileName == profile_name)
  }else if(!is.null(profile_id) & is.null(profile_name)){
    idx = which(metadata$indicator_profile_domain$ProfileID==profile_id)
  }else if(!is.null(profile_name) & is.null(profile_id)){
    profile_name = unlist(strsplit(profile_name,","))
    idx = which(metadata$indicator_profile_domain$ProfileName==profile_name)
  }

  if(length(idx)==0){
    if(!is.null(profile_id) & is.null(profile_name)){
      subs = metadata$indicator_profile_domain[grepl(profile_id,
                                                     metadata$indicator_profile_domain$ProfileID),]
    }else if(!is.null(profile_name) & is.null(profile_id)){
      subs = metadata$indicator_profile_domain[grepl(profile_name,
                                                     metadata$indicator_profile_domain$ProfileName),]
    }else if(!is.null(profile_id) & !is.null(profile_name)){
      subs = metadata$indicator_profile_domain[(grepl(profile_id,metadata$indicator_profile_domain$ProfileID) |
                                                  grepl(profile_name,metadata$indicator_profile_domain$ProfileName)),]
    }

    if(nrow(subs)==0){
      R.utils::cat("\nCould not find specified profile ID or name.\n
             Below is the list of all profile IDs and names in Fingertips.\n")
      print(metadata$indicator_profile_domain %>%
              dplyr::select(c(ProfileID,ProfileName)))
      stop()
    }else{
      R.utils::cat("\nspecified profile name or ID not found but detected following similar profile IDs or names:\n")
      print(subs %>% dplyr::select(c(ProfileID,ProfileName)))
    }
  }else{
    subs = metadata$indicator_profile_domain[idx,]
    if(!is.null(domain_id)){
      subs = subs %>% dplyr::filter(subs$DomainID==domain_id)
    }
    if(!is.null(domain_name)){
      domain_name = unlist(strsplit(domain_name,","))
      subs = subs %>% dplyr::filter(subs$DomainName==domain_name)
    }
    if(!is.null(indicator_name)){
      indicator_name = unlist(strsplit(indicator_name,","))
      subs = subs %>% dplyr::filter(subs$IndicatorName==indicator_name)
    }
    indicator_id = subs$IndicatorID
  }
  indicator_id
}


#' get fingertips metadata
#'
#' @return a list of data frames
#' @export
#'
get_fingertips_metadata = function(){
  list(
    indicator_profile_domain = fingertipsR::indicators(), #indicators, profiles, domains
    indicator_ids_names = fingertipsR::indicators_unique(), #indicators, ids, names
    area_type = fingertipsR::area_types() #area type ids, descriptions, mapping o parent area types
  )
}






