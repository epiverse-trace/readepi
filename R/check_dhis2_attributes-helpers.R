<<<<<<< HEAD
#' Make an API request to the target DHIS2 system
#'
#' @param base_url the base URL of the DHIS2 server
#' @param username the user name
#' @param password the user's password
#' @param which the target DHIS2 attribute name. Possible values are:
#' \enumerate{
#'   \item dataSets: to get the dataset identifiers and names
#'   \item organisationUnits: to get the organisation unit identifiers and names
#'   \item dataElementGroups: to get the data element groups identifiers
#'      and names
#'   \item dataElements: to get the data elements identifiers and names
#'   }
#'
#' @return an object of class `data.frame` that contains the information of
#'    interest.
#' @keywords internal
make_api_request <- function(base_url, username, password,
                             which = "dataElements") {
  checkmate::assert_character(base_url,
                              len = 1L, any.missing = FALSE,
                              null.ok = FALSE, pattern = "https://"
  )
  checkmate::assert_character(username,
                              len = 1L, any.missing = FALSE,
                              null.ok = FALSE
  )
  checkmate::assert_character(password,
                              len = 1L, any.missing = FALSE,
                              null.ok = FALSE
  )
  checkmate::assert_character(which,
                              len = 1L, any.missing = FALSE,
                              null.ok = FALSE
  )
  checkmate::check_choice(which, c(
    "dataSets", "organisationUnits",
    "dataElementGroups", "dataElements"
  ))
  url <- file.path(
    base_url,
    "api",
    which,
    "?fields=id,name,shortName&paging=false"
  )
  response <- httr::GET(url, httr::authenticate(username, password))
  response
=======
#' Get the dataset identifiers and names
#'
#' @param username the user name
#' @param password the user's password
#' @param base_url the base URL of the DHIS2 server
#'
#' @export
#'
get_data_sets <- function(base_url, username, password) {
  checkmate::assertCharacter(base_url, len = 1L, null.ok = FALSE,
                             any.missing = FALSE)
  checkmate::assertCharacter(username, len = 1L, null.ok = FALSE,
                             any.missing = FALSE)
  checkmate::assertCharacter(password, len = 1L, null.ok = FALSE,
                             any.missing = FALSE)

  url <- paste0(base_url, "/api/dataSets?fields=id,name,shortName&paging=false")
  r <- httr::content(httr::GET(url, httr::authenticate(username, password)),
                     as = "parsed")
  do.call(rbind.data.frame, r$dataSets)
>>>>>>> main
}

#' Get the relevant dataset
#'
<<<<<<< HEAD
#' @param base_url the web address of the server the user wishes to log in to
#' @param username the user name
#' @param password the user's password
#' @param attribute_id a comma-separated list of DHIS2 attribute ids. The ids
#'    could be those of a dataSet or an organisationUnit.
#' @param which the target DHIS2 attribute name
#'
#' @return a `list` of 2 elements: a `character` string with the target
#'    attributes ID(s) and a `data.frame` that contains the data of interest
#'    from the specified DHIS2 attribute ids.
#'
#' @examples
#' \dontrun{
#' result <- dhis2_get_relevant_attributes(
#'   attribute_id = "pBOMPrpg1QX,BfMAe6Itzgt",
#'   base_url = "https://play.dhis2.org/dev/",
#'   username = "admin",
#'   password = "district",
#'   which = "dataSets"
#' )
#' }
#' @keywords internal
#'
dhis2_get_relevant_attributes <- function(attribute_id = NULL,
                                          base_url =
                                            "https://play.dhis2.org/dev/",
                                          username = "admin",
                                          password = "district",
                                          which = "dataSets") {
  checkmate::assert_character(base_url,
                              len = 1L, any.missing = FALSE,
                              null.ok = FALSE
  )
  checkmate::assert_character(username,
                              len = 1L, any.missing = FALSE,
                              null.ok = FALSE
  )
  checkmate::assert_character(password,
                              len = 1L, any.missing = FALSE,
                              null.ok = FALSE
  )
  checkmate::assert_character(which,
                              len = 1L, any.missing = FALSE,
                              null.ok = FALSE
  )
  checkmate::assert_character(attribute_id,
                              len = 1L, any.missing = FALSE,
                              null.ok = TRUE
  )
  checkmate::check_choice(which, c(
    "dataSets", "organisationUnits",
    "dataElementGroups", "dataElements"
  ))
  if (is.character(attribute_id)) {
    attribute_id <- unlist(strsplit(attribute_id,
                                    ",",
                                    fixed = TRUE
    ))
  }
  response <- make_api_request(base_url, username, password, which)
  content <- httr::content(response, as = "parsed")
  attributes <- do.call(rbind.data.frame, content[[which]])
  if (which != "dataElements") {
    idx <- which(attribute_id %in% attributes[["id"]])
    if (length(idx) == 0L) {
      stop("Provided attribute ids not found!\n
      Use readepi:::make_api_request() function to view the list of
      available attributes")
    }
    if (length(idx) < length(attribute_id)) {
      warning(
        "\nThe following attribute ids were not found: ",
        glue::glue_collapse(attribute_id[-idx], sep = ", ")
      )
    }
    attribute_id <- paste(attribute_id[idx], collapse = ",")
  }

  res <- switch(which,
                "dataSets" = list(
                  dataset = attribute_id,
                  data_sets = attributes
                ),
                "organisationUnits" = list(
                  organisation_unit = attribute_id,
                  org_units = attributes
                ),
                "dataElementGroups" = list(
                  data_element_group = attribute_id,
                  data_elt_groups = attributes
                ),
                "dataElements" = attributes
  )
  res
}

#' Get the target DHIS2 attribute identifiers and names
#'
#' @param base_url the base URL of the DHIS2 server
#' @param username the user name
#' @param password the user's password
#' @param which the target DHIS2 attribute name.
#'
#' @return an object of type `data.frame` with details about the DHIS2
#'    attributes of interest.
#' @export
#'
#' @examples
#' \dontrun{
#' datasets <- get_dhis2_attributes(
#'   base_url = "https://play.dhis2.org/dev/",
#'   username = "admin",
#'   password = "district",
#'   which = "dataSets"
#' )
#' }
get_dhis2_attributes <- function(base_url = "https://play.dhis2.org/dev/",
                                 username = "admin",
                                 password = "district",
                                 which = "dataSets") {
  checkmate::assert_character(base_url,
                              len = 1L, any.missing = FALSE,
                              null.ok = FALSE, pattern = "https://"
  )
  checkmate::assert_character(username,
                              len = 1L, any.missing = FALSE,
                              null.ok = FALSE
  )
  checkmate::assert_character(password,
                              len = 1L, any.missing = FALSE,
                              null.ok = FALSE
  )
  checkmate::assert_character(which,
                              len = 1L, any.missing = FALSE,
                              null.ok = FALSE
  )
  checkmate::check_choice(which, c(
    "dataSets", "organisationUnits",
    "dataElementGroups", "dataElements"
  ))
  response <- make_api_request(base_url, username, password, which)
  content <- httr::content(response, as = "parsed")
  attributes <- do.call(rbind.data.frame, content[[which]])
  attributes
=======
#' @param dataset the dataSets identifiers
#' @param base_url the web address of the server the user wishes to log in to
#' @param username the user name
#' @param password the user's password
#'
#' @return a list with the relevant datasets
#' @examples
#' result <- get_relevant_dataset(
#'  dataset = "pBOMPrpg1QX,BfMAe6Itzgt",
#'  base_url = "https://play.dhis2.org/dev/",
#'  username = "admin",
#'  password = "district"
#' )
#' @export
get_relevant_dataset <- function(dataset, base_url, username, password) {
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
    dataset,
    data_sets
  )
}


#' Get the relevant organisation units
#'
#' @param organisation_unit the organisationUnits identifiers
#' @param base_url the web address of the server the user wishes to log in to
#' @param username the user name
#' @param password the user's password
#'
#' @return a list with the relevant organisation units
#' @examples
#' result <- get_relevant_organisation_unit(
#'  organisation_unit = "DiszpKrYNg8",
#'  base_url = "https://play.dhis2.org/dev/",
#'  username = "admin",
#'  password = "district"
#' )
#' @export
get_relevant_organisation_unit <- function(organisation_unit, base_url,
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
  checkmate::assert_vector(organisation_unit,
                           any.missing = FALSE, min.len = 1,
                           null.ok = FALSE, unique = TRUE
  )
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
    organisation_unit,
    org_units
  )
}


#' Get the relevant data element groups
#'
#' @param data_element_group the dataElementGroups identifiers
#' @param base_url the web address of the server the user wishes to log in to
#' @param username the user name
#' @param password the user's password
#'
#' @return a list with the data elements of interest
#' @export
get_relevant_data_elt_group <- function(data_element_group, base_url,
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
  checkmate::assert_vector(data_element_group,
                           any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE
  )
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
  checkmate::assert_vector(data_element_group,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
  data_elt_groups <- NULL
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

  list(
    data_element_group,
    data_elt_groups
  )
}

#' Get the data element identifiers and names
#'
#' @param username the user name
#' @param password the user's password
#' @param base_url the base URL of the DHIS2 server
#'
#' @export
#'
get_data_elements <- function(base_url, username, password) {
  checkmate::assertCharacter(base_url, len = 1L, null.ok = TRUE,
                             any.missing = FALSE)
  checkmate::assertCharacter(username, len = 1L, null.ok = TRUE,
                             any.missing = FALSE)
  checkmate::assertCharacter(password, len = 1L, null.ok = TRUE,
                             any.missing = FALSE)

  url <- paste0(base_url,
                "/api/dataElements?fields=id,name,shortName&paging=false")
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
#' @export
#'
get_organisation_units <- function(base_url, username, password) {
  checkmate::assertCharacter(base_url, len = 1L, null.ok = FALSE,
                             any.missing = FALSE)
  checkmate::assertCharacter(username, len = 1L, null.ok = FALSE,
                             any.missing = FALSE)
  checkmate::assertCharacter(password, len = 1L, null.ok = FALSE,
                             any.missing = FALSE)

  url <- paste0(base_url,
                "/api/organisationUnits?fields=id,name,shortName&paging=false")
  r <- httr::content(httr::GET(url, httr::authenticate(username, password)),
                     as = "parsed")
  do.call(rbind.data.frame, r$organisationUnits)
>>>>>>> main
}
