
<!-- README.md is generated from README.Rmd. Please edit that file. -->
<!-- The code to render this README is stored in .github/workflows/render-readme.yaml -->
<!-- Variables marked with double curly braces will be transformed beforehand: -->
<!-- `packagename` is extracted from the DESCRIPTION file -->
<!-- `gh_repo` is extracted via a special environment variable in GitHub Actions -->

<<<<<<< HEAD
# readepi

*readepi* provides functions for importing data into **R** from files
and common *health information systems*.
=======
# readepi: Read data from health information systems <img src="man/figures/logo.png" align="right" width="130"/>
>>>>>>> review

<!-- badges: start -->

[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R-CMD-check](https://github.com/epiverse-trace/readepi/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/epiverse-trace/readepi/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/epiverse-trace/readepi/branch/main/graph/badge.svg)](https://app.codecov.io/gh/epiverse-trace/readepi?branch=main)
[![lifecycle-concept](https://raw.githubusercontent.com/reconverse/reconverse.github.io/master/images/badge-maturing.svg)](https://www.reconverse.org/lifecycle.html#concept)
<!-- badges: end -->

**{readepi}** is an R package for reading data from several health
information systems (HIS) including public repositories, relational
database management systems (RDBMS).

**{readepi}** currently supports reading data from the followings:

- RDBMS (Relational Database Management Systems) such as MS SQL, MySQL,
  and PostgreSQL 
- [REDCap](https://projectredcap.org/software/): Research Electronic
  Data Capture - a secure web application for building and managing
  online surveys and databases  
- [DHIS2](https://dhis2.org/about/): an open source and web-based
  platform for managing health information  
- [Fingertips](https://fingertips.phe.org.uk/): a repository of public
  health indicators in England

**{readepi}** returns a list object containing one or more data frames.
**{readepi}** also has a number of auxiliary functions that allow
importing a subset of the original dataset.

**{readepi}** is developed by
[Epiverse-TRACE](https://data.org/initiatives/epiverse/) team at the
[Medical Research Center, The Gambia unit at London School of Hygiene
and Tropical
Medicine](https://www.lshtm.ac.uk/research/units/mrc-gambia).

## Installation

You can install the development version of **{readepi}** from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
<<<<<<< HEAD
# devtools::install_github("epiverse-trace/readepi@develop", build_vignettes = TRUE)
library(readepi)
```

## Importing data in R

The `readepi()` function allows importing data from several file types
and database management systems. These include:

- all file formats in the
  [rio](https://cran.r-project.org/web/packages/rio/vignettes/rio.html)
  package.  
- file formats that are not accounted for by `rio`  
- relational database management systems (RDBMS) such as **REDCap**,
  **MS SQL server**, **DHIS2**  
- Fingertips (repository of public health indicators in England)

The function returns an object of class list with one or more data
frames.

### Importing data from files

``` r
# READING DATA FROM JSON file
file <- system.file("extdata", "test.json", package = "readepi")
data <- readepi(file_path = file)

# IMPORTING DATA FROM THE SECOND EXCEL SHEET
file <- system.file("extdata", "test.xlsx", package = "readepi")
data <- readepi(file_path = file, which = "Sheet2")

# IMPORTING DATA FROM THE FIRST AND SECOND EXCEL SHEETS
file <- system.file("extdata", "test.xlsx", package = "readepi")
data <- readepi(file_path = file, which = c("Sheet2", "Sheet1"))
```

### Importing data from several files in a directory

``` r
# READING ALL FILES IN A GIVEN DIRECTORY
dir_path <- system.file("extdata", package = "readepi")
data <- readepi(file_path = dir_path)

# READING ONLY '.txt' FILES
data <- readepi(file_path = dir_path, pattern = ".txt")

# READING '.txt' and '.xlsx' FILES
data <- readepi(file_path = dir_path, pattern = c(".txt", ".xlsx"))
```

### Importing data from DBMS

To read data from DBMS, users can either provide the details of the
tables of interest or an SQL query (see `vignette` for illustration).
The current version of `readepi` allows for data import from:  
1. MS SQL server,  
2. MySQL server,  
3. PostgreSQL server.

This requires the users to:

1.  install the MS SQL driver that is compatible with your SQL server
    version. Details about this installation process can be found in the
    **vignette**.  
2.  create a credentials file where the user credential details will be
    stored. Use the `show_example_file()` to see a template of this
    file.

Note that the examples in this section are based on a MySQL server that
does not require the user to specify the `driver name`. But it is
important to keep in mind that specify the driver name is a requirement
for MS SQL server.

``` r
# DISPLAY THE STRUCTURE OF THE CREDENTIALS FILE
show_example_file()

# DEFINING THE CREDENTIALS FILE
credentials_file <- system.file("extdata", "test.ini", package = "readepi")

# READING ALL FIELDS AND RECORDS FROM A REDCap PROJECT
data <- readepi(
  credentials_file = credentials_file,
  project_id = "SD_DATA"
)
project_data <- data$data
project_metadeta <- data$metadata

# DISPLAY THE LIST OF ALL TABLES IN A DATABASE HOSTED IN A MySQL SERVER
# for the test MySQL server, the driver name does not need to be specified
show_tables(
  credentials_file = credentials_file,
  project_id = "Rfam",
  driver_name = ""
)

# VISUALIZE THE FIRST 5 ROWS OF THE TABLE 'author'
visualise_table(
  credentials_file = credentials_file,
  source = "author", # this is the table name
  project_id = "Rfam", # this is the database name
  driver_name = ""
)

# READING ALL FIELDS AND ALL RECORDS FROM A DATABASE HOSTED BY A MS SQL SERVER
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

# READING FROM FINFERTIPS
data <- readepi(
  indicator_id = 90362,
  area_type_id = 202,
  parent_area_type_id = 6 # optional
)
=======
# devtools::install_github("epiverse-trace/readepi", build_vignettes = TRUE)
if (!require("pak")) install.packages("pak")
pak::pak("epiverse-trace/readepi")
library(readepi)
>>>>>>> review
```

## Quick start

The main function in **{readepi}** is `readepi()`. It reads data from a
specified source. The `readepi()` function accepts a user-supplied
string (the API’s URL) as argument. Other specific arguments can be
provided depending on the data source (see the **vignette** for more
details). The examples below show how to use the `readepi()` function to
import data from a variety of sources.

### Reading data from RDBMS and HIS

The `readepi()` function can import data from a variety of RDBMS,
including MS SQL, MySQL, and PostgreSQL. Reading data from a RDBMS
requires the following:

1.  A MS SQL driver that is compatible with the version of DBMS of
    interest. The **vignette** describes how to install the appropriate
    driver for each database management system.  
2.  Valid Credentials to access the server. The user credential details
    are expected to be stored in a file that will be supplied as an
    argument of the `readepi()` function. Use the `show_example_file()`
    function to visualize the structure of the template credential file.

Users can read data from a RDBMS by providing the details of the tables
of interest or an SQL query (for more information, see the
**vignette**).

The vignette of the **readepi** contains detailed illustrations about
the use of each function. This can be accessed by typing the command
below:

``` r
<<<<<<< HEAD
# OPEN THE VIGNETTE WITHIN RSTUDIO
vignette("readepi")

# OPEN THE VIGNETTE IN YOUR WEB BROWSER. 
=======
# DISPLAY THE STRUCTUTRE OF THE TEMPLATE CREDENTIAL FILE
show_example_file()

# DEFINE THE PATH TO THE CREDENTIAL FILE
credentials_file <- system.file("extdata", "test.ini", package = "readepi")

# READING FILE FROM A PROJECT IN A REDCap DATABASE
dat <- readepi(
  data_source      = "https://bbmc.ouhsc.edu/redcap/api/",
  credentials_file = credentials_file
)
project_data     <- dat$data # accessing the actual data
project_metadeta <- dat$metadata # accessing the metadata associated with project

# VIEWING THE LIST OF ALL TABLES IN A MySQL DATABASE
show_tables(
  data_source      = "mysql-rfam-public.ebi.ac.uk",
  credentials_file = credentials_file,
  driver_name      = "" # note that this example MySQL server does not require a driver
)

# VISUAIZE FIRST 5 ROWS OF THE TABLE 'AUTHOR'
visualise_table(
  data_source      = "mysql-rfam-public.ebi.ac.uk",
  credentials_file = credentials_file,
  from             = "author", # this is the table name
  driver_name      = ""
)

# READING ALL FILEDS AND RECORDS FROM A MySQL SERVER
dat <- readepi(
  data_source      = "mysql-rfam-public.ebi.ac.uk",
  credentials_file = credentials_file,
  from             = "author", # this is the table name
  driver_name      = ""
)

# READING DATA FROM DHIS2
dat <- readepi(
  data_source        = "https://play.dhis2.org/dev",
  credentials_file   = credentials_file,
  dataset            = "pBOMPrpg1QX",
  organisation_unit  = "DiszpKrYNg8",
  data_element_group = NULL,
  start_date         = "2014",
  end_date           = "2023"
)

# READING DATA FROM THE FINGERTIPS REPOSITORY
dat <- readepi(
  indicator_id        = 90362,
  area_type_id        = 202,
  parent_area_type_id = 6 # optional
)
```

## Package Vignettes

The vignette of the **{readepi}** package contains detailed
illustrations about the use of each function and the description of
every argument. This can be accessed by typing the command below:

``` r
# OPEN THE VIGNETTE WITHIN RSTUDIO
vignette("readepi")

# OPEN THE VIGNETTE IN YOUR WEB BROWSER.
>>>>>>> review
browseVignettes("readepi")
```

## Development

<<<<<<< HEAD
### Contributions

Contributions are welcome via [pull
requests](https://github.com/epiverse-trace/readepi/pulls).

### Code of Conduct

Please note that the readepi project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
=======
### Lifecycle

This package is currently a *maturing*, as defined by the [RECON
software lifecycle](https://www.reconverse.org/lifecycle.html). This
means that it can be used in production with the understanding that the
interface may still undergo minor changes.

### Contributions

Contributions are welcome via [pull
requests](https://github.com/%7B%7B%20gh_repo%20%7D%7D/pulls).

### Code of Conduct

Please note that the {{ packagename }} project is released with a
[Contributor Code of
Conduct](https://github.com/epiverse-trace/.github/blob/main/CODE_OF_CONDUCT.md).
>>>>>>> review
By contributing to this project, you agree to abide by its terms.
