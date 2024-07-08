
#' Establish a connection to a HIS of interest.
#'
#' The current version of the package supports basic authentication (using the
#' username and password) and personal authentication key (using API key and
#' bearer token)
#'
#' @param from The URL to the HIS of interest. For APIs, this must include both
#'    the base URL and the endpoint (required).
#' @param type The source name (required). The current version of the package
#'    covers the following HIS: "MS SQL", "MySQL", "PostgreSQL", "SQLite",
#'    "REDCap", "DHIS2", "ODK", "Fingertips", "goData".
#' @param user_name The user name (optional).
#' @param password The user's password or API token or key (optional). When the
#'    password is set to `NULL`, the user will be prompt to enter the password,
#'    hence minimizing the exposition of your full credentials.
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
#'     base_url  = file.path("https:/", "play.dhis2.org", "dev", "api", "me"),
#'     user_name = "admin",
#'     password  = NULL
#'   )
#' }
#'
#' # TO DO: investigate the authentication endpoint for the API of the other
#' # HIS'.
authenticate <- function(from,
                         type        = c("MS SQL", "MySQL", "PostgreSQL",
                                         "SQLite", "REDCap", "DHIS2", "ODK",
                                         "Fingertips", "goData", "SORMAS",
                                         "Globaldothealth"),
                         user_name   = NULL,
                         password    = NULL,
                         driver_name = NULL,
                         db_name     = NULL,
                         port        = NULL) {

  checkmate::assert_character(from, null.ok = FALSE, any.missing = FALSE,
                              min.len = 1L)
  type <- match.arg(type)
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
    con <- switch(
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
    attr(con, "credentials") <- list(
      user     = user_name,
      password = password,
      host     = from,
      db_name  = db_name,
      driver   = driver_name,
      port     = port,
      type     = type
    )
    return(invisible(con))
  } else {
    if (!is.null(password)) {
      warning("We recommend using 'password = NULL' and enter the password ",
              "in the prompt.", call. = FALSE)
    }
    if (grep("[:alnum:]", password) && nchar(password) == 32L) {
      # when this condition is met, the password corresponds to the token
      response <- httr2::request(from) |>
        httr2::req_auth_bearer_token(token = password)
    } else {
      response <- httr2::request(from) |>
        httr2::req_auth_basic(username = user_name, password = password)
    }
    message("\nLogged in successfully!")
    return(invisible(response))
  }
}
