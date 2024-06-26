#' Make an API request to the target DHIS2 system
#'
#' @param base_url the base URL of the DHIS2 server
#' @param user_name the user name
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
#' @examples
#' \dontrun{
#'   response <- dhis2_make_api_request(
#'     base_url  = file.path("https:/", "play.dhis2.org", "demo"),
#'     user_name = "admin",
#'     password  = "district",
#'     which     = "dataElements"
#'   )
#' }
#'
dhis2_make_api_request <- function(base_url,
                                   user_name,
                                   password,
                                   which = "dataElements") {
  url <- file.path(
    base_url,
    "api",
    glue::glue(which, "?fields=id,name,shortName&paging=false")
  )
  req <- httr2::request(url) %>%
    httr2::req_auth_basic(user_name, password) %>%
    httr2::req_perform()
  req
}

#' Get the relevant dataset
#'
#' @param base_url the web address of the server the user wishes to log in to
#' @param user_name the user name
#' @param password the user's password
#' @param attribute_id a vector of DHIS2 attribute ids. The ids
#'    could be those of a dataSet or an orgUnit.
#' @param which the target DHIS2 end point
#'
#' @return a `list` of 2 elements: a `character` string with the target
#'    attributes ID(s) and a `data.frame` that contains the data of interest
#'    from the specified DHIS2 attribute ids.
#'
#' @examples
#' \dontrun{
#' result <- dhis2_get_relevant_attributes(
#'   base_url     = "https://play.dhis2.org/demo",
#'   user_name    = "admin",
#'   password     = "district",
#'   attribute_id = c("pBOMPrpg1QX", "BfMAe6Itzgt"),
#'   which        = "dataSets"
#' )
#' }
#' @keywords internal
dhis2_get_relevant_attributes <- function(base_url,
                                          user_name,
                                          password,
                                          attribute_id  = NULL,
                                          which         = "dataSets") {
  checkmate::assert_character(which,
                              len = 1L, any.missing = FALSE,
                              null.ok = FALSE)
  checkmate::assert_vector(attribute_id,
                           min.len = 1L, any.missing = FALSE,
                           null.ok = TRUE)
  checkmate::check_choice(which, c("dataSets", "dataElementGroups",
                                   "organisationUnits",
                                   "organisationUnitGroups", "dataElements"))

  response   <- dhis2_make_api_request(base_url, user_name, password, which)
  content    <- httr2::resp_body_json(response)
  attributes <- content %>% dplyr::bind_rows()
  if (which != "dataElements") {
    idx <- which(attribute_id %in% attributes[["id"]])
    if (length(idx) == 0L) {
      stop("Provided attribute ids not found!",
           "Use readepi:::dhis2_make_api_request() function to view the list",
           "of available attributes")
    }
    if (length(idx) < length(attribute_id)) {
      warning(
        "\nThe following attribute ids were not found: ",
        glue::glue_collapse(attribute_id[-idx], sep = ", ")
      )
    }
    attribute_id <- glue::glue_collapse(attribute_id[idx], sep = ",")
  }

  res <- switch(
    which,
    dataSets               = list(dataset   = attribute_id,
                                  data_sets = attributes),
    dataElementGroups      = list(data_element_group = attribute_id,
                                  data_elt_groups    = attributes),
    organisationUnits      = list(organisation_unit = attribute_id,
                                  org_units         = attributes),
    organisationUnitGroups = list(organisation_unit_group = attribute_id,
                                  org_units_groups        = attributes),
    dataElements           = attributes
  )
  res
}

#' Get the target DHIS2 attribute identifiers and names
#'
#' @param base_url the base URL of the DHIS2 server
#' @param user_name the user name
#' @param password the user's password
#' @param which the target DHIS2 attribute name.
#'
#' @return an object of type `data.frame` with details about the DHIS2
#'    attributes of interest.
#' @export
#'
#' @examples
#' \dontrun{
#' datasets <- dhis2_get_attributes(
#'   base_url  = "https://play.dhis2.org/demo/",
#'   user_name = "admin",
#'   password  = "district",
#'   which     = "dataSets"
#' )
#' }
dhis2_get_attributes <- function(base_url,
                                 user_name,
                                 password,
                                 which = "dataSets") {
  url_check(base_url)
  checkmate::assert_character(user_name,
                              len = 1L, any.missing = FALSE,
                              null.ok = FALSE)
  checkmate::assert_character(password,
                              len = 1L, any.missing = FALSE,
                              null.ok = FALSE)
  checkmate::assert_character(which,
                              len = 1L, any.missing = FALSE,
                              null.ok = FALSE)
  checkmate::check_choice(which, c("dataSets", "organisationUnits",
                                   "dataElementGroups", "dataElements"))
  response   <- dhis2_make_api_request(base_url, user_name, password, which)
  content    <- httr2::resp_body_json(response)
  attributes <- content %>% dplyr::bind_rows()
  attributes
}
