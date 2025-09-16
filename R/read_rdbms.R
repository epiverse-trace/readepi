#' Import data from relational database management systems (RDBMS).
#'
#' @description The function assumes the user has read access to the database.
#'    Importing data from RDBMS requires the installation of the appropriate
#'    `driver` that is compatible with the server version hosting the database.
#'    For more details, see the [vignette](../vignettes/install_drivers.Rmd) on
#'    how to install the driver.
#'
#' @param login The connection object obtained from the `login()` function.
#' @param query An SQL query or a list with the following elements:
#'    \enumerate{
#'      \item table: a string with the table name
#'      \item fields: a vector of column names. When specified, only
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
#'   rdbms_login <- login(
#'     from = "mysql-rfam-public.ebi.ac.uk",
#'     type = "mysql",
#'     user_name = "rfamro",
#'     password = "",
#'     driver_name = "",
#'     db_name = "Rfam",
#'     port = 4497
#'   )
#'
#'   # import data where query parameters are specified as a list
#'   authors_list <- read_rdbms(
#'     login = rdbms_login,
#'     query = list(table = "author", fields = NULL, filter = NULL)
#'   )
#'
#'   # import data where query parameters is within an SQL query
#'   authors_list <- read_rdbms(
#'     login = rdbms_login,
#'     query = "select * from author"
#'   )
#' }
#' @export
read_rdbms <- function(login, query) {
  if (!checkmate::test_character(query, len = 1L, null.ok = FALSE)) {
    checkmate::assert_list(query, min.len = 1L)
    checkmate::assert_vector(query[["fields"]], min.len = 0L, null.ok = TRUE,
                             any.missing = FALSE)
    if (!checkmate::test_character(query[["filter"]], null.ok = TRUE,
                                   any.missing = FALSE)) {
      checkmate::assert_vector(query[["filter"]], null.ok = TRUE,
                               any.missing = FALSE)
    }
    checkmate::assert_character(query[["table"]], len = 1L, null.ok = FALSE,
                                any.missing = FALSE)
  }

  ## re-login if the connection has been closed from previous query
  tmp_login <- as.list(login)
  if (exists("login") && !tmp_login[["valid"]]) {
    connection_params <- attr(login, "credentials")
    login <- login(
      from = connection_params[["host"]],
      type = connection_params[["type"]],
      user_name = connection_params[["user"]],
      password = connection_params[["password"]],
      driver_name = connection_params[["driver"]],
      db_name = connection_params[["db_name"]],
      port = connection_params[["port"]]
    )
  }
  if (!inherits(login, "Pool")) {
    cli::cli_abort(c(
      x = "Invalid connection object!",
      i = "Use the {.fn login} function to establish the connection to the \\
           database."
    ))
  }

  # When the query parameter is a list, the below function will be used
  # construct the SQL query to be used to fetch the data from the specified
  # table
  if (is.list(query)) {
    query <- server_make_query(
      login = login,
      table_name = query[["table"]],
      filter = query[["filter"]],
      select = query[["fields"]]
    )
  }

  # fetch the data using the SQL query
  final_data <- server_fetch_data(login = login, query = query)

  # return the datasets of interest
  return(final_data)
}
