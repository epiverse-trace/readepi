#' Check the DHIS2 attributes for data import
#'
#' @param base_url the web address of the server the user wishes to log in to
#' @param user_name the user name
#' @param password the user's password
#' @param dataset the dataSets identifiers
#' @param organisation_unit the organisationUnits identifiers
#' @param data_element_group the dataElementGroups identifiers
#'
#' @return a list of 7 elements of type `character`.
#'
#' @examples
#' \dontrun{
#' attributes <- dhis2_check_attributes(
#'   base_url            = "https://play.dhis2.org/dev",
#'   user_name           = "admin",
#'   password            = "district",
#'   dataset             = "pBOMPrpg1QX",
#'   organisation_unit   = "DiszpKrYNg8",
#'   data_element_group  = NULL
#' )
#' }
#'
#' @keywords internal
#'
dhis2_check_attributes <- function(base_url,
                                   user_name,
                                   password,
                                   dataset,
                                   organisation_unit  = NULL,
                                   data_element_group = NULL) {
  # get the relevant dataset
  if (!is.null(dataset)) {
    tmp_res   <- dhis2_get_relevant_attributes(
      base_url     = base_url,
      user_name    = user_name,
      password     = password,
      attribute_id = dataset,
      which        = "dataSets"
    )
    dataset   <- tmp_res[["dataset"]]
    data_sets <- tmp_res[["data_sets"]]
  } else {
    dataset   <- data_sets <- NULL
  }

  # get the relevant organisation units
  if (!is.null(organisation_unit)) {
    tmp_res   <- dhis2_get_relevant_attributes(
      base_url     = base_url,
      user_name    = user_name,
      password     = password,
      attribute_id = organisation_unit,
      which        = "organisationUnits"
    )
    organisation_unit <- tmp_res[["organisation_unit"]]
    org_units         <- tmp_res[["org_units"]]
  } else {
    organisation_unit <- org_units <- NULL
  }

  # get the relevant data element groups
  if (!is.null(data_element_group)) {
    tmp_res <- dhis2_get_relevant_attributes(
      base_url     = base_url,
      user_name    = user_name,
      password     = password,
      attribute_id = data_element_group,
      which        = "dataElementGroups"
    )
    data_element_group <- tmp_res[["data_element_group"]]
    data_elt_groups    <- tmp_res[["data_elt_groups"]]
  } else {
    data_element_group <- data_elt_groups <- NULL
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
    data_elements               = data_elements
  )
}
