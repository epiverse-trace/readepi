
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
database management systems (RDBMS), and files of almost any format.

**readepi** currently supports reading data from the following:

- All file formats in the
  [rio](https://cran.r-project.org/web/packages/rio/vignettes/rio.html)
  package  
- File of formats that are not covered by `rio` package  
- RDBMS servers such as MS SQL, MySQL, and PostgreSQL 
- [REDCap](https://projectredcap.org/software/): (Research Electronic
  Data Capture) is a secure web application for building and managing
  online surveys and databases  
- [DHIS2](https://dhis2.org/about/): an open source, web-based platform
  used as a health management information system  
- [Fingertips](https://fingertips.phe.org.uk/): a repository of public
  health indicators in England

**readepi** returns a list object containing one or more data frames. In
addition, **readepi** has a number of auxiliary functions for
manipulating the imported data.

**readepi** is developed by
[Epiverse-TRACE](https://data.org/initiatives/epiverse/) team at the
London School of Hygiene and Tropical Medicine.

## Installation

You can install the development version of **readepi** from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
# devtools::install_github("epiverse-trace/readepi@develop", build_vignettes = TRUE)
library(readepi)
```

## Quick start

The main function in the **readepi** package is `readepi()`, which reads
data from a specified source. The `readepi()` function accepts the
user-supplied string (combination of the path to the file, file name,
and file extension) as argument. The examples below show how to use the
`readepi()` function to import data from a variety of sources.

### Reading data from files

``` r
# Reading data from json file 
file <- system.file("extdata", "test.json", package = "readepi")
data <- readepi(file_path = file)

# Importing data from sheet in excel file
file <- system.file("extdata", "test.xlsx", package = "readepi")
data <- readepi(file_path = file, which = "Sheet2")
# For reading more than one sheet
data <- readepi(file_path = file, which = c("Sheet1", "Sheet2"))

# Reading data from files in a directory
dir_path <- system.file("extdata", package = "readepi")
data <- readepi(file_path = dir_path)

# Reading data from files with specific extension(s) in the directory
data <- readepi(file_path = dir_path, pattern = c(".txt", ".xlsx"))
```

### Reading data from RDBMS and HIS

The `readepi()` method can import data from a variety of DBMS servers,
including MS SQL, MySQL, and PostgreSQL. However, reading data from a
DBMS requires the following:

1.  MS SQL driver that is compatible with the version of DBMS of
    interest. The **vignette** describes how to install the appropriate
    driver for each DBMS server.  
2.  Credentials to access the server. **readpi** accepts a file with
    credentials details, use the `show_example_file()` function to see
    the structure of this file.

Users can read data from DBMS by providing the details of the tables of
interest or an SQL query (for more information, see the **vignette**).

``` r
# Use the below function to see the structure of credential file
show_example_file()

# Specifying the credential file
credentials_file <- system.file("extdata", "test.ini", package = "readepi")

# Reading file from a project in a database
data <- readepi(
  credentials_file = credentials_file,
  project_id = "SD_DATA"
)
project_data <- data$data # accessing the acutal data
project_metadeta <- data$metadata # acessing the metadata associated with project

# Displaying the list of all tables in a MySQL database server
show_tables(
  credentials_file = credentials_file,
  project_id = "Rfam",
  driver_name = ""
)
# **Note** that the MS SQL server does not require  a driver. 
# Visualize first 5 rows of the table 'author'
visualise_table(
  credentials_file = credentials_file,
  source = "author", # this is the table name
  project_id = "Rfam", # this is the database name
  driver_name = ""
)

# Reading all fields and records from a MS SQL sever
data <- readepi(
  credentials_file = credentials_file,
  project_id = "Rfam", # this is the database name
  driver_name = "",
  source = "author"
)

# reading data from DHIS2
data <- readepi(
  credentials_file = credentials_file,
  project_id = "DHIS2_DEMO",
  dataset = "pBOMPrpg1QX",
  organisation_unit = "DiszpKrYNg8",
  data_element_group = NULL,
  start_date = "2014",
  end_date = "2023"
)

# Reading data from Fingertips repo
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
[issue](https://github.com/epiverse-trace/readepi/issues/new/choose).

## Contributions

Contributions are welcome via [pull
requests](https://github.com/epiverse-trace/readepi/pulls).

## Code of Conduct

Please note that the readepi project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
