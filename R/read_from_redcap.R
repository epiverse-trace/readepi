#' Import data from REDCap into R
#' @param uri the URI of the server
#' @param token the user-specific string that serves as the password for a project
#' @param id.position the column position of the variable that unique identifies the subjects. When the column name with the subject IDs is known, use the `id.col.name` argument instead. default is 1
#' @param id.col.name the column name with the subject IDs
#' @param records a vector or a comma-separated string of subset of subject IDs. When specified, only the records that correspond to these subjects will be imported.
#' @param fields a vector or a comma-separated string of column names. If provided, only those columns will be imported.
#' @examples
#' \dontrun{
#' redcap.data <- read_from_redcap(
#'   uri = "https://redcap.mrc.gm:8443/redcap/api/",
#'   token = "****",
#'   id.position = 1,
#'   id.col.name = NULL,
#'   records = NULL,
#'   fields = NULL
#' )
#' }
#' @returns a list with 2 data frames: the data of interest and the metadata associated to the data.
#' @export
read_from_redcap <- function(uri, token, id.position = 1, id.col.name = NULL,
                             records = NULL, fields = NULL) {
  # check input variables
  checkmate::assert_number(id.position, lower = 1, null.ok = TRUE)
  checkmate::assert_character(token, n.chars = 32, len = 1, null.ok = FALSE)
  checkmate::assert_character(uri, len = 1, null.ok = FALSE)
  checkmate::assert_vector(records,
    any.missing = FALSE, min.len = 1,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(fields,
    any.missing = FALSE, min.len = 1,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assertCharacter(id.col.name, len = 1L, null.ok = TRUE, any.missing = FALSE)

  if(!is.null(id.position) & !is.null(id.col.name)){
    stop("Cannot specify both 'id.position' and 'id.col.name' at the same time.")
  }

  if(is.null(id.position)){
    id.position=1
  }

  # importing data and the metadata into R
  if (is.null(records) & is.null(fields)) {
    redcap.data <- REDCapR::redcap_read(
      redcap_uri = uri, token = token, records = NULL,
      fields = NULL, verbose = FALSE,
      id_position = as.integer(id.position)
    )
    metadata <- REDCapR::redcap_metadata_read(
      redcap_uri = uri, token = token,
      fields = NULL, verbose = FALSE
    )
  } else if (!is.null(records) & !is.null(fields)) {
    if (is.vector(fields)) {
      fields <- paste(fields, collapse = ", ")
    }
    redcap.data <- REDCapR::redcap_read(
      redcap_uri = uri, token = token,
      id_position = as.integer(id.position),
      fields_collapsed = fields, verbose = FALSE
    )
    metadata <- REDCapR::redcap_metadata_read(
      redcap_uri = uri, token = token,
      fields_collapsed = fields, verbose = FALSE
    )
    if(!is.null(id.col.name)){
      if(!(id.col.name %in% names(redcap.data$data))) stop("Specified ID column name not found!")
      id.column.name = id.col.name
      id.position = which(names(redcap.data$data)==id.column.name)
    }else {id.column.name <- names(redcap.data$data)[id.position]}
    if (is.character(records)) {
      records <- as.character(unlist(strsplit(records, ",")))
    }
    if (is.numeric(redcap.data$data[[id.column.name]])) {
      records <- as.numeric(records)
    }
    redcap.data$data <- redcap.data$data[which(redcap.data$data[[id.column.name]] %in% records), ]
  } else if (!is.null(fields) & is.null(records)) {
    if (is.vector(fields)) {
      fields <- paste(fields, collapse = ", ")
    }
    redcap.data <- REDCapR::redcap_read(
      redcap_uri = uri, token = token,
      id_position = as.integer(id.position),
      fields_collapsed = fields, verbose = FALSE
    )
    metadata <- REDCapR::redcap_metadata_read(
      redcap_uri = uri, token = token,
      fields_collapsed = fields, verbose = FALSE
    )
  } else if (!is.null(records) & is.null(fields)) {
    if (is.vector(records)) {
      records <- paste(records, collapse = ", ")
    }
    redcap.data <- REDCapR::redcap_read(
      redcap_uri = uri, token = token, records = NULL,
      fields = NULL, verbose = FALSE,
      id_position = as.integer(id.position)
    )
    if(!is.null(id.col.name)){
      if(!(id.col.name %in% names(redcap.data$data))) stop("Specified ID column name not found!")
      id.column.name = id.col.name
      id.position = which(names(redcap.data$data)==id.column.name)
    }else {id.column.name <- names(redcap.data$data)[id.position]}
    redcap.data <- REDCapR::redcap_read(
      redcap_uri = uri, token = token,
      id_position = as.integer(id.position),
      records_collapsed = records, verbose = FALSE
    )
    metadata <- REDCapR::redcap_metadata_read(
      redcap_uri = uri, token = token,
      verbose = FALSE
    )
  }

  # checking whether the importing was successful and extract the desired records and columns
  if (redcap.data$success & metadata$success) {
    data <- redcap.data$data
    meta <- metadata$data
  } else {
    stop("Error in reading from REDCap. Please check your credentials or project ID.")
  }

  # return the imported data
  list(
    data = data,
    metadata = meta
  )
}
