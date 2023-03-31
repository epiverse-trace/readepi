#' Check the DHIS2 attributes for data import
#'
#' @param base.url the web address of the server the user wishes to log in to
#' @param dataset the dataSets identifiers
#' @param organisation.unit the organisationUnits identifiers
#' @param data.element.group the dataElementGroups identifiers
#'
#' @return a list
#' @export
#'
#' @examples
#' attributes <- check_dhis2_attributes(
#'   username = "admin",
#'   password = "district",
#'   base.url = "https://play.dhis2.org/dev/",
#'   dataset = "pBOMPrpg1QX",
#'   organisation.unit = "DiszpKrYNg8",
#'   data.element.group = NULL
#' )
check_dhis2_attributes <- function(username,
                                   password,
                                   base.url,
                                   dataset,
                                   organisation.unit = NULL,
                                   data.element.group = NULL) {
  checkmate::assertCharacter(base.url,
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
  checkmate::assert_vector(organisation.unit,
    any.missing = FALSE, min.len = 1,
    null.ok = FALSE, unique = TRUE
  )
  checkmate::assert_vector(data.element.group,
    any.missing = FALSE, min.len = 1,
    null.ok = TRUE, unique = TRUE
  )
  data.elt.groups <- data.sets <- org.units <- data.elements <- NULL
  if (!is.null(dataset)) {
    if (is.character(dataset)) dataset <- unlist(strsplit(dataset, ","))
    data.sets <- get_data_sets(base.url, username, password)
    idx <- which(dataset %in% data.sets$id)
    if (length(idx) == 0) stop("Provided dataSets not found!\nUse get_data_sets() function to view the list of available dataSets.")
    if (length(idx) < length(dataset)) {
      warning("\nThe following dataSets were not found: ", paste(dataset[-idx], collapse = ", "))
    }
    dataset <- paste(dataset[idx], collapse = ",")
  }

  if (!is.null(organisation.unit)) {
    if (is.character(organisation.unit)) organisation.unit <- unlist(strsplit(organisation.unit, ","))
    org.units <- get_organisation_units(base.url, username, password)
    idx <- which(organisation.unit %in% org.units$id)
    if (length(idx) == 0) stop("Provided organisationUnites not found!\nUse get_organisation_units() function to view the list of available dataSets.")
    if (length(idx) < length(organisation.unit)) {
      warning("\nThe following organisationUnite were not found: ", paste(organisation.unit[-idx], collapse = ", "))
    }
    organisation.unit <- paste(organisation.unit[idx], collapse = ",")
  }

  if (!is.null(data.element.group)) {
    if (is.character(data.element.group)) data.element.group <- unlist(strsplit(data.element.group, ","))
    data.elt.groups <- get_organisation_units(base.url, username, password)
    idx <- which(data.element.group %in% data.elt.groups$id)
    if (length(idx) == 0) stop("Provided dataElementGroups not found!\nUse get_organisation_units() function to view the list of available dataSets.")
    if (length(idx) < length(data.element.group)) {
      warning("\nThe following dataElementGroups were not found: ", paste(data.element.group[-idx], collapse = ", "))
    }
    data.element.group <- paste(data.element.group[idx], collapse = ",")
  }

  data.elements <- get_data_elements(base.url, username, password)

  list(
    dataset = dataset,
    dataset_details = data.sets,
    organisation_unit = organisation.unit,
    org_units_details = org.units,
    data_element_group = data.element.group,
    data_element_groups_details = data.elt.groups,
    data_elements = data.elements
  )
}
