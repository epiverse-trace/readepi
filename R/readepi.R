#' Import data from different sources into R
#' @description the function allows import of data from files or health information systems (HIS)
#' The HIS are database management systems (DBMS), both relational and NoSQL databases.
#' @param credentials.file the path to the file with the user-specific credential details
#' for the projects of interest. It is required when importing data from DBMS. This is a
#' tab-delimited file with the following columns:
#' \enumerate{
#'   \item user_name: the user name
#'   \item password: the user password (for REDCap, this corresponds to the **token** that serves as password to the project)
#'   \item host_name: the host name (for MS SQL servers) or the URI (for REDCap)
#'   \item project_id: the project ID or the name of the database you are access to.
#'   \item comment: a summary description about the project or database of interest
#'   \item dbms: the name of the DBMS: 'redcap' or 'REDCap' when reading from REDCap, 'sqlserver' or 'SQLServer' when reading from MS SQLServer
#'   \item port: the port ID (used for MS SQLServers)
#'   }
#' Use the `show_example_file()` function to display the structure of the template
#' credentials file
#' @param file.path the path to the file to be read. When several files need to be imported from a directory, this should be the path to that directory
#' @param sep the separator between the columns in the file. This is only required for space-separated files.
#' @param format a string used to specify the file format. This is useful when a file does not have an extension, or has a file extension that does not match its actual type
#' @param which a string used to specify which objects should be extracted (the name of the excel sheet to import)
#' @param pattern when specified, only files with this suffix will be imported from the specified directory
#' @param project.id for relational DB, this is the name of the database that contains the table from which the data should be pulled. Otherwise, it is the project ID you were given access to.
#' @param driver.name the name of the MS driver. use `odbc::odbcListDrivers()` to display the list of installed drivers
#' @param table.name the name of the target table
#' @param records a vector or a comma-separated string of subset of subject IDs. When specified, only the records that correspond to these subjects will be imported.
#' @param fields a vector or a comma-separated string of column names. If provided, only those columns will be imported.
#' @param id.position the column position of the variable that unique identifies the subjects. This should only be specified when the column with the subject IDs is not the first column. default is 1.
#' @examples
#' \dontrun{
#' data <- readepi(
#'   credentials.file = system.file("extdata", "test.ini", package = "readepi"),
#'   project.id = "my_project_id"
#' )
#' }
#' @returns a list with 2 data frames (data and metadata) when reading from REDCap. A data frame otherwise.
#' @export
readepi <- function(credentials.file = NULL,
                    file.path = NULL,
                    sep = NULL,
                    format = NULL,
                    which = NULL,
                    pattern = NULL,
                    project.id = NULL,
                    driver.name = NULL,
                    table.name = NULL,
                    records = NULL,
                    fields = NULL,
                    id.position = 1) {
  # check the input arguments
  checkmate::assertCharacter(credentials.file, len = 1L, null.ok = TRUE)
  checkmate::assertCharacter(file.path, len = 1L, null.ok = TRUE)
  checkmate::assertCharacter(sep, len = 1L, null.ok = TRUE, n.chars = 1)
  checkmate::assertCharacter(format, len = 1L, null.ok = TRUE)
  checkmate::assert_vector(which,
    any.missing = FALSE, min.len = 1,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assertCharacter(pattern, null.ok = TRUE, min.len = 1)
  checkmate::assertCharacter(project.id, len = 1L, null.ok = TRUE)
  checkmate::assert_character(driver.name, len = 1, null.ok = TRUE)
  checkmate::assert_vector(table.name,
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
  checkmate::assert_number(id.position, lower = 1)



  # some check points
  if (!is.null(credentials.file) & !is.null(file.path)) {
    stop("Impossible to import data from DBMS and file at the same time.")
  }

  # reading from file
  if (!is.null(file.path)) {
    res <- read_from_file(file.path, sep = sep, format = format, which = which, pattern = pattern)
  }

  # reading from DBMS
  if (!is.null(credentials.file)) {
    credentials <- read_credentials(credentials.file, project.id)
    if (credentials$dbms %in% c("redcap", "REDCap")) {
      res <- read_from_redcap(
        uri = credentials$host, token = credentials$pwd, id.position = id.position,
        records = records, fields = fields
      ) # project.id = credentials$project,
    } else if (credentials$dbms %in% c("sqlserver", "SQLServer")) {
      res <- read_from_ms_sql_server(
        user = credentials$user, password = credentials$pwd, host = credentials$host, port = credentials$port,
        database.name = credentials$project, table.names = table.name, driver.name = driver.name, records = records,
        fields = fields
      )
    }
    # else if(credentials$dbms %in% c('dhis2','DHIS2')){
    #   R.utils::cat("")
    #   res = read_from_dhis2(base.url=credentials$host, password=credentials$pwd,
    #                         user=credentials$user, project.id=credentials$project,
    #                         id.position=id.position, records=records, fields=fields)
    # }
  }

  res
}
