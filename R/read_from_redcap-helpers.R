#' Import data from REDCap under all scenari
#'
#' @description This is a wrapper across all the use case of reading data from
#' REDCap i.e. around the function that all records and fields from the project,
#' around the function that read specific records/fields or both at the same
#' time
#'
#' @param records a vector or a comma-separated string of subset of subject IDs
#' @param fields a vector or a comma-separated string of column names
#' @param uri the URI of the server
#' @param token the user-specific string that serves as the password for a
#' project
#' @param id_position the column position of the variable that unique identifies
#' the subjects
#' @param id_col_name the column name with the subject IDs
#'
#' @return a list with the data of interest and its associated metadata
#' @examples
#' result = import_redcap_data(
#'  uri = "https://bbmc.ouhsc.edu/redcap/api/",
#'  token = "9A81268476645C4E5F03428B8AC3AA7B",
#'  records = c("1", "3", "5"),
#'  fields = c("record_id", "name_first", "age", "bmi"),
#'  id_col_name = NULL,
#'  id_position = 1
#' )
#'
import_redcap_data <- function(records, fields, uri, token,
                               id_position, id_col_name) {
  checkmate::assert_number(id_position, null.ok = TRUE,
                           na.ok = FALSE)
  checkmate::assert_character(token, n.chars = 32, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_character(uri, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_vector(records,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(fields,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
  checkmate::assertCharacter(id_col_name, len = 1, null.ok = TRUE,
                             any.missing = FALSE)

  if (all(is.null(records) & is.null(fields))) {
    res <- redcap_read(uri, token, id_position)
    redcap_data <- res[[1]]
    metadata <- res[[2]]
  }

  if (all(!is.null(records) & !is.null(fields))) {
    res <- redcap_read_rows_columns(fields, uri, token, id_position,
                                    id_col_name, records)
    redcap_data <- res[[1]]
    metadata <- res[[2]]
  }

  if (!is.null(fields) && is.null(records)) {
    res <- redcap_read_fields(fields, uri, token, id_position)
    redcap_data <- res[[1]]
    metadata <- res[[2]]
  }

  if (!is.null(records) && is.null(fields)) {
    res <- redcap_read_records(records, uri, token,
                               id_position, id_col_name)
    redcap_data <- res[[1]]
    metadata <- res[[2]]
  }

  list(
    redcap_data,
    metadata
  )
}

#' Read all rows and columns from redcap
#'
#' @param uri the URI of the REDCap project
#' @param token the user-specific string that serves as the password for a
#' project
#' @param id_position the column position of the variable that unique identifies
#' the subjects
#'
#' @return a list with the project data and its associated metadata
#'
redcap_read <- function(uri, token, id_position) {
  checkmate::assert_number(id_position, lower = 1, null.ok = TRUE,
                           na.ok = FALSE)
  checkmate::assert_character(token, n.chars = 32, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_character(uri, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  redcap_data <- REDCapR::redcap_read(
    redcap_uri = uri, token = token, records = NULL,
    fields = NULL, verbose = FALSE,
    id_position = as.integer(id_position)
  )
  metadata <- REDCapR::redcap_metadata_read(
    redcap_uri = uri, token = token,
    fields = NULL, verbose = FALSE
  )
  list(
    redcap_data = redcap_data,
    metadata = metadata
  )
}

#' Subset records and columns from a REDCap project
#'
#' @param fields a vector or a comma-separated string of column names
#' @param uri the URI of the REDCap project
#' @param token the user-specific string that serves as the password for a
#' project
#' @param id_position the column position of the variable that unique identifies
#' the subjects
#' @param id_col_name the column name with the subject IDs
#' @param records a vector or a comma-separated string of subset of subject IDs
#'
#' @return a list with the project data and its associated metadata with the
#' fields and records of interest
#'
redcap_read_rows_columns <- function(fields, uri, token, id_position,
                                     id_col_name, records) {
  checkmate::assert_number(id_position, lower = 1, null.ok = TRUE,
                           na.ok = FALSE)
  checkmate::assert_character(token, n.chars = 32, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_character(uri, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_vector(records,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(fields,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
  checkmate::assertCharacter(id_col_name, len = 1L, null.ok = TRUE,
                             any.missing = FALSE)
  if (is.vector(fields)) {
    fields <- glue::glue_collapse(fields, sep = ", ")
  }
  redcap_data <- REDCapR::redcap_read(
    redcap_uri = uri, token = token,
    id_position = as.integer(id_position),
    fields_collapsed = fields, verbose = FALSE
  )
  metadata <- REDCapR::redcap_metadata_read(
    redcap_uri = uri, token = token,
    verbose = FALSE
  )
  if (!is.null(id_col_name)) {
    if (!(id_col_name %in% names(redcap_data$data))) {
      stop("Specified ID column name not found!")
    }
    id_column_name <- id_col_name
    id_position <- which(names(redcap_data$data) == id_column_name)
  } else {
    id_column_name <- names(redcap_data$data)[id_position]
  }
  if (is.character(records)) {
    records <- gsub(" ", "", records, fixed = TRUE)
    records <- as.character(unlist(strsplit(records, ",", fixed = TRUE)))
  }
  if (is.numeric(redcap_data$data[[id_column_name]])) {
    records <- as.numeric(records)
  }
  redcap_data$data <-
    redcap_data$data[which(redcap_data$data[[id_column_name]] %in% records), ]
  list(
    redcap_data = redcap_data,
    metadata = metadata
  )
}


#' Subset fields from a REDCap project
#'
#' @param fields a vector or a comma-separated string of column names
#' @param uri the URI of the REDCap project
#' @param token the user-specific string that serves as the password for a
#' project
#' @param id_position the column position of the variable that unique identifies
#' the subjects
#'
#' @return a list with the project data and its associated metadata with the
#' fields of interest
#'
redcap_read_fields <- function(fields, uri, token, id_position) {
  checkmate::assert_number(id_position, lower = 1, null.ok = TRUE,
                           na.ok = FALSE)
  checkmate::assert_character(token, n.chars = 32, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_character(uri, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_vector(fields,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
  if (is.vector(fields)) {
    fields <- glue::glue_collapse(fields, sep = ", ")
  }
  redcap_data <- REDCapR::redcap_read(
    redcap_uri = uri, token = token,
    id_position = as.integer(id_position),
    fields_collapsed = fields, verbose = FALSE
  )
  metadata <- REDCapR::redcap_metadata_read(
    redcap_uri = uri, token = token,
    verbose = FALSE
  )
  list(
    redcap_data = redcap_data,
    metadata = metadata
  )
}


#' Subset records from a REDCap project
#'
#' @param records a vector or a comma-separated string of subset of subject IDs
#' @param uri the URI of the REDCap project
#' @param token the user-specific string that serves as the password for a
#' project
#' @param id_position the column position of the variable that unique identifies
#' the subjects
#' @param id_col_name the column name with the subject IDs
#'
#' @return a list with the project data and its associated metadata with the
#' records of interest
#'
redcap_read_records <- function(records, uri, token, id_position, id_col_name) {
  checkmate::assert_number(id_position, lower = 1, null.ok = TRUE,
                           na.ok = FALSE)
  checkmate::assert_character(token, n.chars = 32, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_character(uri, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_vector(records,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
  checkmate::assertCharacter(id_col_name, len = 1L, null.ok = TRUE,
                             any.missing = FALSE)
  if (is.vector(records)) {
    records <- glue::glue_collapse(records, sep = ", ")
  }
  redcap_data <- REDCapR::redcap_read(
    redcap_uri = uri, token = token, records = NULL,
    fields = NULL, verbose = FALSE,
    id_position = as.integer(id_position)
  )
  if (!is.null(id_col_name)) {
    if (!(id_col_name %in% names(redcap_data$data))) {
      stop("Specified ID column name not found!")
    }
    id_column_name <- id_col_name
    id_position <- which(names(redcap_data$data) == id_column_name)
  } else {
    id_column_name <- names(redcap_data$data)[id_position]
  }
  redcap_data <- REDCapR::redcap_read(
    redcap_uri = uri, token = token,
    id_position = as.integer(id_position),
    records_collapsed = records, verbose = FALSE
  )
  metadata <- REDCapR::redcap_metadata_read(
    redcap_uri = uri, token = token,
    verbose = FALSE
  )
  list(
    redcap_data = redcap_data,
    metadata = metadata
  )
}

#' Check and return data fetch from redcap
#'
#' @param redcap_data the object with redcap data
#' @param metadata the object with redcap metadata
#'
#' @return a list with the redcap dataset and its associated metadata as
#' data frames
#'
#' @examples
#' result <- redcap_get_results(
#' redcap_data = REDCapR::redcap_read(
#'   redcap_uri = "https://bbmc.ouhsc.edu/redcap/api/",
#'   token = "9A81268476645C4E5F03428B8AC3AA7B",
#'   records = c("1", "3", "5"),
#'   fields = c("record_id", "name_first", "age", "bmi"),
#'   verbose = FALSE,
#'   id_position = 1L
#'   ),
#' metadata = REDCapR::redcap_metadata_read(
#'   redcap_uri = "https://bbmc.ouhsc.edu/redcap/api/",
#'   token = "9A81268476645C4E5F03428B8AC3AA7B",
#'   fields = NULL,
#'   verbose = FALSE
#'   )
#'  )
#'
redcap_get_results <- function(redcap_data, metadata) {
  checkmate::assert_list(redcap_data, null.ok = FALSE, min.len = 2,
                         any.missing = FALSE)
  checkmate::assert_list(metadata, null.ok = FALSE, min.len = 2,
                         any.missing = FALSE)
  if (all(redcap_data$success & metadata$success)) {
    data <- redcap_data$data
    meta <- metadata$data
  } else if (redcap_data$success && !metadata$success) {
    warning("\nNote that the metadata was not imported.")
    data <- redcap_data$data
    meta <- NULL
  } else {
    stop("Error in reading from REDCap. Please check your credentials or
         project ID.")
  }

  list(
    data,
    meta
  )
}
