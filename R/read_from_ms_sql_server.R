#' Read data from relational databases hosted by a MS SQL server.
#' @description For a user with read access to a Microsoft SQL server,
#' this function allows data import from the database into R. It required the installation
#' of the appropriate MS driver that is compatible with the SQL server version hosting the
#' database.
#' @param user the user name
#' @param password the user password
#' @param host the name of the host server
#' @param port the port ID
#' @param database.name the name of the database that contains the table from which the data should be pulled
#' @param table.names a vector or a comma-separated list of table names from the project or database. When this is not specified, the function will extract data from all tables in the database.
#' @param driver.name the name of the MS driver. use `odbc::odbcListDrivers()` to display the list of installed drivers
#' @param records a vector or a comma-separated string of subset of subject IDs. When specified, only the records that correspond to these subjects will be imported.
#' @param fields a vector of strings where each string is a comma-separated list of column names. The element of this vector should be a list of column names from the first table specified in the `table.names` argument and so on...
#' @param id.position a vector of the column positions of the variable that unique identifies the subjects in each table. This should only be specified when the column with the subject IDs is not the first column. default is 1.
#' @returns a list of data frames
#' @examples
#' \dontrun{
#' data <- read_from_ms_sql_server(
#'   user = "kmane",
#'   password = "****",
#'   host = "robin.mrc.gm",
#'   port = 1433,
#'   database.name = "my_db",
#'   table.names = "my_table",
#'   driver.name = "ODBC Driver 17 for SQL Server"
#' )
#' }
#' @export
#' @importFrom magrittr %>%
read_from_ms_sql_server <- function(user, password, host, port = 1433, database.name,
                                    driver.name, table.names = NULL, records = NULL,
                                    fields = NULL, id.position = 1) {
  # check the input arguments
  checkmate::assert_number(id.position, lower = 1)
  checkmate::assert_number(port, lower = 1)
  checkmate::assert_character(user, any.missing = FALSE, len = 1, null.ok = FALSE)
  checkmate::assert_character(password, any.missing = FALSE, len = 1, null.ok = FALSE)
  checkmate::assert_character(database.name, any.missing = FALSE, len = 1, null.ok = FALSE)
  checkmate::assert_character(driver.name, len = 1, null.ok = TRUE)
  checkmate::assert_vector(table.names,
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


  # establishing the connection to the server
  con <- DBI::dbConnect(odbc::odbc(),
    driver = driver.name,
    server = host,
    database = database.name,
    uid = user,
    pwd = password,
    port = as.numeric(port)
  )

  # listing the names of the tables present in the database
  tables <- DBI::dbListTables(conn = con)

  # checking if the specified table exists in the database
  if (!is.null(table.names)) {
    if (is.character(table.names)) {
      table.names <- as.character(unlist(strsplit(table.names, ",")))
    }
    idx <- which(table.names %in% tables)
    if (length(idx) == 0) {
      message("Could not found tables called ", paste(table.names, collapse = ", "), " in ", database.name, "!\n")
      R.utils::cat("\nBelow is the list of all tables in the specified database:\n")
      print(tables)
      stop()
    } else if (length(idx) != length(table.names)) {
      message("The following tables are not available in the database: ", paste(table.names[-idx], collapse = ", "))
    }
    table.names <- table.names[idx]
  } else {
    warning("No table name was specified. Data from all tables will be fetched. This might take several minutes...")
    table.names <- tables
  }
  result <- list()
  for (table in table.names) {
    R.utils::cat("\nFetching data from", table)
    sql <- DBI::dbSendQuery(con, paste0("select * from ", table))
    result[[table]] <- DBI::dbFetch(sql, -1)
    DBI::dbClearResult(sql)
  }


  # extract the data from the given tables and store the output in an R object
  # subsetting the columns
  if (!is.null(fields)) {
    j <- 1
    not.found <- 0
    for (table in table.names) {
      R.utils::cat("\nFetching data from", table)
      sql <- DBI::dbSendQuery(con, paste0("select * from ", table))
      res <- DBI::dbFetch(sql, -1)
      DBI::dbClearResult(sql)
      if (!is.na(fields[j])) {
        subset.data <- subset_fields(res, fields[j], table)
        result[[table]] <- subset.data$data
        not.found <- not.found + subset.data$not_found
        j <- j + 1
      } else {
        result[[table]] <- res
        j <- j + 1
      }
    }
    if (not.found == length(table.names)) {
      stop("Specified fields not found in the tables of interest!")
    }
  } else {
    for (table in table.names) {
      R.utils::cat("\nFetching data from", table)
      sql <- DBI::dbSendQuery(con, paste0("select * from ", table))
      result[[table]] <- DBI::dbFetch(sql, -1)
      DBI::dbClearResult(sql)
    }
  }
  cat("\n")

  # subsetting the records
  if (!is.null(records)) {
    j <- 1
    not.found <- 0
    for (table in names(result)) {
      if (!is.na(records[j])) {
        id.position <- ifelse(!is.na(id.position[j]), id.position[j], id.position[1])
        res <- subset_records(result[[table]], records[j], id.position, table)
        result[[table]] <- res$data
        not.found <- not.found + res$not_found
        j <- j + 1
      }
    }
    if (not.found == length(table.names)) {
      stop("Specified records not found in the tables of interest!")
    }
  }
  cat("\n")

  # closing the connection
  DBI::dbDisconnect(conn = con)

  # return the datasets of interest
  result
}
