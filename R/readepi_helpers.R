#' Get file extension
#'
#' @param file_path the target file path
#'
#' @return a string that corresponds to the file extension
#' @export
#'
#' @examples ext <- get_extension(file_path = system.file("extdata", "test.txt",
#' package = "readepi"))
get_extension <- function(file_path) {
  splits <- unlist(strsplit(basename(file_path), ".", fixed = TRUE))
  extension <- splits[length(splits)]
  extension
}

get_base_name <- function(x) {
  ext <- get_extension(x)
  bn <- gsub(paste0(".", ext), "", basename(x))
  bn
}

detect_separator <- function(x) {
  special_characters <- c("\t", "|", ",", ";", " ") # look for other common sep
  sep <- NULL
  for (spec.char in special_characters) {
    if (stringr::str_detect(x, spec.char)) {
      sep <- c(sep, spec.char)
    }
  }
  unique(sep)
}


#' Title
#'
#' @param files_extensions a vector a file extensions made from your files of
#' interest
#' @param rio_extensions a vector of files extensions supported by the rio
#' package
#' @param files a vector a files of interest
#' @param files_base_names a vector of file base
#'
#' @return a list a the parameters needed to import data using rio
#'
read_rio_formats <- function(files_extensions, rio_extensions,
                            files, files_base_names) {
  idx <- which(files_extensions %in% rio_extensions)
  result <- list()
  if (length(idx) > 0) {
    tmp_files <- files[idx]
    tmp_bn <- files_base_names[idx]
    i <- 1
    for (file in tmp_files) {
      data <- rio::import(file) # , format = format, which = which
      result[[tmp_bn[i]]] <- data
      i <- i + 1
    }
    files <- files[-idx]
    files_base_names <- files_base_names[-idx]
    files_extensions <- files_extensions[-idx]
  }
  list(
    files = files,
    files_base_names = files_base_names,
    files_extensions = files_extensions,
    result = result
  )
}


#' Read multiple files, including multiple files in a directory
#'
#' @param files a file or vector of file path to import
#' @param dirs a directory or a vector of directories where files will be
#' imported from
#' @param format a string used to specify the file format. This is useful when a
#' file does not have an extension, or has a file extension that does not match
#' its actual type
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
  rio_extensions <- c(
    "csv", "psv", "tsv", "csvy", "sas7bdat", "sav", "zsav", "dta", "xpt",
    "por", "xls", "R", "RData", "rda", "rds", "rec", "mtp", "syd", "dbf",
    "arff", "dif", "no recognized extension", "fwf", "csv.gz", "parquet",
    "wf1", "feather", "fst", "json", "mat", "ods", "html", "xml", "yml"
  )

  # getting files extensions and basenames
  files_extensions <- as.character(lapply(files, get_extension))
  files_base_names <- as.character(lapply(files, get_base_name))

  # reading files with extensions that are taken care by rio
  tmp.res <- read_rio_formats(files_extensions, rio_extensions,
                             files, files_base_names)
  files <- tmp.res$files
  files_base_names <- tmp.res$files_base_names
  files_extensions <- tmp.res$files_extensions
  result <- tmp.res$result

  # reading files which extensions are not taken care by rio
  i <- 1
  for (file in files) {
    if (files_extensions[i] %in% c("xlsx", "xls")) {
      data <- readxl::read_xlsx(file)
      result[[files_base_names[i]]] <- data
      i <- i + 1
    } else {
      tmp_string <- readLines(con = file, n = 1)
      sep <- detect_separator(tmp_string)
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
      result[[files_base_names[i]]] <- data
      i <- i + 1
    }
  }
  result
}


#' Subset fields
#'
#' @param data_frame the input data frame
#' @param fields the list of columns of interest
#' @param table_name the table names
#' @examples
#' \dontrun{
#' data <- subset_fields(
#'   data_frame = data_frame,
#'   fields = "date,sex,age",
#'   table_name = "covid"
#' )
#' }
#' @returns a list of 2 elements: the subset data frame and an integer that
#' tells whether all fields were missing in the table (1) or not (0)
#' @importFrom magrittr %>%
#' @importFrom dplyr all_of
#' @export
subset_fields <- function(data_frame, fields, table_name) {
  checkmate::assert_data_frame(data_frame, null.ok = FALSE)
  checkmate::assertCharacter(table_name, len = 1L, null.ok = FALSE,
                             any.missing = FALSE)
  checkmate::assert_vector(fields,
    any.missing = FALSE, min.len = 1,
    null.ok = FALSE, unique = TRUE
  )
  not_found <- 0
  target_fields <- as.character(unlist(strsplit(fields, ",", fixed = TRUE)))
  target_fields <- as.character(lapply(target_fields, function(x) {
    gsub(" ", "", x, fixed = TRUE)
  }))
  idx <- which(target_fields %in% names(data_frame))
  if (length(idx) == 0) {
    message("\nThere is no column named as: ",
            glue::glue_collapse(target_fields, sep = ", "), " in ", table_name)
    not_found <- 1
  } else if (length(idx) != length(target_fields)) {
    message("\nThe following fields were not found in ", table_name, ": ",
            glue::glue_collapse(target_fields[-idx], sep = ", "))
    target_fields <- target_fields[idx]
    data <- data_frame %>% dplyr::select(all_of(target_fields))
  } else {
    data <- data_frame %>% dplyr::select(all_of(target_fields))
  }
  list(data = data, not_found = not_found)
}


