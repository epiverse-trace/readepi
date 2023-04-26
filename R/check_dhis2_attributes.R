#' Check the DHIS2 attributes for data import
#'
#' @param username the user name
#' @param password the user's password
#' @param base_url the web address of the server the user wishes to log in to
#' @param dataset the dataSets identifiers
#' @param organisation_unit the organisationUnits identifiers
#' @param data_element_group the dataElementGroups identifiers
#'
#' @return a list
#' @export
#'
#' @examples
#' attributes <- check_dhis2_attributes(
#'   username = "admin",
#'   password = "district",
#'   base_url = "https://play.dhis2.org/dev/",
#'   dataset = "pBOMPrpg1QX",
#'   organisation_unit = "DiszpKrYNg8",
#'   data_element_group = NULL
#' )
check_dhis2_attributes <- function(username,
                                   password,
                                   base_url,
                                   dataset,
                                   organisation_unit = NULL,
                                   data_element_group = NULL) {
  checkmate::assertCharacter(base_url,
    len = 1L, null.ok = FALSE,
    any.missing = FALSE
  )
  checkmate::assertCharacter(username,
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
  data_elt_groups <- data_sets <- org_units <- data_elements <- NULL

  # get the relevant dataset
  tmp_res <- get_relevant_dataset(dataset, base_url, username, password)
  dataset <- tmp_res[[1]]
  data_sets <- tmp_res[[2]]

  # get the relevant organisation units
  tmp_res <- get_relevant_organisation_unit(organisation_unit,
                                                     base_url, username,
                                                     password)
  organisation_unit <- tmp_res[[1]]
  org_units <- tmp_res[[2]]

  # get the relevant data element groups
  tmp_res <- get_relevant_data_elt_group(data_element_group, base_url,
                                            username, password)
  data_element_group <- tmp_res[[1]]
  data_elt_groups <- tmp_res[[2]]

  # get the data element
  data_elements <- get_data_elements(base_url, username, password)

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
