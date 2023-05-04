#' Read credentials from a configuration file
#'
#' @param file_path the path to the file with the user-specific credential
#' details for the projects of interest.
#' @param project_id for relational DB, this is the name of the database
#' that contains the table from which the data should be pulled. Otherwise,
#' it is the project ID you were given access to.
#' @returns  a list with the user credential details.
#' @examples
#' \dontrun{
#' credentials <- read_credentials(
#'   file_path = system.file("extdata", "test.ini", package = "readepi"),
#'   project_id = "Rfam"
#' )
#' }
#' @export
read_credentials <- function(file_path = system.file("extdata", "test.ini",
                                                     package = "readepi"),
                             project_id = NULL) {
  checkmate::assertCharacter(file_path, len = 1L, null.ok = FALSE)
  checkmate::assert_file_exists(file_path)
  checkmate::assertCharacter(project_id, len = 1L, null.ok = FALSE)
  if (!file.exists(file_path) || is.null(file_path)) {
    stop("Could not find ", file_path)
  }
  if (is.null(project_id)) {
    stop("Database name or project ID not specified!")
  }

  credentials <- data.table::fread(file_path, sep = "\t")
  if (ncol(credentials) != 7) {
    stop("credential file should be tab-separated file with 7 columns.")
  }
  if (!all((names(credentials) %in%
            c("user_name", "password", "host_name", "project_id", "comment",
              "dbms", "port")))) {
    stop("Incorrect column names found in provided credentials file.\nThe column
         names should be 'user_name', 'password', 'host_name', 'project_id',
         'comment', 'dbms', 'port'")
  }
  idx <- which(credentials$project_id == project_id)
  if (length(idx) == 0) {
    stop("Credential details for ", project_id, " not found in
         credential file.")
  } else if (length(idx) > 1) {
    stop("Multiple credential lines found for the specified project ID.\n
         Credentials file should contain one line per project.")
  } else {
    project_credentials <- list(
      user = credentials$user_name[idx],
      pwd = credentials$password[idx],
      host = credentials$host_name[idx],
      project = credentials$project_id[idx],
      dbms = credentials$dbms[idx],
      port = credentials$port[idx]
    )
  }
  project_credentials
}

#' Get arguments for reading from files
#'
#' @param args_list a list of user specified arguments
#'
#' @return a list of the parameters to be used for reading from file
#' @examples
#' args_list <- get_read_file_args(
#'  list(
#'    sep = "\t",
#'    format = ".txt",
#'    which = NULL
#'  )
#' )
#'
get_read_file_args <- function(args_list) {
  checkmate::assert_list(args_list)
  if ("sep" %in% names(args_list)) {
    sep <- args_list$sep
  } else {
    sep <- NULL
  }
  if ("format" %in% names(args_list)) {
    format <- args_list$format
  } else {
    format <- NULL
  }
  if ("which" %in% names(args_list)) {
    which <- args_list$which
  } else {
    which <- NULL
  }
  if ("pattern" %in% names(args_list)) {
    pattern <- args_list$pattern
  } else {
    pattern <- NULL
  }

  list(
    sep = sep,
    format = format,
    which = which,
    pattern = pattern
  )
}

#' Get arguments for reading from Fingertips
#'
#' @param args_list a list of user specified arguments
#'
#' @return a list of the parameters to be used for reading from Fingertips
#' @examples
#' args_list <- get_read_fingertips_args(
#'  list(
#'    indicator_id = 90362,
#'    area_type_id = 202
#'  )
#' )
#'
get_read_fingertips_args <- function(args_list) {
  checkmate::assert_list(args_list)
  if ("indicator_id" %in% names(args_list)) {
    indicator_id <- args_list$indicator_id
  } else {
    indicator_id <- NULL
  }
  if ("indicator_name" %in% names(args_list)) {
    indicator_name <- args_list$indicator_name
  } else {
    indicator_name <- NULL
  }
  if ("area_type_id" %in% names(args_list)) {
    area_type_id <- args_list$area_type_id
  } else {
    area_type_id <- NULL
  }
  if ("profile_id" %in% names(args_list)) {
    profile_id <- args_list$profile_id
  } else {
    profile_id <- NULL
  }
  if ("profile_name" %in% names(args_list)) {
    profile_name <- args_list$profile_name
  } else {
    profile_name <- NULL
  }
  if ("domain_id" %in% names(args_list)) {
    domain_id <- args_list$domain_id
  } else {
    domain_id <- NULL
  }
  if ("domain_name" %in% names(args_list)) {
    domain_name <- args_list$domain_name
  } else {
    domain_name <- NULL
  }
  if ("parent_area_type_id" %in% names(args_list)) {
    parent_area_type_id <- args_list$parent_area_type_id
  } else {
    parent_area_type_id <- NULL
  }

  list(
    indicator_id = indicator_id,
    indicator_name = indicator_name,
    area_type_id = area_type_id,
    profile_id = profile_id,
    profile_name = profile_name,
    domain_id = domain_id,
    domain_name = domain_name,
    parent_area_type_id = parent_area_type_id
  )
}
