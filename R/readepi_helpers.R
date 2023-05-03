#' Get file extension
#'
#' @param file_path the target file path
#'
#' @return a string that corresponds to the file extension
#' @export
#'
#' @examples
#' ext <- get_extension(
#' file_path = system.file("extdata", "test.txt", package = "readepi")
#' )
get_extension <- function(file_path) {
  checkmate::assert_character(file_path, any.missing = FALSE, null.ok = FALSE,
                              len = 1)
  checkmate::assert_file_exists(file_path)
  splits <- unlist(strsplit(basename(file_path), ".", fixed = TRUE))
  extension <- splits[length(splits)]
  extension
}

#' Get file base name
#'
#' @param x the file path
#'
#' @return the file base name
#'
#' @examples
#' base_name <- get_base_name(
#' x = system.file("extdata", "test.txt", package = "readepi")
#' )
get_base_name <- function(x) {
  checkmate::assert_character(x, any.missing = FALSE, null.ok = FALSE,
                              len = 1)
  ext <- get_extension(x)
  bn <- gsub(paste0(".", ext), "", basename(x))
  bn
}

#' Detect separator from a string
#'
#' @param x a string
#'
#' @return a vector of identified separators
#' @export
#'
#' @examples
#' sep <- detect_separator(
#' x = "My name is Karim"
#' )
detect_separator <- function(x) {
  checkmate::assert_character(x, any.missing = FALSE, null.ok = FALSE)
  special_characters <- c("\t", "|", ",", ";", " ")
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
  checkmate::assert_vector(files_extensions, any.missing = FALSE,
                           null.ok = FALSE, min.len = 1)
  checkmate::assert_vector(rio_extensions, any.missing = FALSE,
                           null.ok = FALSE, min.len = 1)
  checkmate::assert_vector(files, any.missing = FALSE,
                           null.ok = FALSE, min.len = 1)
  checkmate::assert_vector(files_base_names, any.missing = FALSE,
                           null.ok = FALSE, min.len = 1)
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
  checkmate::assert_vector(files, any.missing = FALSE,
                           null.ok = FALSE, min.len = 1)
  checkmate::assert_vector(dirs, any.missing = FALSE,
                           null.ok = FALSE, min.len = 1)
  checkmate::assert_character(format, null.ok = TRUE, any.missing = FALSE)
  checkmate::assert_vector(which, any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE)
  result <- NULL
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
  if (length(files_extensions) > 0) {
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
  }

  result
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

  url <- file.path(base_url, "api", "me")
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
  checkmate::assert_vector(profile_id,
                           any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(profile_name,
                           any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(metadata,
                           any.missing = FALSE,
                           null.ok = FALSE
  )
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
  checkmate::assert_character(pattern, null.ok = TRUE, min.len = 1,
                              any.missing = FALSE)
  checkmate::assert_character(file_path, null.ok = FALSE, len = 1,
                              any.missing = FALSE)
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
      if (length(files) == 0) {
        next
      }
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
  checkmate::assert_character(sep, null.ok = TRUE, len = 1, any.missing = FALSE)
  checkmate::assert_character(format, null.ok = TRUE, any.missing = FALSE)
  checkmate::assert_vector(which, any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_character(file_path, null.ok = FALSE, len = 1,
                              any.missing = FALSE)
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
  checkmate::assert_data_frame(data, null.ok = FALSE)
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
#' @param data the data read from Fingertips
#'
#' @return a data frame with the columns of interest
#'

fingertips_subset_columns <- function(fields, data) {
  checkmate::assert_data_frame(data, null.ok = FALSE)
  if (!is.null(fields)) {
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
  checkmate::assert_number(id_position, lower = 1, null.ok = TRUE,
                           na.ok = FALSE)
  checkmate::assert_character(token, n.chars = 32, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_character(uri, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  redcap_data <- REDCapR::redcap_read(
    redcap_uri = uri, token = token, records = NULL,
    fields = NULL, verbose = FALSE,
    id_position = as.integer(id_position)
  )
  metadata <- REDCapR::redcap_metadata_read(
    redcap_uri = uri, token = token,
    fields = NULL, verbose = FALSE
  )
  list(
    redcap_data = redcap_data,
    metadata = metadata
  )
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
  checkmate::assert_number(id_position, lower = 1, null.ok = TRUE,
                           na.ok = FALSE)
  checkmate::assert_character(token, n.chars = 32, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_character(uri, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_vector(records,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(fields,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
  checkmate::assertCharacter(id_col_name, len = 1L, null.ok = TRUE,
                             any.missing = FALSE)
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
  list(
    redcap_data = redcap_data,
    metadata = metadata
  )
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
  checkmate::assert_number(id_position, lower = 1, null.ok = TRUE,
                           na.ok = FALSE)
  checkmate::assert_character(token, n.chars = 32, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_character(uri, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_vector(fields,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
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
  list(
    redcap_data = redcap_data,
    metadata = metadata
  )
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
  checkmate::assert_number(id_position, lower = 1, null.ok = TRUE,
                           na.ok = FALSE)
  checkmate::assert_character(token, n.chars = 32, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_character(uri, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_vector(records,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
  checkmate::assertCharacter(id_col_name, len = 1L, null.ok = TRUE,
                             any.missing = FALSE)
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
  list(
    redcap_data = redcap_data,
    metadata = metadata
  )
}

#' Get arguments for reading from files
#'
#' @param args_list a list of user specified arguments
#'
#' @return a list of the parameters to be used for reading from file
#' @examples
#' args_list <- get_read_file_args(
#' list(
#' sep = "\t",
#' format = ".txt",
#' which = NULL))
#'
get_read_file_args <- function(args_list) {
  checkmate::assert_list(args_list)
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
#' @examples
#' args_list <- get_read_fingertips_args(
#' list(
#' indicator_id = 90362,
#' area_type_id = 202))
#'
get_read_fingertips_args <- function(args_list) {
  checkmate::assert_list(args_list)
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
#' @examples
#' result <- get_relevant_dataset(
#' dataset = "pBOMPrpg1QX,BfMAe6Itzgt",
#' base_url = "https://play.dhis2.org/dev/",
#' username = "admin",
#' password = "district"
#' )
get_relevant_dataset <- function(dataset, base_url, username, password) {
  checkmate::assertCharacter(base_url,
                             len = 1L, null.ok = FALSE,
                             any.missing = FALSE
  )
  checkmate::assertCharacter(username,
                             len = 1L, null.ok = FALSE,
                             any.missing = FALSE
  )
  checkmate::assertCharacter(password,
                             len = 1L, null.ok = FALSE,
                             any.missing = FALSE
  )
  checkmate::assert_vector(dataset,
                           any.missing = FALSE, min.len = 1,
                           null.ok = FALSE, unique = TRUE
  )
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
#' @examples
#' result <- get_relevant_organisation_unit(
#' organisation_unit = "DiszpKrYNg8",
#' base_url = "https://play.dhis2.org/dev/",
#' username = "admin",
#' password = "district"
#' )
#'
get_relevant_organisation_unit <- function(organisation_unit, base_url,
                                           username, password) {
  checkmate::assertCharacter(base_url,
                             len = 1L, null.ok = FALSE,
                             any.missing = FALSE
  )
  checkmate::assertCharacter(username,
                             len = 1L, null.ok = FALSE,
                             any.missing = FALSE
  )
  checkmate::assertCharacter(password,
                             len = 1L, null.ok = FALSE,
                             any.missing = FALSE
  )
  checkmate::assert_vector(organisation_unit,
                           any.missing = FALSE, min.len = 1,
                           null.ok = FALSE, unique = TRUE
  )
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
  checkmate::assertCharacter(base_url,
                             len = 1L, null.ok = FALSE,
                             any.missing = FALSE
  )
  checkmate::assertCharacter(username,
                             len = 1L, null.ok = FALSE,
                             any.missing = FALSE
  )
  checkmate::assertCharacter(password,
                             len = 1L, null.ok = FALSE,
                             any.missing = FALSE
  )
  checkmate::assert_vector(data_element_group,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
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
#' @examples
#' result = import_redcap_data(
#' uri = "https://bbmc.ouhsc.edu/redcap/api/",
#' token = "9A81268476645C4E5F03428B8AC3AA7B",
#' records = c("1", "3", "5"),
#' fields = c("record_id", "name_first", "age", "bmi"),
#' id_col_name = NULL,
#' id_position = 1
# )
#'
import_redcap_data <- function(records, fields, uri, token,
                              id_position, id_col_name) {
  checkmate::assert_number(id_position, null.ok = TRUE,
                           na.ok = FALSE)
  checkmate::assert_character(token, n.chars = 32, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_character(uri, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_vector(records,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(fields,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
  checkmate::assertCharacter(id_col_name, len = 1, null.ok = TRUE,
                             any.missing = FALSE)

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
#' @examples
#' # example code
#' results <- dhis2_subset_fields(
#' fields = c("dataElement","period","value"),
#' data = readepi(
#'  credentials_file = system.file("extdata", "test.ini", package = "readepi"),
#'  project_id = "DHIS2_DEMO",
#'  dataset = "pBOMPrpg1QX,BfMAe6Itzgt",
#'  organisation_unit = "DiszpKrYNg8",
#'  data_element_group = NULL,
#'  start_date = "2014",
#'  end_date = "2023",
#'  fields = c("dataElement","period","value")
#'  )
#')
dhis2_subset_fields <- function(fields, data) {
  checkmate::assert_vector(fields,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_data_frame(data, null.ok = FALSE)
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
#' @examples
#' result <- dhis2_subset_records(
#' records = c("FTRrcoaog83", "eY5ehpbEsB7", "Ix2HsbDMLea"),
#' id_col_name = "dataElement",
#' data = readepi(
#'   credentials_file = system.file("extdata", "test.ini", package = "readepi"),
#'   project_id = "DHIS2_DEMO",
#'   dataset = "pBOMPrpg1QX",
#'   organisation_unit = "DiszpKrYNg8",
#'   data_element_group = NULL,
#'   start_date = "2014",
#'   end_date = "2023"
#'   )
#' )
#'
dhis2_subset_records <- function(records, id_col_name, data) {
  checkmate::assert_data_frame(data, null.ok = FALSE)
  checkmate::assert_vector(records,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
  checkmate::assertCharacter(id_col_name, len = 1, null.ok = TRUE,
                             any.missing = FALSE)
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
  checkmate::assert_list(redcap_data, null.ok = FALSE, min.len = 2)
  checkmate::assert_list(metadata, null.ok = FALSE, min.len = 2)
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
