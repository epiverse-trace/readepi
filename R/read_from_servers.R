#' Read data from database management systems (DBMS).
#'
#' @description The function assumes the user has read access to the database.
#'    Importing data from DBMS requires the installation of the appropriate
#'    `driver` that is compatible with the server version hosting the database.
#'    For more details, see the [vignette](../vignettes/install_drivers.Rmd) on
#'    how to install the driver.
#'
#' @param con The connection object obtained from the `authenticate()`
#'    function.
#' @param query An SQL query or a list with the following elements:
#'    \enumerate{
#'      \item table: a string with the table name
#'      \item select: a vector of column names. When specified, only
#'          those columns will be returned. Default is `NULL`.
#'      \item filter: an expression or a vector of values used to filter the
#'          rows from the table of interest. This should be of the same length
#'          as the value for the 'select'. Default is `NULL`.
#'    }
#'
#' @returns A `data.frame` with the requested data as specified in the `query`
#'    argument.
#' @examples
#' \dontrun{
#'   # establish the connection to the database
#'   conn <- authenticate(
#'     from          = "mysql-rfam-public.ebi.ac.uk",
#'     type          = "MySQL",
#'     user_name     = "rfamro",
#'     password      = "",
#'     driver_name   = "",
#'     db_name       = "Rfam",
#'     port          = 4497
#'   )
#'
#'   # import data where query parameters are specified as a list
#'   authors_list <- read_server(
#'     conn  = conn,
#'     query = list(table = "author", select = NULL, filter = NULL)
#'   )
#'
#'   # import data where query parameters is within an SQL query
#'   authors_list <- read_server(
#'     conn  = conn,
#'     query = "select * from author"
#'   )
#' }
#' @export
read_server <- function(conn, query) {
  stopifnot("Invalid connection object!" = inherits(conn, "Pool"))
  if (!checkmate::test_character(query, len = 1L, null.ok = FALSE)) {
    checkmate::assert_list(query, min.len = 1L)
    checkmate::assert_vector(query[["select"]], min.len = 0L, null.ok = TRUE,
                             any.missing = FALSE)
    if (!checkmate::test_character(query[["filter"]], null.ok = TRUE,
                                   any.missing = FALSE)) {
      checkmate::assert_vector(query[["filter"]], null.ok = TRUE,
                                any.missing = FALSE)
    }
    checkmate::assert_character(query[["table"]], len = 1L, null.ok = FALSE,
                                any.missing = FALSE)
  }

  # When the query parameter is a list, the below function will be used
  # construct the SQL query to be used to fetch the data from the specified
  # table
  if (is.list(query)) {
    query <- server_make_query(
      table_name = query[["table"]],
      connexion  = conn,
      filter     = query[["filter"]],
      select     = query[["select"]]
    )
  }

  # fetch the data using the SQL query
  final_data <- server_fetch_data(connexion = conn, query = query)

  # return the datasets of interest
  return(final_data)
}

#' Make SQL query from the list of query parameters
#'
#' @param table_name The name of the table in the server
#' @param connexion A connection object created from the `authenticate()`
#'    function
#' @param filter A vector or a comma-separated string of subset of subject IDs
#' @param select A vector of column names
#'
#' @return A string with the constructed SQL query from the provided query
#'    parameter.
#' @examples
#' # establish the connection
#' \donttest{
#'   # establish the connection to the database
#'   conn <- authenticate(
#'     from          = "mysql-rfam-public.ebi.ac.uk",
#'     type          = "MySQL",
#'     user_name     = "rfamro",
#'     password      = "",
#'     driver_name   = "",
#'     db_name       = "Rfam",
#'     port          = 4497
#'   )
#' }
#' result <- server_make_query(
#'   table_name = "author",
#'   connexion  = conn,
#'   filter     = filter,
#'   select     = select
#' )
#' @keywords internal
#'
server_make_query <- function(table_name,
                              connexion,
                              filter,
                              select) {
  if (is.null(filter) && is.null(select)) {
    # subset all rows and all columns
    query          <- sprintf("select * from %s", table_name)
  } else if (!is.null(select) && is.null(filter)) {
    # subset all rows and specified columns
    target_columns <- paste(select, collapse = ", ")
    query          <- sprintf("select %s from %s", target_columns, table_name)
  } else {
    # subset specified rows and all columns
    target_columns <- ifelse(!is.null(select),
                             paste(select, collapse = ", "),
                             "*")
    query <- server_make_subsetting_query(filter, target_columns,
                                          equivalence_table, table_name)
  }

  return(query)
}

#' Convert R expression into SQL expression
#'
#' @param equivalence_table A data frame with the common R logical operators
#'    and their correspondent SQL operators
#' @param filter A string with the R expression
#'
#' @return A string of SQL expression
#' @keywords internal
#'
server_make_sql_expression <- function(filter, equivalence_table) {
  for (i in seq_len(nrow(equivalence_table))) {
    if (grepl(equivalence_table[["r"]][i], filter)) {
      filter <- gsub(equivalence_table[["r"]][i], equivalence_table[["sql"]][i],
                     filter, fixed = TRUE)
    }
  }
  return(filter)
}

#' Create a subsetting query
#'
#' @param filter An expression that will be used to subset on rows
#' @param target_columns A comma-separated list of column names to be returned
#' @param equivalence_table A table with the common R operators and their
#'    equivalent SQL operator
#' @param table The name of the table of interest
#'
#' @return A string with the SQL query made from the input arguments
#' @keywords internal
#'
server_make_subsetting_query <- function(filter, target_columns,
                                         equivalence_table, table) {
  if (is.numeric(filter)) {
    start               <- min(filter) - 1L
    how_many_from_start <- max(filter) - min(filter) + 1L
    query               <- sprintf("select %s from %s limit %d, %d",
                                   target_columns,
                                   table,
                                   start,
                                   how_many_from_start)
  } else {
    filter <- server_make_sql_expression(filter, equivalence_table)
    query  <- sprintf("select %s from %s where %s",
                      target_columns,
                      table,
                      filter)
  }
  return(query)
}

equivalence_table <- data.frame(cbind(
  r   = c("==", ">=", ">", "<=", "<", "%in%", "!=", "&&", "||"),
  sql = c("=", ">=", ">", "<=", "<", "in", "<>", "and", "or")
))



#' Fetch all or specific rows and columns from a table
#'
#' @inheritParams read_server
#' @param query A string with the SQL query
#'
#' @return A data frame with the data of interest
#' @keywords internal
#'
server_fetch_data <- function(connexion,
                              query) {
  checkmate::assert_character(query, any.missing = FALSE, min.len = 1L,
                              null.ok = FALSE)
  res   <- DBI::dbGetQuery(connexion, query)
  pool::poolClose(connexion)
  return(res)
}
