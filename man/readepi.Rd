% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/readepi.R
\name{readepi}
\alias{readepi}
\title{Import data from different data_sources into R}
\usage{
readepi(
  data_source = NULL,
  records = NULL,
  fields = NULL,
  id_position = NULL,
  id_col_name = NULL,
  ...
)
}
\arguments{
\item{data_source}{the URL of the HIS}

\item{records}{a vector or a comma-separated string of subject IDs.
When specified, only these records will be imported.}

\item{fields}{a vector or a comma-separated string of column names.
If provided, only those columns will be imported.}

\item{id_position}{the column position of the variable that unique identifies
the subjects. When the name of the column with the subject IDs is known,
this can be provided using the \code{id_col_name} argument}

\item{id_col_name}{the column name with the subject IDs.}

\item{...}{additional arguments passed to the \code{readepi()} function. These are
enumerated and described in the vignette.}
}
\value{
a \code{list} of 1 or several object(s) of type \verb{data frame}.

a \code{list} of 2 or more object(s) of type \verb{data frame}.
}
\description{
the function allows import of data from Health Information
Systems (HIS), files, and folders.The HIS consist of database management
systems (DBMS) and website of public data collection.
}
\examples{
# reading from a MySQL server
\dontrun{
data <- readepi(
  data_source      = "mysql-rfam-public.ebi.ac.uk",
  credentials_file = system.file("extdata", "test.ini", package = "readepi"),
  driver_name      = "",
  from             = "author"
)
}
}
