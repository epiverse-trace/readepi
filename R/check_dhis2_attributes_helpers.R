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
}

#' Get the relevant dataset
#'
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
}
