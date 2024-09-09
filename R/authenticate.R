#' Establish a connection to a HIS of interest.
#'
#' The current version of the package supports basic authentication (using the
#' username and password) and personal authentication key (using API key and
#' bearer token)
#'
#' @param from The URL to the HIS of interest. For APIs, this must include both
#'    the base URL and the endpoint (required).
#' @param type The source name (optional). This is only needed when importing
#'    data from RDBMS. The current version of the package covers the following
#'    types: "SQLServer", "MySQL", "PostgreSQL", "SQLite".
#' @param user_name The user name (optional).
#' @param password The user's password or personal access token (PAT) or key
#'    (optional). When the password is set to `NULL`, the user will be prompt to
#'    enter the password, hence minimizing the exposition of your full
#'    credentials.
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
#'   conn <- authenticate(
#'     from        = "mysql-rfam-public.ebi.ac.uk",
#'     type        = "MySQL",
#'     user_name   = "rfamro",
#'     password    = "",
#'     driver_name = "",
#'     db_name     = "Rfam",
#'     port        = 4497
#'   )
#' }
#'
#' # connect to the test DHIS2 server
#' \dontrun{
#'   conn <- authenticate(
#'     from  = file.path("https:/", "play.dhis2.org", "dev", "api", "me"),
#'     user_name = "admin",
#'     password  = NULL
#'   )
#' }
#'
authenticate <- function(from,
                         type        = NULL,
                         user_name   = NULL,
                         password    = NULL,
                         driver_name = NULL,
                         db_name     = NULL,
                         port        = NULL) {

  checkmate::assert_character(from, null.ok = FALSE, any.missing = FALSE,
                              min.len = 1L)
  checkmate::assert_choice(type,
                           choices = c("MS SQL", "MySQL", "PostgreSQL",
                                       "SQLite", "REDCap", "DHIS2"),
                           null.ok = TRUE)
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
  if (!is.null(db_name) && !is.null(port)) {
    conn <- switch(
      type,
      SQLServer  = pool::dbPool(odbc::odbc(),
                                driver   = driver_name,
                                server   = from,
                                database = db_name,
                                uid      = user_name,
                                pwd      = password,
                                port     = port),
      PostgreSQL = pool::dbPool(odbc::odbc(),
                                driver   = driver_name,
                                host     = from,
                                database = db_name,
                                uid      = user_name,
                                pwd      = password,
                                port     = port),
      MySQL      = pool::dbPool(drv = RMySQL::MySQL(),
                                driver   = driver_name,
                                host     = from,
                                dbname   = db_name,
                                username = user_name,
                                password = password,
                                port     = port) ,
      SQLite     = pool::dbPool(drv    = RSQLite::SQLite(),
                                dbname = db_name)
    )

    ## Saving the credentials as attributes of the output object. They will be
    ## used to establish the connection in a subsequent query.
    attr(conn, "credentials") <- list(
      user     = user_name,
      password = password,
      host     = from,
      db_name  = db_name,
      driver   = driver_name,
      port     = port,
      type     = type
    )
  } else {
    # Entering this branch means, data is fetched from an API. We will determine
    # the authentication method based on which arguments are provided.

    # basic authentication requires a user name and password
    if (all(!is.null(user_name) && !is.null(password))) {
      conn <- httr2::request(from) |>
        httr2::req_auth_basic(username = user_name, password = password)
    }

    # bearer token authentication requires a token but not a user name
    if (all(!is.null(password) && is.null(user_name))) {
      conn <- httr2::request(from) |>
        httr2::req_auth_bearer_token(token = password)
    }
  }
  return(invisible(conn))
}
