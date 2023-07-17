#' Import data from REDCap into R
#' @param uri the URI of the server
#' @param token the user-specific string that serves as the password for a
#'    project
#' @param id_position the column position of the variable that unique identifies
#'    the subjects. When the column name with the subject IDs is known, use
#'    the `id_col_name` argument instead. default is 1
#' @param id_col_name the column name with the subject IDs
#' @param records a vector or a comma-separated string of subset of subject IDs.
#'    When specified, only the records that correspond to these subjects will
#'    be imported.
#' @param fields a vector or a comma-separated string of column names.
#'    If provided, only those columns will be imported.
#' @examples
#' \dontrun{
#'   redcap_data <- read_from_redcap(
#'     uri = "https://bbmc.ouhsc.edu/redcap/api/",
#'     token = "9A81268476645C4E5F03428B8AC3AA7B",
#'     id_position = 1,
#'     id_col_name = NULL,
#'     records = NULL,
#'     fields = NULL
#'   )
#' }
#' @returns a `list` of 2 elements of type `data.frame`. They include a data
#'     frame of the dataset of interest and its associated metadata.
#' @keywords internal
#'
read_from_redcap <- function(uri, token, id_position = NULL, id_col_name = NULL,
                             records = NULL, fields = NULL) {
  # check input variables
  checkmate::assert_character(token, n.chars = 32, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_character(uri, len = 1, null.ok = FALSE,
                              any.missing = FALSE)

  stopifnot("Cannot specify both 'id_position' and 'id_col_name' at
            the same time." = !all(!is.null(id_position) &
                                     !is.null(id_col_name)))
  id_position <- ifelse(!is.null(id_position), id_position, 1)

  # importing data and the metadata into R
  tmp_res <- import_redcap_data(records, fields, uri, token,
                                 id_position, id_col_name)
  redcap_data <- tmp_res$redcap_data
  metadata <- tmp_res$metadata

  # checking whether the importing was successful and extract the desired
  # records and columns
  tmp_res <- redcap_get_results(redcap_data, metadata)

  # return the imported data
  list(
    data = tmp_res$data,
    metadata = tmp_res$meta
  )
}
