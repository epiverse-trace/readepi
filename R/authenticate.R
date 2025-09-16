#' Establish a connection to the HIS of interest.
#'
#' The current version of the package supports basic authentication (using the
#' username and password) and personal authentication key (using API key and
#' bearer token).
#'
#' @param from The URL to the HIS of interest. For APIs, this must be the base
#'    URL (required).
#' @param type The source name (required). The current version of the package
#'    covers the following RDBMS and HIS types: "ms sql", "mysql", "postgresql",
#'    "sqlite", "dhis2", and "sormas".
#' @param user_name The user name (optional).
#' @param password The user's password (optional). When the password is not
#'    provided (set to `NULL`), the user will be prompt to enter the password.
#'
#' @param driver_name The driver name (optional). This is only needed for
#'    connecting to RDBMS only.
#' @param db_name The database name (optional). This is only needed for
#'    connecting to RDBMS only.
#' @param port The port ID (optional). This is only needed for connecting to
#'    RDBMS only.
#'
#' @returns A connection object
#' @export
#'
#' @examples
#' # connect to the test MySQL server
#' \dontrun{
#'   login <- login(
#'     from = "mysql-rfam-public.ebi.ac.uk",
#'     type = "mysql",
#'     user_name = "rfamro",
#'     password = "",
#'     driver_name = "",
#'     db_name = "Rfam",
#'     port = 4497
#'   )
#' }
#'
#' # connect to a DHIS2 instance
#' \dontrun{
#'   dhi2s_login <- login(
#'     type = "dhis2",
#'     from = "https://smc.moh.gm/dhis",
#'     user_name = "test",
#'     password = "Gambia@123"
#'   )
#' }
#'
#' # connect to SORMAS
#' \dontrun{
#'   sormas_login <- login(
#'     type = "sormas",
#'     from = "https://demo.sormas.org/sormas-rest",
#'     user_name = "SurvSup",
#'     password = "Lk5R7JXeZSEc"
#'   )
#' }
#'
login <- function(from,
                  type,
                  user_name = NULL,
                  password = NULL,
                  driver_name = NULL,
                  db_name = NULL,
                  port = NULL) {

  checkmate::assert_character(from, null.ok = FALSE, any.missing = FALSE,
                              len = 1L)
  type <- tolower(type)
  checkmate::assert_choice(type,
                           choices = c("ms sql", "mysql", "postgresql",
                                       "sqlite", "dhis2", "sormas"),
                           null.ok = FALSE)
  checkmate::assert_character(user_name, null.ok = TRUE, any.missing = FALSE,
                              min.len = 0L)
  checkmate::assert_character(password, null.ok = TRUE, any.missing = FALSE,
                              min.len = 0L)
  checkmate::assert_character(driver_name, null.ok = TRUE, any.missing = FALSE,
                              min.len = 0L)
  checkmate::assert_character(db_name, null.ok = TRUE,
                              any.missing = FALSE, min.len = 0L)
  checkmate::assert_numeric(port, null.ok = TRUE, any.missing = FALSE,
                            min.len = 0L)
  url_check(from)
  if (type %in% c("ms sql", "mysql", "postgresql", "sqlite")) {
    conn <- switch(
      type,
      "ms sql" = pool::dbPool(odbc::odbc(),
                              driver = driver_name,
                              server = from,
                              database = db_name,
                              uid = user_name,
                              pwd = password,
                              port = port),
      postgresql = pool::dbPool(odbc::odbc(),
                                driver = driver_name,
                                host = from,
                                database = db_name,
                                uid = user_name,
                                pwd = password,
                                port = port),
      mysql = pool::dbPool(drv = RMySQL::MySQL(),
                           driver = driver_name,
                           host = from,
                           dbname = db_name,
                           username = user_name,
                           password = password,
                           port = port),
      sqlite = pool::dbPool(drv = RSQLite::SQLite(),
                            dbname = db_name)
    )
    ## Saving the credentials as attributes of the output object. They will be
    ## used to establish the connection in a subsequent query.
    attr(conn, "credentials") <- list(
      user = user_name,
      password = password,
      host = from,
      db_name = db_name,
      driver = driver_name,
      port = port,
      type = type
    )
    cli::cli_alert_success("Logged in successfully!")
  } else {
    # Entering this branch means, data is fetched from an API. We will determine
    # the authentication method based on which arguments are provided.
    if (is.null(user_name)) {
      cli::cli_abort(c(
        x = "{.strong user_name} must be provided."
      ))
    }
    conn <- switch(type,
      dhis2 = dhis2_login(
        base_url = from,
        user_name = user_name,
        password = password
      ),
      sormas = list(
        base_url = from,
        user_name = user_name,
        password = password
      )
    )

  }
  return(invisible(conn))
}
