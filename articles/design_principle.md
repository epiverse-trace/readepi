# Package design vignette for {readepi}

## Concept and motivation

This document outlines the design decisions guiding the development
strategies of the [readepi](https://epiverse-trace.github.io/readepi/) R
package, the reasoning behind them, as well as the possible pros and
cons of each decision.

Importing data from various sources into the R environment is the first
step in the workflow of outbreak analysis. Health data are often stored
in individual files of different formats, in relational database
management systems (RDBMS), and more importantly, many health
organizations store their data in health information systems (HIS) that
are wrapped under hood of a specific Application Programming Interfaces
(APIs).

Many R packages have been developed over the years to read data stored
in a file or in a directory containing multiple files. We recommend the
[{rio}](http://gesistsa.github.io/rio/) package for importing data that
are relatively small in size and the
[{data.table}](https://CRAN.R-project.org/package=data.table) package
for large files. For retrieving data from RDBMS, we recommend the
[{DBI}](https://dbi.r-dbi.org/) package.

There are several R packages for reading data from HIS such as
{fingertipsR}, {REDCapR}, {godataR}, and {globaldothealth}, which are
used to fetch data from [Fingertips](https://fingertips.phe.org.uk/),
[REDCap](https://projectredcap.org/software/),
[Go.Data](https://www.who.int/tools/godata), and
[Global.Health](https://global.health/) respectively. However, these
packages are usually designed to read from specific HIS and can’t be
used to query others. This increases the dependency on many other
packages and introduces the challenge of having a unified framework for
importing data from multiple HIS. As such, we propose
[readepi](https://epiverse-trace.github.io/readepi/), a centralized tool
that will provide users with the capability of importing data from
various HIS and RDBMS.

[readepi](https://epiverse-trace.github.io/readepi/) aims at importing
data from several potential sources in the same way. The data sources
include distributed health information systems and public databases as
shown in the figure below.

![readepi roadmap](../reference/figures/roadmap_readepi.drawio.svg)

readepi roadmap

## Scope

The [readepi](https://epiverse-trace.github.io/readepi/) package is
designed to import data from two common sources of institutional
health-related data: HIS wrapped with specific APIs and RDBMS that run
on specific servers.

To import data from these sources, users must have read access and
provide the relevant query parameters to fetch the target data. The
current version of [readepi](https://epiverse-trace.github.io/readepi/)
supports importing data from: - **HISs**: [DHIS2](https://dhis2.org/)
and [SORMAS](https://www.sormas.org/),

- **RDBMS**: MS SQL, SQLite, MySQL, and PostgreSQL.

In next releases, we plan to include features for reading data from
additional HISs like GoData, Globaldothealth, and ODK, as well as RDBMS
such as MS Access.

![Diagram of current functions available in
{readepi}](../reference/figures/readepi_design_diagram_v-0.1.0.drawio.svg)

Diagram of current functions available in {readepi}

## Output

The main functions of the {readepi} package return a `data frame` object
that contains the data fetched from the target source with the specified
request parameters. The
[`login()`](https://epiverse-trace.github.io/readepi/reference/login.md)
function returns a connection object that is used in the subsequent
queries.

## Design decisions

The aim of {readepi} is to simplify and standardize the process of
fetching data from APIs and servers. We strive to make this easy for
users by limiting the number of required arguments to access and
retrieve the data of interest from the target source. As such, the
package is structured around few main functions:
[`read_dhis2()`](https://epiverse-trace.github.io/readepi/reference/read_dhis2.md),
[`read_sormas()`](https://epiverse-trace.github.io/readepi/reference/read_sormas.md),
and
[`read_rdbms()`](https://epiverse-trace.github.io/readepi/reference/read_rdbms.md);
and one auxiliary functions
([`login()`](https://epiverse-trace.github.io/readepi/reference/login.md)).

### Authentication

The
[`login()`](https://epiverse-trace.github.io/readepi/reference/login.md)
function is used to establish connection with the data source. It
verifies the user’s identity and determines if they are authorized to
access the requested database or API. Establishing this connection is
crucial for ensuring successful data import. However, the basic
authentication does not work for SORMAS. To maintain the design of the
package across all HIS, the login function returns a object when
importing data from SORMAS.

Once authentication credentials are provided, they are securely stored
within the connection object. This prevents the need to re-supply them
for subsequent requests in other functions. The Figure below lists the
arguments needed to call the
[`login()`](https://epiverse-trace.github.io/readepi/reference/login.md)
function.

The `type` argument refers to the name of the data source of interest.
The current version of the package covers the following types:

    i) RDBMS: “ms sql”, “mysql”, “postgresql”, “sqlite”
    ii) APIs: “dhis2”, “sormas”

### Data import

You can use one of the functions below depending on the data source.

- [`read_rdbms()`](https://epiverse-trace.github.io/readepi/reference/read_rdbms.md):
  for importing data from RDBMS. It takes the following arguments:
  - **login**: A `Pool` object obtained from the
    [`login()`](https://epiverse-trace.github.io/readepi/reference/login.md)
    function
  - **query**: A string with an SQL query or a list of parameters. When
    the query parameters are provided as a list, they will be used to
    form the appropriate SQL query internally. The resulting SQL query
    will then be executed by the
    [`read_rdbms()`](https://epiverse-trace.github.io/readepi/reference/read_rdbms.md).
- [`read_dhis2()`](https://epiverse-trace.github.io/readepi/reference/read_dhis2.md):
  for importing data from DHIS2. This function expect the following
  arguments:
  - **login**: A `httr2_response` object returned by the
    [`login()`](https://epiverse-trace.github.io/readepi/reference/login.md)
    function
  - **org_unit**: A character with the organisation unit ID or name
  - **program**: A character with the program ID or name
- [`read_sormas()`](https://epiverse-trace.github.io/readepi/reference/read_sormas.md):
  for importing data from SORMAS. It takes the following arguments:
  - **login**: A `list` object returned by the
    [`login()`](https://epiverse-trace.github.io/readepi/reference/login.md)
  - **disease**: A character vector with the names of the diseases of
    interest. Users can get the list of all diseases which data is
    available on their SORMAS system using the
    [`sormas_get_diseases()`](https://epiverse-trace.github.io/readepi/reference/sormas_get_diseases.md)
    function.
  - **since**: A Date value in ISO8601 format (YYYY-mm-dd).

Note that, when reading from RDBMS, the `query` argument could be an
*SQL query* or a *list with a vector of table names, fields and rows to
subset on*. For HIS, we strongly recommend reading the vignette on the
[query_parameters](https://epiverse-trace.github.io/readepi/articles/query_parameters.Rmd)
for more details about the request parameters that are supported in the
current version of the package.

## Dependencies

- The main and internal functions of the package rely primarily on three
  packages:
  - [{httr2}](https://CRAN.R-project.org/package=httr2) or
    [{data.table}](https://CRAN.R-project.org/package=data.table): These
    are used to construct and execute API requests.
  - [{dplyr}](https://CRAN.R-project.org/package=dplyr): Utilized for
    its data manipulation capabilities.
- The
  [`read_rdbms()`](https://epiverse-trace.github.io/readepi/reference/read_rdbms.md)
  function depends on the following packages:
  - [{DBI}](https://CRAN.R-project.org/package=DBI): Used for database
    connectivity and querying.
  - [{pool}](https://CRAN.R-project.org/package=pool): Provides
    functionality for managing multiple database connections.
  - [{odbc}](https://CRAN.R-project.org/package=odbc): Supplies drivers
    required for accessing various DBMS.
  - [{RMySQL}](https://CRAN.R-project.org/package=RMySQL): Specifically
    used for MySQL database connectivity.

These functions also require system dependencies for OS-X and Linux
systems, detailed in the [install drivers
vignette](https://epiverse-trace.github.io/readepi/articles/install_drivers.Rmd)
vignette.

Additionally, the development of the package necessitates the inclusion
of other required packages: -
[{checkmate}](https://CRAN.R-project.org/package=checkmate) -
[{httptest2}](https://CRAN.R-project.org/package=httptest2) -
[{bookdown}](https://CRAN.R-project.org/package=bookdown) -
[{rmarkdown}](https://CRAN.R-project.org/package=rmarkdown) -
[{testthat}](https://CRAN.R-project.org/package=testthat) (\>= 3.0.0) -
[{knitr}](https://CRAN.R-project.org/package=knitr) -
[{cli}](https://CRAN.R-project.org/package=cli) -
[{DiagrammeR}](https://CRAN.R-project.org/package=DiagrammeR) -
[{cyclocomp}](https://CRAN.R-project.org/package=cyclocomp)

## Contribute

There are no special requirements to contributing to {readepi}, please
follow the [package contributing
guide](https://github.com/epiverse-trace/.github/blob/main/CONTRIBUTING.md).
