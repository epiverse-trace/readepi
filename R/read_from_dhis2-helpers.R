#' Check DHIS2 authentication details
#'
#' If the user were granted with access to the API, this will return a message
#' specifying that the user was successfully connected. Otherwise, it will throw
#' an error message.
#'
#' @param base_url the base URL of the DHIS2 server
#' @param user_name the user name
#' @param password the user's password
#'
#' @return a message if the dhis2_login was successful,
#'    throws an error otherwise.
#'
#' @return a message if the login was successful, throws an error otherwise.
#'
#' @keywords internal
#' @examples
#' \dontrun{
#'   dhis2_login(
#'     base_url  = file.path("https:/", "play.dhis2.org", "dev"),
#'     user_name = "admin",
#'     password  = "district"
#'   )
#' }
dhis2_login <- function(base_url,
                        user_name,
                        password) {
  url  <- file.path(base_url, "api", "me")
  resp <- httr2::request(url) %>%
    httr2::req_auth_basic(user_name, password) %>%
    httr2::req_perform()
  message("\nLogged in successfully!")
  invisible(resp)
}

#' Subset fields when reading from DHIS2
#'
#' @param fields vector of fields to select from the data frame
#' @param data the input data frame
#'
#' @return an object of type `data.frame` with the data that contains only the
#'    fields of interest.
#' @examples
#' \dontrun{
#' results <- dhis2_subset_fields(
#'   data = readepi(
#'     credentials_file = system.file("extdata", "test.ini",
#'                                      package = "readepi"),
#'     data_source      = "https://play.dhis2.org/dev",
#'     query_parameters = list(
#'         dataSet   = "pBOMPrpg1QX,BfMAe6Itzgt",
#'         orgUnit   = "DiszpKrYNg8",
#'         startDate = "2014",
#'         endDate   = "2023")
#'   )$data,
#'   fields             = c("dataElement", "period", "value")
#' )
#' }
#' @keywords internal
#'
dhis2_subset_fields <- function(data,
                                fields = c("dataElement", "period", "value")) {
  checkmate::assert_data_frame(data,
                               min.rows = 1L, null.ok = FALSE,
                               min.cols = 1L)
  if (!is.null(fields)) {
    if (is.character(fields)) {
      fields <- unlist(strsplit(fields, ",",
                                fixed = TRUE))
    }
    idx      <- which(fields %in% names(data))
    if (length(idx) == 0L) {
      stop("Specified column not found!",
           "The data contains the following columns: ", names(data))
    }
    if (length(idx) != length(fields)) {
      warning("The following fields were not found in the data: ", fields[-idx])
      fields <- fields[idx]
    }
    data     <- data %>% dplyr::select(dplyr::all_of(fields))
  }

  data
}


#' Subset a specified set of records from a dataset imported from DHIS2
#'
#' @param records a vector of records to select from the data
#' @param id_col_name the column name where the records belong to
#' @param data the input data frame
#'
#' @return an object of type `data.frame` with the data that contains only the
#'    records of interest.
#' @examples
#' \dontrun{
#' result <- dhis2_subset_records(
#'   data = readepi(
#'     credentials_file = system.file("extdata", "test.ini",
#'                                    package = "readepi"),
#'     data_source      = "https://play.dhis2.org/dev",
#'     query_parameters = list(
#'         dataSet   = "pBOMPrpg1QX",
#'         orgUnit   = "DiszpKrYNg8",
#'         startDate = "2014",
#'         endDate   = "2023")
#'   )$data,
#'   records            = c("FTRrcoaog83", "eY5ehpbEsB7", "Ix2HsbDMLea"),
#'   id_col_name        = "dataElement"
#' )
#' }
#' @keywords internal
#'
dhis2_subset_records <- function(data,
                                 records,
                                 id_col_name = "dataElement") {
  checkmate::assert_data_frame(data,
                               min.rows = 1L, null.ok = FALSE,
                               min.cols = 1L)
  if (!is.null(records)) {
    if (is.character(records)) {
      records      <- unlist(strsplit(records, ",", fixed = TRUE))
    }
    id_column_name <- id_col_name
    idx            <- which(records %in% data[[id_column_name]])
    if (length(idx) == 0L) {
      stop("Speficied records not found in column: ", id_column_name)
    } else if (length(idx) < length(records)) {
      warning("The following records were not found: ", records[-idx])
      records      <- records[idx]
    }
    data           <- data[which(data[[id_column_name]] %in% records), ]
  }
  data
}

#' Get the DHIS2 query parameters from the user
#'
#' @param args_list a `list` of parameters provided by the user
#'
#' @return an object of type `list` with the values for the DHIS2 query
#'    parameters or NULL if they were not specified (i.e. not reading from
#'    DHIS2)
#' @keywords internal
#'
dhis2_get_query_params <- function(args_list) {
  query_parameters <- NULL
  if ("query_parameters" %in% names(args_list)) {
    query_parameters <- args_list[["query_parameters"]]
  }
  return(query_parameters)
}
