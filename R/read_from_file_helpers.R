#' Get file base name without its extension
#'
#' @param x the file path
#'
#' @return a `character` with the file base name(s) without it extension
#'
#' @examples
#' \dontrun{
#' base_name <- get_base_name(
#'   x = system.file("extdata", "test.txt", package = "readepi")
#' )
#' }
#'
get_base_name <- function(x) {
  checkmate::assert_file(x)
  ext <- rio::get_ext(x)
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
#' sep <- detect_separator(
#'   x = "My name is Karim"
#' )
#' }
#'
detect_separator <- function(x) {
  checkmate::assert_character(x, null.ok = FALSE, any.missing = FALSE)
  special_characters <- c("\t", "|", ",", ";", " ", ":")
  sep <- vector(mode = "character", length = 0L)
  for (spec_char in special_characters) {
    if (grepl(spec_char, x, fixed = TRUE)) {
      sep <- c(sep, spec_char)
    }
  }
  sep
}

#' Split a character by "_" and extract its element
#'
#' @param x a character string
#'
#' @return a character string
#'
#' @keywords internal
f <- function(x) {
  checkmate::assert_character(x, null.ok = FALSE, any.missing = FALSE)
  y <- unlist(strsplit(x, "_", fixed = TRUE))[[2L]]
  y <- suppressWarnings(as.numeric(y))
  y
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
  checkmate::assert_vector(files_extensions,
    min.len = 1L, any.missing = FALSE,
    null.ok = FALSE
  )
  checkmate::assert_vector(rio_extensions,
    min.len = 1L, any.missing = FALSE,
    null.ok = FALSE
  )
  checkmate::assert_vector(files,
    min.len = 1L, any.missing = FALSE,
    null.ok = FALSE
  )
  checkmate::assert_vector(files_base_names,
    min.len = 1L, any.missing = FALSE,
    null.ok = FALSE
  )
  # get indexes of {rio} file's extensions
  idx <- which(files_extensions %in% rio_extensions)
  result <- list()
  if (length(idx) > 0L) {
    tmp_files <- files[idx]
    tmp_bn <- files_base_names[idx]
    # check whether the file names are unique and add a suffix if not
    for (i in seq_along(tmp_files)) {
      name <- tmp_bn[i]
      if (!is.null(names(result)) && grepl(name, names(result))) {
        tmp <- names(result)[which(grepl(name, names(result)))]
        x <- max(as.numeric(lapply(tmp, f)))
        x <- ifelse(is.na(x), 1, (x + 1)) # nolint: line_length_linter
        name <- paste0(name, "_", x)
      }
      # import the file and add a comment
      result[[name]] <- rio::import(tmp_files[i])
      comment(result[[name]]) <- c(comment(result[[name]]), tmp_files[i])
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
  checkmate::assert_vector(files,
    any.missing = FALSE, null.ok = FALSE,
    min.len = 1L
  )
  checkmate::assert_vector(dirs,
    any.missing = FALSE, null.ok = FALSE,
    min.len = 0L
  )
  checkmate::assert_vector(format,
    any.missing = FALSE, null.ok = TRUE,
    min.len = 0L
  )
  checkmate::assert_vector(which,
    any.missing = FALSE, null.ok = TRUE,
    min.len = 0L
  )
  # filter out directories from files
  idx <- which(files %in% dirs)
  if (length(idx) > 0L) {
    files <- files[-idx]
  }

  # defining {rio} package file extensions
  rio_extensions <- c(
    "csv", "psv", "tsv", "csvy", "sas7bdat", "sav", "zsav", "dta", "xpt",
    "por", "xls", "R", "RData", "rda", "rds", "rec", "mtp", "syd", "dbf",
    "arff", "dif", "no recognized extension", "fwf", "csv.gz", "parquet",
    "wf1", "feather", "fst", "json", "mat", "ods", "html", "xml", "yml"
  )

  # getting files extensions and base names
  files_extensions <- as.character(lapply(files, rio::get_ext))
  files_base_names <- as.character(lapply(files, get_base_name))

  # reading files with extensions that are taken care by {rio}
  if (length(files_extensions) > 0L) {
    tmp_res <- read_rio_formats(
      files_extensions, rio_extensions,
      files, files_base_names
    )
    files <- tmp_res[["files"]]
    files_base_names <- tmp_res[["files_base_names"]]
    files_extensions <- tmp_res[["files_extensions"]]
    result <- tmp_res[["result"]]
    result <- import_non_rio_files(files, files_base_names,
      files_extensions,
      result = list()
    )
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
  checkmate::assert_directory(file_path)
  checkmate::assert_vector(pattern,
    min.len = 0L, null.ok = TRUE,
    any.missing = FALSE
  )
  if (length(list.files(file_path,
                        full.names = TRUE,
                        recursive = FALSE)) == 0L) {
    stop("Could not find any file in ", file_path)
  }

  if (!is.null(pattern)) {
    result <- list()
    for (pat in pattern) {
      files <- list.files(file_path,
        full.names = TRUE, pattern = pat,
        recursive = FALSE
      )
      if (length(files) == 0L) {
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
#' @param file_path the path to the file to be read
#' @param sep the separator between the columns in the file
#' @param which a string used to specify the name of the excel sheet to import
#' @param format a string used to specify the file format
#'
#' @return a `list` of 1 or several elements of type `data.frame` where each
#'    contains data from a file
#'
read_files <- function(file_path, sep, which, format) {
  checkmate::assert_file(file_path)
  checkmate::assert_vector(sep,
    min.len = 0L, null.ok = TRUE,
    any.missing = FALSE
  )
  checkmate::assert_vector(which,
    min.len = 0L, null.ok = TRUE,
    any.missing = FALSE
  )
  checkmate::assert_vector(format,
    min.len = 0L, null.ok = TRUE,
    any.missing = FALSE
  )
  result <- list()
  # get the file base name
  base_name <- get_base_name(x = file_path)
  if (!is.null(sep)) {
    result[[base_name]] <- rio::import(file_path, sep = sep)
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
      result[[base_name]] <- rio::import(file_path, format = format)
    } else {
      result[[base_name]] <- rio::import(file_path)
    }
  }

  result
}


#' Import files with extensions that are not handled by the {rio} package
#'
#' @param files a vector of the file paths
#' @param files_base_names a `vector` of the file base names
#' @param files_extensions a `vector` of the file extension
#' @param result a `list` object where the data read from each file will be
#'    stored as a `data.frame`
#'
#' @return an object of type `list` with 1 or several object of type
#'    `data.frame`. Each elements of the list is named after the file from
#'    which the corresponding data is coming.
#'
#' @keywords internal
#'
import_non_rio_files <- function(files, files_base_names,
                                 files_extensions, result = list()) {
  checkmate::assert_vector(files,
    any.missing = FALSE, null.ok = FALSE,
    min.len = 1L
  )
  checkmate::assert_vector(files_base_names,
    any.missing = FALSE,
    null.ok = FALSE, min.len = 1L
  )
  checkmate::assert_vector(files_extensions,
    any.missing = FALSE,
    null.ok = FALSE, min.len = 1L
  )
  checkmate::assert_list(result, any.missing = FALSE, null.ok = FALSE)
  i <- 1L
  for (file in files) {
    if (files_extensions[i] %in% c("xlsx", "xls")) {
      # process MS excel files
      data <- readxl::read_xlsx(file)
      comment(data) <- file
      idx <- which(grepl(files_base_names[i], names(result)))
      base_name <- get_file_name(result, idx, files_base_names[i])
      result[[base_name]] <- data
      i <- i + 1 # nolint
    } else {
      # process non MS excel files: detect the separator and import the file
      tmp_string <- readLines(con = file, n = 1L)
      sep <- detect_separator(tmp_string)
      if (length(sep) == 2L && (" " %in% sep)) {
        sep <- sep[-(which(sep == " "))]
      } else if (length(sep) > 2L) {
        warning("\nCan't resolve separator in", file, "\n", call. = FALSE)
        i <- i + 1L
        next
      }
      data <- read.table(file, sep = sep)
      comment(data) <- file
      idx <- which(grepl(files_base_names[i], names(result)))
      base_name <- get_file_name(result, idx, files_base_names[i])
      result[[base_name]] <- data
      i <- i + 1 # nolint
    }
  }
  result
}

#' Get the file base name
#'
#' Every data frame in the output list is named after its correspondent file
#' base name. This function will extract that base name appropriately and add
#' an index to it when several files have the same name.
#'
#' @param result a `list` of `data.frame`
#' @param idx an integer
#' @param base_name a `character` with the file base name
#'
#' @return a `character` that will be used to name the file.
#' @keywords internal
#'
get_file_name <- function(result, idx, base_name) {
  checkmate::assert_list(result, null.ok = FALSE, any.missing = FALSE)
  checkmate::assert_character(base_name,
    len = 1L, null.ok = FALSE,
    any.missing = FALSE
  )
  checkmate::assert_numeric(idx)

  if (!is.null(names(result)) && length(idx) > 0L) {
    tmp <- names(result)[which(grepl(base_name, names(result)))]
    for (tmp_f in tmp) {
      if (tmp_f == base_name) {
        m <- which(grepl(paste0(base_name, "_"), tmp))
        if (length(m) == 0L) {
          base_name <- paste0(base_name, "_", 1L)
        } else {
          indexes <- max(as.numeric(as.character(
            unlist(strsplit(tmp[m], "_", fixed = TRUE))[[2L]]
          )), na.rm = TRUE)
          base_name <- paste0(base_name, "_", (indexes + 1L))
        }
      }
    }
  }
  base_name
}
