
<!-- README.md is generated from README.Rmd. Please edit that file. -->
<!-- The code to render this README is stored in .github/workflows/render-readme.yaml -->
<!-- Variables marked with double curly braces will be transformed beforehand: -->
<!-- `packagename` is extracted from the DESCRIPTION file -->
<!-- `gh_repo` is extracted via a special environment variable in GitHub Actions -->

# readepi: Read data from health information systems <img src="man/figures/logo.png" align="right" width="130"/>

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
[GitHub](https://github.com/epiverse-trace/readepi) with:

``` r
if (!require("pak")) install.packages("pak")
#> Loading required package: pak
pak::pak("epiverse-trace/readepi")
#> ℹ Loading metadata database
#> ✔ Loading metadata database ... done
#> 
#> 
#> → Will install 10 packages.
#> → Will update 1 package.
#> → All 11 packages (0 B) are cached.
#> + cellranger          1.1.0  
#> + forcats             1.0.0  
#> + haven               2.5.3   + ✔ make, ✔ zlib1g-dev
#> + R.methodsS3         1.8.2  
#> + R.oo                1.25.0 
#> + R.utils             2.12.2 
#> + readepi     1.0.0 → 0.0.1  [bld][cmp] (GitHub: 6b4212c)
#> + readxl              1.4.3  
#> + rematch             2.0.0  
#> + rio                 1.0.1  
#> + writexl             1.4.2
#> ✔ All system requirements are already installed.
#> 
#> ℹ No downloads are needed, 11 pkgs are cached
#> ✔ Got R.methodsS3 1.8.2 (x86_64-pc-linux-gnu-ubuntu-22.04) (80.50 kB)
#> ✔ Got cellranger 1.1.0 (x86_64-pc-linux-gnu-ubuntu-22.04) (100.74 kB)
#> ✔ Got writexl 1.4.2 (x86_64-pc-linux-gnu-ubuntu-22.04) (158.84 kB)
#> ✔ Got forcats 1.0.0 (x86_64-pc-linux-gnu-ubuntu-22.04) (421.62 kB)
#> ✔ Got haven 2.5.3 (x86_64-pc-linux-gnu-ubuntu-22.04) (376.38 kB)
#> ✔ Got rematch 2.0.0 (x86_64-pc-linux-gnu-ubuntu-22.04) (15.95 kB)
#> ✔ Got readxl 1.4.3 (x86_64-pc-linux-gnu-ubuntu-22.04) (862.02 kB)
#> ✔ Got R.oo 1.25.0 (x86_64-pc-linux-gnu-ubuntu-22.04) (963.51 kB)
#> ✔ Got rio 1.0.1 (x86_64-pc-linux-gnu-ubuntu-22.04) (596.72 kB)
#> ✔ Got R.utils 2.12.2 (x86_64-pc-linux-gnu-ubuntu-22.04) (1.40 MB)
#> ✔ Got readepi 0.0.1 (source) (582.01 kB)
#> ℹ Installing system requirements
#> ℹ Executing `sudo sh -c apt-get -y update`
#> Get:1 file:/etc/apt/apt-mirrors.txt Mirrorlist [142 B]
#> Hit:2 http://azure.archive.ubuntu.com/ubuntu jammy InRelease
#> Hit:3 http://azure.archive.ubuntu.com/ubuntu jammy-updates InRelease
#> Hit:4 http://azure.archive.ubuntu.com/ubuntu jammy-backports InRelease
#> Hit:5 http://azure.archive.ubuntu.com/ubuntu jammy-security InRelease
#> Hit:6 https://packages.microsoft.com/ubuntu/22.04/prod jammy InRelease
#> Hit:7 https://ppa.launchpadcontent.net/ubuntu-toolchain-r/test/ubuntu jammy InRelease
#> Reading package lists...
#> ℹ Executing `sudo sh -c apt-get -y install make zlib1g-dev libcurl4-openssl-dev libssl-dev unixodbc-dev libmysqlclient-dev libicu-dev pandoc`
#> Reading package lists...
#> Building dependency tree...
#> Reading state information...
#> libicu-dev is already the newest version (70.1-2).
#> make is already the newest version (4.3-4.1build1).
#> unixodbc-dev is already the newest version (2.3.9-5).
#> libcurl4-openssl-dev is already the newest version (7.81.0-1ubuntu1.13).
#> libmysqlclient-dev is already the newest version (8.0.34-0ubuntu0.22.04.1).
#> libssl-dev is already the newest version (3.0.2-0ubuntu1.10).
#> zlib1g-dev is already the newest version (1:1.2.11.dfsg-2ubuntu9.2).
#> pandoc is already the newest version (2.19.2-1).
#> 0 upgraded, 0 newly installed, 0 to remove and 28 not upgraded.
#> ✔ Installed R.methodsS3 1.8.2  (24ms)
#> ✔ Installed R.oo 1.25.0  (59ms)
#> ✔ Installed R.utils 2.12.2  (34ms)
#> ✔ Installed cellranger 1.1.0  (22ms)
#> ✔ Installed forcats 1.0.0  (26ms)
#> ✔ Installed haven 2.5.3  (29ms)
#> ✔ Installed readxl 1.4.3  (67ms)
#> ✔ Installed rematch 2.0.0  (21ms)
#> ✔ Installed rio 1.0.1  (36ms)
#> ✔ Installed writexl 1.4.2  (23ms)
#> ℹ Packaging readepi 0.0.1
#> ✔ Packaged readepi 0.0.1 (453ms)
#> ℹ Building readepi 0.0.1
#> ✔ Built readepi 0.0.1 (1.7s)
#> ✔ Installed readepi 0.0.1 (github::epiverse-trace/readepi@6b4212c) (24ms)
#> ✔ 1 pkg + 90 deps: kept 77, upd 1, added 10, dld 11 (NA B) [13.7s]
library(readepi)
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

``` r
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
browseVignettes("readepi")
```

## Development

### Lifecycle

This package is currently a *maturing*, as defined by the [RECON
software lifecycle](https://www.reconverse.org/lifecycle.html). This
means that it can be used in production with the understanding that the
interface may still undergo minor changes.

### Contributions

Contributions are welcome via [pull
requests](https://github.com/epiverse-trace/readepi/pulls).

### Code of Conduct

Please note that the readepi project is released with a [Contributor
Code of
Conduct](https://github.com/epiverse-trace/.github/blob/main/CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.
