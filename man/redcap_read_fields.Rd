% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_from_redcap-helpers.R
\name{redcap_read_fields}
\alias{redcap_read_fields}
\title{Subset fields from a REDCap project}
\usage{
redcap_read_fields(base_url, token, fields, id_position = 1L)
}
\arguments{
\item{base_url}{the URI of the REDCap project}

\item{token}{the user-specific string that serves as the password for a
project}

\item{fields}{a vector or a comma-separated string of column names}

\item{id_position}{the column position of the variable that unique identifies
the subjects}
}
\value{
a \code{list} of 2 elements of type \code{data.frame} that contain the project
data with the fields of interest and its associated metadata.
}
\description{
Subset fields from a REDCap project
}
\examples{
\dontrun{
  result <- redcap_read_fields(
    base_url    = "https://bbmc.ouhsc.edu/redcap/api/",
    token       = "9A81268476645C4E5F03428B8AC3AA7B",
    fields      = c("record_id", "name_first", "age", "bmi"),
    id_position = 1L
  )
}

}
\keyword{internal}
