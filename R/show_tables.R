#' Display the list of tables in a database
#' @param credentials.file the path to the file with the user-specific credential details for the projects of interest. See the help of the `readepi` function for more details.
#' @param project.id the name of the target database
#' @param driver.name the name of the MS driver. use `odbc::odbcListDrivers()` to display the list of installed drivers
#' @examples
#' \dontrun{
#' show_tables(
#'   credentials.file = system.file("extdata", "fake_test.ini", package = "readepi"),
#'   project.id = "IBS_BHDSS",
#'   driver.name = "ODBC Driver 17 for SQL Server"
#' )
#' }
#' @returns the list of tables in the specified database
#' @export
#'
show_tables <- function(credentials.file, project.id, driver.name) {
  # checking input parameters
  checkmate::assert_character(credentials.file, null.ok = TRUE, len = 1)
  checkmate::assert_file_exists(credentials.file)
  checkmate::assert_character(project.id, null.ok = FALSE, len = 1)
  checkmate::assert_character(driver.name, null.ok = FALSE, len = 1)

  # reading the credentials from the credential file
  stopifnot(file.exists(credentials.file))
  credentials <- read_credentials(credentials.file, project.id)

  # establishing the connection to the server
  con <- DBI::dbConnect(odbc::odbc(),
    driver = driver.name,
    server = credentials$host,
    database = credentials$project,
    uid = credentials$user,
    pwd = credentials$pwd,
    port = credentials$port
  )

  # listing the names of the tables present in the database
  tables <- DBI::dbListTables(conn = con)
  R.utils::cat(paste(tables, collapse = "\n"))
  # print(tables)
}
