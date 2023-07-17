#' Read from Fingertips
#'
#' @param indicator_id a numeric vector of indicator IDs
#' @param indicator_name a vector of a comma-separated list of indicator names
#' @param area_type_id a vector of area type IDs
#' @param parent_area_type_id a vector of parent area type IDs
#' @param profile_id a vector of profile IDs
#' @param profile_name a vector or a comma-separated list of profile names
#' @param domain_id a vector of domain IDs
#' @param domain_name a vector or a comma-separated list of domain names
#' @param fields a vector or a comma-separated string of column names.
#'    If provided, only those columns will be imported.
#' @param records a vector or a comma-separated string of records.
#'    When specified, only these records will be imported.
#' @param id_position the column position of the variable that unique identifies
#'    the subjects. When the name of the column with the subject IDs is known,
#'    this can be provided using the `id_col_name` argument
#' @param id_col_name the column name with the subject IDs.
#'
#' @return a `list` of 1 element of type `data.frame`. This contains the
#'    imported dataset of interest
#'
#' @examples
#' \dontrun{
#'   data <- read_from_fingertips(indicator_id = 90362, area_type_id = 202)
#' }
#' @keywords internal
#'
read_from_fingertips <- function(indicator_id = NULL, indicator_name = NULL,
                                 area_type_id, parent_area_type_id = NULL,
                                 profile_id = NULL, profile_name = NULL,
                                 domain_id = NULL, domain_name = NULL,
                                 fields = NULL, records = NULL,
                                 id_position = NULL, id_col_name = NULL) {
  checkmate::assert_vector(indicator_id,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(indicator_name,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(area_type_id,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(parent_area_type_id,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(profile_id,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(profile_name,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(domain_id,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(domain_name,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = TRUE
  )

  # check if one of these is not provided
  if (all(is.null(profile_id) & is.null(indicator_id) & is.null(domain_id) &
          is.null(profile_name) & is.null(indicator_name) &
          is.null(domain_name))) {
    stop("\nPlease use the get_fingertips_metadata() function to see the
         Fingertips metadata.")
  }

  # extract the metadata
  metadata <- get_fingertips_metadata()

  # check if the area type ID is not provided
  if (is.null(area_type_id)) {
    message("\narea_type_id not provided! Please choose an area type ID from the
            list below:\n")
    print(metadata$area_type)
    stop()
  }

  # get the indicator ID from the indicator name
  if (!is.null(indicator_name) && is.null(indicator_id)) {
    indicator_id <- get_ind_id_from_ind_name(metadata, indicator_name)
  }

  # get the indicator ID from the domain ID
  if (!is.null(domain_id) && is.null(indicator_id)) {
    indicator_id <- get_ind_id_from_domain_id(metadata, domain_id,
                                              indicator_name)
  }

  # get the indicator ID from the domain name
  if (!is.null(domain_name) &&
      all(is.null(indicator_id) & is.null(domain_id))) {
    indicator_id <- get_ind_id_from_domain_name(metadata, domain_name,
                                                indicator_name)
  }
  # get the indicator ID from the profile ID or profile name
  if (any(!is.null(profile_id) | !is.null(profile_name)) &&
      is.null(indicator_id)) {
    indicator_id <- get_ind_id_from_profile(
      metadata, domain_id, domain_name,
      indicator_name, profile_name, profile_id
    )
  }

  # extract the data
  data <- data <- fingertipsR::fingertips_data(
    IndicatorID = indicator_id,
    AreaTypeID = area_type_id,
    ParentAreaTypeID = parent_area_type_id
  )

  # subset columns
  data <- fingertips_subset_columns(fields, data)

  # subset rows
  data <- fingertips_subset_rows(records, id_col_name, data)

  list(
    data = data
  )
}
