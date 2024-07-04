#' Read data from database management systems (DBMS).
#'
#' @description The function assumes the user has read access to the database.
#'    Importing data from DBMS requires the installation of the appropriate
#'    `driver` that is compatible with the server version hosting the database.
#'    For more details, see the [vignette](../vignettes/install_drivers.Rmd) on
#'    how to install the driver.
#'
#' @param conn The connection object generated from the `authenticate()`
#'    function.
#' @param query An SQL query or a list with the following elements:
#'    \enumerate{
#'      \item tables: a vector of table name(s)
#'      \item select: a vector of column names. When specified, only
#'          those columns will be returned. Default is "all".
#'      \item filter: an expression or a vector of values used to filter the
#'          rows from the tables of interest. This should be of the same length
#'          as 'select'. Default is `NULL`.
#'    }
#'
#' @returns a `list` of 1 or several objects of type `data.frame`. The number of
#'    elements in the list depends on the number of tables from which the
#'    data is fetched.
#' @examples
#' \dontrun{
#'   # establish the connection to the database
#'   conn <- authenticate(
#'     name          = "MySQL",
#'     base_url      = "mysql-rfam-public.ebi.ac.uk",
#'     user_name     = "rfamro",
#'     password      = "",
#'     driver_name   = "",
#'     database_name = "Rfam",
#'     port          = 4497
#'   )
#'
#'   # import data from the 'author' table
#'   data <- read_from_server(
#'     connexion = conn,
#'     src       = "author",
#'     filter    = NULL,
#'     select    = NULL
#'   )
#' }
#' @importFrom magrittr %>%
#' @export
read_server <- function(connexion,
                        query,
                        endpoint = NULL) {
  if (!checkmate::testCharacter(filter, null.ok = TRUE, any.missing = FALSE)) {
    checkmate::assert_numeric(filter, finite = TRUE, null.ok = TRUE,
                              any.missing = FALSE)
  }
  checkmate::assert_vector(select, min.len = 0L, null.ok = TRUE,
                           any.missing = FALSE)
  checkmate::assert_vector(src, any.missing = FALSE, null.ok = FALSE,
                           min.len = 1L)

  # listing the names of the tables present in the database
  tables     <- DBI::dbListTables(conn = connexion)

  # separate the SQL queries from non SQL queries
  attributes <- server_find_table_and_query(src    = src,
                                            tables = tables)
  queries    <- attributes[["queries"]]
  table_name <- attributes[["tables"]]

  # fetch data from queries
  if (length(queries) > 0L) {
    final_result <- server_fetch_data_from_query(src       = queries,
                                                 tables    = tables,
                                                 connexion = connexion)
  }

  # fetch data from tables
  if (length(src) > 0L) {
    final_result <- server_fetch_data_from_table(table_name = table_name,
                                                 connexion  = connexion,
                                                 filter     = filter,
                                                 select     = select)
  }

  # return the datasets of interest
  return(final_result)
}


#' Identify queries or tables names from the user supplied string
#'
#' @param src the user supplied string. This is usually an SQL query or a table
#'    name or a combination of both.
#' @param tables the list of all tables in the database
#'
#' @return a list with the identified queries and tables
#' @keywords internal
#'
server_find_table_and_query <- function(src,
                                        tables) {
  # detect the SQL queries
  # We assume that a query will contain at least 'select' and 'from' or both of
  # them
  queries <- table_names <- NULL
  for (s in src) {
    if (grepl("select", s, fixed = TRUE) || grepl("from", s, fixed = TRUE)) {
      queries <- c(queries, s)
    } else {
      if (s %in% tables) {
        table_names <- c(table_names, s)
      }
    }
  }
  list(
    queries = queries,
    tables  = table_names
  )
}


#' Fetch data from server using an SQL query
#'
#' @param src the SQL query
#' @param tables the list of tables from the database
#' @param connexion the connexion object generated from the `authenticate()`
#'    function
#'
#' @return a `list` of 1 or more objects of type `data.frame` containing each
#'    the data fetched from a specific table.
#'
#' @examples
#' result <- server_fetch_data_from_query(
#'   src       = "select author_id, name, last_name from author",
#'   tables    = c("family_author", "author"),
#'   connexion = connexion
#' )
#' @keywords internal
#'
server_fetch_data_from_query <- function(src,
                                         tables,
                                         connexion) {
  checkmate::assert_vector(tables,
                           any.missing = FALSE, min.len = 1L,
                           null.ok = FALSE, unique = TRUE)

  result  <- list()
  for (query in src) {
    table <- sql_identify_table_name(query, tables)
    stopifnot("Could not detect table name from the query" = !is.null(table))
    result[[table]] <- DBI::dbGetQuery(connexion, src)
  }
  pool::poolClose(connexion)
  result
}

#' Detect table names from an SQL query
#'
#' @param query the SQL query
#' @param tables the list of all tables from the database
#'
#' @return a `character` with the identified tables name(s) from the SQL query
#'
#' @examples
#' \dontrun{
#' table_name <- sql_identify_table_name(
#'   query  = "select * from author",
#'   tables = c("family_author", "author", "test")
#' )
#' }
#' @keywords internal
#'
sql_identify_table_name <- function(query,
                                    tables) {
  checkmate::assert_character(query,
                              any.missing = FALSE, len = 1L,
                              null.ok = FALSE)
  checkmate::assert_vector(tables,
                           any.missing = FALSE, min.len = 1L,
                           null.ok = FALSE, unique = TRUE)
  table_name <- NULL
  query      <- unlist(strsplit(query, " ", fixed = TRUE))
  table_name <- query[which(query %in% tables)]
  table_name <- ifelse(length(table_name) == 1L, table_name,
                       glue::glue_collapse(table_name, sep = "_"))
  return(table_name)
}


#' Fetch data from a server using the table name(s)
#'
#' @param table_name the name of the table in the server
#' @param connexion a connexion object created from the `authenticate()`
#'    function
#' @param filter a vector or a comma-separated string of subset of subject IDs
#' @param select a vector of column names
#'
#' @return a `data.frame` with the data from the corresponding table name
#' @examples
#' \dontrun{
#'   result <- server_fetch_data_from_table(
#'     table_names = "author",
#'     connexion   = connexion,
#'     filter      = filter,
#'     select      = select
#'   )
#' }
#' @keywords internal
#'
server_fetch_data_from_table <- function(table_name,
                                         connexion,
                                         filter,
                                         select) {
  checkmate::assert_character(table_name, any.missing = FALSE, min.len = 1L,
                              null.ok = FALSE, unique = TRUE)
  message("\nFetching data from: ", table_name)
  if (is.null(filter) && is.null(select)) {
    # subset all rows and all/specified columns
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
  result  <- server_fetch_data(connexion, query)

  return(result)
}

#' Convert R expression into SQL expression
#'
#' @param equivalence_table a data frame with the common R logical operators
#'    and their correspondent SQL operators
#' @param filter a string with the R expression
#'
#' @return a string of SQL expression
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
#' @param filter an expression that will be used to subset on rows
#' @param target_columns a comma-separated list of column names to be returned
#' @param equivalence_table a table with the common R operators and their
#'    equivalent SQL operator
#' @param table the name of the table of interest
#'
#' @return a string with the SQL query made from the input arguments
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
#' @inheritParams read_from_servers
#' @param query the SQL query
#'
#' @return a data frame with the data of interest
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
