

#' Get the dataset identifiers and names
#'
#' @param username the user name
#' @param password the user's password
#' @param base_url the base URL of the DHIS2 server
#'
get_data_sets <- function(base_url, username, password) {
  url <- file.path(base_url, "api",
                   "dataSets?fields=id,name,shortName&paging=false")
  r <- httr::content(httr::GET(url, httr::authenticate(username, password)),
                     as = "parsed")
  do.call(rbind.data.frame, r$dataSets)
}

#' Get the data element identifiers and names
#'
#' @param username the user name
#' @param password the user's password
#' @param base_url the base URL of the DHIS2 server
#'
get_data_elements <- function(base_url, username, password) {
  url <- file.path(base_url, "api",
                   "dataElements?fields=id,name,shortName&paging=false")
  r <- httr::content(httr::GET(url, httr::authenticate(username, password)),
                     as = "parsed")
  do.call(rbind.data.frame, r$dataElements)
}

#' Get the organisation unit identifiers and names
#'
#' @param username the user name
#' @param password the user's password
#' @param base_url the base URL of the DHIS2 server
#'
get_organisation_units <- function(base_url, username, password) {
  url <- file.path(base_url, "api",
                   "organisationUnits?fields=id,name,shortName&paging=false")
  r <- httr::content(httr::GET(url, httr::authenticate(username, password)),
                     as = "parsed")
  do.call(rbind.data.frame, r$organisationUnits)
}

#' Get the relevant dataset
#'
#' @param dataset the dataSets identifiers
#' @param base_url the web address of the server the user wishes to log in to
#' @param username the user name
#' @param password the user's password
#'
#' @return a `list` of 2 elements: a `character` string with the target dataset
#'    ID(s) and a `data.frame` of the details about all datasets in the target
#'    DHIS2 server.
#' @examples
#' \dontrun{
#'   result <- get_relevant_dataset(
#'     dataset = "pBOMPrpg1QX,BfMAe6Itzgt",
#'     base_url = "https://play.dhis2.org/dev/",
#'     username = "admin",
#'     password = "district"
#'   )
#' }
#'
get_relevant_dataset <- function(dataset, base_url, username, password) {
  if (!is.null(dataset)) {
    if (is.character(dataset)) dataset <- unlist(strsplit(dataset, ",",
                                                          fixed = TRUE))
    data_sets <- get_data_sets(base_url, username, password)
    idx <- which(dataset %in% data_sets$id)
    if (length(idx) == 0) {
      stop("Provided dataSets not found!\n
        Use get_data_sets() function to view the list of available dataSets.")
    }
    if (length(idx) < length(dataset)) {
      warning("\nThe following dataSets were not found: ",
              glue::glue_collapse(dataset[-idx], sep = ", "))
    }
    dataset <- paste(dataset[idx], collapse = ",")
  }

  list(
    dataset = dataset,
    data_sets = data_sets
  )
}


#' Get the relevant organisation units
#'
#' @param organisation_unit the organisationUnits identifiers
#' @param base_url the web address of the server the user wishes to log in to
#' @param username the user name
#' @param password the user's password
#'
#' @return a `list` of 2 elements: a `character` string with the target
#'    organisation unit ID(s) and a `data.frame` of the details about all
#'    organisation unit in the target DHIS2 server.
#' @examples
#' \dontrun{
#'   result <- get_relevant_organisation_unit(
#'     organisation_unit = "DiszpKrYNg8",
#'     base_url = "https://play.dhis2.org/dev/",
#'     username = "admin",
#'     password = "district"
#'   )
#' }
#'
get_relevant_organisation_unit <- function(organisation_unit, base_url,
                                           username, password) {
  if (!is.null(organisation_unit)) {
    if (is.character(organisation_unit)) organisation_unit <-
        unlist(strsplit(organisation_unit, ",", fixed = TRUE))
    org_units <- get_organisation_units(base_url, username, password)
    idx <- which(organisation_unit %in% org_units$id)
    if (length(idx) == 0) {
      stop("Provided organisationUnites not found!\n
           Use get_organisation_units() function to view the list of available
           dataSets.")
    }
    if (length(idx) < length(organisation_unit)) {
      warning("\nThe following organisationUnite were not found: ",
              glue::glue_collapse(organisation_unit[-idx], sep = ", "))
    }
    organisation_unit <- paste(organisation_unit[idx], collapse = ",")
  }

  list(
    organisation_unit = organisation_unit,
    org_units = org_units
  )
}


#' Get the relevant data element groups
#'
#' @param data_element_group the dataElementGroups identifiers
#' @param base_url the web address of the server the user wishes to log in to
#' @param username the user name
#' @param password the user's password
#'
#' @return a `list` of 2 elements: a `character` string with the target
#'    data element group ID(s) and a `data.frame` of the details about all
#'    data element group in the target DHIS2 server.
#'
get_relevant_data_elt_group <- function(data_element_group, base_url,
                                        username, password) {
  if (!is.null(data_element_group)) {
    if (is.character(data_element_group)) data_element_group <-
        unlist(strsplit(data_element_group, ",", fixed = TRUE))
    data_elt_groups <- get_organisation_units(base_url, username, password)
    idx <- which(data_element_group %in% data_elt_groups$id)
    if (length(idx) == 0) {
      stop("Provided dataElementGroups not found!\n
           Use get_organisation_units() function to view the list of available
           dataSets.")
    }
    if (length(idx) < length(data_element_group)) {
      warning("\nThe following dataElementGroups were not found: ",
              glue::glue_collapse(data_element_group[-idx], sep = ", "))
    }
    data_element_group <- paste(data_element_group[idx], collapse = ",")
  }

  if (!exists("data_elt_groups")) {
    data_elt_groups <- NULL
  }

  list(
    data_element_group = data_element_group,
    data_elt_groups = data_elt_groups
  )
}
