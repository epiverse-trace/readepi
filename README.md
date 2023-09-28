
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
#> → Will install 89 packages.
#> → Will update 1 package.
#> → All 90 packages (90.99 MB) are cached.
#> + askpass                 1.2.0       
#> + backports               1.4.1       
#> + base64enc               0.1-3       
#> + bit                     4.0.5       
#> + bit64                   4.0.5       
#> + blob                    1.2.4       
#> + bslib                   0.5.1       
#> + cachem                  1.0.8       
#> + cellranger              1.1.0       
#> + checkmate               2.2.0       
#> + cli                     3.6.1       
#> + clipr                   0.8.0       
#> + commonmark              1.9.0       
#> + crayon                  1.5.2       
#> + crosstalk               1.2.0       
#> + curl                    5.0.2       
#> + data.table              1.14.8      
#> + DBI                     1.1.3       
#> + digest                  0.6.33      
#> + dplyr                   1.1.3       
#> + DT                      0.29        
#> + ellipsis                0.3.2       
#> + evaluate                0.21        
#> + fansi                   1.0.4       
#> + fastmap                 1.1.1       
#> + fingertipsR             1.0.10.9002 👷🏼‍♂️🔧 (GitHub: caa9b7b)
#> + fontawesome             0.5.2       
#> + forcats                 1.0.0       
#> + fs                      1.6.3       
#> + generics                0.1.3       
#> + glue                    1.6.2       
#> + haven                   2.5.3       
#> + highr                   0.10        
#> + hms                     1.1.3       
#> + htmltools               0.5.6       
#> + htmlwidgets             1.6.2       
#> + httpuv                  1.6.11      
#> + httr                    1.4.7       
#> + jquerylib               0.1.4       
#> + jsonlite                1.8.7       
#> + knitr                   1.44        
#> + later                   1.3.1       
#> + lazyeval                0.2.2       
#> + lifecycle               1.0.3       
#> + magrittr                2.0.3       
#> + memoise                 2.0.1       
#> + mime                    0.12        
#> + miniUI                  0.1.1.1     
#> + odbc                    1.3.5       
#> + openssl                 2.1.1       
#> + pillar                  1.9.0       
#> + pkgconfig               2.0.3       
#> + pool                    1.0.1       
#> + promises                1.2.1       
#> + purrr                   1.0.2       
#> + R.methodsS3             1.8.2       
#> + R.oo                    1.25.0      
#> + R.utils                 2.12.2      
#> + R6                      2.5.1       
#> + rappdirs                0.3.3       
#> + Rcpp                    1.0.11      
#> + readepi         1.0.0 → 0.0.1       👷‍♂️🔧 (GitHub: 6b4212c)
#> + readr                   2.1.4       
#> + readxl                  1.4.3       
#> + REDCapR                 1.1.0       
#> + rematch                 2.0.0       
#> + rio                     1.0.1       
#> + rlang                   1.1.1       
#> + rmarkdown               2.25        
#> + RMySQL                  0.10.26     
#> + sass                    0.4.7       
#> + shiny                   1.7.5       
#> + shinycssloaders         1.0.0       
#> + sourcetools             0.1.7-1     
#> + stringi                 1.7.12      
#> + stringr                 1.5.0       
#> + sys                     3.4.2       
#> + tibble                  3.2.1       
#> + tidyr                   1.3.0       
#> + tidyselect              1.2.0       
#> + tinytex                 0.46        
#> + tzdb                    0.4.0       
#> + utf8                    1.2.3       
#> + vctrs                   0.6.3       
#> + vroom                   1.6.3       
#> + withr                   2.5.1       
#> + writexl                 1.4.2       
#> + xfun                    0.40        
#> + xtable                  1.8-4       
#> + yaml                    2.3.7
#> ℹ No downloads are needed, 90 pkgs (90.99 MB) are cached
#> ✔ Got pool 1.0.1 (aarch64-apple-darwin20) (187.78 kB)
#> ✔ Got readxl 1.4.3 (aarch64-apple-darwin20) (1.54 MB)
#> ✔ Got fastmap 1.1.1 (aarch64-apple-darwin20) (190.58 kB)
#> ✔ Got memoise 2.0.1 (aarch64-apple-darwin20) (47.93 kB)
#> ✔ Got rio 1.0.1 (aarch64-apple-darwin20) (591.50 kB)
#> ✔ Got curl 5.0.2 (aarch64-apple-darwin20) (809.84 kB)
#> ✔ Got fontawesome 0.5.2 (aarch64-apple-darwin20) (1.36 MB)
#> ✔ Got sourcetools 0.1.7-1 (aarch64-apple-darwin20) (136.07 kB)
#> ✔ Got htmltools 0.5.6 (aarch64-apple-darwin20) (356.41 kB)
#> ✔ Got promises 1.2.1 (aarch64-apple-darwin20) (1.82 MB)
#> ✔ Installed readepi 0.0.1 (github::epiverse-trace/readepi@6b4212c) (77ms)
#> ✔ Installed DBI 1.1.3  (94ms)
#> ✔ Installed R.methodsS3 1.8.2  (134ms)
#> ✔ Installed R.oo 1.25.0  (143ms)
#> ✔ Installed R.utils 2.12.2  (152ms)
#> ✔ Installed R6 2.5.1  (160ms)
#> ✔ Installed REDCapR 1.1.0  (176ms)
#> ✔ Installed RMySQL 0.10.26  (187ms)
#> ✔ Installed Rcpp 1.0.11  (197ms)
#> ✔ Installed askpass 1.2.0  (206ms)
#> ✔ Installed backports 1.4.1  (72ms)
#> ✔ Installed bit64 4.0.5  (57ms)
#> ✔ Installed bit 4.0.5  (34ms)
#> ✔ Installed blob 1.2.4  (30ms)
#> ✔ Installed cellranger 1.1.0  (36ms)
#> ✔ Installed checkmate 2.2.0  (39ms)
#> ✔ Installed cli 3.6.1  (35ms)
#> ✔ Installed clipr 0.8.0  (31ms)
#> ✔ Installed crayon 1.5.2  (29ms)
#> ✔ Installed curl 5.0.2  (32ms)
#> ✔ Installed data.table 1.14.8  (62ms)
#> ✔ Installed dplyr 1.1.3  (36ms)
#> ✔ Installed fansi 1.0.4  (32ms)
#> ✔ Installed forcats 1.0.0  (30ms)
#> ✔ Installed generics 0.1.3  (30ms)
#> ✔ Installed glue 1.6.2  (31ms)
#> ✔ Installed haven 2.5.3  (32ms)
#> ✔ Installed hms 1.1.3  (31ms)
#> ✔ Installed httr 1.4.7  (50ms)
#> ✔ Installed jsonlite 1.8.7  (57ms)
#> ✔ Installed later 1.3.1  (36ms)
#> ✔ Installed lifecycle 1.0.3  (33ms)
#> ✔ Installed magrittr 2.0.3  (32ms)
#> ✔ Installed mime 0.12  (30ms)
#> ✔ Installed odbc 1.3.5  (39ms)
#> ✔ Installed openssl 2.1.1  (40ms)
#> ✔ Installed pillar 1.9.0  (35ms)
#> ✔ Installed pkgconfig 2.0.3  (56ms)
#> ✔ Installed pool 1.0.1  (55ms)
#> ✔ Installed purrr 1.0.2  (31ms)
#> ✔ Installed readr 2.1.4  (33ms)
#> ✔ Installed readxl 1.4.3  (35ms)
#> ✔ Installed rematch 2.0.0  (32ms)
#> ✔ Installed rio 1.0.1  (31ms)
#> ✔ Installed rlang 1.1.1  (34ms)
#> ✔ Installed stringr 1.5.0  (18ms)
#> ✔ Installed sys 3.4.2  (20ms)
#> ✔ Installed stringi 1.7.12  (125ms)
#> ✔ Installed tibble 3.2.1  (44ms)
#> ✔ Installed tidyr 1.3.0  (34ms)
#> ✔ Installed tidyselect 1.2.0  (31ms)
#> ✔ Installed tzdb 0.4.0  (31ms)
#> ✔ Installed utf8 1.2.3  (31ms)
#> ✔ Installed vctrs 0.6.3  (32ms)
#> ✔ Installed withr 2.5.1  (15ms)
#> ✔ Installed vroom 1.6.3  (86ms)
#> ✔ Installed writexl 1.4.2  (32ms)
#> ✔ Installed fingertipsR 1.0.10.9002 (github::rOpenSci/fingertipsR@caa9b7b) (30ms)
#> ✔ Installed base64enc 0.1-3  (13ms)
#> ✔ Installed DT 0.29  (82ms)
#> ✔ Installed cachem 1.0.8  (15ms)
#> ✔ Installed commonmark 1.9.0  (18ms)
#> ✔ Installed crosstalk 1.2.0  (22ms)
#> ✔ Installed bslib 0.5.1  (172ms)
#> ✔ Installed digest 0.6.33  (58ms)
#> ✔ Installed ellipsis 0.3.2  (30ms)
#> ✔ Installed evaluate 0.21  (30ms)
#> ✔ Installed fastmap 1.1.1  (32ms)
#> ✔ Installed fontawesome 0.5.2  (31ms)
#> ✔ Installed fs 1.6.3  (33ms)
#> ✔ Installed highr 0.10  (32ms)
#> ✔ Installed htmltools 0.5.6  (31ms)
#> ✔ Installed htmlwidgets 1.6.2  (60ms)
#> ✔ Installed httpuv 1.6.11  (62ms)
#> ✔ Installed jquerylib 0.1.4  (34ms)
#> ✔ Installed lazyeval 0.2.2  (16ms)
#> ✔ Installed knitr 1.44  (66ms)
#> ✔ Installed memoise 2.0.1  (38ms)
#> ✔ Installed miniUI 0.1.1.1  (28ms)
#> ✔ Installed promises 1.2.1  (30ms)
#> ✔ Installed rappdirs 0.3.3  (31ms)
#> ✔ Installed rmarkdown 2.25  (91ms)
#> ✔ Installed sass 0.4.7  (66ms)
#> ✔ Installed shinycssloaders 1.0.0  (17ms)
#> ✔ Installed sourcetools 0.1.7-1  (21ms)
#> ✔ Installed shiny 1.7.5  (98ms)
#> ✔ Installed tinytex 0.46  (34ms)
#> ✔ Installed xfun 0.40  (30ms)
#> ✔ Installed xtable 1.8-4  (31ms)
#> ✔ Installed yaml 2.3.7  (24ms)
#> ✔ 1 pkg + 90 deps: upd 1, added 89, dld 10 (7.04 MB) [10.8s]
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
requests](https://github.com/%7B%7B%20gh_repo%20%7D%7D/pulls).

### Code of Conduct

Please note that the {{ packagename }} project is released with a
[Contributor Code of
Conduct](https://github.com/epiverse-trace/.github/blob/main/CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.
