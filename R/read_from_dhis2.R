#' Import data form DHIS2 into R
#' @param base_url the web address of the server the user wishes to log in to
#' @param user_name the user name
#' @param password the user password
#' @param dataset a vector or a list of comma-separated data set identifiers
#' @param organisation_unit a vector or a list of comma-separated organisation
#' unit identifiers
#' @param data_element_group a vector or a list of comma-separated data element
#' group identifiers
#' @param start_date the start date for the time span of the values to export
#' @param end_date the end date for the time span of the values to export
#' @param records a vector or a comma-separated string of subset of subject IDs.
#' When specified, only the records that correspond to these subjects will be
#' imported.
#' @param fields a vector or a comma-separated string of column names.
#' If provided, only those columns will be imported.
#' @param id_col_name the column name with the records of interest.
#' @returns a list of data frames
#' @export
read_from_dhis2 <- function(base_url,
                            user_name,
                            password,
                            dataset,
                            organisation_unit,
                            data_element_group,
                            start_date,
                            end_date,
                            records,
                            fields,
                            id_col_name = "dataElement") {
  checkmate::assertCharacter(id_col_name,
    len = 1L, null.ok = TRUE,
    any.missing = FALSE
  )
  checkmate::assertCharacter(base_url,
    len = 1L, null.ok = FALSE,
    any.missing = FALSE
  )
  checkmate::assertCharacter(user_name,
    len = 1L, null.ok = FALSE,
    any.missing = FALSE
  )
  checkmate::assertCharacter(password,
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
    any.missing = FALSE, min.len = 1,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(start_date,
    any.missing = FALSE, min.len = 1,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(end_date,
    any.missing = FALSE, min.len = 1,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(records,
    any.missing = FALSE, min.len = 1,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(fields,
    any.missing = FALSE, min.len = 1,
    null.ok = TRUE, unique = TRUE
  )

  # checking user credentials
  login(user_name, password, base_url)

  # checking the attribute details
  attributes <- check_dhis2_attributes(
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
      startDate = start_date, # "2014"
      endDate = end_date
    ) # "2023"
  ) %>% #|>
    httr::content() %>% #|>
    purrr::flatten_dfr()

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
  data <- dhis2_subset_fields(fields, data)

  # subsetting records
 data <- dhis2_subset_records(records, id_col_name, data)

  list(data = data)
}
