#' Display the structure of the credentials file
#' @return Displays the content of the template credential file.
#' @examples
#'   show_example_file()
#' @export
#' @importFrom utils read.table
show_example_file <- function() {
  example_data <- read.table(
    system.file("extdata", "test.ini", package = "readepi"),
    header = TRUE
  )
  print(example_data)
}