#' Subset records
#' @param data_frame the input data frame
#' @param records the list of columns of interest
#' @param id_position a vector of the column position of the variable that
#' unique identifies the subjects. If not provided, it will assumes the first
#' column as the subject ID column in all the tables
#' @param table_name the table name
#' @returns a list of 2 elements: the subset data frame and an integer that
#' tells whether all fields were missing in the table (1) or not (0)
#' @importFrom magrittr %>%
#' @examples
#' \dontrun{
#' sub.data <- subset_records(data_frame, records, id_position = 1, table_name)
#' }
#' @export
subset_records <- function(data_frame, records, id_position = 1, table_name) {
  checkmate::assert_data_frame(data_frame, null.ok = FALSE)
  checkmate::assertCharacter(table_name, len = 1L, null.ok = FALSE,
                             any.missing = FALSE)
  checkmate::assert_vector(records,
    any.missing = FALSE, min.len = 1,
    null.ok = FALSE, unique = TRUE
  )
  checkmate::assert_number(id_position, lower = 1, null.ok = TRUE,
                           na.ok = FALSE)

  not_found <- 0
  records <- as.character(unlist(strsplit(records, ",", fixed = TRUE)))
  records <- as.character(lapply(records, function(x) {
    gsub(" ", "", x, fixed = TRUE)
  }))
  if (is.null(id_position)) {
    id_position <- 1
  }
  id_column_name <- names(data_frame)[id_position]
  if (is.numeric(data_frame[[id_column_name]])) {
    records <- as.numeric(records)
  }
  idx <- which(data_frame[[id_column_name]] %in% records)
  if (length(idx) == 0) {
    message("\nCould not find record named as: ",
            glue::glue_collapse(records, sep = ", "), " in column ",
            id_column_name, " of table ", table_name)
    not_found <- 1
  } else {
    data <- data_frame[idx, ]
  }
  list(data = data, not_found = not_found)
}


