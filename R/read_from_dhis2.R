#' Import data form DHIS2
#'
#' @param base_url the web address of the server the user wishes to log in to
#' @param user_name the user name
#' @param password the user password
#' @param query_parameters a list with the parameters that will be used to
#'    determine which data is returned by the query. The possible values are:
#'    \enumerate{
#'        \item dataSet: a vector or a list of comma-separated data set
#'            identifiers (required)
#'        \item dataElementGroup: a vector or a list of comma-separated data
#'            element group identifiers. This is not needed when the 'dataSet'
#'            is provided
#'        \item orgUnit: a vector or a list of comma-separated organisation
#'            unit identifiers (required)
#'        \item orgUnitGroup: a vector or a list of comma-separated organisation
#'            unit group identifiers. This is not needed when the 'orgUnit'
#'            is provided
#'        \item startDate: the start date for the time span of the values to
#'            export (required)
#'        \item startDate: the end date for the time span of the values to
#'            export (required)
#'    }
#' @param records a vector or a comma-separated string of subset of subject IDs.
#'    When specified, only the records that correspond to these subjects will be
#'    imported.
#' @param fields a vector or a comma-separated string of column names.
#'    If provided, only those columns will be imported.
#' @param id_col_name the column name with the records of interest.
#'
#' @returns a `list` of 1 element of type `data frame`.
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' data <- read_from_dhis2(
#'   base_url         = "https://play.dhis2.org/demo",
#'   user_name        = "admin",
#'   password         = "district",
#'   query_parameters = list(dataSet   = "BfMAe6Itzgt",
#'                           orgUnit   = "Umh4HKqqFp6",
#'                           startDate = "2014",
#'                           endDate   = "2023"),
#'   records          = NULL,
#'   fields           = NULL,
#'   id_col_name      = "dataElement"
#' )
#' }
read_from_dhis2 <- function(base_url,
                            user_name,
                            password,
                            query_parameters,
                            records     = NULL,
                            fields      = NULL,
                            id_col_name = "dataElement") {
  url_check(base_url)
  checkmate::assert_character(user_name,
                              len = 1L, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_character(password,
                              len = 1L, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_list(query_parameters, min.len = 1L, null.ok = FALSE,
                         any.missing = FALSE)

  # checking user credentials
  dhis2_login(base_url, user_name, password)

  # split the query parameters if they are passed as a list of comma-separated
  # elements
  query_parameters <- lapply(
    sapply(unlist(query_parameters), strsplit, ",", fixed = TRUE), # nolint: undesirable_function_linter
    trimws
  )

  # checking the attribute details
  attributes <- dhis2_check_attributes(base_url, user_name, password,
                                       query_parameters)

  # defining the endpoint: we need a better way of choosing the API endpoint.
  # The new implementation should have an argument to let the user define the
  # endpoint.
  # This one is static and only account for dataSets provided by the user
  url    <- file.path(base_url, "api", "dataValueSets.json")

  # fetching the data of interest
  data   <- httr2::request(url) |>
    httr2::req_auth_basic(user_name, password) |>
    httr2::req_method("GET") |>
    httr2::req_url_query(!!!query_parameters, .multi = "explode") |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    dplyr::bind_rows()

  # add the variable names
  tmp_data_elt <- attributes[["data_elements"]][, c("shortName", "id")] |>
    dplyr::rename("dataElement" = "id") # nolint: keyword_quote_linter
  tmp_org_units <- attributes[["org_units_details"]][, c("shortName", "id")] |>
    dplyr::rename("orgUnit" = "id") # nolint: keyword_quote_linter
  data <- data |>
    dplyr::left_join(tmp_data_elt, by = "dataElement") |>
    dplyr::rename("dataElementName" = "shortName") |> # nolint: keyword_quote_linter
    dplyr::left_join(tmp_org_units, by = "orgUnit") |>
    dplyr::rename("OrgUnitName" = "shortName") # nolint: keyword_quote_linter

  # subsetting fields
  data <- dhis2_subset_fields(data, fields)

  # subsetting records
  data <- dhis2_subset_records(data, records, id_col_name)

  list(
    data     = data,
    metadata = NA
  )
}
