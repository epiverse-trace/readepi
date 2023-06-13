#' Get information about all the dataSets on a DHIS2 server.
#'
#' @param username The user name.
#' @param password The user's password.
#' @param base_url The base URL of the DHIS2 server.
#' @param path The path to the content.
#'
#' @return A `data.frame` with information about all the datasets
#' on the DHIS2 server.
#'
#' @export
#'
all_datasets <- function(
    base_url,
    username,
    password,
    path = "/api/dataSets?fields=id,name,shortName&paging=false") {
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

  url <- paste0(base_url, path)
  r <- httr::content(httr::GET(url, httr::authenticate(username, password)),
    as = "parsed"
  )
  do.call(rbind.data.frame, r[["dataSets"]])
}

#' Get one or more datasets from the DHIS2 server.
#'
#' @param dataset_ids The dataSets identifiers.
#' @param base_url The base URL of the DHIS2 server.
#' @param username The user name.
#' @param password The user's password.
#'
#' @return A `list` with the relevant datasets.
#' @examples
#' result <- get_datasets(
#'   dataset_ids = "pBOMPrpg1QX,BfMAe6Itzgt",
#'   base_url = "https://play.dhis2.org/dev/",
#'   username = "admin",
#'   password = "district"
#' )
#' @export
#'
get_datasets <- function(dataset_ids, base_url, username, password) {
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
  checkmate::assert_vector(dataset_ids,
    any.missing = FALSE, min.len = 1L,
    null.ok = FALSE, unique = TRUE
  )
  if (!is.null(dataset_ids)) {
    if (is.character(dataset_ids)) {
      dataset_ids <- unlist(strsplit(dataset_ids, ",",
        fixed = TRUE
      ))
    }
    datasets <- all_datasets(base_url, username, password)
    idx <- which(dataset_ids %in% datasets[["id"]])
    if (length(idx) == 0L) {
      stop("Provided dataSets not found!\n
        Use all_datasets() function to view the list of available dataSets.")
    }
    if (length(idx) < length(dataset_ids)) {
      warning(
        "\nThe following dataSets were not found: ",
        glue::glue_collapse(dataset_ids[-idx], sep = ", ")
      )
    }
    dataset_ids <- paste(dataset_ids[idx], collapse = ",")
  }

  list(
    dataset_ids,
    datasets
  )
}


#' Get one or more organisation units from a DHIS2 server.
#'
#' @param organisation_unit_ids The organisation unit identifiers.
#' @param base_url The base URL of the DHIS2 server.
#' @param username The user name.
#' @param password The user's password.
#'
#' @return A `list` with the relevant organisation units.
#' @examples
#' result <- get_organisation_units(
#'   organisation_unit_ids = "DiszpKrYNg8",
#'   base_url = "https://play.dhis2.org/dev/",
#'   username = "admin",
#'   password = "district"
#' )
#' @export
#'
get_organisation_units <- function(organisation_unit_ids, base_url,
                                  username, password) {
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
  checkmate::assert_vector(organisation_unit_ids,
    any.missing = FALSE, min.len = 1L,
    null.ok = FALSE, unique = TRUE
  )
  if (!is.null(organisation_unit_ids)) {
    if (is.character(organisation_unit_ids)) {
      organisation_unit_ids <-
        unlist(strsplit(organisation_unit_ids, ",", fixed = TRUE))
    }
    organisation_units <- all_organisation_units(base_url, username, password)
    idx <- which(organisation_unit_ids %in% organisation_units[["id"]])
    if (length(idx) == 0L) {
      stop("Provided organisationUnites not found!\n
           Use all_organisation_units() function to view the list of available
           dataSets.")
    }
    if (length(idx) < length(organisation_unit_ids)) {
      warning(
        "\nThe following organisationUnite were not found: ",
        glue::glue_collapse(organisation_unit_ids[-idx], sep = ", ")
      )
    }
    organisation_unit_ids <- paste(organisation_unit_ids[idx], collapse = ",")
  }

  list(
    organisation_unit_ids,
    organisation_units
  )
}


#' Get one or more data element groups.
#'
#' @param data_element_group_ids The dataElementGroups identifiers.
#' @param base_url The base URL of the DHIS2 server.
#' @param username The user name.
#' @param password The user's password.
#'
#' @return A `list` with the data elements of interest.
#' @export
get_data_elements <- function(data_element_group_ids, base_url,
                               username, password) {
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
  checkmate::assert_vector(data_element_group_ids,
    any.missing = FALSE, min.len = 0L,
    null.ok = TRUE, unique = TRUE
  )
  data_elt_groups <- NULL
  if (!is.null(data_element_group_ids)) {
    if (is.character(data_element_group_ids)) {
      data_element_group_ids <-
        unlist(strsplit(data_element_group_ids, ",", fixed = TRUE))
    }
    data_elt_groups <- all_organisation_units(base_url, username, password)
    idx <- which(data_element_group_ids %in% data_elt_groups[["id"]])
    if (length(idx) == 0L) {
      stop("Provided dataElementGroups not found!\n
           Use all_organisation_units() function to view the list of available
           dataSets.")
    }
    if (length(idx) < length(data_element_group_ids)) {
      warning(
        "\nThe following dataElementGroups were not found: ",
        glue::glue_collapse(data_element_group_ids[-idx], sep = ", ")
      )
    }
    data_element_group_ids <- paste(data_element_group_ids[idx], collapse = ",")
  }

  list(
    data_element_group_ids,
    data_elt_groups
  )
}

#' Get information about all data elements on a DHIS2 server.
#'
#' @param username The user name.
#' @param password The user's password.
#' @param base_url The base URL of the DHIS2 server.
#' @param path The path to the content.
#'
#' @export
#'
all_data_elements <- function(
    base_url,
    username,
    password,
    path = "/api/dataElements?fields=id,name,shortName&paging=false") {
  checkmate::assertCharacter(base_url,
    len = 1L, null.ok = TRUE,
    any.missing = FALSE
  )
  checkmate::assertCharacter(username,
    len = 1L, null.ok = TRUE,
    any.missing = FALSE
  )
  checkmate::assertCharacter(password,
    len = 1L, null.ok = TRUE,
    any.missing = FALSE
  )

  url <- paste0(base_url, path)
  r <- httr::content(httr::GET(url, httr::authenticate(username, password)),
    as = "parsed"
  )
  do.call(rbind.data.frame, r[["dataElements"]])
}

#' Get the organisation unit identifiers and names
#'
#' @param username the user name
#' @param password the user's password
#' @param base_url the base URL of the DHIS2 server
#' @param path The path to the content.
#'
#' @export
#'
all_organisation_units <- function(
    base_url,
    username,
    password,
    path = "/api/organisationUnits?fields=id,name,shortName&paging=false") {
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

  url <- paste0(base_url, path)
  r <- httr::content(httr::GET(url, httr::authenticate(username, password)),
    as = "parsed"
  )
  do.call(rbind.data.frame, r[["organisationUnits"]])
}
