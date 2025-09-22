#' Import data from SORMAS
#'
#' The function returns the following columns by default: \code{case_id,
#' person_id, sex, date_of_birth, case_origin, country, city, latitude,
#' longitude, case_status, date_onset, date_admission, outcome, date_outcome,
#' contact_id, date_last_contact, date_first_contact, Ct_values}.
#'
#' @param login A list with the user's authentication details
#' @param disease A character with the target disease name
#' @param since A Date value in ISO8601 format (YYYY-mm-dd). Default is `0` i.e.
#'    to fetch all cases from the beginning of data collection.
#'
#' @return A data frame with the case data of the specified disease.
#' @export
#'
#' @examples
#' \dontrun{
#'   # establish the connection to the SORMAS system
#'   sormas_login <- login(
#'     type = "sormas",
#'     from = "https://demo.sormas.org/sormas-rest",
#'     user_name = "SurvSup",
#'     password = "Lk5R7JXeZSEc"
#'   )
#'   # fetch all COVID (coronavirus) cases from the test SORMAS instance
#'   covid_cases <- read_sormas(
#'     login = sormas_login,
#'     disease = "coronavirus"
#'   )
#' }
#'
#' @details
#' Note that the some values in the `date_of_birth` column of the output object
#' might not have some missing elements such a missing year (NA-12-26), month
#' (2025-NA-01) or date (2025-12-NA), or a combination of two missing elements.
#'
read_sormas <- function(login, disease, since = 0) {
  checkmate::assert_vector(
    disease, min.len = 1L, null.ok = FALSE, any.missing = FALSE
  )
  checkmate::assert_list(
    login, any.missing = FALSE, types = "character",
    null.ok = FALSE, len = 3
  )
  checkmate::assert_named(
    login, type = "named",
    .var.name = c("base_url", "user_name", "password")
  )
  url_check(login[["base_url"]])

  # check and convert the value of 'since'
  if (since != 0 && !inherits(since, "Date")) {
    cli::cli_abort(c(
      x = "Incorrect value for {.emph since} argument!",
      i = "The value for {.emph since} argument must be of type \\
          {.cls Date} in {.strong ISO8601} format."
    ))
  }
  since <- as.numeric(as.POSIXct(since, origin = "1970-01-01"))

  # check if the specified disease is accounted for in SORMAS
  cli::cli_progress_step("Checking whether the disease names are correct.")
  disease <- tolower(disease)
  sormas_diseases <- sormas_get_diseases(login = login)
  sormas_diseases[["disease"]] <- tolower(sormas_diseases[["disease"]])
  verdict <- match(disease, sormas_diseases[["disease"]])
  if (all(is.na(verdict))) {
    cli::cli_abort(c(
      x = "Incorrect disease {cli::qty(length(verdict))} name{?s} supplied!",
      i = "Please run {.fn sormas_get_diseases} to see the full list of \\
           available disease names."
    ))
  }
  if (anyNA(verdict)) {
    cli::cli_alert_warning(
      "{.strong {disease[is.na(verdict)]}} not found in disease list. Please \\
      use {.fn sormas_get_diseases} function to see the full list of \\
      disease names."
    )
  }
  disease <- disease[!is.na(verdict)]

  cli::cli_progress_step("Getting clinical data")
  # send a query to fetch the data from the cases endpoint
  cases_data <- sormas_get_cases_data(
    login = login,
    disease = disease,
    since = since
  )

  cli::cli_progress_step("Getting socio-demographic data")
  # get the persons data
  persons_data <- sormas_get_persons_data(
    login = login,
    since = since
  )

  # keep only persons with a corresponding uuid from the cases data frame
  # the person's uuid has a foreign key in the cases table. this is used to
  # match the cases to the person data.
  final_data <- cases_data |> dplyr::left_join(
    persons_data, by = "case_id", relationship = "many-to-many"
  )

  cli::cli_progress_step("Getting contact data")
  # fetch all contacts details from the 'contacts' endpoint where we can extract
  # contact tracing data such as 'date_first_contact', 'date_last_contact'.
  # the case and contact data will be merged based on their 'uuid' column
  # Note that not all cases have reported contact information
  contact_data <- sormas_get_contact_data(
    login = login,
    since = since
  )
  final_data <- final_data |> dplyr::left_join(contact_data, by = "case_id")

  cli::cli_progress_step("Getting laboratory tests data")
  # Add the Ct (cycle threshold) values from the lab test
  # Pathogen tests are linked with sample. The sample then is connected to a
  # case. From the pathogen test data, we can extract the Ct values and the
  # associated sample case uuids.
  pathogen_tests_data <- sormas_get_pathogen_data(
    login = login,
    since = since
  )
  final_data <- final_data |> dplyr::left_join(
    pathogen_tests_data,
    by = "case_id"
  )

  return(final_data)
}
