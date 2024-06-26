% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check_dhis2_attributes-helpers.R
\name{dhis2_get_attributes}
\alias{dhis2_get_attributes}
\title{Get the target DHIS2 attribute identifiers and names}
\usage{
dhis2_get_attributes(base_url, user_name, password, which = "dataSets")
}
\arguments{
\item{base_url}{the base URL of the DHIS2 server}

\item{user_name}{the user name}

\item{password}{the user's password}

\item{which}{the target DHIS2 attribute name.}
}
\value{
an object of type \code{data.frame} with details about the DHIS2
attributes of interest.
}
\description{
Get the target DHIS2 attribute identifiers and names
}
\examples{
\dontrun{
datasets <- dhis2_get_attributes(
  base_url  = "https://play.dhis2.org/demo/",
  user_name = "admin",
  password  = "district",
  which     = "dataSets"
)
}
}
