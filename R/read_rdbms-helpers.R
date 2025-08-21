#' Make an SQL query from a list of query parameters
#'
#' @param login A connection object created from the `login()` function
#' @param table_name The name of the table in the server
#'    function
#' @param filter A vector or a comma-separated string of subset of subject IDs
#' @param select A vector of column names
#'
#' @return A string with the constructed SQL query from the provided query
#'    parameter.
#' @keywords internal
#'
server_make_query <- function(table_name,
                              login,
                              filter,
                              select) {
  if (is.null(filter) && is.null(select)) {
    # subset all rows and all columns
    query <- sprintf("select * from %s", table_name)
  } else if (!is.null(select) && is.null(filter)) {
    # subset all rows and specified columns
    target_columns <- paste(select, collapse = ", ") # nolint: paste_linter
    query <- sprintf("select %s from %s", target_columns, table_name)
  } else {
    # subset specified rows and all columns
    target_columns <- ifelse(
      !is.null(select),
      paste(select, collapse = ", "), # nolint: paste_linter
      "*"
    )
    query <- server_make_subsetting_query(
      filter, target_columns, table_name
    )
  }

  return(query)
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
server_make_subsetting_query <- function(filter, target_columns, table) {
  if (is.numeric(filter)) {
    start <- min(filter) - 1L
    how_many_from_start <- max(filter) - min(filter) + 1L
    query <- sprintf(
      "select %s from %s limit %d, %d",
      target_columns, table, start, how_many_from_start
    )
  } else {
    filter <- server_make_sql_expression(filter)
    query  <- sprintf(
      "select %s from %s where %s",
      target_columns, table, filter
    )
  }
  return(query)
}

#' Convert R expression into SQL expression
#'
#' @param filter A string with the R expression
#'
#' @return A string of SQL expression
#' @keywords internal
#'
server_make_sql_expression <- function(filter) {
  for (i in seq_len(nrow(equivalence_table))) {
    if (grepl(equivalence_table[["r"]][i], filter)) {
      filter <- gsub(equivalence_table[["r"]][i], equivalence_table[["sql"]][i],
                     filter, fixed = TRUE)
    }
  }
  return(filter)
}


#' Fetch all or specific rows and columns from a table
#'
#' @inheritParams read_rdbms
#' @param query A string with the SQL query
#'
#' @return A data frame with the data of interest
#' @keywords internal
#'
server_fetch_data <- function(login, query) {
  checkmate::assert_character(query, any.missing = FALSE, min.len = 1L,
                              null.ok = FALSE)
  res <- DBI::dbGetQuery(login, query)
  pool::poolClose(login)
  return(res)
}

#' Check if the value for the base_url argument has a correct structure
#'
#' @inheritParams login
#'
#' @returns throws an error if the domain of the provided URL is not valid,
#'    (invisibly) TRUE
#'
#' @keywords internal
#'
url_check <- function(base_url) {
  checkmate::assert_character(base_url, any.missing = FALSE, len = 1L,
                              null.ok = FALSE)
  regex  <- "^(https?://)?(www\\.)?([a-z0-9]([a-z0-9]|(\\-[a-z0-9]))*\\.)+[a-z]+$" # nolint: line_length_linter
  domain <- strsplit(gsub("^(https?://)?(www\\.)?", "", base_url),
                     "/", fixed = TRUE)[[c(1L, 1L)]]
  stopifnot("Incorrect domain name in provided URL!" = grepl(regex, domain))
  return(invisible(TRUE))
}
