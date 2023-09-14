#' Check DHIS2 authentication details
#'
<<<<<<< HEAD
#' If the user were granted with access to the API, this will return a message
#' specifying that the user was successfully connected. Otherwise, it will throw
#' an error message.
#'
=======
>>>>>>> main
#' @param username the user name
#' @param password the user's password
#' @param base_url the base URL of the DHIS2 server
#'
<<<<<<< HEAD
#' @keywords internal
#'
login <- function(username, password, base_url) {
  checkmate::assert_character(username,
                              len = 1L, any.missing = FALSE,
                              null.ok = FALSE
  )
  checkmate::assert_character(password,
                              len = 1L, any.missing = FALSE,
                              null.ok = FALSE
  )
  checkmate::assert_character(base_url,
                              len = 1L, any.missing = FALSE,
                              null.ok = FALSE
  )
  url <- file.path(base_url, "api", "me")
  resp <- httr::GET(url, httr::authenticate(username, password))
  httr::stop_for_status(resp)
  message("\nLogged in successfully!")
=======
login <- function(username, password, base_url) {
  checkmate::assertCharacter(base_url, len = 1L, null.ok = FALSE,
                             any.missing = FALSE)
  checkmate::assertCharacter(username, len = 1L, null.ok = FALSE,
                             any.missing = FALSE)
  checkmate::assertCharacter(password, len = 1L, null.ok = FALSE,
                             any.missing = FALSE)

  url <- file.path(base_url, "api", "me")
  resp <- httr::GET(url, httr::authenticate(username, password))
  httr::stop_for_status(resp)
  R.utils::cat("\nLogged in successfully!")
>>>>>>> main
}

#' Subset fields when reading from DHIS2
#'
#' @param fields vector of fields to select from the data frame
#' @param data the input data frame
#'
<<<<<<< HEAD
#' @return an object of type `data.frame` with the data that contains only the
#'    fields of interest
#' @examples
#' \dontrun{
#' results <- dhis2_subset_fields(
#'   data = readepi(
#'     credentials_file   = system.file("extdata", "test.ini",
#'     package = "readepi"),
#'     data_source        = "https://play.dhis2.org/dev",
#'     dataset            = "pBOMPrpg1QX,BfMAe6Itzgt",
#'     organisation_unit  = "DiszpKrYNg8",
#'     data_element_group = NULL,
#'     start_date         = "2014",
#'     end_date           = "2023",
#'     fields             = c("dataElement", "period", "value")
#'   )$data,
#'   fields               = c("dataElement", "period", "value")
#' )
#' }
#' @keywords internal
dhis2_subset_fields <- function(data, fields) {
  checkmate::assert_data_frame(data,
                               min.rows = 1L, null.ok = FALSE,
                               min.cols = 1L
  )
  checkmate::assert_vector(fields,
                           min.len = 1L, null.ok = TRUE,
                           any.missing = FALSE
  )
  if (!is.null(fields)) {
    if (is.character(fields)) {
      fields <- unlist(strsplit(fields, ",",
                                fixed = TRUE
      ))
    }
    idx <- which(fields %in% names(data))
    if (length(idx) == 0L) stop(sprintf("Specified column not found!
    The data contains the following columns:
    %s", names(data)))
=======
#' @return the data frame with the fields of interest
#' @examples
#' results <- dhis2_subset_fields(
#'  fields = c("dataElement","period","value"),
#'  data = readepi(
#'   credentials_file = system.file("extdata", "test.ini", package = "readepi"),
#'    project_id = "DHIS2_DEMO",
#'    dataset = "pBOMPrpg1QX,BfMAe6Itzgt",
#'    organisation_unit = "DiszpKrYNg8",
#'    data_element_group = NULL,
#'    start_date = "2014",
#'    end_date = "2023",
#'    fields = c("dataElement","period","value")
#'  )$data
#')
#' @export
dhis2_subset_fields <- function(fields, data) {
  checkmate::assert_vector(fields,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_data_frame(data, null.ok = FALSE)
  if (!is.null(fields)) {
    if (is.character(fields)) fields <- unlist(strsplit(fields, ",",
                                                        fixed = TRUE))
    idx <- which(fields %in% names(data))
    if (length(idx) == 0) stop("Specified column not not!\nThe data contains the
                               following column:\n", names(data))
>>>>>>> main
    if (length(idx) != length(fields)) {
      warning("The following fields were not found in the data: ", fields[-idx])
      fields <- fields[idx]
    }
    data <- data %>% dplyr::select(dplyr::all_of(fields))
  }

  data
}


<<<<<<< HEAD
#' Subset a specified set of records from a dataset imported from DHIS2
=======
#' Title
>>>>>>> main
#'
#' @param records a vector of records to select from the data
#' @param id_col_name the column name where the records belong to
#' @param data the input data frame
#'
<<<<<<< HEAD
#' @return an object of type `data.frame` with the data that contains only the
#'    records of interest
#' @examples
#' \dontrun{
#' result <- dhis2_subset_records(
#'   data = readepi(
#'     credentials_file   = system.file("extdata", "test.ini",
#'       package = "readepi"
#'     ),
#'     data_source        = "https://play.dhis2.org/dev",
#'     dataset            = "pBOMPrpg1QX",
#'     organisation_unit  = "DiszpKrYNg8",
#'     data_element_group = NULL,
#'     start_date         = "2014",
#'     end_date           = "2023"
#'   )$data,
#'   records              = c("FTRrcoaog83", "eY5ehpbEsB7", "Ix2HsbDMLea"),
#'   id_col_name          = "dataElement"
#' )
#' }
#' @keywords internal
dhis2_subset_records <- function(data, records, id_col_name) {
  checkmate::assert_data_frame(data,
                               min.rows = 1L, null.ok = FALSE,
                               min.cols = 1L
  )
  checkmate::assert_vector(records,
                           min.len = 1L, null.ok = TRUE,
                           any.missing = FALSE
  )
  checkmate::assert_character(id_col_name,
                              len = 1L, null.ok = TRUE,
                              any.missing = FALSE
  )
  if (!is.null(records)) {
    if (is.character(records)) {
      records <- unlist(strsplit(records, ",",
                                 fixed = TRUE
      ))
    }
    id_column_name <- id_col_name
    idx <- which(records %in% data[[id_column_name]])
    if (length(idx) == 0L) {
=======
#' @return a data frame with the records of interest
#' @examples
#' result <- dhis2_subset_records(
#'  records = c("FTRrcoaog83", "eY5ehpbEsB7", "Ix2HsbDMLea"),
#'  id_col_name = "dataElement",
#'  data = readepi(
#'   credentials_file = system.file("extdata", "test.ini", package = "readepi"),
#'   project_id = "DHIS2_DEMO",
#'   dataset = "pBOMPrpg1QX",
#'   organisation_unit = "DiszpKrYNg8",
#'   data_element_group = NULL,
#'   start_date = "2014",
#'   end_date = "2023"
#'   )$data
#' )
#'
#' @export
dhis2_subset_records <- function(records, id_col_name, data) {
  checkmate::assert_data_frame(data, null.ok = FALSE)
  checkmate::assert_vector(records,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
  checkmate::assertCharacter(id_col_name, len = 1, null.ok = TRUE,
                             any.missing = FALSE)
  if (!is.null(records)) {
    if (is.character(records)) records <- unlist(strsplit(records, ",",
                                                          fixed = TRUE))
    id_column_name <- id_col_name
    idx <- which(records %in% data[[id_column_name]])
    if (length(idx) == 0) {
>>>>>>> main
      stop("Speficied records not found in column: ", id_column_name)
    } else if (length(idx) < length(records)) {
      warning("The following records were not found: ", records[-idx])
      records <- records[idx]
    }
    data <- data[which(data[[id_column_name]] %in% records), ]
  }
<<<<<<< HEAD
  data
}

#' Get the DHIS2 attributes from the user
#'
#' @param args_list a `list` of parameters provided by the user
#'
#' @return an object of type `list` with the values for the DHIS2 attributes
#' @keywords internal
#'
get_attributes_from_user <- function(args_list) {
  dataset <- organisation_unit <- data_element_group <- start_date <-
    end_date <- NULL
  if ("dataset" %in% names(args_list)) {
    dataset <- args_list[["dataset"]]
  }
  if ("organisation_unit" %in% names(args_list)) {
    organisation_unit <- args_list[["organisation_unit"]]
  }
  if ("data_element_group" %in% names(args_list)) {
    data_element_group <- args_list[["data_element_group"]]
  }
  if ("start_date" %in% names(args_list)) {
    start_date <- args_list[["start_date"]]
  }
  if ("end_date" %in% names(args_list)) {
    end_date <- args_list[["end_date"]]
  }
  list(
    dataset            = dataset,
    organisation_unit  = organisation_unit,
    data_element_group = data_element_group,
    start_date         = start_date,
    end_date           = end_date
  )
}
=======

  data
}
>>>>>>> main
