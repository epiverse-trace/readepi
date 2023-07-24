#' Check the DHIS2 attributes for data import
#'
#' @param username the user name
#' @param password the user's password
#' @param base_url the web address of the server the user wishes to log in to
#' @param dataset the dataSets identifiers
#' @param organisation_unit the organisationUnits identifiers
#' @param data_element_group the dataElementGroups identifiers
#'
#' @return a list of 7 elements of type `character`.
#'
#' @examples
#' \dontrun{
#' attributes <- dhis2_check_attributes(
#'   username = "admin",
#'   password = "district",
#'   base_url = "https://play.dhis2.org/dev/",
#'   dataset = "pBOMPrpg1QX",
#'   organisation_unit = "DiszpKrYNg8",
#'   data_element_group = NULL
#' )
#' }
#'
dhis2_check_attributes <- function(username,
                                   password,
                                   base_url,
                                   dataset,
                                   organisation_unit = NULL,
                                   data_element_group = NULL) {
  # get the relevant dataset
  tmp_res <- dhis2_get_relevant_attributes(
    attribute_id = dataset,
    base_url = base_url,
    username = username,
    password = password,
    which = "dataSets"
  )
  dataset <- tmp_res$dataset
  data_sets <- tmp_res$data_sets

  # get the relevant organisation units
  tmp_res <- dhis2_get_relevant_attributes(
    attribute_id = organisation_unit,
    base_url = base_url,
    username = username,
    password = password,
    which = "organisationUnits"
  )
  organisation_unit <- tmp_res$organisation_unit
  org_units <- tmp_res$org_units

  # get the relevant data element groups
  if (!is.null(data_element_group)) {
    tmp_res <- dhis2_get_relevant_attributes(
      attribute_id = data_element_group,
      base_url = base_url,
      username = username,
      password = password,
      which = "dataElementGroups"
    )
    data_element_group <- tmp_res$data_element_group
    data_elt_groups <- tmp_res$data_elt_groups
  } else {
    data_element_group <- NULL
    data_elt_groups <- NULL
  }

  # get the data element
  data_elements <- dhis2_get_relevant_attributes(
    attribute_id = NULL,
    base_url = base_url,
    username = username,
    password = password,
    which = "dataElements"
  )

  list(
    dataset = dataset,
    dataset_details = data_sets,
    organisation_unit = organisation_unit,
    org_units_details = org_units,
    data_element_group = data_element_group,
    data_element_groups_details = data_elt_groups,
    data_elements = data_elements
  )
}
