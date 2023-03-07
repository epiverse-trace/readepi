#' Import data form DHIS2 into R
#' @param base.url the web address of the server the user wishes to log in to
#' @param user the user name
#' @param password the user password
#' @param records a vector or a comma-separated string of subset of subject IDs. When specified, only the records that correspond to these subjects will be imported.
#' @param fields a vector or a comma-separated string of column names. If provided, only those columns will be imported.
#' @returns a data frame
#' @export
read_from_dhis2 <- function(base.url, user, password, records = NULL, fields = NULL) {
  if (!is.null(records) & !is.null(fields)) {
    # use datimutils package to read user specified records and fields
    if (is.vector(fields)) {
      fields <- paste(fields, collapse = ",")
    }
    if (is.character(records)) {
      records <- as.character(unlist(strsplit(records, ",")))
    }
    datimutils::loginToDATIM(username = user, password = password, base_url = base.url)
    data <- datimutils::getDataElementGroups(records, fields = fields)
  } else if (is.null(records) & is.null(fields)) {
    # use httr and readr packages to read the entire dataset
    login <- httr::GET(base.url, httr::authenticate(user, password))
    if (login$status != 200L) {
      stop("Could not login")
    }
    data <- paste0(base.url, "api/reportTables/KJFbpIymTAo/data.csv") %>% # Define the API endpoint
      httr::GET(., httr::authenticate(user, password)) %>% # Make the HTTP call
      httr::content(., "text") %>% # Read the response
      readr::read_csv() # Parse the CSV
  }

  data
}
