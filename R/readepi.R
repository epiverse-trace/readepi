#' Import data from different sources into R
#'
#' @description the function allows import of data from files, folders, or health information systems (HIS)
#' The HIS consist of database management systems (DBMS) and website of public data collection.
#'
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
#' @param records a vector or a comma-separated string of subject IDs. When specified, only these records will be imported.
#' @param fields a vector or a comma-separated string of column names. If provided, only those columns will be imported.
#' @param id.position the column position of the variable that unique identifies the subjects. When the name of the column with the subject IDs is known, this can be provided using the `id.col.name` argument
#' @param id.col.name the column name with the subject IDs.
#' @examples
#' # reading from a MS SQL server
#' data <- readepi(
#'   credentials.file = system.file("extdata", "test.ini", package = "readepi"),
#'   project.id = "TEST_READEPI",
#'   driver.name = "ODBC Driver 17 for SQL Server",
#'   table.name = "ebola"
#' )
#' @returns a list of data frames.
#' @export
readepi <- function(credentials.file = NULL,
                    file.path = NULL,
                    records = NULL,
                    fields = NULL,
                    id.position = NULL,
                    id.col.name = NULL,
                    ...) {
  # check the input arguments
  checkmate::assertCharacter(credentials.file, len = 1L, null.ok = TRUE)
  checkmate::assertCharacter(file.path, len = 1L, null.ok = TRUE)
  checkmate::assert_vector(records,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(fields,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(id.position,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = FALSE
  )
  checkmate::assert_vector(id.col.name,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = FALSE
  )

  # get the additional arguments
  args.list <- list(...)

  # some check points
  if (!is.null(credentials.file) & !is.null(file.path)) {
    stop("Impossible to import data from DBMS and file at the same time.")
  }

  # reading from file
  if (!is.null(file.path)) {
    if("sep" %in% names(args.list)){sep = args.list$sep} else {sep=NULL}
    if("format" %in% names(args.list)){format = args.list$format} else {format=NULL}
    if("which" %in% names(args.list)){which = args.list$which} else {which=NULL}
    if("pattern" %in% names(args.list)){pattern=args.list$pattern} else {pattern=NULL}
    res <- read_from_file(file.path, sep = sep, format = format,
                          which = which, pattern = pattern)
  }

  # reading from Fingertips
  if("indicator_id" %in% names(args.list) |
     "indicator_name" %in% names(args.list) |
     "area_type_id" %in% names(args.list) |
     "profile_id" %in% names(args.list) |
     "profile_name" %in% names(args.list) |
     "domain_id" %in% names(args.list) |
     "domain_name" %in% names(args.list)){
    if("indicator_id" %in% names(args.list)){indicator_id = args.list$indicator_id} else {indicator_id=NULL}
    if("indicator_name" %in% names(args.list)){indicator_name = args.list$indicator_name} else {indicator_name=NULL}
    if("area_type_id" %in% names(args.list)){area_type_id = args.list$area_type_id} else {area_type_id=NULL}
    if("profile_id" %in% names(args.list)){profile_id = args.list$profile_id} else {profile_id=NULL}
    if("profile_name" %in% names(args.list)){profile_name = args.list$profile_name} else {profile_name=NULL}
    if("domain_id" %in% names(args.list)){domain_id = args.list$domain_id} else {domain_id=NULL}
    if("domain_name" %in% names(args.list)){domain_name = args.list$domain_name} else {domain_name=NULL}
    if("parent_area_type_id" %in% names(args.list)){parent_area_type_id = args.list$parent_area_type_id} else {parent_area_type_id=NULL}
    res = read_from_fingertips(indicator_id=indicator_id, indicator_name=indicator_name,
                               area_type_id=area_type_id, parent_area_type_id=parent_area_type_id,
                               profile_id=profile_id, profile_name=profile_name,
                               domain_id=domain_id, domain_name=domain_name,
                               fields=fields, records=records,
                               id.position=id.position, id.col.name=id.col.name
                               )
  }

  # reading from DBMS
  if (!is.null(credentials.file)) {
    if("project.id" %in% names(args.list)){project.id = args.list$project.id}
    else {stop("The project ID/database name must be provided to read data from DBMS.")}
    credentials <- read_credentials(credentials.file, project.id)
    if (credentials$dbms %in% c("redcap", "REDCap")) {
      res <- read_from_redcap(
        uri = credentials$host, token = credentials$pwd,
        id.position = id.position, id.col.name = id.col.name,
        records = records, fields = fields
      )
    } else if (credentials$dbms %in% c("sqlserver", "SQLServer")) {
      if("table.name" %in% names(args.list)){table.name = args.list$table.name} else {table.name=NULL}
      if("driver.name" %in% names(args.list)){driver.name = args.list$driver.name} else {driver.name=NULL}
      res <- read_from_ms_sql_server(
        user = credentials$user, password = credentials$pwd,
        host = credentials$host, port = credentials$port,
        database.name = credentials$project, table.names = table.name,
        driver.name = driver.name, records = records, fields = fields,
        id.position = id.position, id.col.name = id.col.name
      )
    } else if (credentials$dbms %in% c("dhis2", "DHIS2")) {
      if("dataset" %in% names(args.list)){dataset = args.list$dataset} else {dataset=NULL}
      if("organisation.unit" %in% names(args.list)){organisation.unit = args.list$organisation.unit} else {organisation.unit=NULL}
      if("data.element.group" %in% names(args.list)){data.element.group = args.list$data.element.group} else {data.element.group=NULL}
      if("start.date" %in% names(args.list)){start.date = args.list$start.date} else {start.date=NULL}
      if("end.date" %in% names(args.list)){end.date = args.list$end.date} else {end.date=NULL}
      res <- read_from_dhis2(
        base.url = credentials$host, user.name = credentials$user,
        password = credentials$pwd, dataset = dataset,
        organisation.unit = organisation.unit,
        data.element.group = data.element.group,
        start.date = start.date, end.date = end.date,
        records = records, fields = fields,
        id.col.name = id.col.name
      )
    }
  }

  res
}
