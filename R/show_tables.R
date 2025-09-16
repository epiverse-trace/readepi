#' Display the list of tables in a database
#'
#' @inheritParams read_rdbms
#' @examples
#' \dontrun{
#' # connect to the test MySQL server
#'   rdbms_login <- login(
#'     from        = "mysql-rfam-public.ebi.ac.uk",
#'     type        = "mysql",
#'     user_name   = "rfamro",
#'     password    = "",
#'     driver_name = "",
#'     db_name     = "Rfam",
#'     port        = 4497
#'   )
#'
#' # display the list of available tables from this database
#' tables <- show_tables(login = rdbms_login)
#' }
#' @returns a `character` that contains the list of all tables found
#'     in the specified database.
#' @export
#'
show_tables <- function(login) {
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

  # listing the names of the tables present in the database
  tables <- DBI::dbListTables(conn = login)

  return(tables)
}
