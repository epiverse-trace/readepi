#' Read data from relational databases hosted by a MS SQL server.
#' @description For a user with read access to a Microsoft SQL server,
#' this function allows data import from the database into R. It required the
#' installation
#' of the appropriate MS driver that is compatible with the SQL server version
#' hosting the
#' database.
#' @param user the user name
#' @param password the user password
#' @param host the name of the host server
#' @param port the port ID
#' @param database_name the name of the database that contains the table from
#' which the data should be pulled
#' @param table_names a vector or a comma-separated list of table names from
#' the project or database. When this is not specified, the function will
#' extract data from all tables in the database.
#' @param driver_name the name of the MS driver. use `odbc::odbcListDrivers()`
#' to display the list of installed drivers
#' @param records a vector or a comma-separated string of subset of subject IDs.
#' When specified, only the records that correspond to these subjects will be
#' imported.
#' @param fields a vector of strings where each string is a comma-separated list
#' of column names. The element of this vector should be a list of column names
#' from the first table specified in the `table_names` argument and so on...
#' @param id_position a vector of the column positions of the variable that
#' unique identifies the subjects in each table. When the column name with the
#' subject IDs is known, use the `id_col_name` argument instead. default is.
#' default is 1.
#' @param id_col_name the column name with the subject IDs
#' @param dbms the SQL server type
#' @returns a list of data frames
#' @examples
#' \dontrun{
#' data <- read_from_ms_sql_server(
#'   user = "epiverse",
#'   password = "epiverse-trace1",
#'   host = "172.23.33.99",
#'   port = 1433,
#'   database_name = "TEST_READEPI",
#'   table_names = "covid",
#'   driver_name = "ODBC Driver 17 for SQL Server"
#' )
#' }
#' @export
#' @importFrom magrittr %>%
read_from_ms_sql_server <- function(user, password, host, port = 1433,
                                    database_name, driver_name,
                                    table_names = NULL, records = NULL,
                                    fields = NULL, id_position = NULL,
                                    id_col_name = NULL, dbms) {
  # check the input arguments
  checkmate::assert_vector(id_position,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = FALSE
  )
  checkmate::assert_vector(id_col_name,
    any.missing = FALSE, min.len = 1,
    null.ok = TRUE, unique = FALSE
  )
  checkmate::assert_number(port, lower = 1)
  checkmate::assert_character(user, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_character(dbms, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_character(password, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_character(host, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_character(database_name, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_character(driver_name, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_vector(table_names,
    any.missing = FALSE, min.len = 1,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(records,
    any.missing = FALSE, min.len = 1,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(fields,
    any.missing = FALSE, min.len = 1,
    null.ok = TRUE, unique = TRUE
  )

  if (all(!is.null(id_position) & !is.null(id_col_name))) {
    stop("Cannot specify both 'id_position' and 'id_col_name' at
         the same time.")
  }

  # establishing the connection to the server
  con <- switch(dbms,
    "SQLServer" = DBI::dbConnect(odbc::odbc(),
      driver = driver_name,
      server = host, database = database_name,
      uid = user, pwd = password, port = as.numeric(port)
    ),
    "MySQL" = DBI::dbConnect(RMySQL::MySQL(),
      driver = driver_name,
      host = host, dbname = database_name,
      user = user, password = password, port = as.numeric(port)
    ),
    "PostgreSQL" = DBI::dbConnect(odbc::odbc(),
      driver = driver_name,
      host = host, database = database_name,
      uid = user, pwd = password, port = as.numeric(port)
    )
  )

  # listing the names of the tables present in the database
  tables <- DBI::dbListTables(conn = con)

  # checking if the specified table exists in the database
  if (is.null(table_names)) {
    warning("No table name was specified. Data from all tables will be fetched.
            This might take several minutes...")
    table_names <- tables
  }
  table_names <- select_existing_tables(table_names, tables, database_name)

  # extract the data from the given tables and store the output in an R object
  result <- list()
  j <- 1
  for (table in table_names) {
    R.utils::cat("\nFetching data from", table)
    sql <- DBI::dbSendQuery(con, paste0("select * from ", table))
    result[[table]] <- DBI::dbFetch(sql, -1)
    DBI::dbClearResult(sql)
    if (!is.null(id_position[j])) {
      id_col_name <- c(id_col_name, names(result[[table]][id_position[j]]))
      j <- j + 1
    }
  }

  # subsetting the columns
  if (!is.null(fields)) {
    if (length(table_names) == 1) {
      sql <- DBI::dbSendQuery(con, paste0("select * from ", table_names))
      res <- DBI::dbFetch(sql, -1)
      DBI::dbClearResult(sql)
      subset_data <- subset_fields(res, fields, table_names)
      result[[table_names]] <- subset_data$data
    } else {
      result <- fetch_from_several_tables(table_names, con, fields, result)
    }
  } else {
    for (table in table_names) {
      sql <- DBI::dbSendQuery(con, paste0("select * from ", table))
      result[[table]] <- DBI::dbFetch(sql, -1)
      DBI::dbClearResult(sql)
    }
  }
  cat("\n")

  # subsetting the records
  if (!is.null(records)) {
    if (length(table_names) == 1) {
      id_pos <- which(names(result[[table_names]]) == id_col_name)
      res <- subset_records(
        result[[table_names]], records, id_pos,
        table_names
      )
      result[[table_names]] <- res$data
    } else {
      result <- subset_from_several_tables(result, records,
                                           id_col_name, table_names)
    }
  }
  cat("\n")

  # closing the connection
  DBI::dbDisconnect(conn = con)

  # return the datasets of interest
  result
}
