#' Check DHIS2 authentication details
#'
#' @param username the user name
#' @param password the user's password
#' @param base_url the base URL of the DHIS2 server
#'
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
}

#' Subset fields when reading from DHIS2
#'
#' @param fields vector of fields to select from the data frame
#' @param data the input data frame
#'
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
    if (length(idx) != length(fields)) {
      warning("The following fields were not found in the data: ", fields[-idx])
      fields <- fields[idx]
    }
    data <- data %>% dplyr::select(dplyr::all_of(fields))
  }

  data
}


#' Title
#'
#' @param records a vector of records to select from the data
#' @param id_col_name the column name where the records belong to
#' @param data the input data frame
#'
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
      stop("Speficied records not found in column: ", id_column_name)
    } else if (length(idx) < length(records)) {
      warning("The following records were not found: ", records[-idx])
      records <- records[idx]
    }
    data <- data[which(data[[id_column_name]] %in% records), ]
  }

  data
}