#' Read credentials from a configuration file
#'
#' @param file_path the path to the file with the user-specific credential
#' details for the projects of interest.
#' @param project_id for relational DB, this is the name of the database
#' that contains the table from which the data should be pulled. Otherwise,
#' it is the project ID you were given access to.
#' @returns  a list with the user credential details.
#' @examples
#' \dontrun{
#' credentials <- read_credentials(
#'   file_path = system.file("extdata", "test.ini", package = "readepi"),
#'   project_id = "TEST_READEPI"
#' )
#' }
#' @export
read_credentials <- function(file_path = system.file("extdata", "test.ini",
                                                     package = "readepi"),
                             project_id = NULL) {
  checkmate::assertCharacter(file_path, len = 1L, null.ok = FALSE)
  checkmate::assert_file_exists(file_path)
  checkmate::assertCharacter(project_id, len = 1L, null.ok = FALSE)
  if (!file.exists(file_path) || is.null(file_path)) {
    stop("Could not find ", file_path)
  }
  if (is.null(project_id)) {
    stop("Database name or project ID not specified!")
  }

  credentials <- data.table::fread(file_path, sep = "\t")
  if (ncol(credentials) != 7) {
    stop("credential file should be tab-separated file with 7 columns.")
  }
  if (!all((names(credentials) %in%
            c("user_name", "password", "host_name", "project_id", "comment",
              "dbms", "port")))) {
    stop("Incorrect column names found in provided credentials file.\nThe column
         names should be 'user_name', 'password', 'host_name', 'project_id',
         'comment', 'dbms', 'port'")
  }
  idx <- which(credentials$project_id == project_id)
  if (length(idx) == 0) {
    stop("Credential details for ", project_id, " not found in
         credential file.")
  } else if (length(idx) > 1) {
    stop("Multiple credential lines found for the specified project ID.\n
         Credentials file should contain one line per project.")
  } else {
    project_credentials <- list(
      user = credentials$user_name[idx],
      pwd = credentials$password[idx],
      host = credentials$host_name[idx],
      project = credentials$project_id[idx],
      dbms = credentials$dbms[idx],
      port = credentials$port[idx]
    )
  }
  project_credentials
}


#' Check DHIS2 authentication details
#'
#' @param username the user name
#' @param password the user's password
#' @param base_url the base URL of the DHIS2 server
#'
login <- function(username, password, base_url) {
  checkmate::assertCharacter(base_url, len = 1L, null.ok = FALSE,
                             any.missing = FALSE)
  checkmate::assertCharacter(username, len = 1L, null.ok = FALSE,
                             any.missing = FALSE)
  checkmate::assertCharacter(password, len = 1L, null.ok = FALSE,
                             any.missing = FALSE)

  url <- paste0(base_url, "/", "api/me")
  resp <- httr::GET(url, httr::authenticate(username, password))
  httr::stop_for_status(resp)
  R.utils::cat("\nLogged in successfully!")
}

#' Get the data element identifiers and names
#'
#' @param username the user name
#' @param password the user's password
#' @param base_url the base URL of the DHIS2 server
#'
#' @export
#'
get_data_elements <- function(base_url, username, password) {
  checkmate::assertCharacter(base_url, len = 1L, null.ok = TRUE,
                             any.missing = FALSE)
  checkmate::assertCharacter(username, len = 1L, null.ok = TRUE,
                             any.missing = FALSE)
  checkmate::assertCharacter(password, len = 1L, null.ok = TRUE,
                             any.missing = FALSE)

  url <- paste0(base_url,
                "/api/dataElements?fields=id,name,shortName&paging=false")
  r <- httr::content(httr::GET(url, httr::authenticate(username, password)),
                     as = "parsed")
  do.call(rbind.data.frame, r$dataElements)
}

#' Get the dataset identifiers and names
#'
#' @param username the user name
#' @param password the user's password
#' @param base_url the base URL of the DHIS2 server
#'
#' @export
#'
get_data_sets <- function(base_url, username, password) {
  checkmate::assertCharacter(base_url, len = 1L, null.ok = FALSE,
                             any.missing = FALSE)
  checkmate::assertCharacter(username, len = 1L, null.ok = FALSE,
                             any.missing = FALSE)
  checkmate::assertCharacter(password, len = 1L, null.ok = FALSE,
                             any.missing = FALSE)

  url <- paste0(base_url, "/api/dataSets?fields=id,name,shortName&paging=false")
  r <- httr::content(httr::GET(url, httr::authenticate(username, password)),
                     as = "parsed")
  do.call(rbind.data.frame, r$dataSets)
}

#' Get the organisation unit identifiers and names
#'
#' @param username the user name
#' @param password the user's password
#' @param base_url the base URL of the DHIS2 server
#'
#' @export
#'
get_organisation_units <- function(base_url, username, password) {
  checkmate::assertCharacter(base_url, len = 1L, null.ok = FALSE,
                             any.missing = FALSE)
  checkmate::assertCharacter(username, len = 1L, null.ok = FALSE,
                             any.missing = FALSE)
  checkmate::assertCharacter(password, len = 1L, null.ok = FALSE,
                             any.missing = FALSE)

  url <- paste0(base_url,
                "/api/organisationUnits?fields=id,name,shortName&paging=false")
  r <- httr::content(httr::GET(url, httr::authenticate(username, password)),
                     as = "parsed")
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
get_ind_id_from_ind_name <- function(metadata, indicator_name) {
  checkmate::assert_list(metadata, any.missing = FALSE, len = 3,
                         null.ok = FALSE)
  checkmate::assert_vector(indicator_name,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = TRUE
  )

  indicator_name <- unlist(strsplit(indicator_name, ",", fixed = TRUE))
  idx <- which(metadata$indicator_ids_names$IndicatorName == indicator_name)
  if (length(idx) == 0) {
    subs <- metadata$indicator_ids_names[grepl(
      tolower(indicator_name),
      tolower(metadata$indicator_ids_names$IndicatorName)
    ), ]
    if (nrow(subs) == 0) {
      R.utils::cat("\nCould not find specified indicator name.\n
             Below is the list of all indicator names in Fingertips.\n")
      print(metadata$indicator_ids_names)
      stop()
    } else {
      R.utils::cat("\nspecified indicator name not found but detected following
                   similar indicator names:\n")
      print(subs)
    }
  } else {
    indicator_id <- metadata$indicator_ids_names$IndicatorID[idx]
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
get_ind_id_from_domain_id <- function(metadata, domain_id,
                                          indicator_name = NULL) {
  checkmate::assert_list(metadata, any.missing = FALSE, len = 3,
                         null.ok = FALSE)
  checkmate::assert_vector(indicator_name,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(domain_id,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = TRUE
  )

  idx <- which(metadata$indicator_profile_domain$DomainID == domain_id)
  if (length(idx) == 0) {
    subs <- metadata$indicator_profile_domain[grepl(
      domain_id,
      metadata$indicator_profile_domain$DomainID
    ), ]
    if (nrow(subs) == 0) {
      R.utils::cat("\nCould not find specified domain ID.\n
             Below is the list of all domain IDs in Fingertips.\n")
      print(metadata$indicator_profile_domain[, c("DomainID", "DomainName")])
      stop()
    } else {
      R.utils::cat("\nspecified domain ID not found but detected following
                   similar domain IDs:\n")
      print(subs[, c("DomainID", "DomainName")])
    }
  } else {
    if (!is.null(indicator_name)) {
      indicator_name <- unlist(strsplit(indicator_name, ",", fixed = TRUE))
      subs <- metadata$indicator_profile_domain[idx, ]
      subs <- subs[which(subs$IndicatorName %in% indicator_name), ]
      indicator_id <- subs$IndicatorID
    } else {
      indicator_id <- metadata$indicator_profile_domain$IndicatorID[idx]
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
get_ind_id_from_domain_name <- function(metadata, domain_name,
                                            indicator_name = NULL) {
  checkmate::assert_list(metadata, any.missing = FALSE, len = 3,
                         null.ok = FALSE)
  checkmate::assert_vector(domain_name,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(indicator_name,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = TRUE
  )

  domain_name <- unlist(strsplit(domain_name, ",", fixed = TRUE))
  idx <- which(metadata$indicator_profile_domain$DomainName == domain_name)
  if (length(idx) == 0) {
    subs <- metadata$indicator_profile_domain[grepl(
      domain_name,
      metadata$indicator_profile_domain$DomainName
    ), ]
    if (nrow(subs) == 0) {
      R.utils::cat("\nCould not find specified domain name.\n
             Below is the list of all domain names in Fingertips.\n")
      print(metadata$indicator_profile_domain[, c("DomainID", "DomainName")])
      stop()
    } else {
      R.utils::cat("\nspecified domain name not found but detected following
                   similar domain names:\n")
      print(subs[, c("DomainID", "DomainName")])
    }
  } else {
    if (!is.null(indicator_name)) {
      indicator_name <- unlist(strsplit(indicator_name, ",", fixed = TRUE))
      subs <- metadata$indicator_profile_domain[idx, ]
      subs <- subs[which(subs$IndicatorName %in% indicator_name)]
      indicator_id <- subs$IndicatorID
    } else {
      indicator_id <- metadata$indicator_profile_domain$IndicatorID[idx]
    }
  }
  indicator_id
}


#' Get profile name from Fingertips
#'
#' @param profile_id the profile ID
#' @param profile_name the profile name
#' @param metadata the Fingertips metadata
#'
#' @return a list with the profile name and their correspondent indexes
#'
get_profile_name <- function(profile_id, profile_name, metadata) {
  if (all(!is.null(profile_id) & !is.null(profile_name))) {
    profile_name <- unlist(strsplit(profile_name, ",", fixed = TRUE))
    idx <- which(metadata$indicator_profile_domain$ProfileID == profile_id &
                metadata$indicator_profile_domain$ProfileName == profile_name)
  } else if (!is.null(profile_id) && is.null(profile_name)) {
    idx <- which(metadata$indicator_profile_domain$ProfileID == profile_id)
  } else if (!is.null(profile_name) && is.null(profile_id)) {
    profile_name <- unlist(strsplit(profile_name, ",", fixed = TRUE))
    idx <- which(metadata$indicator_profile_domain$ProfileName == profile_name)
  }

  list(
    profile_name,
    idx
  )

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
get_ind_id_from_profile <- function(metadata, domain_id = NULL,
                                         domain_name = NULL,
                                         indicator_name = NULL,
                                         profile_name = NULL,
                                         profile_id = NULL) {
  checkmate::assert_list(metadata, any.missing = FALSE, len = 3,
                         null.ok = FALSE)
  checkmate::assert_vector(domain_id,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(domain_name,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(profile_id,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(profile_name,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(indicator_name,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = TRUE
  )

  tmp_res <- get_profile_name(profile_id, profile_name, metadata)
  profile_name <- tmp_res[[1]]
  idx <- tmp_res[[2]]

  if (length(idx) == 0) {
    if (!is.null(profile_id) && is.null(profile_name)) {
      subs <- metadata$indicator_profile_domain[grepl(
        profile_id,
        metadata$indicator_profile_domain$ProfileID
      ), ]
    } else if (!is.null(profile_name) && is.null(profile_id)) {
      subs <- metadata$indicator_profile_domain[grepl(
        profile_name,
        metadata$indicator_profile_domain$ProfileName
      ), ]
    } else if (all(!is.null(profile_id) & !is.null(profile_name))) {
      subs <- metadata$indicator_profile_domain[(
        grepl(profile_id, metadata$indicator_profile_domain$ProfileID) |
        grepl(profile_name, metadata$indicator_profile_domain$ProfileName)), ]
    }

    if (nrow(subs) == 0) {
      R.utils::cat("\nCould not find specified profile ID or name.\n
             Below is the list of all profile IDs and names in Fingertips.\n")
      print(metadata$indicator_profile_domain[, c("ProfileID", "ProfileName")])
      stop()
    } else {
      R.utils::cat("\nspecified profile name or ID not found but detected
                   following similar profile IDs or names:\n")
      print(subs[, c("ProfileID", "ProfileName")])
    }
  } else {
    subs <- metadata$indicator_profile_domain[idx, ]
    if (!is.null(domain_id)) {
      subs <- subs %>% dplyr::filter(subs$DomainID == domain_id)
    }
    if (!is.null(domain_name)) {
      domain_name <- unlist(strsplit(domain_name, ",", fixed = TRUE))
      subs <- subs %>% dplyr::filter(subs$DomainName == domain_name)
    }
    if (!is.null(indicator_name)) {
      indicator_name <- unlist(strsplit(indicator_name, ",", fixed = TRUE))
      subs <- subs %>% dplyr::filter(subs$IndicatorName == indicator_name)
    }
    indicator_id <- subs$IndicatorID
  }
  indicator_id
}


#' get fingertips metadata
#'
#' @return a list of data frames
#' @export
#'
get_fingertips_metadata <- function() {
  list(
    indicator_profile_domain =
      fingertipsR::indicators(), # indicators, profiles, domains
    indicator_ids_names =
      fingertipsR::indicators_unique(), # indicators, ids, names
    area_type =
      fingertipsR::area_types() # area type ids, descriptions,
    #mapping of parent area types
  )
}


#' Sub-function for reading file in a directory
#'
#' @param file_path the path to the file to be read
#' @param pattern when specified, only files with this suffix will be imported
#'
#' @return a list of data frames where each contains data read from a file
#'
read_files_in_directory <- function(file_path, pattern) {
  result <- NULL
  if (length(list.files(file_path, full.names = TRUE,
                       recursive = FALSE)) == 0) {
    stop("Could not find any file in ", file_path)
  }

  if (!is.null(pattern)) {
    for (pat in pattern) {
      files <- list.files(file_path,
                          full.names = TRUE, pattern = pat,
                          recursive = FALSE
      )
      dirs <- list.dirs(file_path, full.names = TRUE, recursive = FALSE)
      res <- read_multiple_files(files, dirs)
      result <- c(result, res)
    }
  } else {
    files <- list.files(file_path, full.names = TRUE, recursive = FALSE)
    dirs <- list.dirs(file_path, full.names = TRUE, recursive = FALSE)
    result <- read_multiple_files(files, dirs)
  }

  result
}


#' Sub-function for reading files using rio package
#'
#' @param sep the separator between the columns in the file
#' @param file_path the path to the file to be read
#' @param which a string used to specify the name of the excel sheet to import
#' @param format a string used to specify the file format
#'
#' @return a list of data frames where each contains data from a file
#'
read_files <- function(sep, file_path, which, format) {
  result <- NULL
  if (!is.null(sep)) {
    result[[1]] <- data.table::fread(file_path, sep = sep)
  } else if (is.null(sep)) {
    if (all(!is.null(which) & !is.null(format))) {
      for (wh in which) {
        data <- rio::import(file_path, format = format, which = wh)
        result[[wh]] <- data
      }
    } else if (!is.null(which) && is.null(format)) {
      for (wh in which) {
        data <- rio::import(file_path, which = wh)
        result[[wh]] <- data
      }
    } else if (!is.null(format) && is.null(which)) {
      result[[1]] <- rio::import(file_path, format = format)
    } else {
      result[[1]] <- rio::import(file_path)
    }
  }

  result
}


#' Subset records when reading from Fingertips
#'
#' @param records a vector or a comma-separated string of records
#' @param id_col_name the column name with the subject IDs
#' @param data the data read from Fingertips
#'
#' @return a data frame with the records of interest
#'
fingertips_subset_rows <- function(records, id_col_name, data) {
  if (!is.null(records)) {
    records <- unlist(strsplit(records, ",", fixed = TRUE))
    records <- gsub(" ", "", records, fixed = TRUE)
    if (all(records %in% data[[id_col_name]])) {
      data <- data[which(data[[id_col_name]] %in% records), ]
    } else {
      idx <- which(records %in% data[[id_col_name]])
      warning("\n", length(records[-idx]), " records were not found in
              the data.")
      data <- data[which(data[[id_col_name]] %in% records[idx]), ]
    }
  }
  data
}


#' Subset columns when reading from Fingertips
#'
#' @param fields a vector or a comma-separated string of column names
#' @param id_position the column position of the variable that unique identifies
#' the subjects
#' @param data the data read from Fingertips
#' @param id_col_name the column name with the subject IDs
#'
#' @return a data frame with the columns of interest
#'
fingertips_subset_columns <- function(fields, id_position, data, id_col_name) {
  if (!is.null(fields)) {
    if (is.null(id_position)) id_position <- 1
    id_col_name <- ifelse(!is.null(id_col_name), id_col_name,
                          names(data)[id_position]
    )
    fields <- unlist(strsplit(fields, ",", fixed = TRUE))
    fields <- gsub(" ", "", fields, fixed = TRUE)
    idx <- which(fields %in% names(data))
    if (length(idx) == 0) {
      stop("\nCould not find specified fields. The field names in the dataset
           are:\n", print(names(data)))
    } else if (length(idx) != length(fields)) {
      warning("\nCould not find the following fields:\n", print(fields[-idx]))
    } else {
      data <- data %>% dplyr::select(dplyr::all_of(fields[idx]))
    }
  }
  data
}

#' Read all rows and columns from redcap
#'
#' @param uri the URI of the REDCap project
#' @param token the user-specific string that serves as the password for a
#' project
#' @param id_position the column position of the variable that unique identifies
#' the subjects
#'
#' @return a list with the project data and its associated metadata
#'
redcap_read <- function(uri, token, id_position) {
  redcap_data <- REDCapR::redcap_read(
    redcap_uri = uri, token = token, records = NULL,
    fields = NULL, verbose = FALSE,
    id_position = as.integer(id_position)
  )
  metadata <- REDCapR::redcap_metadata_read(
    redcap_uri = uri, token = token,
    fields = NULL, verbose = FALSE
  )
  list(redcap_data, metadata)
}


#' Subset records and columns from a REDCap project
#'
#' @param fields a vector or a comma-separated string of column names
#' @param uri the URI of the REDCap project
#' @param token the user-specific string that serves as the password for a
#' project
#' @param id_position the column position of the variable that unique identifies
#' the subjects
#' @param id_col_name the column name with the subject IDs
#' @param records a vector or a comma-separated string of subset of subject IDs
#'
#' @return a list with the project data and its associated metadata with the
#' fields and records of interest
#'
redcap_read_rows_columns <- function(fields, uri, token, id_position,
                                    id_col_name, records) {
  if (is.vector(fields)) {
    fields <- glue::glue_collapse(fields, sep = ", ")
  }
  redcap_data <- REDCapR::redcap_read(
    redcap_uri = uri, token = token,
    id_position = as.integer(id_position),
    fields_collapsed = fields, verbose = FALSE
  )
  metadata <- REDCapR::redcap_metadata_read(
    redcap_uri = uri, token = token,
    verbose = FALSE
  )
  if (!is.null(id_col_name)) {
    if (!(id_col_name %in% names(redcap_data$data))) {
      stop("Specified ID column name not found!")
    }
    id_column_name <- id_col_name
    id_position <- which(names(redcap_data$data) == id_column_name)
  } else {
    id_column_name <- names(redcap_data$data)[id_position]
  }
  if (is.character(records)) {
    records <- gsub(" ", "", records, fixed = TRUE)
    records <- as.character(unlist(strsplit(records, ",", fixed = TRUE)))
  }
  if (is.numeric(redcap_data$data[[id_column_name]])) {
    records <- as.numeric(records)
  }
  redcap_data$data <-
    redcap_data$data[which(redcap_data$data[[id_column_name]] %in% records), ]
  list(redcap_data, metadata)
}


#' Subset fields from a REDCap project
#'
#' @param fields a vector or a comma-separated string of column names
#' @param uri the URI of the REDCap project
#' @param token the user-specific string that serves as the password for a
#' project
#' @param id_position the column position of the variable that unique identifies
#' the subjects
#'
#' @return a list with the project data and its associated metadata with the
#' fields of interest
#'
redcap_read_fields <- function(fields, uri, token, id_position) {
  if (is.vector(fields)) {
    fields <- glue::glue_collapse(fields, sep = ", ")
  }
  redcap_data <- REDCapR::redcap_read(
    redcap_uri = uri, token = token,
    id_position = as.integer(id_position),
    fields_collapsed = fields, verbose = FALSE
  )
  metadata <- REDCapR::redcap_metadata_read(
    redcap_uri = uri, token = token,
    verbose = FALSE
  )
  list(redcap_data, metadata)
}


#' Subset records from a REDCap project
#'
#' @param records a vector or a comma-separated string of subset of subject IDs
#' @param uri the URI of the REDCap project
#' @param token the user-specific string that serves as the password for a
#' project
#' @param id_position the column position of the variable that unique identifies
#' the subjects
#' @param id_col_name the column name with the subject IDs
#'
#' @return a list with the project data and its associated metadata with the
#' records of interest
#'
redcap_read_records <- function(records, uri, token, id_position, id_col_name) {
  if (is.vector(records)) {
    records <- glue::glue_collapse(records, sep = ", ")
  }
  redcap_data <- REDCapR::redcap_read(
    redcap_uri = uri, token = token, records = NULL,
    fields = NULL, verbose = FALSE,
    id_position = as.integer(id_position)
  )
  if (!is.null(id_col_name)) {
    if (!(id_col_name %in% names(redcap_data$data))) {
      stop("Specified ID column name not found!")
    }
    id_column_name <- id_col_name
    id_position <- which(names(redcap_data$data) == id_column_name)
  } else {
    id_column_name <- names(redcap_data$data)[id_position]
  }
  redcap_data <- REDCapR::redcap_read(
    redcap_uri = uri, token = token,
    id_position = as.integer(id_position),
    records_collapsed = records, verbose = FALSE
  )
  metadata <- REDCapR::redcap_metadata_read(
    redcap_uri = uri, token = token,
    verbose = FALSE
  )
  list(redcap_data, metadata)
}


#' Fetch data from several files
#'
#' @param table_names a vector of table names
#' @param con the established connection to the database
#' @param fields a vector or a comma-separated string of column names
#' @param result a list of data from the table name
#'
#' @return a list of data from the tables of interest
#'
fetch_from_several_tables <- function(table_names, con, fields, result) {
  j <- 1
  not_found <- 0
  for (table in table_names) {
    sql <- DBI::dbSendQuery(con, paste0("select * from ", table))
    res <- DBI::dbFetch(sql, -1)
    DBI::dbClearResult(sql)
    if (!is.na(fields[j])) {
      subset_data <- subset_fields(res, fields[j], table)
      result[[table]] <- subset_data$data
      not_found <- not_found + subset_data$not_found
      j <- j + 1
    } else {
      result[[table]] <- res
      j <- j + 1
    }
  }
  if (not_found == length(table_names)) {
    stop("Specified fields not found in the tables of interest!")
  }

  result
}


#' Subset data from several tables
#'
#' @param result a list of data from the table name
#' @param records a vector or a comma-separated string of subset of subject IDs
#' @param id_col_name the column name with the subject IDs
#' @param table_names a vector of table names
#'
#' @return a list of data from the tables of interest with the records and
#' fields of interest
#'
subset_from_several_tables <- function(result, records,
                                      id_col_name, table_names) {
  j <- 1
  not_found <- 0
  for (table in names(result)) {
    if (!is.na(records[j])) {
      id_pos <- ifelse(!is.na(id_col_name[j]),
                       which(names(result[[table]]) == id_col_name[j]),
                       which(names(result[[table]]) == id_col_name[1])
      )
      res <- subset_records(result[[table]], records[j], id_pos, table)
      result[[table]] <- res$data
      not_found <- not_found + res$not_found
      j <- j + 1
    }
  }
  if (not_found == length(table_names)) {
    stop("Specified records not found in the tables of interest!")
  }

  result
}


#' Check if tables of interest are part of the tables in the database
#'
#' @param table_names a vector of table names of interest
#' @param tables the list of all tables in the database
#' @param database_name the database name
#'
#' @return the list of tables of interest that are part of the database
#'
select_existing_tables <- function(table_names, tables, database_name) {
  if (is.character(table_names)) {
    table_names <- gsub(" ", "", table_names, fixed = TRUE)
    table_names <- as.character(unlist(strsplit(table_names, ",",
                                                fixed = TRUE)))
  }
  idx <- which(table_names %in% tables)
  if (length(idx) == 0) {
    message("Could not find tables called ",
            glue::glue_collapse(table_names, sep = ", "), " in ",
            database_name, "!\n")
    R.utils::cat("\nBelow is the list of all tables in the specified
                 database:\n")
    print(tables)
    stop()
  } else if (length(idx) != length(table_names)) {
    message("The following tables are not available in the database: ",
            glue::glue_collapse(table_names[-idx], sep = ", "))
  }
  table_names <- table_names[idx]
  table_names
}


#' Get arguments for reading from files
#'
#' @param args_list a list of user specified arguments
#'
#' @return a list of the parameters to be used for reading from file
#'
get_read_file_args <- function(args_list) {
  if ("sep" %in% names(args_list)) {
    sep <- args_list$sep
  } else {
    sep <- NULL
  }
  if ("format" %in% names(args_list)) {
    format <- args_list$format
  } else {
    format <- NULL
  }
  if ("which" %in% names(args_list)) {
    which <- args_list$which
  } else {
    which <- NULL
  }
  if ("pattern" %in% names(args_list)) {
    pattern <- args_list$pattern
  } else {
    pattern <- NULL
  }

  list(
    sep = sep,
    format = format,
    which = which,
    pattern = pattern
    )
}


#' Get arguments for reading from Fingertips
#'
#' @param args_list a list of user specified arguments
#'
#' @return a list of the parameters to be used for reading from Fingertips
#'
get_read_fingertips_args <- function(args_list) {
  if ("indicator_id" %in% names(args_list)) {
    indicator_id <- args_list$indicator_id
  } else {
    indicator_id <- NULL
  }
  if ("indicator_name" %in% names(args_list)) {
    indicator_name <- args_list$indicator_name
  } else {
    indicator_name <- NULL
  }
  if ("area_type_id" %in% names(args_list)) {
    area_type_id <- args_list$area_type_id
  } else {
    area_type_id <- NULL
  }
  if ("profile_id" %in% names(args_list)) {
    profile_id <- args_list$profile_id
  } else {
    profile_id <- NULL
  }
  if ("profile_name" %in% names(args_list)) {
    profile_name <- args_list$profile_name
  } else {
    profile_name <- NULL
  }
  if ("domain_id" %in% names(args_list)) {
    domain_id <- args_list$domain_id
  } else {
    domain_id <- NULL
  }
  if ("domain_name" %in% names(args_list)) {
    domain_name <- args_list$domain_name
  } else {
    domain_name <- NULL
  }
  if ("parent_area_type_id" %in% names(args_list)) {
    parent_area_type_id <- args_list$parent_area_type_id
  } else {
    parent_area_type_id <- NULL
  }

  list(
    indicator_id = indicator_id,
    indicator_name = indicator_name,
    area_type_id = area_type_id,
    profile_id = profile_id,
    profile_name = profile_name,
    domain_id = domain_id,
    domain_name = domain_name,
    parent_area_type_id = parent_area_type_id
  )
}


#' Get the relevant dataset
#'
#' @param dataset the dataSets identifiers
#' @param base_url the web address of the server the user wishes to log in to
#' @param username the user name
#' @param password the user's password
#'
#' @return a list with the relevant datasets
#'
get_relevant_dataset <- function(dataset, base_url, username, password) {
  if (!is.null(dataset)) {
    if (is.character(dataset)) dataset <- unlist(strsplit(dataset, ",",
                                                          fixed = TRUE))
    data_sets <- get_data_sets(base_url, username, password)
    idx <- which(dataset %in% data_sets$id)
    if (length(idx) == 0) {
      stop("Provided dataSets not found!\n
        Use get_data_sets() function to view the list of available dataSets.")
    }
    if (length(idx) < length(dataset)) {
      warning("\nThe following dataSets were not found: ",
              glue::glue_collapse(dataset[-idx], sep = ", "))
    }
    dataset <- paste(dataset[idx], collapse = ",")
  }

  list(
    dataset,
    data_sets
  )
}


#' Get the relevant organisation units
#'
#' @param organisation_unit the organisationUnits identifiers
#' @param base_url the web address of the server the user wishes to log in to
#' @param username the user name
#' @param password the user's password
#'
#' @return a list with the relevant organisation units
#'
get_relevant_organisation_unit <- function(organisation_unit, base_url,
                                           username, password) {
  if (!is.null(organisation_unit)) {
    if (is.character(organisation_unit)) organisation_unit <-
        unlist(strsplit(organisation_unit, ",", fixed = TRUE))
    org_units <- get_organisation_units(base_url, username, password)
    idx <- which(organisation_unit %in% org_units$id)
    if (length(idx) == 0) {
      stop("Provided organisationUnites not found!\n
           Use get_organisation_units() function to view the list of available
           dataSets.")
    }
    if (length(idx) < length(organisation_unit)) {
      warning("\nThe following organisationUnite were not found: ",
              glue::glue_collapse(organisation_unit[-idx], sep = ", "))
    }
    organisation_unit <- paste(organisation_unit[idx], collapse = ",")
  }

  list(
    organisation_unit,
    org_units
  )
}


#' Get the relevant data element groups
#'
#' @param data_element_group the dataElementGroups identifiers
#' @param base_url the web address of the server the user wishes to log in to
#' @param username the user name
#' @param password the user's password
#'
#' @return a list with the data elements of interest
#'
get_relevant_data_elt_group <- function(data_element_group, base_url,
                                            username, password) {
  data_elt_groups <- NULL
  if (!is.null(data_element_group)) {
    if (is.character(data_element_group)) data_element_group <-
        unlist(strsplit(data_element_group, ",", fixed = TRUE))
    data_elt_groups <- get_organisation_units(base_url, username, password)
    idx <- which(data_element_group %in% data_elt_groups$id)
    if (length(idx) == 0) {
      stop("Provided dataElementGroups not found!\n
           Use get_organisation_units() function to view the list of available
           dataSets.")
    }
    if (length(idx) < length(data_element_group)) {
      warning("\nThe following dataElementGroups were not found: ",
              glue::glue_collapse(data_element_group[-idx], sep = ", "))
    }
    data_element_group <- paste(data_element_group[idx], collapse = ",")
  }

  list(
    data_element_group,
    data_elt_groups
  )
}


#' Import data from REDCap under all scenari
#'
#' @description This is a wrapper across all the use case of reading data from
#' REDCap i.e. around the function that all records and fields from the project,
#' around the function that read specific records/fields or both at the same
#' time
#'
#' @param records a vector or a comma-separated string of subset of subject IDs
#' @param fields a vector or a comma-separated string of column names
#' @param uri the URI of the server
#' @param token the user-specific string that serves as the password for a
#' project
#' @param id_position the column position of the variable that unique identifies
#' the subjects
#' @param id_col_name the column name with the subject IDs
#'
#' @return a list with the data of interest and its associated metadata
#'
import_redcap_data <- function(records, fields, uri, token,
                              id_position, id_col_name) {
  if (all(is.null(records) & is.null(fields))) {
    res <- redcap_read(uri, token, id_position)
    redcap_data <- res[[1]]
    metadata <- res[[2]]
  }

  if (all(!is.null(records) & !is.null(fields))) {
    res <- redcap_read_rows_columns(fields, uri, token, id_position,
                                    id_col_name, records)
    redcap_data <- res[[1]]
    metadata <- res[[2]]
  }

  if (!is.null(fields) && is.null(records)) {
    res <- redcap_read_fields(fields, uri, token, id_position)
    redcap_data <- res[[1]]
    metadata <- res[[2]]
  }

  if (!is.null(records) && is.null(fields)) {
    res <- redcap_read_records(records, uri, token,
                               id_position, id_col_name)
    redcap_data <- res[[1]]
    metadata <- res[[2]]
  }

  list(
    redcap_data,
    metadata
  )
}


#' Subset fields when reading from DHIS2
#'
#' @param fields vector of fields to select from the data frame
#' @param data the input data frame
#'
#' @return the data frame with the fields of interest
#'
dhis2_subset_fields <- function(fields, data) {
  if (!is.null(fields)) {
    if (is.character(fields)) fields <- unlist(strsplit(fields, ",",
                                                        fixed = TRUE))
    idx <- which(fields %in% names(data))
    if (length(idx) == 0) stop("Specified column not not!\nThe data contains the
                               following column:\n", names(data))
    if (length(idx) != length(fields)) {
      warning("The following fields were not found in the data: ", fields[-idx])
      fields <- fields[idx]
    }
    data <- data %>% dplyr::select(dplyr::all_of(fields))
  }

  data
}


#' Title
#'
#' @param records a vector of records to select from the data
#' @param id_col_name the column name where the records belong to
#' @param data the input data frame
#'
#' @return a data frame with the records of interest
#'
dhis2_subset_records <- function(records, id_col_name, data) {
  if (!is.null(records)) {
    if (is.character(records)) records <- unlist(strsplit(records, ",",
                                                          fixed = TRUE))
    id_column_name <- id_col_name
    idx <- which(records %in% data[[id_column_name]])
    if (length(idx) == 0) {
      stop("Speficied records not found in column: ", id_column_name)
    } else if (length(idx) < length(records)) {
      warning("The following records were not found: ", records[-idx])
      records <- records[idx]
    }
    data <- data[which(data[[id_column_name]] %in% records), ]
  }

  data
}


#' Check and return data fetch from redcap
#'
#' @param redcap_data the object with redcap data
#' @param metadata the object with redcap metadata
#'
#' @return a list with the redcap dataset and its associated metadata as
#' data frames
redcap_get_results <- function(redcap_data, metadata) {
  if (all(redcap_data$success & metadata$success)) {
    data <- redcap_data$data
    meta <- metadata$data
  } else if (redcap_data$success && !metadata$success) {
    warning("\nNote that the metadata was not imported.")
    data <- redcap_data$data
    meta <- NULL
  } else {
    stop("Error in reading from REDCap. Please check your credentials or
         project ID.")
  }

  list(
    data,
    meta
  )
}
