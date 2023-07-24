#' Display the structure of the credentials file
#' @examples
#' \dontrun{
#' show_example_file()
#' }
#' @export
#'
show_example_file <- function() {
  example_data <- data.table::fread(system.file("extdata", "test.ini",
    package = "readepi"
  ))
  print(example_data)
}
