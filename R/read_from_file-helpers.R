#' Get file extension
#'
#' @param file_path the target file path
#'
#' @return a string that corresponds to the file extension
#'
#' @examples
#' \dontrun{
#' ext <- get_extension(
#'  file_path = system.file("extdata", "test.txt", package = "readepi")
#' )
#' }
#'
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
#' \dontrun{
#' base_name <- get_base_name(
#'  x = system.file("extdata", "test.txt", package = "readepi")
#' )
#' }
#'
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
#'
#' @examples
#' \dontrun{
#' sep <- detect_separator(
#'  x = "My name is Karim"
#' )
#' }
#'
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
