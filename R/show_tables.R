#' Display the list of tables in a database
<<<<<<< HEAD
#'
#' @param data_source the URL of the HIS of interest
#' @param credentials_file the path to the file with the user-specific
#'    credential details for the projects of interest. See the help of
#'    the `readepi` function for more details.
#' @param driver_name the name of the MS driver. use `odbc::odbcListDrivers()`
#'    to display the list of installed drivers
#' @examples
#' \dontrun{
#' show_tables(
#'   credentials_file = system.file("extdata", "test.ini",
#'                                  package = "readepi"),
#'   data_source      = "mysql-rfam-public.ebi.ac.uk",
#'   driver_name      = ""
#' )
#' }
#' @returns a `character` that contains the list of all tables found
#'     in the specified database
#' @export
#'
show_tables <- function(data_source, credentials_file, driver_name) {
  # checking input parameters
  checkmate::assert_character(credentials_file, null.ok = TRUE, len = 1L)
  checkmate::assert_file_exists(credentials_file)
  checkmate::assert_character(data_source, null.ok = FALSE, len = 1L)

  # reading the credentials from the credential file
  stopifnot(file.exists(credentials_file))
  credentials <- read_credentials(credentials_file, data_source)

  # establishing the connection to the server
  con <- switch(credentials[["dbms"]],
                "SQLServer" = DBI::dbConnect(odbc::odbc(),
                                             driver = driver_name,
                                             server = credentials[["host"]],
                                             database = credentials[["project"]], # nolint: line_length_linter
                                             uid = credentials[["user"]],
                                             pwd = credentials[["pwd"]],
                                             port = as.numeric(credentials[["port"]]) # nolint: line_length_linter
                ),
                "MySQL" = DBI::dbConnect(RMySQL::MySQL(),
                                         driver = driver_name,
                                         host = credentials[["host"]],
                                         dbname = credentials[["project"]],
                                         user = credentials[["user"]],
                                         password = credentials[["pwd"]],
                                         port = as.numeric(credentials[["port"]]) # nolint: line_length_linter
                ),
                "PostgreSQL" = DBI::dbConnect(odbc::odbc(),
                                              driver = driver_name,
                                              host = credentials[["host"]],
                                              database = credentials[["project"]], # nolint: line_length_linter
                                              uid = credentials[["user"]],
                                              pwd = credentials[["pwd"]],
                                              port = as.numeric(credentials[["port"]]) # nolint: line_length_linter
                )
=======
#' @param credentials_file the path to the file with the user-specific
#' credential details for the projects of interest. See the help of
#' the `readepi` function for more details.
#' @param project_id the name of the target database
#' @param driver_name the name of the MS driver. use `odbc::odbcListDrivers()`
#' to display the list of installed drivers
#' @examples
#' \dontrun{
#' show_tables(
#'   credentials_file = system.file("extdata", "test.ini", package = "readepi"),
#'   project_id = "Rfam",
#'   driver_name = ""
#' )
#' }
#' @returns the list of tables in the specified database
#' @export
#'
show_tables <- function(credentials_file, project_id, driver_name) {
  # checking input parameters
  checkmate::assert_character(credentials_file, null.ok = TRUE, len = 1)
  checkmate::assert_file_exists(credentials_file)
  checkmate::assert_character(project_id, null.ok = FALSE, len = 1)
  checkmate::assert_character(driver_name, null.ok = FALSE, len = 1)

  # reading the credentials from the credential file
  stopifnot(file.exists(credentials_file))
  credentials <- read_credentials(credentials_file, project_id)

  # establishing the connection to the server
  con <- switch(credentials$dbms,
    "SQLServer" = DBI::dbConnect(odbc::odbc(),
      driver = driver_name,
      server = credentials$host, database = credentials$project,
      uid = credentials$user, pwd = credentials$pwd,
      port = as.numeric(credentials$port)
    ),
    "MySQL" = DBI::dbConnect(RMySQL::MySQL(),
      driver = driver_name,
      host = credentials$host, dbname = credentials$project,
      user = credentials$user, password = credentials$pwd,
      port = as.numeric(credentials$port)
    ),
    "PostgreSQL" = DBI::dbConnect(odbc::odbc(),
      driver = driver_name,
      host = credentials$host, database = credentials$project,
      uid = credentials$user, pwd = credentials$pwd,
      port = as.numeric(credentials$port)
    )
>>>>>>> main
  )

  # listing the names of the tables present in the database
  tables <- DBI::dbListTables(conn = con)
<<<<<<< HEAD
  tables
=======
  R.utils::cat(paste(tables, collapse = "\n"))
>>>>>>> main
}
