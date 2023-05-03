#' Import data from different sources into R
#'
#' @description the function allows import of data from files, folders, or
#' health information systems (HIS)
#' The HIS consist of database management systems (DBMS) and website of public
#' data collection.
#'
#' @param credentials_file the path to the file with the user-specific
#' credential details
#' for the projects of interest. It is required when importing data from DBMS.
#' This is a tab-delimited file with the following columns:
#' \enumerate{
#'   \item user_name: the user name
#'   \item password: the user password (for REDCap, this corresponds to the
#'   **token** that serves as password to the project)
#'   \item host_name: the host name (for MS SQL servers) or the URI (for REDCap)
#'   \item project_id: the project ID or the name of the database
#'   you are access to.
#'   \item comment: a summary description about the project or database
#'   of interest
#'   \item dbms: the name of the DBMS: Possible values are: 'REDCap',
#'   'SQLServer', 'MySQL', 'PostgreSQL', etc...
#'   \item port: the port ID
#'   }
#' Use the `show_example_file()` function to display the structure of
#' the template credentials file
#' @param file_path the path to the file to be read. When several files need to
#' be imported from a directory, this should be the path to that directory
#' @param records a vector or a comma-separated string of subject IDs.
#' When specified, only these records will be imported.
#' @param fields a vector or a comma-separated string of column names.
#' If provided, only those columns will be imported.
#' @param id_position the column position of the variable that unique identifies
#' the subjects. When the name of the column with the subject IDs is known,
#' this can be provided using the `id_col_name` argument
#' @param id_col_name the column name with the subject IDs.
#' @param ... additional arguments passed to the readepi function.
#' These are enumarated in the vignette.
#' @examples
#' # reading from a MS SQL server
#' data <- readepi(
#'   credentials_file = system.file("extdata", "test.ini", package = "readepi"),
#'   project_id = "Rfam",
#'   driver_name = "",
#'   table_name = "author"
#' )
#' @returns a list of data frames.
#' @export
readepi <- function(credentials_file = NULL,
                    file_path = NULL,
                    records = NULL,
                    fields = NULL,
                    id_position = NULL,
                    id_col_name = NULL,
                    ...) {
  # check the input arguments
  checkmate::assertCharacter(credentials_file, len = 1L, null.ok = TRUE)
  checkmate::assertCharacter(file_path, len = 1L, null.ok = TRUE)
  checkmate::assert_vector(records,
    any.missing = FALSE, min.len = 1,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(fields,
    any.missing = FALSE, min.len = 1,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(id_position,
    any.missing = FALSE, min.len = 1,
    null.ok = TRUE, unique = FALSE
  )
  checkmate::assert_vector(id_col_name,
    any.missing = FALSE, min.len = 1,
    null.ok = TRUE, unique = TRUE
  )

  # get the additional arguments
  args_list <- list(...)

  # some check points
  if (all(!is.null(credentials_file) & !is.null(file_path))) {
    stop("Impossible to import data from DBMS and file at the same time.")
  }

  # reading from file
  if (!is.null(file_path)) {
    args <- get_read_file_args(args_list)
    res <- read_from_file(file_path,
      sep = args$sep, format = args$format,
      which = args$which, pattern = args$pattern
    )
  }

  # reading from Fingertips
  if (any("indicator_id" %in% names(args_list) |
    "indicator_name" %in% names(args_list) |
    "area_type_id" %in% names(args_list) |
    "profile_id" %in% names(args_list) |
    "profile_name" %in% names(args_list) |
    "domain_id" %in% names(args_list) |
    "domain_name" %in% names(args_list))) {
    args <- get_read_fingertips_args(args_list)
    res <- read_from_fingertips(
      indicator_id = args$indicator_id, indicator_name = args$indicator_name,
      area_type_id = args$area_type_id,
      parent_area_type_id = args$parent_area_type_id,
      profile_id = args$profile_id, profile_name = args$profile_name,
      domain_id = args$domain_id, domain_name = args$domain_name,
      fields = fields, records = records,
      id_position = id_position, id_col_name = id_col_name
    )
  }

  # reading from DBMS
  if (!is.null(credentials_file)) {
    project_id <- ifelse("project_id" %in% names(args_list),
                        args_list$project_id,
                        stop("The project ID/database name must be provided
                        to read data from DBMS."))
    credentials <- read_credentials(credentials_file, project_id)
    if (credentials$dbms == "REDCap") {
      res <- read_from_redcap(
        uri = credentials$host, token = credentials$pwd,
        id_position = id_position, id_col_name = id_col_name,
        records = records, fields = fields
      )
    } else if (credentials$dbms %in% c("MySQL", "SQLServer", "PostgreSQL")) {
      if ("source" %in% names(args_list)) {
        source <- args_list$source
      } else {
        source <- NULL
      }
      if ("driver_name" %in% names(args_list)) {
        driver_name <- args_list$driver_name
      } else {
        driver_name <- ""
      }
      res <- sql_server_read_data(
        user = credentials$user, password = credentials$pwd,
        host = credentials$host, port = credentials$port,
        database_name = credentials$project, source =  source,
        driver_name = driver_name, records = records, fields = fields,
        id_position = id_position, id_col_name = id_col_name,
        dbms = credentials$dbms
      )
    } else if (credentials$dbms %in% c("dhis2", "DHIS2")) {
      if ("dataset" %in% names(args_list)) {
        dataset <- args_list$dataset
      } else {
        dataset <- NULL
      }
      if ("organisation_unit" %in% names(args_list)) {
        organisation_unit <- args_list$organisation_unit
      } else {
        organisation_unit <- NULL
      }
      if ("data_element_group" %in% names(args_list)) {
        data_element_group <- args_list$data_element_group
      } else {
        data_element_group <- NULL
      }
      if ("start_date" %in% names(args_list)) {
        start_date <- args_list$start_date
      } else {
        start_date <- NULL
      }
      if ("end_date" %in% names(args_list)) {
        end_date <- args_list$end_date
      } else {
        end_date <- NULL
      }
      res <- read_from_dhis2(
        base_url = credentials$host, user_name = credentials$user,
        password = credentials$pwd, dataset = dataset,
        organisation_unit = organisation_unit,
        data_element_group = data_element_group,
        start_date = start_date, end_date = end_date,
        records = records, fields = fields,
        id_col_name = id_col_name
      )
    }
  }

  res
}
