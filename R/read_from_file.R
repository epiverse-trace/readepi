#' Read data from file or directory
#' @param file_path the path to the file to be read. When several files need to
#' be imported from a directory, this should be the path to that directory
#' @param sep the separator between the columns in the file. This is only
#' required for space-separated files
#' @param format a string used to specify the file format. This is useful when
#' a file does not have an extension, or has a file extension that does not
#' match its actual type
#' @param which a string used to specify the name of the excel sheet to import
#' @param pattern when specified, only files with this suffix will be imported
#' from the specified directory
#' @returns  a list of 1 (when reading from file) or several (when reading from
#' directory or reading several excel sheets) data frames
#' @examples
#' data <- read_from_file(
#'   file_path = system.file("extdata", "test.txt", package = "readepi"),
#'   sep = NULL,
#'   format = NULL,
#'   which = NULL,
#'   pattern = NULL
#' )
#' @export
read_from_file <- function(
    file_path = system.file("extdata", "test.txt", package = "readepi"),
    sep = NULL, format = NULL, which = NULL, pattern = NULL) {

  # check the input arguments
  checkmate::assert_character(sep, null.ok = TRUE, len = 1, any.missing = FALSE)
  checkmate::assert_character(format, null.ok = TRUE, any.missing = FALSE)
  checkmate::assert_vector(which, any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_character(pattern, null.ok = TRUE, min.len = 1,
                              any.missing = FALSE)
  checkmate::assert_character(file_path, null.ok = FALSE, len = 1,
                              any.missing = FALSE)

  if (all(!checkmate::test_file_exists(file_path) &
          !checkmate::test_directory_exists(file_path))) {
    stop("Must provide a file path or directory")
  }

  # reading several files from a directory
  result <- list()
  if (checkmate::test_directory_exists(file_path)) {
    result <- read_files_in_directory(file_path, pattern)
  } else if (checkmate::test_file_exists(file_path)) {
    result <- read_files(sep, file_path, which, format)
  }
  result
}
