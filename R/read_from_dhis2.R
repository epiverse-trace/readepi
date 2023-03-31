#' Import data form DHIS2 into R
#' @param base.url the web address of the server the user wishes to log in to
#' @param user.name the user name
#' @param password the user password
#' @param dataset a vector or a list of comma-separated data set identifiers
#' @param organisation.unit a vector or a list of comma-separated organisation unit identifiers
#' @param data.element.group a vector or a list of comma-separated data element group identifiers
#' @param start.date the start date for the time span of the values to export
#' @param end.date the end date for the time span of the values to export
#' @param records a vector or a comma-separated string of subset of subject IDs. When specified, only the records that correspond to these subjects will be imported.
#' @param fields a vector or a comma-separated string of column names. If provided, only those columns will be imported.
#' @param id.col.name the column name with the records of interest.
#' @returns a list of data frames
#' @export
read_from_dhis2 <- function(base.url,
                            user.name,
                            password,
                            dataset,
                            organisation.unit,
                            data.element.group,
                            start.date,
                            end.date,
                            records,
                            fields,
                            id.col.name = "dataElement") {
  checkmate::assertCharacter(id.col.name,
    len = 1L, null.ok = TRUE,
    any.missing = FALSE
  )
  checkmate::assertCharacter(base.url,
    len = 1L, null.ok = FALSE,
    any.missing = FALSE
  )
  checkmate::assertCharacter(user.name,
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
  checkmate::assert_vector(start.date,
    any.missing = FALSE, min.len = 1,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(end.date,
    any.missing = FALSE, min.len = 1,
    null.ok = TRUE, unique = TRUE
  )
  # checkmate::assert_vector(period,
  #                          any.missing = FALSE, min.len = 1,
  #                          null.ok = TRUE, unique = TRUE)
  checkmate::assert_vector(records,
    any.missing = FALSE, min.len = 1,
    null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(fields,
    any.missing = FALSE, min.len = 1,
    null.ok = TRUE, unique = TRUE
  )
  # checkmate::assert_number(id.position, lower = 1)

  # checking user credentials
  login(user.name, password, base.url)

  # checking the attribute details
  attributes <- check_dhis2_attributes(
    user.name,
    password,
    base.url,
    dataset,
    organisation.unit,
    data.element.group
  )

  # fetching data
  data <- httr::GET(
    paste0(base.url, "/api/dataValueSets"),
    httr::authenticate(user.name, password),
    query = list(
      dataSet = attributes$dataset,
      orgUnit = attributes$organisation_unit,
      startDate = start.date, # "2014"
      endDate = end.date
    ) # "2023"
  ) |>
    httr::content() |>
    purrr::flatten_dfr()

  # add the variable names
  tmp.data.elt <- attributes$data_elements %>%
    dplyr::select(c(shortName, id)) %>%
    dplyr::rename("dataElement" = "id")
  tmp.org.units <- attributes$org_units_details %>%
    dplyr::select(c(shortName, id)) %>%
    dplyr::rename("orgUnit" = "id")
  data <- data %>%
    dplyr::left_join(tmp.data.elt, by = "dataElement") %>%
    dplyr::rename("dataElementName" = "shortName") %>%
    dplyr::left_join(tmp.org.units, by = "orgUnit") %>%
    dplyr::rename("OrgUnitName" = "shortName")

  # subsetting fields
  if (!is.null(fields)) {
    if (is.character(fields)) fields <- unlist(strsplit(fields, ","))
    idx <- which(fields %in% names(data))
    if (length(idx) == 0) stop("Specified column not not!\nThe data contains the following column:\n", names(data))
    if (length(idx) != length(fields)) {
      warning("The following fields were not found in the data: ", fields[-idx])
      fields <- fields[idx]
    }
    data <- data %>% dplyr::select(dplyr::all_of(fields))
  }

  # subsetting records
  if (!is.null(records)) {
    if (is.character(records)) records <- unlist(strsplit(records, ","))
    id.column.name <- id.col.name # names(data)[id.position]
    idx <- which(records %in% data[[id.column.name]])
    if (length(idx) == 0) {
      stop("Speficied records not found in column: ", id.column.name)
    } else if (length(idx) < length(records)) {
      warning("The following records were not found: ", records[-idx])
      records <- records[idx]
    }
    data <- data[which(data[[id.column.name]] %in% records), ]
  }

  list(data = data)
}
