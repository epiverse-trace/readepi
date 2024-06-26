% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check_dhis2_attributes-helpers.R
\name{dhis2_make_api_request}
\alias{dhis2_make_api_request}
\title{Make an API request to the target DHIS2 system}
\usage{
dhis2_make_api_request(base_url, user_name, password, which = "dataElements")
}
\arguments{
\item{base_url}{the base URL of the DHIS2 server}

\item{user_name}{the user name}

\item{password}{the user's password}

\item{which}{the target DHIS2 attribute name. Possible values are:
\enumerate{
\item dataSets: to get the dataset identifiers and names
\item organisationUnits: to get the organisation unit identifiers and names
\item dataElementGroups: to get the data element groups identifiers
and names
\item dataElements: to get the data elements identifiers and names
}}
}
\value{
an object of class \code{data.frame} that contains the information of
interest.
}
\description{
Make an API request to the target DHIS2 system
}
\examples{
\dontrun{
  response <- dhis2_make_api_request(
    base_url  = file.path("https:/", "play.dhis2.org", "demo"),
    user_name = "admin",
    password  = "district",
    which     = "dataElements"
  )
}

}
\keyword{internal}
