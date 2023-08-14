#' Import data form DHIS2 into R
#' @param base_url the web address of the server the user wishes to log in to
#' @param user_name the user name
#' @param password the user password
#' @param dataset a vector or a list of comma-separated data set identifiers
#' @param organisation_unit a vector or a list of comma-separated organisation
#'    unit identifiers
#' @param data_element_group a vector or a list of comma-separated data element
#'    group identifiers
#' @param start_date the start date for the time span of the values to export
#' @param end_date the end date for the time span of the values to export
#' @param records a vector or a comma-separated string of subset of subject IDs.
#'    When specified, only the records that correspond to these subjects will be
#'    imported.
#' @param fields a vector or a comma-separated string of column names.
#'    If provided, only those columns will be imported.
#' @param id_col_name the column name with the records of interest.
#' @returns a `list` of 1 element of type `data frame`.
#' @keywords internal
#' #' @examples
#' \dontrun{
#' data <- read_from_dhis2(
#'  base_url = file.path("https:/", "play.dhis2.org", "dev"),
#'  user_name = "admin",
#'  password = "district",
#'  dataset = "pBOMPrpg1QX",
#'  organisation_unit = "DiszpKrYNg8",
#'  data_element_group = "oDkJh5Ddh7d",
#'  start_date = "2014",
#'  end_date = "2023",
#'  records = NULL,
#'  fields = NULL,
#'  id_col_name = "dataElement"
#' )
#' }
read_from_dhis2 <- function(base_url,
                            user_name,
                            password,
                            dataset,
                            organisation_unit,
                            data_element_group,
                            start_date,
                            end_date,
                            records = NULL,
                            fields = NULL,
                            id_col_name = "dataElement") {
  checkmate::assert_character(base_url,
    len = 1L, null.ok = FALSE,
    any.missing = FALSE
  )
  checkmate::assert_character(user_name,
    len = 1L, null.ok = FALSE,
    any.missing = FALSE
  )
  checkmate::assert_character(password,
    len = 1L, null.ok = FALSE,
    any.missing = FALSE
  )
  checkmate::assert_vector(dataset,
    any.missing = FALSE, min.len = 1,
    null.ok = FALSE, unique = TRUE
  )
  checkmate::assert_vector(organisation_unit,
    any.missing = FALSE, min.len = 1,
    null.ok = FALSE, unique = TRUE
  )
  checkmate::assert_vector(data_element_group,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(start_date,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(end_date,
    any.missing = FALSE, min.len = 0,
    null.ok = TRUE, unique = TRUE
  )

  # checking user credentials
  login(user_name, password, base_url)

  # checking the attribute details
  attributes <- dhis2_check_attributes(
    user_name,
    password,
    base_url,
    dataset,
    organisation_unit,
    data_element_group
  )

  # fetching data
  data <- httr::GET(
    file.path(base_url, "api", "dataValueSets"),
    httr::authenticate(user_name, password),
    query = list(
      dataSet = attributes$dataset,
      orgUnit = attributes$organisation_unit,
      startDate = start_date,
      endDate = end_date
    )
  ) %>%
    httr::content() %>%
    dplyr::bind_rows()

  # add the variable names
  tmp_data_elt <- attributes$data_elements[, c("shortName", "id")] %>%
    dplyr::rename("dataElement" = "id")
  tmp_org_units <- attributes$org_units_details[, c("shortName", "id")] %>%
    dplyr::rename("orgUnit" = "id")
  data <- data %>%
    dplyr::left_join(tmp_data_elt, by = "dataElement") %>%
    dplyr::rename("dataElementName" = "shortName") %>%
    dplyr::left_join(tmp_org_units, by = "orgUnit") %>%
    dplyr::rename("OrgUnitName" = "shortName")

  # subsetting fields
  data <- dhis2_subset_fields(data, fields)

  # subsetting records
  data <- dhis2_subset_records(data, records, id_col_name)

  list(
    data = data
  )
}
