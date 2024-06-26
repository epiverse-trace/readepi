#' Import data from REDCap

#' @param base_url the URI of the server
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
#' redcap_data <- read_from_redcap(
#'   base_url    = "https://bbmc.ouhsc.edu/redcap/api/",
#'   token       = "9A81268476645C4E5F03428B8AC3AA7B",
#'   records     = NULL,
#'   fields      = NULL,
#'   id_position = 1,
#'   id_col_name = NULL
#' )
#' }
#' @returns a `list` of 2 elements of type `data.frame`. They include a data
#'     frame of the dataset of interest and its associated metadata.
#' @keywords internal
#'
read_from_redcap <- function(base_url,
                             token,
                             records     = NULL,
                             fields      = NULL,
                             id_position = 1L,
                             id_col_name = NULL) {
  # check input variables
  checkmate::assert_character(token,
                              n.chars = 32L, len = 1L, null.ok = FALSE,
                              any.missing = FALSE)
  url_check(base_url)

  stopifnot("Cannot specify both 'id_position' and 'id_col_name' at
            the same time." = !all(!is.null(id_position) &
                                     !is.null(id_col_name)))
  id_position <- ifelse(!is.null(id_position), id_position, 1L)

  # importing data and the metadata into R
  tmp_res <- redcap_import_data(
    base_url, token, records, fields,
    id_position, id_col_name
  )
  redcap_data <- tmp_res[["redcap_data"]]
  metadata    <- tmp_res[["metadata"]]

  # checking whether the importing was successful and extract the desired
  # records and columns
  tmp_res     <- redcap_get_results(redcap_data, metadata)

  # return the imported data
  list(
    data     = tmp_res[["data"]],
    metadata = tmp_res[["meta"]]
  )
}
