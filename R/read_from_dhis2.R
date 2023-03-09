#' Import data form DHIS2 into R
#' @param base.url the web address of the server the user wishes to log in to
#' @param data.path the path to the data
#' @param user.name the user name
#' @param password the user password
#' @param records a vector or a comma-separated string of subset of subject IDs. When specified, only the records that correspond to these subjects will be imported.
#' @param fields a vector or a comma-separated string of column names. If provided, only those columns will be imported.
#' @returns a data frame
#' @export
read_from_dhis2 <- function(base.url,
                            data.path,
                            user.name,
                            password,
                            records = NULL,
                            fields = NULL) {

  # base.url<-"https://covid19.moh.gm/tracker/"
  # url<-paste0(base.url,"api/resources")
  # username<-"amie.badjie"
  # password<-"Amie@123"
  # login<-GET(url, authenticate(username,password))
  #
  # mydata<-paste0(base.url,"api/reportTables/EGxmvn086IK/data.xml") %>% #Define the API endpoint
  #      GET(.,authenticate(username,password)) %>% #Make the HTTP call
  #      content(.,"text") %>% #Read the response
  #      rio::import()

  if (!is.null(records) & !is.null(fields)) {
    # use datimutils package to read user specified records and fields
    if (is.vector(fields)) {
      fields <- paste(fields, collapse = ",")
    }
    if (is.character(records)) {
      records <- as.character(unlist(strsplit(records, ",")))
    }
    datimutils::loginToDATIM(username = user.name, password = password, base_url = base.url)
    data <- datimutils::getDataElementGroups(records, fields = fields)
  } else if (is.null(records) & is.null(fields)) {
    # use httr and readr packages to read the entire dataset
    # use httr and rio packages to read the entire dataset
    url <- paste0(base.url,"api/me")
    login <- httr::GET(url, httr::authenticate(user.name, password))
    if (login$status != 200L) {
      stop("\nCould not login")
    }
    # Define the API endpoint
    api.end.point <- paste0(base.url, "api/", data.path)

    # Make the HTTP call
    res.http.call = httr::GET(api.end.point,
                              httr::authenticate(user.name, password)
                              )

    # Read the response
    request.content = httr::content(res.http.call, "text")

    # Parse the CSV
    data = xml2::read_html(request.content)
      readr::read_csv(request.content)
      rio::import(request.content)
  }

  data
}
