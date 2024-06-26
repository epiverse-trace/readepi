#' Display the list of tables in a database
#'
#' @param data_source the URL of the server of interest
#' @param credentials_file the path to the file with the user-specific
#'    credential details for the projects of interest. See the help of
#'    the `readepi` function for more details.
#' @param driver_name the name of the MS driver. use `odbc::odbcListDrivers()`
#'    to display the list of installed drivers
#' @examples
#' \dontrun{
#' show_tables(
#'   data_source      = "mysql-rfam-public.ebi.ac.uk",
#'   credentials_file = system.file("extdata", "test.ini", package = "readepi"),
#'   driver_name      = ""
#' )
#' }
#' @returns a `character` that contains the list of all tables found
#'     in the specified database.
#' @export
#'
show_tables <- function(data_source,
                        driver_name,
                        credentials_file = NULL) {
  # checking input parameters
  checkmate::assert_character(credentials_file, null.ok = TRUE, len = 1L)
  if (is.null(credentials_file)) {
    message("The test credential file looks like below:\n")
    credentials_file <- system.file("extdata", "test.ini", package = "readepi")
  }
  checkmate::assert_file_exists(credentials_file)
  checkmate::assert_character(data_source, null.ok = FALSE, len = 1L,
                              any.missing = FALSE)

  # reading the credentials from the credential file
  stopifnot(file.exists(credentials_file))
  credentials <- read_credentials(credentials_file, data_source)

  # establishing the connection to the server
  con <- switch(
    credentials[["dbms"]],
    SQLServer = DBI::dbConnect(odbc::odbc(),
                               driver   = driver_name,
                               server   = credentials[["host"]],
                               database = credentials[["project"]],
                               uid      = credentials[["user"]],
                               pwd      = credentials[["pwd"]],
                               port     = as.numeric(credentials[["port"]])),
    MySQL = DBI::dbConnect(RMySQL::MySQL(),
                           driver   = driver_name,
                           host     = credentials[["host"]],
                           dbname   = credentials[["project"]],
                           user     = credentials[["user"]],
                           password = credentials[["pwd"]],
                           port     = as.numeric(credentials[["port"]])),
    PostgreSQL = DBI::dbConnect(odbc::odbc(),
                                driver   = driver_name,
                                host     = credentials[["host"]],
                                database = credentials[["project"]],
                                uid      = credentials[["user"]],
                                pwd      = credentials[["pwd"]],
                                port     = as.numeric(credentials[["port"]]))
  )

  # listing the names of the tables present in the database
  tables <- DBI::dbListTables(conn = con)
  tables
}
