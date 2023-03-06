

#' Read data from file or directory
#' @param file.path the path to the file to be read. When several files need to be imported from a directory, this should be the path to that directory
#' @param sep the separator between the columns in the file. This is only required for space-separated files
#' @param format a string used to specify the file format. This is useful when a file does not have an extension, or has a file extension that does not match its actual type
#' @param which a string used to specify the name of the excel sheet to import
#' @param pattern when specified, only files with this suffix will be imported from the specified directory
#' @returns  a list of 1 (when reading from file) or several (when reading from directory or reading several excel sheets) data frames
#' @examples
#' data <- read_from_file(file.path = system.file("extdata", "test.txt", package = "readepi"),
#' sep = NULL,
#' format = NULL,
#' which = NULL,
#' pattern = NULL)
#' @export
read_from_file <- function(file.path=system.file("extdata", "test.txt", package = "readepi"),
                           sep = NULL, format = NULL,
                           which = NULL, pattern = NULL) {
  # check the input arguments
  checkmate::assert_character(sep, n.chars = 1, null.ok = TRUE, len = 1)
  checkmate::assert_character(format, null.ok = TRUE)
  checkmate::assert_vector(which, any.missing = FALSE, min.len = 1, null.ok = TRUE, unique = TRUE)
  checkmate::assert_character(pattern, null.ok = TRUE, min.len = 1)
  checkmate::assert_character(file.path, null.ok = FALSE, len = 1)

  # reading several files from a directory
  result = list()
  if (checkmate::test_directory_exists(file.path)) { #dir.exists(file.path)
    if(length(list.files(file.path, full.names = TRUE, recursive = FALSE)) > 0){
      if (!is.null(pattern)) {
        for(pat in pattern){
          files = list.files(file.path, full.names = TRUE, pattern = pat,
                             recursive = FALSE)
          dirs = list.dirs(file.path, full.names = TRUE, recursive = FALSE)
          res = read_multiple_files(files, dirs)
          # data <- rio::import_list(list.files(file.path, full.names = TRUE, pattern = pat,
          #                                     recursive = FALSE))
          result = c(result, res)
        }
      } else {
        files = list.files(file.path, full.names = TRUE, recursive = FALSE)
        dirs = list.dirs(file.path, full.names = TRUE, recursive = FALSE)
        result = read_multiple_files(files, dirs)
      }
    }else{
      stop("Could not find any file in ",file.path)
    }
  }else if (checkmate::test_file_exists(file.path)) {  #file.exists(file.path)
    if (!is.null(sep)) {
      result[[1]] <- data.table::fread(file.path, sep = sep)
    }else if (is.null(sep)) {
      if (!is.null(which) & !is.null(format)) {
        for(wh in which){
          data <- rio::import(file.path, format = format, which = wh)
          result[[wh]] = data
        }
      } else if (!is.null(which) & is.null(format)) {
        for(wh in which){
          data <- rio::import(file.path, which = wh)
          result[[wh]] = data
        }
      } else if (!is.null(format) & is.null(which)) {
        result[[1]] <- rio::import(file.path, format = format)
      } else {
        result[[1]] <- rio::import(file.path)
      }
    }
  }else if(!checkmate::test_file_exists(file.path) &
           !checkmate::test_directory_exists(file.path)) {  #!file.exists(file.path) & !dir.exists(file.path)
    stop(file.path, " No such file or directory!")
  }
  result
}








# read_from_file <- function(file.path=system.file("extdata", "test.txt", package = "readepi"),
#                            sep = NULL, format = NULL,
#                            which = NULL, pattern = NULL) {
#   # check the input arguments
#   checkmate::assert_character(sep, n.chars = 1, null.ok = TRUE, len = 1)
#   checkmate::assert_character(format, null.ok = TRUE)
#   checkmate::assert_vector(which, any.missing = FALSE, min.len = 1, null.ok = TRUE, unique = TRUE)
#   checkmate::assert_character(pattern, null.ok = TRUE, len = 1)
#   checkmate::assert_character(file.path, null.ok = FALSE, len = 1)
#
#   # reading several files from a directory
#   result = list()
#   if (checkmate::test_directory_exists(file.path)) { #dir.exists(file.path)
#     if(length(list.files(file.path, full.names = TRUE, recursive = FALSE)) > 0){
#       if (!is.null(pattern)) {
#         for(pat in pattern){
#           data <- rio::import_list(list.files(file.path, full.names = TRUE, pattern = pat,
#                                               recursive = FALSE))
#           result = c(result, data)
#         }
#       } else {
#         result <- rio::import_list(list.files(file.path, full.names = TRUE))
#       }
#     }else{
#       stop("Could not find any file in ",file.path)
#     }
#   }else if (checkmate::test_file_exists(file.path)) {  #file.exists(file.path)
#     if (!is.null(sep)) {
#       result[[1]] <- data.table::fread(file.path, sep = sep)
#     }else if (is.null(sep)) {
#       if (!is.null(which) & !is.null(format)) {
#         for(wh in which){
#           data <- rio::import(file.path, format = format, which = wh)
#           result[[wh]] = data
#         }
#       } else if (!is.null(which) & is.null(format)) {
#         for(wh in which){
#           data <- rio::import(file.path, which = wh)
#           result[[wh]] = data
#         }
#       } else if (!is.null(format) & is.null(which)) {
#         result[[1]] <- rio::import(file.path, format = format)
#       } else {
#         result[[1]] <- rio::import(file.path)
#       }
#     }
#   }else if(!checkmate::test_file_exists(file.path) &
#            !checkmate::test_directory_exists(file.path)) {  #!file.exists(file.path) & !dir.exists(file.path)
#     stop(file.path, " No such file or directory!")
#   }
#   result
# }
