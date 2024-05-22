#' Check the DHIS2 attributes for data import
#'
#' @param base_url the web address of the server the user wishes to log in to
#' @param user_name the user name
#' @param password the user's password
#' @param query_parameters a list with the parameters that will be used to
#'    determine which data is returned by the query
#'
#' @return a list of 9 elements of type `character`.
#'
#' @examples
#' \dontrun{
#'   attributes <- dhis2_check_attributes(
#'     base_url         = "https://play.dhis2.org/dev",
#'     user_name        = "admin",
#'     password         = "district",
#'     query_parameters = list(dataSet = "pBOMPrpg1QX",
#'                             orgUnit = "DiszpKrYNg8")
#'   )
#' }
#'
#' @keywords internal
#'
dhis2_check_attributes <- function(base_url,
                                   user_name,
                                   password,
                                   query_parameters) {
  # get the relevant dataset
  if ("dataSet" %in% names(query_parameters)) {
    tmp_res   <- dhis2_get_relevant_attributes(
      base_url     = base_url,
      user_name    = user_name,
      password     = password,
      attribute_id = query_parameters[["dataSet"]],
      which        = "dataSets"
    )
    dataset   <- tmp_res[["dataset"]]
    data_sets <- tmp_res[["data_sets"]]
  } else {
    dataset   <- data_sets <- NULL
  }

  # get the relevant data element groups
  if ("dataElementGroup" %in% names(query_parameters)) {
    tmp_res <- dhis2_get_relevant_attributes(
      base_url     = base_url,
      user_name    = user_name,
      password     = password,
      attribute_id = query_parameters[["dataElementGroup"]],
      which        = "dataElementGroups"
    )
    data_element_group <- tmp_res[["data_element_group"]]
    data_elt_groups    <- tmp_res[["data_elt_groups"]]
  } else {
    data_element_group <- data_elt_groups <- NULL
  }

  # get the relevant organisation units
  if ("orgUnit" %in% names(query_parameters)) {
    tmp_res   <- dhis2_get_relevant_attributes(
      base_url     = base_url,
      user_name    = user_name,
      password     = password,
      attribute_id = query_parameters[["orgUnit"]],
      which        = "organisationUnits"
    )
    organisation_unit <- tmp_res[["organisation_unit"]]
    org_units         <- tmp_res[["org_units"]]
  } else {
    organisation_unit <- org_units <- NULL
  }

  # get the relevant organisation units
  if ("orgUnitGroup" %in% names(query_parameters)) {
    tmp_res   <- dhis2_get_relevant_attributes(
      base_url     = base_url,
      user_name    = user_name,
      password     = password,
      attribute_id = query_parameters[["orgUnitGroup"]],
      which        = "organisationUnitGroups"
    )
    organisation_unit_group <- tmp_res[["organisation_unit_group"]]
    org_units_groups        <- tmp_res[["org_units_groups"]]
  } else {
    organisation_unit_group <- org_units_groups <- NULL
  }

  # get the data element
  data_elements <- dhis2_get_relevant_attributes(
    base_url     = base_url,
    user_name    = user_name,
    password     = password,
    attribute_id = NULL,
    which        = "dataElements"
  )

  list(
    dataset                     = dataset,
    dataset_details             = data_sets,
    organisation_unit           = organisation_unit,
    org_units_details           = org_units,
    data_element_group          = data_element_group,
    data_element_groups_details = data_elt_groups,
    organisation_unit_group     = organisation_unit_group,
    org_units_groups            = org_units_groups,
    data_elements               = data_elements
  )
}
