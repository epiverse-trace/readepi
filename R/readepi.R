#' Import data from different sources into R
#'
#' @description the function allows import of data from Health Information
#' Systems (HIS), files, and folders.The HIS consist of database management
#' systems (DBMS) and website of public data collection.
#'
#' @param from either the the URL of the HIS or the path to the file or
#' directory of interest otherwise.
#' @param records a vector or a comma-separated string of subject IDs.
#'    When specified, only these records will be imported.
#' @param fields a vector or a comma-separated string of column names.
#'    If provided, only those columns will be imported.
#' @param id_position the column position of the variable that unique identifies
#'    the subjects. When the name of the column with the subject IDs is known,
#'    this can be provided using the `id_col_name` argument
#' @param id_col_name the column name with the subject IDs.
#' @param ... additional arguments passed to the `readepi()` function. These are
#'    enumerated and described in the vignette.
#' @examples
#' # reading from a MySQL server
#' data <- readepi(
#'   from             = "mysql-rfam-public.ebi.ac.uk",
#'   credentials_file = system.file("extdata", "test.ini", package = "readepi"),
#'   driver_name      = "",
#'   source           = "author"
#' )
#' @returns a `list` of 1 or several object of type `data frame`.
#' @export
readepi <- function(from = NULL,
                    records = NULL,
                    fields = NULL,
                    id_position = NULL,
                    id_col_name = NULL,
                    ...) {
  # check the input arguments
  checkmate::assert_character(from, null.ok = TRUE, any.missing = FALSE,
                              min.len = 0)
  checkmate::assert_vector(records,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(fields,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(id_position,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = FALSE
  )
  checkmate::assert_vector(id_col_name,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = TRUE
  )

  # get the additional arguments
  args_list <- list(...)

  # reading from file
  if (all(!is.null(from) && any(file.exists(from) || dir.exists(from)))) {
    args <- get_read_file_args(args_list)
    res  <- read_from_file(
      file_path    = from,
      sep          = args$sep,
      format       = args$format,
      which        = args$which,
      pattern      = args$pattern
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
    res  <- read_from_fingertips(
      indicator_id        = args$indicator_id,
      indicator_name      = args$indicator_name,
      area_type_id        = args$area_type_id,
      parent_area_type_id = args$parent_area_type_id,
      profile_id          = args$profile_id,
      profile_name        = args$profile_name,
      domain_id           = args$domain_id,
      domain_name         = args$domain_name,
      fields              = fields,
      records             = records,
      id_position         = id_position,
      id_col_name         = id_col_name
    )
  }

  # reading from DBMS
  if ("credentials_file" %in% names(args_list)) {
    credentials <- read_credentials(args_list$credentials_file, from)
    if (credentials$dbms == "REDCap") {
      res <- read_from_redcap(
        uri         = credentials$host,
        token       = credentials$pwd,
        id_position = id_position,
        id_col_name = id_col_name,
        records     = records,
        fields      = fields
      )
    } else if (credentials$dbms %in% c("MySQL", "SQLServer", "PostgreSQL")) {
      source      <- NULL
      driver_name <- ""
      if ("source" %in% names(args_list)) {
        source <- args_list$source
      }
      if ("driver_name" %in% names(args_list)) {
        driver_name <- args_list$driver_name
      }
      res <- sql_server_read_data(
        user          = credentials$user,
        password      = credentials$pwd,
        host          = credentials$host,
        port          = credentials$port,
        database_name = credentials$project,
        source        = source,
        driver_name   = driver_name,
        records       = records,
        fields        = fields,
        id_position   = id_position,
        id_col_name   = id_col_name,
        dbms          = credentials$dbms
      )
    } else if (credentials$dbms %in% c("dhis2", "DHIS2")) {
      tmp_attributes <- get_attributes_from_user(args_list)
      res            <- read_from_dhis2(
        base_url           = credentials$host,
        user_name          = credentials$user,
        password           = credentials$pwd,
        dataset            = tmp_attributes$dataset,
        organisation_unit  = tmp_attributes$organisation_unit,
        data_element_group = tmp_attributes$data_element_group,
        start_date         = tmp_attributes$start_date,
        end_date           = tmp_attributes$end_date,
        records            = records,
        fields             = fields,
        id_col_name        = id_col_name
      )
    }
  }

  res
}
