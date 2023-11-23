#' Read data from database management systems (DBMS).
#'
#' @description The function assumes the user has read access to the database.
#'    Importing data stored in DBMS into R requires the installation
#'    of the appropriate `driver` that is compatible with the server version
#'    hosting the database. See the `vignette` for how to install the driver
#' @param base_url the name of the host server
#' @param user_name the user name
#' @param password the user password
#' @param port the port ID
#' @param database_name the name of the database that contains the table from
#'    which the data should be pulled
#' @param src an SQL query or a vector of table names from
#'    the project or database. When this is not specified, the function will
#'    extract data from all tables in the database.
#' @param driver_name the name of the MS driver. use `odbc::odbcListDrivers()`
#'    to display the list of installed drivers
#' @param records a vector or a comma-separated string of subset of subject IDs.
#'    When specified, only the records that correspond to these subjects will
#'    be imported.
#' @param fields a vector of strings where each string is a comma-separated list
#'    of column names. The element of this vector should be a list of column
#'    names from the first table specified in the `table_names` argument
#'    and so on...
#' @param id_position a vector of the column positions of the variable that
#'    unique identifies the subjects in each table. When the column name with
#'    the subject IDs is known, use the `id_col_name` argument instead. default
#'    is 1.
#' @param id_col_name the column name with the subject IDs
#' @param dbms the SQL server type
#' @returns a `list` of 1 or several objects of type `data.frame`. The number of
#'    elements in the list depends on the number of tables from which the
#'    data is fetched.
#' @examples
#' \dontrun{
#' data <- sql_server_read_data(
#'   base_url      = "mysql-rfam-public.ebi.ac.uk",
#'   user_name     = "rfamro",
#'   password      = "",
#'   dbms          = "MySQL",
#'   driver_name   = "",
#'   database_name = "Rfam",
#'   port          = 4497,
#'   src           = "author",
#'   records       = NULL,
#'   fields        = NULL,
#'   id_position   = NULL,
#'   id_col_name   = NULL
#' )
#' }
#' @importFrom magrittr %>%
#' @keywords internal
sql_server_read_data <- function(base_url,
                                 user_name,
                                 password,
                                 dbms,
                                 driver_name,
                                 database_name,
                                 port,
                                 src           = NULL,
                                 records       = NULL,
                                 fields        = NULL,
                                 id_position   = NULL,
                                 id_col_name   = NULL) {
  # check the input arguments
  checkmate::assert_number(port, lower = 1L)
  checkmate::assert_character(user_name,
                              any.missing = FALSE, len = 1L,
                              null.ok = FALSE)
  checkmate::assert_character(dbms,
                              any.missing = FALSE, len = 1L,
                              null.ok = FALSE)
  checkmate::assert_character(password,
                              any.missing = FALSE, len = 1L,
                              null.ok = FALSE)
  checkmate::assert_character(base_url,
                              any.missing = FALSE, len = 1L,
                              null.ok = FALSE)
  checkmate::assert_character(database_name,
                              any.missing = FALSE, len = 1L,
                              null.ok = FALSE)
  checkmate::assert_character(driver_name,
                              len = 1L, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_vector(src,
                           any.missing = FALSE, min.len = 1L,
                           null.ok = TRUE, unique = TRUE)

  final_result <- list()

  # check the id_position and id_column name
  if (!is.null(id_position) && !is.null(id_col_name)) {
    stop("Cannot specify both 'id_position' and 'id_col_name' at
         the same time.")
  }

  # establishing the connection to the server
  con <- connect_to_server(
    base_url, user_name, password, dbms, driver_name, database_name, port
  )

  # listing the names of the tables present in the database
  tables      <- DBI::dbListTables(conn = con)
  # closing the connection
  pool::poolClose(con)

  # separate the srcs
  attributes <- identify_tables_and_queries(src = src, tables = tables)
  queries    <- attributes[["queries"]]
  src        <- attributes[["tables"]]

  # fetch data from queries
  if (length(queries) > 0L) {
    from_query <- fetch_data_from_query(src           = queries,
                                        tables        = tables,
                                        base_url      = base_url,
                                        user_name     = user_name,
                                        password      = password,
                                        dbms          = dbms,
                                        driver_name   = driver_name,
                                        database_name = database_name,
                                        port          = port)
    final_result <- c(final_result, from_query)
  }

  # fetch data from tables
  if (length(src) > 0L) {
    from_table_names <- sql_select_data(
      src, base_url, user_name, password,
      dbms, driver_name, database_name, port,
      id_col_name, fields, records, id_position
    )
    final_result <- c(final_result, from_table_names)
  }

  # return the datasets of interest
  final_result
}
