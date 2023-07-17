#' Get file extension
#'
#' @param file_path the target file path
#'
#' @return a `character` that contains the file extension
#'
#' @examples
#' \dontrun{
#'   ext <- get_extension(
#'     file_path = system.file("extdata", "test.txt", package = "readepi")
#'   )
#' }
#'
get_extension <- function(file_path) {
  splits <- unlist(strsplit(basename(file_path), ".", fixed = TRUE))
  extension <- splits[length(splits)]
  extension
}

#' Get file base name
#'
#' @param x the file path
#'
#' @return a `character` with the file base name(s)
#'
#' @examples
#' \dontrun{
#'   base_name <- get_base_name(
#'     x = system.file("extdata", "test.txt", package = "readepi")
#'   )
#' }
#'
get_base_name <- function(x) {
  ext <- get_extension(x)
  bn <- gsub(paste0(".", ext), "", basename(x))
  bn
}

#' Detect separator from a string
#'
#' @param x a string
#'
#' @return a `character vector` of identified separators
#'
#' @examples
#' \dontrun{
#'   sep <- detect_separator(
#'     x = "My name is Karim"
#'   )
#' }
#'
detect_separator <- function(x) {
  special_characters <- c("\t", "|", ",", ";", " ", ":")
  sep <- vector(mode = "character", length = 0)
  for (spec_char in special_characters) {
    if (grepl(spec_char, x)) {
      sep <- c(sep, spec_char)
    }
  }
  unique(sep)
}


#' Read files using the `rio` package
#'
#' @param files_extensions a vector a file extensions made from your files of
#'    interest
#' @param rio_extensions a vector of files extensions supported by the rio
#'    package
#' @param files a vector a files of interest
#' @param files_base_names a vector of file base
#'
#' @return a `list` of 4 elements of type `character` and `list`.
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
#' @return a `list` of 1 or several objects of type `data.frame` where each data
#'    frame contains data from a specific file.
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
        if (!exists("result")) {
          result <- list()
        }
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
              warning("\nCan't resolve separator in", file, "\n", call. = FALSE)
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
#' @return a `list` of 1 or several objects of type `data.frame` where each
#'    element contains data read from a file.
#'
read_files_in_directory <- function(file_path, pattern) {
  if (length(list.files(file_path, full.names = TRUE,
                        recursive = FALSE)) == 0) {
    stop("Could not find any file in ", file_path)
  }

  if (!is.null(pattern)) {
    result <- list()
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
#' @return a `list` of 1 or several elements of type `data.frame` where each
#'    contains data from a file
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
