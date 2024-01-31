#' Import data from REDCap under all scenario
#'
#' @description This is a wrapper across all the use case of reading data from
#'    REDCap i.e. around the function that all records and fields from the
#'    project, around the function that read specific records/fields or both at
#'    the same time
#'
#' @param base_url the URI of the server
#' @param token the user-specific string that serves as the password for a
#'    project
#' @param records a vector or a comma-separated string of subset of subject IDs
#' @param fields a vector or a comma-separated string of column names
#' @param id_position the column position of the variable that unique identifies
#'    the subjects
#' @param id_col_name the column name with the subject IDs
#'
#' @return a `list` of 2 elements of type `data.frame`. These are the dataset of
#'    interest and its associated metadata.
#' @keywords internal
#' @examples
#' \dontrun{
#'   result <- redcap_import_data(
#'     base_url    = file.path("https:/", "bbmc.ouhsc.edu",
#'                             "redcap", "api", ""),
#'     token       = "9A81268476645C4E5F03428B8AC3AA7B",
#'     records     = c("1", "3", "5"),
#'     fields      = c("record_id", "name_first", "age", "bmi"),
#'     id_position = 1L,
#'     id_col_name = NULL
#'   )
#' }
#'
#'
redcap_import_data <- function(base_url,
                               token,
                               records     = NULL,
                               fields      = NULL,
                               id_position = 1L,
                               id_col_name = NULL) {
  if (is.null(records) && is.null(fields)) {
    res <- redcap_read_data(base_url, token, id_position)
  } else if (!is.null(records) && !is.null(fields)) {
    res <- redcap_read_rows_columns(
      base_url, token, fields, records, id_position,
      id_col_name
    )
  } else if (!is.null(fields) && is.null(records)) {
    res <- redcap_read_fields(base_url, token, fields, id_position)
  } else if (!is.null(records) && is.null(fields)) {
    res <- redcap_read_records(
      base_url, token, records,
      id_position, id_col_name
    )
  }
  redcap_data <- res[[1L]]
  metadata    <- res[[2L]]

  list(
    redcap_data = redcap_data,
    metadata    = metadata
  )
}

#' Read all rows and columns from redcap
#'
#' @param base_url the URI of the REDCap project
#' @param token the user-specific string that serves as the password for a
#'    project
#' @param id_position the column position of the variable that unique identifies
#'    the subjects
#'
#' @return a `list` of 2 elements of type `data.frame` that contain the project
#'    data and its associated metadata.
#' @keywords internal
#' @examples
#' \dontrun{
#'   result <- redcap_read_data(
#'     base_url    = "https://bbmc.ouhsc.edu/redcap/api/",
#'     token       = "9A81268476645C4E5F03428B8AC3AA7B",
#'     id_position = 1L
#'   )
#' }
#'
redcap_read_data <- function(base_url,
                             token,
                             id_position = 1L) {
  redcap_data <- REDCapR::redcap_read(
    redcap_uri  = base_url,
    token       = token,
    records     = NULL,
    fields      = NULL,
    verbose     = FALSE,
    id_position = as.integer(id_position)
  )
  metadata <- REDCapR::redcap_metadata_read(
    redcap_uri = base_url,
    token      = token,
    fields     = NULL,
    verbose    = FALSE
  )
  list(
    redcap_data = redcap_data,
    metadata    = metadata
  )
}

#' Subset records and columns from a REDCap project
#'
#' @param base_url the URI of the REDCap project
#' @param token the user-specific string that serves as the password for a
#'    project
#' @param fields a vector or a comma-separated string of column names
#' @param records a vector or a comma-separated string of subset of subject IDs
#' @param id_position the column position of the variable that unique identifies
#'    the subjects
#' @param id_col_name the column name with the subject IDs
#'
#' @return a `list` of 2 elements of type `data.frame` that contain the project
#'    data with only the records and fields of interest and its associated
#'    metadata.
#' @keywords internal
#' @examples
#' \dontrun{
#'   result <- redcap_read_rows_columns(
#'     base_url    = "https://bbmc.ouhsc.edu/redcap/api/",
#'     token       = "9A81268476645C4E5F03428B8AC3AA7B",
#'     fields      = c("record_id", "name_first", "age", "bmi"),
#'     records     = c("1", "3", "5"),
#'     id_position = 1L,
#'     id_col_name = NULL
#'   )
#' }
#'
redcap_read_rows_columns <- function(base_url,
                                     token,
                                     fields      = NULL,
                                     records     = NULL,
                                     id_position = 1L,
                                     id_col_name = NULL) {
  fields      <- glue::glue_collapse(fields, sep = ", ")
  redcap_data <- REDCapR::redcap_read(
    redcap_uri       = base_url,
    token            = token,
    id_position      = as.integer(id_position),
    fields_collapsed = fields,
    verbose          = FALSE
  )
  metadata    <- REDCapR::redcap_metadata_read(
    redcap_uri = base_url,
    token      = token,
    verbose    = FALSE
  )
  if (!is.null(id_col_name)) {
    if (!(id_col_name %in% names(redcap_data[["data"]]))) {
      stop("Specified ID column name not found!")
    }
    id_column_name <- id_col_name
    id_position    <- which(names(redcap_data[["data"]]) == id_column_name)
  } else {
    id_column_name <- names(redcap_data[["data"]])[id_position]
  }
  if (is.character(records)) {
    records <- gsub(" ", "", records, fixed = TRUE)
    records <- as.character(unlist(strsplit(records, ",", fixed = TRUE)))
  }
  if (is.numeric(redcap_data[["data"]][[id_column_name]])) {
    records <- as.numeric(records)
  }
  redcap_data[["data"]] <-
    redcap_data[["data"]][which(redcap_data[["data"]][[id_column_name]] %in%
                                  records), ]
  list(
    redcap_data = redcap_data,
    metadata    = metadata
  )
}


