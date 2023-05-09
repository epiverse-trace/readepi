
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
[![lifecycle-concept](https://raw.githubusercontent.com/reconverse/reconverse.github.io/master/images/badge-maturing.svg)](https://www.reconverse.org/lifecycle.html#concept)
<!-- badges: end -->

## Installation

You can install the development version of readepi from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
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
```

## Vignette

The vignette of the **readepi** contains detailed illustrations about
the use of each function. This can be accessed by typing the command
below:

``` r
# OPEN THE VIGNETTE WITHIN RSTUDIO
vignette("readepi")

# OPEN THE VIGNETTE IN YOUR WEB BROWSER. 
browseVignettes("readepi")
```

## Development

### Contributions

Contributions are welcome via [pull
requests](https://github.com/epiverse-trace/readepi/pulls).

### Code of Conduct

Please note that the readepi project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
