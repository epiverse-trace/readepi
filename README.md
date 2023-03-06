
<!-- README.md is generated from README.Rmd. Please edit that file -->

# readepi

*readepi* provides functions for importing data into **R** from files
and common *health information systems*.

<!-- badges: start -->

[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R-CMD-check](https://github.com/epiverse-trace/readepi/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/epiverse-trace/readepi/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/epiverse-trace/readepi/branch/main/graph/badge.svg)](https://app.codecov.io/gh/epiverse-trace/readepi?branch=main)
[![lifecycle-concept](https://raw.githubusercontent.com/reconverse/reconverse.github.io/master/images/badge-concept.svg)](https://www.reconverse.org/lifecycle.html#concept)
<!-- badges: end -->

## Installation

You can install the development version of readepi from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
# devtools::install_github("epiverse-trace/readepi", build_vignettes = TRUE)
suppressPackageStartupMessages(library(readepi))
```

# Reading data from file or directory

`readepi` allows importing data from several file types into R,
including:

- all file formats in the
  [rio](https://cran.r-project.org/web/packages/rio/vignettes/rio.html)
  package.  
- file formats that are not accounted for by `rio`

When reading data from file or directory, the function expects the
following arguments:  
`file.path`: the path to the file of interest. When several files need
to be imported from a directory, this should be the path to that
directory,  
`sep`: the separator between the columns in the file. This is only
required for space-separated files,  
`format`: a string used to specify the file format. This is useful when
a file does not have an extension, or has a file extension that does not
match its actual type,  
`which`: a string used to specify which objects should be extracted
(e.g. the name of the excel sheet to import),  
`pattern`: when provided, only files that contain this pattern will be
imported from the specified directory.  
The function will return a list of data frames (if several files were
imported from a directory).

# Reading data from relational database management systems (RDBMS): HDSS, EMRS, REDCap

Research data are usually stored in either relational databases or NoSQL
databases. For instance, at the MRCG, project data are stored in
relational databases. The HDSS and EMRS host databases that run under MS
SQL Server, while REDCap (that uses an EAV schema) run under a MySQL
server.  
To import data from a HDSS or EMRS (MS SQL Server) into R, some
dependencies need to be installed first.

## installation of dependencies

If you are using a Unix-based system, you will need to install the MS
ODBC driver that is compatible with the version of the target MS SQL
server. For **SQL server 2019, version 15.0**, we installed **ODBC
Driver 17 for SQL Server** on the mac OS. This is compatible with the
MRCG test server `robin.mrc.gm`. Details about how to install the
**odbc** package and odbc drivers can be found at [the odbc github
page](https://github.com/r-dbi/odbc#installation) and
[here](https://learn.microsoft.com/en-us/sql/connect/odbc/linux-mac/install-microsoft-odbc-driver-sql-server-macos?view=sql-server-ver15).  
Once installed, the list of drivers can be displayed in R using:
`odbc::odbcListDrivers()`.  
It is important to view the data that is stored in the MS SQL server. I
recommend to install a GUI such as `Azure Data Studio`.

## importing data from RDBMS into R

Users should be granted with read access to be able to pull data from
the RDBMS.  
The **read_epi()** expects the following arguments:  
`credentials.file`: the path to the file with the user-specific
credential details for the projects of interest. This is a tab-delimited
file with the following columns:

- user_name: the user name,  
- password: the user password (for REDCap, this corresponds to the
  **token** that serves as password to the project),  
- host_name: the host name (for HDSS and EMRS) or the URI (for
  REDCap),  
- project_id: the project ID (for REDCap) or the name of the database
  (for HDSS and EMRS) you are access to,  
- comment: a summary description about the project or database of
  interest,  
- dbms: the name of the DBMS: ‘redcap’ or ‘REDCap’ when reading from
  REDCap, ‘sqlserver’ or ‘SQLServer’ when reading from MS SQL Server,  
- port: the port ID (used for MS SQL Servers only).  
  `project.id` for relational DB, this is the name of the database that
  contains the table from which the data should be pulled. Otherwise, it
  is the project ID you were given access to. Note that this should be
  similar to the value of the **project_id** field in the credential
  file.  
  `driver.name` the name of the MS driver (only for HDSS and EMRS). use
  `odbc::odbcListDrivers()` to display the list of installed drivers,  
  `table.name`: the name of the target table (only for HDSS and EMRS),  
  `records`: a vector or a comma-separated string of a subset of subject
  IDs. When specified, only the records that correspond to these
  subjects will be imported,  
  `fields`: a vector or a comma-separated string of column names. If
  provided, only those columns will be imported,  
  `id.position`: the column position of the variable that unique
  identifies the subjects. This should only be specified when the column
  with the subject IDs is not the first column. default is 1.

When reading from REDCap, the function returns a list with 2 data
frames, that represent respectively the data and its associated
metadata.

## Vignette

The vignette of the **readepi** contains detailed illustration about the
used of the functions. This can be accessed by typing the command below:

``` r
browseVignettes("readepi")
```

## Development

### Lifecycle

This package is currently a *concept*, as defined by the [RECON software
lifecycle](https://www.reconverse.org/lifecycle.html). This means that
essential features and mechanisms are still being developed, and the
package is not ready for use outside of the development team.

### Contributions

Contributions are welcome via [pull
requests](https://github.com/epiverse-trace/readepi/pulls).

Contributors to the project include:

- Karim Mané (author)
- Thibaut Jombart (author)

### Code of Conduct

Please note that the linelist project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
