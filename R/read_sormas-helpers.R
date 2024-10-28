#' Get list of disease names from SORMAS
#'
#' @inheritParams get_disease_names
#'
#' @return A vector of the list of disease names in SORMAS
#' @keywords internal
#'
sormas_get_diseases <- function(user_name, password) {
  url <- file.path(
    "https://demo.sormas.org/sormas-rest",
    "diseaseconfigurations",
    "all",
    0
  )
  resp <- httr2::request(url) %>%
    httr2::req_auth_basic(user_name, password) %>%
    httr2::req_perform() %>%
    httr2::resp_body_json()
  content <- lapply(resp, unlist)
  disease_names <- suppressMessages(dplyr::bind_rows(content))

  # only return columns with the disease names and whether a disease is active
  # or not
  target_columns <- c("disease", "active")
  disease_names <- disease_names %>%
    dplyr::select(dplyr::all_of(target_columns))
  return(disease_names)
}

#' Update data filtration options based on the user-provided parameters.
#'
#' @param filter A list with the user-defined data filtration option
#'
#' @return A list with the data filtration options to be applied on the imported
#'    data
#' @keywords internal
#'
sormas_get_filters <- function(filter) {
  # get the default filters
  default_filters <- get_default_filters()

  # set 'since' to 0 if filter is NULL - the default value for SORMAS
  # otherwise, make sure this date is numeric
  if (is.null(filter)) {
    filter[["since"]] <- 0
  } else {
    if (!checkmate::test_numeric(filter[["since"]]) &&
        lubridate::is.Date(filter[["since"]])) {
      filter[["since"]] <- as.numeric(as.POSIXct(filter[["since"]]))
    }
  }

  # modify the default parameters with the user-provided parameters
  filters <- modify_default_filters(default_filters, filter, FALSE)

  return(filters)
}
