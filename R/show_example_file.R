#' Display the structure of the credentials file
<<<<<<< HEAD
#' @examples
#' \dontrun{
#'   show_example_file()
#' }
#' @export
#'
show_example_file <- function() {
  example_data <- data.table::fread(system.file("extdata", "test.ini",
                                                package = "readepi"
  ))
=======
#' @export
#' @examples
#' show_example_file()
show_example_file <- function() {
  example_data <- data.table::fread(system.file("extdata", "test.ini",
                                                package = "readepi"))
>>>>>>> main
  print(example_data)
}
