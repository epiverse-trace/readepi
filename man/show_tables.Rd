% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/show_tables.R
\name{show_tables}
\alias{show_tables}
\title{Display the list of tables in a database}
\usage{
show_tables(data_source, driver_name, credentials_file = NULL)
}
\arguments{
\item{data_source}{the URL of the server of interest}

\item{driver_name}{the name of the MS driver. use \code{odbc::odbcListDrivers()}
to display the list of installed drivers}

\item{credentials_file}{the path to the file with the user-specific
credential details for the projects of interest. See the help of
the \code{readepi} function for more details.}
}
\value{
a \code{character} that contains the list of all tables found
in the specified database.
}
\description{
Display the list of tables in a database
}
\examples{
\dontrun{
show_tables(
  data_source      = "mysql-rfam-public.ebi.ac.uk",
  credentials_file = system.file("extdata", "test.ini", package = "readepi"),
  driver_name      = ""
)
}
}
