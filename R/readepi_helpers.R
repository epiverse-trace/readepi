#' Read credentials from a configuration file
#'
#' @param file_path the path to the file with the user-specific credential
#'    details for the projects of interest.
#' @param base_url the URL of the HIS of interest
#'
#' @returns a `list` of 5 elements of type `character` and `numeric`. These
#'    correspond to the user's credential details.
#' @examples
#' \dontrun{
#' credentials <- read_credentials(
#'   file_path = system.file("extdata", "test.ini", package = "readepi"),
#'   base_url  = "mysql-rfam-public.ebi.ac.uk"
#' )
#' }
#' @keywords internal
#' @importFrom utils read.table
read_credentials <- function(file_path, base_url) {
  url_check(base_url)
  checkmate::assert_file(file_path)

  credentials <- read.table(file_path, sep = "\t", header = TRUE)
  if (ncol(credentials) != 7L) {
    stop("credential file should be a tab-separated file with 7 columns.")
  }
  if (!all((names(credentials) %in%
              c("user_name", "password", "host_name", "project_id", "comment",
                "dbms", "port")))) {
    stop("Incorrect column names found in provided credentials file.\nThe column
         names should be 'user_name', 'password', 'host_name', 'project_id',
         'comment', 'dbms', 'port'")
  }
  idx <- which(credentials[["host_name"]] == base_url)
  if (length(idx) == 0L) {
    stop("Credential details for ", base_url, " not found in
         credential file.")
  } else if (length(idx) > 1L) {
    stop("Multiple credential lines found for the specified URL.\n
         Credentials file should contain one line per project.")
  } else {
    project_credentials <- list(
      user    = credentials[["user_name"]][idx],
      pwd     = credentials[["password"]][idx],
      host    = credentials[["host_name"]][idx],
      project = credentials[["project_id"]][idx],
      dbms    = credentials[["dbms"]][idx],
      port    = credentials[["port"]][idx]
    )
  }
  project_credentials
}

#' Get arguments for reading from Fingertips
#'
#' @param args_list a `list` of user specified arguments
#'
#' @return a `list` of 8 elements of type `character` and `numeric` that will be
#'    used for importing data from Fingertips
#' @keywords internal
#' @examples
#' \dontrun{
#'   res <- fingertips_get_args(
#'     list(indicator_id   = 90362L,
#'          area_type_id   = 202L,
#'          indicator_name = "Healthy life expectancy at birth",
#'          profile_id     = 19L)
#'   )
#' }
#'
fingertips_get_args <- function(args_list =
                                  list(indicator_id        = NULL,
                                       indicator_name      = NULL,
                                       area_type_id        = NULL,
                                       profile_id          = NULL,
                                       profile_name        = NULL,
                                       domain_id           = NULL,
                                       domain_name         = NULL,
                                       parent_area_type_id = NULL)) {
  checkmate::assert_list(args_list)
  if ("indicator_id" %in% names(args_list)) {
    indicator_id <- args_list[["indicator_id"]]
  } else {
    indicator_id <- NULL
  }
  if ("indicator_name" %in% names(args_list)) {
    indicator_name <- args_list[["indicator_name"]]
  } else {
    indicator_name <- NULL
  }
  if ("area_type_id" %in% names(args_list)) {
    area_type_id <- args_list[["area_type_id"]]
  } else {
    area_type_id <- NULL
  }
  if ("profile_id" %in% names(args_list)) {
    profile_id <- args_list[["profile_id"]]
  } else {
    profile_id <- NULL
  }
  if ("profile_name" %in% names(args_list)) {
    profile_name <- args_list[["profile_name"]]
  } else {
    profile_name <- NULL
  }
  if ("domain_id" %in% names(args_list)) {
    domain_id <- args_list[["domain_id"]]
  } else {
    domain_id <- NULL
  }
  if ("domain_name" %in% names(args_list)) {
    domain_name <- args_list[["domain_name"]]
  } else {
    domain_name <- NULL
  }
  if ("parent_area_type_id" %in% names(args_list)) {
    parent_area_type_id <- args_list[["parent_area_type_id"]]
  } else {
    parent_area_type_id <- NULL
  }

  list(
    indicator_id        = indicator_id,
    indicator_name      = indicator_name,
    area_type_id        = area_type_id,
    profile_id          = profile_id,
    profile_name        = profile_name,
    domain_id           = domain_id,
    domain_name         = domain_name,
    parent_area_type_id = parent_area_type_id
  )
}

#' Check if the value for the base_url argument has a correct structure
#'
#' @param base_url the URL to the HIS of interest
#'
#' @returns throws an error if the domain of the provided URL is not valid,
#'    (invisibly) TRUE
#'
#' @keywords internal
#'
url_check <- function(base_url) {
  checkmate::assert_character(base_url, any.missing = FALSE, len = 1L,
                              null.ok = FALSE)
  regex  <- "^(https?://)?(www\\.)?([a-z0-9]([a-z0-9]|(\\-[a-z0-9]))*\\.)+[a-z]+$" # nolint: line_length_linter
  domain <- strsplit(gsub("^(https?://)?(www\\.)?", "", base_url),
                     "/", fixed = TRUE)[[c(1L, 1L)]]
  stopifnot("Incorrect domain name in provided URL!" = grepl(regex, domain))
  return(invisible(TRUE))
}