#' Subset fields from a REDCap project
#'
#' @param base_url the URI of the REDCap project
#' @param token the user-specific string that serves as the password for a
#'    project
#' @param fields a vector or a comma-separated string of column names
#' @param id_position the column position of the variable that unique identifies
#'    the subjects
#'
#' @return a `list` of 2 elements of type `data.frame` that contain the project
#'    data with the fields of interest and its associated metadata.
#' @keywords internal
#' @examples
#' \dontrun{
#'   result <- redcap_read_fields(
#'     base_url    = "https://bbmc.ouhsc.edu/redcap/api/",
#'     token       = "9A81268476645C4E5F03428B8AC3AA7B",
#'     fields      = c("record_id", "name_first", "age", "bmi"),
#'     id_position = 1L
#'   )
#' }
#'
redcap_read_fields <- function(base_url,
                               token,
                               fields,
                               id_position = 1L) {
  fields      <- glue::glue_collapse(fields, sep = ", ")
  redcap_data <- REDCapR::redcap_read(
    redcap_uri       = base_url, token = token,
    id_position      = as.integer(id_position),
    fields_collapsed = fields, verbose = FALSE
  )
  metadata <- REDCapR::redcap_metadata_read(
    redcap_uri = base_url,
    token      = token,
    verbose    = FALSE
  )
  list(
    redcap_data = redcap_data,
    metadata    = metadata
  )
}


#' Subset records from a REDCap project
#'
#' @param base_url the URI of the REDCap project
#' @param token the user-specific string that serves as the password for a
#'    project
#' @param records a vector or a comma-separated string of subset of subject IDs
#' @param id_position the column position of the variable that unique identifies
#'    the subjects
#' @param id_col_name the column name with the subject IDs
#'
#' @return a `list` of 2 elements of type `data.frame` that contain the project
#'    data with the records of interest and its associated metadata.
#' @keywords internal
#' @examples
#' \dontrun{
#'   result <- redcap_read_records(
#'     base_url    = "https://bbmc.ouhsc.edu/redcap/api/",
#'     token       = "9A81268476645C4E5F03428B8AC3AA7B",
#'     records     = c("1", "2", "3"),
#'     id_position = 1L,
#'     id_col_name = NULL
#'   )
#' }
#'
redcap_read_records <- function(base_url,
                                token,
                                records,
                                id_position = 1L,
                                id_col_name = NULL) {
  records     <- glue::glue_collapse(records, sep = ", ")
  redcap_data <- REDCapR::redcap_read(
    redcap_uri  = base_url,
    token       = token,
    records     = NULL,
    fields      = NULL,
    verbose     = FALSE,
    id_position = as.integer(id_position)
  )
  if (!is.null(id_col_name)) {
    if (!(id_col_name %in% names(redcap_data[["data"]]))) {
      stop("Specified ID column name not found!")
    }
    id_column_name <- id_col_name
    id_position    <- which(names(redcap_data[["data"]]) == id_column_name)
  } else {
    id_column_name <- names(redcap_data[["data"]])[id_position]
  }
  redcap_data <- REDCapR::redcap_read(
    redcap_uri        = base_url,
    token             = token,
    id_position       = as.integer(id_position),
    records_collapsed = records, verbose = FALSE
  )
  metadata <- REDCapR::redcap_metadata_read(
    redcap_uri = base_url,
    token      = token,
    verbose    = FALSE
  )
  list(
    redcap_data = redcap_data,
    metadata    = metadata
  )
}

#' Check and return data fetch from redcap
#'
#' @param redcap_data the object with redcap data
#' @param metadata the object with redcap metadata
#'
#' @return a `list` of 2 elements of type `data.frame`. These are the dataset of
#'    interest and its associated metadata.
#'
#' @examples
#' \dontrun{
#' result <- redcap_get_results(
#'   redcap_data = REDCapR::redcap_read(
#'     redcap_uri  = "https://bbmc.ouhsc.edu/redcap/api/",
#'     token       = "9A81268476645C4E5F03428B8AC3AA7B",
#'     records     = c("1", "3", "5"),
#'     fields      = c("record_id", "name_first", "age", "bmi"),
#'     verbose     = FALSE,
#'     id_position = 1L
#'   ),
#'   metadata = REDCapR::redcap_metadata_read(
#'     redcap_uri = "https://bbmc.ouhsc.edu/redcap/api/",
#'     token      = "9A81268476645C4E5F03428B8AC3AA7B",
#'     fields     = NULL,
#'     verbose    = FALSE
#'   )
#' )
#' }
#' @keywords internal
#'
redcap_get_results <- function(redcap_data, metadata) {
  checkmate::assert_list(redcap_data,
                         null.ok     = FALSE,
                         min.len     = 2L,
                         any.missing = FALSE)
  checkmate::assert_list(metadata,
                         null.ok     = FALSE,
                         min.len     = 2L,
                         any.missing = FALSE)
  if (all(redcap_data[["success"]] && metadata[["success"]])) {
    data <- redcap_data[["data"]]
    meta <- metadata[["data"]]
  }

  list(
    data = data,
    meta = meta
  )
}
