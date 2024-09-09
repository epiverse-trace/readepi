#' Get the list of disease names for which cases data is available in a
#' given health information system (HIS).
#'
#' @param from The name of the HIS. Possible values are: sormas, dhis2, odk,
#'    redcap, global.health, goData
#' @param user_name The user name
#' @param password The user's password
#'
#' @return A vector of the list of disease names.
#' @export
#'
#' @examples
#' # get the disease names from SORMAS
#' sormas_diseases <- get_disease_names(
#'   from = "sormas",
#'   user_name = "SurvSup",
#'   password = "Lk5R7JXeZSEc"
#' )
#'
get_disease_names <- function(from, user_name, password) {
  from <- match.arg(from, choices = c("sormas", "dhis2", "odk", "redcap",
                                      "global.health", "goData"))
  # TODO: automate the process of fetching the disease names

  disease_names <- switch(
    from,
    sormas = sormas_get_diseases(user_name, password)
  )


  return(disease_names)
}

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
  resp <- httr2::request(url) |>
    httr2::req_auth_basic(user_name, password) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  content <- lapply(resp, function(x) {unlist(x)})
  disease_names <- suppressMessages(dplyr::bind_rows(content))
  disease_names <- disease_names %>%
    dplyr::select(c(disease, active))
  return(disease_names)
}
