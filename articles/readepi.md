# readepi: Reading data from health information systems

## Overview

Health-related data in general, and epidemiological data in particular,
are stored in files, relation database management systems (RDBMS), or
health information systems (HIS). Each category includes numerous
options, such as various file formats, RDBMS types, and HIS APIs.
Importing data from such repositories involve the usage of different
format-specific functions or API-specific packages, which is an
exhausting task for end users.

The main objective of the **{readepi}** package is to simplify the
process of reading health-related data from diverse sources, allowing
the user to focus more on downstream analysis tasks.

The current implementation of **{readepi}** provides functions for
reading data from two common HIS: ([SORMAS](https://sormas.org/),
[DHIS2](https://dhis2.org/), and RDBMS such as MS SQL, MySQL,
PostgreSQL, and SQLite. Other utility functions for accessing relevant
files and data are also included in this package.

``` r
# Load readepi
library(readepi)
```

### Need for MS drivers

Users of operating systems other than Microsoft need to have the
appropriate MS driver installed into their system. The driver
installation process is documented in details in the [install drivers
vignette](https://epiverse-trace.github.io/readepi/articles/install_drivers.Rmd)
vignette.

### Authentication

To read data from RDBMS and HIS APIs, the user is expected to have, at
least, read access to the system. To establish the connection to their
system, users can call the
[`login()`](https://epiverse-trace.github.io/readepi/reference/login.md)
function with the following arguments:

- `from`: The URL to the system of interest. For APIs, this must be the
  base URL (required).
- `type`: The source name (required). The current version of the package
  covers the following RDBMS and HIS types: “ms sql”, “mysql”,
  “postgresql”, “sqlite”, “dhis2”, “sormas”.
- `user_name`: The user name (optional).
- `password`: The user’s password (optional). When the password is not
  provided (set to NULL), the user will be prompt to enter the password.
- `driver_name`: The driver name (optional). This is only needed for
  connecting to RDBMS only.
- `db_name`: The database name (optional). This is only needed for
  connecting to RDBMS only.
- `port`: The port ID (optional). This is only needed for connecting to
  RDBMS only.

### Reading data from RDBMS

Health related research data are usually stored in either relational
databases or non-SQL databases. For example, at
[MRCG@LSHTM](https://www.lshtm.ac.uk/research/units/mrc-gambia),
projects data are stored in relational databases. A SQL-based database
is run under a specific sever. The current version of the **{readepi}**
package provides a function
([`read_rdbms()`](https://epiverse-trace.github.io/readepi/reference/read_rdbms.md))
for reading data from MS SQL, MySQL, PostgreSQL, and SQLite. The
[`read_rdbms()`](https://epiverse-trace.github.io/readepi/reference/read_rdbms.md)
function takes the following arguments:

- `login`: The connection object obtained from the
  [`login()`](https://epiverse-trace.github.io/readepi/reference/login.md)
  function
- `query`: An SQL query or a list with the following elements:
  1.  table: a string with the table name.
  2.  fields: a vector of column names. When specified, only those
      columns will be returned. Default is `NULL`.
  3.  filter: an expression or a vector of values used to filter the
      rows from the table of interest. This should be of the same length
      as the value for the ‘select’. Default is `NULL`.

``` r
# CONNECT TO THE TEST MYSQL SERVER
rdbms_login <- login(
  type = "mysql",
  from = "mysql-rfam-public.ebi.ac.uk",
  user_name = "rfamro",
  password = "",
  driver_name = "",
  db_name = "Rfam",
  port = 4497
)
```

``` r
# DISPLAY THE LIST OF TABLES FROM A DATABASE OF INTEREST
tables <- show_tables(login = rdbms_login)
head(tables)
#> [1] "_annotated_file"     "_family_file"        "_genome_data"       
#> [4] "_lock"               "_overlap"            "_overlap_membership"
```

``` r
# READING ALL FIELDS AND ALL RECORDS FROM ONE TABLE (`author`) USING AN SQL
# QUERY
dat <- read_rdbms(
  login = rdbms_login,
  query = "select * from author"
)
```

``` r
# READING ALL FIELDS AND ALL RECORDS FROM ONE TABLE (`author`) WHERE QUERY
# PARAMETERS ARE SPECIFIED AS A LIST
dat <- read_rdbms(
  login = rdbms_login,
  query = list(table = "author", fields = NULL, filter = NULL)
)
```

``` r
# SELECT FEW COLUMNS FROM ONE TABLE AND LEFT JOIN WITH ANOTHER TABLE
dat <- read_rdbms(
    login = rdbms_login,
    query = "select author.author_id, author.name,
  family_author.author_id from author left join family_author on
  author.author_id = family_author.author_id"
)
```

| author_id | name                 | author_id |
|----------:|:---------------------|----------:|
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         8 | Boursnell C          |         8 |
|        56 | Weinberg Z           |        56 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        38 | Moore B              |        38 |
|         8 | Boursnell C          |         8 |
|         8 | Boursnell C          |         8 |
|        61 | Wilkinson A          |        61 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        75 | Lamkiewicz K         |        75 |
|       120 | Triebel S            |       120 |
|        34 | Marz M               |        34 |
|        39 | Moxon SJ             |        39 |
|        74 | Petrov AI            |        74 |
|        39 | Moxon SJ             |        39 |
|        61 | Wilkinson A          |        61 |
|         6 | Bateman A            |         6 |
|        38 | Moore B              |        38 |
|         6 | Bateman A            |         6 |
|        38 | Moore B              |        38 |
|        62 | Eberhardt R          |        62 |
|        56 | Weinberg Z           |        56 |
|        76 | Eckert I             |        76 |
|        16 | Daub J               |        16 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        24 | Gardner PP           |        24 |
|        38 | Moore B              |        38 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        61 | Wilkinson A          |        61 |
|        56 | Weinberg Z           |        56 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|         8 | Boursnell C          |         8 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        72 | Repoila F            |        72 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        44 | Osuch I              |        44 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        33 | Marantidis E         |        33 |
|         2 | Argasinska J         |         2 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|         6 | Bateman A            |         6 |
|        39 | Moxon SJ             |        39 |
|        44 | Osuch I              |        44 |
|        56 | Weinberg Z           |        56 |
|        44 | Osuch I              |        44 |
|        39 | Moxon SJ             |        39 |
|        56 | Weinberg Z           |        56 |
|         6 | Bateman A            |         6 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        33 | Marantidis E         |        33 |
|        62 | Eberhardt R          |        62 |
|        26 | Griffiths-Jones SR   |        26 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|         6 | Bateman A            |         6 |
|        24 | Gardner PP           |        24 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        24 | Gardner PP           |        24 |
|        16 | Daub J               |        16 |
|         2 | Argasinska J         |         2 |
|        33 | Marantidis E         |        33 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        61 | Wilkinson A          |        61 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        72 | Repoila F            |        72 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|         2 | Argasinska J         |         2 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        56 | Weinberg Z           |        56 |
|        37 | Moll S               |        37 |
|        47 | Schneider DJ         |        47 |
|        50 | Stodghill P          |        50 |
|        41 | Myers CR             |        41 |
|        12 | Cartinhour SW        |        12 |
|        22 | Filiatrault M        |        22 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        44 | Osuch I              |        44 |
|        56 | Weinberg Z           |        56 |
|        76 | Eckert I             |        76 |
|        62 | Eberhardt R          |        62 |
|         6 | Bateman A            |         6 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        38 | Moore B              |        38 |
|       130 | Burge S              |       130 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        16 | Daub J               |        16 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        11 | Burge SW             |        11 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        38 | Moore B              |        38 |
|        44 | Osuch I              |        44 |
|        26 | Griffiths-Jones SR   |        26 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        38 | Moore B              |        38 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|         2 | Argasinska J         |         2 |
|        26 | Griffiths-Jones SR   |        26 |
|        44 | Osuch I              |        44 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|       127 | Gardner P            |       127 |
|         2 | Argasinska J         |         2 |
|        26 | Griffiths-Jones SR   |        26 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        56 | Weinberg Z           |        56 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        16 | Daub J               |        16 |
|        61 | Wilkinson A          |        61 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|       119 | Brewer, KI           |       119 |
|       107 | Ontiveros-Palacios N |       107 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        61 | Wilkinson A          |        61 |
|        33 | Marantidis E         |        33 |
|        44 | Osuch I              |        44 |
|        39 | Moxon SJ             |        39 |
|        56 | Weinberg Z           |        56 |
|        39 | Moxon SJ             |        39 |
|        44 | Osuch I              |        44 |
|        61 | Wilkinson A          |        61 |
|        44 | Osuch I              |        44 |
|        39 | Moxon SJ             |        39 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        11 | Burge SW             |        11 |
|        56 | Weinberg Z           |        56 |
|         2 | Argasinska J         |         2 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        16 | Daub J               |        16 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|         8 | Boursnell C          |         8 |
|        26 | Griffiths-Jones SR   |        26 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|         6 | Bateman A            |         6 |
|        24 | Gardner PP           |        24 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        72 | Repoila F            |        72 |
|         2 | Argasinska J         |         2 |
|        44 | Osuch I              |        44 |
|        61 | Wilkinson A          |        61 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        24 | Gardner PP           |        24 |
|        38 | Moore B              |        38 |
|        61 | Wilkinson A          |        61 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|         6 | Bateman A            |         6 |
|        44 | Osuch I              |        44 |
|        26 | Griffiths-Jones SR   |        26 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        24 | Gardner PP           |        24 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        72 | Repoila F            |        72 |
|        39 | Moxon SJ             |        39 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        72 | Repoila F            |        72 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        24 | Gardner PP           |        24 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|        39 | Moxon SJ             |        39 |
|        61 | Wilkinson A          |        61 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        56 | Weinberg Z           |        56 |
|         2 | Argasinska J         |         2 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        56 | Weinberg Z           |        56 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|        39 | Moxon SJ             |        39 |
|        56 | Weinberg Z           |        56 |
|         8 | Boursnell C          |         8 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|         6 | Bateman A            |         6 |
|         2 | Argasinska J         |         2 |
|        38 | Moore B              |        38 |
|        61 | Wilkinson A          |        61 |
|        56 | Weinberg Z           |        56 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        13 | Chen A               |        13 |
|        10 | Brown C              |        10 |
|        16 | Daub J               |        16 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        26 | Griffiths-Jones SR   |        26 |
|        56 | Weinberg Z           |        56 |
|        76 | Eckert I             |        76 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|        33 | Marantidis E         |        33 |
|        38 | Moore B              |        38 |
|        16 | Daub J               |        16 |
|        56 | Weinberg Z           |        56 |
|         2 | Argasinska J         |         2 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        16 | Daub J               |        16 |
|        56 | Weinberg Z           |        56 |
|        26 | Griffiths-Jones SR   |        26 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|        33 | Marantidis E         |        33 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|         8 | Boursnell C          |         8 |
|        39 | Moxon SJ             |        39 |
|        33 | Marantidis E         |        33 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        44 | Osuch I              |        44 |
|         8 | Boursnell C          |         8 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        65 | Corbino K            |        65 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|        56 | Weinberg Z           |        56 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|        38 | Moore B              |        38 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        17 | de la Pena M         |        17 |
|        11 | Burge SW             |        11 |
|        38 | Moore B              |        38 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|        38 | Moore B              |        38 |
|        39 | Moxon SJ             |        39 |
|        26 | Griffiths-Jones SR   |        26 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        26 | Griffiths-Jones SR   |        26 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        72 | Repoila F            |        72 |
|        62 | Eberhardt R          |        62 |
|        26 | Griffiths-Jones SR   |        26 |
|        16 | Daub J               |        16 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        61 | Wilkinson A          |        61 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|         8 | Boursnell C          |         8 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|         6 | Bateman A            |         6 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        44 | Osuch I              |        44 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        72 | Repoila F            |        72 |
|       129 | Narunsky A           |       129 |
|         9 | Breaker RR           |         9 |
|       107 | Ontiveros-Palacios N |       107 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        26 | Griffiths-Jones SR   |        26 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        24 | Gardner PP           |        24 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        33 | Marantidis E         |        33 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|        56 | Weinberg Z           |        56 |
|         8 | Boursnell C          |         8 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        38 | Moore B              |        38 |
|        44 | Osuch I              |        44 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        33 | Marantidis E         |        33 |
|        56 | Weinberg Z           |        56 |
|         2 | Argasinska J         |         2 |
|        16 | Daub J               |        16 |
|        39 | Moxon SJ             |        39 |
|        56 | Weinberg Z           |        56 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|       116 | Fei Q                |       116 |
|       117 | Kapranov P           |       117 |
|         2 | Argasinska J         |         2 |
|        72 | Repoila F            |        72 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        56 | Weinberg Z           |        56 |
|         2 | Argasinska J         |         2 |
|        16 | Daub J               |        16 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        44 | Osuch I              |        44 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        66 | Griffiths-Jones S    |        66 |
|        36 | Mifsud W             |        36 |
|        24 | Gardner PP           |        24 |
|         6 | Bateman A            |         6 |
|        16 | Daub J               |        16 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        56 | Weinberg Z           |        56 |
|        26 | Griffiths-Jones SR   |        26 |
|        24 | Gardner PP           |        24 |
|        39 | Moxon SJ             |        39 |
|        61 | Wilkinson A          |        61 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        39 | Moxon SJ             |        39 |
|        44 | Osuch I              |        44 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        26 | Griffiths-Jones SR   |        26 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        26 | Griffiths-Jones SR   |        26 |
|        16 | Daub J               |        16 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        26 | Griffiths-Jones SR   |        26 |
|        16 | Daub J               |        16 |
|         2 | Argasinska J         |         2 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        56 | Weinberg Z           |        56 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        39 | Moxon SJ             |        39 |
|        56 | Weinberg Z           |        56 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        26 | Griffiths-Jones SR   |        26 |
|        62 | Eberhardt R          |        62 |
|        26 | Griffiths-Jones SR   |        26 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|         6 | Bateman A            |         6 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        26 | Griffiths-Jones SR   |        26 |
|        39 | Moxon SJ             |        39 |
|       107 | Ontiveros-Palacios N |       107 |
|        16 | Daub J               |        16 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        44 | Osuch I              |        44 |
|        16 | Daub J               |        16 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        44 | Osuch I              |        44 |
|        39 | Moxon SJ             |        39 |
|         8 | Boursnell C          |         8 |
|        61 | Wilkinson A          |        61 |
|        24 | Gardner PP           |        24 |
|        16 | Daub J               |        16 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        72 | Repoila F            |        72 |
|         2 | Argasinska J         |         2 |
|        52 | Valach M             |        52 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|         2 | Argasinska J         |         2 |
|        56 | Weinberg Z           |        56 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|         6 | Bateman A            |         6 |
|        38 | Moore B              |        38 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        61 | Wilkinson A          |        61 |
|        33 | Marantidis E         |        33 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        26 | Griffiths-Jones SR   |        26 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|       130 | Burge S              |       130 |
|        26 | Griffiths-Jones SR   |        26 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        33 | Marantidis E         |        33 |
|        39 | Moxon SJ             |        39 |
|        44 | Osuch I              |        44 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        26 | Griffiths-Jones SR   |        26 |
|        38 | Moore B              |        38 |
|        33 | Marantidis E         |        33 |
|        16 | Daub J               |        16 |
|        62 | Eberhardt R          |        62 |
|         6 | Bateman A            |         6 |
|        61 | Wilkinson A          |        61 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|        39 | Moxon SJ             |        39 |
|        33 | Marantidis E         |        33 |
|        39 | Moxon SJ             |        39 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|         6 | Bateman A            |         6 |
|        62 | Eberhardt R          |        62 |
|        26 | Griffiths-Jones SR   |        26 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|       109 | Nawrocki EP          |       109 |
|         2 | Argasinska J         |         2 |
|        44 | Osuch I              |        44 |
|        39 | Moxon SJ             |        39 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        38 | Moore B              |        38 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|         3 | Bachellerie JP       |         3 |
|        26 | Griffiths-Jones SR   |        26 |
|        39 | Moxon SJ             |        39 |
|        13 | Chen A               |        13 |
|        10 | Brown C              |        10 |
|        16 | Daub J               |        16 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        61 | Wilkinson A          |        61 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        38 | Moore B              |        38 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        44 | Osuch I              |        44 |
|        61 | Wilkinson A          |        61 |
|        33 | Marantidis E         |        33 |
|        38 | Moore B              |        38 |
|         6 | Bateman A            |         6 |
|        39 | Moxon SJ             |        39 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        11 | Burge SW             |        11 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        56 | Weinberg Z           |        56 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        39 | Moxon SJ             |        39 |
|        56 | Weinberg Z           |        56 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        86 | SERIR R              |        86 |
|        87 | SCHNEIDER T          |        87 |
|        88 | SANGARANE V          |        88 |
|        38 | Moore B              |        38 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|         6 | Bateman A            |         6 |
|        33 | Marantidis E         |        33 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|         6 | Bateman A            |         6 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        16 | Daub J               |        16 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        24 | Gardner PP           |        24 |
|        62 | Eberhardt R          |        62 |
|         8 | Boursnell C          |         8 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|         6 | Bateman A            |         6 |
|        16 | Daub J               |        16 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        26 | Griffiths-Jones SR   |        26 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        26 | Griffiths-Jones SR   |        26 |
|        44 | Osuch I              |        44 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        11 | Burge SW             |        11 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        61 | Wilkinson A          |        61 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        56 | Weinberg Z           |        56 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        24 | Gardner PP           |        24 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|         6 | Bateman A            |         6 |
|        39 | Moxon SJ             |        39 |
|         6 | Bateman A            |         6 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        72 | Repoila F            |        72 |
|        39 | Moxon SJ             |        39 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        38 | Moore B              |        38 |
|        24 | Gardner PP           |        24 |
|        66 | Griffiths-Jones S    |        66 |
|        24 | Gardner PP           |        24 |
|        34 | Marz M               |        34 |
|         2 | Argasinska J         |         2 |
|        61 | Wilkinson A          |        61 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        26 | Griffiths-Jones SR   |        26 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        26 | Griffiths-Jones SR   |        26 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        33 | Marantidis E         |        33 |
|        61 | Wilkinson A          |        61 |
|        99 | Liger J              |        99 |
|       100 | Minaud L             |       100 |
|       101 | Poulain C            |       101 |
|       102 | Vencic J             |       102 |
|        44 | Osuch I              |        44 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        44 | Osuch I              |        44 |
|        61 | Wilkinson A          |        61 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        61 | Wilkinson A          |        61 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        24 | Gardner PP           |        24 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        38 | Moore B              |        38 |
|         2 | Argasinska J         |         2 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        16 | Daub J               |        16 |
|         2 | Argasinska J         |         2 |
|        38 | Moore B              |        38 |
|         2 | Argasinska J         |         2 |
|        56 | Weinberg Z           |        56 |
|         2 | Argasinska J         |         2 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|         4 | Barquist LE          |         4 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        33 | Marantidis E         |        33 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        38 | Moore B              |        38 |
|        56 | Weinberg Z           |        56 |
|        24 | Gardner PP           |        24 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        16 | Daub J               |        16 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        38 | Moore B              |        38 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        24 | Gardner PP           |        24 |
|        38 | Moore B              |        38 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        33 | Marantidis E         |        33 |
|         6 | Bateman A            |         6 |
|        61 | Wilkinson A          |        61 |
|         2 | Argasinska J         |         2 |
|        44 | Osuch I              |        44 |
|        33 | Marantidis E         |        33 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        16 | Daub J               |        16 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        33 | Marantidis E         |        33 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        26 | Griffiths-Jones SR   |        26 |
|        56 | Weinberg Z           |        56 |
|         2 | Argasinska J         |         2 |
|        61 | Wilkinson A          |        61 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        32 | Machado Lima A       |        32 |
|        39 | Moxon SJ             |        39 |
|        33 | Marantidis E         |        33 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        33 | Marantidis E         |        33 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|         8 | Boursnell C          |         8 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        56 | Weinberg Z           |        56 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        61 | Wilkinson A          |        61 |
|        44 | Osuch I              |        44 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|        33 | Marantidis E         |        33 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        56 | Weinberg Z           |        56 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|        61 | Wilkinson A          |        61 |
|        38 | Moore B              |        38 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|         6 | Bateman A            |         6 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        33 | Marantidis E         |        33 |
|        16 | Daub J               |        16 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|        24 | Gardner PP           |        24 |
|        38 | Moore B              |        38 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|        33 | Marantidis E         |        33 |
|         2 | Argasinska J         |         2 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        13 | Chen A               |        13 |
|        10 | Brown C              |        10 |
|        16 | Daub J               |        16 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|        24 | Gardner PP           |        24 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        56 | Weinberg Z           |        56 |
|        39 | Moxon SJ             |        39 |
|        58 | Wilkinson AC         |        58 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        19 | Doniger T            |        19 |
|        35 | Michaeli S           |        35 |
|        51 | Unger R              |        51 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        38 | Moore B              |        38 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        16 | Daub J               |        16 |
|        62 | Eberhardt R          |        62 |
|        26 | Griffiths-Jones SR   |        26 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        24 | Gardner PP           |        24 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        62 | Eberhardt R          |        62 |
|        16 | Daub J               |        16 |
|        39 | Moxon SJ             |        39 |
|        61 | Wilkinson A          |        61 |
|        39 | Moxon SJ             |        39 |
|        61 | Wilkinson A          |        61 |
|        56 | Weinberg Z           |        56 |
|        44 | Osuch I              |        44 |
|        56 | Weinberg Z           |        56 |
|        44 | Osuch I              |        44 |
|        39 | Moxon SJ             |        39 |
|        24 | Gardner PP           |        24 |
|        34 | Marz M               |        34 |
|        26 | Griffiths-Jones SR   |        26 |
|        16 | Daub J               |        16 |
|        26 | Griffiths-Jones SR   |        26 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        56 | Weinberg Z           |        56 |
|        24 | Gardner PP           |        24 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        24 | Gardner PP           |        24 |
|        34 | Marz M               |        34 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        26 | Griffiths-Jones SR   |        26 |
|        36 | Mifsud W             |        36 |
|        24 | Gardner PP           |        24 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|         5 | Barrick JE           |         5 |
|         5 | Barrick JE           |         5 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|         6 | Bateman A            |         6 |
|        26 | Griffiths-Jones SR   |        26 |
|         6 | Bateman A            |         6 |
|        13 | Chen A               |        13 |
|        10 | Brown C              |        10 |
|        16 | Daub J               |        16 |
|       108 | Jonas K              |       108 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        60 | Yang J               |        60 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        38 | Moore B              |        38 |
|         8 | Boursnell C          |         8 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|        56 | Weinberg Z           |        56 |
|        24 | Gardner PP           |        24 |
|        56 | Weinberg Z           |        56 |
|        24 | Gardner PP           |        24 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        56 | Weinberg Z           |        56 |
|        79 | Gore J               |        79 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        76 | Eckert I             |        76 |
|        56 | Weinberg Z           |        56 |
|        76 | Eckert I             |        76 |
|        56 | Weinberg Z           |        56 |
|        76 | Eckert I             |        76 |
|        56 | Weinberg Z           |        56 |
|        76 | Eckert I             |        76 |
|        56 | Weinberg Z           |        56 |
|        76 | Eckert I             |        76 |
|        56 | Weinberg Z           |        56 |
|        76 | Eckert I             |        76 |
|        56 | Weinberg Z           |        56 |
|        76 | Eckert I             |        76 |
|        56 | Weinberg Z           |        56 |
|        76 | Eckert I             |        76 |
|        56 | Weinberg Z           |        56 |
|        76 | Eckert I             |        76 |
|        56 | Weinberg Z           |        56 |
|        76 | Eckert I             |        76 |
|        56 | Weinberg Z           |        56 |
|        76 | Eckert I             |        76 |
|        56 | Weinberg Z           |        56 |
|        76 | Eckert I             |        76 |
|        56 | Weinberg Z           |        56 |
|        76 | Eckert I             |        76 |
|        56 | Weinberg Z           |        56 |
|        76 | Eckert I             |        76 |
|        56 | Weinberg Z           |        56 |
|        76 | Eckert I             |        76 |
|        80 | Secherre E           |        80 |
|        81 | Boudhouche H         |        81 |
|        82 | Bahroun R            |        82 |
|        92 | Rabearivelo N        |        92 |
|        93 | Marty M              |        93 |
|        94 | Sabban J             |        94 |
|       119 | Brewer, KI           |       119 |
|       107 | Ontiveros-Palacios N |       107 |
|       128 | Hooks KB             |       128 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|         6 | Bateman A            |         6 |
|        24 | Gardner PP           |        24 |
|         6 | Bateman A            |         6 |
|        39 | Moxon SJ             |        39 |
|        58 | Wilkinson AC         |        58 |
|        26 | Griffiths-Jones SR   |        26 |
|        36 | Mifsud W             |        36 |
|        26 | Griffiths-Jones SR   |        26 |
|        36 | Mifsud W             |        36 |
|        24 | Gardner PP           |        24 |
|        26 | Griffiths-Jones SR   |        26 |
|        24 | Gardner PP           |        24 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        39 | Moxon SJ             |        39 |
|        26 | Griffiths-Jones SR   |        26 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|         5 | Barrick JE           |         5 |
|         9 | Breaker RR           |         9 |
|         5 | Barrick JE           |         5 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        10 | Brown C              |        10 |
|        56 | Weinberg Z           |        56 |
|        24 | Gardner PP           |        24 |
|        56 | Weinberg Z           |        56 |
|        24 | Gardner PP           |        24 |
|        56 | Weinberg Z           |        56 |
|        24 | Gardner PP           |        24 |
|        26 | Griffiths-Jones SR   |        26 |
|        36 | Mifsud W             |        36 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        24 | Gardner PP           |        24 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        65 | Corbino K            |        65 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|         8 | Boursnell C          |         8 |
|        38 | Moore B              |        38 |
|        44 | Osuch I              |        44 |
|        38 | Moore B              |        38 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        24 | Gardner PP           |        24 |
|        38 | Moore B              |        38 |
|        38 | Moore B              |        38 |
|         8 | Boursnell C          |         8 |
|         8 | Boursnell C          |         8 |
|         8 | Boursnell C          |         8 |
|        24 | Gardner PP           |        24 |
|        24 | Gardner PP           |        24 |
|        62 | Eberhardt R          |        62 |
|        30 | Jones T              |        30 |
|        38 | Moore B              |        38 |
|        16 | Daub J               |        16 |
|        34 | Marz M               |        34 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        24 | Gardner PP           |        24 |
|        24 | Gardner PP           |        24 |
|        56 | Weinberg Z           |        56 |
|        24 | Gardner PP           |        24 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        56 | Weinberg Z           |        56 |
|        24 | Gardner PP           |        24 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        31 | Levy A               |        31 |
|        11 | Burge SW             |        11 |
|        56 | Weinberg Z           |        56 |
|        24 | Gardner PP           |        24 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        45 | Quinones-Olvera N    |        45 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        72 | Repoila F            |        72 |
|         2 | Argasinska J         |         2 |
|        56 | Weinberg Z           |        56 |
|        24 | Gardner PP           |        24 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        62 | Eberhardt R          |        62 |
|       107 | Ontiveros-Palacios N |       107 |
|        56 | Weinberg Z           |        56 |
|       107 | Ontiveros-Palacios N |       107 |
|       110 | Prezza, G            |       110 |
|       111 | Ryan, D              |       111 |
|       115 | Madler, G            |       115 |
|       113 | Barquist, L          |       113 |
|       114 | Westermann, A        |       114 |
|        26 | Griffiths-Jones SR   |        26 |
|        36 | Mifsud W             |        36 |
|        24 | Gardner PP           |        24 |
|        61 | Wilkinson A          |        61 |
|       107 | Ontiveros-Palacios N |       107 |
|        24 | Gardner PP           |        24 |
|       107 | Ontiveros-Palacios N |       107 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|        56 | Weinberg Z           |        56 |
|        26 | Griffiths-Jones SR   |        26 |
|        36 | Mifsud W             |        36 |
|        24 | Gardner PP           |        24 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|         6 | Bateman A            |         6 |
|        39 | Moxon SJ             |        39 |
|        44 | Osuch I              |        44 |
|        16 | Daub J               |        16 |
|         6 | Bateman A            |         6 |
|        39 | Moxon SJ             |        39 |
|       107 | Ontiveros-Palacios N |       107 |
|         2 | Argasinska J         |         2 |
|        65 | Corbino K            |        65 |
|        56 | Weinberg Z           |        56 |
|         2 | Argasinska J         |         2 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        76 | Eckert I             |        76 |
|        56 | Weinberg Z           |        56 |
|        76 | Eckert I             |        76 |
|        56 | Weinberg Z           |        56 |
|        76 | Eckert I             |        76 |
|        56 | Weinberg Z           |        56 |
|        76 | Eckert I             |        76 |
|        56 | Weinberg Z           |        56 |
|        76 | Eckert I             |        76 |
|        23 | Finn RD              |        23 |
|       107 | Ontiveros-Palacios N |       107 |
|        24 | Gardner PP           |        24 |
|        38 | Moore B              |        38 |
|       107 | Ontiveros-Palacios N |       107 |
|         6 | Bateman A            |         6 |
|        24 | Gardner PP           |        24 |
|        24 | Gardner PP           |        24 |
|        56 | Weinberg Z           |        56 |
|        24 | Gardner PP           |        24 |
|        26 | Griffiths-Jones SR   |        26 |
|        24 | Gardner PP           |        24 |
|        26 | Griffiths-Jones SR   |        26 |
|        24 | Gardner PP           |        24 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        39 | Moxon SJ             |        39 |
|        24 | Gardner PP           |        24 |
|        39 | Moxon SJ             |        39 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|         5 | Barrick JE           |         5 |
|         6 | Bateman A            |         6 |
|        53 | Vitreschak AG        |        53 |
|        69 | Gelfand MS           |        69 |
|        24 | Gardner PP           |        24 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        39 | Moxon SJ             |        39 |
|        58 | Wilkinson AC         |        58 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        24 | Gardner PP           |        24 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        39 | Moxon SJ             |        39 |
|        33 | Marantidis E         |        33 |
|        16 | Daub J               |        16 |
|        33 | Marantidis E         |        33 |
|        61 | Wilkinson A          |        61 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        56 | Weinberg Z           |        56 |
|        24 | Gardner PP           |        24 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        56 | Weinberg Z           |        56 |
|        24 | Gardner PP           |        24 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        16 | Daub J               |        16 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|         2 | Argasinska J         |         2 |
|        38 | Moore B              |        38 |
|        16 | Daub J               |        16 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|       124 | Rodionov DA          |       124 |
|       125 | Vitreshchak AG       |       125 |
|       126 | Mironov AA           |       126 |
|        69 | Gelfand MS           |        69 |
|         6 | Bateman A            |         6 |
|        39 | Moxon SJ             |        39 |
|       107 | Ontiveros-Palacios N |       107 |
|        56 | Weinberg Z           |        56 |
|       107 | Ontiveros-Palacios N |       107 |
|        71 | Vitreshchak A        |        71 |
|        25 | Gelfand M            |        25 |
|         6 | Bateman A            |         6 |
|       107 | Ontiveros-Palacios N |       107 |
|        26 | Griffiths-Jones SR   |        26 |
|        24 | Gardner PP           |        24 |
|       107 | Ontiveros-Palacios N |       107 |
|         7 | Boese B              |         7 |
|         5 | Barrick JE           |         5 |
|         9 | Breaker RR           |         9 |
|        57 | Wickiser JK          |        57 |
|         5 | Barrick JE           |         5 |
|         9 | Breaker RR           |         9 |
|        59 | Winkler WC           |        59 |
|        42 | Nahvi A              |        42 |
|        46 | Roth A               |        46 |
|        14 | Collins JA           |        14 |
|         5 | Barrick JE           |         5 |
|         9 | Breaker RR           |         9 |
|         5 | Barrick JE           |         5 |
|        15 | Corbino KA           |        15 |
|         9 | Breaker RR           |         9 |
|         5 | Barrick JE           |         5 |
|         9 | Breaker RR           |         9 |
|       107 | Ontiveros-Palacios N |       107 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|       107 | Ontiveros-Palacios N |       107 |
|        60 | Yang J               |        60 |
|        56 | Weinberg Z           |        56 |
|       107 | Ontiveros-Palacios N |       107 |
|        56 | Weinberg Z           |        56 |
|       107 | Ontiveros-Palacios N |       107 |
|        24 | Gardner PP           |        24 |
|        56 | Weinberg Z           |        56 |
|        38 | Moore B              |        38 |
|        56 | Weinberg Z           |        56 |
|         1 | Ames T               |         1 |
|       107 | Ontiveros-Palacios N |       107 |
|         2 | Argasinska J         |         2 |
|       107 | Ontiveros-Palacios N |       107 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|        26 | Griffiths-Jones SR   |        26 |
|       107 | Ontiveros-Palacios N |       107 |
|        56 | Weinberg Z           |        56 |
|       107 | Ontiveros-Palacios N |       107 |
|         6 | Bateman A            |         6 |
|         5 | Barrick JE           |         5 |
|        26 | Griffiths-Jones SR   |        26 |
|        36 | Mifsud W             |        36 |
|        39 | Moxon SJ             |        39 |
|       107 | Ontiveros-Palacios N |       107 |
|        56 | Weinberg Z           |        56 |
|       107 | Ontiveros-Palacios N |       107 |
|        56 | Weinberg Z           |        56 |
|       107 | Ontiveros-Palacios N |       107 |
|         2 | Argasinska J         |         2 |
|       107 | Ontiveros-Palacios N |       107 |
|        38 | Moore B              |        38 |
|       107 | Ontiveros-Palacios N |       107 |
|        13 | Chen A               |        13 |
|        10 | Brown C              |        10 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|       107 | Ontiveros-Palacios N |       107 |
|        56 | Weinberg Z           |        56 |
|       107 | Ontiveros-Palacios N |       107 |
|        56 | Weinberg Z           |        56 |
|        24 | Gardner PP           |        24 |
|        56 | Weinberg Z           |        56 |
|       107 | Ontiveros-Palacios N |       107 |
|        56 | Weinberg Z           |        56 |
|       107 | Ontiveros-Palacios N |       107 |
|        29 | Holmes I             |        29 |
|        39 | Moxon SJ             |        39 |
|        21 | Eddy SR              |        21 |
|        26 | Griffiths-Jones SR   |        26 |
|        36 | Mifsud W             |        36 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|       107 | Ontiveros-Palacios N |       107 |
|        16 | Daub J               |        16 |
|        26 | Griffiths-Jones SR   |        26 |
|        16 | Daub J               |        16 |
|        39 | Moxon SJ             |        39 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        39 | Moxon SJ             |        39 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        39 | Moxon SJ             |        39 |
|        26 | Griffiths-Jones SR   |        26 |
|        39 | Moxon SJ             |        39 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        16 | Daub J               |        16 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        16 | Daub J               |        16 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|         8 | Boursnell C          |         8 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        16 | Daub J               |        16 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        39 | Moxon SJ             |        39 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        16 | Daub J               |        16 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        16 | Daub J               |        16 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        16 | Daub J               |        16 |
|       107 | Ontiveros-Palacios N |       107 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        39 | Moxon SJ             |        39 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        62 | Eberhardt R          |        62 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        16 | Daub J               |        16 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        16 | Daub J               |        16 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|         8 | Boursnell C          |         8 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|         8 | Boursnell C          |         8 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        11 | Burge SW             |        11 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        16 | Daub J               |        16 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        38 | Moore B              |        38 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|         8 | Boursnell C          |         8 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|         8 | Boursnell C          |         8 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|         8 | Boursnell C          |         8 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        62 | Eberhardt R          |        62 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        16 | Daub J               |        16 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        16 | Daub J               |        16 |
|        26 | Griffiths-Jones SR   |        26 |
|        39 | Moxon SJ             |        39 |
|        26 | Griffiths-Jones SR   |        26 |
|        16 | Daub J               |        16 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        39 | Moxon SJ             |        39 |
|         8 | Boursnell C          |         8 |
|        26 | Griffiths-Jones SR   |        26 |
|        16 | Daub J               |        16 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        16 | Daub J               |        16 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        16 | Daub J               |        16 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        16 | Daub J               |        16 |
|        26 | Griffiths-Jones SR   |        26 |
|        16 | Daub J               |        16 |
|        61 | Wilkinson A          |        61 |
|        26 | Griffiths-Jones SR   |        26 |
|        16 | Daub J               |        16 |
|        26 | Griffiths-Jones SR   |        26 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|         5 | Barrick JE           |         5 |
|         9 | Breaker RR           |         9 |
|        39 | Moxon SJ             |        39 |
|        24 | Gardner PP           |        24 |
|       107 | Ontiveros-Palacios N |       107 |
|        11 | Burge SW             |        11 |
|        39 | Moxon SJ             |        39 |
|         6 | Bateman A            |         6 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|       107 | Ontiveros-Palacios N |       107 |
|        56 | Weinberg Z           |        56 |
|         5 | Barrick JE           |         5 |
|        39 | Moxon SJ             |        39 |
|       107 | Ontiveros-Palacios N |       107 |
|        56 | Weinberg Z           |        56 |
|        24 | Gardner PP           |        24 |
|       107 | Ontiveros-Palacios N |       107 |
|        56 | Weinberg Z           |        56 |
|        55 | Wang J               |        55 |
|        24 | Gardner PP           |        24 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        24 | Gardner PP           |        24 |
|        56 | Weinberg Z           |        56 |
|       107 | Ontiveros-Palacios N |       107 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|       107 | Ontiveros-Palacios N |       107 |
|         4 | Barquist LE          |         4 |
|         6 | Bateman A            |         6 |
|         6 | Bateman A            |         6 |
|         4 | Barquist LE          |         4 |
|         6 | Bateman A            |         6 |
|         6 | Bateman A            |         6 |
|         6 | Bateman A            |         6 |
|       127 | Gardner P            |       127 |
|         6 | Bateman A            |         6 |
|         6 | Bateman A            |         6 |
|         6 | Bateman A            |         6 |
|         6 | Bateman A            |         6 |
|        16 | Daub J               |        16 |
|        39 | Moxon SJ             |        39 |
|         2 | Argasinska J         |         2 |
|        67 | Barquist L           |        67 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        67 | Barquist L           |        67 |
|        39 | Moxon SJ             |        39 |
|       127 | Gardner P            |       127 |
|        22 | Filiatrault M        |        22 |
|       127 | Gardner P            |       127 |
|        26 | Griffiths-Jones SR   |        26 |
|         4 | Barquist LE          |         4 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        67 | Barquist L           |        67 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|       107 | Ontiveros-Palacios N |       107 |
|         5 | Barrick JE           |         5 |
|        16 | Daub J               |        16 |
|        16 | Daub J               |        16 |
|        16 | Daub J               |        16 |
|        54 | Voss B               |        54 |
|        24 | Gardner PP           |        24 |
|        67 | Barquist L           |        67 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|        67 | Barquist L           |        67 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|        24 | Gardner PP           |        24 |
|        24 | Gardner PP           |        24 |
|        24 | Gardner PP           |        24 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        16 | Daub J               |        16 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        16 | Daub J               |        16 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        11 | Burge SW             |        11 |
|       130 | Burge S              |       130 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        60 | Yang J               |        60 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        65 | Corbino K            |        65 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        38 | Moore B              |        38 |
|        38 | Moore B              |        38 |
|        38 | Moore B              |        38 |
|        38 | Moore B              |        38 |
|        38 | Moore B              |        38 |
|        38 | Moore B              |        38 |
|        38 | Moore B              |        38 |
|        38 | Moore B              |        38 |
|        73 | Meyer MM             |        73 |
|        24 | Gardner PP           |        24 |
|        38 | Moore B              |        38 |
|        38 | Moore B              |        38 |
|        38 | Moore B              |        38 |
|        38 | Moore B              |        38 |
|        38 | Moore B              |        38 |
|        38 | Moore B              |        38 |
|        38 | Moore B              |        38 |
|        38 | Moore B              |        38 |
|        38 | Moore B              |        38 |
|        38 | Moore B              |        38 |
|        38 | Moore B              |        38 |
|        38 | Moore B              |        38 |
|        38 | Moore B              |        38 |
|        38 | Moore B              |        38 |
|        38 | Moore B              |        38 |
|         4 | Barquist LE          |         4 |
|        44 | Osuch I              |        44 |
|         4 | Barquist LE          |         4 |
|         4 | Barquist LE          |         4 |
|        11 | Burge SW             |        11 |
|        62 | Eberhardt R          |        62 |
|         4 | Barquist LE          |         4 |
|        11 | Burge SW             |        11 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|         4 | Barquist LE          |         4 |
|         4 | Barquist LE          |         4 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        11 | Burge SW             |        11 |
|        62 | Eberhardt R          |        62 |
|        11 | Burge SW             |        11 |
|         4 | Barquist LE          |         4 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        11 | Burge SW             |        11 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        11 | Burge SW             |        11 |
|        11 | Burge SW             |        11 |
|        62 | Eberhardt R          |        62 |
|        38 | Moore B              |        38 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        11 | Burge SW             |        11 |
|        11 | Burge SW             |        11 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        45 | Quinones-Olvera N    |        45 |
|         2 | Argasinska J         |         2 |
|        45 | Quinones-Olvera N    |        45 |
|        56 | Weinberg Z           |        56 |
|         2 | Argasinska J         |         2 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|       110 | Prezza, G            |       110 |
|       111 | Ryan, D              |       111 |
|       115 | Madler, G            |       115 |
|       113 | Barquist, L          |       113 |
|       114 | Westermann, A        |       114 |
|        95 | Ducos C              |        95 |
|        96 | Michel M             |        96 |
|        97 | Morice E             |        97 |
|       110 | Prezza, G            |       110 |
|       111 | Ryan, D              |       111 |
|       115 | Madler, G            |       115 |
|       113 | Barquist, L          |       113 |
|       114 | Westermann, A        |       114 |
|       110 | Prezza, G            |       110 |
|       111 | Ryan, D              |       111 |
|       115 | Madler, G            |       115 |
|       113 | Barquist, L          |       113 |
|       114 | Westermann, A        |       114 |
|       110 | Prezza, G            |       110 |
|       111 | Ryan, D              |       111 |
|       115 | Madler, G            |       115 |
|       113 | Barquist, L          |       113 |
|       114 | Westermann, A        |       114 |
|       110 | Prezza, G            |       110 |
|       111 | Ryan, D              |       111 |
|       115 | Madler, G            |       115 |
|       113 | Barquist, L          |       113 |
|       114 | Westermann, A        |       114 |
|       110 | Prezza, G            |       110 |
|       111 | Ryan, D              |       111 |
|       115 | Madler, G            |       115 |
|       113 | Barquist, L          |       113 |
|       114 | Westermann, A        |       114 |
|       110 | Prezza, G            |       110 |
|       111 | Ryan, D              |       111 |
|       115 | Madler, G            |       115 |
|       113 | Barquist, L          |       113 |
|       114 | Westermann, A        |       114 |
|        56 | Weinberg Z           |        56 |
|        78 | Ames TD              |        78 |
|        56 | Weinberg Z           |        56 |
|        78 | Ames TD              |        78 |
|        56 | Weinberg Z           |        56 |
|        78 | Ames TD              |        78 |
|        26 | Griffiths-Jones SR   |        26 |
|        36 | Mifsud W             |        36 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|        34 | Marz M               |        34 |
|        16 | Daub J               |        16 |
|        24 | Gardner PP           |        24 |
|        28 | Gutell RR            |        28 |
|        24 | Gardner PP           |        24 |
|        43 | Nawrocki E           |        43 |
|        44 | Osuch I              |        44 |
|        26 | Griffiths-Jones SR   |        26 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        26 | Griffiths-Jones SR   |        26 |
|        39 | Moxon SJ             |        39 |
|        26 | Griffiths-Jones SR   |        26 |
|        39 | Moxon SJ             |        39 |
|        68 | Wilkison A           |        68 |
|        16 | Daub J               |        16 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        61 | Wilkinson A          |        61 |
|        33 | Marantidis E         |        33 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        11 | Burge SW             |        11 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        61 | Wilkinson A          |        61 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        61 | Wilkinson A          |        61 |
|        39 | Moxon SJ             |        39 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        11 | Burge SW             |        11 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|        44 | Osuch I              |        44 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        11 | Burge SW             |        11 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        28 | Gutell RR            |        28 |
|        43 | Nawrocki E           |        43 |
|         6 | Bateman A            |         6 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        43 | Nawrocki E           |        43 |
|         6 | Bateman A            |         6 |
|        16 | Daub J               |        16 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|         6 | Bateman A            |         6 |
|        26 | Griffiths-Jones SR   |        26 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        75 | Lamkiewicz K         |        75 |
|       120 | Triebel S            |       120 |
|        34 | Marz M               |        34 |
|        26 | Griffiths-Jones SR   |        26 |
|        39 | Moxon SJ             |        39 |
|        28 | Gutell RR            |        28 |
|        43 | Nawrocki E           |        43 |
|        28 | Gutell RR            |        28 |
|        43 | Nawrocki E           |        43 |
|        24 | Gardner PP           |        24 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|       107 | Ontiveros-Palacios N |       107 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        75 | Lamkiewicz K         |        75 |
|       120 | Triebel S            |       120 |
|        34 | Marz M               |        34 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|         6 | Bateman A            |         6 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|         6 | Bateman A            |         6 |
|         6 | Bateman A            |         6 |
|         6 | Bateman A            |         6 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|         6 | Bateman A            |         6 |
|        39 | Moxon SJ             |        39 |
|       107 | Ontiveros-Palacios N |       107 |
|         5 | Barrick JE           |         5 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|         5 | Barrick JE           |         5 |
|         5 | Barrick JE           |         5 |
|         5 | Barrick JE           |         5 |
|         5 | Barrick JE           |         5 |
|        40 | Moy RH               |        40 |
|        16 | Daub J               |        16 |
|        75 | Lamkiewicz K         |        75 |
|       120 | Triebel S            |       120 |
|        34 | Marz M               |        34 |
|        75 | Lamkiewicz K         |        75 |
|       120 | Triebel S            |       120 |
|        34 | Marz M               |        34 |
|        75 | Lamkiewicz K         |        75 |
|       120 | Triebel S            |       120 |
|        34 | Marz M               |        34 |
|        75 | Lamkiewicz K         |        75 |
|       120 | Triebel S            |       120 |
|        34 | Marz M               |        34 |
|        75 | Lamkiewicz K         |        75 |
|       120 | Triebel S            |       120 |
|        34 | Marz M               |        34 |
|        75 | Lamkiewicz K         |        75 |
|       120 | Triebel S            |       120 |
|        34 | Marz M               |        34 |
|        75 | Lamkiewicz K         |        75 |
|       120 | Triebel S            |       120 |
|        34 | Marz M               |        34 |
|        75 | Lamkiewicz K         |        75 |
|       120 | Triebel S            |       120 |
|        34 | Marz M               |        34 |
|        24 | Gardner PP           |        24 |
|       107 | Ontiveros-Palacios N |       107 |
|         6 | Bateman A            |         6 |
|        39 | Moxon SJ             |        39 |
|        75 | Lamkiewicz K         |        75 |
|       120 | Triebel S            |       120 |
|        34 | Marz M               |        34 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        43 | Nawrocki E           |        43 |
|        26 | Griffiths-Jones SR   |        26 |
|        26 | Griffiths-Jones SR   |        26 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|         6 | Bateman A            |         6 |
|         6 | Bateman A            |         6 |
|        39 | Moxon SJ             |        39 |
|        56 | Weinberg Z           |        56 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|         6 | Bateman A            |         6 |
|        39 | Moxon SJ             |        39 |
|       107 | Ontiveros-Palacios N |       107 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        75 | Lamkiewicz K         |        75 |
|       120 | Triebel S            |       120 |
|        34 | Marz M               |        34 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        44 | Osuch I              |        44 |
|        16 | Daub J               |        16 |
|        16 | Daub J               |        16 |
|        16 | Daub J               |        16 |
|        62 | Eberhardt R          |        62 |
|       118 | Choi K               |       118 |
|       107 | Ontiveros-Palacios N |       107 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        75 | Lamkiewicz K         |        75 |
|        75 | Lamkiewicz K         |        75 |
|        75 | Lamkiewicz K         |        75 |
|        75 | Lamkiewicz K         |        75 |
|        75 | Lamkiewicz K         |        75 |
|        75 | Lamkiewicz K         |        75 |
|        75 | Lamkiewicz K         |        75 |
|        75 | Lamkiewicz K         |        75 |
|        75 | Lamkiewicz K         |        75 |
|        75 | Lamkiewicz K         |        75 |
|        75 | Lamkiewicz K         |        75 |
|        75 | Lamkiewicz K         |        75 |
|        75 | Lamkiewicz K         |        75 |
|        75 | Lamkiewicz K         |        75 |
|       106 | Wolfinger MT         |       106 |
|        75 | Lamkiewicz K         |        75 |
|       106 | Wolfinger MT         |       106 |
|        75 | Lamkiewicz K         |        75 |
|       106 | Wolfinger MT         |       106 |
|        75 | Lamkiewicz K         |        75 |
|        75 | Lamkiewicz K         |        75 |
|       106 | Wolfinger MT         |       106 |
|        75 | Lamkiewicz K         |        75 |
|        75 | Lamkiewicz K         |        75 |
|        75 | Lamkiewicz K         |        75 |
|       121 | Steckelberg A        |       121 |
|       122 | Vicens Q             |       122 |
|       123 | Jeffrey K            |       123 |
|        75 | Lamkiewicz K         |        75 |
|       120 | Triebel S            |       120 |
|        34 | Marz M               |        34 |
|        28 | Gutell RR            |        28 |
|        43 | Nawrocki E           |        43 |
|        28 | Gutell RR            |        28 |
|        43 | Nawrocki E           |        43 |
|        49 | Stevens S            |        49 |
|       127 | Gardner P            |       127 |
|        10 | Brown C              |        10 |
|        49 | Stevens S            |        49 |
|       127 | Gardner P            |       127 |
|        10 | Brown C              |        10 |
|         2 | Argasinska J         |         2 |
|         6 | Bateman A            |         6 |
|        39 | Moxon SJ             |        39 |
|         6 | Bateman A            |         6 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        26 | Griffiths-Jones SR   |        26 |
|         6 | Bateman A            |         6 |
|        16 | Daub J               |        16 |
|        16 | Daub J               |        16 |
|        16 | Daub J               |        16 |
|        16 | Daub J               |        16 |
|        16 | Daub J               |        16 |
|        16 | Daub J               |        16 |
|        39 | Moxon SJ             |        39 |
|        34 | Marz M               |        34 |
|        70 | Stadler PF           |        70 |
|        24 | Gardner PP           |        24 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|       107 | Ontiveros-Palacios N |       107 |
|        39 | Moxon SJ             |        39 |
|        43 | Nawrocki E           |        43 |
|       107 | Ontiveros-Palacios N |       107 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        61 | Wilkinson A          |        61 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        61 | Wilkinson A          |        61 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        39 | Moxon SJ             |        39 |
|        33 | Marantidis E         |        33 |
|        16 | Daub J               |        16 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        33 | Marantidis E         |        33 |
|        16 | Daub J               |        16 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|        33 | Marantidis E         |        33 |
|        16 | Daub J               |        16 |
|        33 | Marantidis E         |        33 |
|        16 | Daub J               |        16 |
|        33 | Marantidis E         |        33 |
|        16 | Daub J               |        16 |
|        61 | Wilkinson A          |        61 |
|        16 | Daub J               |        16 |
|         2 | Argasinska J         |         2 |
|        16 | Daub J               |        16 |
|        61 | Wilkinson A          |        61 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|         2 | Argasinska J         |         2 |
|        26 | Griffiths-Jones SR   |        26 |
|        34 | Marz M               |        34 |
|        62 | Eberhardt R          |        62 |
|        26 | Griffiths-Jones SR   |        26 |
|        24 | Gardner PP           |        24 |
|        27 | Gruber A             |        27 |
|        70 | Stadler PF           |        70 |
|        24 | Gardner PP           |        24 |
|        62 | Eberhardt R          |        62 |
|        62 | Eberhardt R          |        62 |
|        39 | Moxon SJ             |        39 |
|        39 | Moxon SJ             |        39 |
|        16 | Daub J               |        16 |
|       107 | Ontiveros-Palacios N |       107 |
|         6 | Bateman A            |         6 |
|        83 | Gobalakichenin A     |        83 |
|        84 | Ibene M              |        84 |
|        85 | Pohyer V             |        85 |
|        75 | Lamkiewicz K         |        75 |
|        62 | Eberhardt R          |        62 |
|        28 | Gutell RR            |        28 |
|        43 | Nawrocki E           |        43 |
|        56 | Weinberg Z           |        56 |
|        56 | Weinberg Z           |        56 |
|        39 | Moxon SJ             |        39 |
|        38 | Moore B              |        38 |
|         6 | Bateman A            |         6 |
|       107 | Ontiveros-Palacios N |       107 |
|         6 | Bateman A            |         6 |
|        17 | de la Pena M         |        17 |
|        11 | Burge SW             |        11 |
|        17 | de la Pena M         |        17 |
|        11 | Burge SW             |        11 |
|        56 | Weinberg Z           |        56 |
|        76 | Eckert I             |        76 |
|        56 | Weinberg Z           |        56 |
|        76 | Eckert I             |        76 |
|        56 | Weinberg Z           |        56 |
|        18 | Ditzler M            |        18 |
|        62 | Eberhardt R          |        62 |
|        44 | Osuch I              |        44 |
|        16 | Daub J               |        16 |
|       107 | Ontiveros-Palacios N |       107 |
|        26 | Griffiths-Jones SR   |        26 |
|        16 | Daub J               |        16 |
|        20 | Eberhardt RY         |        NA |
|        48 | Stadler P            |        NA |
|        77 | Weinberg Z, Ames TD  |        NA |
|       112 | MÃ¤dler, G           |        NA |

## Reading data from HIS APIs

The current version of **{readepi}** supports reading data from two
common HIS: [DHIS2](https://dhis2.org/), and
[SORMAS](https://sormas.org/).

### Importing data from DHIS2

The [District Health Information Software
(DHIS2)](https://dhis2.org/about-2/) is an open source software used by
many health institutions to store, manage and analyze various types of
health data. The
[`read_dhis2()`](https://epiverse-trace.github.io/readepi/reference/read_dhis2.md)
function can be used to import data from [DHIS2
Tracker](https://dhis2.org/tracker-in-action/) instances through their
API with following arguments:

- `login`: A `httr2_response` object returned by the
  [`login()`](https://epiverse-trace.github.io/readepi/reference/login.md)
  function
- `org_unit`: A character with the organisation unit ID or name
- `program`: A character with the program ID or name

It is important to note that the request parameters used in the internal
functions of the package vary depending on the API version. Currently,
{readepi} accounts for versions from **2.22** to **2.42**. The later is
the current version of the DHIS2 test instance. Newer versions (**\>
2.42**) might require a different syntax for the request parameters
depending on how they are defined by the DHIS2 developers. This can
result in the failure of the
[`read_dhis2()`](https://epiverse-trace.github.io/readepi/reference/read_dhis2.md)
function when importing data from those newer versions. An issue can be
raised [here](https://github.com/epiverse-trace/readepi/issues) to make
the developers of the package aware of this problem.

In the current version, the
[`login()`](https://epiverse-trace.github.io/readepi/reference/login.md)
function only supports basic authentication, i.e., using the user name
and password. An example of how to establish a connection to a DHIS2
instance is shown below.

``` r
# CONNECT TO A DHIS2 INSTANCE
dhis2_login <- login(
  type = "dhis2",
  from = "https://play.im.dhis2.org/stable-2-41-8",
  user_name = "admin",
  password = "district"
)
```

Organisation units and programs are the key elements for a successful
call of the
[`read_dhis2()`](https://epiverse-trace.github.io/readepi/reference/read_dhis2.md)
function. For this reason, we exported the following functions to help
users access and identify the correct organisation unit and program
names and IDs for a given DHIS2 instance.

``` r
# GET THE LIST OF ALL ORGANISATION UNITS IN AN HIERARCHICAL ORDER
org_units <- get_organisation_units(login = dhis2_login)
```

|           | National_name | National_id | District_name  | District_id | Chiefdom_name              | Chiefdom_id | Facility_name                                    | Facility_id |
|:----------|:--------------|:------------|:---------------|:------------|:---------------------------|:------------|:-------------------------------------------------|:------------|
| test_1    | Sierra Leone  | ImspTQPwCqd | 2026316 Region | Mv2k5OwQgv4 | 2026316 District           | KVZxPMZ1Zvx | 2026316 Facility                                 | Q6InHwbDddL |
| test_2    | Sierra Leone  | ImspTQPwCqd | 2333013_Region | a9wNItQbL75 | 2333013_District           | gXrZPWeKRlc | 2333013_Facility                                 | zjLp3AxhULB |
| test_3    | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Adonkia CHP                                      | Rp268JB6Ne4 |
| test_4    | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Afro Arab Clinic                                 | cDw53Ej8rju |
| test_5    | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Agape CHP                                        | GvFqTavdpGE |
| test_6    | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Magbema                    | QywkxFudXrC | Ahamadyya Mission Cl                             | plnHVbJR6p4 |
| test_7    | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Yoni                       | NNE0YMCDZkO | Ahmadiyya Muslim Hospital                        | BV4IomHvri4 |
| test_8    | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Kaffu Bullom               | vn9KJsLyP5f | Air Port Centre, Lungi                           | qjboFI0irVu |
| test_9    | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Nieni                      | J4GiUImJZoE | Alkalia CHP                                      | dWOAzMcK2Wt |
| test_10   | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Allen Town Health Post                           | kbGqmM6ZWWV |
| test_11   | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Approved School CHP                              | eoYV2p74eVz |
| test_12   | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Gbense                     | TQkG0sX9nca | Arab Clinic                                      | nq7F0t1Pz6t |
| test_13   | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Wandor                     | X7dWcGerQIm | Baama CHC                                        | r5WWF9WDzoa |
| test_14   | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Lokomasama                 | fRLX08WHWpL | Babara CHC                                       | yMCshbaVExv |
| test_15   | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Diang                      | Lt8U7GVWvSR | Badala MCHP                                      | tlMeFk8C4CG |
| test_16   | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Wara Wara Bafodia          | XrF5AvaGcuw | Bafodia CHC                                      | Jiymtq0A01x |
| test_17   | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Tankoro                    | M2qEv692lS6 | Baiama CHP                                       | XtuhRhmbrJM |
| test_18   | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Kaffu Bullom               | vn9KJsLyP5f | Bai Bureh Memorial Hospital                      | BH7rDkWjUqc |
| test_19   | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Mandu                      | yu4N82FFeLm | Baiima CHP                                       | c41XRVOYNJm |
| test_20   | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kori                       | nV3OkyzF4US | Bai Largo MCHP                                   | Rll4VmTDRiE |
| test_21   | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Lokomasama                 | fRLX08WHWpL | Bailor CHP                                       | Eyj2kiEJ7M3 |
| test_22   | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Dea                        | lYIM1MXbSYS | Baiwala CHP                                      | HFyjUvMjQ8H |
| test_23   | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Yoni                       | NNE0YMCDZkO | Bakeloko CHP                                     | MHAWZr2Caxw |
| test_24   | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Gorama Mende               | KXSqt7jv6DU | Bambara Kaima CHP                                | LOpWauwwghf |
| test_25   | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Wandor                     | X7dWcGerQIm | Bambara MCHP                                     | mUuCjQWMaOc |
| test_26   | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Bambawolo CHP                                    | TNbHYOuQi8s |
| test_27   | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Dasse                      | RndxKqQGzUl | Bambuibu Tommy MCHP                              | aSfF9kuNINJ |
| test_28   | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Sengbeh                    | VGAFxBXz16y | Bambukoro MCHP                                   | wYLjA4vN6Y9 |
| test_29   | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Banana Island MCHP                               | jjtzkzrmG7s |
| test_30   | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Sowa                       | NqWaKXcg01b | Bandajuma Clinic CHC                             | FNnj3jKGS7i |
| test_31   | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Njaluahun                  | ERmBhYkhV6Y | Bandajuma Kpolihun CHP                           | ABM75Q1UfoP |
| test_32   | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Bandajuma MCHP                                   | rx9ubw0UCqj |
| test_33   | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Luawa                      | cM2BKSrj9F9 | Bandajuma Sinneh MCHP                            | OZ1olxsTyNa |
| test_34   | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Yawei                      | byp7w6Xd9Df | Bandajuma Yawei CHC                              | MpcMjLmbATv |
| test_35   | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Nieni                      | J4GiUImJZoE | Bandakarifaia MCHP                               | qO2JLjYrg91 |
| test_36   | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Neya                       | GFk45MOxzJJ | Bandaperie CHP                                   | U7yKrx2QVet |
| test_37   | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Barri                      | RzKeCma9qb1 | Bandasuma CHP                                    | uPshwz3B3Uu |
| test_38   | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Fiama                      | CF243RPvNY7 | Bandasuma Fiama MCHP                             | aF6iPGbrcRk |
| test_39   | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Niawa                      | uKC54fzxRzO | Bandawor MCHP                                    | lpAPY3QOY2D |
| test_40   | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Soa                        | iGHlidSFdpu | Bandusuma MCHP                                   | t1aAdpBbDB3 |
| test_41   | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Sandor                     | g5ptsn0SFX8 | Bangambaya MCHP                                  | xQIU41mR69s |
| test_42   | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Ya Kpukumu Krim            | pk7bUK5c1Uf | Bangoma MCHP                                     | pdF4XIHIGPx |
| test_43   | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Masungbala                 | FlBemv1NfEC | Banka Makuloh MCHP                               | rxc497GUdDt |
| test_44   | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Valunia                    | npWGUj37qDe | Baomahun CHC                                     | FLjwMPWLrL2 |
| test_45   | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Koya (kenema)              | EYt6ThQDagn | Baoma (Koya) CHC                                 | Yj2ni275yPJ |
| test_46   | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Nongoba Bullum             | VP397wRvePm | Baoma Kpenge CHP                                 | a1dP5m3Clw4 |
| test_47   | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Luawa                      | cM2BKSrj9F9 | Baoma (Luawa) MCHP                               | TQ5DSmdliN7 |
| test_48   | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Gbane                      | ajILkI0cfxn | Baoma MCHP                                       | t52CJEyLhch |
| test_49   | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Kandu Lepiema              | K1r3uF6eZ8n | Baoma Oil Mill CHC                               | Y8foq27WLti |
| test_50   | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Peje West                  | pmxZm7klXBy | Baoma-Peje CHP                                   | x8SUTSsJoeO |
| test_51   | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Baoma                      | vWbkYPRmKyS | Baoma Station CHP                                | jNb63DIHuwU |
| test_52   | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Samu                       | r06ohri9wA9 | Baptist Centre Kassirie                          | QIp6DHlMGfb |
| test_53   | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Samu                       | r06ohri9wA9 | Bapuya MCHP                                      | weLTzWrLXCO |
| test_54   | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Bramaia                    | kbPmt60yi0L | Barakuya MCHP                                    | eLLMnNjuluX |
| test_55   | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Bargbe                     | dGheVylzol6 | Barlie MCHP                                      | y5hLlID8ihI |
| test_56   | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Bureh Kasseh Maconteh      | TA7NvKjsn4A | Barmoi CHP                                       | XkA2vbJAWHG |
| test_57   | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Magbema                    | QywkxFudXrC | Barmoi Luma MCHP                                 | vyIl6s0lhKc |
| test_58   | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Masungbala                 | FlBemv1NfEC | Barmoi Munu CHP                                  | vELaJEPLOPF |
| test_59   | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kalansogoia                | smoyi1iYNK6 | Bassia MCHP                                      | tlvNeDXXrS7 |
| test_60   | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Yoni                       | NNE0YMCDZkO | Bath Bana MCHP                                   | sDTodaygv5u |
| test_61   | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Wonde                      | ARZ4y5i4reU | Bathurst MCHP                                    | UGVLYrO63mR |
| test_62   | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Libeisaygahun              | hRZOIgQ0O1m | Batkanu CHC                                      | agM0BKQlTh3 |
| test_63   | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kongbora                   | Jiyc4ekaMMh | Bauya (Kongbora) CHC                             | iMZihUMzH92 |
| test_64   | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Kissi Teng                 | j0Mtr3xTMjM | Bayama (K. Teng) MCHP                            | cUNdCErxl9g |
| test_65   | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Kpanga Krim                | YpVol7asWvd | Bayama MCHP                                      | k92yudERPlv |
| test_66   | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Tunkia                     | l7pFejMtUoF | Belebu CHP                                       | PwgoRuWEDvJ |
| test_67   | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Bumpeh                     | nOYt1LtFSyU | Belentin MCHP                                    | qusWt6sESRU |
| test_68   | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Malegohun                  | x4HaBHHwBML | Bendoma (Malegohun) MCHP                         | VpYAl8dXs6m |
| test_69   | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Bendu Cha                  | EB1zRKdYjdY | Bendu CHC                                        | uFp0ztDOFbI |
| test_70   | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Sambaia Bendugu            | r1RUyfVBkLp | Bendugu CHC                                      | o0BgK1dLhF8 |
| test_71   | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Mongo                      | OTFepb1k9Db | Bendugu (Mongo) CHC                              | PMsF64R6OJX |
| test_72   | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kowa                       | xIKjidMrico | Bendu (Kowa) MCHP                                | er9S4CQ9QOn |
| test_73   | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Kwamabai Krim              | HV8RTzgcFH3 | Benduma CHC                                      | n7wN9gMFfZ5 |
| test_74   | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Bargbe                     | dGheVylzol6 | Benduma MCHP                                     | Wr8kmywwseZ |
| test_75   | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Malegohun                  | x4HaBHHwBML | Bendu Mameima CHC                                | amgb83zVxp5 |
| test_76   | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Yawei                      | byp7w6Xd9Df | Bendu (Yawei) CHP                                | DQHGtTGOP6b |
| test_77   | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Mano Sakrim                | nlt6j60tCHF | Bengani MCHP                                     | yDFM5J6WeKU |
| test_78   | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Benguema MI Room                                 | iPcreOldeV9 |
| test_79   | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Benguima Grassfield MCHP                         | ZKL5hlVG6F6 |
| test_80   | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Bagruwa                    | jPidqyo7cpF | Benkeh MCHP                                      | wQ71REGAMet |
| test_81   | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Lokomasama                 | fRLX08WHWpL | Benkia MCHP                                      | OcRCVRy2M7X |
| test_82   | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Safroko Limba              | XG8HGAbrbbL | Binkolo CHC                                      | GHHvGp7tgtZ |
| test_83   | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Small Bo                   | vzup1f6ynON | Blama CHC                                        | kUzpbgPCwVA |
| test_84   | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Galliness Perri            | eNtRuQrrZeo | Blama Massaquoi CHP                              | xXhKbgwL39t |
| test_85   | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Baoma                      | vWbkYPRmKyS | Blamawo MCHP                                     | WAjjFMDJKcx |
| test_86   | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Blessed Mokaba clinic                            | kBP1UvZpsNj |
| test_87   | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Blessed Mokaba East                              | lPeZdUm9fD7 |
| test_88   | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Blessed Mokaka East Clinic                       | waNtxFbPjrI |
| test_89   | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Simbaru                    | A3Fh37HWBWE | Boajibu CHC                                      | L5gENbBNNup |
| test_90   | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Bo Govt. Hosp.                                   | rZxk3S0qN63 |
| test_91   | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Upper Bambara              | LfTkc0S4b5k | Bomaru CHP                                       | D6yiaX1K5sO |
| test_92   | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Jawi                       | KSdZwrU7Hh6 | Bombohun MCHP                                    | PB8FMGbn19r |
| test_93   | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Fiama                      | CF243RPvNY7 | Bombordu MCHP                                    | YQYgz8exK9S |
| test_94   | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Lower Bambara              | hdEuw2ugkVF | Bomie MCHP                                       | VXrJKs8hic4 |
| test_95   | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Timidale                   | AovmOHadayb | Bomotoke CHC                                     | H97XE5Ea089 |
| test_96   | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Kpanga Kabonde             | QwMiPiME3bA | Bomu Saamba CHP                                  | aVlSMMvgVzf |
| test_97   | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Koya (kenema)              | EYt6ThQDagn | Bongor MCHP                                      | zAyK28LLaez |
| test_98   | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Yoni                       | NNE0YMCDZkO | Bonkababay MCHP                                  | IcVHzEm0b6Z |
| test_99   | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Lugbu                      | kU8vhUkAGaT | Bontiwo MCHP                                     | VfZnZ6UKyn8 |
| test_100  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Ya Kpukumu Krim            | pk7bUK5c1Uf | Borma (YKK) MCHP                                 | uYG1rUdsJJi |
| test_101  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Gbense                     | TQkG0sX9nca | Boroma MCHP                                      | szbAJSWOXjT |
| test_102  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Gbanti Kamaranka           | e1eIKM1GIF3 | Borongoh Makarankay CHP                          | cZZG5BMDLps |
| test_103  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Ribbi                      | gy8rmvYT4cj | Bradford CHC                                     | GRc9WXp9gSy |
| test_104  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Bucksal Clinic                                   | vRC0stJ5y9Q |
| test_105  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Kissi Tongi                | hjpHnHZIniP | Buedu CHC                                        | tO01bqIipeD |
| test_106  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Bumpe Ngao                 | BGGmAwx33dj | Buma MCHP                                        | AXZq6q7Dr6E |
| test_107  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Biriwa                     | fwH9ipvXde9 | Bumbanday MCHP                                   | LZclRdyVk1t |
| test_108  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Biriwa                     | fwH9ipvXde9 | Bumban MCHP                                      | OI0BQUurVFS |
| test_109  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Pejeh                      | N233eZJZ1bh | Bumbeh MCHP                                      | DwpbWkiqjMy |
| test_110  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Neya                       | GFk45MOxzJJ | Bumbukoro MCHP                                   | MwfWgjMRgId |
| test_111  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kalansogoia                | smoyi1iYNK6 | Bumbuna CHC                                      | Q2USZSJmcNK |
| test_112  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Bargbo                     | zFDYIgyGmXG | Bum Kaku MCHP                                    | EJoI3HArJ2W |
| test_113  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Bumpe Ngao                 | BGGmAwx33dj | Bumpe CHC                                        | E497Rk80ivZ |
| test_114  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Malema                     | GE25DpSrqpB | Bumpeh CHP                                       | wbtk73Zwhj9 |
| test_115  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Nimikoro                   | DmaLM8WYmWv | Bumpeh (Nimikoro) CHC                            | cMFi8lYbXHY |
| test_116  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Galliness Perri            | eNtRuQrrZeo | Bumpeh Perri CHC                                 | d9zRBAoM8OC |
| test_117  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Bumpeh                     | nOYt1LtFSyU | Bumpeh River CHP                                 | mkIugjeYSjE |
| test_118  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kargboro                   | Z9QaI6sxTwW | Bumpetoke CHP                                    | NpHsnQ2L1oY |
| test_119  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Gorama Kono                | GWTIxJO9pRo | Bunabu MCHP                                      | rspjJHg4WY1 |
| test_120  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Lokomasama                 | fRLX08WHWpL | Bundulai MCHP                                    | HVQ6gJE8R24 |
| test_121  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Peje West                  | pmxZm7klXBy | Bunumbu CHP                                      | lsqa3EEGHxv |
| test_122  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Bureh Kasseh Maconteh      | TA7NvKjsn4A | Bureh MCHP                                       | rpAgG9XCWhO |
| test_123  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Burma 2 MCHP                                     | qvHMAxtWWK6 |
| test_124  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Calaba town CHC                                  | KiheEgvUZ0i |
| test_125  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Campbell Town CHP                                | h9q3qixffZT |
| test_126  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Nimikoro                   | DmaLM8WYmWv | Catholic Clinic                                  | PD1fqyvJssC |
| test_127  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Charlotte CHP                                    | uYTq3TEO2a9 |
| test_128  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Kaffu Bullom               | vn9KJsLyP5f | Conakry Dee CHC                                  | U4FzUXMvbI8 |
| test_129  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Nimiyama                   | qgQ49DH9a0v | Condama MCHP                                     | yTMrs5kClCv |
| test_130  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Connaught Hospital                               | ldXIdLNUNEn |
| test_131  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Crossing MCHP                                    | U2QkKSeyL5r |
| test_132  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Diang                      | Lt8U7GVWvSR | Dalakuru CHP                                     | Xytauldn2QJ |
| test_133  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Selenga                    | KctpIIucige | Damballa CHC                                     | wByqtWCCuDJ |
| test_134  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Kpanga Kabonde             | QwMiPiME3bA | Dandabu CHP                                      | RpRJUDOPtt7 |
| test_135  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Sambaia Bendugu            | r1RUyfVBkLp | Dankawalia MCHP                                  | flQBQV8eyHc |
| test_136  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Sengbeh                    | VGAFxBXz16y | Dankawalie MCHP                                  | DErmFP7bri7 |
| test_137  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Jawi                       | KSdZwrU7Hh6 | Daru CHC                                         | m5BX6CvJ6Ex |
| test_138  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Kissi Tongi                | hjpHnHZIniP | Dawa MCHP                                        | JemZqD90S44 |
| test_139  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Deep Eye water MCHP                              | yets9NmUcRS |
| test_140  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Degbuama MCHP                                    | C1tAqIpKB9k |
| test_141  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Kandu Lepiema              | K1r3uF6eZ8n | Deima MCHP                                       | oIgBLlEo6eH |
| test_142  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Sittia                     | g8DdBm7EmUt | Delken MCHP                                      | sSgOnY1Xqd9 |
| test_143  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Kissi Kama                 | JsxnA2IywRo | Dia CHP                                          | qHBTf9A89xW |
| test_144  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Dama                       | myQ4q1W6B4y | Diamei MCHP                                      | M4hyYfnb21I |
| test_145  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Magbema                    | QywkxFudXrC | Dibia MCHP                                       | KbO0JnhiMwl |
| test_146  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Dodo                       | QlCIp2S9NHs | Dodo CHC                                         | jKZ0U8Og5aV |
| test_147  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Luawa                      | cM2BKSrj9F9 | Dodo Kortuma CHP                                 | rwfuVQHnZJ5 |
| test_148  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Folosaba Dembelia          | iEkBZnMDarP | Dogoloya CHP                                     | aIsnJuZbmVA |
| test_149  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Small Bo                   | vzup1f6ynON | Doujou CHP                                       | f90eISKFm7P |
| test_150  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Neya                       | GFk45MOxzJJ | Dulukoro MCHP                                    | RpjUEvgWSNO |
| test_151  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Neya                       | GFk45MOxzJJ | Durukoro MCHP                                    | ADeZNq1pKsu |
| test_152  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | EDC Unit CHP                                     | K3k64jslIlL |
| test_153  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Elshadai Clinic                                  | F7oVR22kQ5J |
| test_154  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Elshadai MCHP                                    | sK498nBOLfQ |
| test_155  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Gbense                     | TQkG0sX9nca | EM&BEE Maternity Home Clinic                     | LaxJ6CD2DHq |
| test_156  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | EPI Headquarter                                  | FO1Tq8vUa62 |
| test_157  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Baoma                      | vWbkYPRmKyS | Faabu CHP                                        | ZpE2POxvl9P |
| test_158  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Wandor                     | X7dWcGerQIm | Faala CHP                                        | hKD6hpZUh9v |
| test_159  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Kasonko                    | vEvs2ckGNQj | Fadugu CHC                                       | K6oyIMh7Lee |
| test_160  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Soro-Gbeima                | d9iMR1MpuIO | Fairo CHC                                        | Gm7YUjhVi9Q |
| test_161  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Sulima (Koinadugu)         | PaqugoqjRIj | Falaba CHC                                       | kuqKh33SPgg |
| test_162  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Galliness Perri            | eNtRuQrrZeo | Falaba CHP                                       | pRg7dkjqNPc |
| test_163  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Fakunya                    | vULnao2hV5v | Falaba MCHP                                      | YTQRSW91PxO |
| test_164  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Family Clinic                                    | fXT1scbEObM |
| test_165  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Soro-Gbeima                | d9iMR1MpuIO | Fanima CHP                                       | WT6JLfyR9lL |
| test_166  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Wonde                      | ARZ4y5i4reU | Fanima (Wonde) MCHP                              | Q23tMsKOoO6 |
| test_167  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Nieni                      | J4GiUImJZoE | Fankoya MCHP                                     | fmLRqcL9sWF |
| test_168  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Fatibra CHP                                      | jfV49JGnYKF |
| test_169  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Gbense                     | TQkG0sX9nca | Fatkom Muchendeh Maternity Clinic                | JLKGG67z7oj |
| test_170  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Tunkia                     | l7pFejMtUoF | Fayeima CHP                                      | Pr2stbkaSX3 |
| test_171  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Lugbu                      | kU8vhUkAGaT | Feiba CHP                                        | r4W2vzlmPhm |
| test_172  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Fengehun MCHP                                    | Ioxjc2KBjWd |
| test_173  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Ribbi                      | gy8rmvYT4cj | Ferry CHP                                        | Eyqyhztf8G1 |
| test_174  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Soa                        | iGHlidSFdpu | Feuror MCHP                                      | rYIkxCJFtTX |
| test_175  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Tambaka                    | Qhmi8IZyPyD | Fintonia CHC                                     | xKaB8tfbTzm |
| test_176  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Nieni                      | J4GiUImJZoE | Firawa CHC                                       | NMcx2jmra3c |
| test_177  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Lei                        | LhaAPLxdSFH | Foakor MCHP                                      | iP4fRh8EHmF |
| test_178  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Malema                     | GE25DpSrqpB | Fobu MCHP                                        | e0RGds86ow6 |
| test_179  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Gbinleh Dixion             | qIRCo0MfuGb | Fodaya MCHP                                      | i7Oh2tlkToJ |
| test_180  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kori                       | nV3OkyzF4US | Fogbo CHP                                        | fGp4OcovQpa |
| test_181  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Fogbo (WAR) MCHP                                 | aVycEyoSBJx |
| test_182  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Lower Bambara              | hdEuw2ugkVF | Foindu (Lower Bamabara) CHC                      | pNPmNeqyrim |
| test_183  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Yoni                       | NNE0YMCDZkO | Foindu MCHP                                      | D3oZZXtXjNk |
| test_184  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Njaluahun                  | ERmBhYkhV6Y | Follah MCHP                                      | t66taqSF1mW |
| test_185  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Galliness Perri            | eNtRuQrrZeo | Fonikor CHP                                      | LUGqPutql0P |
| test_186  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Buya Romende               | Pc3JTyqnsmL | Foredugu MCHP                                    | z1ielwdLtPl |
| test_187  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Diang                      | Lt8U7GVWvSR | Foria CHP                                        | JKhjdiwoQZu |
| test_188  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kunike                     | l0ccv2yzfF3 | Fotaneh Junction MCHP                            | OwhDCucf4Ue |
| test_189  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kunike                     | l0ccv2yzfF3 | Fothaneh Bana MCHP                               | GkHpMSo5K60 |
| test_190  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Valunia                    | npWGUj37qDe | Foya CHP                                         | qqF8jshIs66 |
| test_191  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Dembelia Sinkunia          | Mr4au3jR9bt | Fulamansa MCHP                                   | TbiRD4Bsz4Z |
| test_192  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Bombali Sebora             | KKkLOTpMXGV | Fullah Town (B.Sebora) MCHP                      | aQoqXL4cZaF |
| test_193  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Makari Gbanti              | lY93YpCxJqf | Fullah Town (M.Gbanti) MCHP                      | z9KGMrElTYS |
| test_194  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Fullawahun MCHP                                  | eRg3KZyWUSJ |
| test_195  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Galliness Perri            | eNtRuQrrZeo | Funyehun MCHP                                    | dGZbEZroAWr |
| test_196  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Pejeh                      | N233eZJZ1bh | Futa CHC                                         | uDzWmUDHKeR |
| test_197  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Jong                       | VCtF1DbspR5 | Gambia CHP                                       | UWhv0MQOqoB |
| test_198  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Fakunya                    | vULnao2hV5v | Gandorhun CHC                                    | ZdPkczYqeIY |
| test_199  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Niawa                      | uKC54fzxRzO | Gandorhun CHP                                    | IWb1hstfROc |
| test_200  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Gbane                      | ajILkI0cfxn | Gandorhun (Gbane) CHC                            | ii2KMnWMx2L |
| test_201  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Sulima (Koinadugu)         | PaqugoqjRIj | Ganya MCHP                                       | JttXgTlQAGE |
| test_202  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Dama                       | myQ4q1W6B4y | Gao MCHP                                         | GAvxcmr5jB1 |
| test_203  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Makpele                    | BD9gU0GKlr2 | Gbaa (Makpele) CHP                               | RXeDDKU26rB |
| test_204  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Jaiama Bongor              | daJPPxtIrQn | Gbaama MCHP                                      | ei21lW7hFPX |
| test_205  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Kandu Lepiema              | K1r3uF6eZ8n | Gbado MCHP                                       | kedYKTsv95j |
| test_206  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Makpele                    | BD9gU0GKlr2 | Gbahama (Makpele) MCHP                           | TWH05Rjz6oT |
| test_207  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Peje Bongre                | DxAPPqXvwLy | Gbahama (P. Bongre) CHP                          | YhBJbiD5N1z |
| test_208  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Gbo                        | YmmeuGbqOwR | Gbaiima CHC                                      | jGYT5U5qJP6 |
| test_209  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Gbanti Kamaranka           | e1eIKM1GIF3 | Gbainkfay MCHP                                   | QFcMulIoEii |
| test_210  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Lokomasama                 | fRLX08WHWpL | Gbainty Wallah CHP                               | ifw5aLygJEi |
| test_211  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Luawa                      | cM2BKSrj9F9 | Gbalahun CHP                                     | nDoybVJLD74 |
| test_212  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Gbinleh Dixion             | qIRCo0MfuGb | Gbalamuya MCHP                                   | IPvrsWbm0EM |
| test_213  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Masungbala                 | FlBemv1NfEC | Gbalan Thallan MCHP                              | FsunWIQLXoF |
| test_214  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Soa                        | iGHlidSFdpu | Gbamandu MCHP                                    | AlLmKZIIIT4 |
| test_215  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Nongoba Bullum             | VP397wRvePm | Gbamani CHP                                      | EihevoTWn2i |
| test_216  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Imperi                     | XEyIRFd9pct | Gbamgbaia CHP                                    | K5wBtEzE2qJ |
| test_217  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Imperi                     | XEyIRFd9pct | Gbamgbama CHC                                    | D2rB1GRuh8C |
| test_218  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Kissi Tongi                | hjpHnHZIniP | Gbandiwulo CHP                                   | Vw6CNyFUeh9 |
| test_219  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Kaffu Bullom               | vn9KJsLyP5f | Gbaneh Bana MCHP                                 | w7a4l3XHIgi |
| test_220  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Kaffu Bullom               | vn9KJsLyP5f | Gbaneh Lol MCHP                                  | oxAoPoePpqy |
| test_221  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Gbense                     | TQkG0sX9nca | Gbangadu MCHP                                    | lQIe6vtSe1P |
| test_222  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Bargbo                     | zFDYIgyGmXG | Gbangbalia MCHP                                  | ctMepV9p92I |
| test_223  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Selenga                    | KctpIIucige | Gbangba MCHP                                     | r93q83kZoR9 |
| test_224  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Lower Banta                | W5fN3G6y1VI | Gbangbatoke CHC                                  | ubsjwFFBaJM |
| test_225  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Simbaru                    | A3Fh37HWBWE | Gbangeima MCHP                                   | VH7hLUaypel |
| test_226  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Gbanja Town MCHP                                 | E9oBVjyEaCe |
| test_227  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Gbanti Kamaranka           | e1eIKM1GIF3 | Gbanti CHC                                       | uedNhvYPMNu |
| test_228  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Nongoba Bullum             | VP397wRvePm | Gbap CHC                                         | TEVtOFKcLAP |
| test_229  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Njaluahun                  | ERmBhYkhV6Y | Gbeika MCHP                                      | U8tyWV7WmIB |
| test_230  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Gbendembu Ngowahun         | BXJdOLvUrZB | Gbendembu Wesleyan CHC                           | YAuJ3fyoEuI |
| test_231  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Barri                      | RzKeCma9qb1 | Gbengama MCHP                                    | duINhdt3Yay |
| test_232  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Sengbeh                    | VGAFxBXz16y | Gbenikoro MCHP                                   | y77LiPqLMoq |
| test_233  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Folosaba Dembelia          | iEkBZnMDarP | Gbentu CHP                                       | D7UVRRE9iUC |
| test_234  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Sulima (Koinadugu)         | PaqugoqjRIj | Gberia Timbakor MCHP                             | SCc0TNTDJED |
| test_235  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Mongo                      | OTFepb1k9Db | Gberifeh MCHP                                    | qELjt3LRkSD |
| test_236  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Fiama                      | CF243RPvNY7 | Gbetema MCHP (Fiama)                             | as1dnmlXLzG |
| test_237  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Luawa                      | cM2BKSrj9F9 | Gbeworbu-Gao CHP                                 | L05Bfpu7AcZ |
| test_238  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Dembelia Sinkunia          | Mr4au3jR9bt | Gbindi CHP                                       | LFpl1falVZi |
| test_239  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Dibia                      | ZiOVcrSjSYe | Gbinti CHC                                       | NaVzm59XKGf |
| test_240  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Sanda Magbolonthor         | HWjrSuoNPte | Gbogbodo MCHP                                    | Pw9SihGDbZ5 |
| test_241  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Gbo-Kakajama 1 MCHP                              | TAN6Q7vjvuk |
| test_242  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Gbo-Kakajama 2 MCHP                              | l0WRLZlEgB1 |
| test_243  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Gbo-Lambayama 1 MCHP                             | OzVuFaZgm5U |
| test_244  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Gbo-Lambayama 2 MCHP                             | TYq1YW7qs7k |
| test_245  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Bramaia                    | kbPmt60yi0L | Gbolon MCHP                                      | vwvDblM3MNX |
| test_246  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Dibia                      | ZiOVcrSjSYe | Gbombana MCHP                                    | X3D19LoA2Ij |
| test_247  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Buya Romende               | Pc3JTyqnsmL | Gbomsamba MCHP                                   | cBi3y4lGhDd |
| test_248  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Kpanga Kabonde             | QwMiPiME3bA | Gbondapi CHC                                     | bHcw141PTsE |
| test_249  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Gbongboma MCHP                                   | tGf942oWszb |
| test_250  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Kpanda Kemoh               | aWQTfvgPA5v | Gbongeh CHP                                      | MMrdfNDfBIi |
| test_251  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kaiyamba                   | USQdmvrHh1Q | Gbongeima MCHP                                   | rebbn0ooFSO |
| test_252  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Lei                        | LhaAPLxdSFH | Gbongongor CHP                                   | HOgWkpYH3KB |
| test_253  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Gbanti Kamaranka           | e1eIKM1GIF3 | Gbonkobana CHP                                   | BXJnMD2eJAx |
| test_254  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Maforki                    | JdqfYTIFZXN | Gbonkoh Kareneh MCHP                             | zm9breCeT1m |
| test_255  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Magbema                    | QywkxFudXrC | Gbonkomaria CHP                                  | M3dL6ZAIZ3I |
| test_256  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Libeisaygahun              | hRZOIgQ0O1m | Gbonkonka CHP                                    | v2vi8UaIYlo |
| test_257  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Gbotima MCHP                                     | i7qaYfmGVDr |
| test_258  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Wonde                      | ARZ4y5i4reU | Gboyama CHC                                      | k1Y0oNqPlmy |
| test_259  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kori                       | nV3OkyzF4US | Gbuihun MCHP                                     | DA2BEQMhv9B |
| test_260  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Dama                       | myQ4q1W6B4y | Geima CHP                                        | ZzdTFqWrlDa |
| test_261  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Small Bo                   | vzup1f6ynON | Gelehun MCHP                                     | FZxJ0KST9jn |
| test_262  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Wandor                     | X7dWcGerQIm | Gendema MCHP                                     | W3t0pSZLtrC |
| test_263  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Sowa                       | NqWaKXcg01b | Geoma Jagor CHC                                  | FbD5Z8z22Yb |
| test_264  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | George Brook Health Centre                       | U514Dz4v9pv |
| test_265  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Baoma                      | vWbkYPRmKyS | Gerehun CHC                                      | TSyzvBiovKh |
| test_266  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Kpanga Kabonde             | QwMiPiME3bA | Gibena MCHP                                      | ywNG86IY4Ve |
| test_267  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Luawa                      | cM2BKSrj9F9 | Giema (Luawa) MCHP                               | vPKxHJ1og0r |
| test_268  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Ginger Hall Health Centre                        | m0XorV4WWg0 |
| test_269  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Makpele                    | BD9gU0GKlr2 | Gissiwolo MCHP                                   | AekX8HBymng |
| test_270  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Gloucester CHP                                   | HTDuY3uxj6u |
| test_271  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Goderich Health Centre                           | dQggcljEImF |
| test_272  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Goderich MI Room                                 | HAqUY00X9N5 |
| test_273  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Gods Favour health Center                        | RaQGHRti7JM |
| test_274  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Makpele                    | BD9gU0GKlr2 | Gofor CHP                                        | lf7FRlrchg3 |
| test_275  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Baoma                      | vWbkYPRmKyS | Golu MCHP                                        | azRICFoILuh |
| test_276  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kamaje                     | LsYpCyYxSLY | Gondama (Kamaje) CHP                             | E4jn4059Y1x |
| test_277  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Upper Banta                | DBs6e2Oxaj1 | Gondama MCHP                                     | fRV3Fhz1IP8 |
| test_278  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Nimikoro                   | DmaLM8WYmWv | Gondama (Nimikoro) MCHP                          | ObJjzhhBkfy |
| test_279  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Tikonko                    | sxRd2XOzFbz | Gondama (Tikonko) CHC                            | jhtj3eQa1pM |
| test_280  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Tunkia                     | l7pFejMtUoF | Gorahun CHC                                      | QpRIPul20Sb |
| test_281  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | BMC                        | ENHOJz3UH5L | Govt. Hosp. Bonthe                               | NnQpISrLYWZ |
| test_282  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Maforki                    | JdqfYTIFZXN | Govt. Hospital                                   | ZvX8lXd1tYs |
| test_283  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kaiyamba                   | USQdmvrHh1Q | Govt. Hospital Moyamba                           | U8uqyDAu5bH |
| test_284  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Govt. Hosp. Kenema                               | djMCTPYvltl |
| test_285  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Bombali Sebora             | KKkLOTpMXGV | Govt. Hosp. Makeni                               | GQcsUZf81vP |
| test_286  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Kpanga Kabonde             | QwMiPiME3bA | Govt. Hosp. Pujehun                              | STv4PP4Hiyl |
| test_287  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Luawa                      | cM2BKSrj9F9 | Govt. Medical Hospital                           | xmZNDeO0qCR |
| test_288  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Grafton MCHP                                     | vAdMjyOspGL |
| test_289  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Grassfield CHC                                   | lL2LBkhlsmV |
| test_290  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Grey Bush CHC                                    | JZraNIfZ5JM |
| test_291  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Tikonko                    | sxRd2XOzFbz | Griema MCHP                                      | KR0jLuFOB3d |
| test_292  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Valunia                    | npWGUj37qDe | Grima CHP                                        | NLN0MvWv9tl |
| test_293  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Peje Bongre                | DxAPPqXvwLy | Grima Jou MCHP                                   | xATvj8pdYoT |
| test_294  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Dodo                       | QlCIp2S9NHs | Guala MCHP                                       | ARAZtL7Bdpy |
| test_295  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Folosaba Dembelia          | iEkBZnMDarP | Hamdalai MCHP                                    | HDOnfLXKkYs |
| test_296  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Hamilton MCHP                                    | oolcy5HBlMy |
| test_297  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Gbense                     | TQkG0sX9nca | Handicap Clinic                                  | DSBXsRQSXUW |
| test_298  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Hangha CHC                                       | g10jm7jPdzf |
| test_299  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Harvest Time MCHP                                | VrDA0Hn4Xc6 |
| test_300  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Hastings Health Centre                           | zQpYVEyAM2t |
| test_301  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Malegohun                  | x4HaBHHwBML | Helegombu MCHP                                   | DxguTiXvIJu |
| test_302  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Wara Wara Yagala           | EZPwuUTeIIG | Heremakono MCHP                                  | UCwtaCrNUls |
| test_303  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Hill Station MCHP                                | AKvgfYx5WZq |
| test_304  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Lugbu                      | kU8vhUkAGaT | Hima MCHP                                        | l2kZRcJjomr |
| test_305  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Yoni                       | NNE0YMCDZkO | Hinistas CHC                                     | g5lonXJ9ndA |
| test_306  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Holy Mary Clinic                                 | LV2b3vaLRl1 |
| test_307  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Holy Mary Hospital                               | jk1TtiBM5hz |
| test_308  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Magbaimba Ndowahun         | eV4cuxniZgP | Hunduwa CHP                                      | J1x66stNjk2 |
| test_309  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Iscon CHP                                        | wjFsUXI1MlO |
| test_310  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Nimiyama                   | qgQ49DH9a0v | Jaiama Sewafe CHC                                | W7ekX3gi0ut |
| test_311  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Imperi                     | XEyIRFd9pct | Jangalor MCHP                                    | qzm5ww3U0vz |
| test_312  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Tunkia                     | l7pFejMtUoF | Jao MCHP                                         | t7bcrWLjL1m |
| test_313  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Baoma                      | vWbkYPRmKyS | Jembe CHC                                        | Umh4HKqqFp6 |
| test_314  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Soro-Gbeima                | d9iMR1MpuIO | Jendema CHC                                      | QzPf0qKBU4n |
| test_315  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Upper Bambara              | LfTkc0S4b5k | Jenneh MCHP                                      | ndan8zClk4E |
| test_316  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Jenner Wright Clinic                             | cZtKKa9eJZ3 |
| test_317  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Bargbo                     | zFDYIgyGmXG | Jimmi CHC                                        | vELbGdEphPd |
| test_318  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | John Thorpe MCHP                                 | DplgrYeRIZ1 |
| test_319  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Malema                     | GE25DpSrqpB | Jojoima CHC                                      | DvzKyuC0G4w |
| test_320  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Peje West                  | pmxZm7klXBy | Jokibu MCHP                                      | f7yRhIeFn1k |
| test_321  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Jormu CHP                                        | m3QGt8fY3L0 |
| test_322  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Baoma                      | vWbkYPRmKyS | Jormu MCHP                                       | RzgSFJ9E46G |
| test_323  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Gaura                      | eROJsBwxQHt | Joru CHC                                         | cw0Wm1QTHRq |
| test_324  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Juba M I Room                                    | PysJIi3VIol |
| test_325  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Koya (kenema)              | EYt6ThQDagn | Jui CHP                                          | VH8vOjm0l8w |
| test_326  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kori                       | nV3OkyzF4US | Juma MCHP                                        | V6QWyB0KqvP |
| test_327  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Jong                       | VCtF1DbspR5 | Junctionla MCHP                                  | QCnJDmNjQy0 |
| test_328  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Dasse                      | RndxKqQGzUl | Kabaima MCHP                                     | EQUwHqZOb5L |
| test_329  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Jong                       | VCtF1DbspR5 | Kabati CHP                                       | Xk2fvz4aTBU |
| test_330  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Sella Limba                | j43EZb15rjI | Kabba Ferry MCHP                                 | TWMVxJANJeU |
| test_331  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Safroko Limba              | XG8HGAbrbbL | Kabombeh MCHP                                    | CbIWQQoWcLc |
| test_332  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Safroko Limba              | XG8HGAbrbbL | Kabonka MCHP                                     | wfGRNqXqf92 |
| test_333  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Biriwa                     | fwH9ipvXde9 | Kagbaneh CHP                                     | duGLGssecoD |
| test_334  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Biriwa                     | fwH9ipvXde9 | Kagbankona MCHP                                  | OjTS752GbZE |
| test_335  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Bureh Kasseh Maconteh      | TA7NvKjsn4A | Kagbanthama CHP                                  | ZZmMpGIE7pD |
| test_336  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Kasonko                    | vEvs2ckGNQj | Kagbasia MCHP                                    | T3iVyvrCpZ0 |
| test_337  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Magbaimba Ndowahun         | eV4cuxniZgP | Kagbere CHC                                      | TjZwphhxCuV |
| test_338  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Safroko Limba              | XG8HGAbrbbL | Kagbo MCHP                                       | OTlKtnhvEm1 |
| test_339  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Sella Limba                | j43EZb15rjI | Kagboray MCHP                                    | Sglj9VCoQmc |
| test_340  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Lokomasama                 | fRLX08WHWpL | Kagbulor CHP                                     | n3MRjKtwr3O |
| test_341  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Libeisaygahun              | hRZOIgQ0O1m | Kaimunday CHP                                    | hpXXBtRXXSd |
| test_342  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Soa                        | iGHlidSFdpu | Kainkordu CHC                                    | KKoPh1lDd9j |
| test_343  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Wara Wara Bafodia          | XrF5AvaGcuw | Kakoya MCHP                                      | NJolnlvYgLr |
| test_344  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Mambolo                    | xGMGhjA3y6J | Kalainkay MCHP                                   | OGaAWQD6SYs |
| test_345  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Bureh Kasseh Maconteh      | TA7NvKjsn4A | Kalangba BKM MCHP                                | nYiOoF2nXIr |
| test_346  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Sanda Magbolonthor         | HWjrSuoNPte | Kalangba CHC                                     | aSxNNRxPuBP |
| test_347  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Lokomasama                 | fRLX08WHWpL | Kalangba MCHP                                    | UqXSUMp19FB |
| test_348  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Sulima (Koinadugu)         | PaqugoqjRIj | Kaliyereh MCHP                                   | oDAoqMWcsJQ |
| test_349  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Biriwa                     | fwH9ipvXde9 | Kamabai CHC                                      | mt47bcb0Rcj |
| test_350  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Sella Limba                | j43EZb15rjI | Kamabaio MCHP                                    | OwHjzJEVEUN |
| test_351  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Sengbeh                    | VGAFxBXz16y | Kamadu Sokuralla MCHP                            | iqd7BiRHor0 |
| test_352  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Tonko Limba                | y5X4mP5XylL | Kamagbewu MCHP                                   | b7YDjQ6DBzt |
| test_353  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Sella Limba                | j43EZb15rjI | Kamakwie MCHP                                    | KnU2XHRvyiX |
| test_354  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Sanda Loko                 | WXnNDWTiE9r | Kamalo CHC                                       | HNv1aLPdMYb |
| test_355  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Gbanti Kamaranka           | e1eIKM1GIF3 | Kamaranka CHC                                    | bSj2UnYhTFb |
| test_356  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Diang                      | Lt8U7GVWvSR | kamaron CHP                                      | F9zWBqG5Pmi |
| test_357  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Mongo                      | OTFepb1k9Db | kamaron MCHP                                     | eCfxBe1lnxb |
| test_358  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kalansogoia                | smoyi1iYNK6 | Kamasaypana MCHP                                 | e4P2zTzM7gQ |
| test_359  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Biriwa                     | fwH9ipvXde9 | Kamasikie MCHP                                   | ZxuSbAmsLCn |
| test_360  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Buya Romende               | Pc3JTyqnsmL | Kamasondo CHC                                    | zuXW98AEbE7 |
| test_361  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Tonko Limba                | y5X4mP5XylL | Kamassasa CHC                                    | inpc5QsFRTm |
| test_362  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Sella Limba                | j43EZb15rjI | Kamawornie CHP                                   | wO4z5Aqo0hf |
| test_363  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Jawi                       | KSdZwrU7Hh6 | Kambama CHP                                      | mYMJHVqdBKt |
| test_364  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Folosaba Dembelia          | iEkBZnMDarP | kamba mamudia                                    | zO5hgxxfU4T |
| test_365  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Folosaba Dembelia          | iEkBZnMDarP | Kamba Mamudia MCHP                               | DF76ZjQtFSg |
| test_366  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Magbema                    | QywkxFudXrC | Kamba MCHP                                       | cJ7omISg7gG |
| test_367  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Wonde                      | ARZ4y5i4reU | Kambawama MCHP                                   | GjWQK6UA4FO |
| test_368  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Gbanti Kamaranka           | e1eIKM1GIF3 | Kambia CHP                                       | UUgajyaViT7 |
| test_369  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Magbema                    | QywkxFudXrC | Kambia GH                                        | N7mHLD3ljYc |
| test_370  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Tainkatopa Makama Safrokoh | PrJQHI6q7w2 | Kambia Makama CHP                                | kO9xe2HCovK |
| test_371  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Lower Bambara              | hdEuw2ugkVF | Kamboma MCHP                                     | PyLBGdbzdEo |
| test_372  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Mafindor                   | EjnIQNVAXGp | Kamiendor MCHP                                   | hHKKi9WNoBG |
| test_373  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Gbane                      | ajILkI0cfxn | Kanekor MCHP                                     | tXL6C7P0ObJ |
| test_374  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kaiyamba                   | USQdmvrHh1Q | Kangahun CHC                                     | wUmVUKhnPuy |
| test_375  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Lower Banta                | W5fN3G6y1VI | Kanga (LB) MCHP                                  | AFi1GjbeejL |
| test_376  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Kissi Teng                 | j0Mtr3xTMjM | Kangama CHP                                      | PSjKMcPGUvA |
| test_377  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Gorama Kono                | GWTIxJO9pRo | Kangama (Kangama) CHP                            | pYr0Kcy93M2 |
| test_378  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Sogbini                    | cgOy0hRMGu9 | Kanga MCHP                                       | IpA5FViU8tk |
| test_379  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Masungbala                 | FlBemv1NfEC | Kania (Masungbala) MCHP                          | RNGpZqutw3Y |
| test_380  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Diang                      | Lt8U7GVWvSR | Kania MCHP                                       | AGrsLyKWrVX |
| test_381  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Biriwa                     | fwH9ipvXde9 | Kanikay MCHP                                     | nDwbwJZQUYU |
| test_382  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Bumpe Ngao                 | BGGmAwx33dj | Kaniya MCHP                                      | CTOMXJg41hz |
| test_383  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Bramaia                    | kbPmt60yi0L | Kanku Bramaia MCHP                               | u3rHGQGLLP7 |
| test_384  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Sanda Magbolonthor         | HWjrSuoNPte | Kantia CHP                                       | KGN2jvZ0GJy |
| test_385  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Safroko Limba              | XG8HGAbrbbL | Kapethe MCHP                                     | GhDwjKv07iC |
| test_386  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Sella Limba                | j43EZb15rjI | Kaponkie MCHP                                    | Crgx572DnXR |
| test_387  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Dibia                      | ZiOVcrSjSYe | Kareneh MCHP                                     | YBZcWphXQ99 |
| test_388  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Biriwa                     | fwH9ipvXde9 | Karina MCHP                                      | ObV5AR1NECl |
| test_389  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Lugbu                      | kU8vhUkAGaT | Karleh MCHP                                      | AlG0apJE5cm |
| test_390  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Ya Kpukumu Krim            | pk7bUK5c1Uf | Karlu CHC                                        | K00jR5dmoFZ |
| test_391  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Kasonko                    | vEvs2ckGNQj | Kasanikoro MCHP                                  | jj1MhWhHqta |
| test_392  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Kaffu Bullom               | vn9KJsLyP5f | Kasongha MCHP                                    | OqBiNJjKQAu |
| test_393  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Tonko Limba                | y5X4mP5XylL | Kasoria MCHP                                     | wP1zsnNxbSE |
| test_394  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Tikonko                    | sxRd2XOzFbz | Kassama MCHP                                     | yh1PrRTboyg |
| test_395  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Bargbo                     | zFDYIgyGmXG | Kasse MCHP                                       | cJkZLwhL8RP |
| test_396  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Paki Masabong              | L8iA6eLwKNb | Kathanta Bana MCHP                               | pmzk0ho80aA |
| test_397  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Sella Limba                | j43EZb15rjI | Kathanta Yimbor CHC                              | NjyJYiIuKIG |
| test_398  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Tonko Limba                | y5X4mP5XylL | Katherie MCHP                                    | MPUiud3BYRq |
| test_399  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kalansogoia                | smoyi1iYNK6 | Kathombo MCHP                                    | yEU926iVAJJ |
| test_400  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Masimera                   | EfWCa0Cc8WW | Katick MCHP                                      | Zp2Yi4j2AAH |
| test_401  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Lokomasama                 | fRLX08WHWpL | Katongha MCHP                                    | BDBXHeASwHl |
| test_402  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Bagruwa                    | jPidqyo7cpF | Kawaya MCHP                                      | qMbxFg9McOF |
| test_403  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Bureh Kasseh Maconteh      | TA7NvKjsn4A | Kawengha MCHP                                    | rwgK8TkRwHl |
| test_404  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Masungbala                 | FlBemv1NfEC | Kawula CHP                                       | etrIik4vsBQ |
| test_405  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Safroko Limba              | XG8HGAbrbbL | Kayasie MCHP                                     | dczh6Jfd4no |
| test_406  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Sandor                     | g5ptsn0SFX8 | Kayima CHC                                       | k8ZPul89UDm |
| test_407  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Biriwa                     | fwH9ipvXde9 | Kayongoro MCHP                                   | tEgxbwwrwUd |
| test_408  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kalansogoia                | smoyi1iYNK6 | Kemedugu MCHP                                    | QMnoFLTLpkY |
| test_409  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Dasse                      | RndxKqQGzUl | Kenema Gbandoma MCHP                             | s7SLtx8wmRA |
| test_410  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Tankoro                    | M2qEv692lS6 | Kensay MCHP                                      | UjusePB4jmP |
| test_411  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Kent CHP                                         | lELJZCBxz7H |
| test_412  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Makari Gbanti              | lY93YpCxJqf | Kerefay Loko MCHP                                | GhXvo3BpCvo |
| test_413  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Sambaia Bendugu            | r1RUyfVBkLp | Kholifaga MCHP                                   | lCEeiuv4NaB |
| test_414  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Malal Mara                 | EVkm2xYcf6Z | Kiampkakolo MCHP                                 | Q8oWscr9rlQ |
| test_415  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Baoma                      | vWbkYPRmKyS | Kigbai MCHP                                      | egv5Es0QlQP |
| test_416  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Kindoyal Hospital                                | uROAmk9ymNE |
| test_417  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | KingHarman Rd. Hospital                          | gei3Sqw8do7 |
| test_418  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Kingtom Police Hospital (MI Room)                | lekPjgUm0o2 |
| test_419  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Kissy Health Centre                              | FclfbEFMcf3 |
| test_420  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Koya                       | pRHGAROvuyI | Kissy Koya MCHP                                  | XLiqwElsFHO |
| test_421  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Kissy Town CHP                                   | lmNWdmeOYmV |
| test_422  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Gbense                     | TQkG0sX9nca | Koakor MCHP                                      | EQc3n1juPFn |
| test_423  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Tankoro                    | M2qEv692lS6 | Koakoyima CHC                                    | SnCrOCRrxGX |
| test_424  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Gbane Kandor               | Zoy23SSHCPs | Koardu MCHP                                      | PwoQgMJNWbR |
| test_425  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Sandor                     | g5ptsn0SFX8 | Kochero MCHP                                     | VF7LfO19vxS |
| test_426  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Gbense                     | TQkG0sX9nca | Koeyor MCHP                                      | zsqxu7ZZRpO |
| test_427  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Gbense                     | TQkG0sX9nca | Koidu Govt. Hospital                             | OzjRQLn3G24 |
| test_428  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Gbense                     | TQkG0sX9nca | Koidu Under Five Clinic                          | Ls2ESQONh9S |
| test_429  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Soro-Gbeima                | d9iMR1MpuIO | Koije MCHP                                       | vj0HUVazItT |
| test_430  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Sengbeh                    | VGAFxBXz16y | Koinadugu II CHP                                 | hMBotMwWnU1 |
| test_431  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Kissi Teng                 | j0Mtr3xTMjM | Koindu CHC                                       | DMxw0SASFih |
| test_432  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Mafindor                   | EjnIQNVAXGp | Koindu-kuntey MCHP                               | GM9ddjXIO5b |
| test_433  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Sulima (Koinadugu)         | PaqugoqjRIj | Koindukura MCHP                                  | bqSIIRuZ1qj |
| test_434  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Gaura                      | eROJsBwxQHt | Kokoru CHP                                       | F2TAF765q1b |
| test_435  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Makari Gbanti              | lY93YpCxJqf | Kolisokor MCHP                                   | m7fBMpmVpSM |
| test_436  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Lei                        | LhaAPLxdSFH | Komba Yendeh CHP                                 | T62lSjsZe9n |
| test_437  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Mongo                      | OTFepb1k9Db | Kombilie MCHP                                    | HC2NlwpoXfb |
| test_438  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Komboya                    | JdhagCUEMbj | Komboya Gbauja MCHP                              | JiEz2VDLwHY |
| test_439  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Komendeh (Nongowa) MCHP                          | NqwvaQC1ni4 |
| test_440  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kaiyamba                   | USQdmvrHh1Q | Komende (Kaiyamba) MCHP                          | Zr7pgiajIo9 |
| test_441  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Lower Bambara              | hdEuw2ugkVF | Komende Luyaima MCHP                             | Zq9ATbrmKIa |
| test_442  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Sanda Magbolonthor         | HWjrSuoNPte | Komneh CHP                                       | w0QDch3dyPH |
| test_443  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Koya                       | pRHGAROvuyI | Komrabai Ngolla MCHP                             | Uv15pOAstzX |
| test_444  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kholifa Mabang             | fwxkctgmffZ | Komrabai Station MCHP                            | cUltUneFSan |
| test_445  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Konabu MCHP                                      | mhJQYk2Jwym |
| test_446  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kori                       | nV3OkyzF4US | Konda CHP                                        | jkPHBqdn9SA |
| test_447  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Diang                      | Lt8U7GVWvSR | Kondembaia CHC                                   | p310xqwAJge |
| test_448  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Toli                       | FRxcUEwktoV | Kondewakoro CHP                                  | ZSBnWFBpPPJ |
| test_449  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Sengbeh                    | VGAFxBXz16y | Kondeya MCHP                                     | OynYyQiFu82 |
| test_450  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Sandor                     | g5ptsn0SFX8 | Kondeya (Sandor) MCHP                            | e5sGsWLEn3k |
| test_451  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Bargbe                     | dGheVylzol6 | Kondiama MCHP                                    | kRWIof0qPJj |
| test_452  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Lei                        | LhaAPLxdSFH | Kongoifeh MCHP                                   | qwmh84DV65K |
| test_453  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Barri                      | RzKeCma9qb1 | Konia MCHP                                       | yJ1xkKha5oE |
| test_454  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Luawa                      | cM2BKSrj9F9 | Konjo CHP                                        | mokUyyg3olJ |
| test_455  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Dama                       | myQ4q1W6B4y | Konjo (Dama) CHP                                 | aXsLBCzwYWW |
| test_456  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Lower Bambara              | hdEuw2ugkVF | Konjo MCHP                                       | d7hw1ababST |
| test_457  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Penguia                    | bQiBfA2j5cw | Kono Bendu CHP                                   | SVEfwJ0BGeD |
| test_458  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Bramaia                    | kbPmt60yi0L | Konta CHP                                        | AQQCxQqDxLe |
| test_459  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Gorama Mende               | KXSqt7jv6DU | Konta (Gorama M) CHP                             | UAtEKSd5QTf |
| test_460  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Masimera                   | EfWCa0Cc8WW | Konta-Line MCHP                                  | nornKUJmQqn |
| test_461  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Lokomasama                 | fRLX08WHWpL | Konta Wallah MCHP                                | TkhwySsXC5V |
| test_462  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Niawa Lenga                | I4jWcnFmgEC | Korbu MCHP                                       | m73lWmo5BDG |
| test_463  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Kordebotehun MCHP                                | lwHs72tP6Kh |
| test_464  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kaiyamba                   | USQdmvrHh1Q | Korgbotuma MCHP                                  | hCm2Nh7C8BW |
| test_465  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Jaiama Bongor              | daJPPxtIrQn | Koribondo CHC                                    | mwN7QuEfT8m |
| test_466  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Jong                       | VCtF1DbspR5 | Kormende MCHP                                    | S9QckzKX6Lg |
| test_467  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Lower Bambara              | hdEuw2ugkVF | Kornia Kpindema CHP                              | MrME31scKA1 |
| test_468  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Dama                       | myQ4q1W6B4y | Kornia MCHP                                      | CSDGDOa7wHd |
| test_469  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Gbendembu Ngowahun         | BXJdOLvUrZB | Kortohun CHP                                     | z6v73gowbuM |
| test_470  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Jawi                       | KSdZwrU7Hh6 | Kortuma MCHP                                     | cXOR7vSMBKO |
| test_471  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Galliness Perri            | eNtRuQrrZeo | Kowama MCHP                                      | jr5hIZcJBXB |
| test_472  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Koyagbema MCHP                                   | Kmu7ox2MiiU |
| test_473  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Samu                       | r06ohri9wA9 | Koya MCHP                                        | brnL0W3Fbsj |
| test_474  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Dama                       | myQ4q1W6B4y | Kpandebu CHC                                     | TljiT6C5D0J |
| test_475  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Luawa                      | cM2BKSrj9F9 | Kpandebu CHP                                     | nE01sGNCY5P |
| test_476  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Lower Bambara              | hdEuw2ugkVF | Kpandebu MCHP                                    | PFZbQjwty2n |
| test_477  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Kpayama 1 MCHP                                   | So2b8zJfcMa |
| test_478  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Kpayama 2 MCHP                                   | geVF87N7qTw |
| test_479  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Bumpe Ngao                 | BGGmAwx33dj | Kpetema CHP                                      | RTixJpRqS4C |
| test_480  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Toli                       | FRxcUEwktoV | Kpetema CHP (Toli)                               | GIRLSZ1tB00 |
| test_481  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Lower Bambara              | hdEuw2ugkVF | Kpetema (Lower Bambara) CHP                      | U02o1QAm6cC |
| test_482  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Kpetema MCHP                                     | kDxbU1uSBFh |
| test_483  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Lugbu                      | kU8vhUkAGaT | Kpetewoma CHP                                    | mGmu0GJ5neg |
| test_484  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Valunia                    | npWGUj37qDe | Kpewama MCHP                                     | DcmSvQd5N8c |
| test_485  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Kpolies Clinic                                   | bM4Ky73uMao |
| test_486  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Galliness Perri            | eNtRuQrrZeo | Kpowubu MCHP                                     | QkczRcSeNck |
| test_487  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Valunia                    | npWGUj37qDe | Kpuabu MCHP                                      | S7KwVLbFlss |
| test_488  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Baoma                      | vWbkYPRmKyS | Kpumbu MCHP                                      | pMEnu7BjqMz |
| test_489  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Kroo Bay CHC                                     | sM0Us0NkSez |
| test_490  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Bramaia                    | kbPmt60yi0L | Kukuna CHP                                       | M9JyYBZTqR7 |
| test_491  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Nieni                      | J4GiUImJZoE | Kumala CHP                                       | CvYsZipdHMN |
| test_492  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Yoni                       | NNE0YMCDZkO | Kumrabai Yoni MCHP                               | bJ0VSATHwO2 |
| test_493  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Dodo                       | QlCIp2S9NHs | Kundorma CHP                                     | S2NaydvPENH |
| test_494  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Lei                        | LhaAPLxdSFH | Kundundu MCHP                                    | jYPY8mT8gn6 |
| test_495  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Makari Gbanti              | lY93YpCxJqf | Kunsho CHP                                       | tdhB1JXYBx2 |
| test_496  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Kuntorloh CHP                                    | bKiJzk8ZZbS |
| test_497  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Sambaia Bendugu            | r1RUyfVBkLp | Kunya MCHP                                       | kIbcKauMdlW |
| test_498  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Koya                       | pRHGAROvuyI | Kuranko MCHP                                     | WUQrS4Yqmoy |
| test_499  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Neya                       | GFk45MOxzJJ | Kurubonla CHC                                    | Ep5iWL1UKvF |
| test_500  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Yawei                      | byp7w6Xd9Df | Kwellu Ngieya CHP                                | SzEmaH63Qe8 |
| test_501  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Samu                       | r06ohri9wA9 | Kychom CHC                                       | PcADvhvcaI2 |
| test_502  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Sanda Loko                 | WXnNDWTiE9r | Laiya CHP                                        | yg7uxUol97F |
| test_503  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Lakka Hospital                                   | K0d08d3sUOv |
| test_504  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Lakka/Ogoo Farm CHC                              | NRPCjDljVtu |
| test_505  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Penguia                    | bQiBfA2j5cw | Laleihun CHP                                     | SFQblJrFblm |
| test_506  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Njaluahun                  | ERmBhYkhV6Y | Laleihun Kovoma CHC                              | N3tpEjZcPm9 |
| test_507  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Lango Town MCHP                                  | xEip3dtU8bp |
| test_508  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Largo CHC                                        | iOA3z6Y3cq5 |
| test_509  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kongbora                   | Jiyc4ekaMMh | Lawana (Kongbora) MCHP                           | aXnGiQGhOAj |
| test_510  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Kpanda Kemoh               | aWQTfvgPA5v | Lawana MCHP                                      | X7ZVgRPt31q |
| test_511  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Leicester (RWA) CHP                              | KxtLZtVmpur |
| test_512  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Diang                      | Lt8U7GVWvSR | Lengekoro MCHP                                   | rs87nYgwbKv |
| test_513  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Makari Gbanti              | lY93YpCxJqf | Leprosy & TB Hospital                            | cdmkMyYv04T |
| test_514  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Mandu                      | yu4N82FFeLm | Levuma CHP                                       | Bf9R1R91mw4 |
| test_515  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kaiyamba                   | USQdmvrHh1Q | Levuma Kai MCHP                                  | BgOhMcH9bxq |
| test_516  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Kandu Lepiema              | K1r3uF6eZ8n | Levuma (Kandu Lep) CHC                           | YvwYw7GilkP |
| test_517  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kongbora                   | Jiyc4ekaMMh | Levuma Nyomeh CHP                                | BqRElDluXGa |
| test_518  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Lion for Lion Clinic                             | cZxP4NE5O9z |
| test_519  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Kpaka                      | zSNUViKdkk3 | Liya MCHP                                        | tBRDdxfKbMx |
| test_520  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Small Bo                   | vzup1f6ynON | London (Blama) MCHP                              | hIpcmjLrDDW |
| test_521  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Looking Town MCHP                                | Z7UAnjpK74g |
| test_522  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Dama                       | myQ4q1W6B4y | Loppa CHP                                        | IW3guWF3uvF |
| test_523  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Bombali Sebora             | KKkLOTpMXGV | Loreto Clinic                                    | cgqkFdShPzg |
| test_524  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Lower Bambara              | hdEuw2ugkVF | Lowoma CHC                                       | IlMQTFvcq9r |
| test_525  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Jaiama Bongor              | daJPPxtIrQn | Lowoma MCHP                                      | rozv5QUSE7a |
| test_526  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Lumley Hospital                                  | PqlNXedmh7u |
| test_527  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Lumpa CHP                                        | m8qnxndRDR6 |
| test_528  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Kaffu Bullom               | vn9KJsLyP5f | Lungi Govt. Hospital, Port Loko                  | gsypzntLahf |
| test_529  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Kaffu Bullom               | vn9KJsLyP5f | Lungi Town MCHP                                  | ntQSuMb7J21 |
| test_530  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Kaffu Bullom               | vn9KJsLyP5f | Lungi UFC                                        | xuk02oLk12O |
| test_531  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Marampa                    | RWvG1aFrr0r | Lunsar CHC                                       | q56204kKXgZ |
| test_532  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Lyn Maternity MCHP                               | k6DIO9LIEk9 |
| test_533  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Bum                        | iUauWFeH8Qp | Maami CHP                                        | voQXVNftP4W |
| test_534  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kholifa Rowalla            | PQZJPIpTepd | Mabai (Kholifa Rowalla) MCHP                     | q5kAX5MyPB6 |
| test_535  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kholifa Mabang             | fwxkctgmffZ | Mabai MCHP                                       | xRsoZIRmnt4 |
| test_536  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Bureh Kasseh Maconteh      | TA7NvKjsn4A | Mabain MCHP                                      | GtJoxCaM2zg |
| test_537  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kholifa Mabang             | fwxkctgmffZ | Mabang CHC                                       | Ahh47q8AkId |
| test_538  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Ribbi                      | gy8rmvYT4cj | Mabang MCHP                                      | fCFdj2T0Bq1 |
| test_539  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Makari Gbanti              | lY93YpCxJqf | Mabayo MCHP                                      | Xzxy8NuVsLp |
| test_540  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Mabella MCHP                                     | MiYhwDprCCA |
| test_541  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Makari Gbanti              | lY93YpCxJqf | Mabenteh Community Hospital                      | taKiTcaf05H |
| test_542  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kunike                     | l0ccv2yzfF3 | Mabineh MCHP                                     | mc3jvzpzSi4 |
| test_543  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Bombali Sebora             | KKkLOTpMXGV | Mabolleh MCHP                                    | PybxeRWVSrI |
| test_544  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kholifa Rowalla            | PQZJPIpTepd | Mabom CHP                                        | lBob31rp6l4 |
| test_545  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Maforki                    | JdqfYTIFZXN | Maboni MCHP                                      | r0TCGeLkQKI |
| test_546  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Safroko Limba              | XG8HGAbrbbL | Mabonkanie MCHP                                  | CEoD9uQVIZB |
| test_547  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kafe Simira                | BmYyh9bZ0sr | Mabontor CHP                                     | jVDUkOBCjDy |
| test_548  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Koya                       | pRHGAROvuyI | Mabora MCHP                                      | fmkqsEx6MRo |
| test_549  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kholifa Rowalla            | PQZJPIpTepd | Maborie MCHP                                     | ApLCxUmnT6q |
| test_550  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Dibia                      | ZiOVcrSjSYe | Maborognor MCHP                                  | vxExu6yOYLg |
| test_551  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Sanda Tendaren             | UhHipWG7J8b | Mabunduka CHC                                    | TmCsvdJLHoX |
| test_552  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Mabureh CHP                                      | b09gf2vvZDb |
| test_553  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Buya Romende               | Pc3JTyqnsmL | Mabureh Mende MCHP                               | bkMlhoccaVw |
| test_554  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Macauley Satellite Hospital                      | rIgJX4N0DGZ |
| test_555  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | MacDonald MCHP                                   | FupvWBUFXr7 |
| test_556  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Mambolo                    | xGMGhjA3y6J | Macoth MCHP                                      | U0KpeSx4UIB |
| test_557  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Yoni                       | NNE0YMCDZkO | Macrogba MCHP                                    | Xnif5imKLlT |
| test_558  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | MadaKa MCHP                                      | b1F5bfb7WUR |
| test_559  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Bum                        | iUauWFeH8Qp | Madina (BUM) CHC                                 | gE3gEGZbQMi |
| test_560  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Sanda Loko                 | WXnNDWTiE9r | Madina Fullah CHP                                | pJj2r2HElLE |
| test_561  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Bum                        | iUauWFeH8Qp | Madina Gbonkobor MCHP                            | SZrG4yHGV4x |
| test_562  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Gbendembu Ngowahun         | BXJdOLvUrZB | Madina Loko CHP                                  | I48Qu6R0sGm |
| test_563  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Malema                     | GE25DpSrqpB | Madina (Malema) MCHP                             | SFQigiC2ISS |
| test_564  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Buya Romende               | Pc3JTyqnsmL | Madina MCHP                                      | kFScvrF3wPo |
| test_565  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Tonko Limba                | y5X4mP5XylL | Madina Wesleyan Mission                          | ALnjmvcRSxU |
| test_566  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Kissi Tongi                | hjpHnHZIniP | Madopolahun MCHP                                 | QBRQnWPRO3V |
| test_567  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Gbinleh Dixion             | qIRCo0MfuGb | Mafaray CHP                                      | OjRCvy71kAL |
| test_568  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Maforki                    | JdqfYTIFZXN | Mafoimara MCHP                                   | z4silfLpw2G |
| test_569  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Bombali Sebora             | KKkLOTpMXGV | Maforay (B. Sebora) MCHP                         | C1zlHePEQe6 |
| test_570  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Maforki                    | JdqfYTIFZXN | Maforay MCHP                                     | simyC07XwnS |
| test_571  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Samu                       | r06ohri9wA9 | Mafufuneh MCHP                                   | L3GgannGGKl |
| test_572  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Yoni                       | NNE0YMCDZkO | Magbaesa MCHP                                    | j57JudVQJtn |
| test_573  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Yoni                       | NNE0YMCDZkO | Magbaft MCHP                                     | XjpmsLNjyrz |
| test_574  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Makari Gbanti              | lY93YpCxJqf | Magbaikoli MCHP                                  | cTU2WmWcJKx |
| test_575  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Libeisaygahun              | hRZOIgQ0O1m | Magbaingba MCHP                                  | DIQl5jJ17IE |
| test_576  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kunike                     | l0ccv2yzfF3 | Magbanabom MCHP                                  | a5glgtnXJRG |
| test_577  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Yoni                       | NNE0YMCDZkO | Magbassabana MCHP                                | bf6PXrSNMKK |
| test_578  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kholifa Rowalla            | PQZJPIpTepd | Magbass MCHP                                     | sFgNRYS5pBo |
| test_579  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Marampa                    | RWvG1aFrr0r | Magbele MCHP                                     | hZpaU5uFSDm |
| test_580  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Gbinleh Dixion             | qIRCo0MfuGb | Magbengbeh MCHP                                  | VeXU3mndzri |
| test_581  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Maforki                    | JdqfYTIFZXN | Magbengberah MCHP                                | WxMIZC6Cxqs |
| test_582  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Koya                       | pRHGAROvuyI | Magbeni MCHP                                     | UJ80rknbJtm |
| test_583  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kongbora                   | Jiyc4ekaMMh | Magbenka CHP                                     | uAk40nFigUK |
| test_584  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Magbema                    | QywkxFudXrC | Magbethy MCHP                                    | koa3hwZZ2i7 |
| test_585  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Marampa                    | RWvG1aFrr0r | Magbil MCHP                                      | n9HIySyR00g |
| test_586  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Yoni                       | NNE0YMCDZkO | Magboki Rd. Mile 91 MCHP                         | PWqwcBdRGIH |
| test_587  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Sanda Magbolonthor         | HWjrSuoNPte | Magbolonthor MCHP                                | XfVYz6l2rzg |
| test_588  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kholifa Rowalla            | PQZJPIpTepd | Magburaka Govt. Hospital                         | mEUUK7MHLSF |
| test_589  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Maguama CHP                                      | ltF8BmYAXpQ |
| test_590  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Sanda Loko                 | WXnNDWTiE9r | Maharibo MCHP                                    | CKJ9YS2AbWy |
| test_591  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Gbendembu Ngowahun         | BXJdOLvUrZB | Maharie MCHP                                     | qEQFWnKh4gs |
| test_592  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Kaffu Bullom               | vn9KJsLyP5f | Mahera CHC                                       | LnToY3ExKxL |
| test_593  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Dama                       | myQ4q1W6B4y | Majihun MCHP                                     | ShdRyzuLKA2 |
| test_594  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Maforki                    | JdqfYTIFZXN | Makaba MCHP                                      | kSo9KSpHUPL |
| test_595  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Marampa                    | RWvG1aFrr0r | Makabo MCHP                                      | en0j7qFnySQ |
| test_596  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Gbanti Kamaranka           | e1eIKM1GIF3 | Makaiba MCHP                                     | ewh5SKxcCAl |
| test_597  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kunike Barina              | rXLor9Knq6l | Makali CHC                                       | scc4QyxenJd |
| test_598  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Koya                       | pRHGAROvuyI | Makalie MCHP                                     | CgunjDKbM45 |
| test_599  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Bombali Sebora             | KKkLOTpMXGV | Makama MCHP                                      | Dbn6fyCgMBV |
| test_600  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Koya                       | pRHGAROvuyI | Makarankay MCHP                                  | XePkcmza9e8 |
| test_601  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Makari Gbanti              | lY93YpCxJqf | Makarie MCHP                                     | wSHfjjFqUay |
| test_602  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Yoni                       | NNE0YMCDZkO | Makelleh MCHP                                    | NwX8noGxLoz |
| test_603  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Paki Masabong              | L8iA6eLwKNb | Makeni-Lol MCHP                                  | dmdYffw2I0F |
| test_604  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Yoni                       | NNE0YMCDZkO | Makeni-Rokfullah MCHP                            | jbfISeV6Wdu |
| test_605  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Koya                       | pRHGAROvuyI | Makiteh MCHP                                     | YldSFPxB6WH |
| test_606  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Malal Mara                 | EVkm2xYcf6Z | Makoba Bana MCHP                                 | KwSj4DlRWAm |
| test_607  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Makobeh MCHP                                     | iMDr2FG7i8Q |
| test_608  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Paki Masabong              | L8iA6eLwKNb | Makolor CHP                                      | si34vmovtgR |
| test_609  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Tane                       | xhyjU2SVewz | Makona MCHP                                      | JKdMirJ02nv |
| test_610  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kunike Barina              | rXLor9Knq6l | Makoni Line MCHP                                 | CebtBqqp1fp |
| test_611  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Makonkondey MCHP                                 | RHJram03Rlm |
| test_612  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Gbonkonlenken              | P69SId31eDp | Makonkorie MCHP                                  | Zf2v0kbI7ah |
| test_613  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kafe Simira                | BmYyh9bZ0sr | Makonthanday MCHP                                | cd3U2Tp0qR2 |
| test_614  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Tane                       | xhyjU2SVewz | Makrugbeh MCHP                                   | G5NCnFJ3bbV |
| test_615  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Bombali Sebora             | KKkLOTpMXGV | Makump Bana MCHP                                 | E7IDb3nNiW7 |
| test_616  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Yoni                       | NNE0YMCDZkO | Makundu MCHP                                     | LWlh25dfvEA |
| test_617  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Maforki                    | JdqfYTIFZXN | Malal MCHP                                       | FFU3PJ3pY7s |
| test_618  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Malama MCHP                                      | kBrq7i12aan |
| test_619  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Malambay CHP                                     | ZoHdXy2ueVn |
| test_620  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Soro-Gbeima                | d9iMR1MpuIO | Malema 1 MCHP                                    | dCvUVvKnhMe |
| test_621  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Yawei                      | byp7w6Xd9Df | Malema (Yawei) CHP                               | Mod8hYpQ3Ma |
| test_622  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Koya                       | pRHGAROvuyI | Malenkie MCHP                                    | TrmusBXxLm3 |
| test_623  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kholifa Rowalla            | PQZJPIpTepd | Malone MCHP                                      | F0uVXCVvOPO |
| test_624  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Gbendembu Ngowahun         | BXJdOLvUrZB | Mamaka MCHP                                      | d9uZeZ5fMUo |
| test_625  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Yoni                       | NNE0YMCDZkO | Mamaka (Yoni) MCHP                               | u0SlCNJnK3K |
| test_626  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Masimera                   | EfWCa0Cc8WW | Mamalikie MCHP                                   | ALZ2qr5u0X0 |
| test_627  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Kaffu Bullom               | vn9KJsLyP5f | Mamankie MCHP                                    | eP4F9eB76B0 |
| test_628  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kholifa Mabang             | fwxkctgmffZ | Mamanso Kafla MCHP                               | T1lTKu6zkHN |
| test_629  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kunike                     | l0ccv2yzfF3 | Mamanso Sanka CHP                                | YFlZA0y0Vi6 |
| test_630  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Magbaimba Ndowahun         | eV4cuxniZgP | Mambiama CHP                                     | LmRTf03IFkA |
| test_631  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Mambolo                    | xGMGhjA3y6J | Mambolo CHC                                      | RAsstekPRco |
| test_632  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Jaiama Bongor              | daJPPxtIrQn | Mamboma MCHP                                     | w3vRmEz3J7t |
| test_633  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Peje Bongre                | DxAPPqXvwLy | Mamboma (Peje Bongre) CHP                        | F7u30K5OIpi |
| test_634  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kholifa Rowalla            | PQZJPIpTepd | Mamuntha MCHP                                    | Vh1fsWOYcv1 |
| test_635  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Marampa                    | RWvG1aFrr0r | Mamusa MCHP                                      | FRX63UWciyO |
| test_636  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Sanda Tendaren             | UhHipWG7J8b | Manack MCHP                                      | fUxVOkpX3yi |
| test_637  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Lokomasama                 | fRLX08WHWpL | Mana II CHP                                      | U9klfqqGlRa |
| test_638  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Kpanga Kabonde             | QwMiPiME3bA | Mandema CHP                                      | WerHl8SDtRU |
| test_639  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Sogbini                    | cgOy0hRMGu9 | Mandu CHP                                        | EQnfnY03sRp |
| test_640  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Malal Mara                 | EVkm2xYcf6Z | Manewa MCHP                                      | CTnuuI55SOj |
| test_641  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Tane                       | xhyjU2SVewz | Mangaybana CHP                                   | mRNfATVxa3m |
| test_642  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Makari Gbanti              | lY93YpCxJqf | Mangay Loko MCHP                                 | gaOSAjPM07w |
| test_643  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Samu                       | r06ohri9wA9 | Mange Bissan MCHP                                | cKXicCOquXe |
| test_644  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Bureh Kasseh Maconteh      | TA7NvKjsn4A | Mange CHC                                        | w3mBVfrWhXl |
| test_645  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Sittia                     | g8DdBm7EmUt | Mania MCHP                                       | XsB16iHtwLL |
| test_646  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Soa                        | iGHlidSFdpu | Manjama MCHP                                     | mMvt6zhCclb |
| test_647  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Manjama Shellmingo CHC                           | lOv6IFgr6Fs |
| test_648  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Manjama UMC CHC                                  | Z9ny6QeqsgX |
| test_649  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kori                       | nV3OkyzF4US | Manjeihun MCHP                                   | J3wTSn87RP2 |
| test_650  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Biriwa                     | fwH9ipvXde9 | Manjoro MCHP                                     | Uwcj0mz78BV |
| test_651  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Dembelia Sinkunia          | Mr4au3jR9bt | Manna MCHP                                       | gowgzHWc8FT |
| test_652  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Dasse                      | RndxKqQGzUl | Mano CHC                                         | va2lE4FiVVb |
| test_653  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Mano Sakrim                | nlt6j60tCHF | Mano Gbonjeima CHC                               | O1KFJmM6HUx |
| test_654  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Jaiama Bongor              | daJPPxtIrQn | Mano-Jaiama CHP                                  | hLGkoHmvBgI |
| test_655  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Njaluahun                  | ERmBhYkhV6Y | Mano Menima CHP                                  | vlNXjc2lk9y |
| test_656  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Tunkia                     | l7pFejMtUoF | Mano Njeigbla CHP                                | Fbq6Vxa4MIx |
| test_657  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Luawa                      | cM2BKSrj9F9 | Mano Sewallu CHP                                 | XvqLmn4kZXy |
| test_658  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Peje Bongre                | DxAPPqXvwLy | Manowa CHC                                       | PaNv9VyD06n |
| test_659  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Bargbo                     | zFDYIgyGmXG | Mano Yorgbo MCHP                                 | KvE0PYQzXMM |
| test_660  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Mongo                      | OTFepb1k9Db | Mansadu MCHP                                     | GyH8bjdOTsD |
| test_661  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Gbonkonlenken              | P69SId31eDp | Mansumana CHP                                    | RVAkLOVWSWc |
| test_662  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Nimikoro                   | DmaLM8WYmWv | Mansundu MCHP                                    | tR6e8k99ODA |
| test_663  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Sandor                     | g5ptsn0SFX8 | Mansundu (Sandor) MCHP                           | OUPkxfQld8y |
| test_664  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Buya Romende               | Pc3JTyqnsmL | Manumtheneh MCHP                                 | ZALwM386w0T |
| test_665  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kargboro                   | Z9QaI6sxTwW | Mapailleh MCHP                                   | RG6MGu5nUlI |
| test_666  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Paki Masabong              | L8iA6eLwKNb | Mapaki CHC                                       | mshIal30ffW |
| test_667  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kunike Barina              | rXLor9Knq6l | Mapamurie MCHP                                   | sHbLRZLmS4w |
| test_668  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Maforki                    | JdqfYTIFZXN | Mapawn MCHP                                      | HlDMbDWUmTy |
| test_669  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Lokomasama                 | fRLX08WHWpL | Mapillah MCHP                                    | SIxGTeya5lN |
| test_670  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Samu                       | r06ohri9wA9 | Mapotolon CHC                                    | RQgXBKxgvHf |
| test_671  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Malal Mara                 | EVkm2xYcf6Z | Mara CHC                                         | J42QfNe0GJZ |
| test_672  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Gbonkonlenken              | P69SId31eDp | Maraka MCHP                                      | v0HMlSxlH7l |
| test_673  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Marie Stopes Clinic (Abedeen R)                  | KuR0y0h0mOM |
| test_674  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Gbense                     | TQkG0sX9nca | Marie Stopes (Gbense) Clinic                     | Bift1B4gjru |
| test_675  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Marie Stopes (Kakua) Clinic                      | kLNQT4KQ9hT |
| test_676  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Maforki                    | JdqfYTIFZXN | Maronko MCHP                                     | UoLtRvXxNaB |
| test_677  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Tainkatopa Makama Safrokoh | PrJQHI6q7w2 | Maron MCHP                                       | LzvoPaeLPsb |
| test_678  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Paki Masabong              | L8iA6eLwKNb | Masabong Pil MCHP                                | suFG8zx4bU3 |
| test_679  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kunike                     | l0ccv2yzfF3 | Masaika MCHP                                     | ETRqfu74kge |
| test_680  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Buya Romende               | Pc3JTyqnsmL | Masamboi MCHP                                    | Hu31NCRjZlj |
| test_681  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kholifa Rowalla            | PQZJPIpTepd | Masanga Leprosy Hospital                         | wB4R3E1X6pC |
| test_682  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Sella Limba                | j43EZb15rjI | Masankorie CHP                                   | eyfrdOUUkXO |
| test_683  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Tane                       | xhyjU2SVewz | Masankoro MCHP                                   | l3jnkNNpoD8 |
| test_684  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Safroko Limba              | XG8HGAbrbbL | Maselleh MCHP                                    | CY8cV5khn7e |
| test_685  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Koya                       | pRHGAROvuyI | Masiaka CHC                                      | EURoFVjowXs |
| test_686  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Masimera                   | EfWCa0Cc8WW | Masimera CHC                                     | EH0dXLB4nZg |
| test_687  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Paki Masabong              | L8iA6eLwKNb | Masingbi-Lol MCHP                                | t0DLywkw6O1 |
| test_688  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Neya                       | GFk45MOxzJJ | Masofinia MCHP                                   | eKoXODABUJe |
| test_689  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kholifa Rowalla            | PQZJPIpTepd | Masoko MCHP                                      | D6B4jrCpCwu |
| test_690  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Makari Gbanti              | lY93YpCxJqf | Masongbo CHC                                     | uRQj8WRK0Py |
| test_691  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Safroko Limba              | XG8HGAbrbbL | Masongbo Limba MCHP                              | PhR1PdMTzhW |
| test_692  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Masorie CHP                                      | xWjiTeok0Sr |
| test_693  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Bombali Sebora             | KKkLOTpMXGV | Masory MCHP                                      | dqHvtpUqLwB |
| test_694  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kunike Barina              | rXLor9Knq6l | Massaba MCHP                                     | S6KDC0jVhmD |
| test_695  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Nimiyama                   | qgQ49DH9a0v | Massabendu CHP                                   | Z0q0Y3GRugt |
| test_696  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Massah Memorial Maternity MCHP                   | ptc0SQi05E4 |
| test_697  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Massahun MCHP                                    | GA7eQkgK5mX |
| test_698  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Kpaka                      | zSNUViKdkk3 | Massam MCHP                                      | vpNGJvZ0ljF |
| test_699  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Yawei                      | byp7w6Xd9Df | Massayeima MCHP                                  | iH79WhpsByj |
| test_700  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Tonko Limba                | y5X4mP5XylL | Masselleh MCHP                                   | cag6vQQ9SQk |
| test_701  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Bureh Kasseh Maconteh      | TA7NvKjsn4A | Masseseh MCHP                                    | jIrb5XckcU6 |
| test_702  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kunike                     | l0ccv2yzfF3 | Massingbi CHC                                    | OY7mYDATra3 |
| test_703  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Bombali Sebora             | KKkLOTpMXGV | Masuba MCHP                                      | XzmWizbR343 |
| test_704  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Koya                       | pRHGAROvuyI | Masumana MCHP                                    | UlgEReuUPM4 |
| test_705  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kafe Simira                | BmYyh9bZ0sr | Masumbrie MCHP                                   | flJbtXOQ4ha |
| test_706  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Sanda Tendaren             | UhHipWG7J8b | Mateboi CHC                                      | EXbPGmEUdnc |
| test_707  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Gbonkonlenken              | P69SId31eDp | Mathamp MCHP                                     | KFhJrkqnrnb |
| test_708  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Lokomasama                 | fRLX08WHWpL | Mathen MCHP                                      | TrIXhUR4sDQ |
| test_709  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kholifa Mabang             | fwxkctgmffZ | Mathinkalol MCHP                                 | caif2tNAS0n |
| test_710  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Yoni                       | NNE0YMCDZkO | Mathoir CHC                                      | dkmpOuVhBba |
| test_711  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kunike                     | l0ccv2yzfF3 | Matholey MCHP                                    | lyONqUkY1Bq |
| test_712  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Tane                       | xhyjU2SVewz | Mathonkara MCHP                                  | rLaGvUnv2BF |
| test_713  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Tane                       | xhyjU2SVewz | Mathufulie MCHP                                  | OTn9VMNEkdo |
| test_714  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Magbema                    | QywkxFudXrC | Mathuraneh MCHP                                  | tt9XZYR5avl |
| test_715  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Tane                       | xhyjU2SVewz | Matotoka CHC                                     | KcCbIDzRcui |
| test_716  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Libeisaygahun              | hRZOIgQ0O1m | Matoto MCHP                                      | uGa5JtIMfRx |
| test_717  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Jong                       | VCtF1DbspR5 | Mattru Jong MCHP                                 | PnMPARoMhWW |
| test_718  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Tikonko                    | sxRd2XOzFbz | Mattru on the Rail MCHP                          | Qu0QOykPdcD |
| test_719  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Jong                       | VCtF1DbspR5 | Mattru UBC Hospital                              | ctN0WgIvfke |
| test_720  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Koya                       | pRHGAROvuyI | Mawoma MCHP                                      | Srnpwq8jKbp |
| test_721  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Mambolo                    | xGMGhjA3y6J | Mayakie MCHP                                     | R0CmUlFULXg |
| test_722  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kafe Simira                | BmYyh9bZ0sr | Mayassoh MCHP                                    | Z8Cm76B2726 |
| test_723  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Gbonkonlenken              | P69SId31eDp | Mayepoh CHC                                      | aHs9PLxIdbr |
| test_724  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Yoni                       | NNE0YMCDZkO | Mayogbor MCHP                                    | XiORvSsxn6s |
| test_725  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Masimera                   | EfWCa0Cc8WW | Mayolla MCHP                                     | JBhJiwqBCUa |
| test_726  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Masimera                   | EfWCa0Cc8WW | Mayombo MCHP                                     | gfk1TNPI4wN |
| test_727  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kholifa Rowalla            | PQZJPIpTepd | Mayossoh MCHP                                    | vQYIk5G9NxP |
| test_728  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Dema                       | DNRAeXT9IwS | Mbaoma CHP                                       | QN4te5Z5svQ |
| test_729  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Sittia                     | g8DdBm7EmUt | Mbokie CHP                                       | nImgPWDVQIa |
| test_730  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Dodo                       | QlCIp2S9NHs | Mbowohun CHP                                     | irVdYBmHBxs |
| test_731  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Baoma                      | vWbkYPRmKyS | Mbundorbu MCHP                                   | EuoA3Crpqts |
| test_732  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | MCH (Kakua) Static                               | Pae8DR7VmcL |
| test_733  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Wara Wara Yagala           | EZPwuUTeIIG | MCH Static                                       | kpDoH80fwdX |
| test_734  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Kpanga Kabonde             | QwMiPiME3bA | MCH Static Pujehun                               | foPGXhwhlqp |
| test_735  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kaiyamba                   | USQdmvrHh1Q | MCH Static/U5                                    | w9XjBMJYL9R |
| test_736  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Tainkatopa Makama Safrokoh | PrJQHI6q7w2 | Melekuray CHC                                    | HcB2W6Fgp7i |
| test_737  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Luawa                      | cM2BKSrj9F9 | Mende Buima MCHP                                 | NnGUNkc5Zq8 |
| test_738  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Gaura                      | eROJsBwxQHt | Mendekelema CHP                                  | sYjp3h6amhA |
| test_739  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Upper Bambara              | LfTkc0S4b5k | Mendekelema (Upper Banbara) CHP                  | SlNw6FxElY9 |
| test_740  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Bargbe                     | dGheVylzol6 | Mendewa MCHP                                     | YWXXO0XMkQe |
| test_741  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Magbema                    | QywkxFudXrC | Menicurve MCHP                                   | VjVYaKZ9t4K |
| test_742  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Lokomasama                 | fRLX08WHWpL | Menika MCHP                                      | HHc5HDPFlXy |
| test_743  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Mercy Ship ACFC                                  | xO9WbCvFq5k |
| test_744  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Mercy Ship Hospital                              | bqtZrXoryDF |
| test_745  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Mid Land MCHP                                    | hyLU8ivDJDi |
| test_746  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Koya                       | pRHGAROvuyI | Mile 38 CHP                                      | WoqN1oUBX2R |
| test_747  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Nongoba Bullum             | VP397wRvePm | Minah MCHP                                       | ZW3XCXXiLcO |
| test_748  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Bendu Cha                  | EB1zRKdYjdY | Mindohun CHP                                     | QZzRkqdGjlm |
| test_749  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Bureh Kasseh Maconteh      | TA7NvKjsn4A | Minthomor CHP                                    | cZI3AWM7bIa |
| test_750  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | M I Room (Military)                              | c9wCIfbcyVo |
| test_751  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Mandu                      | yu4N82FFeLm | Mobai CHC                                        | MXdbul7bBqV |
| test_752  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Yawbeko                    | CG4QD1HC3h4 | Mobefa MCHP                                      | XL745P4ETSL |
| test_753  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Magbema                    | QywkxFudXrC | Modia MCHP                                       | ua3kNk4uraZ |
| test_754  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Upper Banta                | DBs6e2Oxaj1 | Modonkor CHP                                     | cXMQtUId06K |
| test_755  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kowa                       | xIKjidMrico | Mofombo MCHP                                     | kqyeoWyfDmQ |
| test_756  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Dasse                      | RndxKqQGzUl | Mogbasske CHP                                    | DZaJmtlaBMl |
| test_757  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Ribbi                      | gy8rmvYT4cj | Mogbongisseh MCHP                                | DJr17K6RWzO |
| test_758  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kamaje                     | LsYpCyYxSLY | Mogbuama MCHP                                    | wGsBlwh6Zzt |
| test_759  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Imperi                     | XEyIRFd9pct | Mogbwemo CHP                                     | jIkxZKctVhB |
| test_760  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Upper Banta                | DBs6e2Oxaj1 | Mogomgbay MCHP                                   | GQpxsB7tekR |
| test_761  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kargboro                   | Z9QaI6sxTwW | Mokainsumana CHP                                 | bLYNonGzr0Y |
| test_762  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Bumpeh                     | nOYt1LtFSyU | Mokaiyegbeh MCHP                                 | WxMmxNU6Gla |
| test_763  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kargboro                   | Z9QaI6sxTwW | Mokandor CHP                                     | sIVFEyNfOg4 |
| test_764  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Lower Banta                | W5fN3G6y1VI | Mokanji CHC                                      | cNAp6CJeLxk |
| test_765  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Bagruwa                    | jPidqyo7cpF | Mokassie MCHP                                    | kd2Aqw5S07V |
| test_766  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Fakunya                    | vULnao2hV5v | Mokellay MCHP                                    | RxmgoSlw9YF |
| test_767  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Upper Banta                | DBs6e2Oxaj1 | Mokelleh CHC                                     | JQJjsXvHE5M |
| test_768  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Bumpe Ngao                 | BGGmAwx33dj | Mokoba MCHP                                      | xt08cuqf1ys |
| test_769  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kargboro                   | Z9QaI6sxTwW | Mokobo MCHP                                      | SC0nM3cbGHy |
| test_770  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kargboro                   | Z9QaI6sxTwW | Mokongbetty MCHP                                 | BedE3DKQDFf |
| test_771  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Ribbi                      | gy8rmvYT4cj | Mokorbu MCHP                                     | cHqboEGRUiY |
| test_772  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Fakunya                    | vULnao2hV5v | Mokorewa MCHP                                    | sAO5hEWo4z5 |
| test_773  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Lower Banta                | W5fN3G6y1VI | Mokotawa CHP                                     | R9gZAoI9aQM |
| test_774  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Timidale                   | AovmOHadayb | Mokpanabom MCHP                                  | qcYG2Id7GS8 |
| test_775  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Bumpe Ngao                 | BGGmAwx33dj | Mokpende MCHP                                    | am6EFqHGKeU |
| test_776  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Bargbo                     | zFDYIgyGmXG | Momajo MCHP                                      | fA43H8Ds0Ja |
| test_777  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Gorama Mende               | KXSqt7jv6DU | Mondema CHC                                      | Luv2kmWWgoG |
| test_778  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Valunia                    | npWGUj37qDe | Mongere CHC                                      | PC3Ag91n82e |
| test_779  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Jong                       | VCtF1DbspR5 | Mongerewa MCHP                                   | WdgS1JcBL2g |
| test_780  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Luawa                      | cM2BKSrj9F9 | Morfindor CHP                                    | ih77LC7LE1p |
| test_781  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Imperi                     | XEyIRFd9pct | Moriba Town CHC                                  | xMn4Wki9doK |
| test_782  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Samu                       | r06ohri9wA9 | Moribaya MCHP                                    | HMltAwIjIIe |
| test_783  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Morning Star Clinic                              | kMTHqMgenme |
| test_784  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Timidale                   | AovmOHadayb | Mosagbe MCHP                                     | AIM09vwxjoN |
| test_785  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Timidale                   | AovmOHadayb | Mosanda CHP                                      | cDRQOxX1wHO |
| test_786  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Bagruwa                    | jPidqyo7cpF | Mosenegor MCHP                                   | HHz1kAG1LKn |
| test_787  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Lower Banta                | W5fN3G6y1VI | Mosenessie Junction MCHP                         | XmfqaErvQ2T |
| test_788  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Nimikoro                   | DmaLM8WYmWv | Motema CHP                                       | g3O1pGAfgK1 |
| test_789  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Ribbi                      | gy8rmvYT4cj | Motoni MCHP                                      | fvytjjnlQlK |
| test_790  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Ribbi                      | gy8rmvYT4cj | Motonkoh MCHP                                    | BpWJ3cRsO6g |
| test_791  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Bumpeh                     | nOYt1LtFSyU | Motorbong MCHP                                   | Gtnbmf4LkOz |
| test_792  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Kpanda Kemoh               | aWQTfvgPA5v | Motuo CHC                                        | rCKWdLr4B8K |
| test_793  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Fakunya                    | vULnao2hV5v | Moyamba Junction CHC                             | MuZJ8lprGqK |
| test_794  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Bumpeh                     | nOYt1LtFSyU | Moyeamoh CHP                                     | WhCQNekdIwM |
| test_795  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Moyiba CHC                                       | zEsMdeJOty4 |
| test_796  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Fakunya                    | vULnao2hV5v | Moyollo MCHP                                     | UgUcwzbEv2C |
| test_797  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Jong                       | VCtF1DbspR5 | Moyowa MCHP                                      | sY1WN6LjmAx |
| test_798  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Murray Town CHC                                  | a04CZxe0PSe |
| test_799  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Lokomasama                 | fRLX08WHWpL | Musaia CHP                                       | sTOXJA2KcY2 |
| test_800  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Folosaba Dembelia          | iEkBZnMDarP | Musaia (Koinadugu) CHC                           | lBMmM0HBp4s |
| test_801  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Mutual Faith Clinic                              | Uo4cyJwAhTW |
| test_802  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Nafaya MCHP                                      | KQFAul3T9xz |
| test_803  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Dea                        | lYIM1MXbSYS | Nagbena CHP                                      | nGb94wPdcqx |
| test_804  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Sengbeh                    | VGAFxBXz16y | Nasarah Clinic                                   | bPHn9IgjKLC |
| test_805  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Ndegbome MCHP                                    | ZsjXrmZS59z |
| test_806  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Nduvuibu MCHP                                    | aBfyTU5Wgds |
| test_807  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Needy CHC                                        | UOJlcpPnBat |
| test_808  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Nekabo CHC                                       | L4Tw4NlaMjn |
| test_809  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Niawa Lenga                | I4jWcnFmgEC | Nengbema CHC                                     | rm60vuHyQXj |
| test_810  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | New Harvest Clinic                               | yP2nhllbQPh |
| test_811  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | New London MCHP                                  | uczMdDZXdtl |
| test_812  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Maforki                    | JdqfYTIFZXN | New Maforkie CHP                                 | lzz1UhTzO4E |
| test_813  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | New Police Barracks CHC                          | mzsOsz0NwNY |
| test_814  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Newton CHC                                       | m3VnSQbE8CD |
| test_815  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Nimikoro                   | DmaLM8WYmWv | Ngaiya MCHP                                      | YnuwSqXPx9H |
| test_816  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Bargbe                     | dGheVylzol6 | Ngalu CHC                                        | CvBAqD6RzLZ |
| test_817  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Tunkia                     | l7pFejMtUoF | Ngegbwema CHC                                    | P4upLKrpkHP |
| test_818  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Badjia                     | YuQRtpLP10I | Ngelehun CHC                                     | DiszpKrYNg8 |
| test_819  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Ngelehun MCHP                                    | FwKJ7gYEv8U |
| test_820  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Bum                        | iUauWFeH8Qp | Ngessehun MCHP                                   | Brre03pQkKB |
| test_821  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Gorama Mende               | KXSqt7jv6DU | Ngiegboiya MCHP                                  | DwEfz1MN7Z5 |
| test_822  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Luawa                      | cM2BKSrj9F9 | Ngiehun CHC                                      | sznCEDMABa2 |
| test_823  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Malegohun                  | x4HaBHHwBML | Ngiehun Kongo CHP                                | QII5GqfDfO3 |
| test_824  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Lower Bambara              | hdEuw2ugkVF | Ngiehun (Lower Bambara) MCHP                     | m21WB5iqHAb |
| test_825  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kargboro                   | Z9QaI6sxTwW | Ngiehun MCHP                                     | hBPtNXkQ3mP |
| test_826  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Tunkia                     | l7pFejMtUoF | Ngiewahun CHP                                    | KuGO75X47Gk |
| test_827  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Lugbu                      | kU8vhUkAGaT | Ngieyehun MCHP                                   | al4GkB6X2X3 |
| test_828  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Niawa Lenga                | I4jWcnFmgEC | Ngogbebu MCHP                                    | hoJ0Do9loZl |
| test_829  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Bumpe Ngao                 | BGGmAwx33dj | Ngolahun CHC                                     | wwM3YPvBKu2 |
| test_830  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Valunia                    | npWGUj37qDe | Ngolahun Jabaty MCHP                             | aSnKB1sWaz4 |
| test_831  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Nimiyama                   | qgQ49DH9a0v | Ngo Town CHP                                     | XGUOQaRUPjO |
| test_832  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Sogbini                    | cgOy0hRMGu9 | Ngueh MCHP                                       | Vw4Uv6UPIPC |
| test_833  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Bargbo                     | zFDYIgyGmXG | Niagorehun CHP                                   | p9ZtyC3LQ9f |
| test_834  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Komboya                    | JdhagCUEMbj | Niagorehun MCHP                                  | WOk7efLlLSj |
| test_835  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Niahun Buima MCHP                                | cC03EwJLBiO |
| test_836  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Njaluahun                  | ERmBhYkhV6Y | Niahun Gboyama MCHP                              | BJMWTGwuGiw |
| test_837  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Jaiama Bongor              | daJPPxtIrQn | Niayahun CHP                                     | IHa6fsNWsOZ |
| test_838  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Sambaia Bendugu            | r1RUyfVBkLp | Ninkikoro MCHP                                   | YXdC9hjYPqQ |
| test_839  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Fakunya                    | vULnao2hV5v | Njagbahun (Fakunya) MCHP                         | QoROdPmIdY1 |
| test_840  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Lower Banta                | W5fN3G6y1VI | Njagbahun (L.Banta) MCHP                         | u3B5RqJuDAP |
| test_841  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Lower Bambara              | hdEuw2ugkVF | Njagbahun MCHP                                   | VjygCFzqcYu |
| test_842  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Nimikoro                   | DmaLM8WYmWv | Njagbwema CHP                                    | MUnd4KWox8m |
| test_843  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Fiama                      | CF243RPvNY7 | Njagbwema Fiama CHC                              | sLKHXoBIqSs |
| test_844  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Gorama Kono                | GWTIxJO9pRo | Njagbwema MCHP                                   | aV9VVijeVB2 |
| test_845  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Komboya                    | JdhagCUEMbj | Njala CHC                                        | QsAwd531Cpd |
| test_846  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Nimikoro                   | DmaLM8WYmWv | Njala CHP                                        | vPz4Irz7sxR |
| test_847  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kori                       | nV3OkyzF4US | Njala University Hospital                        | Bpvug2zxHEZ |
| test_848  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Barri                      | RzKeCma9qb1 | Njaluahun CHP                                    | kvzdkXBxHoN |
| test_849  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kowa                       | xIKjidMrico | Njama CHC                                        | hzf90qz08AW |
| test_850  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Malema                     | GE25DpSrqpB | Njama MCHP                                       | WMj6mBDw76A |
| test_851  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Badjia                     | YuQRtpLP10I | Njandama MCHP                                    | g8upMTyEZGZ |
| test_852  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nomo                       | U09TSwIjG0s | Nomo Faama CHP                                   | bne6tOoPaWn |
| test_853  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Masimera                   | EfWCa0Cc8WW | Nonkoba CHP                                      | fdsRQbuuAuh |
| test_854  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Tonko Limba                | y5X4mP5XylL | Numea CHC                                        | PduUQmdt0pB |
| test_855  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Luawa                      | cM2BKSrj9F9 | Nyandehun CHP                                    | JQr6TJx5KE3 |
| test_856  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Koya (kenema)              | EYt6ThQDagn | Nyandehun (Koya) MCHP                            | DINXUs8QZWg |
| test_857  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Mano Sakrim                | nlt6j60tCHF | Nyandehun (Mano Sakrim) MCHP                     | t6S2MopeRaM |
| test_858  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Malen                      | DfUfwjM9am5 | Nyandehun MCHP                                   | mVvEwzoFutG |
| test_859  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Njaluahun                  | ERmBhYkhV6Y | Nyandehun Nguvoihun CHP                          | zpEPGogIr6q |
| test_860  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Nyandeyaima MCHP                                 | DwlFKzDSuQU |
| test_861  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Small Bo                   | vzup1f6ynON | Nyangbe-Bo MCHP                                  | AiGBODidxPw |
| test_862  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Jawi                       | KSdZwrU7Hh6 | Nyeama CHP                                       | dNT8lAL4zGo |
| test_863  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Ola During Clinic                                | tHUYjt9cU6h |
| test_864  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Panderu MCHP                                     | ueuQlqb8ccl |
| test_865  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Lower Bambara              | hdEuw2ugkVF | Panguma Mission Hosp.                            | PEZNsGbZaVJ |
| test_866  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Makari Gbanti              | lY93YpCxJqf | Panlap MCHP                                      | zLiMZ1WrxdG |
| test_867  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Paramedical CHC                                  | tSBcgrTDdB8 |
| test_868  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Dama                       | myQ4q1W6B4y | Patama MCHP                                      | tWjUy6MCx8q |
| test_869  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Bombali Sebora             | KKkLOTpMXGV | Pate Bana CHP                                    | wzvDhS0TkAF |
| test_870  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | PCM Hospital                                     | LqH7ZGU9KAx |
| test_871  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Kpanga Kabonde             | QwMiPiME3bA | Pehala MCHP                                      | CqARw68kXbB |
| test_872  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Peje West                  | pmxZm7klXBy | Pejewa CHC                                       | nv41sOz8IVM |
| test_873  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Pejeh                      | N233eZJZ1bh | Pejewa MCHP                                      | BTXwf2gl7av |
| test_874  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Baoma                      | vWbkYPRmKyS | Pelewahun (Baoma) MCHP                           | KfUCAQoOIae |
| test_875  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Lower Bambara              | hdEuw2ugkVF | Pelewahun MCHP                                   | MQHszd6K6V5 |
| test_876  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Jawi                       | KSdZwrU7Hh6 | Pellie CHC                                       | HQoxFu4lYPS |
| test_877  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Upper Bambara              | LfTkc0S4b5k | Pendembu CHC                                     | pJv8NJlJNhU |
| test_878  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Njaluahun                  | ERmBhYkhV6Y | Pendembu Njeigbla MCHP                           | fYmE4ymzZSe |
| test_879  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Lokomasama                 | fRLX08WHWpL | Pepel CHP                                        | XXlzHWzhf5d |
| test_880  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Gaura                      | eROJsBwxQHt | Perrie MCHP                                      | f6xGA6BZBLO |
| test_881  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Lokomasama                 | fRLX08WHWpL | Petifu CHC                                       | ke2gwHKHP3z |
| test_882  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Yoni                       | NNE0YMCDZkO | Petifu Fulamasa MCHP                             | Yc8Cmr5XS4B |
| test_883  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kunike                     | l0ccv2yzfF3 | Petifu Line MCHP                                 | byOPfWkK6M6 |
| test_884  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Gbonkonlenken              | P69SId31eDp | Petifu Mayepoh MCHP                              | DxPNV7VHauJ |
| test_885  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Jawi                       | KSdZwrU7Hh6 | Pewama CHP                                       | nbMpoRiVRWd |
| test_886  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Nimiyama                   | qgQ49DH9a0v | Peya MCHP                                        | zQ2pFkzGtIg |
| test_887  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Kamara                     | kvkDWg42lHR | Peyima CHP                                       | FGV6TAbL0eN |
| test_888  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Philip Street Clinic                             | ctfiYW0ePJ8 |
| test_889  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kargboro                   | Z9QaI6sxTwW | Plantain Island MCHP                             | oV9P0VvL9Jh |
| test_890  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | PMO Clinetown                                    | g7BLyiBb0ET |
| test_891  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Neya                       | GFk45MOxzJJ | Porpon MCHP                                      | EO6ghLtWv4W |
| test_892  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Potehun MCHP                                     | zY9ds4oNZxw |
| test_893  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Barri                      | RzKeCma9qb1 | Potoru CHC                                       | k6lOze3vTzP |
| test_894  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Praise Foundation CHC                            | wtdBuXDwZYQ |
| test_895  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Gorama Mende               | KXSqt7jv6DU | Punduru CHP                                      | sYJCxNdKHxR |
| test_896  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Makari Gbanti              | lY93YpCxJqf | Punthun MCHP                                     | rNaQEFRINbd |
| test_897  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Quarry MCHP                                      | xXYv82KlBUh |
| test_898  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Gbense                     | TQkG0sX9nca | Quidadu MCHP                                     | VZ6Cocesljy |
| test_899  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Rapha Clinic                                     | is3w3HROKVc |
| test_900  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Bombali Sebora             | KKkLOTpMXGV | Red Cross Clinic                                 | wNYYRm2c9EK |
| test_901  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Regent (RWA) CHC                                 | oRncQGhLYNE |
| test_902  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Rina Clinic                                      | u6ZGNI8yUmt |
| test_903  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Tainkatopa Makama Safrokoh | PrJQHI6q7w2 | Robaka MCHP                                      | ym42ZOlfZ1P |
| test_904  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Yoni                       | NNE0YMCDZkO | Robarie MCHP                                     | oph70zH8JB2 |
| test_905  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Bombali Sebora             | KKkLOTpMXGV | Robat MCHP                                       | gP6hn503KUX |
| test_906  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Malal Mara                 | EVkm2xYcf6Z | Robina MCHP                                      | fHqBRE3LTiQ |
| test_907  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Yoni                       | NNE0YMCDZkO | Rochem Kamandao CHP                              | PHo0IV7Vk50 |
| test_908  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Malal Mara                 | EVkm2xYcf6Z | Rochen Malal MCHP                                | X9zzzyPZViR |
| test_909  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Koya                       | pRHGAROvuyI | Rofoindu CHP                                     | jSPLEMDwXN4 |
| test_910  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Masimera                   | EfWCa0Cc8WW | Rofutha MCHP                                     | G5FuODAbH6X |
| test_911  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Dibia                      | ZiOVcrSjSYe | Rogballan CHP                                    | EZIMUaUD8AJ |
| test_912  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Bureh Kasseh Maconteh      | TA7NvKjsn4A | Rogballan MCHP                                   | I2UW55qvn82 |
| test_913  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Tainkatopa Makama Safrokoh | PrJQHI6q7w2 | Rogbaneh MCHP                                    | pvTYrkG1d6f |
| test_914  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Rogbangba MCHP                                   | bPJABq7F5Iy |
| test_915  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Maforki                    | JdqfYTIFZXN | Rogbere CHC                                      | qVvitxEF2ck |
| test_916  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Sanda Tendaren             | UhHipWG7J8b | Rogbin MCHP                                      | yvDKjcRRQsR |
| test_917  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Samu                       | r06ohri9wA9 | Rokai CHP                                        | UxpUYgdb4oU |
| test_918  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Masimera                   | EfWCa0Cc8WW | Rokel (Masimera) MCHP                            | UUZoBCSn245 |
| test_919  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Mambolo                    | xGMGhjA3y6J | Rokel MCHP                                       | dtuiqEXYa7z |
| test_920  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Yoni                       | NNE0YMCDZkO | Rokimbi MCHP                                     | pVuRAzSstbn |
| test_921  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Ribbi                      | gy8rmvYT4cj | Rokolon MCHP                                     | eqPIdr5yD1Q |
| test_922  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Bombali Sebora             | KKkLOTpMXGV | Rokonta CHC                                      | mepHuAA9l51 |
| test_923  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Dibia                      | ZiOVcrSjSYe | Roktolon MCHP                                    | VTtyiYcc6TE |
| test_924  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Sanda Tendaren             | UhHipWG7J8b | Rokulan CHC                                      | X79FDd4EAgo |
| test_925  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Rokupa Govt. Hospital                            | NfE9gvFwLIF |
| test_926  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Magbema                    | QywkxFudXrC | Rokupr CHC                                       | QZtMuEEV9Vv |
| test_927  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Marampa                    | RWvG1aFrr0r | Rolembray MCHP                                   | nZblzPvJ5UW |
| test_928  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Mambolo                    | xGMGhjA3y6J | Romando MCHP                                     | FQ5CCuUKNLf |
| test_929  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Bureh Kasseh Maconteh      | TA7NvKjsn4A | Romeni MCHP                                      | GCbYmPqcOOP |
| test_930  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Yoni                       | NNE0YMCDZkO | Ronietta MCHP                                    | B9RxRfRUi2R |
| test_931  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Yoni                       | NNE0YMCDZkO | Rorocks CHP                                      | D0iakqyTknH |
| test_932  | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Tane                       | xhyjU2SVewz | Rosengbeh MCHP                                   | x3ti3t9eOuX |
| test_933  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Samu                       | r06ohri9wA9 | Rosinor CHP                                      | n2qFnUIhbq3 |
| test_934  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Buya Romende               | Pc3JTyqnsmL | Rosint Buya MCHP                                 | el8sgzyHuEe |
| test_935  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Ross Road Health Centre                          | bPqP6eRfkyn |
| test_936  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Mambolo                    | xGMGhjA3y6J | Rotaimbana MCHP                                  | GMOl74xzmAE |
| test_937  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Fakunya                    | vULnao2hV5v | Rotawa CHP                                       | GcwGqLqyi1M |
| test_938  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Sanda Loko                 | WXnNDWTiE9r | Rothatha MCHP                                    | KaevAHPgkA8 |
| test_939  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Bumpeh                     | nOYt1LtFSyU | Rotifunk CHC                                     | gUPhNWkSXvD |
| test_940  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Gbanti Kamaranka           | e1eIKM1GIF3 | Royeama CHP                                      | msH78gZ7Fe6 |
| test_941  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Masimera                   | EfWCa0Cc8WW | Royeiben MCHP                                    | JU4dWUv0Pmd |
| test_942  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Barri                      | RzKeCma9qb1 | Saahun (barri) MCHP                              | InQWjSe6k2f |
| test_943  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Kpaka                      | zSNUViKdkk3 | Saahun (kpaka) MCHP                              | BG2fC2mRFOL |
| test_944  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Lower Bambara              | hdEuw2ugkVF | Saama (Lower Bamabara) CHP                       | BJ3DJFBKwBR |
| test_945  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Galliness Perri            | eNtRuQrrZeo | Saama MCHP                                       | WZ8PTx8qQlE |
| test_946  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Malen                      | DfUfwjM9am5 | Sahn Bumpe MCHP                                  | NDqR2cWlVy3 |
| test_947  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Niawa Lenga                | I4jWcnFmgEC | Sahn CHC                                         | PuZOFApTSeo |
| test_948  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Malen                      | DfUfwjM9am5 | Sahn (Malen) CHC                                 | HWXk4EBHUyk |
| test_949  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Bumpeh                     | nOYt1LtFSyU | Sahun (Bumpeh) MCHP                              | BXd3TqaAxkK |
| test_950  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Lei                        | LhaAPLxdSFH | Saiama MCHP                                      | AvGz949akv4 |
| test_951  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Kpanga Kabonde             | QwMiPiME3bA | Salima MCHP                                      | rFelzKE3SEp |
| test_952  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kaiyamba                   | USQdmvrHh1Q | Salina CHP                                       | XJI24bY3AN7 |
| test_953  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Tonko Limba                | y5X4mP5XylL | Samaia MCHP                                      | fNL2oehab2Q |
| test_954  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Samai Town MCHP                                  | I2DzylqJa2i |
| test_955  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Wara Wara Bafodia          | XrF5AvaGcuw | Samamaia MCHP                                    | SKJoPDgjELa |
| test_956  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Sandor                     | g5ptsn0SFX8 | Samandu MCHP                                     | g9xUM1x1f1i |
| test_957  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Tambaka                    | Qhmi8IZyPyD | Samaya CHP                                       | BnVjTzwis3o |
| test_958  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Mafindor                   | EjnIQNVAXGp | Sambaya MCHP                                     | vgOQ7fWmMyZ |
| test_959  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Kamara                     | kvkDWg42lHR | Samiquidu MCHP                                   | yXBtSoD0IRS |
| test_960  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Sam Lean’s MCHP                                  | H0OkaM4ReRK |
| test_961  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Penguia                    | bQiBfA2j5cw | Sandaru CHC                                      | Mi4dWRtfIOC |
| test_962  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Gaura                      | eROJsBwxQHt | Sandaru (Gaura) MCHP                             | hTGeTrwzrPi |
| test_963  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Lower Bambara              | hdEuw2ugkVF | Sandayeima MCHP                                  | oUR5HPmim7E |
| test_964  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Nimiyama                   | qgQ49DH9a0v | Sandia CHP                                       | vcY0lzBz6fU |
| test_965  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Kissi Tongi                | hjpHnHZIniP | Sandia (Kissi Tongi) CHP                         | iIQENGb7za6 |
| test_966  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Luawa                      | cM2BKSrj9F9 | Sandialu MCHP                                    | g6y7PS0UQR4 |
| test_967  | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Tambaka                    | Qhmi8IZyPyD | Sanya CHP                                        | UqHuR4IYvTY |
| test_968  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Kpanga Kabonde             | QwMiPiME3bA | Sawula MCHP                                      | tNs4E0JcMKe |
| test_969  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Kasonko                    | vEvs2ckGNQj | Sawuria CHP                                      | G6LbealddgU |
| test_970  | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Scan Drive MCHP                                  | u1eQDDtKqm7 |
| test_971  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | School Health Clinic                             | HPg74Rr7UWp |
| test_972  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Mano Sakrim                | nlt6j60tCHF | Sebengu MCHP                                     | Jd7G0NYBTx1 |
| test_973  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Nimikoro                   | DmaLM8WYmWv | Seidu MCHP                                       | uoPC2z9r7Cc |
| test_974  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Tonko Limba                | y5X4mP5XylL | Sellah Kafta MCHP                                | yZPsWcZC9WA |
| test_975  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Jong                       | VCtF1DbspR5 | Semabu MCHP                                      | Dluer5aKZmd |
| test_976  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Tikonko                    | sxRd2XOzFbz | Sembehun 17 CHP                                  | DqfiI6NVnB1 |
| test_977  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Bagruwa                    | jPidqyo7cpF | Sembehun CHC                                     | egjrZ1PHNtT |
| test_978  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Gaura                      | eROJsBwxQHt | Sembehun (Gaura) MCHP                            | Mi4Ax9suQmB |
| test_979  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Gbo                        | YmmeuGbqOwR | Sembehun Mamagewor MCHP                          | lvxIJAb2QJo |
| test_980  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Kandu Lepiema              | K1r3uF6eZ8n | Sembehun MCHP                                    | IWM4eKPJJSc |
| test_981  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Bagruwa                    | jPidqyo7cpF | Sembehunwo MCHP                                  | QaeQJJCmnTS |
| test_982  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Lower Bambara              | hdEuw2ugkVF | Sembeima MCHP                                    | REtQE1gstTf |
| test_983  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Lower Bambara              | hdEuw2ugkVF | Semewebu MCHP                                    | NqTZjfTIsxC |
| test_984  | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Sanda Magbolonthor         | HWjrSuoNPte | Sendugu CHC                                      | OjXNuYyLaCJ |
| test_985  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Niawa                      | uKC54fzxRzO | Sendumei CHC                                     | Jyv7sjpl9bA |
| test_986  | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kamaje                     | LsYpCyYxSLY | Senehun CHC                                      | oLuhRyYPxRO |
| test_987  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Yawbeko                    | CG4QD1HC3h4 | Senehun Gbloh MCHP                               | Efmr3Xo36DR |
| test_988  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Wara Wara Yagala           | EZPwuUTeIIG | Senekedugu MCHP                                  | xX4lIVqF4yb |
| test_989  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Soro-Gbeima                | d9iMR1MpuIO | Sengama MCHP                                     | MBtmOhLs7y1 |
| test_990  | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Malen                      | DfUfwjM9am5 | Sengema CHP                                      | aRXfvyonenP |
| test_991  | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Luawa                      | cM2BKSrj9F9 | Sengema (Luawa) CHP                              | wkYbuEwNWyf |
| test_992  | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Kpanda Kemoh               | aWQTfvgPA5v | Senjehun MCHP                                    | MnfykVk3zin |
| test_993  | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Nimikoro                   | DmaLM8WYmWv | Senjekoro MCHP                                   | tcEjL7gmFJL |
| test_994  | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Magbema                    | QywkxFudXrC | Senthai MCHP                                     | Qr41Mw2MSjo |
| test_995  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Bumpe Ngao                 | BGGmAwx33dj | Serabu (Bumpe Ngao) UFC                          | prNiMdHuaaU |
| test_996  | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Bumpe Ngao                 | BGGmAwx33dj | Serabu Hospital Mission                          | Tht0fnjagHi |
| test_997  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Koya (kenema)              | EYt6ThQDagn | Serabu (Koya) CHP                                | wjP03y8OY5k |
| test_998  | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Small Bo                   | vzup1f6ynON | Serabu (Small Bo) CHP                            | Gba5bTc8NIg |
| test_999  | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Mongo                      | OTFepb1k9Db | Serekolia MCHP                                   | ZOZ4s2gTPj7 |
| test_1000 | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Mongo                      | OTFepb1k9Db | Seria MCHP                                       | kzmwOrwmzbW |
| test_1001 | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Bramaia                    | kbPmt60yi0L | Shekaia MCHP                                     | DUDHgE5DECu |
| test_1002 | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kargboro                   | Z9QaI6sxTwW | Shenge CHC                                       | p9KfD6eaRvu |
| test_1003 | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Upper Bambara              | LfTkc0S4b5k | Siama (U. Bamabara) MCHP                         | cWIiusmHULW |
| test_1004 | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Dea                        | lYIM1MXbSYS | Sienga CHP                                       | a1E6QWBTEwX |
| test_1005 | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Imperi                     | XEyIRFd9pct | Sierra Rutile Clinic                             | Bq5nb7UAEGd |
| test_1006 | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Gbane Kandor               | Zoy23SSHCPs | Sindadu MCHP                                     | nurO6U9bOLi |
| test_1007 | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Dembelia Sinkunia          | Mr4au3jR9bt | Sinkunia CHC                                     | IlnqGuxfQAw |
| test_1008 | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Maforki                    | JdqfYTIFZXN | SLC. RHC Port Loko                               | FGbXmz7gTTl |
| test_1009 | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | SLIMS Clinic                                     | gmen7SXL9CU |
| test_1010 | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Jong                       | VCtF1DbspR5 | SLRC (Mattru) Clinic                             | T2Cn45nBY0u |
| test_1011 | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | SLRCS (Bo) Clinic                                | roQ2l7TX0eZ |
| test_1012 | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Magbema                    | QywkxFudXrC | S.L.R.C.S Clinic                                 | JNJIPX9DfaW |
| test_1013 | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | SLRCS (Freetown) Clinic                          | EmTN0L4EAVi |
| test_1014 | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Sengbeh                    | VGAFxBXz16y | SLRCS (Koinadugu) Clinic                         | PLoeN9CaL7z |
| test_1015 | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kholifa Rowalla            | PQZJPIpTepd | SLRCS MCH Clinic                                 | wicmjKI3xiP |
| test_1016 | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | SLRCS (Nongowa) clinic                           | Vnc2qIRLbyw |
| test_1017 | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | BMC                        | ENHOJz3UH5L | SL Red Cross (BMC) Clinic                        | nCh5dBoJVNw |
| test_1018 | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Gbense                     | TQkG0sX9nca | SL Red Cross (Gbense) Clinic                     | BLVKubgVxkF |
| test_1019 | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Gbense                     | TQkG0sX9nca | Small Sefadu MCHP                                | ncGs9vXS36w |
| test_1020 | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Bum                        | iUauWFeH8Qp | Sogballeh MCHP                                   | GKrklllwmbU |
| test_1021 | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Songo CHC                                        | pXDcgDRz8Od |
| test_1022 | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Sulima (Koinadugu)         | PaqugoqjRIj | sonkoya MCHP                                     | SmhR2aaKLjw |
| test_1023 | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Dembelia Sinkunia          | Mr4au3jR9bt | Sonkoya MCHP                                     | WjO2puYKysP |
| test_1024 | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Kpanga Kabonde             | QwMiPiME3bA | Sorbeh Grima MCHP                                | FgYDmGwmpEU |
| test_1025 | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Samu                       | r06ohri9wA9 | Soriebolomia MCHP                                | mkFoaAdosuY |
| test_1026 | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | St Anthony clinic                                | bVZTNrnfn9G |
| test_1027 | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Stella Maries Clinic                             | Ea3j0kUvyWg |
| test_1028 | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Kaffu Bullom               | vn9KJsLyP5f | St. John of God Catholic Clinic                  | RUCp6OaTSAD |
| test_1029 | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Marampa                    | RWvG1aFrr0r | St. John of God Catholic Hospital                | xWIyicUgscN |
| test_1030 | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | St. Joseph CHC                                   | YQ3csPLAlrn |
| test_1031 | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | BMC                        | ENHOJz3UH5L | St. Joseph’s Clinic                              | vv1QJFONsT6 |
| test_1032 | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | St. Luke’s Wellington                            | vxa2YQRGV7I |
| test_1033 | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Lower Banta                | W5fN3G6y1VI | St. Mary’s Clinic                                | M721NHGtdZV |
| test_1034 | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | St Monica’s Clinic                               | jCnyQOKQBFX |
| test_1035 | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Makari Gbanti              | lY93YpCxJqf | Stocco CHP                                       | Zwnfm4rnzbZ |
| test_1036 | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Ribbi                      | gy8rmvYT4cj | Suen CHP                                         | wqbyzbQ78oI |
| test_1037 | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Gbane                      | ajILkI0cfxn | Suga MCHP                                        | KFowGOhmuSL |
| test_1038 | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Kamara                     | kvkDWg42lHR | Sukudu MCHP                                      | Q0HywoaWOcM |
| test_1039 | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Soa                        | iGHlidSFdpu | Sukudu Soa MCHP                                  | EoIjKXqXxi2 |
| test_1040 | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Soro-Gbeima                | d9iMR1MpuIO | Sulima CHP                                       | PfZXxl6Wp3F |
| test_1041 | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Nieni                      | J4GiUImJZoE | Sumbaria MCHP                                    | GvstqlRRnpV |
| test_1042 | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Kpaka                      | zSNUViKdkk3 | Sumbuya Bessima CHP                              | Tc3zugEWdTm |
| test_1043 | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Lugbu                      | kU8vhUkAGaT | Sumbuya CHC                                      | W2KnxOMvmgE |
| test_1044 | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Koya                       | pRHGAROvuyI | Sumbuya MCHP                                     | pUZIL5xBsve |
| test_1045 | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Susan’s Bay MCHP                                 | rJ25bHbIujw |
| test_1046 | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Sussex MCHP                                      | wcHRDp21Lw1 |
| test_1047 | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Tankoro                    | M2qEv692lS6 | Swarray Town MCHP                                | fzBpuujglTY |
| test_1048 | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kowa                       | xIKjidMrico | Tabe MCHP                                        | Zbp8TbiMKVc |
| test_1049 | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Kaffu Bullom               | vn9KJsLyP5f | Tagrin CHC                                       | O63vIA5MVn6 |
| test_1050 | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kori                       | nV3OkyzF4US | Taiama (Kori) CHC                                | e2WgqiasKnD |
| test_1051 | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Yawbeko                    | CG4QD1HC3h4 | Talia CHC                                        | s5aXfzOL456 |
| test_1052 | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Talia (Nongowa) CHC                              | qIpBLa1SCZt |
| test_1053 | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Mongo                      | OTFepb1k9Db | Tambaliabalia MCHP                               | oNqqmKD0zXj |
| test_1054 | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Barri                      | RzKeCma9qb1 | Tambeyama MCHP                                   | dU3vTbLRLHy |
| test_1055 | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Gbendembu Ngowahun         | BXJdOLvUrZB | Tambiama CHC                                     | agEKP19IUKI |
| test_1056 | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Bumpe Ngao                 | BGGmAwx33dj | Taninahun (BN) CHP                               | kEkU53NrFmy |
| test_1057 | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Malen                      | DfUfwjM9am5 | Taninahun (Malen) CHP                            | UgYg0YW7ZIh |
| test_1058 | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Barri                      | RzKeCma9qb1 | Taninahun MCHP                                   | Fhko00f3hXT |
| test_1059 | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Dasse                      | RndxKqQGzUl | Taninihun Kapuima MCHP                           | iHQVo7h7KOQ |
| test_1060 | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kongbora                   | Jiyc4ekaMMh | Taninihun Mboka MCHP                             | Cc9kMNFpGmC |
| test_1061 | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Tassoh MCHP                                      | mW20aiZHqwE |
| test_1062 | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Dama                       | myQ4q1W6B4y | Tawahun MCHP                                     | GHPuYdLcVN5 |
| test_1063 | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Gbinleh Dixion             | qIRCo0MfuGb | Tawuya CHP                                       | wy6tbexg2nu |
| test_1064 | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Sandor                     | g5ptsn0SFX8 | Tefeya CHP                                       | nAH0uNc3b5f |
| test_1065 | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Komboya                    | JdhagCUEMbj | Teibor MCHP                                      | kFur7xPhpH9 |
| test_1066 | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Kwamabai Krim              | HV8RTzgcFH3 | Tei CHP                                          | PeyblWrhOwL |
| test_1067 | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Bombali Sebora             | KKkLOTpMXGV | Teko Barracks Clinic                             | OuwX8H2CcRO |
| test_1068 | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Jaiama Bongor              | daJPPxtIrQn | Telu CHP                                         | erqWTArTsyJ |
| test_1069 | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Tengbewabu MCHP                                  | gfWvbbgdjoS |
| test_1070 | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Wara Wara Bafodia          | XrF5AvaGcuw | Thellia CHP                                      | oiSllOTiHNx |
| test_1071 | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Tankoro                    | M2qEv692lS6 | The White House Clinic                           | AhnK8hb3JWm |
| test_1072 | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Thompson Bay MCHP                                | BzEwqabuW19 |
| test_1073 | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Sogbini                    | cgOy0hRMGu9 | Tihun CHC                                        | ua5GXy2uhBR |
| test_1074 | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Tikonko                    | sxRd2XOzFbz | Tikonko CHC                                      | KYXbIQBQgP1 |
| test_1075 | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Gaura                      | eROJsBwxQHt | Tikonko (gaura) MCHP                             | DKZnUSfwjKx |
| test_1076 | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Tonko Limba                | y5X4mP5XylL | Timbo CHP                                        | svCLFkT99Yx |
| test_1077 | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Dema                       | DNRAeXT9IwS | Tissana CHC                                      | CFPrsD3dNeb |
| test_1078 | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Tissana MCHP                                     | SptGAcmbgPz |
| test_1079 | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Small Bo                   | vzup1f6ynON | Tobanda CHC                                      | PQEpIeuSTCN |
| test_1080 | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Tokeh MCHP                                       | GGDHb8xd8jc |
| test_1081 | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Dama                       | myQ4q1W6B4y | Tokpombu (Dama) CHP                              | zw5ppT2dwZy |
| test_1082 | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Tokpombu MCHP                                    | IFXdzAk7hKi |
| test_1083 | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Tombo CHC                                        | JrSIoCOdTH2 |
| test_1084 | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Kamara                     | kvkDWg42lHR | Tombodu CHC                                      | lxxASQqPUqd |
| test_1085 | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Mambolo                    | xGMGhjA3y6J | Tombo Wallah CHP                                 | VFF7f43dJv4 |
| test_1086 | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Lower Bambara              | hdEuw2ugkVF | Tongo Field CHC                                  | K3jhn3TXF3a |
| test_1087 | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Nimikoro                   | DmaLM8WYmWv | Tongorma MCHP                                    | RwkdG4Pku2x |
| test_1088 | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Tankoro                    | M2qEv692lS6 | Tongoro MCHP                                     | iIpPPnnzDo6 |
| test_1089 | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Bombali Sebora             | KKkLOTpMXGV | Tonko Maternity Clinic                           | uNEhNuBUr0i |
| test_1090 | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Makari Gbanti              | lY93YpCxJqf | Tonkomba MCHP                                    | xIMxph4NMP1 |
| test_1091 | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Kwamabai Krim              | HV8RTzgcFH3 | Topan CHP                                        | hjqgB6hEdl3 |
| test_1092 | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Gorama Kono                | GWTIxJO9pRo | Torkpumbu MCHP                                   | RJpiHpefEUw |
| test_1093 | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Bum                        | iUauWFeH8Qp | Torma Bum CHP                                    | rZkUcho9Z65 |
| test_1094 | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Baoma                      | vWbkYPRmKyS | Tugbebu CHP                                      | bG0PlyD0iP3 |
| test_1095 | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Gorama Mende               | KXSqt7jv6DU | Tungie CHC                                       | lpQvlm9czYE |
| test_1096 | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Jong                       | VCtF1DbspR5 | UBC Under 5                                      | PdGktj8bAML |
| test_1097 | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | BMC                        | ENHOJz3UH5L | UFC Bonthe                                       | gGv9ATEs68L |
| test_1098 | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kholifa Rowalla            | PQZJPIpTepd | UFC Magburaka                                    | w9FJ9oAdFys |
| test_1099 | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Njaluahun                  | ERmBhYkhV6Y | UFC Nixon Hospital                               | JCXEtUDYyp9 |
| test_1100 | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | UFC Nongowa                                      | XQudzejlhJZ |
| test_1101 | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Maforki                    | JdqfYTIFZXN | UFC Port Loko                                    | SHLY5rkOFTQ |
| test_1102 | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kori                       | nV3OkyzF4US | UMC Clinic Taiama                                | Qw7c6Ckb0XC |
| test_1103 | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Nimikoro                   | DmaLM8WYmWv | UMC Mitchener Memorial Maternity & Health Centre | g5A3hiJlwmI |
| test_1104 | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | UMC (Urban Centre) Hospital                      | vSbt6cezomG |
| test_1105 | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Luawa                      | cM2BKSrj9F9 | Under five (Luawa) Clinic                        | IXJg79fclDm |
| test_1106 | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Magbema                    | QywkxFudXrC | Under Fives Clinic                               | mTNOoGXuC39 |
| test_1107 | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | UNIMUS MCHP                                      | UugO8xDeLQD |
| test_1108 | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Sowa                       | NqWaKXcg01b | Upper Komende MCHP                               | TJA0eGRoRpc |
| test_1109 | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Lugbu                      | kU8vhUkAGaT | Upper Saama MCHP                                 | Ykx8Ovui7g0 |
| test_1110 | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Nongowa                    | KIUCimTXf8Q | Vaahun MCHP                                      | up9gjdODKXE |
| test_1111 | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Kpanga Krim                | YpVol7asWvd | Vaama (kpanga krim) MCHP                         | qAFXoNjlZCB |
| test_1112 | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Barri                      | RzKeCma9qb1 | Vaama MCHP                                       | GjJjES51GvK |
| test_1113 | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Gaura                      | eROJsBwxQHt | Venima CHP                                       | SoXpnYO84eZ |
| test_1114 | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Imperi                     | XEyIRFd9pct | Victoria MCHP                                    | dyn5pihalrJ |
| test_1115 | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Kissi Tongi                | hjpHnHZIniP | Voahun MCHP                                      | wB4tSXlryyO |
| test_1116 | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kori                       | nV3OkyzF4US | Waiima (Kori) MCHP                               | DlLBIHdpaTy |
| test_1117 | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Barri                      | RzKeCma9qb1 | Waiima MCHP                                      | YPSCWmJ3TyN |
| test_1118 | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Soro-Gbeima                | d9iMR1MpuIO | Wai MCHP                                         | zCSWBz2pyMd |
| test_1119 | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Mongo                      | OTFepb1k9Db | Walia MCHP                                       | m0PiiU5BteW |
| test_1120 | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Bumpe Ngao                 | BGGmAwx33dj | Wallehun MCHP                                    | tZxqVn3xNrA |
| test_1121 | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Koya                       | pRHGAROvuyI | Warima MCHP                                      | DXegteybeb5 |
| test_1122 | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Gbonkonlenken              | P69SId31eDp | Warrima MCHP                                     | NqLYdlnK8sc |
| test_1123 | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | Waterloo CHC                                     | VhRX5JDVo7R |
| test_1124 | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Lower Bambara              | hdEuw2ugkVF | Weima CHC                                        | CKkE4GBJekz |
| test_1125 | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Wellbody MCHP                                    | XuGfiry96Bg |
| test_1126 | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Wellington Health Centre                         | Qc9lf4VM9bD |
| test_1127 | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Wesleyan Health Clinic                           | XJ6DqDkMlPv |
| test_1128 | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Wilberforce CHC                                  | EUUkKEDoNsf |
| test_1129 | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Wilberforce MCHP                                 | EDxXfB4iVpY |
| test_1130 | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Freetown                   | C9uduqDZr9d | Wilberforce Military Hospital                    | ui12Hyvn6jR |
| test_1131 | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Tankoro                    | M2qEv692lS6 | Woama MCHP                                       | AtZJOoQiGHd |
| test_1132 | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Kunike Barina              | rXLor9Knq6l | Wonkibor MCHP                                    | Qwzs1iinAI7 |
| test_1133 | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Sandor                     | g5ptsn0SFX8 | Wordu CHP                                        | bW5BaqrBM4K |
| test_1134 | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Buya Romende               | Pc3JTyqnsmL | Woreh Bana MCHP                                  | DVjewuIdgMN |
| test_1135 | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Penguia                    | bQiBfA2j5cw | Woroma CHP                                       | v0dXACseLuB |
| test_1136 | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Gbinleh Dixion             | qIRCo0MfuGb | Worreh MCHP                                      | VSwnkMSAdp7 |
| test_1137 | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Langrama                   | jWSIbtKfURj | Woyama MCHP                                      | fPe1l06MurL |
| test_1138 | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Magbema                    | QywkxFudXrC | Wullah Thenkle MCHP                              | IN2dOk0gY1G |
| test_1139 | Sierra Leone  | ImspTQPwCqd | Kenema         | kJq2mPyFEHo | Langrama                   | jWSIbtKfURj | Yabaima CHP                                      | XbyObqerCya |
| test_1140 | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Baoma                      | vWbkYPRmKyS | Yakaji MCHP                                      | AnXoUM1tfNT |
| test_1141 | Sierra Leone  | ImspTQPwCqd | Kambia         | PMa2VCrupOd | Samu                       | r06ohri9wA9 | Yalieboya CHP                                    | sgcHQEaB40Y |
| test_1142 | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Baoma                      | vWbkYPRmKyS | Yamandu CHC                                      | nX05QLraDhO |
| test_1143 | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Lugbu                      | kU8vhUkAGaT | Yambama MCHP                                     | QDoO5r6Sae7 |
| test_1144 | Sierra Leone  | ImspTQPwCqd | Bombali        | fdc6uOvgoji | Makari Gbanti              | lY93YpCxJqf | Yankasa MCHP                                     | SQz3xtx1Sgr |
| test_1145 | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Diang                      | Lt8U7GVWvSR | Yara MCHP                                        | M9q1wOOsrXp |
| test_1146 | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Neya                       | GFk45MOxzJJ | Yarawadu MCHP                                    | wxMmC45UyNw |
| test_1147 | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Imperi                     | XEyIRFd9pct | Yargoi MCHP                                      | XctPvvWIIcF |
| test_1148 | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Wara Wara Yagala           | EZPwuUTeIIG | Yataya CHP                                       | MErVkzdbsP5 |
| test_1149 | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Gbonkonlenken              | P69SId31eDp | Yeben MCHP                                       | g031LbUPMmh |
| test_1150 | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Fiama                      | CF243RPvNY7 | Yekior MCHP                                      | dBD9OHJFN8u |
| test_1151 | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Gbonkonlenken              | P69SId31eDp | Yele CHC                                         | sesv0eXljBq |
| test_1152 | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Yemoh MCHP                                       | dx4NOnoGtE7 |
| test_1153 | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Kakua                      | U6Kr7Gtpidn | Yemoh Town CHC                                   | RhJbg8UD75Q |
| test_1154 | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Nimikoro                   | DmaLM8WYmWv | Yengema CHC                                      | PA1spYiNZfv |
| test_1155 | Sierra Leone  | ImspTQPwCqd | Bo             | O6uvpzGd5pu | Bumpe Ngao                 | BGGmAwx33dj | Yengema CHP                                      | EFTcruJcNmZ |
| test_1156 | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Bumpeh                     | nOYt1LtFSyU | Yenkissa MCHP                                    | QZ5rmKrVleg |
| test_1157 | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Nieni                      | J4GiUImJZoE | Yiffin CHC                                       | qxbsDd9QYv6 |
| test_1158 | Sierra Leone  | ImspTQPwCqd | Koinadugu      | qhqAxPSTUXp | Sengbeh                    | VGAFxBXz16y | Yiraia CHP                                       | esMAQ4vs4kM |
| test_1159 | Sierra Leone  | ImspTQPwCqd | Port Loko      | TEQlaapDQoK | Kaffu Bullom               | vn9KJsLyP5f | Yongoro CHP                                      | YDDOlgRBEAA |
| test_1160 | Sierra Leone  | ImspTQPwCqd | Tonkolili      | eIQbndfxQMb | Yoni                       | NNE0YMCDZkO | Yonibana MCHP                                    | x5ZxMDvEQUb |
| test_1161 | Sierra Leone  | ImspTQPwCqd | Bonthe         | lc3eMKXaEfw | Sittia                     | g8DdBm7EmUt | Yoni CHC                                         | fAsj6a4nudH |
| test_1162 | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kargboro                   | Z9QaI6sxTwW | Yorgbofore MCHP                                  | TGRCfJEnXJr |
| test_1163 | Sierra Leone  | ImspTQPwCqd | Western Area   | at6UHUQatSo | Rural Western Area         | qtr8GGlm4gg | York CHC                                         | xa4F6gesVJm |
| test_1164 | Sierra Leone  | ImspTQPwCqd | Kono           | Vth0fbpFcsO | Sandor                     | g5ptsn0SFX8 | Yormandu CHC                                     | roGdTjEqLZQ |
| test_1165 | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kargboro                   | Z9QaI6sxTwW | Youndu CHP                                       | hDW65lFySeF |
| test_1166 | Sierra Leone  | ImspTQPwCqd | Kailahun       | jUb8gELQApl | Mandu                      | yu4N82FFeLm | Yoyah CHP                                        | Urk55T8KgpT |
| test_1167 | Sierra Leone  | ImspTQPwCqd | Moyamba        | jmIPBj66vD6 | Kaiyamba                   | USQdmvrHh1Q | Yoyema MCHP                                      | VdXuxcNkiad |
| test_1168 | Sierra Leone  | ImspTQPwCqd | Pujehun        | bL4ooGhyHRQ | Makpele                    | BD9gU0GKlr2 | Zimmi CHC                                        | BNFrspDBKel |

``` r
# GET THE LIST OF ALL PROGRAMS
programs <- get_programs(login = dhis2_login)
```

| displayName                                         | id          | type      |
|:----------------------------------------------------|:------------|:----------|
| 2026316 COVID Patient Tracker                       | MzhqB3DL12f | tracker   |
| 2026316 COVID Screening Event Program               | x0J4tg624T8 | aggregate |
| 2333013\_ COVID Patient Tracker                     | RuhqpgVhujg | tracker   |
| Antenatal care visit                                | lxAQ7Zs9VYR | aggregate |
| Child Programme                                     | IpHINAT79UW | tracker   |
| Contraceptives Voucher Program                      | kla3mAPgvCH | aggregate |
| Household Tracker                                   | LAdz1P6aCW3 | tracker   |
| Information Campaign                                | q04UBOqq3rp | aggregate |
| Inpatient morbidity and mortality                   | eBAyeGv0exc | aggregate |
| Malaria case diagnosis, treatment and investigation | qDkgAbB5Jlk | tracker   |
| Malaria case registration                           | VBqh0ynB2wv | aggregate |
| Malaria focus investigation                         | M3xtLkYBlKI | tracker   |
| Malaria Rapid Test Screening_EF_HD                  | gJWtasl9T99 | aggregate |
| MALARIA RAPID TEST SCREENING_HS_HD                  | tgYZZpKVud4 | aggregate |
| MALARIA SCREENING VISIT_HS_HD                       | BbnH2uPbpmM | aggregate |
| Malaria testing and surveillance                    | bMcwwoVnbSR | aggregate |
| MNCH / PNC (Adult Woman)                            | uy2gU8kT1jF | tracker   |
| Provider Follow-up and Support Tool                 | fDd25txQckK | tracker   |
| TB program                                          | ur1Edk5Oe2n | tracker   |
| WHO RMNCH Tracker                                   | WSGAb5XwJ3Y | tracker   |
| XX MAL RDT - Case Registration                      | MoUd5BTQ3lY | aggregate |

Similarly, users can also access the list of all data elements and
program stages from a given DHIS2 instance as shown in the code chunks
below.

``` r
# GET THE LIST OF ALL DATA ELEMENTS
data_elements <- get_data_elements(login = dhis2_login)
```

| name                                                                                                     | id          |
|:---------------------------------------------------------------------------------------------------------|:------------|
| 2020316 Confirmed Cases                                                                                  | QCoeWCaPcFU |
| 2026316 Confirmed Cases                                                                                  | gPqr3PdHjP3 |
| 2026316 Cough                                                                                            | Z644Otnwrdw |
| 2026316 Deaths                                                                                           | mh106wu0ZdR |
| 2026316 Dose Number                                                                                      | B4ttLXGhWpH |
| 2026316 Fever                                                                                            | A0PTf8SE9Yv |
| 2026316 Hospital Admissions                                                                              | I6wA2Dme3Yc |
| 2026316 Hospitalized                                                                                     | WtbehR8508a |
| 2026316 ICU Admissions                                                                                   | qvFdQ6gVdtP |
| 2026316 ICU Required                                                                                     | qx0cS7wkFuH |
| 2026316 Oxygen Level                                                                                     | fjbZd5vnlyt |
| 2026316 Oxygen Level (%)                                                                                 | X9hpPdUCJep |
| 2026316 Patient Status                                                                                   | RxUFJL0dFGD |
| 2026316 Positive Results                                                                                 | PaoL2wE1bao |
| 2026316 Recovered Cases                                                                                  | zQeRWjbHKUU |
| 2026316 Suspected Cases                                                                                  | myK95ve8px0 |
| 2026316 Symptom Severity                                                                                 | HV67AaZLjNH |
| 2026316 Symptoms Present                                                                                 | s2VpMoLyjUQ |
| 2026316 Temperature                                                                                      | KPoe9TMI8wn |
| 2026316 Tested Positive                                                                                  | GoNPLpUD8Y4 |
| 2026316 Test Result                                                                                      | R9PC2O1MXmq |
| 2026316 Tests Conducted                                                                                  | cB7VZwH8uHl |
| 2026316 Test Status                                                                                      | GDMbx0iofKn |
| 2026316 Total tested                                                                                     | XtvZkye0Lvl |
| 2026316 Travel History                                                                                   | cN9CXXg219s |
| 2026316 Vaccination Date                                                                                 | trgGJUkOUTp |
| 2026316 Vaccinations                                                                                     | rPuxasbC3i2 |
| 2026316 Vaccination Type                                                                                 | H2f30erCVWV |
| 2026316 Ventilator Patients                                                                              | I7DWK6pK2Hh |
| 2333013_Cough                                                                                            | ak9XZfxN3Ew |
| 2333013_Dose Number                                                                                      | AoiLFBDR7LT |
| 2333013_Fever                                                                                            | w9884kB7VGu |
| 2333013_Hospitalized                                                                                     | HcAj5Ex9u4r |
| 2333013_ICU Required                                                                                     | yKiDdPzaaIv |
| 2333013_Oxygen Level (%)                                                                                 | ODfu6CU81Xe |
| 2333013\_ Patient Status                                                                                 | SFpE4ykfaZ9 |
| 2333013_Symptom Severity                                                                                 | Zw94sJeGM8G |
| 2333013_Test Status                                                                                      | tPeUV2oUt3E |
| 2333013_Vaccination Date                                                                                 | NEhHr2yTAKR |
| 2333013_Vaccine Type                                                                                     | s6u8FVV2Yjz |
| Accute Flaccid Paralysis (Deaths \< 5 yrs)                                                               | FTRrcoaog83 |
| Acute Flaccid Paralysis (AFP) follow-up                                                                  | P3jJH5Tu5VC |
| Acute Flaccid Paralysis (AFP) new                                                                        | FQ2o8UBlcrS |
| Acute Flaccid Paralysis (AFP) referrals                                                                  | M62VHgYT2n0 |
| Additional medication                                                                                    | WO8yRIZb7nb |
| Additional notes related to facility                                                                     | uF1DLnZNlWe |
| Admission Date                                                                                           | eMyVanycQSC |
| Age in years                                                                                             | qrur9Dvnyt5 |
| Age of LLINs                                                                                             | JuTpJ2Ywq5b |
| Albendazole given at ANC (2nd trimester)                                                                 | hCVSHjcml9g |
| All access routes are clearly marked and safe                                                            | rxt7nvPyRUi |
| Allergies (multi-select)                                                                                 | ZxH5QHtTTtX |
| All other follow-ups                                                                                     | RUv0hqER0zV |
| All other new                                                                                            | A2VfEfPflHV |
| All other referrals                                                                                      | laZLQdnucV1 |
| All sterilisation equipment is validated / licensed                                                      | U7v0q0amJqi |
| Anaemia follow-up                                                                                        | jmWyJFtE7Af |
| Anaemia new                                                                                              | HLPuaFB7Frw |
| Anaemia referrals                                                                                        | yqBkn9CWKih |
| An alternative to communicate if telephone line is off is always available                               | sPQgYGhXnXI |
| ANC 1st visit                                                                                            | fbfJHSPpUQD |
| ANC 2nd visit                                                                                            | cYeuwXTCPkU |
| ANC 3rd visit                                                                                            | Jtf34kNZhzP |
| ANC 4th or more visits                                                                                   | hfdmMSPBgLG |
| Animal Bites - Rabid (Deaths \< 5 yrs)                                                                   | LjNlMTl9Nq9 |
| Antenatal Care Visits (ANC 1st Visit)##                                                                  | rCFywfC3sGG |
| Antenatal Care Visits (ANC 4+)##                                                                         | nXVCbaNaKLg |
| Appropriate hand washing facilities are available                                                        | a57FmdPj3Zl |
| ARI treated with antibiotics (pneumonia) follow-up                                                       | FHD3wiSM7Sn |
| ARI treated with antibiotics (pneumonia) new                                                             | iKGjnOOaPlE |
| ARI treated with antibiotics (pneumonia) referrals                                                       | XTqOHygxDj5 |
| ARI treated without antibiotics (cough) follow-up                                                        | RF4VFVGdFRO |
| ARI treated without antibiotics (cough) new                                                              | Cm4XUw6VAxv |
| ARI treated without antibiotics (cough) referrals                                                        | oLfWYAJhZb2 |
| ART clients with new adverse clinical event                                                              | NJnhOzjaLYk |
| ART defaulters                                                                                           | aIJZ2d2QgVV |
| ART enrollment stage 1                                                                                   | BOSZApCrBni |
| ART enrollment stage 2                                                                                   | dGdeotKpRed |
| ART enrollment stage 3                                                                                   | eRwOwCpMzyP |
| ART enrollment stage 4                                                                                   | zYkwbCBALhn |
| ART entry point: No diagnostic testing                                                                   | I5MLuG16arn |
| ART entry point: No old patients                                                                         | LVaUdM3CERi |
| ART entry point: No other                                                                                | vJSPn2R6gVe |
| ART entry point: No PMTCT                                                                                | kVOiLDV4OC6 |
| ART entry point: No transfer in                                                                          | HDZOFvdXsqE |
| ART entry point: No transfer out                                                                         | soACnRV9gOI |
| ART entry point: No walk in                                                                              | FTy5pcJZ3yX |
| ART entry point: TB                                                                                      | Yf4u4QOIdsi |
| ART new clients started on ARV                                                                           | QrhlrvV6Xs8 |
| ART No clients who stopped TRT due to adverse clinical status/event                                      | wfKKFhBn0Q0 |
| ART No clients who stopped TRT due to TRT failure                                                        | GMd99K8gVut |
| ART No clients with change of regimen due to drug toxicity                                               | F53rTVTmSuF |
| ART No clients with new adverse drug reaction                                                            | rNEpbBxSyu7 |
| ART No started Opportunist Infection prophylaxis                                                         | CxlYcbqio4v |
| ART treatment stopped due to death                                                                       | ibL7BD2vn2C |
| ART treatment stopped due to loss to follow-up                                                           | TyQ1vOHM6JO |
| BCG doses given                                                                                          | s46m5MS0hxu |
| Birth certificate                                                                                        | uf3svrmp8Oj |
| Blood pressure monitor, electronic or manual available                                                   | nzl75uHiWQO |
| Blood transfusion within 3 months before onset of symptoms                                               | yO0ZIegEsDk |
| BRC - This is a test disaster                                                                            | wmT9kNuPUv3 |
| Burns follow-up                                                                                          | QYBJk7sqc1I |
| Burns new                                                                                                | zMGEd921xd3 |
| Burns referrals                                                                                          | BHvVPwWrrLC |
| Cabin fever                                                                                              | A21lT9x7pmc |
| Case detection                                                                                           | fazCI2ygYkq |
| Case Investigation Conducted By                                                                          | eYApmORDKgx |
| Case species classification                                                                              | lvx6qda7SN0 |
| Cause of death D - others                                                                                | Pd5bZxTS4ql |
| Children from Gen.Paed. ward tested for HIV                                                              | hhevl49MXyA |
| Children from Gen.Paed. ward with positive HIV result                                                    | HL77Pems4Cv |
| Children from TB ward tested for HIV                                                                     | ydvyXLhIbTn |
| Children from TB ward with positive HIV result                                                           | AKJvJehDSb6 |
| Children from TFC tested for HIV                                                                         | xFpppWvT43s |
| Children from TFC with positive HIV result                                                               | KWzP8OWYQL7 |
| Children Fully Immunized##                                                                               | mbaXnyRsUHn |
| Children getting therapeutic feeding                                                                     | qw2sIef52Fu |
| Children HIV 1&2 positive test                                                                           | e73QxJpd88B |
| Children HIV 1 positive test                                                                             | EnsFXKU7LEW |
| Children HIV 2 positive test                                                                             | GhsYeB89HaL |
| Children initiated ARV treatment                                                                         | MWEGBw0pmgU |
| Children on exclusive breastfeeding (HIV Paed.)                                                          | SMrE2ByiyZp |
| Children on replacement feeding (HIV Paed.)                                                              | UMexg4VGfaY |
| Children supplied with food supplemements                                                                | Y53Jcc9LBYh |
| Children with Fever (Suspected Malaria)##                                                                | nkwsPrvf1bp |
| CHO                                                                                                      | LSJ5mKpyEv1 |
| Cholera (Deaths \< 5 yrs)                                                                                | eY5ehpbEsB7 |
| Cholera (Deaths \< 5 yrs) Narrative                                                                      | mxc1T932aWM |
| Client Age_EF_HD                                                                                         | x3rwAV9w6tl |
| CLIENT AGE_HS_HD                                                                                         | uZA1autY4rd |
| Clinical Malnutrition follow-up                                                                          | HJulLfnIAE3 |
| Clinical Malnutrition new                                                                                | TBbCcJfZ91x |
| Clinical Malnutrition referrals                                                                          | oNyB0VOXIM8 |
| Clinical status                                                                                          | SzVk2KvkSSd |
| CMC Clients offered information on range of methods exist                                                | LHXqz53TmPe |
| CMC COPE has been introduced at the facility and staff conducted a COPE exercise during the past quarter | OJSkJXzhdU1 |
| CMC Counseling rooms in FP and CAC service units ensure client privacy and confidentiality               | DF0B07U2lPZ |
| CMC Date of clinical monitoring visit                                                                    | rkAZZFGFEQ7 |
| CMC Facility part of health care finance (HCF) board scheme                                              | wokFPoIO3NK |
| CMC Facility receives FP referrals from community health workers                                         | rTYZHPHVULr |
| CMC FP and CAC commodity requests correctly based on previous consumption / stock at hand                | rZiGA1lv7Ah |
| CMC FP and CAC procedure rooms have adequate lighting for the performance of all procedures              | EonDTYTVXxM |
| CMC FP and CAC service units have dedicated hours or space for youth clients                             | LadMythncw2 |
| CMC FP services available - Contraceptive pills                                                          | UysSLXGhwrC |
| CMC FP services available - Female condoms                                                               | ZVqZ600pgzC |
| CMC FP services available - Female Sterilization                                                         | X4SRfUAnrHD |
| CMC FP services available - Implanon                                                                     | xqlapchAEVR |
| CMC FP services available - Injectables (DMPA)                                                           | NKoGfjnFWcE |
| CMC FP services available - IUD                                                                          | XPyixxRoRFF |
| CMC FP services available - Jadelle or Sino-Implant                                                      | k7vxGJER2SH |
| CMC FP services available - Male condoms                                                                 | FNa6RHwtpuV |
| CMC FP services available - Male Sterilization                                                           | dupnnRrJB9g |
| CMC Functioning set-up for decontamination in both FP and CAC service units exist                        | tY33H1Xmbiq |
| CMC IMPLANT INSERTION KITS (functional and in good condition) available                                  | VEsHW11Ee9u |
| CMC IMPLANT REMOVAL KITS (functional and in good condition) available                                    | x7UR3a7PnFC |
| CMC Incentives for staff in the FP or CAC service units to provide FP exist                              | eDO63WfftUO |
| CMC Infection prevention protocol charts are posted in both FP and CAC service units                     | e4r6eLK76M9 |
| CMC IUD KITS (functional and in good condition) available                                                | jhz73zxjuuy |
| CMC IUD REMOVAL KITS (functional and in good condition) available                                        | ozL7F7k4l0S |
| CMC Leak-proof and puncture-proof containers in FP and CAC exist                                         | ShRC4KSdfcw |
| CMC MINILAPAROTOMY KITS (functional and in good condition) available                                     | W87PJK0RlJa |
| CMC Most recent delivery of FP and CAC commodities match the request made through the RRF                | sjir9Ki2vuA |
| CMC MVA KITS (functional and in good condition) available                                                | Els0dBuHtWJ |
| CMC National guidelines and standards for FP and CAC service provision available                         | AX2JjzrU0oU |
| CMC NSV KITS (functional and in good condition) available                                                | KKEYwCcGvfl |
| CMC Post-abortion FP methods provided in CAC unit - Contraceptive pills                                  | A4R8Ns0wtJk |
| CMC Post-abortion FP methods provided in CAC unit - Female condoms                                       | H5q0J5EeytP |
| CMC Post-abortion FP methods provided in CAC unit - Implanon                                             | lLl7dD5jRhg |
| CMC Post-abortion FP methods provided in CAC unit - Injectables (DMPA)                                   | R8X9WHD6Ta9 |
| CMC Post-abortion FP methods provided in CAC unit - IUD                                                  | J6KG9poh1WL |
| CMC Post-abortion FP methods provided in CAC unit - Jadelle or Sino-Implant                              | HcQqfCPHC79 |
| CMC Post-abortion FP methods provided in CAC unit - Male condoms                                         | MqeQ222wxN8 |
| CMC Post-abortion FP methods provided in CAC unit - Other (specify)                                      | otxWZ2s0Iyg |
| CMC Post-abortion FP methods provided through referrals - Contraceptive pills                            | aEgcSZrUD1j |
| CMC Post-abortion FP methods provided through referrals - Female condoms                                 | wpEO1pvc4oS |
| CMC Post-abortion FP methods provided through referrals - Implanon                                       | yEPjrf4pvLF |
| CMC Post-abortion FP methods provided through referrals - Injectables (DMPA)                             | weKxnsPrnTB |
| CMC Post-abortion FP methods provided through referrals - IUD                                            | sIZsJrOtJ8S |
| CMC Post-abortion FP methods provided through referrals - Jadelle or Sino-Implant                        | aponpM6fnJe |
| CMC Post-abortion FP methods provided through referrals - Male condoms                                   | VX6qaS9JEGv |
| CMC Post-abortion FP methods provided through referrals - Other (specify)                                | XktwbHEcOZ5 |
| CMC Post-abortion FP referred other facility - Contraceptive pills                                       | TD9EmYHnJcZ |
| CMC Post-abortion FP referred other facility - Female condoms                                            | nECT8BcbdF6 |
| CMC Post-abortion FP referred other facility - Implanon                                                  | A1wdvOOktNI |
| CMC Post-abortion FP referred other facility - Injectables (DMPA)                                        | OutJUTjR21E |
| CMC Post-abortion FP referred other facility - IUD                                                       | PNAudHvnC29 |
| CMC Post-abortion FP referred other facility - Jadelle or Sino-Implant                                   | GvSDEPwzn1l |
| CMC Post-abortion FP referred other facility - Male condoms                                              | aPRMs8ZWoQe |
| CMC Post-abortion FP referred other facility - Other (specify)                                           | x6Cc96XcRjT |
| CMC Post abortion related services available - E&C/D&C Abortion                                          | XcP6HTlP7Nt |
| CMC Post abortion related services available - E&C/D&C Post-abortion                                     | x3cG1nQrV0d |
| CMC Post abortion related services available - MA Abortion                                               | FAZsjrqfaYk |
| CMC Post abortion related services available - MA Post-abortion                                          | GaDscQKVYrw |
| CMC Post abortion related services available - MVA Abortion                                              | lFEc4Weo8Uw |
| CMC Post abortion related services available - MVA Post-abortion                                         | Fo8lG6JORup |
| CMC Procedure rooms in FP and CAC service units ensure client privacy and confidentiality                | ylTxB8pDdW6 |
| CMC Providers trained and certified both CAC and CC                                                      | mrCQ760kGUu |
| CMC Providers trained and certified comprehensive abortion care (CAC)                                    | mU3ywrD2d24 |
| CMC Providers trained and certified comprehensive contraception (CC)                                     | c30icyuh08j |
| CMC Providers trained and certified postpartum IUD insertion                                             | J6hufb5lO0k |
| CMC Providers trained in youth-friendly services in addition to CC or CAC services                       | ILtncREADfd |
| CMC Provider teams trained and certified PMs                                                             | OZGgl38Z7tC |
| CMC Safe abortion related services available - E&C/D&C Abortion                                          | xN2F50KrWOs |
| CMC Safe abortion related services available - E&C/D&C Post-abortion                                     | edTAupzSt8B |
| CMC Safe abortion related services available - MA Abortion                                               | MYVHFFkdTYi |
| CMC Safe abortion related services available - MA Post-abortion                                          | fmQ8ORZ0eaz |
| CMC Safe abortion related services available - MVA Abortion                                              | EQbayB0ysYj |
| CMC Safe abortion related services available - MVA Post-abortion                                         | QxYJoKrJTZx |
| CMC Signed consent forms for all PM and CAC procedures conducted during the past two months              | nC6ZrPp6F7B |
| CMC Staff in FP/CAC units received a facilitative supervision visit from supervisor past six months      | s5gk8w06vif |
| CMC Staff in the FP, CAC and pharmacy units have been oriented on use of the IPLS for FP and CAC         | P7jdTXzh4ut |
| CMC Sterilization/HLD mechanism in place, such as sterilizer, boiler, autoclave available in FP and CAC  | iyLG1s9EAQ8 |
| CMC Stock-out - Contraceptive pills                                                                      | bZgd4FWFsQI |
| CMC Stock-out - Female condoms                                                                           | SDQMvEIFZJH |
| CMC Stock-out - Implanon                                                                                 | CsORyrmcScJ |
| CMC Stock-out - Injectables (DMPA)                                                                       | lZEg2kLmHnz |
| CMC Stock-out - IUD                                                                                      | wwh5ng6o81Z |
| CMC Stock-out - Jadelle or Sino-Implant                                                                  | fuhMFSpMGzx |
| CMC Stock-out - Male condoms                                                                             | h0RS9WyBGPh |
| CMC Stock-out - Other (specify)                                                                          | es9P4K9xRCF |
| CMC Support provided ABRI III - CC and CAC support                                                       | xV8nAovXuOF |
| CMC Support provided ABRI III - Community referral linkages                                              | KPxUIT1OtGW |
| CMC Support provided ABRI III - Others, specify                                                          | heGCGPwVxfU |
| CMC Support provided ABRI III - PM (FS & NSV)                                                            | xxgP9Pbe70o |
| CMC Support provided ABRI III - PPIUD                                                                    | uCSDy69GLVl |
| CMC Support provided ABRI III - Service integration                                                      | sgcewfdjRRq |
| CMC Support provided ABRI III - Youth-friendly services                                                  | drDdShUJJzi |
| CMC Targets or quotas for service providers in the FP or CAC exist                                       | k5YaukDVwcu |
| CMC Visiting team members (name and organization)                                                        | o5USc1zH5mA |
| CoD - Age of mother in years                                                                             | SvdMvylfTRD |
| CoD - Autopsy conducted                                                                                  | vRT1wJGTvje |
| CoD - Autopsy findings used in certification                                                             | AfPenosN9MU |
| CoD - Birth weight in grams                                                                              | GTYimatiqtP |
| CoD - Cause A is underlying cause                                                                        | xBZ2VsHFHVG |
| CoD - Cause B is underlying cause                                                                        | zm11IWgxKgX |
| CoD - Cause C is underlying cause                                                                        | vDoCf56L9wb |
| CoD - Cause D is underlying cause                                                                        | ohxcCCUJRmJ |
| CoD - Cause of death A (immediate)                                                                       | RU1KXNWlT6S |
| CoD - Cause of death A (immediate) - entity identify                                                     | Ovu3nxFVwRB |
| CoD - Cause of death A (immediate) - others                                                              | okahaacYKqO |
| CoD - Cause of death B                                                                                   | QjFzlJHUD9Y |
| CoD - Cause of death B - entity identify                                                                 | draFmNEP1ID |
| CoD - Cause of death B - others                                                                          | MSYrx2z1f8p |
| CoD - Cause of death C                                                                                   | eRMha7cwC1R |
| CoD - Cause of death C - entity identify                                                                 | GMiHyYq3JlY |
| CoD - Cause of death C - others                                                                          | UboyGYmr19j |
| CoD - Cause of death D                                                                                   | SzLlhusJK6R |
| CoD - Cause of death D - entity identify                                                                 | ddohQFXWz6e |
| CoD - Cause of death Other                                                                               | F7tgJi4Mrh2 |
| CoD - Cause of death Other - entity identify                                                             | lgqnByA6upc |
| CoD - Cause of death Other - others                                                                      | vVU9TucLNL1 |
| CoD- Cause Other is underlying cause                                                                     | rdYmAWuty2c |
| CoD - Completed weeks of pregnancy                                                                       | gskFsDUUv3s |
| CoD - Date of injury                                                                                     | O2HZAuxH8RH |
| CoD - Date of surgery                                                                                    | f3DaU224GDr |
| CoD - Deceased person was pregnant within the last year                                                  | HHSCjcfEoKa |
| CoD - Description of external cause                                                                      | xfrRGCTrsbg |
| CoD - Hours newborn survived                                                                             | lVXgG5rdRxY |
| CoD - Manner of death                                                                                    | BaO1pJKhZJc |
| CoD - Multiple pregnancies                                                                               | UO2nkQCl91t |
| CoD - Periodtype - onset to death - cause A                                                              | dEvMi21KHHh |
| CoD - Periodtype - onset to death - cause B                                                              | HLf4M23Yxop |
| CoD - Periodtype - onset to death - cause C                                                              | TgO3vRHCaNV |
| CoD - Periodtype - onset to death - cause D                                                              | PgkDvnP4oZH |
| CoD - Periodtype - onset to death - cause Other                                                          | pM2nSQ1qRct |
| CoD - Place of occurence of external cause                                                               | do9ClTIpO5Q |
| CoD - Place of occurence of external cause - specify                                                     | xJaJXE64Mwr |
| CoD - Pregnancy conditions                                                                               | emRklq26SUZ |
| CoD - Pregnancy contributed to death                                                                     | LbWJoDtfDn7 |
| CoD - Reason for manual selection of underlying cause                                                    | sJfmq3ueBBI |
| CoD - Reason for surgery (disease or condition)                                                          | YXJsdoaszh3 |
| CoD - Surgery performed last 4 weeks                                                                     | dzGpRK1w7sN |
| CoD - Time from onset to death - cause A                                                                 | QyTACRjivAo |
| CoD - Time from onset to death - cause B                                                                 | Apnx0pnzMUq |
| CoD - Time from onset to death - cause C                                                                 | ZhbIetKpHtd |
| CoD - Time from onset to death - cause D                                                                 | cQTtzqf81UY |
| CoD - Time from onset to death - cause Other                                                             | CdspXgp2mWz |
| CoD - Time from pregnancy                                                                                | Z7yQ9Rm1y4a |
| CoD - Underlying cause of death                                                                          | D1DfTA9Sttb |
| CoD - Underlying cause of death from DORIS tool                                                          | RbHkIAJNO7p |
| CoD - Underlying cause of death - ICD-11                                                                 | Iu7raZhcHn9 |
| CoD - Underlying cause of death - ICD-11 Cause Group                                                     | zwFVJMwggaH |
| CoD - Underlying cause of death - ICD-11 Chapter                                                         | W4lXedV97kG |
| CoD - Underlying cause of death - ICD-11 Result Report from Doris API                                    | cH9NADGoNwU |
| CoD - Underlying cause of death processed by                                                             | YZeiZFyQWKs |
| CoD - Underlying cause of death - Warning from Doris API                                                 | GGBSjMU7nt6 |
| CoD - Was stillborn                                                                                      | QselLsJcB7Z |
| Commodities - Amoxicillin                                                                                | Boy3QwztgeZ |
| Commodities - Antenatal Corticosteroids                                                                  | d9vZ3HOlzAd |
| Commodities - Chlorhexidine                                                                              | WjDoIR27f31 |
| Commodities - Emergency Contraception                                                                    | BXgDHhPdFVU |
| Commodities - Female Condoms                                                                             | dY4OCwl0Y7Y |
| Commodities - Implants                                                                                   | Dkapzovo8Ll |
| Commodities - Injectable Antibiotics                                                                     | JIazHXNSnFJ |
| Commodities - Magnesium Sulfate                                                                          | o15CyZiTvxa |
| Commodities - Misoprostol                                                                                | f27B1G7B3m3 |
| Commodities - Oral Rehydration Salts                                                                     | Lz8MM2Y9DNh |
| Commodities - Oxytocin                                                                                   | hJNC4Bu2Mkv |
| Commodities - Resuscitation Equipment                                                                    | W1XtQhP6BGd |
| Commodities - Zinc                                                                                       | TCfIC3NDgQK |
| Community Health Assistant (CHA)                                                                         | vBu1MTGwcZh |
| Complicated deliveries in community live birth                                                           | tn3p7vIxoKY |
| Complicated deliveries in community still births                                                         | FE82N2sA0YI |
| Complicated deliveries in PHU live birth                                                                 | R1WAv9bVXff |
| Complicated deliveries in PHU still births                                                               | ncEnqRPHFvk |
| Confirmed Malaria Cases##                                                                                | MTkUAFPBGhJ |
| Confirmed Malaria Cases+EF                                                                               | HD2026GS002 |
| Confirmed Malaria Cases HDOI                                                                             | i9PBIbXDCcN |
| Country traveled to                                                                                      | f9xYwUwrHq9 |
| Coverage (Response to clear/interrupt transmission and prevent onward infection)                         | gomyQh3Z4Uy |
| Date carried out                                                                                         | A2iV932tYAo |
| Date of assessment                                                                                       | zDDHyXrJkCi |
| Date of Entry_EC_HD                                                                                      | S7dzwWUHBzy |
| Date of Entry_EF_HD                                                                                      | aPYamaXEFbH |
| Date of Entry_FAM_HD                                                                                     | Eqb2TFyVCSN |
| Date of previous classification                                                                          | Ah29MGrnVjJ |
| Date of previous malaria episode                                                                         | Urz28endlF6 |
| Date onset of Symptoms                                                                                   | AZLp9Shoab9 |
| Deaths due to tuberculosis among HIV-negative people (per 100 000 population)                            | V9bT6YUTrMZ |
| Debriefing sessions are part of each resuscitation protocol                                              | DgnwZliJuh5 |
| Development activity present                                                                             | Tj642rK34Qf |
| Development activity type                                                                                | jzksn7lA2ac |
| Diagnosis (ICD-10)                                                                                       | K6uUAvq500H |
| Diarrhoea with blood (Dysentery) follow-up                                                               | vLA3KVFcZIw |
| Diarrhoea with blood (Dysentery) new                                                                     | nymNRxmnj4z |
| Diarrhoea with blood (Dysentery) referrals                                                               | HQv1p570ldT |
| Diarrhoea without severe dehydration follow-up                                                           | nvkbuPrYmDd |
| Diarrhoea without severe dehydration new                                                                 | U3jd8zVFKxY |
| Diarrhoea with severe dehydration follow-up                                                              | ndb4fIRrQbM |
| Diarrhoea with severe dehydration new                                                                    | UfZcabJUVcZ |
| Diarrhoea with severe dehydration referrals                                                              | HpM1I5qc3Pb |
| Discharge Date                                                                                           | msodh3rEMJa |
| Dispenser                                                                                                | EzR5Y2V0JF9 |
| Distance of inhabitants (with malaria) from breeding site                                                | okV7juK4t4M |
| District/block/sub-block                                                                                 | xPs1qQeCRmq |
| Doctor                                                                                                   | nlQztbooKAj |
| Documentation                                                                                            | ulD2zW0TIy2 |
| DOT 3 days                                                                                               | iI24WVP95js |
| Dysentery (Deaths \< 5 yrs)                                                                              | Ix2HsbDMLea |
| EDC Unit Assitant                                                                                        | zSl1hUZBDHY |
| Effectiveness of response                                                                                | NiF6K3MXHsi |
| EHO                                                                                                      | kFmyXB7IYrK |
| EM: Assessed Indicator                                                                                   | QDTUyIOxyKY |
| EM:Source Documents Available                                                                            | so4xfCD39kI |
| EM:Source Documents Complete                                                                             | gUXfdUFljb7 |
| EM:Source Documents within period                                                                        | cU3xY7qf02r |
| Equipment is placed in appropriate reachable areas                                                       | uZJkd96hYCm |
| ER Census reports produced                                                                               | w1G4l0cSxOi |
| ER Children trained on key survival skills                                                               | KFnFpbqDqji |
| ER Teacher accommodation constructed                                                                     | AcXiLSABIOe |
| ER Teachers trained                                                                                      | EX2jDbKe4Yq |
| ER Teacher training programs designed                                                                    | zFFb3bar4Ct |
| ER Teaching materials improved                                                                           | l8gZXKhwawK |
| ER Technical support visits                                                                              | DCSDJH4IFUG |
| ER Visits in schools                                                                                     | oI6YtDaVFcw |
| ER Vulnerable families receiving follow-up visits                                                        | LCmAJHuXaoG |
| ER Workshops conducted                                                                                   | qiaHMoI3bjA |
| Evidence                                                                                                 | PILB3GtIwiJ |
| Examination table with pad                                                                               | cG4A76jrZmp |
| EXP Cars Expense                                                                                         | BDuY694ZAFa |
| EXP Drugs Expense                                                                                        | ixDKJGrGtFg |
| Expected pregnancies                                                                                     | h0xKKjijTdI |
| EXP Salary Expense                                                                                       | M3anTdbJ7iJ |
| EXP Security Expense                                                                                     | dHrtL2a4EcD |
| EXP Sheets Expense                                                                                       | RR538iV9G1X |
| Eye infection follow-up                                                                                  | QV7HsRncdCz |
| Eye infection new                                                                                        | BQI18TPLR7W |
| Eye infection referrals                                                                                  | XfsVSt4zciP |
| Facility Deliveries##                                                                                    | m0lOFL2X3LO |
| Facility has access to running water                                                                     | TLSChlBcw7L |
| Facility has access to stable electrical power                                                           | UMJym1vYPSu |
| Facility has access to stable Internet connectivity                                                      | MJYalhqFsHK |
| FAPH FA&PH: Dead bodies and body parts handled                                                           | AUM8AQYDrpR |
| FAPH FA&PH: Dead bodies and body parts handled (PHEC)                                                    | VzY0wA1odRJ |
| FAPH FA&PH: Gyneobs cases treated or supported                                                           | wvSQFx1doyV |
| FAPH FA&PH: IDPs/ refugees treated as part of First Aid Services                                         | UfoVrB0HTzs |
| FAPH FA&PH: Non weapon wounded cases                                                                     | vuVWtJhIgxJ |
| FAPH FA&PH: Non weapon wounded cases (PHEC)                                                              | EHcV6wCY52R |
| FAPH FA&PH: Non weapon-wounded treated as part of First Aid services                                     | lJ6bPVOuXqL |
| FAPH FA&PH: Non weapon-wounded treated as part of First Aid services - Total                             | CM0BNuLYagq |
| FAPH FA&PH: Sexual violence cases treated or supported                                                   | eocReF8DkzK |
| FAPH FA&PH: Weapon-wounded treated as part of First Aid Services                                         | DrXvxJDPPWa |
| FAPH FA&PH: Weapon-wounded treated as part of First Aid Services - Total                                 | hKNBpx9UUH6 |
| Fever                                                                                                    | rzhHSqK3lQq |
| Fever (Last 48 hrs)\_EF_HD                                                                               | LkVbJmWuxle |
| FEVER(LAST 48HRS)\_HS_HD                                                                                 | bnFcQSlfF0X |
| Foci malaria positive                                                                                    | JmZ0m8Q3gwh |
| Foci malaria test                                                                                        | rFQNCGMYud2 |
| Focus date of classification                                                                             | bl7EMKxJIIT |
| Focus final classification                                                                               | fjdU9F6EngS |
| Foetal heart recorded hourly                                                                             | BbE5wGi3gZl |
| Follow-up diagnosis actions                                                                              | UfCjMVB4gFT |
| Follow-up treatment actions                                                                              | ErApFcbWNtV |
| Follow-up vector control action details                                                                  | zgnTlAH4ZOk |
| Follow-up vector control action details 2                                                                | Y14cBKFUsg4 |
| Follow-up vector control action details 3                                                                | pKj8YrNKVda |
| Follow-up vector control action details 4                                                                | E09G4giWspB |
| Follow-up vector control action details 5                                                                | nrVAe60NnBJ |
| Follow-up vector control actions                                                                         | TOxArSXVv3E |
| Follow-up vector control actions 2                                                                       | wNvEmaLLGE2 |
| Follow-up vector control actions 3                                                                       | h0w2rWQVRsQ |
| Follow-up vector control actions 4                                                                       | fHRsTEml7pq |
| Follow-up vector control actions 5                                                                       | Qvb7NExMqjZ |
| Formulaire RH                                                                                            | tAGMdSK8PEE |
| Fully Immunized child                                                                                    | UOlfIjgN8X6 |
| Gender                                                                                                   | oZg33kd9taw |
| Gender_EC_HD                                                                                             | l5MlQ8pRDlZ |
| Gender_FAM_HD                                                                                            | Q6A2uNkdK2S |
| Gender_HSR_HD                                                                                            | rff9FkRj7mS |
| General state of facility                                                                                | sJWqKsx0ghX |
| Geographical features                                                                                    | SaHE38QFFwZ |
| Glucometer is present                                                                                    | y3S3a9e4ugi |
| GPS DataElement                                                                                          | GyJHQUWZ9Rl |
| Grounds are maintained and are safe and clean                                                            | Kjvr9TNOmC1 |
| Height in cm                                                                                             | GieVkTxp4HH |
| HIV: counseling                                                                                          | o0fOD1HLuv8 |
| HIV: currently on care                                                                                   | ZwrIPRUiHEB |
| HIV exposed children tested at 12 months                                                                 | ESGq1GV8YEE |
| HIV exposed children tested at 18 months                                                                 | ECYnLIh3IdU |
| HIV exposed children with positive result at 12 months                                                   | ifTgszmp25q |
| HIV exposed children with positive result at 18 months                                                   | cxkB6Csdae7 |
| HIV exposed infants initiated cotrim from age 6 wks                                                      | dL7MKVOSCUf |
| HIV infected children given cotrim prophylaxis (18m-18y)                                                 | ofqavN7bUXQ |
| HIV Negative_EF_HD                                                                                       | yKQw1Bd9TTr |
| HIV: new on care                                                                                         | veW7w0xDDOQ |
| HIV positive children lost to follow-up                                                                  | PwAOGo407Kq |
| HIV Positive_EF_HD                                                                                       | cw5j4h81ium |
| HIV positive women assessed for ART eligibility by CD4 counting                                          | u6yhzgWPIsj |
| HIV positive women assessed for ART eligibility by clinical staging                                      | CwnEqKR0ebt |
| HIV related deaths (children)                                                                            | pN3V4jZeCmU |
| HIV: testing                                                                                             | R4KStuS8qt7 |
| Household Investigation Conducted By                                                                     | VGASkvkD2Vf |
| Household location                                                                                       | F3ogKBuviRA |
| Household members fever past month                                                                       | rIjZnxmjGpg |
| Household members malaria positive                                                                       | qxWAgIAfZAh |
| Household members tested for malaria                                                                     | y57kkdyw35d |
| Households                                                                                               | VNM6zoPECqd |
| Households included                                                                                      | k0rev4WSffi |
| Households in neighbourhood                                                                              | fPPOb4St6ea |
| Households in neighbourhood where a case was detected                                                    | VOIXEuqBTBI |
| Household sprayed in the past 6 months                                                                   | AeVEKN0zwJJ |
| Households screened                                                                                      | p2NvDm7mWM3 |
| Hypertension follow-up                                                                                   | h0BwBQO9XUf |
| Hypertension new                                                                                         | UXW5hWW8dE1 |
| Hypertension referrals                                                                                   | X5GbcxQCasr |
| IC Activity                                                                                              | f3Rn9XPEQuv |
| IC Age                                                                                                   | Dv7iIitX44Y |
| IC Group Type                                                                                            | UuL3eX8KJHY |
| IC People reached                                                                                        | lsJCUffec9h |
| IC Topic                                                                                                 | deQEw93Vr4j |
| IC Venue                                                                                                 | DvrjjquRrvF |
| IDSR Cholera                                                                                             | UsSUX0cpKsH |
| IDSR Malaria                                                                                             | vq2qO3eTrNi |
| IDSR Measles                                                                                             | YazgqXbizv1 |
| IDSR Plague                                                                                              | HS9zqaBdOQ4 |
| IDSR Yellow fever                                                                                        | noIzB569hTM |
| Index case                                                                                               | QBrhoanBAV5 |
| Infants born to HIV Positive mothers (exposed)                                                           | XB4uzhs4Is4 |
| Infants delivered in the health facility female                                                          | avs8Dhz3OoG |
| Infants delivered in the health facility male                                                            | N9vniUuCcqY |
| Inpatient cases                                                                                          | WHBtsCMZVAE |
| Inpatient deaths                                                                                         | ZRVfMoPKK05 |
| Inpatient malaria cases                                                                                  | p4K11MFEWtw |
| Inpatient malaria deaths                                                                                 | wWy5TE9cQ0V |
| Inpatient Place of Infection                                                                             | S33cRBsnXPo |
| Insured patient                                                                                          | IyAKwL6Zjkl |
| IPT 1st dose given at PHU                                                                                | bqK6eSIwo3h |
| IPT 1st dose given by TBA                                                                                | yTHydhurQQU |
| IPT 2nd dose given at PHU                                                                                | V37YqbqpEhV |
| IPT 2nd dose given by TBA                                                                                | SA7WeFZnUci |
| Iron Folate given at ANC 3rd                                                                             | rbkr8PL0rwM |
| IRS coverage (%)                                                                                         | Pm5sXfeRbzp |
| Laboratory Assistant                                                                                     | eizakNwF2ep |
| Laboratory Technician                                                                                    | v0Shu9zrSh0 |
| Lab results Date                                                                                         | d3ALOzRamhl |
| Lab results type                                                                                         | CPJzbQbFMr5 |
| Lassa fever follow-up                                                                                    | dVdxnTNL2jZ |
| Lassa fever new                                                                                          | NCteyX2xpMf |
| Lassa fever referrals                                                                                    | uz8dqEzuxyc |
| Leprosy follow-up                                                                                        | kqqgh0EOlcA |
| Leprosy new                                                                                              | zAW6b5Owalk |
| Leprosy referrals                                                                                        | KAXjpSLFlhB |
| Lighting and ventilation is observed to be adequate                                                      | X0rTbbFpRTO |
| Live births                                                                                              | gQNFkFkObU8 |
| LLIN coverage (%)                                                                                        | fADIatyOu2g |
| LLINs displayed                                                                                          | JhpYDsTUfi2 |
| LLIN usage (%)                                                                                           | g6tH05ItHEm |
| LLITN given after delivery                                                                               | ntzmpYRSKGg |
| LLITN given at ANC 1st                                                                                   | ybzlGLjWwnK |
| LLITN given at Penta3                                                                                    | z7duEFcpApd |
| Local Case Classification                                                                                | doBYriW7P5a |
| Louse Borne Typhus - Relapsing fever (Deaths \< 5 yrs)                                                   | NpJtsQkMTm3 |
| Low birth weight in community                                                                            | Ce6kAvaHsxR |
| Low birth weight in PHU                                                                                  | DvEF1SdMORa |
| Main breeding site                                                                                       | bW5ZTqkCTHy |
| Main breeding sites                                                                                      | Vbv4EDAeXJl |
| Malaria case classification                                                                              | ElxhP9pTTP6 |
| Malaria confirmed mixed (CI)                                                                             | HUPFagklWaN |
| Malaria confirmed mixed (foci)                                                                           | vYH71AeWNQK |
| Malaria confirmed Pf (CI)                                                                                | jt8mzqlDEjd |
| Malaria confirmed Pf (foci)                                                                              | Xh63x0mfF5o |
| Malaria confirmed Pk (CI)                                                                                | ZB8ZUUsxqsd |
| Malaria confirmed Pk (foci)                                                                              | NMtyvCDiGxh |
| Malaria confirmed Pm (CI)                                                                                | sJ23PICb6Fy |
| Malaria confirmed Pm (foci)                                                                              | qYaI3TszPET |
| Malaria confirmed Po (CI)                                                                                | E2K6KluoF7L |
| Malaria confirmed Po (foci)                                                                              | PaliV83bIb9 |
| Malaria confirmed Pv (CI)                                                                                | ImgnHPhcNYE |
| Malaria confirmed Pv (foci)                                                                              | XjcDg2kOmqf |
| Malaria (Deaths \< 5 yrs)                                                                                | r6nrJANOqMw |
| Malaria (Deaths \< 5 yrs) Narrative                                                                      | a0WhmKHnZ6J |
| Malaria history                                                                                          | cpXwLgQTLeO |
| Malaria inpatient/outpatient                                                                             | E0W0ZTTosXK |
| Malaria Medication                                                                                       | nTMP8Aj1rYA |
| Malaria medication completed                                                                             | uYreHlUd6RL |
| Malaria Outbreak Threshold                                                                               | nXJJZNVAy0Y |
| Malaria positive (people in neighbourhood)                                                               | LvJ1d1ytjfb |
| Malaria positive species                                                                                 | vGxpKVMkmaW |
| Malaria referrals                                                                                        | hnwWyM4gDSg |
| Malaria test                                                                                             | qdjVZojEK8S |
| Malaria tested (people in neighbourhood)                                                                 | r9O7yJrA41g |
| Malaria test result                                                                                      | aY4kB8kS521 |
| Malaria Test Result##                                                                                    | Gc2bhNQon7y |
| Malaria Tests Conducted+EF                                                                               | HD2026GS003 |
| Malaria Tests Conducted HDOI                                                                             | wBdTdSbB14t |
| Malaria treated at PHU with ACT \< 24 hrs f-up                                                           | CecywZWejT3 |
| Malaria treated at PHU with ACT \> 24 hrs f-up                                                           | bVkFujnp3F2 |
| Malaria treated at PHU with ACT \< 24 hrs new                                                            | AFM5H0wNq3t |
| Malaria treated at PHU with ACT \> 24 hrs new                                                            | d92E7cpMvdl |
| Malaria treated at PHU without ACT \< 24 hrs f-up                                                        | iIBbZPAqnMt |
| Malaria treated at PHU without ACT \> 24 hrs f-up                                                        | pgi981WXhas |
| Malaria treated at PHU without ACT \< 24 hrs new                                                         | nmh0BSu3vaV |
| Malaria treated at PHU without ACT \> 24 hrs new                                                         | EGUJY3jQdJ6 |
| Malaria treated in community with ACT \<24 hrs f-up                                                      | TQnDEASFsVH |
| Malaria treated in community with ACT \>24 hrs f-up                                                      | vzcahelbU5s |
| Malaria treated in community with ACT \<24 hrs new                                                       | x8gsvCKjGdZ |
| Malaria treated in community with ACT \>24 hrs new                                                       | kcbTUfABUck |
| Maternal death                                                                                           | FUrCpcvMAmC |
| MCH Aide                                                                                                 | q7QXzNnSstn |
| MCH ANC Visit                                                                                            | g9eOBujte1U |
| MCH Apgar comment                                                                                        | H6uSAMO5WLD |
| MCH Apgar Score                                                                                          | a3kGcGDCuk6 |
| MCH ARV at birth                                                                                         | wQLfBvPrXqq |
| MCH ARVs                                                                                                 | NALlPhMmMTQ |
| MCH BCG dose                                                                                             | bx6fsa0t90x |
| MCH Blood Pressure                                                                                       | KVQpGEjHluk |
| MCH Breast Status                                                                                        | thO0LN2i2OJ |
| MCH CD4 count                                                                                            | XorIxxprsOp |
| MCH Cervix Status                                                                                        | DWcWXE0xO2b |
| MCH Child ARVs                                                                                           | sj3j9Hwc7so |
| MCH Condition of baby on discharge                                                                       | PuakB9BOtIV |
| MCH Condition of mother on discharge                                                                     | Rbv6wcblbxe |
| MCH CTX                                                                                                  | ihOp58eRcG3 |
| MCH Date of Delivery                                                                                     | uxRgo9bGWhX |
| MCH Delivery Comment                                                                                     | tLn2UVJJ9kO |
| MCH DPT dose                                                                                             | pOe0ogW4OWd |
| MCH Family Planning                                                                                      | DBFcMGod0Wy |
| MCH HB                                                                                                   | xjTklbpY6oG |
| MCH HIV Test Type                                                                                        | hDZbpskhqDd |
| MCH Infant Feeding                                                                                       | X8zyunlgUfM |
| MCH Infant HIV Test Result                                                                               | cYGaxwK615G |
| MCH Infant Weight (g)                                                                                    | GQY2lXrypjO |
| MCH IPT dose                                                                                             | lNNb3truQoi |
| MCH Iron/Folic                                                                                           | EzMxXuVww2z |
| MCH ITN                                                                                                  | sMspMpbvDYI |
| MCH Mabendazole                                                                                          | pB5sL7Ts4fb |
| MCH Management of 3rd stage                                                                              | gvrK6CxWTcp |
| MCH Measles dose                                                                                         | FqlgKAG8HOu |
| MCH Mode of Delivery                                                                                     | fIy3fOtkbdS |
| MCH MUAC                                                                                                 | utliJZmDeeC |
| MCH OPV dose                                                                                             | ebaJjqltK5N |
| MCH Penta dose                                                                                           | vTUhAUZFoys |
| MCH PMTCT P                                                                                              | SMo8UtuSF5p |
| MCH PMTCT W                                                                                              | jkKCVlLRsFD |
| MCH Polio dose                                                                                           | uRYRt4fs52Q |
| MCH Results given to caretaker                                                                           | BeynU4L6VCQ |
| MCH Septrin Given                                                                                        | aei1xRjSU2l |
| MCH Status of the Baby (PNC)                                                                             | L9G6ZtxbfjG |
| MCH Syphilis Test                                                                                        | r0VOslrt2RP |
| MCH TB Status                                                                                            | wpKRnvM14KO |
| MCH Tetatus                                                                                              | gAbD3uDVHHh |
| MCH Visit Comment                                                                                        | OuJ6sgPyAbC |
| MCH Vit A                                                                                                | HLmTEmupdX0 |
| MCH Weight (g)                                                                                           | UXz7xuGCEhU |
| MCH WHO Stage                                                                                            | DRGELgdyWk9 |
| MCH Yellow fever dose                                                                                    | rxBfISxXS2U |
| Measles (Deaths \< 5 yrs)                                                                                | f7n9E0hX8qk |
| Measles (Deaths \< 5 yrs) Narrative                                                                      | FaVPxpiCab5 |
| Measles doses given                                                                                      | YtbsuPPo010 |
| Measles follow-up                                                                                        | uCVKV6PGGNB |
| Measles new                                                                                              | GCvqIM3IzN0 |
| Measles referrals                                                                                        | eomLLbWJfcx |
| Mebendazole/Albendazole (for children 12-59 months)                                                      | d5xTg3WR3DP |
| Meningitis (Deaths \< 5 yrs)                                                                             | MSZuQ1mTsia |
| Meningitis/severe bacterial infection follow-up                                                          | bBiAGF9UhUy |
| Meningitis/severe bacterial infection new                                                                | JFFUt8yR2iW |
| Meningitis/severe bacterial infection referrals                                                          | hfuTiKOkuKs |
| Microscopy Result                                                                                        | UheAxQgiyyE |
| Micro +ve species                                                                                        | BRqksRYCj8a |
| Midwife                                                                                                  | OKj6vV8hmTP |
| MNCH ANC Attendance                                                                                      | WQSdEl9xUMA |
| MNCH ANC registrants                                                                                     | iYCGteGcr6Q |
| MNCH Breech/shoulder delivery                                                                            | ijIsjbvXFJL |
| MNCH Caesarean section deliveries                                                                        | DosHq4vnsYv |
| MNCH Cases of anaemia during ANC                                                                         | QhKQD2wHowC |
| MNCH Destructive operations delivery                                                                     | Q8lOv2CAUjf |
| MNCH Heamoglobin checks performed during ANC                                                             | aLF5wmCZrKF |
| MNCH Normal deliveries                                                                                   | SqvCDfGBFzM |
| MNCH vacuum/forceps delivery                                                                             | g9Tso8plX88 |
| Mode of Discharge                                                                                        | fWIAEtYVEGk |
| Months pregnant                                                                                          | Y4EkaFzzGLY |
| Name of Collector_EC_HD                                                                                  | QWwxbHR7jZc |
| Name of Collector_EF_HD                                                                                  | ApL0gpCF5dm |
| Name of Collector_FAM_HD                                                                                 | kFfC2lPvoXp |
| Negative for HIV_EC_HD                                                                                   | rYNQkewD09E |
| Negative for HIV_HSR_HD                                                                                  | HIrOvXjM51c |
| Neonatal Tetanus follow-up                                                                               | sFMVaj1mHBk |
| Neonatal Tetanus new                                                                                     | wcwbN1jR0ar |
| Neonatal Tetanus referrals                                                                               | HFw6q0jUFKI |
| Newborn protected at birth against tetanus (TT2+)                                                        | DUSpd8Jq3M7 |
| New on ABC 300mg + ddI 200mg + IDV 400mg + r 100mg                                                       | PxT44IblPCq |
| New on ABC 300mg + ddI 200mg + LPV/r 133.3/33.3mg                                                        | la1f7sqY9sb |
| New on ART other regimen                                                                                 | lmj0xtl5P6C |
| New on AZT 10mg/ml + 3TC 10mg/ml + NVP 10mg/ml                                                           | xrbIG3L9DdO |
| New on AZT 300mg + 3TC 150mg + ABC 300mg                                                                 | xETRo03ZfOM |
| New on AZT 300mg / 3TC 150mg + EFV 600mg                                                                 | tZLjsE0VXrL |
| New on AZT 300mg / 3TC 150mg + NVP 200mg                                                                 | YX1MQLgAD92 |
| New on AZT 300mg + 3TC 150mg + TDF 300mg                                                                 | wIQ5ugpWYUH |
| New on AZT 300mg at 28 wks                                                                               | GgsWqA0YETj |
| New on AZT + 3TC 300mg + 150mg for 7 days                                                                | GNY9KvEmRjy |
| New on AZT + 3TC 300mg + 150mg for 7 days after 36 weeks                                                 | nvsNqhfSSxd |
| New on AZT + 3TC 300mg + 150mg on labour                                                                 | ozmEltb5V8d |
| New on AZT + 3TC + NVP 300mg + 150mg + 200mg                                                             | pVImQlMAla4 |
| New on d4T 30mg + 3TC 100mg + ABC 300mg                                                                  | hoj1wTJT6ZW |
| New on d4T 30mg + 3TC 100mg + TDF 300mg                                                                  | SLcj0Swq8rD |
| New on d4T 30mg + 3TC 150mg + EFV 600mg                                                                  | x98jMXibptT |
| New on d4T 30mg / 3TC 150mg / NVP 200mg                                                                  | o44j6gPqFlA |
| New on d4T / 3TC / NVP 12mg/60mg/100mg                                                                   | YIDKw3om85t |
| New on d4T / 3TC / NVP 6mg/30mg/50mg                                                                     | pq4msirdtpr |
| New on d4T 40mg + 3TC 150mg + EFV 600mg                                                                  | fDkcJaO15aQ |
| New on d4T 40mg / 3TC 150mg / NVP 200mg                                                                  | xUNvvqqhNwz |
| New on Infant NVP 10mg/ml (2mg/kg)                                                                       | uN64b5MivTO |
| New on NVP + AZT + 3TC 10mg/ml (2mg/kg) + 10mg/ml + 10mg/ml for 7 days                                   | D4PywWuIwy0 |
| New on TDF 300mg + ddI 200mg + IDV 400mg + r 100mg                                                       | tnDQ80ycQus |
| New on TDF 300mg + ddI 200mg + LPV/r 133.3mg/33.3mg                                                      | w1554hhXNcq |
| Non-active malaria foci classification                                                                   | ai8q3uo44rl |
| Non-resident district and country                                                                        | OAVNZb2venY |
| Number of deaths due to tuberculosis excluding HIV                                                       | oUlFoAVdLgB |
| Number of prevalent tuberculosis cases                                                                   | LseeuddA4Fp |
| Nursing Aide                                                                                             | DUtltDE5ma1 |
| Onchocerciasis follow-up                                                                                 | BvuQnfq1C4J |
| Onchocerciasis new                                                                                       | DrEOxW8mbbh |
| Onchocerciasis referrals                                                                                 | q9AIeFQD7zj |
| OPV0 doses given                                                                                         | x3Do5e7g4Qo |
| OPV1 doses given                                                                                         | pikOziyCXbM |
| OPV2 doses given                                                                                         | O05mAByOgAv |
| OPV3 doses given                                                                                         | vI2csg55S9C |
| Other additional medication (please specify)                                                             | QjBlbVQ8QR8 |
| Other breeding site                                                                                      | efvdFsY1dme |
| Other diagnosis method (please specify)                                                                  | FxYWTORW4mT |
| Other staff                                                                                              | viFyEk7JmVd |
| Other Symptoms                                                                                           | VUUio5uEiyZ |
| Otitis media follow-up                                                                                   | ArS7VyuL95f |
| Otitis media new                                                                                         | DWLCM68Q7Zl |
| Otitis media referrals                                                                                   | j73ScVBTyP0 |
| Outcome of illness                                                                                       | zXNfOKXRBA9 |
| Outpatient Visits (OPD)##                                                                                | zTPHIglRwjX |
| PCV1 doses given                                                                                         | xc8gmAKfO95 |
| PCV2 doses given                                                                                         | mGN1az8Xub6 |
| PCV3 doses given                                                                                         | L2kxa2IA2cs |
| Penta1 doses given                                                                                       | fClA2Erf6IO |
| Penta2 doses given                                                                                       | I78gJm4KBo7 |
| Penta3 doses given                                                                                       | n6aMJNLdvep |
| People included                                                                                          | DX4LVYeP7bw |
| PFS Date of training (end of training)                                                                   | qpQinIDQ6Uy |
| PFS End-of-training assessment - CAC counseling                                                          | zNXca47AaTh |
| PFS End-of-training assessment - CAC MVA                                                                 | fQMBEt42CSl |
| PFS End-of-training assessment - CC FP counseling                                                        | PfSefJQpg5g |
| PFS End-of-training assessment - CC Implanon insertion                                                   | f2MduVqwPXO |
| PFS End-of-training assessment - CC IUCD insertion                                                       | GXNUsigphqK |
| PFS End-of-training assessment - CC Jadelle insertion                                                    | ROEGWNaasDP |
| PFS End-of-training assessment - PM FP counseling                                                        | Lh9x3J6EF0g |
| PFS End-of-training assessment - PM NSV                                                                  | BLNHqFdGFRv |
| PFS End-of-training assessment - PM Suprapubic minilap                                                   | Y35b9mKPwgz |
| PFS End-of-training assessment - PPIUD FP counseling                                                     | CtpjtJOlix1 |
| PFS End-of-training assessment - PPUID Postplacental IUCD                                                | Kdj9bEhmtER |
| PFS Inadequate client recovery area                                                                      | bTWjEduOv4P |
| PFS Inadequate client recovery area - Discussion off-site management                                     | uYrt6Rjh0q2 |
| PFS Inadequate client recovery area - Discussion on-site management                                      | lsPerCow7QG |
| PFS Inadequate client recovery area - Discussion with provider                                           | qlzHqClWAsG |
| PFS Inadequate counseling room                                                                           | D795f7Ftl5Z |
| PFS Inadequate counseling room - Discussion with off-site management                                     | msiehvzdkh0 |
| PFS Inadequate counseling room - Discussion with on-site management                                      | qv3Ivgr7qA8 |
| PFS Inadequate counseling room - Discussion with provider                                                | OjGY9phCVkF |
| PFS Inadequate procedure room                                                                            | hFbuuBkjut3 |
| PFS Inadequate procedure room - Discussion with off-site management                                      | kSDiqFhUP8P |
| PFS Inadequate procedure room - Discussion with on-site management                                       | zJer0XIW5fV |
| PFS Lack of clinical knowledge                                                                           | zF6StgsGthD |
| PFS Lack of clinical knowledge - Clinical coaching                                                       | DgluqT5CbIp |
| PFS Lack of clinical knowledge - Knowledge update/orientation                                            | OKN6ZG1z7pq |
| PFS Lack of clinical knowledge - Provision of reference materials                                        | ZpvFqxRhFuP |
| PFS Lack of clinical skill                                                                               | Q6vysZzUoPl |
| PFS Lack of clinical skill - Arrangement exchange visit high caseload site                               | ogBU5CfbAUZ |
| PFS Lack of clinical skill - Arrangement for peer mentoring on-site                                      | z8Ay2GaaqpC |
| PFS Lack of clinical skill - Clinical coaching                                                           | lJSMLN5WRDF |
| PFS Lack of clinical standards                                                                           | LDEqL9GokCM |
| PFS Lack of clinical standards - Discussion with off-site management                                     | dGdEEpNb7GW |
| PFS Lack of clinical standards - Discussion with on-site management                                      | uHkibfGqtXg |
| PFS Lack of clinical standards - Provision of job aids/guidelines                                        | HpC2iqyoMR8 |
| PFS Lack of confidence                                                                                   | fgPOFbi37BM |
| PFS Lack of confidence - Arrangement for peer mentoring on-site                                          | VDxTE7l7sc7 |
| PFS Lack of confidence - Clinical coaching                                                               | Ws36Dp6gHA1 |
| PFS Lack of confidence - Encouragement                                                                   | KRJeVOPBy6t |
| PFS Method of contact                                                                                    | GFDKf2idXLV |
| PFS Name of person conducting follow-up                                                                  | e4EMaGSEyV9 |
| PFS Provider provision challenges - CAC                                                                  | IgkWhfPryqt |
| PFS Provider provision challenges - FS                                                                   | Q5725FPinzH |
| PFS Provider provision challenges - Implant                                                              | ihgI4dDwUQT |
| PFS Provider provision challenges - IUD                                                                  | AVC7oJYrZrk |
| PFS Provider provision challenges - NSV                                                                  | WMhpzP6czRF |
| PFS Provider provision challenges - PAFP                                                                 | ZhGKg3ssbmX |
| PFS Provider provision challenges - PPIUD                                                                | UoRMWhj2YIy |
| PFS Service provision 0 - CAC                                                                            | pharIEKZNo0 |
| PFS Service provision 0 - FS                                                                             | IZSvH4lOb1h |
| PFS Service provision 0 - Implant                                                                        | DcsUXIcK8IJ |
| PFS Service provision 0 - IUD                                                                            | rxTX7yNs8Ph |
| PFS Service provision 0 - NSV                                                                            | ypvDEOvkjTx |
| PFS Service provision 0 - PA FP                                                                          | SayYGlKyPCa |
| PFS Service provision 0 - PPIUD                                                                          | ASvofuem7Oa |
| PFS Service provision 1 - CAC                                                                            | M3H9NEMuBix |
| PFS Service provision 1 - FS                                                                             | hca8vQ6jEST |
| PFS Service provision 1 - Implant                                                                        | SKh80FGIVKI |
| PFS Service provision 1 - IUD                                                                            | MUOpAoXRVX9 |
| PFS Service provision 1 - NSV                                                                            | bCBiRLqLjQl |
| PFS Service provision 1 - PA FP                                                                          | vsKP6aojcqL |
| PFS Service provision 1 - PPIUD                                                                          | njV5usO9oNl |
| PFS Service provision 2 - CAC                                                                            | t9NU3SqPvcN |
| PFS Service provision 2 - FS                                                                             | zff1i2Iwk8S |
| PFS Service provision 2 - Implant                                                                        | PKBFrGgUy26 |
| PFS Service provision 2 - IUD                                                                            | pWpQ69deqiv |
| PFS Service provision 2 - NSV                                                                            | QKujt9JlJfn |
| PFS Service provision 2 - PA FP                                                                          | JSovKG6FZNW |
| PFS Service provision 2 - PPIUD                                                                          | cOXBak6pilm |
| PFS Type of training - CAC                                                                               | yqiAt2vL2Oe |
| PFS Type of training - CC                                                                                | wqH05wytdJH |
| PFS Type of training - CC (OJT)                                                                          | Ef3ueStqxJj |
| PFS Type of training - PM                                                                                | gtYt3KpQpW8 |
| PFS Type of training - PPIUD                                                                             | suMqFd2seuA |
| PFS Visit number                                                                                         | Mnkodq2wzlV |
| PH Aide                                                                                                  | dIqx7rdnVc9 |
| Place where transmission occurs                                                                          | Kx7SANA8K1z |
| Plague (Deaths \< 5 yrs)                                                                                 | lXolhoWewYH |
| Plague (Deaths \< 5 yrs) Narrative                                                                       | iT8n0tI3nRW |
| PLHIVs referred for TB screening                                                                         | srXmZTeJxxT |
| PLHIVs referred for TB test (Sputum/CXRay)                                                               | ZydlV51mGuj |
| PLHIVs with a positive TB result                                                                         | oxht1VLqF6x |
| PMTCT discordant partners or couples                                                                     | yMtFhLsbZaL |
| PMTCT expected delivery among HIV+ women                                                                 | ZFC9MdnFHFJ |
| PMTCT HIV exposed children registered during the course of the month                                     | x0PshcPLSk1 |
| PMTCT HIV positive Women received ZDV and 3TC during labor                                               | hxh8X16Gvip |
| PMTCT HIV positive women received ZDV at ANC                                                             | dWqQVwKJTSu |
| PMTCT HIV positive w. received ART for own health                                                        | gnKnwQbY3UK |
| PMTCT infant who received NVP within 72hrs                                                               | wZqi8EXN5x4 |
| PMTCT infant who received ZDV & Lamivudine                                                               | HdQ2QsgMtCc |
| PMTCT male partners tested for HIV                                                                       | WqbXHjN95Xw |
| PMTCT male partners tested HIV positive                                                                  | MIKpDxt5ZvE |
| PMTCT No HIV women who delivered in the health facility (CS)                                             | RoCtZpDLVS7 |
| PMTCT No HIV women who delivered in the health facility (Normal)                                         | tAQe5dZ6wRv |
| PMTCT No of expected HIV exposed children                                                                | rFTnRXMFgxC |
| PMTCT positive w. offered FP during ANC/Post natal                                                       | L4G4X567SeK |
| PMTCT positive w. referred for FP from ANC                                                               | zCPMzMGWyHU |
| PMTCT reported mother death                                                                              | FGdTDgQrsBy |
| PMTCT total expected preg. women for the month                                                           | aO5TCNZ4OOr |
| PMTCT women counselled for infant feeding                                                                | kfSFuD4Q8rF |
| PMTCT women HIV1                                                                                         | fQ46YRJj7Yq |
| PMTCT women HIV1 and HIV2                                                                                | yhrP2vizKlf |
| PMTCT women HIV2                                                                                         | hQkv3NaAjqv |
| PMTCT women HIV positve                                                                                  | TvQ1myd6oTE |
| PMTCT women lost to contact                                                                              | f3vP3dSjUrS |
| PMTCT women received complete ARV for PMTCT                                                              | WQqSx9H0RDf |
| PMTCT women received NVP during labour                                                                   | e87Gl0315MV |
| PMTCT women received post test counselling and result                                                    | OCU92ttHmic |
| PMTCT women received pre- test counselling                                                               | CJKrsPzuY8R |
| PMTCT women received ZDV & 3CT after delivery                                                            | HPZd1WtTArI |
| PMTCT women seen for 1st ANC                                                                             | ONgKakbp7wR |
| PMTCT women tested for HIV                                                                               | fxOM6VBQhBy |
| Population                                                                                               | HDRons6AfbL |
| Population of women of child bearing age (WRA)                                                           | vg6pdjObxsm |
| Porter                                                                                                   | zgeAdnpSY5K |
| Positive For HIV_EC_HD                                                                                   | vbNqdMspbkE |
| Positive for HIV_HSR_HD                                                                                  | MLP7rPOFtfi |
| Postnatal 1st contact (within 1 week)                                                                    | LhoRsqtRn4r |
| Postnatal 2nd contact (at 6 weeks)                                                                       | k1vnEuKnRYE |
| Postnatal Care Visits (PNC within 48 hrs)##                                                              | KQI84Ztdz6G |
| Pregnancy-related complications                                                                          | h8vtacmZL5j |
| Pregnancy-related deaths (6 weeks of birth) 10-19y at PHU                                                | d6GUgNWCDfl |
| Pregnancy-related deaths (6 weeks of birth) 10-19y in comm.                                              | z1q4VpzJvEh |
| Pregnancy-related deaths (6 weeks of birth) 20-35y at PHU                                                | pnMGI9pJTxH |
| Pregnancy-related deaths (6 weeks of birth) 20-35y in comm.                                              | ZuAqHa7ekka |
| Pregnancy-related deaths (6 weeks of birth) 35+ y at PHU                                                 | ZjLFpnq46QF |
| Pregnancy-related deaths (6 weeks of birth) 35+ y in comm.                                               | GHvwvsJzV4x |
| Pregnancy status                                                                                         | DweoXDLChlg |
| Pregnant                                                                                                 | SWfdB5lX0fk |
| Prevalence of tuberculosis (per 100 000 population)                                                      | sTzxtq72Moq |
| Previous classification                                                                                  | V1OnhZYfSa2 |
| Previous vector control intervention                                                                     | iSxGIwA3ZrV |
| Prev. month on ABC 300mg + ddI 200mg + IDV 400mg + r 100mg                                               | D33rH8UHKlZ |
| Prev. month on ABC 300mg + ddI 200mg + LPV/r 133.3/33.3mg                                                | obbSEvaKTyW |
| Prev. month on ART other regimen                                                                         | VZPWjoT6Iyb |
| Prev. month on AZT 10mg/ml + 3TC 10mg/ml + NVP 10mg/ml                                                   | yXZd6HTew4q |
| Prev. month on AZT 300mg + 3TC 150mg + ABC 300mg                                                         | BVU4XA3aL0Y |
| Prev. month on AZT 300mg / 3TC 150mg + EFV 600mg                                                         | rFkRvm5Ns4a |
| Prev. month on AZT 300mg / 3TC 150mg + NVP 200mg                                                         | pgzNTiQwMES |
| Prev. month on AZT 300mg + 3TC 150mg + TDF 300mg                                                         | FOWABOOZtPg |
| Prev. month on AZT 300mg at 28 wks                                                                       | ReljOufQV11 |
| Prev. month on AZT + 3TC 300mg + 150mg for 7 days                                                        | FDpeT1lFQMM |
| Prev. month on AZT + 3TC 300mg + 150mg for 7 days after 36w                                              | deGkTqbpTlS |
| Prev. month on AZT + 3TC 300mg + 150mg on labour                                                         | BI5CBuRJVSV |
| Prev. month on AZT + 3TC + NVP 300mg + 150mg + 200mg                                                     | e1eDe6JsE9j |
| Prev. month on d4T 30mg + 3TC 100mg + ABC 300mg                                                          | oYZug9IEm3Q |
| Prev. month on d4T 30mg + 3TC 100mg + TDF 300mg                                                          | KD5UjA5V16r |
| Prev. month on d4T 30mg + 3TC 150mg + EFV 600mg                                                          | FQhY9n5Ft7t |
| Prev. month on d4T 30mg / 3TC 150mg / NVP 200mg                                                          | ZecQS9lx4j9 |
| Prev. month on d4T / 3TC / NVP 12mg/60mg/100mg                                                           | gyudBBtgGCv |
| Prev. month on d4T / 3TC / NVP 6mg/30mg/50mg                                                             | YknvQAH4LnL |
| Prev. month on d4T 40mg + 3TC 150mg + EFV 600mg                                                          | XVzfK55tu7h |
| Prev. month on d4T 40mg / 3TC 150mg / NVP 200mg                                                          | Sdfo0RBu1W3 |
| Prev. month on Infant NVP 10mg/ml (2mg/kg)                                                               | iri7NSiuRc3 |
| Prev. month on NVP + AZT + 3TC 10mg/ml (2mg/kg) + 10mg/ml + 10mg/ml for 7 days                           | CUVDjGzRmmU |
| Prev. month on TDF 300mg + ddI 200mg + IDV 400mg + r 100mg                                               | n91IylSb1JQ |
| Prev. month on TDF 300mg + ddI 200mg + LPV/r 133.3mg/33.3mg                                              | cQxY2T8GenX |
| Project: Activity Report                                                                                 | xPTAT98T2Jd |
| Project: Comments                                                                                        | yiAhmn4q7wJ |
| Project: Communications plan                                                                             | xk0krAO2KfJ |
| Project: Feasibility study                                                                               | okVqga4sADb |
| Project: Goals and achievables                                                                           | JXwI2RLVRwa |
| Project: Narrative                                                                                       | qF555AXehEn |
| Project: Plan                                                                                            | b65EIDnbjXf |
| Project: Procurement plans                                                                               | seNDI6rguib |
| Project: Review                                                                                          | hA2cfVJL4fp |
| Proven insecticide resistance                                                                            | fyjPqlHE7Dn |
| Q_Early breastfeeding (within 1 hr after delivery) at BCG                                                | dU0GquGkGQr |
| Q_Exclusive breastfeeding at time of Penta 3                                                             | pEOVd4Z3TAS |
| Q_LLITN given at time of 2nd Vit A dose                                                                  | Rmixc9wJl0G |
| Q_Slept under LLIN last night Measles                                                                    | GCGfEY82Wz6 |
| Q_Vitamin A received 4-6 months ago at 12-59 dose                                                        | ca8lfO062zg |
| Rabies (Deaths \< 5 yrs)                                                                                 | jVDAvs6kIAP |
| Rapid diagnostic test for Malaria negative                                                               | Qk9nnX0i7lZ |
| Rapid diagnostic test for Malaria positive                                                               | wZwzzRnr9N4 |
| RDT Result+EF                                                                                            | HD2026GS005 |
| RDT Result_EF_HD                                                                                         | DpFJPremltP |
| RDT Result HDOI                                                                                          | x87eMJpm1lw |
| RDT RESULT_HS_HD                                                                                         | czyK2MC3FUd |
| RDT Test Done_EF_HD                                                                                      | W4cGzn4rhfF |
| RDT TEST DONE_HS_HD                                                                                      | lrFrHqXhES7 |
| RDT test result                                                                                          | hKZh1et5n7v |
| Reason for conducting case investigation                                                                 | zFiMMpGyBgr |
| Reason for conducting household investigation                                                            | M2EsgTm4JHu |
| Reason for referral                                                                                      | Zlro25GTcNK |
| Received treatment for both TB and HIV                                                                   | gVfwyHBGWec |
| Receiving ART                                                                                            | A3FR1rkz9D8 |
| Referral Made_EF_HD                                                                                      | T5ApTm43FKx |
| REFERRAL MADE_HS_HD                                                                                      | cF7C45Fx9PL |
| Referral protocol is described                                                                           | qgwWv33YaBj |
| Referred                                                                                                 | MKMyvXshCdB |
| Relationship of cases to residence and breeding site                                                     | Ue0g4Ii4oM8 |
| Remark                                                                                                   | RYXVmlXoFb6 |
| Residence of the malaria case/s that prompted the current case investigation                             | DanTR5x0WDK |
| Residents had malaria past month                                                                         | ECjafwJrxL5 |
| Residents in household                                                                                   | lezQpdvvGjY |
| Residents in household who slept under a net the previous night                                          | KA6RY4BB41F |
| Results of case investigation (parasite prevalence among tested)                                         | AscpjfkjEks |
| Results post-response                                                                                    | xb5oJFjopGD |
| Schistosomiasis follow-up                                                                                | GYm08KsVDOz |
| Schistosomiasis new                                                                                      | Y7Oq71I3ASg |
| Schistosomiasis referrals                                                                                | l76gpVSWoSE |
| SECHN                                                                                                    | hkfMucdRMQG |
| Security worker                                                                                          | iVla5mEZiZo |
| Sex_EF_HD                                                                                                | iXz7pdb7UnF |
| SEX_HS_HD                                                                                                | b8Jr6f4B8Ak |
| Shift from ABC 300mg + ddI 200mg + IDV 400mg + r 100mg                                                   | hI7NM78r3Rg |
| Shift from ABC 300mg + ddI 200mg + LPV/r 133.3/33.3mg                                                    | lznF009R6XI |
| Shift from ART other regimen                                                                             | Jw8BIUYVMGE |
| Shift from AZT 10mg/ml + 3TC 10mg/ml + NVP 10mg/ml                                                       | t6YgakIbFif |
| Shift from AZT 300mg + 3TC 150mg + ABC 300mg                                                             | gSD3Znye1hY |
| Shift from AZT 300mg / 3TC 150mg + EFV 600mg                                                             | jHxFwWMbXT2 |
| Shift from AZT 300mg / 3TC 150mg + NVP 200mg                                                             | pSHgU0Wf4ir |
| Shift from AZT 300mg + 3TC 150mg + TDF 300mg                                                             | MeAvt39JtqN |
| Shift from AZT 300mg at 28 wks                                                                           | LJBV91hapop |
| Shift from AZT + 3TC 300mg + 150mg for 7 days                                                            | Mow8dnhE6FJ |
| Shift from AZT + 3TC 300mg + 150mg for 7 days after 36w                                                  | supsI55QU7E |
| Shift from AZT + 3TC 300mg + 150mg on labour                                                             | q9CskFaFGE6 |
| Shift from AZT + 3TC + NVP 300mg + 150mg + 200mg                                                         | AzwEuYfWAtN |
| Shift from d4T 30mg + 3TC 100mg + ABC 300mg                                                              | ZGKUt190yEn |
| Shift from d4T 30mg + 3TC 100mg + TDF 300mg                                                              | a7Pue4ht1n1 |
| Shift from d4T 30mg + 3TC 150mg + EFV 600mg                                                              | ksGURIlASZB |
| Shift from d4T 30mg / 3TC 150mg / NVP 200mg                                                              | mmHNj6THZNH |
| Shift from d4T / 3TC / NVP 12mg/60mg/100mg                                                               | iCGDtgPA28k |
| Shift from d4T / 3TC / NVP 6mg/30mg/50mg                                                                 | tlSucW8wn23 |
| Shift from d4T 40mg + 3TC 150mg + EFV 600mg                                                              | BtXmKYNBc3k |
| Shift from d4T 40mg / 3TC 150mg / NVP 200mg                                                              | dAnZOL5kxlK |
| Shift from Infant NVP 10mg/ml (2mg/kg)                                                                   | Z5uEjG9zJNK |
| Shift from NVP + AZT + 3TC 10mg/ml (2mg/kg) + 10mg/ml + 10mg/ml for 7 days                               | HmBwa7GWGRG |
| Shift from TDF 300mg + ddI 200mg + IDV 400mg + r 100mg                                                   | y6noHe7ltxY |
| Shift from TDF 300mg + ddI 200mg + LPV/r 133.3mg/33.3mg                                                  | oJLoUSMs3Ud |
| Shift to ABC 300mg + ddI 200mg + IDV 400mg + r 100mg                                                     | hUSSNufoUQz |
| Shift to ABC 300mg + ddI 200mg + LPV/r 133.3/33.3mg                                                      | PBXQFnb2AOk |
| Shift to ART other regimen                                                                               | DlZORv7kWSl |
| Shift to AZT 10mg/ml + 3TC 10mg/ml + NVP 10mg/ml                                                         | vhT3YzTev3B |
| Shift to AZT 300mg + 3TC 150mg + ABC 300mg                                                               | PNlOOplRNOp |
| Shift to AZT 300mg / 3TC 150mg + EFV 600mg                                                               | XMsORYe4ZcA |
| Shift to AZT 300mg / 3TC 150mg + NVP 200mg                                                               | kxcIr99QcAO |
| Shift to AZT 300mg + 3TC 150mg + TDF 300mg                                                               | NV0OXpHu6x4 |
| Shift to AZT 300mg at 28 wks                                                                             | AyLbN9fhY4W |
| Shift to AZT + 3TC 300mg + 150mg for 7 days                                                              | zTWitarSrae |
| Shift to AZT + 3TC 300mg + 150mg for 7 days after 36w                                                    | jYYxzqd1dqM |
| Shift to AZT + 3TC 300mg + 150mg on labour                                                               | IJ4yZ027EmK |
| Shift to AZT + 3TC + NVP 300mg + 150mg + 200mg                                                           | YgsAnqU3I7B |
| Shift to d4T 30mg + 3TC 100mg + ABC 300mg                                                                | YTmhoGBxE2m |
| Shift to d4T 30mg + 3TC 100mg + TDF 300mg                                                                | yB3qDR4Mlqk |
| Shift to d4T 30mg + 3TC 150mg + EFV 600mg                                                                | qUY0i7PnaLS |
| Shift to d4T 30mg / 3TC 150mg / NVP 200mg                                                                | V651s5yIbnR |
| Shift to d4T / 3TC / NVP 12mg/60mg/100mg                                                                 | EEEu3r8z1Rg |
| Shift to d4T / 3TC / NVP 6mg/30mg/50mg                                                                   | eCIPNNYj9ZM |
| Shift to d4T 40mg + 3TC 150mg + EFV 600mg                                                                | a5MxE5H7d3q |
| Shift to d4T 40mg / 3TC 150mg / NVP 200mg                                                                | C6yhZddXLCX |
| Shift to Infant NVP 10mg/ml (2mg/kg)                                                                     | E7QJ0voitk7 |
| Shift to NVP + AZT + 3TC 10mg/ml (2mg/kg) + 10mg/ml + 10mg/ml for 7 days                                 | un5mkYkVKqV |
| Shift to TDF 300mg + ddI 200mg + IDV 400mg + r 100mg                                                     | ZgIaamZjBjz |
| Shift to TDF 300mg + ddI 200mg + LPV/r 133.3mg/33.3mg                                                    | aJ9oon0aJ87 |
| Skin infection follow-up                                                                                 | i0vXh1P92m3 |
| Skin infection new                                                                                       | Y4cFzB4A9ZQ |
| Skin infection referrals                                                                                 | AoVvYq5mtLL |
| Sleeping places                                                                                          | QtZBHQORAvK |
| Slept away from usual residence before first symptoms                                                    | dHwY9LwU21J |
| SRN                                                                                                      | nu3vYkWgl2x |
| STI - Genital Discharge follow-up                                                                        | tl03DMc49UT |
| STI - Genital Discharge new                                                                              | CN9Oxawn7bD |
| STI - Genital Discharge referrals                                                                        | bcxWMsa1ZwU |
| STI - Genital Ulcer follow-up                                                                            | RZNJFsg7fQp |
| STI - Genital Ulcer new                                                                                  | IeO1sWXVyp6 |
| STI - Genital Ulcer referrals                                                                            | saMXNnGMaBw |
| Still births                                                                                             | HZSdnO5fCUc |
| Stock PHU discarded BCG                                                                                  | cZnQDuF3IDz |
| Stock PHU discarded Measles                                                                              | FvKdfA2SuWI |
| Stock PHU discarded OPV                                                                                  | WVrH6j3Wfye |
| Stock PHU dispensed BCG                                                                                  | p1MDHOT6ENy |
| Stock PHU dispensed Measles                                                                              | lVknokmR4Ip |
| Stock PHU dispensed OPV                                                                                  | FTINmL2lehN |
| Stock PHU received BCG                                                                                   | axVhq1itoQD |
| Stock PHU received Measles                                                                               | XNrjXqZrHD8 |
| Stock PHU received OPV                                                                                   | nGCLjZDn0Q4 |
| Stock PHU start balance BCG                                                                              | t99PL3gUxIl |
| Stock PHU start balance Measles                                                                          | vEAo4KwsAzl |
| Stock PHU start balance OPV                                                                              | iuSIObmKutb |
| Suspected Malaria Cases_EF                                                                               | HD2026GS001 |
| Suspected Malaria Cases HDOI                                                                             | BkwZkeajb58 |
| Symptoms                                                                                                 | XCMLePzaZiL |
| TB Case Definition                                                                                       | HmkXnHJxcD1 |
| TB Cohort new SS+ completed                                                                              | JFJfrQRwKUH |
| TB Cohort new SS+ cured                                                                                  | LwqtuNuXzMO |
| TB Cohort new SS+ defaulted                                                                              | iGWmygJhJ0W |
| TB Cohort new SS+ died                                                                                   | iwKQb6AzcyA |
| TB Cohort new SS+ failed                                                                                 | iM7agdDyMAv |
| TB Cohort new SS+ registered                                                                             | ax9QMVVaWzT |
| TB Cohort new SS+ trans. in                                                                              | LvVagpDFHVd |
| TB Cohort new SS+ trans out                                                                              | zg2HS37R0S0 |
| TB Disease Classification                                                                                | D7m8vpzxHDJ |
| TB Extra pulmonary TB                                                                                    | tHFKyPb1db7 |
| TB HIV testing done                                                                                      | U5ubm6PPYrM |
| TB Known MDR-TB contact                                                                                  | cVs0TJQDBwT |
| TB lab CD4                                                                                               | Vk1tzSQxvOR |
| TB lab Creatinine                                                                                        | fCXKBdc27Bt |
| Tb lab Glucose                                                                                           | lJTx9EZ1dk1 |
| TB lab Hemoglobin                                                                                        | fTZFU8cWvb3 |
| TB New SS+ cases                                                                                         | PcdVnX3EthS |
| TB No. of suspects screened                                                                              | sVDDqpaKwBH |
| TB Previous use of second-line drugs                                                                     | vAzDOljIN1o |
| TB Referred by community member                                                                          | Vacgoqzb0a9 |
| TB Referred by other                                                                                     | x4KonEdVrf4 |
| TB Referred by private provider                                                                          | BexcJLSBmoI |
| TB Referred by public facility                                                                           | HihtAAbmIKd |
| TB registration group                                                                                    | V7IfAfgOH9c |
| TB Self referral                                                                                         | DfxIW8gECPb |
| TB smear microscopy number of specimen                                                                   | yLIPuJHRgey |
| TB smear microscopy test outcome                                                                         | zocHNQIQBIN |
| TB Smear Negative                                                                                        | NzUztyjtUm2 |
| TB Smear not done                                                                                        | QmqSvR8y1VP |
| TB Smear Positive T.A.I                                                                                  | NRmkLQkTbHw |
| TB Smear Positve Failure                                                                                 | auVPuAdFCmY |
| TB Smear Positve Relapse                                                                                 | uwbLjPhducc |
| TB Started on ART                                                                                        | zJbnrm3kUAk |
| TB Started on CPT                                                                                        | P6hgV2tSIvi |
| TB treatment card                                                                                        | lpHeSOA8GUV |
| Temperature                                                                                              | J7hdx5FCJvG |
| Test approvals (\$)                                                                                      | z3FtmbkiCZ9 |
| Test delete                                                                                              | HxNiYb2Yt1Q |
| Test done \_EC_HD                                                                                        | i49IxFZ0h4H |
| Test Done_EC_HD                                                                                          | JmuwhkokcO3 |
| Test done_FAM_HD                                                                                         | FyLTnPj3LTl |
| Test done_HSR_HD                                                                                         | ZK0sIhPCIwM |
| Tested For HIV_EC_HD                                                                                     | nN7RotSmqh3 |
| Tested For HIV_EF_HD                                                                                     | DaHM1FceI3W |
| Tested for HIV_HSR_HD                                                                                    | ONr1OH4gMoy |
| Tetanus Neonatal (Deaths \< 5 yrs)                                                                       | Vp12ncSU1Av |
| Tetanus (not incl. 0-28 days) follow-up                                                                  | nG0tBc37z0q |
| Tetanus (not incl. 0-28 days) new                                                                        | Uoj2wmnr5Dw |
| Tetanus (not incl. 0-28 days) referrals                                                                  | Bc7pt6MgY0j |
| Tetanus Other (Deaths \< 5 yrs)                                                                          | hM4ya5T2AqX |
| Time of assessment                                                                                       | bOTcPezfyYk |
| Timing of case/s with and local transmission                                                             | IFgKaK8mSpD |
| Total                                                                                                    | J4ns7DDmKqu |
| Total number of pregnant women attending antenatal care who receive iron & folic acid supplements        | wectpNCENCi |
| Total Population                                                                                         | WUg3MYWQ7pt |
| Total population \< 1 year                                                                               | DTVRnCGamkV |
| Total population \< 5 years                                                                              | DTtCy7Nx5jH |
| Travel comment                                                                                           | i7JwJXVEl2C |
| Travel in last 12 months                                                                                 | hiymQVgVG2v |
| Travel outside province                                                                                  | OhU3RfPlQGR |
| Travel to (last 12 months)                                                                               | ISRUNdE4K1Q |
| Travel to (last 2 weeks)                                                                                 | xoDfSuukvZ9 |
| Travel to (last 6 weeks)                                                                                 | B1zbtdPXMRk |
| Treatment Given+EF                                                                                       | HD2026GS004 |
| Treatment Given_EF_HD                                                                                    | VDnbPB0vEFW |
| Treatment Given HDOI                                                                                     | eY54hHzW6aN |
| TREATMENT GIVEN_HS_HD                                                                                    | spUJ9kx6eJS |
| Treatment Malaria                                                                                        | O7OiONht8T3 |
| TrueOnly                                                                                                 | ROz7HjmtxIg |
| TT1 doses given                                                                                          | zzHwXqxKYy1 |
| TT2 doses given                                                                                          | DUTSJE8MGCw |
| TT3 doses given                                                                                          | jWaNoH0X0Am |
| TT4 doses given                                                                                          | tbudfYMNFS5 |
| TT5 doses given                                                                                          | B2ocYtYkPBD |
| Tuberculosis follow-up                                                                                   | madOetOj4Ye |
| Tuberculosis new                                                                                         | z9dYcQ2DlBG |
| Tuberculosis referrals                                                                                   | hdHLjKFmxB4 |
| Type of population                                                                                       | mtzLOpBltII |
| Typhoid (Deaths \< 5 yrs)                                                                                | Yy9NtNfwYZJ |
| Typhoid fever follow-up                                                                                  | rNi710XHPXY |
| Typhoid fever new                                                                                        | Cj5rTc9nEvl |
| Typhoid fever referrals                                                                                  | LaTxwutQILW |
| Vaccinator                                                                                               | Nz5YtOpDyuV |
| VCCT No positive test HIV1 and HIV2                                                                      | ZjILYaYGEBM |
| VCCT No positive test HIV1 only                                                                          | LicY0q8cagk |
| VCCT No positive test HIV2 only                                                                          | LgYtBqVkADK |
| VCCT No receiving positive test results                                                                  | EASG4IZChNr |
| VCCT No receiving Pre-test counselling                                                                   | IpwsH1GUjCs |
| VCCT No reiciving result & post-test counselling                                                         | CjLP7zAhlP4 |
| VCCT No Test                                                                                             | bmW8ktueArb |
| Vector behavior (based on study)                                                                         | RKJ08MlK5kr |
| Visit Outcome##                                                                                          | pZGdoN7dCeM |
| Vitamin A given at postnatal                                                                             | btSSE4w61kd |
| Vitamin A given to \< 5y                                                                                 | tU7GixyHhsv |
| Voucher HTC                                                                                              | b6dOUjAarHD |
| Voucher IMCI                                                                                             | W7aC8jLASW8 |
| Voucher Implants                                                                                         | fqnXmRYo5Cz |
| Voucher Injections                                                                                       | HrJmqlBqTFG |
| Voucher IUCD                                                                                             | Qz3kfeKgLgL |
| Voucher Pills                                                                                            | UwCXONyUtGs |
| Voucher VMMC                                                                                             | HyJL2Lt37jN |
| Vulnerability                                                                                            | yugu3uQNOg7 |
| Weight                                                                                                   | JINgGHgqzSN |
| Weight for age below lower line (red)                                                                    | bTcRDVjC66S |
| Weight for age between middle and lower line (yellow)                                                    | ldGXl6SEdqf |
| Weight for age on or above middle line (green)                                                           | NLnXLV5YpZF |
| Weight for height 70-79 percent                                                                          | pnL2VG8Bn7N |
| Weight for height 80 percent and above                                                                   | qPVDd87kS9Z |
| Weight for height below 70 percent                                                                       | lVsbKXoF0zX |
| Weight in kg                                                                                             | vV9UWAZohSf |
| WHOMCH Allergies (drugs and/or severe food allergies)                                                    | QFX1FLWBwtq |
| WHOMCH Antihypertensive drug given                                                                       | cKBSkBB3Mt4 |
| WHOMCH Autoimmune disease                                                                                | zzGNbeMnTd6 |
| WHOMCH Blood transfusion                                                                                 | ez86AhQ5cqp |
| WHOMCH Body temperature                                                                                  | L6Toy2TrHHq |
| WHOMCH Calcium supplements given                                                                         | PKZPVfAJfHD |
| WHOMCH CD4 count                                                                                         | B3bDhNpCcEM |
| WHOMCH Chronic conditions                                                                                | de0FEHSIoxh |
| WHOMCH Chronic hypertension                                                                              | UQ2Zo8CruPB |
| WHOMCH Clinical estimate of due date                                                                     | YKXci7Sm0Zq |
| WHOMCH Clinical impression of eclampsia                                                                  | ALfOm7aaH6b |
| WHOMCH Clinical impression of pre-eclampsia                                                              | Mfq2Y9N21KZ |
| WHOMCH Commencement of labour                                                                            | mGHBXrtqSut |
| WHOMCH Conditions in previous pregnancy                                                                  | suhLG4CrzUw |
| WHOMCH Confirmed or suspected infection                                                                  | klEz81wXFoU |
| WHOMCH Continuous supportive presence during labour and birth                                            | z8m3llJYuh9 |
| WHOMCH Contraceptive counselling provided                                                                | QWVRukwa83h |
| WHOMCH Corticostereoid exposure                                                                          | awGGBWPT5yv |
| WHOMCH Date of birth/End of pregnancy                                                                    | u3TE34T4KH0 |
| WHOMCH Date of birth of most recent newborn                                                              | cwgQnkamM2j |
| WHOMCH Date of induction of labor                                                                        | MH33VLmOOqm |
| WHOMCH Date of last TT dose                                                                              | r3BqzOPxAjp |
| WHOMCH Delivery method                                                                                   | spkG704sTh6 |
| WHOMCH Diabetes                                                                                          | Q1x1HIhuwFN |
| WHOMCH Diastolic blood pressure                                                                          | dyYdfamSY2Z |
| WHOMCH Eclamptic convulsions                                                                             | w7enwqzx90I |
| WHOMCH ECV conversion remaining                                                                          | yTDoF5b1OhI |
| WHOMCH ECV offered                                                                                       | QM5d0hfSbKk |
| WHOMCH ECV performed                                                                                     | DCUDZxqOxUo |
| WHOMCH Erythromycin given for PPROM                                                                      | rHgrmXfa57b |
| WHOMCH Erythromycin given for syphillis                                                                  | Js57E09s9fh |
| WHOMCH Estimated blood loss (ml)                                                                         | hib4oz2sOLw |
| WHOMCH Extreme pallor                                                                                    | EyfTU3ibMmJ |
| WHOMCH Fetal heart rate on admission                                                                     | u7aAPS8OgLw |
| WHOMCH Fetal presentation                                                                                | vPdXnmGWzfy |
| WHOMCH Gestational age at visit                                                                          | roKuXYfw1BW |
| WHOMCH Gravidity(previous pregnancies)                                                                   | PuiTfPfSf86 |
| WHOMCH Haematocrit value                                                                                 | X8HbdaoS9LN |
| WHOMCH Heart rate                                                                                        | pwfdgeE21Os |
| WHOMCH Hemoglobin value                                                                                  | vANAXwtLwcT |
| WHOMCH HIV counselling provided - negative                                                               | jRo4KlnCKeX |
| WHOMCH HIV counselling provided - positive                                                               | yEmfXF9HJ1M |
| WHOMCH HIV rapid test                                                                                    | Itl05OEupgQ |
| WHOMCH HIV test results provided to patient                                                              | yq1qT0NdjYQ |
| WHOMCH Hospital / Birth clinic                                                                           | n1rtSHYf6O6 |
| WHOMCH Indication for induction of labour                                                                | D1EHM01p454 |
| WHOMCH Induction of labor                                                                                | MVIV2RGWhUq |
| WHOMCH Induction of labour with vaginal prostaglandin performed at term                                  | oQgcj7kV1c3 |
| WHOMCH Insecticide treated bednet promoted                                                               | NPZPVg2rVh4 |
| WHOMCH Iron and folic acid supplements given                                                             | Kb6kZzUCJi1 |
| WHOMCH LMP date                                                                                          | w4ky6EkVahL |
| WHOMCH Low-dose acetylsalicylic acid given                                                               | OSuxnldV4Ug |
| WHOMCH Malaria prophylaxis given in second trimester                                                     | MHW5v2Iljtw |
| WHOMCH Malaria prophylaxis given in third trimester                                                      | zsWyjzmBLGz |
| WHOMCH Maternal near-miss                                                                                | FIHEeJwfhZH |
| WHOMCH Maternal near-miss by coagulation/haematological dysfunction                                      | i9mEM7ZW7yV |
| WHOMCH Maternal near-miss by other reason                                                                | SojR4V7A8u2 |
| WHOMCH Maternal near-miss by uterine dysfunction                                                         | PQlndpI05Bb |
| WHOMCH Meconium stained liquor                                                                           | YsVHgzQCwmr |
| WHOMCH Medication                                                                                        | fNnOPQj83jz |
| WHOMCH MgSO4 injection given                                                                             | lcaG1Pnh27I |
| WHOMCH Moderate aneamia                                                                                  | FYLMjPQ0wmo |
| WHOMCH Mohammads point                                                                                   | EnalHZFesIv |
| WHOMCH Offered a choice of induction of labour or expectant management                                   | SeXllT5ypsh |
| WHOMCH Ongoing or initiated ARV regimen                                                                  | nhW3SZX9JaN |
| WHOMCH Onset of symptoms in current pregnancy                                                            | WY9LjaUQI1q |
| WHOMCH Other chronic condition                                                                           | xPTngRLQTnu |
| WHOMCH Other chronic condition specified                                                                 | Mh7nK8UKoZP |
| WHOMCH Other medicine allergy                                                                            | dpOtt7HUQXa |
| WHOMCH Other medicine allergy specified                                                                  | VSmOcdK3v7y |
| WHOMCH Other severe allergy                                                                              | ZbDPeYzWsh2 |
| WHOMCH Other severe allergy specified                                                                    | zk4Eui7Jhtr |
| WHOMCH Oxytocin given                                                                                    | BmaBjPQX8ME |
| WHOMCH Pain medication given                                                                             | HUfKCOou7de |
| WHOMCH Parity (previous deliveries)                                                                      | hisxuZstYJM |
| WHOMCH Partograph used                                                                                   | VXdfPQRXKiA |
| WHOMCH Penicillin allergy                                                                                | E6QaDtrQP5e |
| WHOMCH Penicillin given                                                                                  | OhcR0fpFcWa |
| WHOMCH Plurality assessed                                                                                | PN6HcGjTraL |
| WHOMCH Pregnancy outcome                                                                                 | V5PR8Kw8ZnC |
| WHOMCH Previously known HIV-positive                                                                     | VFffa31SKjH |
| WHOMCH Previous modes of delivery                                                                        | W4zW3aPyS0G |
| WHOMCH Previous pregnacy birthweight                                                                     | iwNXUX6KYX0 |
| WHOMCH Previous pregnancy gest.age at birth                                                              | wqpUVEeJR3D |
| WHOMCH Previous pregnancy outcomes                                                                       | mrVkW9h2Rdp |
| WHOMCH Proteinuria (concentration mg/dL)                                                                 | dpiyZz8bkVE |
| WHOMCH Proteinuria (urinstix)                                                                            | a7XjFEuZuKE |
| WHOMCH Recurrent eclamptic seizures                                                                      | vTEkiy8F3yj |
| WHOMCH Renal disease                                                                                     | sdchiIXIcCf |
| WHOMCH Respiratory rate                                                                                  | Spl22QJsWeu |
| WHOMCH Retained placenta                                                                                 | PCiOYWXZq2E |
| WHOMCH RPR test                                                                                          | AAaJGnWR5js |
| WHOMCH Screening for autoimmune disease performed                                                        | xoji9tjIrIj |
| WHOMCH Screening for chronic hypertension performed                                                      | kRVjK1hrUCe |
| WHOMCH Screening for diabetes performed                                                                  | jTtAqN1pMTY |
| WHOMCH Screening for pre-eclampsia risk factors performed                                                | YrtUVQtPngs |
| WHOMCH Screening for previous pre-eclampsia performed                                                    | rIwYLa8kox3 |
| WHOMCH Screening for renal disease performed                                                             | hH1izHeUNrQ |
| WHOMCH Severe anaemia                                                                                    | AXuzjgLsBy3 |
| WHOMCH Slept under ITN (insecticide treated bednet)                                                      | ytV9rX4ADnn |
| WHOMCH Smoking                                                                                           | sWoqcoByYmD |
| WHOMCH Smoking cessation counselling provided                                                            | Ok9OQpitjQr |
| WHOMCH Speculum examination test result for suspected pPROM                                              | z9auvNRRWQJ |
| WHOMCH Speculum examination test result for suspected PROM                                               | yV91JsUXuju |
| WHOMCH Suspected pPROM                                                                                   | cF0XbuZkUcC |
| WHOMCH Suspected PROM                                                                                    | DwWIh6D3fSr |
| WHOMCH Systolic blood pressure                                                                           | M4HEOoEFTAT |
| WHOMCH Tetanus vaccination status                                                                        | sUX4i7QqbXF |
| WHOMCH Third or fourth degree perineal tear                                                              | cz5DN6BVVeW |
| WHOMCH Treatment for moderate anemia                                                                     | RxVNLSeTjto |
| WHOMCH Treatment for severe anemia                                                                       | nB4Ui3ckmUi |
| WHOMCH Ultrasound estimate of due date                                                                   | DecmCMPDPdS |
| WHOMCH Uterotonics given                                                                                 | m3XQrgadVK9 |
| WHOMCH White blood cell count                                                                            | csl3yq5UC46 |
| Worm infestation follow-up                                                                               | E62UwxnYf26 |
| Worm infestation new                                                                                     | Usk9Asj5DED |
| Worm infestation referrals                                                                               | VmoPqzwBgkx |
| Wounds/Trauma follow-up                                                                                  | yJwdE6XJbrF |
| Wounds/Trauma new                                                                                        | FJs8ZjlQE6f |
| Wounds/Trauma referrals                                                                                  | JMKtVQ5HasH |
| WP1                                                                                                      | zHaIxBfQMZk |
| WP2                                                                                                      | HUYDWrGgTdI |
| XX MAL RDT TRK - Age                                                                                     | vcSXdYGa5St |
| XX MAL RDT TRK - Diagnosis Method                                                                        | lWLkpWMHqEq |
| XX MAL RDT TRK - Diagnosis Type                                                                          | QMLLmxjsFqk |
| XX MAL RDT TRK - Microscopy Result                                                                       | XEuy83qbOvM |
| XX MAL RDT TRK - No tested reason                                                                        | iV67wNwjQuG |
| XX MAL RDT TRK - RDT Result                                                                              | diH9IbKTpHj |
| XX MAL RDT TRK - Reason for not testing                                                                  | DKj79JKpli0 |
| XX MAL RDT TRK - Referral                                                                                | DY1xJukD6nc |
| XX MAL RDT TRK - Sex                                                                                     | YdwvOAN77SV |
| XX MAL RDT TRK - Treatment Mixed                                                                         | zFaeo9trjWb |
| XX MAL RDT TRK - Treatment Pf                                                                            | CLC5VYdZBay |
| XX MAL RDT TRK - Treatment Pv                                                                            | TnCSyYfCaNE |
| XX MAL RDT TRK - Village of Residence                                                                    | rypjN8CV02V |
| Yaws follow-up                                                                                           | plfo9ai1jtW |
| Yaws new                                                                                                 | FF3Ev33BuCh |
| Yaws referrals                                                                                           | gQAAvbLx8MM |
| Yebo                                                                                                     | cNkTt6mJQyO |
| Yellow Fever (Deaths \< 5 yrs)                                                                           | USBq0VHSkZq |
| Yellow Fever (Deaths \< 5 yrs) Narrative                                                                 | rj9mw1J6sBg |
| Yellow Fever doses given                                                                                 | l6byfWFUGaP |
| Yellow fever follow-up                                                                                   | hvdCBRWUk80 |
| Yellow fever new                                                                                         | XWU1Huh0Luy |
| Yellow fever referrals                                                                                   | zSJF2b48kOg |
| YesOnly                                                                                                  | QN8WyI8KgpU |

``` r
# GET THE LIST OF ALL PROGRAM STAGES FOR A GIVEN PROGRAM ID
program_stages <- get_program_stages(
  login = dhis2_login,
  program = "IpHINAT79UW",
  programs = programs
)
```

| program_id  | program_name    | program_stage_name | program_stage_id |
|:------------|:----------------|:-------------------|:-----------------|
| IpHINAT79UW | Child Programme | Birth              | A03MvHHogjR      |
| IpHINAT79UW | Child Programme | Baby Postnatal     | ZzYYXq4fJie      |

It is important to know that not all organisation units are registered
for a specific program. To know the organisation units that run a
particular program, use the
[`get_program_org_units()`](https://epiverse-trace.github.io/readepi/reference/get_program_org_units.md)
function as shown in the example below.

``` r
# GET THE LIST OF ORGANISATION UNITS RUNNING THE SPECIFIED PROGRAM
target_org_units <- get_program_org_units(
    login = dhis2_login,
    program = "IpHINAT79UW",
    org_units = org_units
  )
```

| org_unit_ids | levels        | org_unit_names                                   |
|:-------------|:--------------|:-------------------------------------------------|
| vRC0stJ5y9Q  | Facility_name | Bucksal Clinic                                   |
| simyC07XwnS  | Facility_name | Maforay MCHP                                     |
| E9oBVjyEaCe  | Facility_name | Gbanja Town MCHP                                 |
| ZpE2POxvl9P  | Facility_name | Faabu CHP                                        |
| yTMrs5kClCv  | Facility_name | Condama MCHP                                     |
| FO1Tq8vUa62  | Facility_name | EPI Headquarter                                  |
| jGYT5U5qJP6  | Facility_name | Gbaiima CHC                                      |
| LaxJ6CD2DHq  | Facility_name | EM&BEE Maternity Home Clinic                     |
| WerHl8SDtRU  | Facility_name | Mandema CHP                                      |
| CTnuuI55SOj  | Facility_name | Manewa MCHP                                      |
| RHJram03Rlm  | Facility_name | Makonkondey MCHP                                 |
| IXJg79fclDm  | Facility_name | Under five (Luawa) Clinic                        |
| MHAWZr2Caxw  | Facility_name | Bakeloko CHP                                     |
| gfWvbbgdjoS  | Facility_name | Tengbewabu MCHP                                  |
| m0PiiU5BteW  | Facility_name | Walia MCHP                                       |
| GIRLSZ1tB00  | Facility_name | Kpetema CHP (Toli)                               |
| gfk1TNPI4wN  | Facility_name | Mayombo MCHP                                     |
| MQHszd6K6V5  | Facility_name | Pelewahun MCHP                                   |
| irVdYBmHBxs  | Facility_name | Mbowohun CHP                                     |
| BedE3DKQDFf  | Facility_name | Mokongbetty MCHP                                 |
| fA43H8Ds0Ja  | Facility_name | Momajo MCHP                                      |
| QMnoFLTLpkY  | Facility_name | Kemedugu MCHP                                    |
| mshIal30ffW  | Facility_name | Mapaki CHC                                       |
| scc4QyxenJd  | Facility_name | Makali CHC                                       |
| oolcy5HBlMy  | Facility_name | Hamilton MCHP                                    |
| AiGBODidxPw  | Facility_name | Nyangbe-Bo MCHP                                  |
| QoROdPmIdY1  | Facility_name | Njagbahun (Fakunya) MCHP                         |
| iP4fRh8EHmF  | Facility_name | Foakor MCHP                                      |
| PeyblWrhOwL  | Facility_name | Tei CHP                                          |
| KuGO75X47Gk  | Facility_name | Ngiewahun CHP                                    |
| UAtEKSd5QTf  | Facility_name | Konta (Gorama M) CHP                             |
| RG6MGu5nUlI  | Facility_name | Mapailleh MCHP                                   |
| QsAwd531Cpd  | Facility_name | Njala CHC                                        |
| QDoO5r6Sae7  | Facility_name | Yambama MCHP                                     |
| HVQ6gJE8R24  | Facility_name | Bundulai MCHP                                    |
| rNaQEFRINbd  | Facility_name | Punthun MCHP                                     |
| yP2nhllbQPh  | Facility_name | New Harvest Clinic                               |
| jCnyQOKQBFX  | Facility_name | St Monica’s Clinic                               |
| PqlNXedmh7u  | Facility_name | Lumley Hospital                                  |
| Eyqyhztf8G1  | Facility_name | Ferry CHP                                        |
| kzmwOrwmzbW  | Facility_name | Seria MCHP                                       |
| WxMmxNU6Gla  | Facility_name | Mokaiyegbeh MCHP                                 |
| M3dL6ZAIZ3I  | Facility_name | Gbonkomaria CHP                                  |
| K3k64jslIlL  | Facility_name | EDC Unit CHP                                     |
| cDw53Ej8rju  | Facility_name | Afro Arab Clinic                                 |
| JKdMirJ02nv  | Facility_name | Makona MCHP                                      |
| STv4PP4Hiyl  | Facility_name | Govt. Hosp. Pujehun                              |
| C1zlHePEQe6  | Facility_name | Maforay (B. Sebora) MCHP                         |
| msH78gZ7Fe6  | Facility_name | Royeama CHP                                      |
| QpRIPul20Sb  | Facility_name | Gorahun CHC                                      |
| Xytauldn2QJ  | Facility_name | Dalakuru CHP                                     |
| mt47bcb0Rcj  | Facility_name | Kamabai CHC                                      |
| hoJ0Do9loZl  | Facility_name | Ngogbebu MCHP                                    |
| zpEPGogIr6q  | Facility_name | Nyandehun Nguvoihun CHP                          |
| DSBXsRQSXUW  | Facility_name | Handicap Clinic                                  |
| NJolnlvYgLr  | Facility_name | Kakoya MCHP                                      |
| ywNG86IY4Ve  | Facility_name | Gibena MCHP                                      |
| XjpmsLNjyrz  | Facility_name | Magbaft MCHP                                     |
| EO6ghLtWv4W  | Facility_name | Porpon MCHP                                      |
| AlG0apJE5cm  | Facility_name | Karleh MCHP                                      |
| HcB2W6Fgp7i  | Facility_name | Melekuray CHC                                    |
| lOv6IFgr6Fs  | Facility_name | Manjama Shellmingo CHC                           |
| wxMmC45UyNw  | Facility_name | Yarawadu MCHP                                    |
| koa3hwZZ2i7  | Facility_name | Magbethy MCHP                                    |
| DcmSvQd5N8c  | Facility_name | Kpewama MCHP                                     |
| aXsLBCzwYWW  | Facility_name | Konjo (Dama) CHP                                 |
| XvqLmn4kZXy  | Facility_name | Mano Sewallu CHP                                 |
| F2TAF765q1b  | Facility_name | Kokoru CHP                                       |
| ZALwM386w0T  | Facility_name | Manumtheneh MCHP                                 |
| UWhv0MQOqoB  | Facility_name | Gambia CHP                                       |
| mMvt6zhCclb  | Facility_name | Manjama MCHP                                     |
| nGb94wPdcqx  | Facility_name | Nagbena CHP                                      |
| jVDUkOBCjDy  | Facility_name | Mabontor CHP                                     |
| xt08cuqf1ys  | Facility_name | Mokoba MCHP                                      |
| LOpWauwwghf  | Facility_name | Bambara Kaima CHP                                |
| vPz4Irz7sxR  | Facility_name | Njala CHP                                        |
| TGRCfJEnXJr  | Facility_name | Yorgbofore MCHP                                  |
| YhBJbiD5N1z  | Facility_name | Gbahama (P. Bongre) CHP                          |
| xQIU41mR69s  | Facility_name | Bangambaya MCHP                                  |
| TWH05Rjz6oT  | Facility_name | Gbahama (Makpele) MCHP                           |
| EXbPGmEUdnc  | Facility_name | Mateboi CHC                                      |
| nX05QLraDhO  | Facility_name | Yamandu CHC                                      |
| WAjjFMDJKcx  | Facility_name | Blamawo MCHP                                     |
| jIkxZKctVhB  | Facility_name | Mogbwemo CHP                                     |
| cXOR7vSMBKO  | Facility_name | Kortuma MCHP                                     |
| FGV6TAbL0eN  | Facility_name | Peyima CHP                                       |
| OUPkxfQld8y  | Facility_name | Mansundu (Sandor) MCHP                           |
| D6B4jrCpCwu  | Facility_name | Masoko MCHP                                      |
| jkPHBqdn9SA  | Facility_name | Konda CHP                                        |
| cHqboEGRUiY  | Facility_name | Mokorbu MCHP                                     |
| DA2BEQMhv9B  | Facility_name | Gbuihun MCHP                                     |
| q56204kKXgZ  | Facility_name | Lunsar CHC                                       |
| wB4R3E1X6pC  | Facility_name | Masanga Leprosy Hospital                         |
| cC03EwJLBiO  | Facility_name | Niahun Buima MCHP                                |
| qcYG2Id7GS8  | Facility_name | Mokpanabom MCHP                                  |
| uGa5JtIMfRx  | Facility_name | Matoto MCHP                                      |
| m3QGt8fY3L0  | Facility_name | Jormu CHP                                        |
| Cc9kMNFpGmC  | Facility_name | Taninihun Mboka MCHP                             |
| bVZTNrnfn9G  | Facility_name | St Anthony clinic                                |
| vcY0lzBz6fU  | Facility_name | Sandia CHP                                       |
| a04CZxe0PSe  | Facility_name | Murray Town CHC                                  |
| qxbsDd9QYv6  | Facility_name | Yiffin CHC                                       |
| wO4z5Aqo0hf  | Facility_name | Kamawornie CHP                                   |
| cUNdCErxl9g  | Facility_name | Bayama (K. Teng) MCHP                            |
| AIM09vwxjoN  | Facility_name | Mosagbe MCHP                                     |
| UUgajyaViT7  | Facility_name | Kambia CHP                                       |
| TrmusBXxLm3  | Facility_name | Malenkie MCHP                                    |
| qVvitxEF2ck  | Facility_name | Rogbere CHC                                      |
| kpDoH80fwdX  | Facility_name | MCH Static                                       |
| U2QkKSeyL5r  | Facility_name | Crossing MCHP                                    |
| Fbq6Vxa4MIx  | Facility_name | Mano Njeigbla CHP                                |
| Gtnbmf4LkOz  | Facility_name | Motorbong MCHP                                   |
| IFXdzAk7hKi  | Facility_name | Tokpombu MCHP                                    |
| oUR5HPmim7E  | Facility_name | Sandayeima MCHP                                  |
| wjFsUXI1MlO  | Facility_name | Iscon CHP                                        |
| BXJnMD2eJAx  | Facility_name | Gbonkobana CHP                                   |
| S2NaydvPENH  | Facility_name | Kundorma CHP                                     |
| RTixJpRqS4C  | Facility_name | Kpetema CHP                                      |
| TAN6Q7vjvuk  | Facility_name | Gbo-Kakajama 1 MCHP                              |
| SVEfwJ0BGeD  | Facility_name | Kono Bendu CHP                                   |
| kBP1UvZpsNj  | Facility_name | Blessed Mokaba clinic                            |
| dqHvtpUqLwB  | Facility_name | Masory MCHP                                      |
| PQEpIeuSTCN  | Facility_name | Tobanda CHC                                      |
| qELjt3LRkSD  | Facility_name | Gberifeh MCHP                                    |
| K5wBtEzE2qJ  | Facility_name | Gbamgbaia CHP                                    |
| XGUOQaRUPjO  | Facility_name | Ngo Town CHP                                     |
| hCm2Nh7C8BW  | Facility_name | Korgbotuma MCHP                                  |
| cJkZLwhL8RP  | Facility_name | Kasse MCHP                                       |
| zCSWBz2pyMd  | Facility_name | Wai MCHP                                         |
| lCEeiuv4NaB  | Facility_name | Kholifaga MCHP                                   |
| VpYAl8dXs6m  | Facility_name | Bendoma (Malegohun) MCHP                         |
| UCwtaCrNUls  | Facility_name | Heremakono MCHP                                  |
| d9zRBAoM8OC  | Facility_name | Bumpeh Perri CHC                                 |
| duGLGssecoD  | Facility_name | Kagbaneh CHP                                     |
| rwfuVQHnZJ5  | Facility_name | Dodo Kortuma CHP                                 |
| tWjUy6MCx8q  | Facility_name | Patama MCHP                                      |
| L4Tw4NlaMjn  | Facility_name | Nekabo CHC                                       |
| GCbYmPqcOOP  | Facility_name | Romeni MCHP                                      |
| qO2JLjYrg91  | Facility_name | Bandakarifaia MCHP                               |
| X9zzzyPZViR  | Facility_name | Rochen Malal MCHP                                |
| MwfWgjMRgId  | Facility_name | Bumbukoro MCHP                                   |
| g7BLyiBb0ET  | Facility_name | PMO Clinetown                                    |
| GMOl74xzmAE  | Facility_name | Rotaimbana MCHP                                  |
| wkYbuEwNWyf  | Facility_name | Sengema (Luawa) CHP                              |
| W7ekX3gi0ut  | Facility_name | Jaiama Sewafe CHC                                |
| tcEjL7gmFJL  | Facility_name | Senjekoro MCHP                                   |
| fdsRQbuuAuh  | Facility_name | Nonkoba CHP                                      |
| uedNhvYPMNu  | Facility_name | Gbanti CHC                                       |
| r0TCGeLkQKI  | Facility_name | Maboni MCHP                                      |
| CKJ9YS2AbWy  | Facility_name | Maharibo MCHP                                    |
| MrME31scKA1  | Facility_name | Kornia Kpindema CHP                              |
| wYLjA4vN6Y9  | Facility_name | Bambukoro MCHP                                   |
| JCXEtUDYyp9  | Facility_name | UFC Nixon Hospital                               |
| xKaB8tfbTzm  | Facility_name | Fintonia CHC                                     |
| ltF8BmYAXpQ  | Facility_name | Maguama CHP                                      |
| t52CJEyLhch  | Facility_name | Baoma MCHP                                       |
| SFQigiC2ISS  | Facility_name | Madina (Malema) MCHP                             |
| cZtKKa9eJZ3  | Facility_name | Jenner Wright Clinic                             |
| qMbxFg9McOF  | Facility_name | Kawaya MCHP                                      |
| YPSCWmJ3TyN  | Facility_name | Waiima MCHP                                      |
| tXL6C7P0ObJ  | Facility_name | Kanekor MCHP                                     |
| GhDwjKv07iC  | Facility_name | Kapethe MCHP                                     |
| fCFdj2T0Bq1  | Facility_name | Mabang MCHP                                      |
| jYPY8mT8gn6  | Facility_name | Kundundu MCHP                                    |
| KbO0JnhiMwl  | Facility_name | Dibia MCHP                                       |
| gowgzHWc8FT  | Facility_name | Manna MCHP                                       |
| cXMQtUId06K  | Facility_name | Modonkor CHP                                     |
| Ea3j0kUvyWg  | Facility_name | Stella Maries Clinic                             |
| DQHGtTGOP6b  | Facility_name | Bendu (Yawei) CHP                                |
| rJ25bHbIujw  | Facility_name | Susan’s Bay MCHP                                 |
| qusWt6sESRU  | Facility_name | Belentin MCHP                                    |
| XtuhRhmbrJM  | Facility_name | Baiama CHP                                       |
| mkIugjeYSjE  | Facility_name | Bumpeh River CHP                                 |
| HlDMbDWUmTy  | Facility_name | Mapawn MCHP                                      |
| Xk2fvz4aTBU  | Facility_name | Kabati CHP                                       |
| B9RxRfRUi2R  | Facility_name | Ronietta MCHP                                    |
| gaOSAjPM07w  | Facility_name | Mangay Loko MCHP                                 |
| PB8FMGbn19r  | Facility_name | Bombohun MCHP                                    |
| FGbXmz7gTTl  | Facility_name | SLC. RHC Port Loko                               |
| NMcx2jmra3c  | Facility_name | Firawa CHC                                       |
| yDFM5J6WeKU  | Facility_name | Bengani MCHP                                     |
| UGVLYrO63mR  | Facility_name | Bathurst MCHP                                    |
| RQgXBKxgvHf  | Facility_name | Mapotolon CHC                                    |
| ndan8zClk4E  | Facility_name | Jenneh MCHP                                      |
| BH7rDkWjUqc  | Facility_name | Bai Bureh Memorial Hospital                      |
| fzBpuujglTY  | Facility_name | Swarray Town MCHP                                |
| g3O1pGAfgK1  | Facility_name | Motema CHP                                       |
| I2UW55qvn82  | Facility_name | Rogballan MCHP                                   |
| PuZOFApTSeo  | Facility_name | Sahn CHC                                         |
| gsypzntLahf  | Facility_name | Lungi Govt. Hospital, Port Loko                  |
| I48Qu6R0sGm  | Facility_name | Madina Loko CHP                                  |
| ZZmMpGIE7pD  | Facility_name | Kagbanthama CHP                                  |
| vPKxHJ1og0r  | Facility_name | Giema (Luawa) MCHP                               |
| IN2dOk0gY1G  | Facility_name | Wullah Thenkle MCHP                              |
| ABM75Q1UfoP  | Facility_name | Bandajuma Kpolihun CHP                           |
| wNYYRm2c9EK  | Facility_name | Red Cross Clinic                                 |
| rs87nYgwbKv  | Facility_name | Lengekoro MCHP                                   |
| m5BX6CvJ6Ex  | Facility_name | Daru CHC                                         |
| Bq5nb7UAEGd  | Facility_name | Sierra Rutile Clinic                             |
| zO5hgxxfU4T  | Facility_name | kamba mamudia                                    |
| C1tAqIpKB9k  | Facility_name | Degbuama MCHP                                    |
| YXdC9hjYPqQ  | Facility_name | Ninkikoro MCHP                                   |
| HOgWkpYH3KB  | Facility_name | Gbongongor CHP                                   |
| ZvX8lXd1tYs  | Facility_name | Govt. Hospital                                   |
| oph70zH8JB2  | Facility_name | Robarie MCHP                                     |
| f7yRhIeFn1k  | Facility_name | Jokibu MCHP                                      |
| pYr0Kcy93M2  | Facility_name | Kangama (Kangama) CHP                            |
| l3jnkNNpoD8  | Facility_name | Masankoro MCHP                                   |
| PybxeRWVSrI  | Facility_name | Mabolleh MCHP                                    |
| Zp2Yi4j2AAH  | Facility_name | Katick MCHP                                      |
| tlMeFk8C4CG  | Facility_name | Badala MCHP                                      |
| uYG1rUdsJJi  | Facility_name | Borma (YKK) MCHP                                 |
| k92yudERPlv  | Facility_name | Bayama MCHP                                      |
| DxPNV7VHauJ  | Facility_name | Petifu Mayepoh MCHP                              |
| cWIiusmHULW  | Facility_name | Siama (U. Bamabara) MCHP                         |
| NqLYdlnK8sc  | Facility_name | Warrima MCHP                                     |
| nE01sGNCY5P  | Facility_name | Kpandebu CHP                                     |
| VXrJKs8hic4  | Facility_name | Bomie MCHP                                       |
| uYTq3TEO2a9  | Facility_name | Charlotte CHP                                    |
| U0KpeSx4UIB  | Facility_name | Macoth MCHP                                      |
| eCfxBe1lnxb  | Facility_name | kamaron MCHP                                     |
| M4hyYfnb21I  | Facility_name | Diamei MCHP                                      |
| VF7LfO19vxS  | Facility_name | Kochero MCHP                                     |
| nurO6U9bOLi  | Facility_name | Sindadu MCHP                                     |
| TSyzvBiovKh  | Facility_name | Gerehun CHC                                      |
| ctMepV9p92I  | Facility_name | Gbangbalia MCHP                                  |
| Zbp8TbiMKVc  | Facility_name | Tabe MCHP                                        |
| eoYV2p74eVz  | Facility_name | Approved School CHP                              |
| bPqP6eRfkyn  | Facility_name | Ross Road Health Centre                          |
| tlvNeDXXrS7  | Facility_name | Bassia MCHP                                      |
| BTXwf2gl7av  | Facility_name | Pejewa MCHP                                      |
| OI0BQUurVFS  | Facility_name | Bumban MCHP                                      |
| OynYyQiFu82  | Facility_name | Kondeya MCHP                                     |
| WZ8PTx8qQlE  | Facility_name | Saama MCHP                                       |
| yJ1xkKha5oE  | Facility_name | Konia MCHP                                       |
| duINhdt3Yay  | Facility_name | Gbengama MCHP                                    |
| G5FuODAbH6X  | Facility_name | Rofutha MCHP                                     |
| ADeZNq1pKsu  | Facility_name | Durukoro MCHP                                    |
| hKD6hpZUh9v  | Facility_name | Faala CHP                                        |
| PC3Ag91n82e  | Facility_name | Mongere CHC                                      |
| rebbn0ooFSO  | Facility_name | Gbongeima MCHP                                   |
| l0WRLZlEgB1  | Facility_name | Gbo-Kakajama 2 MCHP                              |
| aRXfvyonenP  | Facility_name | Sengema CHP                                      |
| bHcw141PTsE  | Facility_name | Gbondapi CHC                                     |
| F7u30K5OIpi  | Facility_name | Mamboma (Peje Bongre) CHP                        |
| BLVKubgVxkF  | Facility_name | SL Red Cross (Gbense) Clinic                     |
| v0HMlSxlH7l  | Facility_name | Maraka MCHP                                      |
| kFur7xPhpH9  | Facility_name | Teibor MCHP                                      |
| VFF7f43dJv4  | Facility_name | Tombo Wallah CHP                                 |
| IWM4eKPJJSc  | Facility_name | Sembehun MCHP                                    |
| ObJjzhhBkfy  | Facility_name | Gondama (Nimikoro) MCHP                          |
| TljiT6C5D0J  | Facility_name | Kpandebu CHC                                     |
| w3mBVfrWhXl  | Facility_name | Mange CHC                                        |
| MErVkzdbsP5  | Facility_name | Yataya CHP                                       |
| w7a4l3XHIgi  | Facility_name | Gbaneh Bana MCHP                                 |
| UugO8xDeLQD  | Facility_name | UNIMUS MCHP                                      |
| w0QDch3dyPH  | Facility_name | Komneh CHP                                       |
| Q23tMsKOoO6  | Facility_name | Fanima (Wonde) MCHP                              |
| cMFi8lYbXHY  | Facility_name | Bumpeh (Nimikoro) CHC                            |
| vAdMjyOspGL  | Facility_name | Grafton MCHP                                     |
| Rp268JB6Ne4  | Facility_name | Adonkia CHP                                      |
| c41XRVOYNJm  | Facility_name | Baiima CHP                                       |
| Bift1B4gjru  | Facility_name | Marie Stopes (Gbense) Clinic                     |
| dyn5pihalrJ  | Facility_name | Victoria MCHP                                    |
| Tc3zugEWdTm  | Facility_name | Sumbuya Bessima CHP                              |
| rspjJHg4WY1  | Facility_name | Bunabu MCHP                                      |
| q5kAX5MyPB6  | Facility_name | Mabai (Kholifa Rowalla) MCHP                     |
| oLuhRyYPxRO  | Facility_name | Senehun CHC                                      |
| bqtZrXoryDF  | Facility_name | Mercy Ship Hospital                              |
| aVlSMMvgVzf  | Facility_name | Bomu Saamba CHP                                  |
| b1F5bfb7WUR  | Facility_name | MadaKa MCHP                                      |
| Dbn6fyCgMBV  | Facility_name | Makama MCHP                                      |
| Qu0QOykPdcD  | Facility_name | Mattru on the Rail MCHP                          |
| XXlzHWzhf5d  | Facility_name | Pepel CHP                                        |
| is3w3HROKVc  | Facility_name | Rapha Clinic                                     |
| ui12Hyvn6jR  | Facility_name | Wilberforce Military Hospital                    |
| VeXU3mndzri  | Facility_name | Magbengbeh MCHP                                  |
| UOJlcpPnBat  | Facility_name | Needy CHC                                        |
| dQggcljEImF  | Facility_name | Goderich Health Centre                           |
| RwkdG4Pku2x  | Facility_name | Tongorma MCHP                                    |
| qqF8jshIs66  | Facility_name | Foya CHP                                         |
| mc3jvzpzSi4  | Facility_name | Mabineh MCHP                                     |
| EQnfnY03sRp  | Facility_name | Mandu CHP                                        |
| ALZ2qr5u0X0  | Facility_name | Mamalikie MCHP                                   |
| u1eQDDtKqm7  | Facility_name | Scan Drive MCHP                                  |
| hDW65lFySeF  | Facility_name | Youndu CHP                                       |
| DErmFP7bri7  | Facility_name | Dankawalie MCHP                                  |
| rYIkxCJFtTX  | Facility_name | Feuror MCHP                                      |
| BqRElDluXGa  | Facility_name | Levuma Nyomeh CHP                                |
| Q2USZSJmcNK  | Facility_name | Bumbuna CHC                                      |
| sLKHXoBIqSs  | Facility_name | Njagbwema Fiama CHC                              |
| Bf9R1R91mw4  | Facility_name | Levuma CHP                                       |
| UjusePB4jmP  | Facility_name | Kensay MCHP                                      |
| qwmh84DV65K  | Facility_name | Kongoifeh MCHP                                   |
| HPg74Rr7UWp  | Facility_name | School Health Clinic                             |
| dtuiqEXYa7z  | Facility_name | Rokel MCHP                                       |
| sTOXJA2KcY2  | Facility_name | Musaia CHP                                       |
| mEUUK7MHLSF  | Facility_name | Magburaka Govt. Hospital                         |
| E7IDb3nNiW7  | Facility_name | Makump Bana MCHP                                 |
| jr5hIZcJBXB  | Facility_name | Kowama MCHP                                      |
| uFp0ztDOFbI  | Facility_name | Bendu CHC                                        |
| MUnd4KWox8m  | Facility_name | Njagbwema CHP                                    |
| aHs9PLxIdbr  | Facility_name | Mayepoh CHC                                      |
| ShdRyzuLKA2  | Facility_name | Majihun MCHP                                     |
| yEU926iVAJJ  | Facility_name | Kathombo MCHP                                    |
| WdgS1JcBL2g  | Facility_name | Mongerewa MCHP                                   |
| VdXuxcNkiad  | Facility_name | Yoyema MCHP                                      |
| LnToY3ExKxL  | Facility_name | Mahera CHC                                       |
| QZ5rmKrVleg  | Facility_name | Yenkissa MCHP                                    |
| jhtj3eQa1pM  | Facility_name | Gondama (Tikonko) CHC                            |
| XctPvvWIIcF  | Facility_name | Yargoi MCHP                                      |
| ZsjXrmZS59z  | Facility_name | Ndegbome MCHP                                    |
| SC0nM3cbGHy  | Facility_name | Mokobo MCHP                                      |
| eP4F9eB76B0  | Facility_name | Mamankie MCHP                                    |
| e0RGds86ow6  | Facility_name | Fobu MCHP                                        |
| GRc9WXp9gSy  | Facility_name | Bradford CHC                                     |
| TQ5DSmdliN7  | Facility_name | Baoma (Luawa) MCHP                               |
| DwEfz1MN7Z5  | Facility_name | Ngiegboiya MCHP                                  |
| Pw9SihGDbZ5  | Facility_name | Gbogbodo MCHP                                    |
| zQpYVEyAM2t  | Facility_name | Hastings Health Centre                           |
| wicmjKI3xiP  | Facility_name | SLRCS MCH Clinic                                 |
| tEgxbwwrwUd  | Facility_name | Kayongoro MCHP                                   |
| sgcHQEaB40Y  | Facility_name | Yalieboya CHP                                    |
| lxxASQqPUqd  | Facility_name | Tombodu CHC                                      |
| oRncQGhLYNE  | Facility_name | Regent (RWA) CHC                                 |
| EUUkKEDoNsf  | Facility_name | Wilberforce CHC                                  |
| TkhwySsXC5V  | Facility_name | Konta Wallah MCHP                                |
| T3iVyvrCpZ0  | Facility_name | Kagbasia MCHP                                    |
| g031LbUPMmh  | Facility_name | Yeben MCHP                                       |
| uDzWmUDHKeR  | Facility_name | Futa CHC                                         |
| a5glgtnXJRG  | Facility_name | Magbanabom MCHP                                  |
| wGsBlwh6Zzt  | Facility_name | Mogbuama MCHP                                    |
| flQBQV8eyHc  | Facility_name | Dankawalia MCHP                                  |
| ZdPkczYqeIY  | Facility_name | Gandorhun CHC                                    |
| CTOMXJg41hz  | Facility_name | Kaniya MCHP                                      |
| s7SLtx8wmRA  | Facility_name | Kenema Gbandoma MCHP                             |
| RpRJUDOPtt7  | Facility_name | Dandabu CHP                                      |
| p310xqwAJge  | Facility_name | Kondembaia CHC                                   |
| PwoQgMJNWbR  | Facility_name | Koardu MCHP                                      |
| WoqN1oUBX2R  | Facility_name | Mile 38 CHP                                      |
| XJ6DqDkMlPv  | Facility_name | Wesleyan Health Clinic                           |
| Rll4VmTDRiE  | Facility_name | Bai Largo MCHP                                   |
| GjWQK6UA4FO  | Facility_name | Kambawama MCHP                                   |
| bJ0VSATHwO2  | Facility_name | Kumrabai Yoni MCHP                               |
| u6ZGNI8yUmt  | Facility_name | Rina Clinic                                      |
| tZxqVn3xNrA  | Facility_name | Wallehun MCHP                                    |
| x3ti3t9eOuX  | Facility_name | Rosengbeh MCHP                                   |
| er9S4CQ9QOn  | Facility_name | Bendu (Kowa) MCHP                                |
| nq7F0t1Pz6t  | Facility_name | Arab Clinic                                      |
| XmfqaErvQ2T  | Facility_name | Mosenessie Junction MCHP                         |
| ZxuSbAmsLCn  | Facility_name | Kamasikie MCHP                                   |
| NqwvaQC1ni4  | Facility_name | Komendeh (Nongowa) MCHP                          |
| p9KfD6eaRvu  | Facility_name | Shenge CHC                                       |
| xuk02oLk12O  | Facility_name | Lungi UFC                                        |
| k6lOze3vTzP  | Facility_name | Potoru CHC                                       |
| K3jhn3TXF3a  | Facility_name | Tongo Field CHC                                  |
| HNv1aLPdMYb  | Facility_name | Kamalo CHC                                       |
| pJv8NJlJNhU  | Facility_name | Pendembu CHC                                     |
| KvE0PYQzXMM  | Facility_name | Mano Yorgbo MCHP                                 |
| sK498nBOLfQ  | Facility_name | Elshadai MCHP                                    |
| rpAgG9XCWhO  | Facility_name | Bureh MCHP                                       |
| YTQRSW91PxO  | Facility_name | Falaba MCHP                                      |
| xX4lIVqF4yb  | Facility_name | Senekedugu MCHP                                  |
| YAuJ3fyoEuI  | Facility_name | Gbendembu Wesleyan CHC                           |
| jKZ0U8Og5aV  | Facility_name | Dodo CHC                                         |
| n9HIySyR00g  | Facility_name | Magbil MCHP                                      |
| kIbcKauMdlW  | Facility_name | Kunya MCHP                                       |
| Umh4HKqqFp6  | Facility_name | Jembe CHC                                        |
| IpA5FViU8tk  | Facility_name | Kanga MCHP                                       |
| ubsjwFFBaJM  | Facility_name | Gbangbatoke CHC                                  |
| lBob31rp6l4  | Facility_name | Mabom CHP                                        |
| sIVFEyNfOg4  | Facility_name | Mokandor CHP                                     |
| ARAZtL7Bdpy  | Facility_name | Guala MCHP                                       |
| iMZihUMzH92  | Facility_name | Bauya (Kongbora) CHC                             |
| N7mHLD3ljYc  | Facility_name | Kambia GH                                        |
| dGZbEZroAWr  | Facility_name | Funyehun MCHP                                    |
| FFU3PJ3pY7s  | Facility_name | Malal MCHP                                       |
| fmkqsEx6MRo  | Facility_name | Mabora MCHP                                      |
| oIgBLlEo6eH  | Facility_name | Deima MCHP                                       |
| CY8cV5khn7e  | Facility_name | Maselleh MCHP                                    |
| GM9ddjXIO5b  | Facility_name | Koindu-kuntey MCHP                               |
| kuqKh33SPgg  | Facility_name | Falaba CHC                                       |
| M721NHGtdZV  | Facility_name | St. Mary’s Clinic                                |
| LzvoPaeLPsb  | Facility_name | Maron MCHP                                       |
| fAsj6a4nudH  | Facility_name | Yoni CHC                                         |
| EQc3n1juPFn  | Facility_name | Koakor MCHP                                      |
| Mi4dWRtfIOC  | Facility_name | Sandaru CHC                                      |
| Srnpwq8jKbp  | Facility_name | Mawoma MCHP                                      |
| ei21lW7hFPX  | Facility_name | Gbaama MCHP                                      |
| DXegteybeb5  | Facility_name | Warima MCHP                                      |
| mzsOsz0NwNY  | Facility_name | New Police Barracks CHC                          |
| TYq1YW7qs7k  | Facility_name | Gbo-Lambayama 2 MCHP                             |
| BXd3TqaAxkK  | Facility_name | Sahun (Bumpeh) MCHP                              |
| pdF4XIHIGPx  | Facility_name | Bangoma MCHP                                     |
| wByqtWCCuDJ  | Facility_name | Damballa CHC                                     |
| cNAp6CJeLxk  | Facility_name | Mokanji CHC                                      |
| GAvxcmr5jB1  | Facility_name | Gao MCHP                                         |
| n7wN9gMFfZ5  | Facility_name | Benduma CHC                                      |
| n3MRjKtwr3O  | Facility_name | Kagbulor CHP                                     |
| iIQENGb7za6  | Facility_name | Sandia (Kissi Tongi) CHP                         |
| wbtk73Zwhj9  | Facility_name | Bumpeh CHP                                       |
| mW20aiZHqwE  | Facility_name | Tassoh MCHP                                      |
| Q8oWscr9rlQ  | Facility_name | Kiampkakolo MCHP                                 |
| LUGqPutql0P  | Facility_name | Fonikor CHP                                      |
| TJA0eGRoRpc  | Facility_name | Upper Komende MCHP                               |
| nDwbwJZQUYU  | Facility_name | Kanikay MCHP                                     |
| Zf2v0kbI7ah  | Facility_name | Makonkorie MCHP                                  |
| D7UVRRE9iUC  | Facility_name | Gbentu CHP                                       |
| fGp4OcovQpa  | Facility_name | Fogbo CHP                                        |
| BpWJ3cRsO6g  | Facility_name | Motonkoh MCHP                                    |
| OTn9VMNEkdo  | Facility_name | Mathufulie MCHP                                  |
| inpc5QsFRTm  | Facility_name | Kamassasa CHC                                    |
| t66taqSF1mW  | Facility_name | Follah MCHP                                      |
| L3GgannGGKl  | Facility_name | Mafufuneh MCHP                                   |
| djMCTPYvltl  | Facility_name | Govt. Hosp. Kenema                               |
| YnuwSqXPx9H  | Facility_name | Ngaiya MCHP                                      |
| GGDHb8xd8jc  | Facility_name | Tokeh MCHP                                       |
| aSxNNRxPuBP  | Facility_name | Kalangba CHC                                     |
| Q0HywoaWOcM  | Facility_name | Sukudu MCHP                                      |
| s5aXfzOL456  | Facility_name | Talia CHC                                        |
| O1KFJmM6HUx  | Facility_name | Mano Gbonjeima CHC                               |
| DZaJmtlaBMl  | Facility_name | Mogbasske CHP                                    |
| kSo9KSpHUPL  | Facility_name | Makaba MCHP                                      |
| vyIl6s0lhKc  | Facility_name | Barmoi Luma MCHP                                 |
| F9zWBqG5Pmi  | Facility_name | kamaron CHP                                      |
| vQYIk5G9NxP  | Facility_name | Mayossoh MCHP                                    |
| ZW3XCXXiLcO  | Facility_name | Minah MCHP                                       |
| tSBcgrTDdB8  | Facility_name | Paramedical CHC                                  |
| LWlh25dfvEA  | Facility_name | Makundu MCHP                                     |
| KiheEgvUZ0i  | Facility_name | Calaba town CHC                                  |
| cTU2WmWcJKx  | Facility_name | Magbaikoli MCHP                                  |
| sesv0eXljBq  | Facility_name | Yele CHC                                         |
| fNL2oehab2Q  | Facility_name | Samaia MCHP                                      |
| u0SlCNJnK3K  | Facility_name | Mamaka (Yoni) MCHP                               |
| kDxbU1uSBFh  | Facility_name | Kpetema MCHP                                     |
| NLN0MvWv9tl  | Facility_name | Grima CHP                                        |
| RXeDDKU26rB  | Facility_name | Gbaa (Makpele) CHP                               |
| bKiJzk8ZZbS  | Facility_name | Kuntorloh CHP                                    |
| SlNw6FxElY9  | Facility_name | Mendekelema (Upper Banbara) CHP                  |
| IlnqGuxfQAw  | Facility_name | Sinkunia CHC                                     |
| lpQvlm9czYE  | Facility_name | Tungie CHC                                       |
| aSnKB1sWaz4  | Facility_name | Ngolahun Jabaty MCHP                             |
| zQ2pFkzGtIg  | Facility_name | Peya MCHP                                        |
| KKoPh1lDd9j  | Facility_name | Kainkordu CHC                                    |
| HAqUY00X9N5  | Facility_name | Goderich MI Room                                 |
| esMAQ4vs4kM  | Facility_name | Yiraia CHP                                       |
| fRV3Fhz1IP8  | Facility_name | Gondama MCHP                                     |
| AFi1GjbeejL  | Facility_name | Kanga (LB) MCHP                                  |
| TEVtOFKcLAP  | Facility_name | Gbap CHC                                         |
| pXDcgDRz8Od  | Facility_name | Songo CHC                                        |
| M9JyYBZTqR7  | Facility_name | Kukuna CHP                                       |
| dCvUVvKnhMe  | Facility_name | Malema 1 MCHP                                    |
| waNtxFbPjrI  | Facility_name | Blessed Mokaka East Clinic                       |
| OqBiNJjKQAu  | Facility_name | Kasongha MCHP                                    |
| F0uVXCVvOPO  | Facility_name | Malone MCHP                                      |
| NaVzm59XKGf  | Facility_name | Gbinti CHC                                       |
| Ahh47q8AkId  | Facility_name | Mabang CHC                                       |
| SHLY5rkOFTQ  | Facility_name | UFC Port Loko                                    |
| oDAoqMWcsJQ  | Facility_name | Kaliyereh MCHP                                   |
| cDRQOxX1wHO  | Facility_name | Mosanda CHP                                      |
| DF76ZjQtFSg  | Facility_name | Kamba Mamudia MCHP                               |
| vSbt6cezomG  | Facility_name | UMC (Urban Centre) Hospital                      |
| dWOAzMcK2Wt  | Facility_name | Alkalia CHP                                      |
| qIpBLa1SCZt  | Facility_name | Talia (Nongowa) CHC                              |
| xWjiTeok0Sr  | Facility_name | Masorie CHP                                      |
| z4silfLpw2G  | Facility_name | Mafoimara MCHP                                   |
| H97XE5Ea089  | Facility_name | Bomotoke CHC                                     |
| bkMlhoccaVw  | Facility_name | Mabureh Mende MCHP                               |
| kEkU53NrFmy  | Facility_name | Taninahun (BN) CHP                               |
| YvwYw7GilkP  | Facility_name | Levuma (Kandu Lep) CHC                           |
| xMn4Wki9doK  | Facility_name | Moriba Town CHC                                  |
| RaQGHRti7JM  | Facility_name | Gods Favour health Center                        |
| iMDr2FG7i8Q  | Facility_name | Makobeh MCHP                                     |
| dmdYffw2I0F  | Facility_name | Makeni-Lol MCHP                                  |
| RJpiHpefEUw  | Facility_name | Torkpumbu MCHP                                   |
| JQJjsXvHE5M  | Facility_name | Mokelleh CHC                                     |
| h9q3qixffZT  | Facility_name | Campbell Town CHP                                |
| kvzdkXBxHoN  | Facility_name | Njaluahun CHP                                    |
| zY9ds4oNZxw  | Facility_name | Potehun MCHP                                     |
| kd2Aqw5S07V  | Facility_name | Mokassie MCHP                                    |
| FRX63UWciyO  | Facility_name | Mamusa MCHP                                      |
| pMEnu7BjqMz  | Facility_name | Kpumbu MCHP                                      |
| kbGqmM6ZWWV  | Facility_name | Allen Town Health Post                           |
| MMrdfNDfBIi  | Facility_name | Gbongeh CHP                                      |
| nbMpoRiVRWd  | Facility_name | Pewama CHP                                       |
| Pr2stbkaSX3  | Facility_name | Fayeima CHP                                      |
| hpXXBtRXXSd  | Facility_name | Kaimunday CHP                                    |
| bf6PXrSNMKK  | Facility_name | Magbassabana MCHP                                |
| FQ5CCuUKNLf  | Facility_name | Romando MCHP                                     |
| fUxVOkpX3yi  | Facility_name | Manack MCHP                                      |
| PMsF64R6OJX  | Facility_name | Bendugu (Mongo) CHC                              |
| v0dXACseLuB  | Facility_name | Woroma CHP                                       |
| ih77LC7LE1p  | Facility_name | Morfindor CHP                                    |
| bPHn9IgjKLC  | Facility_name | Nasarah Clinic                                   |
| HHc5HDPFlXy  | Facility_name | Menika MCHP                                      |
| hLGkoHmvBgI  | Facility_name | Mano-Jaiama CHP                                  |
| roQ2l7TX0eZ  | Facility_name | SLRCS (Bo) Clinic                                |
| TNbHYOuQi8s  | Facility_name | Bambawolo CHP                                    |
| JrSIoCOdTH2  | Facility_name | Tombo CHC                                        |
| nCh5dBoJVNw  | Facility_name | SL Red Cross (BMC) Clinic                        |
| a1E6QWBTEwX  | Facility_name | Sienga CHP                                       |
| gmen7SXL9CU  | Facility_name | SLIMS Clinic                                     |
| cJ7omISg7gG  | Facility_name | Kamba MCHP                                       |
| rwgK8TkRwHl  | Facility_name | Kawengha MCHP                                    |
| dNT8lAL4zGo  | Facility_name | Nyeama CHP                                       |
| gGv9ATEs68L  | Facility_name | UFC Bonthe                                       |
| hZpaU5uFSDm  | Facility_name | Magbele MCHP                                     |
| KFowGOhmuSL  | Facility_name | Suga MCHP                                        |
| MPUiud3BYRq  | Facility_name | Katherie MCHP                                    |
| ua3kNk4uraZ  | Facility_name | Modia MCHP                                       |
| c9wCIfbcyVo  | Facility_name | M I Room (Military)                              |
| NnQpISrLYWZ  | Facility_name | Govt. Hosp. Bonthe                               |
| lf7FRlrchg3  | Facility_name | Gofor CHP                                        |
| yh1PrRTboyg  | Facility_name | Kassama MCHP                                     |
| QN4te5Z5svQ  | Facility_name | Mbaoma CHP                                       |
| FLjwMPWLrL2  | Facility_name | Baomahun CHC                                     |
| suFG8zx4bU3  | Facility_name | Masabong Pil MCHP                                |
| Gba5bTc8NIg  | Facility_name | Serabu (Small Bo) CHP                            |
| uAk40nFigUK  | Facility_name | Magbenka CHP                                     |
| nYiOoF2nXIr  | Facility_name | Kalangba BKM MCHP                                |
| lL2LBkhlsmV  | Facility_name | Grassfield CHC                                   |
| erqWTArTsyJ  | Facility_name | Telu CHP                                         |
| pJj2r2HElLE  | Facility_name | Madina Fullah CHP                                |
| up9gjdODKXE  | Facility_name | Vaahun MCHP                                      |
| egjrZ1PHNtT  | Facility_name | Sembehun CHC                                     |
| NRPCjDljVtu  | Facility_name | Lakka/Ogoo Farm CHC                              |
| X79FDd4EAgo  | Facility_name | Rokulan CHC                                      |
| lzz1UhTzO4E  | Facility_name | New Maforkie CHP                                 |
| E4jn4059Y1x  | Facility_name | Gondama (Kamaje) CHP                             |
| NqTZjfTIsxC  | Facility_name | Semewebu MCHP                                    |
| wfGRNqXqf92  | Facility_name | Kabonka MCHP                                     |
| O63vIA5MVn6  | Facility_name | Tagrin CHC                                       |
| PHo0IV7Vk50  | Facility_name | Rochem Kamandao CHP                              |
| MnfykVk3zin  | Facility_name | Senjehun MCHP                                    |
| KwSj4DlRWAm  | Facility_name | Makoba Bana MCHP                                 |
| zsqxu7ZZRpO  | Facility_name | Koeyor MCHP                                      |
| VZ6Cocesljy  | Facility_name | Quidadu MCHP                                     |
| N3tpEjZcPm9  | Facility_name | Laleihun Kovoma CHC                              |
| Qc9lf4VM9bD  | Facility_name | Wellington Health Centre                         |
| KnU2XHRvyiX  | Facility_name | Kamakwie MCHP                                    |
| P4upLKrpkHP  | Facility_name | Ngegbwema CHC                                    |
| rozv5QUSE7a  | Facility_name | Lowoma MCHP                                      |
| AtZJOoQiGHd  | Facility_name | Woama MCHP                                       |
| xXYv82KlBUh  | Facility_name | Quarry MCHP                                      |
| VTtyiYcc6TE  | Facility_name | Roktolon MCHP                                    |
| wjP03y8OY5k  | Facility_name | Serabu (Koya) CHP                                |
| GQpxsB7tekR  | Facility_name | Mogomgbay MCHP                                   |
| VfZnZ6UKyn8  | Facility_name | Bontiwo MCHP                                     |
| MBtmOhLs7y1  | Facility_name | Sengama MCHP                                     |
| XzmWizbR343  | Facility_name | Masuba MCHP                                      |
| UxpUYgdb4oU  | Facility_name | Rokai CHP                                        |
| GHHvGp7tgtZ  | Facility_name | Binkolo CHC                                      |
| wqbyzbQ78oI  | Facility_name | Suen CHP                                         |
| Qwzs1iinAI7  | Facility_name | Wonkibor MCHP                                    |
| wwM3YPvBKu2  | Facility_name | Ngolahun CHC                                     |
| wzvDhS0TkAF  | Facility_name | Pate Bana CHP                                    |
| lsqa3EEGHxv  | Facility_name | Bunumbu CHP                                      |
| nImgPWDVQIa  | Facility_name | Mbokie CHP                                       |
| jj1MhWhHqta  | Facility_name | Kasanikoro MCHP                                  |
| AvGz949akv4  | Facility_name | Saiama MCHP                                      |
| QZzRkqdGjlm  | Facility_name | Mindohun CHP                                     |
| x8SUTSsJoeO  | Facility_name | Baoma-Peje CHP                                   |
| xRsoZIRmnt4  | Facility_name | Mabai MCHP                                       |
| pUZIL5xBsve  | Facility_name | Sumbuya MCHP                                     |
| OzVuFaZgm5U  | Facility_name | Gbo-Lambayama 1 MCHP                             |
| k6DIO9LIEk9  | Facility_name | Lyn Maternity MCHP                               |
| XbyObqerCya  | Facility_name | Yabaima CHP                                      |
| jbfISeV6Wdu  | Facility_name | Makeni-Rokfullah MCHP                            |
| mwN7QuEfT8m  | Facility_name | Koribondo CHC                                    |
| Hu31NCRjZlj  | Facility_name | Masamboi MCHP                                    |
| nDoybVJLD74  | Facility_name | Gbalahun CHP                                     |
| aV9VVijeVB2  | Facility_name | Njagbwema MCHP                                   |
| MuZJ8lprGqK  | Facility_name | Moyamba Junction CHC                             |
| YWXXO0XMkQe  | Facility_name | Mendewa MCHP                                     |
| Jyv7sjpl9bA  | Facility_name | Sendumei CHC                                     |
| BnVjTzwis3o  | Facility_name | Samaya CHP                                       |
| PSjKMcPGUvA  | Facility_name | Kangama CHP                                      |
| qzm5ww3U0vz  | Facility_name | Jangalor MCHP                                    |
| R0CmUlFULXg  | Facility_name | Mayakie MCHP                                     |
| EDxXfB4iVpY  | Facility_name | Wilberforce MCHP                                 |
| zEsMdeJOty4  | Facility_name | Moyiba CHC                                       |
| PA1spYiNZfv  | Facility_name | Yengema CHC                                      |
| hMBotMwWnU1  | Facility_name | Koinadugu II CHP                                 |
| mVvEwzoFutG  | Facility_name | Nyandehun MCHP                                   |
| WjO2puYKysP  | Facility_name | Sonkoya MCHP                                     |
| zm9breCeT1m  | Facility_name | Gbonkoh Kareneh MCHP                             |
| KFhJrkqnrnb  | Facility_name | Mathamp MCHP                                     |
| sSgOnY1Xqd9  | Facility_name | Delken MCHP                                      |
| jfV49JGnYKF  | Facility_name | Fatibra CHP                                      |
| z9KGMrElTYS  | Facility_name | Fullah Town (M.Gbanti) MCHP                      |
| rLaGvUnv2BF  | Facility_name | Mathonkara MCHP                                  |
| xIMxph4NMP1  | Facility_name | Tonkomba MCHP                                    |
| tNs4E0JcMKe  | Facility_name | Sawula MCHP                                      |
| WOk7efLlLSj  | Facility_name | Niagorehun MCHP                                  |
| Eyj2kiEJ7M3  | Facility_name | Bailor CHP                                       |
| NnGUNkc5Zq8  | Facility_name | Mende Buima MCHP                                 |
| SIxGTeya5lN  | Facility_name | Mapillah MCHP                                    |
| Uwcj0mz78BV  | Facility_name | Manjoro MCHP                                     |
| UqHuR4IYvTY  | Facility_name | Sanya CHP                                        |
| JQr6TJx5KE3  | Facility_name | Nyandehun CHP                                    |
| kO9xe2HCovK  | Facility_name | Kambia Makama CHP                                |
| RhJbg8UD75Q  | Facility_name | Yemoh Town CHC                                   |
| dU3vTbLRLHy  | Facility_name | Tambeyama MCHP                                   |
| Pae8DR7VmcL  | Facility_name | MCH (Kakua) Static                               |
| ua5GXy2uhBR  | Facility_name | Tihun CHC                                        |
| ym42ZOlfZ1P  | Facility_name | Robaka MCHP                                      |
| FbD5Z8z22Yb  | Facility_name | Geoma Jagor CHC                                  |
| WT6JLfyR9lL  | Facility_name | Fanima CHP                                       |
| MiYhwDprCCA  | Facility_name | Mabella MCHP                                     |
| aF6iPGbrcRk  | Facility_name | Bandasuma Fiama MCHP                             |
| sY1WN6LjmAx  | Facility_name | Moyowa MCHP                                      |
| brnL0W3Fbsj  | Facility_name | Koya MCHP                                        |
| oV9P0VvL9Jh  | Facility_name | Plantain Island MCHP                             |
| WxMIZC6Cxqs  | Facility_name | Magbengberah MCHP                                |
| amgb83zVxp5  | Facility_name | Bendu Mameima CHC                                |
| KaevAHPgkA8  | Facility_name | Rothatha MCHP                                    |
| U02o1QAm6cC  | Facility_name | Kpetema (Lower Bambara) CHP                      |
| FwKJ7gYEv8U  | Facility_name | Ngelehun MCHP                                    |
| PhR1PdMTzhW  | Facility_name | Masongbo Limba MCHP                              |
| nornKUJmQqn  | Facility_name | Konta-Line MCHP                                  |
| kedYKTsv95j  | Facility_name | Gbado MCHP                                       |
| cd3U2Tp0qR2  | Facility_name | Makonthanday MCHP                                |
| lELJZCBxz7H  | Facility_name | Kent CHP                                         |
| cUltUneFSan  | Facility_name | Komrabai Station MCHP                            |
| ZKL5hlVG6F6  | Facility_name | Benguima Grassfield MCHP                         |
| EQUwHqZOb5L  | Facility_name | Kabaima MCHP                                     |
| xXhKbgwL39t  | Facility_name | Blama Massaquoi CHP                              |
| bG0PlyD0iP3  | Facility_name | Tugbebu CHP                                      |
| m0XorV4WWg0  | Facility_name | Ginger Hall Health Centre                        |
| lyONqUkY1Bq  | Facility_name | Matholey MCHP                                    |
| CvBAqD6RzLZ  | Facility_name | Ngalu CHC                                        |
| yg7uxUol97F  | Facility_name | Laiya CHP                                        |
| HFyjUvMjQ8H  | Facility_name | Baiwala CHP                                      |
| SmhR2aaKLjw  | Facility_name | sonkoya MCHP                                     |
| RpjUEvgWSNO  | Facility_name | Dulukoro MCHP                                    |
| BJMWTGwuGiw  | Facility_name | Niahun Gboyama MCHP                              |
| m8qnxndRDR6  | Facility_name | Lumpa CHP                                        |
| tHUYjt9cU6h  | Facility_name | Ola During Clinic                                |
| uNEhNuBUr0i  | Facility_name | Tonko Maternity Clinic                           |
| yets9NmUcRS  | Facility_name | Deep Eye water MCHP                              |
| ETRqfu74kge  | Facility_name | Masaika MCHP                                     |
| AhnK8hb3JWm  | Facility_name | The White House Clinic                           |
| d9uZeZ5fMUo  | Facility_name | Mamaka MCHP                                      |
| wy6tbexg2nu  | Facility_name | Tawuya CHP                                       |
| jIrb5XckcU6  | Facility_name | Masseseh MCHP                                    |
| mGmu0GJ5neg  | Facility_name | Kpetewoma CHP                                    |
| Kmu7ox2MiiU  | Facility_name | Koyagbema MCHP                                   |
| cBi3y4lGhDd  | Facility_name | Gbomsamba MCHP                                   |
| rx9ubw0UCqj  | Facility_name | Bandajuma MCHP                                   |
| k8ZPul89UDm  | Facility_name | Kayima CHC                                       |
| CSDGDOa7wHd  | Facility_name | Kornia MCHP                                      |
| lQIe6vtSe1P  | Facility_name | Gbangadu MCHP                                    |
| OzjRQLn3G24  | Facility_name | Koidu Govt. Hospital                             |
| HHz1kAG1LKn  | Facility_name | Mosenegor MCHP                                   |
| e4P2zTzM7gQ  | Facility_name | Kamasaypana MCHP                                 |
| x5ZxMDvEQUb  | Facility_name | Yonibana MCHP                                    |
| EihevoTWn2i  | Facility_name | Gbamani CHP                                      |
| gP6hn503KUX  | Facility_name | Robat MCHP                                       |
| bW5BaqrBM4K  | Facility_name | Wordu CHP                                        |
| GkHpMSo5K60  | Facility_name | Fothaneh Bana MCHP                               |
| NjyJYiIuKIG  | Facility_name | Kathanta Yimbor CHC                              |
| PD1fqyvJssC  | Facility_name | Catholic Clinic                                  |
| taKiTcaf05H  | Facility_name | Mabenteh Community Hospital                      |
| KGN2jvZ0GJy  | Facility_name | Kantia CHP                                       |
| hHKKi9WNoBG  | Facility_name | Kamiendor MCHP                                   |
| b09gf2vvZDb  | Facility_name | Mabureh CHP                                      |
| VSwnkMSAdp7  | Facility_name | Worreh MCHP                                      |
| el8sgzyHuEe  | Facility_name | Rosint Buya MCHP                                 |
| caif2tNAS0n  | Facility_name | Mathinkalol MCHP                                 |
| xATvj8pdYoT  | Facility_name | Grima Jou MCHP                                   |
| Vw4Uv6UPIPC  | Facility_name | Ngueh MCHP                                       |
| g6y7PS0UQR4  | Facility_name | Sandialu MCHP                                    |
| bM4Ky73uMao  | Facility_name | Kpolies Clinic                                   |
| hIpcmjLrDDW  | Facility_name | London (Blama) MCHP                              |
| t1aAdpBbDB3  | Facility_name | Bandusuma MCHP                                   |
| QzPf0qKBU4n  | Facility_name | Jendema CHC                                      |
| QBRQnWPRO3V  | Facility_name | Madopolahun MCHP                                 |
| as1dnmlXLzG  | Facility_name | Gbetema MCHP (Fiama)                             |
| vELbGdEphPd  | Facility_name | Jimmi CHC                                        |
| n2qFnUIhbq3  | Facility_name | Rosinor CHP                                      |
| NDqR2cWlVy3  | Facility_name | Sahn Bumpe MCHP                                  |
| va2lE4FiVVb  | Facility_name | Mano CHC                                         |
| JNJIPX9DfaW  | Facility_name | S.L.R.C.S Clinic                                 |
| mhJQYk2Jwym  | Facility_name | Konabu MCHP                                      |
| UqXSUMp19FB  | Facility_name | Kalangba MCHP                                    |
| BJ3DJFBKwBR  | Facility_name | Saama (Lower Bamabara) CHP                       |
| K0d08d3sUOv  | Facility_name | Lakka Hospital                                   |
| pmzk0ho80aA  | Facility_name | Kathanta Bana MCHP                               |
| cag6vQQ9SQk  | Facility_name | Masselleh MCHP                                   |
| RNGpZqutw3Y  | Facility_name | Kania (Masungbala) MCHP                          |
| I2DzylqJa2i  | Facility_name | Samai Town MCHP                                  |
| LZclRdyVk1t  | Facility_name | Bumbanday MCHP                                   |
| SKJoPDgjELa  | Facility_name | Samamaia MCHP                                    |
| kUzpbgPCwVA  | Facility_name | Blama CHC                                        |
| PFZbQjwty2n  | Facility_name | Kpandebu MCHP                                    |
| FupvWBUFXr7  | Facility_name | MacDonald MCHP                                   |
| Mi4Ax9suQmB  | Facility_name | Sembehun (Gaura) MCHP                            |
| PysJIi3VIol  | Facility_name | Juba M I Room                                    |
| rCKWdLr4B8K  | Facility_name | Motuo CHC                                        |
| lwHs72tP6Kh  | Facility_name | Kordebotehun MCHP                                |
| DINXUs8QZWg  | Facility_name | Nyandehun (Koya) MCHP                            |
| Sglj9VCoQmc  | Facility_name | Kagboray MCHP                                    |
| qAFXoNjlZCB  | Facility_name | Vaama (kpanga krim) MCHP                         |
| m73lWmo5BDG  | Facility_name | Korbu MCHP                                       |
| fYmE4ymzZSe  | Facility_name | Pendembu Njeigbla MCHP                           |
| ctfiYW0ePJ8  | Facility_name | Philip Street Clinic                             |
| svCLFkT99Yx  | Facility_name | Timbo CHP                                        |
| cZI3AWM7bIa  | Facility_name | Minthomor CHP                                    |
| EoIjKXqXxi2  | Facility_name | Sukudu Soa MCHP                                  |
| ewh5SKxcCAl  | Facility_name | Makaiba MCHP                                     |
| plnHVbJR6p4  | Facility_name | Ahamadyya Mission Cl                             |
| GA7eQkgK5mX  | Facility_name | Massahun MCHP                                    |
| QaeQJJCmnTS  | Facility_name | Sembehunwo MCHP                                  |
| S6KDC0jVhmD  | Facility_name | Massaba MCHP                                     |
| u3rHGQGLLP7  | Facility_name | Kanku Bramaia MCHP                               |
| l2kZRcJjomr  | Facility_name | Hima MCHP                                        |
| BV4IomHvri4  | Facility_name | Ahmadiyya Muslim Hospital                        |
| t7bcrWLjL1m  | Facility_name | Jao MCHP                                         |
| GvstqlRRnpV  | Facility_name | Sumbaria MCHP                                    |
| KfUCAQoOIae  | Facility_name | Pelewahun (Baoma) MCHP                           |
| etrIik4vsBQ  | Facility_name | Kawula CHP                                       |
| W3t0pSZLtrC  | Facility_name | Gendema MCHP                                     |
| PyLBGdbzdEo  | Facility_name | Kamboma MCHP                                     |
| tBRDdxfKbMx  | Facility_name | Liya MCHP                                        |
| WhCQNekdIwM  | Facility_name | Moyeamoh CHP                                     |
| z6v73gowbuM  | Facility_name | Kortohun CHP                                     |
| Zwnfm4rnzbZ  | Facility_name | Stocco CHP                                       |
| xmZNDeO0qCR  | Facility_name | Govt. Medical Hospital                           |
| vgOQ7fWmMyZ  | Facility_name | Sambaya MCHP                                     |
| Uo4cyJwAhTW  | Facility_name | Mutual Faith Clinic                              |
| DJr17K6RWzO  | Facility_name | Mogbongisseh MCHP                                |
| hyLU8ivDJDi  | Facility_name | Mid Land MCHP                                    |
| Jiymtq0A01x  | Facility_name | Bafodia CHC                                      |
| GtJoxCaM2zg  | Facility_name | Mabain MCHP                                      |
| lPeZdUm9fD7  | Facility_name | Blessed Mokaba East                              |
| GcwGqLqyi1M  | Facility_name | Rotawa CHP                                       |
| al4GkB6X2X3  | Facility_name | Ngieyehun MCHP                                   |
| CEoD9uQVIZB  | Facility_name | Mabonkanie MCHP                                  |
| geVF87N7qTw  | Facility_name | Kpayama 2 MCHP                                   |
| fXT1scbEObM  | Facility_name | Family Clinic                                    |
| EuoA3Crpqts  | Facility_name | Mbundorbu MCHP                                   |
| ueuQlqb8ccl  | Facility_name | Panderu MCHP                                     |
| tdhB1JXYBx2  | Facility_name | Kunsho CHP                                       |
| YBZcWphXQ99  | Facility_name | Kareneh MCHP                                     |
| o0BgK1dLhF8  | Facility_name | Bendugu CHC                                      |
| agEKP19IUKI  | Facility_name | Tambiama CHC                                     |
| f90eISKFm7P  | Facility_name | Doujou CHP                                       |
| DlLBIHdpaTy  | Facility_name | Waiima (Kori) MCHP                               |
| JU4dWUv0Pmd  | Facility_name | Royeiben MCHP                                    |
| S9QckzKX6Lg  | Facility_name | Kormende MCHP                                    |
| b7YDjQ6DBzt  | Facility_name | Kamagbewu MCHP                                   |
| Fhko00f3hXT  | Facility_name | Taninahun MCHP                                   |
| RVAkLOVWSWc  | Facility_name | Mansumana CHP                                    |
| iqd7BiRHor0  | Facility_name | Kamadu Sokuralla MCHP                            |
| OY7mYDATra3  | Facility_name | Massingbi CHC                                    |
| PLoeN9CaL7z  | Facility_name | SLRCS (Koinadugu) Clinic                         |
| IWb1hstfROc  | Facility_name | Gandorhun CHP                                    |
| m21WB5iqHAb  | Facility_name | Ngiehun (Lower Bambara) MCHP                     |
| PduUQmdt0pB  | Facility_name | Numea CHC                                        |
| SZrG4yHGV4x  | Facility_name | Madina Gbonkobor MCHP                            |
| Ioxjc2KBjWd  | Facility_name | Fengehun MCHP                                    |
| UgUcwzbEv2C  | Facility_name | Moyollo MCHP                                     |
| y5hLlID8ihI  | Facility_name | Barlie MCHP                                      |
| jk1TtiBM5hz  | Facility_name | Holy Mary Hospital                               |
| D2rB1GRuh8C  | Facility_name | Gbamgbama CHC                                    |
| NpHsnQ2L1oY  | Facility_name | Bumpetoke CHP                                    |
| Gm7YUjhVi9Q  | Facility_name | Fairo CHC                                        |
| HTDuY3uxj6u  | Facility_name | Gloucester CHP                                   |
| D3oZZXtXjNk  | Facility_name | Foindu MCHP                                      |
| Vw6CNyFUeh9  | Facility_name | Gbandiwulo CHP                                   |
| KR0jLuFOB3d  | Facility_name | Griema MCHP                                      |
| m7fBMpmVpSM  | Facility_name | Kolisokor MCHP                                   |
| rZkUcho9Z65  | Facility_name | Torma Bum CHP                                    |
| r5WWF9WDzoa  | Facility_name | Baama CHC                                        |
| g5lonXJ9ndA  | Facility_name | Hinistas CHC                                     |
| GjJjES51GvK  | Facility_name | Vaama MCHP                                       |
| cKXicCOquXe  | Facility_name | Mange Bissan MCHP                                |
| Bpvug2zxHEZ  | Facility_name | Njala University Hospital                        |
| AKvgfYx5WZq  | Facility_name | Hill Station MCHP                                |
| FsunWIQLXoF  | Facility_name | Gbalan Thallan MCHP                              |
| a1dP5m3Clw4  | Facility_name | Baoma Kpenge CHP                                 |
| PwgoRuWEDvJ  | Facility_name | Belebu CHP                                       |
| T2Cn45nBY0u  | Facility_name | SLRC (Mattru) Clinic                             |
| kRWIof0qPJj  | Facility_name | Kondiama MCHP                                    |
| XLiqwElsFHO  | Facility_name | Kissy Koya MCHP                                  |
| HQoxFu4lYPS  | Facility_name | Pellie CHC                                       |
| X3D19LoA2Ij  | Facility_name | Gbombana MCHP                                    |
| D6yiaX1K5sO  | Facility_name | Bomaru CHP                                       |
| RUCp6OaTSAD  | Facility_name | St. John of God Catholic Clinic                  |
| yvDKjcRRQsR  | Facility_name | Rogbin MCHP                                      |
| iIpPPnnzDo6  | Facility_name | Tongoro MCHP                                     |
| voQXVNftP4W  | Facility_name | Maami CHP                                        |
| Qw7c6Ckb0XC  | Facility_name | UMC Clinic Taiama                                |
| yZPsWcZC9WA  | Facility_name | Sellah Kafta MCHP                                |
| ZzdTFqWrlDa  | Facility_name | Geima CHP                                        |
| EURoFVjowXs  | Facility_name | Masiaka CHC                                      |
| ii2KMnWMx2L  | Facility_name | Gandorhun (Gbane) CHC                            |
| J42QfNe0GJZ  | Facility_name | Mara CHC                                         |
| AnXoUM1tfNT  | Facility_name | Yakaji MCHP                                      |
| VrDA0Hn4Xc6  | Facility_name | Harvest Time MCHP                                |
| gUPhNWkSXvD  | Facility_name | Rotifunk CHC                                     |
| ntQSuMb7J21  | Facility_name | Lungi Town MCHP                                  |
| FclfbEFMcf3  | Facility_name | Kissy Health Centre                              |
| JLKGG67z7oj  | Facility_name | Fatkom Muchendeh Maternity Clinic                |
| ZOZ4s2gTPj7  | Facility_name | Serekolia MCHP                                   |
| tGf942oWszb  | Facility_name | Gbongboma MCHP                                   |
| mkFoaAdosuY  | Facility_name | Soriebolomia MCHP                                |
| fPe1l06MurL  | Facility_name | Woyama MCHP                                      |
| NwX8noGxLoz  | Facility_name | Makelleh MCHP                                    |
| tt9XZYR5avl  | Facility_name | Mathuraneh MCHP                                  |
| tR6e8k99ODA  | Facility_name | Mansundu MCHP                                    |
| hBPtNXkQ3mP  | Facility_name | Ngiehun MCHP                                     |
| QFcMulIoEii  | Facility_name | Gbainkfay MCHP                                   |
| wcHRDp21Lw1  | Facility_name | Sussex MCHP                                      |
| XL745P4ETSL  | Facility_name | Mobefa MCHP                                      |
| V6QWyB0KqvP  | Facility_name | Juma MCHP                                        |
| zAyK28LLaez  | Facility_name | Bongor MCHP                                      |
| am6EFqHGKeU  | Facility_name | Mokpende MCHP                                    |
| OjTS752GbZE  | Facility_name | Kagbankona MCHP                                  |
| FgYDmGwmpEU  | Facility_name | Sorbeh Grima MCHP                                |
| mYMJHVqdBKt  | Facility_name | Kambama CHP                                      |
| HWXk4EBHUyk  | Facility_name | Sahn (Malen) CHC                                 |
| wB4tSXlryyO  | Facility_name | Voahun MCHP                                      |
| p9ZtyC3LQ9f  | Facility_name | Niagorehun CHP                                   |
| W2KnxOMvmgE  | Facility_name | Sumbuya CHC                                      |
| tO01bqIipeD  | Facility_name | Buedu CHC                                        |
| xEip3dtU8bp  | Facility_name | Lango Town MCHP                                  |
| ZoHdXy2ueVn  | Facility_name | Malambay CHP                                     |
| weLTzWrLXCO  | Facility_name | Bapuya MCHP                                      |
| sYJCxNdKHxR  | Facility_name | Punduru CHP                                      |
| CvYsZipdHMN  | Facility_name | Kumala CHP                                       |
| pVuRAzSstbn  | Facility_name | Rokimbi MCHP                                     |
| HDOnfLXKkYs  | Facility_name | Hamdalai MCHP                                    |
| aBfyTU5Wgds  | Facility_name | Nduvuibu MCHP                                    |
| VH7hLUaypel  | Facility_name | Gbangeima MCHP                                   |
| X7ZVgRPt31q  | Facility_name | Lawana MCHP                                      |
| nAH0uNc3b5f  | Facility_name | Tefeya CHP                                       |
| eKoXODABUJe  | Facility_name | Masofinia MCHP                                   |
| SCc0TNTDJED  | Facility_name | Gberia Timbakor MCHP                             |
| qHBTf9A89xW  | Facility_name | Dia CHP                                          |
| Z9ny6QeqsgX  | Facility_name | Manjama UMC CHC                                  |
| flJbtXOQ4ha  | Facility_name | Masumbrie MCHP                                   |
| RxmgoSlw9YF  | Facility_name | Mokellay MCHP                                    |
| en0j7qFnySQ  | Facility_name | Makabo MCHP                                      |
| Y8foq27WLti  | Facility_name | Baoma Oil Mill CHC                               |
| mepHuAA9l51  | Facility_name | Rokonta CHC                                      |
| uROAmk9ymNE  | Facility_name | Kindoyal Hospital                                |
| sHbLRZLmS4w  | Facility_name | Mapamurie MCHP                                   |
| Uv15pOAstzX  | Facility_name | Komrabai Ngolla MCHP                             |
| DvzKyuC0G4w  | Facility_name | Jojoima CHC                                      |
| F7oVR22kQ5J  | Facility_name | Elshadai Clinic                                  |
| Luv2kmWWgoG  | Facility_name | Mondema CHC                                      |
| YDDOlgRBEAA  | Facility_name | Yongoro CHP                                      |
| PEZNsGbZaVJ  | Facility_name | Panguma Mission Hosp.                            |
| qvHMAxtWWK6  | Facility_name | Burma 2 MCHP                                     |
| kqyeoWyfDmQ  | Facility_name | Mofombo MCHP                                     |
| LmRTf03IFkA  | Facility_name | Mambiama CHP                                     |
| cw0Wm1QTHRq  | Facility_name | Joru CHC                                         |
| Ep5iWL1UKvF  | Facility_name | Kurubonla CHC                                    |
| qEQFWnKh4gs  | Facility_name | Maharie MCHP                                     |
| EH0dXLB4nZg  | Facility_name | Masimera CHC                                     |
| XiORvSsxn6s  | Facility_name | Mayogbor MCHP                                    |
| egv5Es0QlQP  | Facility_name | Kigbai MCHP                                      |
| YQ3csPLAlrn  | Facility_name | St. Joseph CHC                                   |
| FZxJ0KST9jn  | Facility_name | Gelehun MCHP                                     |
| YFlZA0y0Vi6  | Facility_name | Mamanso Sanka CHP                                |
| aQoqXL4cZaF  | Facility_name | Fullah Town (B.Sebora) MCHP                      |
| vv1QJFONsT6  | Facility_name | St. Joseph’s Clinic                              |
| y77LiPqLMoq  | Facility_name | Gbenikoro MCHP                                   |
| FNnj3jKGS7i  | Facility_name | Bandajuma Clinic CHC                             |
| QII5GqfDfO3  | Facility_name | Ngiehun Kongo CHP                                |
| SFQblJrFblm  | Facility_name | Laleihun CHP                                     |
| kFScvrF3wPo  | Facility_name | Madina MCHP                                      |
| ObV5AR1NECl  | Facility_name | Karina MCHP                                      |
| T62lSjsZe9n  | Facility_name | Komba Yendeh CHP                                 |
| BDBXHeASwHl  | Facility_name | Katongha MCHP                                    |
| PfZXxl6Wp3F  | Facility_name | Sulima CHP                                       |
| IcVHzEm0b6Z  | Facility_name | Bonkababay MCHP                                  |
| agM0BKQlTh3  | Facility_name | Batkanu CHC                                      |
| IPvrsWbm0EM  | Facility_name | Gbalamuya MCHP                                   |
| Tht0fnjagHi  | Facility_name | Serabu Hospital Mission                          |
| ApLCxUmnT6q  | Facility_name | Maborie MCHP                                     |
| jSPLEMDwXN4  | Facility_name | Rofoindu CHP                                     |
| DUDHgE5DECu  | Facility_name | Shekaia MCHP                                     |
| e2WgqiasKnD  | Facility_name | Taiama (Kori) CHC                                |
| KcCbIDzRcui  | Facility_name | Matotoka CHC                                     |
| Zr7pgiajIo9  | Facility_name | Komende (Kaiyamba) MCHP                          |
| GQcsUZf81vP  | Facility_name | Govt. Hosp. Makeni                               |
| Ykx8Ovui7g0  | Facility_name | Upper Saama MCHP                                 |
| kMTHqMgenme  | Facility_name | Morning Star Clinic                              |
| wP1zsnNxbSE  | Facility_name | Kasoria MCHP                                     |
| cgqkFdShPzg  | Facility_name | Loreto Clinic                                    |
| JemZqD90S44  | Facility_name | Dawa MCHP                                        |
| BzEwqabuW19  | Facility_name | Thompson Bay MCHP                                |
| BgOhMcH9bxq  | Facility_name | Levuma Kai MCHP                                  |
| LqH7ZGU9KAx  | Facility_name | PCM Hospital                                     |
| QCnJDmNjQy0  | Facility_name | Junctionla MCHP                                  |
| f6xGA6BZBLO  | Facility_name | Perrie MCHP                                      |
| Z0q0Y3GRugt  | Facility_name | Massabendu CHP                                   |
| vwvDblM3MNX  | Facility_name | Gbolon MCHP                                      |
| OwhDCucf4Ue  | Facility_name | Fotaneh Junction MCHP                            |
| rIgJX4N0DGZ  | Facility_name | Macauley Satellite Hospital                      |
| IlMQTFvcq9r  | Facility_name | Lowoma CHC                                       |
| WUQrS4Yqmoy  | Facility_name | Kuranko MCHP                                     |
| CgunjDKbM45  | Facility_name | Makalie MCHP                                     |
| sDTodaygv5u  | Facility_name | Bath Bana MCHP                                   |
| pNPmNeqyrim  | Facility_name | Foindu (Lower Bamabara) CHC                      |
| iH79WhpsByj  | Facility_name | Massayeima MCHP                                  |
| Zq9ATbrmKIa  | Facility_name | Komende Luyaima MCHP                             |
| JttXgTlQAGE  | Facility_name | Ganya MCHP                                       |
| K00jR5dmoFZ  | Facility_name | Karlu CHC                                        |
| fmLRqcL9sWF  | Facility_name | Fankoya MCHP                                     |
| xa4F6gesVJm  | Facility_name | York CHC                                         |
| Vh1fsWOYcv1  | Facility_name | Mamuntha MCHP                                    |
| JKhjdiwoQZu  | Facility_name | Foria CHP                                        |
| DwpbWkiqjMy  | Facility_name | Bumbeh MCHP                                      |
| hzf90qz08AW  | Facility_name | Njama CHC                                        |
| OcRCVRy2M7X  | Facility_name | Benkia MCHP                                      |
| CFPrsD3dNeb  | Facility_name | Tissana CHC                                      |
| KYXbIQBQgP1  | Facility_name | Tikonko CHC                                      |
| MpcMjLmbATv  | Facility_name | Bandajuma Yawei CHC                              |
| DKZnUSfwjKx  | Facility_name | Tikonko (gaura) MCHP                             |
| BG2fC2mRFOL  | Facility_name | Saahun (kpaka) MCHP                              |
| Efmr3Xo36DR  | Facility_name | Senehun Gbloh MCHP                               |
| lmNWdmeOYmV  | Facility_name | Kissy Town CHP                                   |
| OjRCvy71kAL  | Facility_name | Mafaray CHP                                      |
| OjXNuYyLaCJ  | Facility_name | Sendugu CHC                                      |
| vlNXjc2lk9y  | Facility_name | Mano Menima CHP                                  |
| t6S2MopeRaM  | Facility_name | Nyandehun (Mano Sakrim) MCHP                     |
| KxtLZtVmpur  | Facility_name | Leicester (RWA) CHP                              |
| GhXvo3BpCvo  | Facility_name | Kerefay Loko MCHP                                |
| AekX8HBymng  | Facility_name | Gissiwolo MCHP                                   |
| mokUyyg3olJ  | Facility_name | Konjo CHP                                        |
| wSHfjjFqUay  | Facility_name | Makarie MCHP                                     |
| QIp6DHlMGfb  | Facility_name | Baptist Centre Kassirie                          |
| yXBtSoD0IRS  | Facility_name | Samiquidu MCHP                                   |
| K6oyIMh7Lee  | Facility_name | Fadugu CHC                                       |
| t0DLywkw6O1  | Facility_name | Masingbi-Lol MCHP                                |
| byOPfWkK6M6  | Facility_name | Petifu Line MCHP                                 |
| bSj2UnYhTFb  | Facility_name | Kamaranka CHC                                    |
| ZSBnWFBpPPJ  | Facility_name | Kondewakoro CHP                                  |
| vxExu6yOYLg  | Facility_name | Maborognor MCHP                                  |
| yMCshbaVExv  | Facility_name | Babara CHC                                       |
| DwlFKzDSuQU  | Facility_name | Nyandeyaima MCHP                                 |
| Qr41Mw2MSjo  | Facility_name | Senthai MCHP                                     |
| rxc497GUdDt  | Facility_name | Banka Makuloh MCHP                               |
| kBrq7i12aan  | Facility_name | Malama MCHP                                      |
| rZxk3S0qN63  | Facility_name | Bo Govt. Hosp.                                   |
| g5A3hiJlwmI  | Facility_name | UMC Mitchener Memorial Maternity & Health Centre |
| oNqqmKD0zXj  | Facility_name | Tambaliabalia MCHP                               |
| qjboFI0irVu  | Facility_name | Air Port Centre, Lungi                           |
| G5NCnFJ3bbV  | Facility_name | Makrugbeh MCHP                                   |
| lekPjgUm0o2  | Facility_name | Kingtom Police Hospital (MI Room)                |
| rm60vuHyQXj  | Facility_name | Nengbema CHC                                     |
| Mod8hYpQ3Ma  | Facility_name | Malema (Yawei) CHP                               |
| iOA3z6Y3cq5  | Facility_name | Largo CHC                                        |
| TWMVxJANJeU  | Facility_name | Kabba Ferry MCHP                                 |
| MXdbul7bBqV  | Facility_name | Mobai CHC                                        |
| U8uqyDAu5bH  | Facility_name | Govt. Hospital Moyamba                           |
| foPGXhwhlqp  | Facility_name | MCH Static Pujehun                               |
| EJoI3HArJ2W  | Facility_name | Bum Kaku MCHP                                    |
| w3vRmEz3J7t  | Facility_name | Mamboma MCHP                                     |
| dkmpOuVhBba  | Facility_name | Mathoir CHC                                      |
| xWIyicUgscN  | Facility_name | St. John of God Catholic Hospital                |
| mTNOoGXuC39  | Facility_name | Under Fives Clinic                               |
| ctN0WgIvfke  | Facility_name | Mattru UBC Hospital                              |
| fvytjjnlQlK  | Facility_name | Motoni MCHP                                      |
| xO9WbCvFq5k  | Facility_name | Mercy Ship ACFC                                  |
| L05Bfpu7AcZ  | Facility_name | Gbeworbu-Gao CHP                                 |
| jjtzkzrmG7s  | Facility_name | Banana Island MCHP                               |
| UgYg0YW7ZIh  | Facility_name | Taninahun (Malen) CHP                            |
| vpNGJvZ0ljF  | Facility_name | Massam MCHP                                      |
| lvxIJAb2QJo  | Facility_name | Sembehun Mamagewor MCHP                          |
| sFgNRYS5pBo  | Facility_name | Magbass MCHP                                     |
| J1x66stNjk2  | Facility_name | Hunduwa CHP                                      |
| QkczRcSeNck  | Facility_name | Kpowubu MCHP                                     |
| lpAPY3QOY2D  | Facility_name | Bandawor MCHP                                    |
| NfE9gvFwLIF  | Facility_name | Rokupa Govt. Hospital                            |
| SoXpnYO84eZ  | Facility_name | Venima CHP                                       |
| pRg7dkjqNPc  | Facility_name | Falaba CHP                                       |
| OuwX8H2CcRO  | Facility_name | Teko Barracks Clinic                             |
| XuGfiry96Bg  | Facility_name | Wellbody MCHP                                    |
| gei3Sqw8do7  | Facility_name | KingHarman Rd. Hospital                          |
| cZxP4NE5O9z  | Facility_name | Lion for Lion Clinic                             |
| ncGs9vXS36w  | Facility_name | Small Sefadu MCHP                                |
| XePkcmza9e8  | Facility_name | Makarankay MCHP                                  |
| Yc8Cmr5XS4B  | Facility_name | Petifu Fulamasa MCHP                             |
| RAsstekPRco  | Facility_name | Mambolo CHC                                      |
| XkA2vbJAWHG  | Facility_name | Barmoi CHP                                       |
| SptGAcmbgPz  | Facility_name | Tissana MCHP                                     |
| DIQl5jJ17IE  | Facility_name | Magbaingba MCHP                                  |
| bqSIIRuZ1qj  | Facility_name | Koindukura MCHP                                  |
| PdGktj8bAML  | Facility_name | UBC Under 5                                      |
| YQYgz8exK9S  | Facility_name | Bombordu MCHP                                    |
| dczh6Jfd4no  | Facility_name | Kayasie MCHP                                     |
| U8tyWV7WmIB  | Facility_name | Gbeika MCHP                                      |
| Xnif5imKLlT  | Facility_name | Macrogba MCHP                                    |
| AQQCxQqDxLe  | Facility_name | Konta CHP                                        |
| uoPC2z9r7Cc  | Facility_name | Seidu MCHP                                       |
| sAO5hEWo4z5  | Facility_name | Mokorewa MCHP                                    |
| PcADvhvcaI2  | Facility_name | Kychom CHC                                       |
| HMltAwIjIIe  | Facility_name | Moribaya MCHP                                    |
| hTGeTrwzrPi  | Facility_name | Sandaru (Gaura) MCHP                             |
| iHQVo7h7KOQ  | Facility_name | Taninihun Kapuima MCHP                           |
| OGaAWQD6SYs  | Facility_name | Kalainkay MCHP                                   |
| XJI24bY3AN7  | Facility_name | Salina CHP                                       |
| OZ1olxsTyNa  | Facility_name | Bandajuma Sinneh MCHP                            |
| OwHjzJEVEUN  | Facility_name | Kamabaio MCHP                                    |
| DMxw0SASFih  | Facility_name | Koindu CHC                                       |
| WMj6mBDw76A  | Facility_name | Njama MCHP                                       |
| eLLMnNjuluX  | Facility_name | Barakuya MCHP                                    |
| JZraNIfZ5JM  | Facility_name | Grey Bush CHC                                    |
| vj0HUVazItT  | Facility_name | Koije MCHP                                       |
| ifw5aLygJEi  | Facility_name | Gbainty Wallah CHP                               |
| TrIXhUR4sDQ  | Facility_name | Mathen MCHP                                      |
| JiEz2VDLwHY  | Facility_name | Komboya Gbauja MCHP                              |
| z1ielwdLtPl  | Facility_name | Foredugu MCHP                                    |
| v2vi8UaIYlo  | Facility_name | Gbonkonka CHP                                    |
| fHqBRE3LTiQ  | Facility_name | Robina MCHP                                      |
| Ls2ESQONh9S  | Facility_name | Koidu Under Five Clinic                          |
| rFelzKE3SEp  | Facility_name | Salima MCHP                                      |
| D0iakqyTknH  | Facility_name | Rorocks CHP                                      |
| Vnc2qIRLbyw  | Facility_name | SLRCS (Nongowa) clinic                           |
| j57JudVQJtn  | Facility_name | Magbaesa MCHP                                    |
| IHa6fsNWsOZ  | Facility_name | Niayahun CHP                                     |
| kLNQT4KQ9hT  | Facility_name | Marie Stopes (Kakua) Clinic                      |
| PWqwcBdRGIH  | Facility_name | Magboki Rd. Mile 91 MCHP                         |
| JBhJiwqBCUa  | Facility_name | Mayolla MCHP                                     |
| hjqgB6hEdl3  | Facility_name | Topan CHP                                        |
| E497Rk80ivZ  | Facility_name | Bumpe CHC                                        |
| sznCEDMABa2  | Facility_name | Ngiehun CHC                                      |
| bne6tOoPaWn  | Facility_name | Nomo Faama CHP                                   |
| XfVYz6l2rzg  | Facility_name | Magbolonthor MCHP                                |
| si34vmovtgR  | Facility_name | Makolor CHP                                      |
| Brre03pQkKB  | Facility_name | Ngessehun MCHP                                   |
| RzgSFJ9E46G  | Facility_name | Jormu MCHP                                       |
| i7qaYfmGVDr  | Facility_name | Gbotima MCHP                                     |
| roGdTjEqLZQ  | Facility_name | Yormandu CHC                                     |
| r93q83kZoR9  | Facility_name | Gbangba MCHP                                     |
| aIsnJuZbmVA  | Facility_name | Dogoloya CHP                                     |
| DqfiI6NVnB1  | Facility_name | Sembehun 17 CHP                                  |
| SzEmaH63Qe8  | Facility_name | Kwellu Ngieya CHP                                |
| M9q1wOOsrXp  | Facility_name | Yara MCHP                                        |
| g9xUM1x1f1i  | Facility_name | Samandu MCHP                                     |
| UJ80rknbJtm  | Facility_name | Magbeni MCHP                                     |
| IW3guWF3uvF  | Facility_name | Loppa CHP                                        |
| TbiRD4Bsz4Z  | Facility_name | Fulamansa MCHP                                   |
| oxAoPoePpqy  | Facility_name | Gbaneh Lol MCHP                                  |
| Crgx572DnXR  | Facility_name | Kaponkie MCHP                                    |
| CqARw68kXbB  | Facility_name | Pehala MCHP                                      |
| QZtMuEEV9Vv  | Facility_name | Rokupr CHC                                       |
| szbAJSWOXjT  | Facility_name | Boroma MCHP                                      |
| U4FzUXMvbI8  | Facility_name | Conakry Dee CHC                                  |
| AXZq6q7Dr6E  | Facility_name | Buma MCHP                                        |
| PnMPARoMhWW  | Facility_name | Mattru Jong MCHP                                 |
| nv41sOz8IVM  | Facility_name | Pejewa CHC                                       |
| So2b8zJfcMa  | Facility_name | Kpayama 1 MCHP                                   |
| nZblzPvJ5UW  | Facility_name | Rolembray MCHP                                   |
| aVycEyoSBJx  | Facility_name | Fogbo (WAR) MCHP                                 |
| EmTN0L4EAVi  | Facility_name | SLRCS (Freetown) Clinic                          |
| S7KwVLbFlss  | Facility_name | Kpuabu MCHP                                      |
| e5sGsWLEn3k  | Facility_name | Kondeya (Sandor) MCHP                            |
| U9klfqqGlRa  | Facility_name | Mana II CHP                                      |
| m3VnSQbE8CD  | Facility_name | Newton CHC                                       |
| DxguTiXvIJu  | Facility_name | Helegombu MCHP                                   |
| AGrsLyKWrVX  | Facility_name | Kania MCHP                                       |
| UlgEReuUPM4  | Facility_name | Masumana MCHP                                    |
| DVjewuIdgMN  | Facility_name | Woreh Bana MCHP                                  |
| bLYNonGzr0Y  | Facility_name | Mokainsumana CHP                                 |
| vxa2YQRGV7I  | Facility_name | St. Luke’s Wellington                            |
| U514Dz4v9pv  | Facility_name | George Brook Health Centre                       |
| r4W2vzlmPhm  | Facility_name | Feiba CHP                                        |
| wUmVUKhnPuy  | Facility_name | Kangahun CHC                                     |
| vELaJEPLOPF  | Facility_name | Barmoi Munu CHP                                  |
| REtQE1gstTf  | Facility_name | Sembeima MCHP                                    |
| wQ71REGAMet  | Facility_name | Benkeh MCHP                                      |
| w9FJ9oAdFys  | Facility_name | UFC Magburaka                                    |
| uczMdDZXdtl  | Facility_name | New London MCHP                                  |
| InQWjSe6k2f  | Facility_name | Saahun (barri) MCHP                              |
| R9gZAoI9aQM  | Facility_name | Mokotawa CHP                                     |
| VjygCFzqcYu  | Facility_name | Njagbahun MCHP                                   |
| mUuCjQWMaOc  | Facility_name | Bambara MCHP                                     |
| Z8Cm76B2726  | Facility_name | Mayassoh MCHP                                    |
| gE3gEGZbQMi  | Facility_name | Madina (BUM) CHC                                 |
| zuXW98AEbE7  | Facility_name | Kamasondo CHC                                    |
| eRg3KZyWUSJ  | Facility_name | Fullawahun MCHP                                  |
| KQFAul3T9xz  | Facility_name | Nafaya MCHP                                      |
| TjZwphhxCuV  | Facility_name | Kagbere CHC                                      |
| LV2b3vaLRl1  | Facility_name | Holy Mary Clinic                                 |
| GyH8bjdOTsD  | Facility_name | Mansadu MCHP                                     |
| VhRX5JDVo7R  | Facility_name | Waterloo CHC                                     |
| VjVYaKZ9t4K  | Facility_name | Menicurve MCHP                                   |
| uPshwz3B3Uu  | Facility_name | Bandasuma CHP                                    |
| pvTYrkG1d6f  | Facility_name | Rogbaneh MCHP                                    |
| dx4NOnoGtE7  | Facility_name | Yemoh MCHP                                       |
| Z7UAnjpK74g  | Facility_name | Looking Town MCHP                                |
| Dluer5aKZmd  | Facility_name | Semabu MCHP                                      |
| ldXIdLNUNEn  | Facility_name | Connaught Hospital                               |
| HC2NlwpoXfb  | Facility_name | Kombilie MCHP                                    |
| azRICFoILuh  | Facility_name | Golu MCHP                                        |
| ptc0SQi05E4  | Facility_name | Massah Memorial Maternity MCHP                   |
| XQudzejlhJZ  | Facility_name | UFC Nongowa                                      |
| aSfF9kuNINJ  | Facility_name | Bambuibu Tommy MCHP                              |
| ke2gwHKHP3z  | Facility_name | Petifu CHC                                       |
| VH8vOjm0l8w  | Facility_name | Jui CHP                                          |
| T1lTKu6zkHN  | Facility_name | Mamanso Kafla MCHP                               |
| prNiMdHuaaU  | Facility_name | Serabu (Bumpe Ngao) UFC                          |
| CbIWQQoWcLc  | Facility_name | Kabombeh MCHP                                    |
| i7Oh2tlkToJ  | Facility_name | Fodaya MCHP                                      |
| g10jm7jPdzf  | Facility_name | Hangha CHC                                       |
| SQz3xtx1Sgr  | Facility_name | Yankasa MCHP                                     |
| DiszpKrYNg8  | Facility_name | Ngelehun CHC                                     |
| sYjp3h6amhA  | Facility_name | Mendekelema CHP                                  |
| Urk55T8KgpT  | Facility_name | Yoyah CHP                                        |
| OTlKtnhvEm1  | Facility_name | Kagbo MCHP                                       |
| GKrklllwmbU  | Facility_name | Sogballeh MCHP                                   |
| bPJABq7F5Iy  | Facility_name | Rogbangba MCHP                                   |
| J3wTSn87RP2  | Facility_name | Manjeihun MCHP                                   |
| g8upMTyEZGZ  | Facility_name | Njandama MCHP                                    |
| cdmkMyYv04T  | Facility_name | Leprosy & TB Hospital                            |
| mRNfATVxa3m  | Facility_name | Mangaybana CHP                                   |
| sM0Us0NkSez  | Facility_name | Kroo Bay CHC                                     |
| d7hw1ababST  | Facility_name | Konjo MCHP                                       |
| G6LbealddgU  | Facility_name | Sawuria CHP                                      |
| jNb63DIHuwU  | Facility_name | Baoma Station CHP                                |
| LFpl1falVZi  | Facility_name | Gbindi CHP                                       |
| YldSFPxB6WH  | Facility_name | Makiteh MCHP                                     |
| u3B5RqJuDAP  | Facility_name | Njagbahun (L.Banta) MCHP                         |
| aXnGiQGhOAj  | Facility_name | Lawana (Kongbora) MCHP                           |
| EFTcruJcNmZ  | Facility_name | Yengema CHP                                      |
| Jd7G0NYBTx1  | Facility_name | Sebengu MCHP                                     |
| TmCsvdJLHoX  | Facility_name | Mabunduka CHC                                    |
| BNFrspDBKel  | Facility_name | Zimmi CHC                                        |
| Wr8kmywwseZ  | Facility_name | Benduma MCHP                                     |
| ALnjmvcRSxU  | Facility_name | Madina Wesleyan Mission                          |
| dBD9OHJFN8u  | Facility_name | Yekior MCHP                                      |
| DplgrYeRIZ1  | Facility_name | John Thorpe MCHP                                 |
| iPcreOldeV9  | Facility_name | Benguema MI Room                                 |
| Yj2ni275yPJ  | Facility_name | Baoma (Koya) CHC                                 |
| UUZoBCSn245  | Facility_name | Rokel (Masimera) MCHP                            |
| eqPIdr5yD1Q  | Facility_name | Rokolon MCHP                                     |
| SnCrOCRrxGX  | Facility_name | Koakoyima CHC                                    |
| zLiMZ1WrxdG  | Facility_name | Panlap MCHP                                      |
| wtdBuXDwZYQ  | Facility_name | Praise Foundation CHC                            |
| PaNv9VyD06n  | Facility_name | Manowa CHC                                       |
| GHPuYdLcVN5  | Facility_name | Tawahun MCHP                                     |
| GvFqTavdpGE  | Facility_name | Agape CHP                                        |
| w9XjBMJYL9R  | Facility_name | MCH Static/U5                                    |
| lBMmM0HBp4s  | Facility_name | Musaia (Koinadugu) CHC                           |
| AlLmKZIIIT4  | Facility_name | Gbamandu MCHP                                    |
| UoLtRvXxNaB  | Facility_name | Maronko MCHP                                     |
| uRQj8WRK0Py  | Facility_name | Masongbo CHC                                     |
| KuR0y0h0mOM  | Facility_name | Marie Stopes Clinic (Abedeen R)                  |
| H0OkaM4ReRK  | Facility_name | Sam Lean’s MCHP                                  |
| k1Y0oNqPlmy  | Facility_name | Gboyama CHC                                      |
| cZZG5BMDLps  | Facility_name | Borongoh Makarankay CHP                          |
| CKkE4GBJekz  | Facility_name | Weima CHC                                        |
| Xzxy8NuVsLp  | Facility_name | Mabayo MCHP                                      |
| XsB16iHtwLL  | Facility_name | Mania MCHP                                       |
| CebtBqqp1fp  | Facility_name | Makoni Line MCHP                                 |
| EZIMUaUD8AJ  | Facility_name | Rogballan CHP                                    |
| U7yKrx2QVet  | Facility_name | Bandaperie CHP                                   |
| eyfrdOUUkXO  | Facility_name | Masankorie CHP                                   |
| L5gENbBNNup  | Facility_name | Boajibu CHC                                      |
| zw5ppT2dwZy  | Facility_name | Tokpombu (Dama) CHP                              |
| oiSllOTiHNx  | Facility_name | Thellia CHP                                      |

After identifying the correct organisation unit and program IDs or
names, users can import the corresponding data using the
[`read_dhis2()`](https://epiverse-trace.github.io/readepi/reference/read_dhis2.md)
with the following syntax:

``` r
# IMPORT DATA FROM DHIS2 FOR THE SPECIFIED ORGANISATION UNIT AND PROGRAM IDs
data <- read_dhis2(
  login = dhis2_login,
  org_unit = "XjpmsLNjyrz",
  program = "IpHINAT79UW"
)
```

|      | event       | tracked_entity | org_unit     | Gender | First name | Last name  | enrollment  | program         | program_stage  | event_date              | MCH Infant Feeding | MCH Infant Weight (g) | MCH Vit A | MCH Infant HIV Test Result | MCH HIV Test Type |
|:-----|:------------|:---------------|:-------------|:-------|:-----------|:-----------|:------------|:----------------|:---------------|:------------------------|:-------------------|:----------------------|:----------|:---------------------------|:------------------|
| 1    | sj970m8NlXM | SizBw0WqOxL    | Magbaft MCHP | Female | Lisa       | Andrews    | PaO7W8X52xX | Child Programme | Baby Postnatal | 2026-07-30T00:00:00.000 | Replacement        | 2722                  | true      | Negative-Conf              | PCR               |
| 2    | u0jZS3HfoiY | SizBw0WqOxL    | Magbaft MCHP | Female | Lisa       | Andrews    | PaO7W8X52xX | Child Programme | Birth          | 2026-07-09T00:00:00.000 | Replacement        | NA                    | NA        | NA                         | NA                |
| 3    | D3jCrBt7iDe | I6Fg4qZ4Mhi    | Magbaft MCHP | Female | Alice      | Kim        | gNs5FbaEU2k | Child Programme | Baby Postnatal | 2026-03-27T00:00:00.000 | Exclusive          | 2843                  | false     | Postive √                  | PCR               |
| 4    | TPtrsgIDASw | I6Fg4qZ4Mhi    | Magbaft MCHP | Female | Alice      | Kim        | gNs5FbaEU2k | Child Programme | Birth          | 2026-03-06T00:00:00.000 | Exclusive          | NA                    | NA        | NA                         | NA                |
| 5    | gVzZDJqeMJs | PxmC9mN2o9u    | Magbaft MCHP | Male   | Aaron      | Torres     | Cw4r8iO3uF9 | Child Programme | Baby Postnatal | 2026-09-17T00:00:00.000 | Mixed              | 2518                  | false     | Postive √                  | PCR               |
| 6    | oKDSQpeHljW | PxmC9mN2o9u    | Magbaft MCHP | Male   | Aaron      | Torres     | Cw4r8iO3uF9 | Child Programme | Birth          | 2026-08-27T00:00:00.000 | Exclusive          | NA                    | NA        | NA                         | NA                |
| 7    | quYCqxPh6Lz | JAlFuII6Vs6    | Magbaft MCHP | Male   | Eugene     | West       | KCW6OupXaDs | Child Programme | Birth          | 2026-06-26T00:00:00.000 | Exclusive          | NA                    | NA        | NA                         | NA                |
| 8    | QXGI4IXT5nk | JAlFuII6Vs6    | Magbaft MCHP | Male   | Eugene     | West       | KCW6OupXaDs | Child Programme | Baby Postnatal | 2026-07-17T00:00:00.000 | Exclusive          | 3797                  | true      | Negative                   | Rapid             |
| 9    | ZKoBwrFweAv | EeaUGHqRjt6    | Magbaft MCHP | Male   | Gary       | Fernandez  | fkpDi1AAqJu | Child Programme | Birth          | 2026-09-16T00:00:00.000 | Exclusive          | NA                    | NA        | NA                         | NA                |
| 10   | iMYFkdaBRp9 | EeaUGHqRjt6    | Magbaft MCHP | Male   | Gary       | Fernandez  | fkpDi1AAqJu | Child Programme | Baby Postnatal | 2026-10-07T00:00:00.000 | Replacement        | 2911                  | true      | Negative-Conf              | PCR               |
| 11   | ehddEUXacSg | GCHRIfQ8F1R    | Magbaft MCHP | Female | Lillian    | Stephens   | GWVVHfYZLaJ | Child Programme | Birth          | 2026-08-02T00:00:00.000 | Exclusive          | NA                    | NA        | NA                         | NA                |
| 12   | wxT2xbmKu2A | GCHRIfQ8F1R    | Magbaft MCHP | Female | Lillian    | Stephens   | GWVVHfYZLaJ | Child Programme | Baby Postnatal | 2026-08-23T00:00:00.000 | Replacement        | 3050                  | false     | Negative                   | PCR               |
| 13   | xI9cuoNsGuc | eLq0rsbZh4K    | Magbaft MCHP | Male   | Eric       | George     | V9vYHFHm6U8 | Child Programme | Birth          | 2026-02-25T00:00:00.000 | Mixed              | NA                    | NA        | NA                         | NA                |
| 14   | HpbpNQNGCtx | eLq0rsbZh4K    | Magbaft MCHP | Male   | Eric       | George     | V9vYHFHm6U8 | Child Programme | Baby Postnatal | 2026-03-18T00:00:00.000 | Exclusive          | 3046                  | true      | Negative                   | PCR               |
| 15   | fsSOH7PltaL | lZgdWp4xUVV    | Magbaft MCHP | Male   | Dennis     | Lewis      | TnJxI3xnddm | Child Programme | Baby Postnatal | 2026-12-18T00:00:00.000 | Replacement        | 3041                  | true      | Positive                   | PCR               |
| 16   | ZCPmsYAM6PZ | lZgdWp4xUVV    | Magbaft MCHP | Male   | Dennis     | Lewis      | TnJxI3xnddm | Child Programme | Birth          | 2026-11-27T00:00:00.000 | Mixed              | NA                    | NA        | NA                         | NA                |
| 17   | yjJRc3jJUa2 | ZkoVZLiMHT1    | Magbaft MCHP | Female | Nicole     | Hernandez  | wiZWoeGbf1W | Child Programme | Birth          | 2025-01-27T00:00:00.000 | Replacement        | NA                    | NA        | NA                         | NA                |
| 18   | n5K36YDrSfd | ZkoVZLiMHT1    | Magbaft MCHP | Female | Nicole     | Hernandez  | wiZWoeGbf1W | Child Programme | Baby Postnatal | 2025-02-17T00:00:00.000 | Exclusive          | 2530                  | true      | Negative                   | Rapid             |
| 19   | jpoyRPIic4X | pgZcRfhrs3s    | Magbaft MCHP | Female | Marie      | Patterson  | VxwJkHpvnjc | Child Programme | Baby Postnatal | 2025-05-18T00:00:00.000 | Exclusive          | 3837                  | true      | Postive √                  | PCR               |
| 20   | Yh0YfWD2W9o | pgZcRfhrs3s    | Magbaft MCHP | Female | Marie      | Patterson  | VxwJkHpvnjc | Child Programme | Birth          | 2025-04-27T00:00:00.000 | Replacement        | NA                    | NA        | NA                         | NA                |
| 21   | qIHjguOown4 | CTipmhyKwyN    | Magbaft MCHP | Male   | Ronald     | Williams   | ppwTBblWxuT | Child Programme | Birth          | 2025-09-30T00:00:00.000 | Exclusive          | NA                    | NA        | NA                         | NA                |
| 22   | jmeKBUJdkx3 | CTipmhyKwyN    | Magbaft MCHP | Male   | Ronald     | Williams   | ppwTBblWxuT | Child Programme | Baby Postnatal | 2025-10-21T00:00:00.000 | Mixed              | 3526                  | false     | Postive √                  | PCR               |
| 23   | X5W8WxWh4h2 | zK4HgMbdiFe    | Magbaft MCHP | Male   | Scott      | Richardson | QwIHBtYwQit | Child Programme | Birth          | 2025-09-09T00:00:00.000 | Exclusive          | NA                    | NA        | NA                         | NA                |
| 24   | OWvhpmhr4hZ | zK4HgMbdiFe    | Magbaft MCHP | Male   | Scott      | Richardson | QwIHBtYwQit | Child Programme | Baby Postnatal | 2025-09-30T00:00:00.000 | Replacement        | 2861                  | false     | Negative-Conf              | Rapid             |
| 25   | TIfJRQfp5qM | UtaYJLbRWwN    | Magbaft MCHP | Female | Dorothy    | Holmes     | w5z4mY9AyAS | Child Programme | Baby Postnatal | 2025-12-07T00:00:00.000 | Replacement        | 2712                  | false     | Positive                   | PCR               |
| 26   | g8gEqasnX3D | UtaYJLbRWwN    | Magbaft MCHP | Female | Dorothy    | Holmes     | w5z4mY9AyAS | Child Programme | Birth          | 2025-11-16T00:00:00.000 | Exclusive          | NA                    | NA        | NA                         | NA                |
| 27   | MkmAIIJZdx2 | LJZeA4avYHt    | Magbaft MCHP | Female | Ann        | Ferguson   | EL54kqMlwum | Child Programme | Birth          | 2025-01-23T00:00:00.000 | Exclusive          | NA                    | NA        | NA                         | NA                |
| 28   | DYVijbMKdHS | LJZeA4avYHt    | Magbaft MCHP | Female | Ann        | Ferguson   | EL54kqMlwum | Child Programme | Baby Postnatal | 2025-02-13T00:00:00.000 | Mixed              | 2539                  | true      | Negative-Conf              | PCR               |
| 29   | mx2ilIVlv6s | AvwNCH08FJ5    | Magbaft MCHP | Female | Ashley     | Thompson   | CqFTMUn7srR | Child Programme | Baby Postnatal | 2025-10-01T00:00:00.000 | Replacement        | 2617                  | false     | Positive                   | Rapid             |
| 30   | f6FbysfGtfP | AvwNCH08FJ5    | Magbaft MCHP | Female | Ashley     | Thompson   | CqFTMUn7srR | Child Programme | Birth          | 2025-09-10T00:00:00.000 | Mixed              | NA                    | NA        | NA                         | NA                |
| 31   | qia3GHAgC1B | IOOia4y13Uw    | Magbaft MCHP | Male   | Russell    | Ferguson   | oHKDiNMMZ5W | Child Programme | Baby Postnatal | 2026-01-08T00:00:00.000 | Exclusive          | 3100                  | true      | Postive √                  | Rapid             |
| 32   | RGrUfx0HHMJ | IOOia4y13Uw    | Magbaft MCHP | Male   | Russell    | Ferguson   | oHKDiNMMZ5W | Child Programme | Birth          | 2025-12-18T00:00:00.000 | Replacement        | NA                    | NA        | NA                         | NA                |
| 33   | bPdT2Aj2X94 | fqwvqq2DTiH    | Magbaft MCHP | Female | Sharon     | Frazier    | nBbKZCmzWeG | Child Programme | Birth          | 2025-04-13T00:00:00.000 | Mixed              | NA                    | NA        | NA                         | NA                |
| 34   | CMqywTDAuwe | fqwvqq2DTiH    | Magbaft MCHP | Female | Sharon     | Frazier    | nBbKZCmzWeG | Child Programme | Baby Postnatal | 2025-05-04T00:00:00.000 | Mixed              | 2919                  | false     | Negative-Conf              | PCR               |
| 35   | YclTSPU7h5i | uACoQ7HciFH    | Magbaft MCHP | Female | Patricia   | Bennett    | BxWiI7RaA9L | Child Programme | Baby Postnatal | 2025-09-20T00:00:00.000 | Mixed              | 2937                  | false     | Negative                   | PCR               |
| 36   | xkjmvCnHw5e | uACoQ7HciFH    | Magbaft MCHP | Female | Patricia   | Bennett    | BxWiI7RaA9L | Child Programme | Birth          | 2025-08-30T00:00:00.000 | Mixed              | NA                    | NA        | NA                         | NA                |
| 37   | ZbiWjXPGuDv | FiJZ1pU8KEz    | Magbaft MCHP | Male   | Fred       | Kennedy    | MdLi1ru1u4i | Child Programme | Birth          | 2025-03-02T00:00:00.000 | Mixed              | NA                    | NA        | NA                         | NA                |
| 38   | NMyf58Bpt49 | FiJZ1pU8KEz    | Magbaft MCHP | Male   | Fred       | Kennedy    | MdLi1ru1u4i | Child Programme | Baby Postnatal | 2025-03-23T00:00:00.000 | Exclusive          | 3045                  | true      | Negative                   | PCR               |
| 39   | LbV4b7nvRfJ | RaBRZNScFoV    | Magbaft MCHP | Male   | Bruce      | Wright     | H5RbmJPZWXi | Child Programme | Baby Postnatal | 2025-10-29T00:00:00.000 | Replacement        | 2628                  | true      | Negative-Conf              | PCR               |
| 40   | VqNf7BGxMxg | RaBRZNScFoV    | Magbaft MCHP | Male   | Bruce      | Wright     | H5RbmJPZWXi | Child Programme | Birth          | 2025-10-08T00:00:00.000 | Exclusive          | NA                    | NA        | NA                         | NA                |
| NA   | NA          | NA             | NA           | NA     | NA         | NA         | NA          | NA              | NA             | NA                      | NA                 | NA                    | NA        | NA                         | NA                |
| NA.1 | NA          | NA             | NA           | NA     | NA         | NA         | NA          | NA              | NA             | NA                      | NA                 | NA                    | NA        | NA                         | NA                |
| NA.2 | NA          | NA             | NA           | NA     | NA         | NA         | NA          | NA              | NA             | NA                      | NA                 | NA                    | NA        | NA                         | NA                |
| NA.3 | NA          | NA             | NA           | NA     | NA         | NA         | NA          | NA              | NA             | NA                      | NA                 | NA                    | NA        | NA                         | NA                |
| NA.4 | NA          | NA             | NA           | NA     | NA         | NA         | NA          | NA              | NA             | NA                      | NA                 | NA                    | NA        | NA                         | NA                |
| NA.5 | NA          | NA             | NA           | NA     | NA         | NA         | NA          | NA              | NA             | NA                      | NA                 | NA                    | NA        | NA                         | NA                |
| NA.6 | NA          | NA             | NA           | NA     | NA         | NA         | NA          | NA              | NA             | NA                      | NA                 | NA                    | NA        | NA                         | NA                |
| NA.7 | NA          | NA             | NA           | NA     | NA         | NA         | NA          | NA              | NA             | NA                      | NA                 | NA                    | NA        | NA                         | NA                |
| NA.8 | NA          | NA             | NA           | NA     | NA         | NA         | NA          | NA              | NA             | NA                      | NA                 | NA                    | NA        | NA                         | NA                |
| NA.9 | NA          | NA             | NA           | NA     | NA         | NA         | NA          | NA              | NA             | NA                      | NA                 | NA                    | NA        | NA                         | NA                |

### Importing data from SORMAS

The [Surveillance Outbreak Response Management and Analysis System
(SORMAS)](https://sormas.org/) is an open source eHealth system that
optimises the processes used in monitoring the spread of infectious
diseases and responding to outbreak situations. The
[`read_sormas()`](https://epiverse-trace.github.io/readepi/reference/read_sormas.md)
function can be used to import data from SORMAS through its API.

In the current version, the
[`read_sormas()`](https://epiverse-trace.github.io/readepi/reference/read_sormas.md)
function returns data for the following columns: **case_id, person_id,
sex, date_of_birth, case_origin, country, city, lat, long, case_status,
date_onset, date_admission, date_last_contact, date_first_contact,
outcome, date_outcome, Ct_values**.

It is important to note that SORMAS does not support basic
authentication i.e., the authentication details are directly provided to
the
[`read_sormas()`](https://epiverse-trace.github.io/readepi/reference/read_sormas.md)
function without a prior call of the
[`login()`](https://epiverse-trace.github.io/readepi/reference/login.md)
function. Hence, the function takes the following arguments:

- `base_url`: A character with the base URL to the target SORMAS system
- `user_name`: A character with the user name credential
- `password`: A character with the password credential
- `disease`: A character vector with the names of the diseases of
  interest.

Users can get the list of all diseases available on their SORMAS system
using the
[`sormas_get_diseases()`](https://epiverse-trace.github.io/readepi/reference/sormas_get_diseases.md)
function.

``` r
# ESTABLISH THE CONNECTION TO THE SORMAS SYSTEM
sormas_login <- login(
  type = "sormas",
  from = "https://demo.sormas.org/sormas-rest",
  user_name = "SurvSup",
  password = "Lk5R7JXeZSEc"
)

# GET THE LIST OF ALL AVAILABLE DISEASES IN THE TEST SORMAS SYSTEM
disease_names <- sormas_get_diseases(
  login = sormas_login
)
```

When relevant, users can download the data dictionary into a specific
folder using the
[`sormas_get_data_dictionary()`](https://epiverse-trace.github.io/readepi/reference/sormas_get_data_dictionary.md).
This provides an idea of the content of each column.

``` r
# DOWNLOAD AND SAVE THE DATA DICTIONARY IN YOUR CURRENT DIRECTORY
path_to_dictionary <- sormas_get_data_dictionary(path = getwd())
path_to_dictionary
#> [1] "/home/runner/work/readepi/readepi/vignettes/dictionary."
```

A call of the
[`read_sormas()`](https://epiverse-trace.github.io/readepi/reference/read_sormas.md)
function looks like below.

``` r
# FETCH ALL COVID (coronavirus) CASES FROM THE TEST SORMAS INSTANCE FROM THE
# BEGINNING OF DATA COLLECTION
covid_cases <- read_sormas(
  login = sormas_login,
  disease = "coronavirus",
  since = 0
)

# FETCH ALL COVID (coronavirus) CASES FROM THE TEST SORMAS INSTANCE SINCE
# JUNE 01, 2025
covid_cases <- read_sormas(
  login = sormas_login,
  disease = "coronavirus",
  since = as.Date("2025-06-01")
)
```

| case_id                       | person_id                     | date_onset | case_origin    | case_status    | outcome    | sex | date_of_birth | country | city | latitude | longitude | contact_id | date_last_contact | date_first_contact |
|:------------------------------|:------------------------------|:-----------|:---------------|:---------------|:-----------|:----|:--------------|:--------|:-----|:---------|:----------|:-----------|:------------------|:-------------------|
| VPMCMM-YUZENC-P3JNEW-A7K62KMU | U2BJQK-M2FWRH-FNY53G-XC4SCCMQ | 2025-11-01 | IN_COUNTRY     | CONFIRMED      | DECEASED   | NA  | NA            | NA      | NA   | NA       | NA        | NA         | NA                | NA                 |
| T4Y6UI-DXJMR3-MBVFVX-JU5QKCWU | X7U4QL-Z2AQ5I-H45DBS-H5BUSKKU | NA         | IN_COUNTRY     | NOT_CLASSIFIED | NO_OUTCOME | NA  | NA            | NA      | NA   | NA       | NA        | NA         | NA                | NA                 |
| U2QLP2-4DXBFG-6QRA7V-CKF4KH3E | WINV7F-CM7SRP-DM5KKO-AI6SCFXI | 2026-03-27 | POINT_OF_ENTRY | NOT_CLASSIFIED | NO_OUTCOME | NA  | NA            | NA      | NA   | NA       | NA        | NA         | NA                | NA                 |
