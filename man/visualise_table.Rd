% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_servers_helpers.R
\name{visualise_table}
\alias{visualise_table}
\title{Visualize the first 5 rows of the data from a table}
\usage{
visualise_table(data_source, credentials_file, from, driver_name)
}
\arguments{
\item{data_source}{the the URL of the HIS}

\item{credentials_file}{the path to the file with the user-specific
credential details for the projects of interest}

\item{from}{the table name}

\item{driver_name}{the name of the MS driver}
}
\value{
prints the first 5 rows of the specified table.
}
\description{
Visualize the first 5 rows of the data from a table
}
\examples{
\dontrun{
  result <- visualise_table(
    data_source      = "mysql-rfam-public.ebi.ac.uk",
    credentials_file = system.file("extdata", "test.ini",
                                   package = "readepi"),
    from             = "author",
    driver_name      = ""
  )
}

}
