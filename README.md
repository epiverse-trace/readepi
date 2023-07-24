
<!-- README.md is generated from README.Rmd. Please edit that file -->

# readepi: Read data from health information systems <img src="man/figures/logo.png" align="right" width="130"/>

<!-- badges: start -->

[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R-CMD-check](https://github.com/epiverse-trace/readepi/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/epiverse-trace/readepi/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/epiverse-trace/readepi/branch/main/graph/badge.svg)](https://app.codecov.io/gh/epiverse-trace/readepi?branch=main)
[![lifecycle-concept](https://raw.githubusercontent.com/reconverse/reconverse.github.io/master/images/badge-maturing.svg)](https://www.reconverse.org/lifecycle.html#concept)
<!-- badges: end -->

**readepi** is an R package for reading data from several health
information systems (HIS) including public repositories, relational
database management systems (RDBMS), and files of almost any formats.

**readepi** currently supports reading data from the following:

- All file formats in the
  [rio](https://cran.r-project.org/web/packages/rio/vignettes/rio.html)
  package  
- Files of formats that are not covered by `rio` package  
- RDBMS (Relational DataBase Management Systems) such as MS SQL, MySQL,
  and PostgreSQL 
- [REDCap](https://projectredcap.org/software/): Research Electronic
  Data Capture - a secure web application for building and managing
  online surveys and databases  
- [DHIS2](https://dhis2.org/about/): an open source and web-based
  platform for managing health information  
- [Fingertips](https://fingertips.phe.org.uk/): a repository of public
  health indicators in England

**readepi** returns a list object containing one or more data frames.
**readepi** also has a number of auxiliary functions the import of a
subset of original dataset.

**readepi** is developed by
[Epiverse-TRACE](https://data.org/initiatives/epiverse/) team at the
Medical Research Center, The Gambia unit at London School of Hygiene and
Tropical Medicine (<MRCG@LSHTM>).

## Installation

You can install the development version of **readepi** from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
# devtools::install_github("epiverse-trace/readepi", build_vignettes = TRUE)
if (!require("pak")) install.packages("pak")
pak::pak("epiverse-trace/readepi")
library(readepi)
```

## Quick start

The main function **readepi** is `readepi()` that reads data from a
specified source. The `readepi()` function accepts a user-supplied
string (combination of the path to the file, file name, and file
extension) as argument. The examples below show how to use the
`readepi()` function to import data from a variety of sources.

### Reading data from files

``` r
# READING FROM JSON FILE
file <- system.file("extdata", "test.json", package = "readepi")
data <- readepi(file_path = file)

# IMPORTING DATA FROM SHEET IN EXCEL FILE
file <- system.file("extdata", "test.xlsx", package = "readepi")
data <- readepi(file_path = file, which = "Sheet2")
# READING FROM MULTIPLE SHEETS
data <- readepi(file_path = file, which = c("Sheet1", "Sheet2"))

# READING DATA FROM FILES IN A DIRECTORY
dir_path <- system.file("extdata", package = "readepi")
data <- readepi(file_path = dir_path)

# READING DATA FROM FILES WITH SPECIFIC EXTENSION(S) IN A DICECTORY
data <- readepi(file_path = dir_path, pattern = c(".txt", ".xlsx"))
```

### Reading data from RDBMS and HIS

The `readepi()` function can import data from a variety of RDBMS,
including MS SQL, MySQL, and PostgreSQL. Reading data from a RDBMS
requires the following:

1.  MS SQL driver that is compatible with the version of DBMS of
    interest. The **vignette** describes how to install the appropriate
    driver for each database management system.  
2.  Credentials to access the server. **readpi** allows users to create
    and save a file with credentials details, which can then be used as
    one of the `readepi()` function’s arguments to access a database.
    The `show_example_file()` function shows the structure of the
    credential file.

Users can read data from a RDBMS by providing the details of the tables
of interest or an SQL query (for more information, see the
**vignette**).

``` r
# USE THE BELOW FUNCTION TO SEE THE STRUCTUTRE OF CREDENTIAL FILE
show_example_file()

# SETTING UP THE CREDENTIAL FILE
credentials_file <- system.file("extdata", "test.ini", package = "readepi")

# READING FILE FROM A PROJECT IN A REDCap DATABASE
data <- readepi(
  credentials_file = credentials_file,
  project_id = "SD_DATA"
)
project_data <- data$data # accessing the actual data
project_metadeta <- data$metadata # accessing the metadata associated with project

# VIEWING THE LIST OF ALL TABLES IN A MySQL DATABASE
show_tables(
  credentials_file = credentials_file,
  project_id = "Rfam",
  driver_name = "" # note that this example mysql server does not require a driver
)

# VISUAIZE FIRST 5 ROWS OF THE TABLE 'AUTHOR'
visualise_table(
  credentials_file = credentials_file,
  source = "author", # this is the table name
  project_id = "Rfam", # this is the database name
  driver_name = ""
)

# READING ALL FILEDS AND RECORDS FROM A MySQL SERVER
data <- readepi(
  credentials_file = credentials_file,
  project_id = "Rfam", # this is the database name
  driver_name = "",
  source = "author"
)

# READING DATA FROM DHIS2
data <- readepi(
  credentials_file = credentials_file,
  project_id = "DHIS2_DEMO",
  dataset = "pBOMPrpg1QX",
  organisation_unit = "DiszpKrYNg8",
  data_element_group = NULL,
  start_date = "2014",
  end_date = "2023"
)

# READING DATA FROM THE FINGERTIPS REPOSITORY
data <- readepi(
  indicator_id = 90362,
  area_type_id = 202,
  parent_area_type_id = 6 # optional
)
```

## Package Vignettes

The vignette of the **readepi** contains detailed illustrations about
the use of each function. This can be accessed by typing the command
below:

``` r
# OPEN THE VIGNETTE WITHIN RSTUDIO
vignette("readepi")

# OPEN THE VIGNETTE IN YOUR WEB BROWSER.
browseVignettes("readepi")
```

## Help

To report a bug please open an
[issue](https://github.com/%7B%7B%20gh_repo%20%7D%7D/issues/new/choose).

## Contributions

Contributions are welcome via [pull
requests](https://github.com/epiverse-trace/readepi/pulls).

## Code of Conduct

Please note that the readepi project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
