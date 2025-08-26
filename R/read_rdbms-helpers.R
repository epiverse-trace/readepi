#' Make an SQL query from a list of query parameters
#'
#' @inheritParams read_rdbms
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
    select <- fields_check(fields = select, table_name = table_name,
                           login = login)
    target_columns <- toString(select)
    query <- sprintf("select %s from %s", target_columns, table_name)
  } else {
    select <- fields_check(fields = select, table_name = table_name,
                           login = login)
    # subset specified rows and all columns
    target_columns <- ifelse(
      !is.null(select),
      toString(select),
      "*"
    )
    query_check(query = filter, login = login, table_name = table_name)
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
#' @param table The name of the table of interest
#'
#' @return A string with the SQL query made from the input arguments
#' @keywords internal
#'
server_make_subsetting_query <- function(filter, target_columns, table) {
  if (is.numeric(filter)) {
    from <- min(filter) - 1L
    to <- max(filter) - min(filter) + 1L
    query <- sprintf(
      "select %s from %s limit %d, %d",
      target_columns, table, from, to
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
  for (i in seq_len(nrow(readepi::lookup_table))) {
    if (grepl(readepi::lookup_table[["r"]][i], filter)) {
      filter <- gsub(
        readepi::lookup_table[["r"]][i],
        readepi::lookup_table[["sql"]][i],
        filter, fixed = TRUE
      )
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
  if (!grepl(regex, domain)) {
    cli::cli_abort(c(
      x = "Incorrect domain name in the provided URL!"
    ))
  }
  return(invisible(TRUE))
}


#' Check whether the user-provided query is valid
#'
#' We define a query as valid when it contains either one of the column names of
#' the table being queried and/or one of the `R` operators provided in the
#' `lookup_table` object of the package.
#'
#' @inheritParams read_rdbms
#' @param query An R expression that will be converted into an SQL query
#' @param table_name A character with the table name
#'
#' @returns Invisibly returns `TRUE` if the query is valid; throws an error
#'    otherwise.
#' @keywords internal
#'
query_check <- function(query, login, table_name) {
  # fetch only the first row of the table and extract the column names
  cols_name_query <- sprintf("select * from %s", table_name)
  res <- DBI::dbGetQuery(login, cols_name_query, n = 1)
  col_names <- names(res)

  # check whether the query contains either the column names of the table and/or
  # the R operators in 'lookup_table'
  cols_are_in_query <- unlist(lapply(col_names, grepl, query, fixed = TRUE))
  operators_are_in_query <- unlist(lapply(readepi::lookup_table[["r"]], grepl,
                                          query, fixed = TRUE))
  sum_checks <- sum(cols_are_in_query) + sum(operators_are_in_query)
  if (sum_checks == 0) {
    cli::cli_abort(c(
      x = "You provided an incorrect SQL query."
    ))
  }

  return(invisible(TRUE))
}


#' Check whether the user-specified fields are valid
#'
#' A valid field is the one that corresponds to a column name of the specified
#' table.
#'
#' @inheritParams read_rdbms
#' @param fields A character vector of column names
#' @param table_name A character with the table name
#'
#' @returns A character vector with the valid fields
#' @keywords internal
#'
fields_check <- function(fields, table_name, login) {
  # fetch only the first row of the table and extract the column names
  cols_name_query <- sprintf("select * from %s", table_name)
  res <- DBI::dbGetQuery(login, cols_name_query, n = 1)

  if (is.character(fields)) {
    fields <- unlist(strsplit(fields, ",", fixed = TRUE))
  }

  verdict <- fields %in% names(res)
  if (sum(verdict) == 0) {
    cli::cli_abort(c(
      x = "Incorrect column {cli::qty(length(verdict))} name{?s} provided in \\
           'fields' argument."
    ))
  }

  if (!all(verdict)) {
    idx <- which(!verdict)
    cli::cli_alert_warning(
      "Cannot find the following field {cli::qty(length(fields[idx]))}\\
      name{?s}: {.field {toString(fields[idx])}} in table \\
      {.strong {table_name}}"
    )
    fields <- fields[-idx]
  }
  return(fields)
}
