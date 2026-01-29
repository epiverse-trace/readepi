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
# LOAD readepi
library(readepi)
```

### Need for MS drivers

Users of operating systems other than Microsoft need to have the
appropriate MS driver installed into their system. The driver
installation process is documented in details in the [install drivers
vignette](https://epiverse-trace.github.io/readepi/articles/install_drivers.Rmd)
vignette.

### Authentication

To read data from RDBMS and HIS, the user is expected to have, at least,
read access to the system. To establish the connection to their system,
users can call the
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

``` r
# CONNECT TO A DHIS2 INSTANCE
dhis2_login <- login(
  type = "dhis2",
  from  = "https://smc.moh.gm/dhis",
  user_name = "test",
  password  = "Gambia@123"
)

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

# CONNECT TO A SORMAS SYSTEM
dhis2_login <- login(
  type = "sormas",
  from  = "https://demo.sormas.org/sormas-rest",
  user_name = "SurvSup",
  password  = "Lk5R7JXeZSEc"
)
```

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

## Reading data from HIS

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
  from = "https://smc.moh.gm/dhis",
  user_name = "test",
  password = "Gambia@123"
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

|          | National_name | National_id | Regional_name        | Regional_id | District_name        | District_id | Operational Zone_name        | Operational Zone_id | Town/Village_name               | Town/Village_id |
|:---------|:--------------|:------------|:---------------------|:------------|:---------------------|:------------|:-----------------------------|:--------------------|:--------------------------------|:----------------|
| test_1   | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | Abeokuta                        | jwNQq4D7b8H     |
| test_2   | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Jarrol          | kAxFyJFfYV8 | Foni Jarrol zone             | y81dl12FCm5         | Ahallullai (Wassadu Anex)       | eMLJLnVV81C     |
| test_3   | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Alimaka/Nawdeh Tenda            | qx3YSq5Tgy5     |
| test_4   | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | Allatentu                       | gN958MfQWr3     |
| test_5   | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Sabi Circuit                 | sxPzOXHGb3F         | Allunhareh Abdou                | HSxqOOoaAO1     |
| test_6   | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Basse (Fulladu East Circuit) | Q4z6iT2INEg         | Allunhari                       | IcXvjaOVrK6     |
| test_7   | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | Amsadam                         | mjDcxUOqRvA     |
| test_8   | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Jarrol          | kAxFyJFfYV8 | Foni Jarrol zone             | y81dl12FCm5         | Arankoli Kunda                  | j1rNxTEZxoe     |
| test_9   | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Babou Jobe                      | uL6vUVXQ6NS     |
| test_10  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Kulari                       | FrELcNpqo3x         | Badari                          | KE8R64jCBN8     |
| test_11  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Bafuloto zone                | eSqfgzZGsdW         | Bafuloto                        | E7MmCdr0Eft     |
| test_12  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Baipal                          | YzHNJJ7GHJE     |
| test_13  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Baja Kunda                      | Dc09cw8PsuA     |
| test_14  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Darsilameh zone              | RC8nwUH79ib         | Bajiran                         | kjZah2IoOcZ     |
| test_15  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Sabi Circuit                 | sxPzOXHGb3F         | Bajong Fula Kunda               | WvBEr7pQGpd     |
| test_16  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Darsilameh zone              | RC8nwUH79ib         | Bajonkoto                       | VOULvPpcFra     |
| test_17  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Bajonkoto/Perai Mamadi          | PQxHydb3mEG     |
| test_18  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Bajonkotong                     | i3qhz4b4aO4     |
| test_19  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Bakadagy                        | OEmp3QOJ59G     |
| test_20  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Bakary Demba                    | G1ArowJcjor     |
| test_21  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Darsilameh zone              | RC8nwUH79ib         | Bakary Sambouya                 | Uq2a1dCX6j7     |
| test_22  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Balangarr Njok                  | cSj5XV4VO4f     |
| test_23  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Balanghar Benteng Ke            | vOZQPN55077     |
| test_24  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Balanghar Chamen                | w2bmg8af3EQ     |
| test_25  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Balanghar Kerr Jarga            | g2n5nSj8nLF     |
| test_26  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Balanghar Njien                 | D7upTfLLCEe     |
| test_27  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Balanghar Njoben                | QFMeuOiiXtw     |
| test_28  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Balanghar Pallen Ndimba         | IVdxq0RRyCJ     |
| test_29  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Balangharr Choyen               | qqiV1pLBZx8     |
| test_30  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Balangharr Jalato Ndery         | LlBgOYie9dI     |
| test_31  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Balangharr Kerr Majara          | wwtUf3HWkVd     |
| test_32  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Balangharr Sey Kunda            | kBP9mZpqWSD     |
| test_33  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Balangharr Wharf Town           | hQEjNbQ2Am9     |
| test_34  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Ballanghar Kerr Jibel           | F3XPkCk92Of     |
| test_35  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Ballanghar Kerr Nderry          | MajdhuvTSTe     |
| test_36  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Ballen                          | jKfCLR8F2N8     |
| test_37  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Bambaya (Dankunu Fula)          | pRgoEl7GPBJ     |
| test_38  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Sabi Circuit                 | sxPzOXHGb3F         | Bangasia                        | UdrrsaBdHm8     |
| test_39  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Sabi Circuit                 | sxPzOXHGb3F         | Baniko Afia                     | NKeUs2NueqA     |
| test_40  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Sabi Circuit                 | sxPzOXHGb3F         | Baniko Ismaila                  | OXsOyAZyvQj     |
| test_41  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Sabi Circuit                 | sxPzOXHGb3F         | Baniko Kekoro                   | dgVJRBi7Loy     |
| test_42  | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | Banjulinding Zone            | LriPZHmEbB4         | Banjulinding                    | YdbQ2SfVdnH     |
| test_43  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | Banjuluding                     | iNWgjt02Urs     |
| test_44  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | Bankuba                         | juAIW7as8zu     |
| test_45  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | Banni                           | FM0YDubRYEJ     |
| test_46  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | Banni                           | N23a2YvJxDA     |
| test_47  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Banni                           | VNZl27qAELq     |
| test_48  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Banni                           | xVRXyG3HOJc     |
| test_49  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Sare Alpha                   | b2XRfRDmjCw         | Banni Kunda                     | bXNsdHDMDzu     |
| test_50  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | Bansang                         | rAXlaNSs5Wi     |
| test_51  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Bantang Koto Mandinka           | I7wgbWfMXRX     |
| test_52  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Bantang Koto Njama              | n3JrMcr5XO5     |
| test_53  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Bantang koto                    | yeVmUV0lhTr     |
| test_54  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Bantangel                       | e6V4KLIHejh     |
| test_55  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | Bantanto                        | PUEkehTiHeO     |
| test_56  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Tujereng zone                | YhE8nieVLdk         | Banyaka                         | SCaCf2pazXK     |
| test_57  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Fatoto (circuit)             | U3xOxX9xxv4         | Baragi Kunda                    | Q26BYUBn4ww     |
| test_58  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Barrinabeh                      | tnXoqSjgQCd     |
| test_59  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Barrow Kunda                    | TJN1BAHqX7g     |
| test_60  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Barrow Kunda                    | nCODXuSwABW     |
| test_61  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Barrow Kunda                    | sgd4mzdWy4g     |
| test_62  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Basori                          | cD7ZmL9UJn0     |
| test_63  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Basse (Fulladu East Circuit) | Q4z6iT2INEg         | Basse Santo-Su                  | r4Dk3shrn0q     |
| test_64  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Basse (Fulladu East Circuit) | Q4z6iT2INEg         | Bassending                      | zc1V7hf3YWj     |
| test_65  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Tujereng zone                | YhE8nieVLdk         | Bato Kunku                      | OcFGqjY4oSm     |
| test_66  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Batunding                       | NPJRAYmUyBO     |
| test_67  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Baya ba                         | O1bi9jfPf0c     |
| test_68  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Basse (Fulladu East Circuit) | Q4z6iT2INEg         | Berefeteh (Nafugan Modi)        | cEHi7qZDLYa     |
| test_69  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Gunjur zone                  | zmvR7h1519q         | Berending                       | KMutKzKPSIy     |
| test_70  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Berending Kobong                | wHY6fdCq56n     |
| test_71  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Bessending                      | gjP1cjy5Pfb     |
| test_72  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Dingiri                      | OpmIzMikUgb         | Bisandugu                       | el3c1ciA8gs     |
| test_73  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Bogal                           | XmSlKeE9Kg0     |
| test_74  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Bohole                          | t18CX9wNcfu     |
| test_75  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Bohoum Kunda                    | ZDS0RcVcHUL     |
| test_76  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Bolibanna                       | psyHoqeN2Tw     |
| test_77  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Bonto Koto                      | EVyn5DMNbyN     |
| test_78  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Bonto Kuta                      | yhhkBrwrFia     |
| test_79  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | Boraba                          | whuclGUUwIU     |
| test_80  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Boro Dampha Kunda               | zjoTEo333X2     |
| test_81  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Boro Kanda Kasseh               | AJjbAprwndC     |
| test_82  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Boro Modi Banni                 | PrLBGbY8JYh     |
| test_83  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Boro Samba Ya                   | ETqFfZnIzQk     |
| test_84  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Boye kunda/Sutukonding          | ADkyxylW0Hn     |
| test_85  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Briffu                          | UvolhH8zM1n     |
| test_86  | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Brikama                         | y1Z3KuvQyhI     |
| test_87  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Brikama / Lefaye                | Gwkf4DTOiYA     |
| test_88  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Brikama Hospital zone        | Al5RW4x18ui         | Brikama Hospital                | n7CaV93pq6T     |
| test_89  | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | Brufut Zone                  | QtTGfgIScf9         | Brufut                          | ZgKXOzZRayF     |
| test_90  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Jarrol          | kAxFyJFfYV8 | Foni Jarrol zone             | y81dl12FCm5         | Brumen                          | KvOxH0uAPhX     |
| test_91  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Bugingha                        | qFqhDFciM8R     |
| test_92  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Bujiling                        | pBbXcEel12m     |
| test_93  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Buluntu                         | YoEnxCiljhF     |
| test_94  | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Buniadou                        | CVjxkwdlTae     |
| test_95  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Tujereng zone                | YhE8nieVLdk         | Bunkilling Manjako              | wk1tWOwdcbj     |
| test_96  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Bunubor                         | kY6lPPRT8sz     |
| test_97  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Bunyaiba                        | oTuGAyS85Yx     |
| test_98  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Bunyainding                     | a1FVUT9Rq0B     |
| test_99  | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Burock                          | Kxzy8WzyKsS     |
| test_100 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | Buruko                          | ICbLs8pDBzX     |
| test_101 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Bust Town                       | GvNYjo8DK81     |
| test_102 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | Busumbala Zone               | djUDW9uhYZh         | Busumbala                       | ZaMRAu33dgn     |
| test_103 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Darsilameh zone              | RC8nwUH79ib         | Busura                          | vVQmMttp8l5     |
| test_104 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Busura Alieu                    | GO8ACR8AXaS     |
| test_105 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Busura Fulbe                    | Ha2fSiJfT94     |
| test_106 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Darsilameh zone              | RC8nwUH79ib         | Busuranding (Nyonfelleh)        | gOtpPbHqoHa     |
| test_107 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Bwiam                           | xx5drNtQueT     |
| test_108 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Kulari                       | FrELcNpqo3x         | Ceesay Kunda                    | r1Z83RNzPha     |
| test_109 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Jarrol          | kAxFyJFfYV8 | Foni Jarrol zone             | y81dl12FCm5         | Chabai                          | VhbErCUHalq     |
| test_110 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Chamambugu                      | ARxWDI1mthS     |
| test_111 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Chamen                          | qlB4zgVrMWr     |
| test_112 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Chamen Baka                     | wZHkPqk9Cku     |
| test_113 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Dampha Kunda                 | WsvcwF16nOD         | Chamoi                          | xxetm7NPQpJ     |
| test_114 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Chamoi Bunda                    | zuXVDy0nIn3     |
| test_115 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Chamoi Charlie                  | Tgh4bqbK7q2     |
| test_116 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Changally Chewdo                | xvetY37kmnm     |
| test_117 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Changally Lang Kaddy            | G2l7DCX5phU     |
| test_118 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Chewal                          | kp0ZYUEqJE8     |
| test_119 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Chewal Besse                    | Bk15T8j09SN     |
| test_120 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Basse (Fulladu East Circuit) | Q4z6iT2INEg         | Daba kunda                      | PlGvEvroUhD     |
| test_121 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Dampha Kunda                 | WsvcwF16nOD         | Dampha Kunda                    | ZIguHYb8PqB     |
| test_122 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Dampha Kunda                 | WsvcwF16nOD         | Dando                           | C2QG7tlszDA     |
| test_123 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Dankunku                        | kv8vJr5ju7P     |
| test_124 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | Mandinary Zone               | ctTDw9c199R         | Daranka                         | cRKeEOmfFwf     |
| test_125 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Darboe Kunda                    | KYAorIpvhoS     |
| test_126 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Darsilame Bullembu              | kW53xb4uKFs     |
| test_127 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Darsilame Jarjeh/Darsilame Sega | JDArxUkh86F     |
| test_128 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Darsilame Mandinka              | DWWVXjQjaiI     |
| test_129 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Darsilame Takutala              | rl3wVLuYzai     |
| test_130 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Darsilameh                      | NQBolHhL7QU     |
| test_131 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Dingiri                      | OpmIzMikUgb         | Darsilameh Juled                | AmIVGhlNmR5     |
| test_132 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Darsilameh zone              | RC8nwUH79ib         | Darsilami                       | hXkceHzE8JJ     |
| test_133 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Daru Salam                      | aFeegoo0G1l     |
| test_134 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Daru Salam                      | zWl3RFoAzqN     |
| test_135 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Darusalam                       | KqaXU4u17fn     |
| test_136 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Demba Kunda (Brifu Fula kunda)  | LSpuZDqhW8C     |
| test_137 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Gambisara                    | M2siBeFtFW6         | Demba Kunda Koto                | mCSz9U7ihdV     |
| test_138 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Gambisara                    | M2siBeFtFW6         | Demba Kunda Kuta                | RpJ9fSPSCIL     |
| test_139 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Demba Wandu                     | vaajibqYuBt     |
| test_140 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Demba kali                      | CUzD36s4lD8     |
| test_141 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Demba kali ngaga                | Iq4aBCIiivP     |
| test_142 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Dembanding                      | p2eNr4CvPpn     |
| test_143 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Dembel Jawo                     | Uum0lZUE7w5     |
| test_144 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Demfai                          | FLTCQ2pI30o     |
| test_145 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Demfai karim                    | Ha6xKquurKh     |
| test_146 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Sanyang zone                 | iN4zYiLgz9N         | Deya                            | iMSf6C9ddYX     |
| test_147 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Sare Alpha                   | b2XRfRDmjCw         | Diabugu Ba Sillah               | kYOZ6TAC5ly     |
| test_148 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Diabugu Batapa                  | C27BxKy5laK     |
| test_149 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Diabugu Tenda                   | vzi1QauVe22     |
| test_150 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Sabi Circuit                 | sxPzOXHGb3F         | Dibbasey Hella                  | Ri7j7lQfd6Z     |
| test_151 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Darsilameh zone              | RC8nwUH79ib         | Dimbaya                         | BgJixG2YXfK     |
| test_152 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | Dingeria                        | a6P4MaOLsTM     |
| test_153 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Dingiri                      | OpmIzMikUgb         | Dingiri                         | NNAA1NvML4V     |
| test_154 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Dobo                            | iaCFhlQHE06     |
| test_155 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Dobong                          | Dird5nSz3jR     |
| test_156 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | Dobong kunda                    | hx8oY8rGJ0w     |
| test_157 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | Draman                          | XCMZoiCCrvi     |
| test_158 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Draman                          | loZHULQvzhU     |
| test_159 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Dumbuto                         | L9ubjzmFOZI     |
| test_160 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | Duta wally                      | VxByx8mV5ee     |
| test_161 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Duwasu                          | NDRbpSDGNoB     |
| test_162 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Darsilameh zone              | RC8nwUH79ib         | Ebou Ya                         | ScYDN9beo7k     |
| test_163 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Elli Kunda                      | fR9xXjuZxuC     |
| test_164 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Sanyang zone                 | iN4zYiLgz9N         | Faala 1                         | ai0kLypQp1q     |
| test_165 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Fadia Kunda                     | lBSkoSJGJMv     |
| test_166 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Fantumbung                      | jE5sny5JZez     |
| test_167 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Faraba Banta                    | sugVw24RwMd     |
| test_168 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Faraba Banta Jalikassa          | pGhGV2ko0ah     |
| test_169 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Faraba Sutu                     | lpHI2PcUOlB     |
| test_170 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Farato                          | kndhefw6tPu     |
| test_171 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Farato zone                  | cOVhDahQHpz         | Farato                          | LAX4zx5rUFi     |
| test_172 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Wellingara zone              | pcdArzRLIMO         | Farato Bojang Kunda             | rdxVgR0Xtjh     |
| test_173 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Sabi Circuit                 | sxPzOXHGb3F         | Fass Bajong                     | tnED5GtvbXb     |
| test_174 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | Fass Bellal                     | lxzSFiRp5pL     |
| test_175 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Fass Jimara                     | jGQEyV8qZ0x     |
| test_176 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Jarrol          | kAxFyJFfYV8 | Foni Jarrol zone             | y81dl12FCm5         | Fass chabai                     | MOE6z7EAfce     |
| test_177 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Fata Tenda                      | lKhgyotg0Hn     |
| test_178 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Fatako                          | pGVfuxhS2IR     |
| test_179 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Fatoto (circuit)             | U3xOxX9xxv4         | Fatoto                          | AfOztTn4x9o     |
| test_180 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | Fittu fula                      | T3NltShHq8x     |
| test_181 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | Fittu wollof                    | jdh3b95pfOV     |
| test_182 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Foday Kunda                     | kJfgb15tGds     |
| test_183 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Fori                            | VpnzmDkf0xF     |
| test_184 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | Fori                            | WBWkrVc4i9h     |
| test_185 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Fufo                            | UgLjINdviqc     |
| test_186 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | Fuga                            | MSHaBBtOvJG     |
| test_187 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Funtang                         | WHsKcFv6WRr     |
| test_188 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | Futayel                         | NbQca9LUm1b     |
| test_189 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Fatoto (circuit)             | U3xOxX9xxv4         | Gadafarro                       | sniNi1Uipgv     |
| test_190 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | Galleh manda                    | gNgyBp9Aaog     |
| test_191 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | Galleh wollof                   | kie7gRwiLSc     |
| test_192 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Bafuloto zone                | eSqfgzZGsdW         | Galloya                         | JZRMPYhS6kl     |
| test_193 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Gambisara                    | M2siBeFtFW6         | Gambisara                       | jksuqXpGgzG     |
| test_194 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Fatoto (circuit)             | U3xOxX9xxv4         | Garawol                         | vcLjIYgafxo     |
| test_195 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Garawol Kuta                    | L5qATaT5FUt     |
| test_196 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Geinge Tukulorr                 | I7ZynnSWFP5     |
| test_197 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Geinge Wollof                   | Bk9T354GOVs     |
| test_198 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Gendeh                          | tGGZ5bdZz3n     |
| test_199 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | Brufut Zone                  | QtTGfgIScf9         | Ghana Town                      | u2nLz4uh7Et     |
| test_200 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Gibangarr                       | KAGc2cnLeOP     |
| test_201 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Giboro Koto                     | y2M6kvSvNpO     |
| test_202 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Giboro Kuta                     | nvDcmFW7URv     |
| test_203 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Gidda                           | W3vH9yBUSei     |
| test_204 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Gidda zone                   | Tc8iOk7pzrJ         | Gidda                           | IZva6Z1wMiM     |
| test_205 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Gidda Bajonki                   | Jgi5P8EL2fD     |
| test_206 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Gidda Sukuta                    | acJjfo2MCop     |
| test_207 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Gikes Dandon                    | Du9v7XWo4Ok     |
| test_208 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Ginier                          | sHNmfWw7khG     |
| test_209 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Basse (Fulladu East Circuit) | Q4z6iT2INEg         | Giroba kunda                    | jBxR7xvQswb     |
| test_210 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Gui Jahanka                     | FS1zaWl9sED     |
| test_211 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Fatoto (circuit)             | U3xOxX9xxv4         | Gulumbuyel                      | pmfHGHzj7Yc     |
| test_212 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Gungurr Tukulor                 | FvWQ3Z6QGb8     |
| test_213 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Gungurr Wollof                  | NO2FuPacxfE     |
| test_214 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Gunjur zone                  | zmvR7h1519q         | Gunjur                          | zWvK70GbnCS     |
| test_215 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Gunjur zone                  | zmvR7h1519q         | Gunjur Bato Sateh               | WZsg2ihRoFb     |
| test_216 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Gunjur Jega                     | AB7tQ6fLKKJ     |
| test_217 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Sanyang zone                 | iN4zYiLgz9N         | Gunjur Kunkujang                | HdK1Pla0w5C     |
| test_218 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Gunjur Kuta                     | rCTjz6qJLMt     |
| test_219 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Gunjur zone                  | zmvR7h1519q         | Gunjur Taneneh                  | oTli2vNdZz6     |
| test_220 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Gunjur koto                     | vcXHPKWmCka     |
| test_221 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Hamdalai                        | IGcuxDcqeig     |
| test_222 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Hamdalai                        | gp7yCjfA1pc     |
| test_223 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Fatoto (circuit)             | U3xOxX9xxv4         | Hamdalaye                       | i4Qnj9Zd0n0     |
| test_224 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Gambisara                    | M2siBeFtFW6         | Hella Kunda                     | qRTiBkFozbL     |
| test_225 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | Hydara                          | JevH6Sx7CaH     |
| test_226 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | Jabang Zone                  | iKAbh5EAylG         | Jabang                          | Ey0wCpnvnIN     |
| test_227 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Jagajary                        | ORYAhwm7bSC     |
| test_228 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Jah Kunda                       | cixE4Ny8dQz     |
| test_229 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | Jahanka                         | L2AE5WV9YJX     |
| test_230 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Jahawurr Mandinka               | bdVXPMHSDFs     |
| test_231 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Jahawurr Tukulor                | bMmKE4vTtn8     |
| test_232 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Jaka Madina                     | NwCkVhoUFEO     |
| test_233 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Jaka Madina                     | lxaDoIkvxoy     |
| test_234 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Jakaba                          | Dbpvln6gjyQ     |
| test_235 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Jakoto                          | ueJ6tPgdO3k     |
| test_236 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Jalakoto (Sare Wali)            | Q9bvtkcDyl5     |
| test_237 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Nyambai zone                 | Rya1IVjQgYe         | Jalanbang                       | NVfcRC9Tn0U     |
| test_238 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Darsilameh zone              | RC8nwUH79ib         | Jalanbantang                    | fQbcW8ztcxl     |
| test_239 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | Jallow kunda                    | lFqLy6lmlMM     |
| test_240 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Sanyang zone                 | iN4zYiLgz9N         | Jambanjelly                     | sp8a1Sbet32     |
| test_241 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Farato zone                  | cOVhDahQHpz         | Jamburr                         | wtGb1wGEHPt     |
| test_242 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Jamisa zone                  | X2CLHLYXajG         | Jamisa                          | vH8NCJOP0xj     |
| test_243 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | Jamjam yero                     | o7qFmcMXh9u     |
| test_244 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Jammeh Kunda                    | mF5C5x2msxl     |
| test_245 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Jamwelly                        | W5p0oqbnRf5     |
| test_246 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | Jabang Zone                  | iKAbh5EAylG         | Jamwelly                        | pbwocJxzPay     |
| test_247 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | Jamwelly sarjo                  | uXQ58Ztsa7k     |
| test_248 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Janjanbureh          | lJKroqCqjBk | Janjanbureh (Circuit)        | NXfJYYiHdGG         | Janjanbureh                     | p7HEZH2oQNO     |
| test_249 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Jarrol          | kAxFyJFfYV8 | Foni Jarrol zone             | y81dl12FCm5         | Jarrol                          | OjfsctEIotZ     |
| test_250 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Jawla                           | TQD42wUF0eM     |
| test_251 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Jawo Kunda                      | wlVsFVeHSTx     |
| test_252 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Jenung Kunda                    | jMXtlgl23WE     |
| test_253 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Jimbala Alhagie Sanoho          | wlNDwfHeUjX     |
| test_254 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Jimbala Ali Hincha (Kerr Jah)   | dW2YlfqGf3w     |
| test_255 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Jimbala Felngo                  | PPRMlVrWgI8     |
| test_256 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Jimbala Kerr Chendou            | hrw5FjJSPPZ     |
| test_257 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Jimbala Kerr Cherno             | oeLnWk1xwzB     |
| test_258 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Jimbala Kerr Malick Njie        | p1KJcG5Qg28     |
| test_259 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Jimbala Kerr Musa (Kerr Choire) | P7ZhdjQKVKA     |
| test_260 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Jiramba                         | Sby1yaJBr8B     |
| test_261 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Jisadi                          | eMMmG94AIA9     |
| test_262 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Jomo Kunda                      | oOFI5wfaleY     |
| test_263 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Jonyerr                         | XlhnALkZvpR     |
| test_264 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Julangel                        | yNTR6uClp4X     |
| test_265 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Basse (Fulladu East Circuit) | Q4z6iT2INEg         | Kaba kama                       | GQ66LZbe4GY     |
| test_266 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Kabamba                         | WnDP2fZaa0j     |
| test_267 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Darsilameh zone              | RC8nwUH79ib         | Kabekel                         | bwF7sW41hyB     |
| test_268 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Gunjur zone                  | zmvR7h1519q         | Kachumeh                        | ZpdngJigvi1     |
| test_269 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Kafuta                          | aamV5QlasOz     |
| test_270 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Kafuta Tumbung                  | qrv52eolTfi     |
| test_271 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Gunjur zone                  | zmvR7h1519q         | Kajaabang                       | WgByQySYg4o     |
| test_272 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Jarrol          | kAxFyJFfYV8 | Foni Jarrol zone             | y81dl12FCm5         | Kalagi                          | B7TuXoDt5PQ     |
| test_273 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Kalli Kagera                    | Sd3cbkTYaa1     |
| test_274 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Jarrol          | kAxFyJFfYV8 | Foni Jarrol zone             | y81dl12FCm5         | Kambaleiba                      | PJjeLXNYkoz     |
| test_275 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Kambelly                        | UB2mnf2HbZ0     |
| test_276 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Kambong                         | asTAWn6sdEV     |
| test_277 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Kampant                         | J80q1Xn9fKe     |
| test_278 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Jarrol          | kAxFyJFfYV8 | Foni Jarrol zone             | y81dl12FCm5         | Kampassa                        | AQT9p7TRhRP     |
| test_279 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Kanapeh                         | ILkNrNe5glp     |
| test_280 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Kanfenda                        | i1qHnJIONcd     |
| test_281 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Jarrol          | kAxFyJFfYV8 | Foni Jarrol zone             | y81dl12FCm5         | Kang Mamadu                     | pnW8MvWK8Uz     |
| test_282 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Jarrol          | kAxFyJFfYV8 | Foni Jarrol zone             | y81dl12FCm5         | Kang Sambou                     | eXLwEteKXtn     |
| test_283 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Kanilai                         | uVOG494TGny     |
| test_284 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Fatoto (circuit)             | U3xOxX9xxv4         | Kanjambu                        | CctpZ40IPJC     |
| test_285 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Kankuntu                        | SYHqciS0xto     |
| test_286 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Kanling                         | NLxrftWsLSw     |
| test_287 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Jarrol          | kAxFyJFfYV8 | Foni Jarrol zone             | y81dl12FCm5         | Kanmanka                        | JqeqmCewR0M     |
| test_288 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Kantel Kunda                    | v3FGJEBIlZd     |
| test_289 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Kantimba                        | R8nPKIm5iBt     |
| test_290 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Basse (Fulladu East Circuit) | Q4z6iT2INEg         | Kanubeh                         | eCDCn32vXbP     |
| test_291 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Kappa                           | livAslEV1Hb     |
| test_292 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Karam                           | ZKNYhAedlDE     |
| test_293 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Sare Alpha                   | b2XRfRDmjCw         | Karantaba                       | UniRbcQMebG     |
| test_294 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Karinorr                        | atvcWoDptry     |
| test_295 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Karrol                          | JTvZGUN5TYq     |
| test_296 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Gunjur zone                  | zmvR7h1519q         | Karthong                        | BFTgJ0KnsXi     |
| test_297 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Darsilameh zone              | RC8nwUH79ib         | Kassa Kunda                     | r6ubzxk1Nqe     |
| test_298 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Kassi Kunda                     | kf5boqdaRGc     |
| test_299 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Kaur Janneh Kunda               | AHTzuwZSCy9     |
| test_300 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Kaur Touray Kunda               | Yh3QuvdkMZ2     |
| test_301 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Kaur Wharf Town                 | AJF7jKwEfcv     |
| test_302 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Fatoto (circuit)             | U3xOxX9xxv4         | Kebbeh Kunda                    | i9eLbegPo49     |
| test_303 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Bafuloto zone                | eSqfgzZGsdW         | Kembujeh                        | z2b4JGsCjpy     |
| test_304 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Bafuloto zone                | eSqfgzZGsdW         | Kembujeh Medina                 | fCA30ZmRbuX     |
| test_305 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Keneba                          | GcLhRNAFppR     |
| test_306 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Dingiri                      | OpmIzMikUgb         | Keneba Tumana                   | P7WloFwmjMq     |
| test_307 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Tujereng zone                | YhE8nieVLdk         | Kenending Sabel                 | q1fJYNZZ12m     |
| test_308 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Kerewan                         | VaKjjsl6w9t     |
| test_309 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Kerewan Badala                  | ZZxAxiFjQvU     |
| test_310 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Kerr Alpha Sanna                | iIALRle8BX9     |
| test_311 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Kerr Amat Demba                 | ZTdkFvTQKHZ     |
| test_312 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Kerr Demba Gabou                | TRRYPRDstgp     |
| test_313 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Kerr Jabel                      | PzD4RTTzHjL     |
| test_314 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Kerr Kossa                      | iVv5QeIbNS6     |
| test_315 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Kerr Lien                       | SJdKD0PToju     |
| test_316 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Kerr Maila                      | VjOPZ2IfSHF     |
| test_317 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Kerr Maila Secka                | UVMTOudrFyQ     |
| test_318 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Kerr Sam Boye                   | gvsKf28bzbh     |
| test_319 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Kerr Samba Sira                 | ApKVDzbUiCQ     |
| test_320 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Dampha Kunda                 | WsvcwF16nOD         | Kiskis                          | utW5qaGIm4A     |
| test_321 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Darsilameh zone              | RC8nwUH79ib         | Kitty                           | RMBv0oBUhKY     |
| test_322 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Basse (Fulladu East Circuit) | Q4z6iT2INEg         | Koba Kunda                      | U8bTrnq5mNB     |
| test_323 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Kulari                       | FrELcNpqo3x         | Koboto                          | NoZL17tQaYd     |
| test_324 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Koina                           | Zrm5o9nPmgh     |
| test_325 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Koli Bantang                    | yFUJur3EoSb     |
| test_326 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Koli Kunda                      | Olkr7c04EKX     |
| test_327 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Kulari                       | FrELcNpqo3x         | Kolli Kunda                     | aYrUKceLR6K     |
| test_328 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Fatoto (circuit)             | U3xOxX9xxv4         | Kolli Kunda                     | heevj9oYlv6     |
| test_329 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | Mandinary Zone               | ctTDw9c199R         | Kombo Kerewan                   | Vyr93Pmq24P     |
| test_330 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Koro Jula Kunda                 | glXIULh1YSn     |
| test_331 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Koro Numy Kunda                 | IdximP5mWMz     |
| test_332 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | Korop                           | AJWDPBlIndD     |
| test_333 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Kosemer                         | FVNIArMHi8p     |
| test_334 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | Mandinary Zone               | ctTDw9c199R         | Kubariko                        | r7m9BBE9pW3     |
| test_335 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Bafuloto zone                | eSqfgzZGsdW         | Kubuneh                         | KFeUlVOMFkA     |
| test_336 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Kulari                          | FtVcmEsIZkF     |
| test_337 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Kulari                       | FrELcNpqo3x         | Kulari                          | OS5nfg9yBJx     |
| test_338 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Kulenya Badala                  | NBgQT2efeGD     |
| test_339 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Dingiri                      | OpmIzMikUgb         | Kulinto Mawundeh                | BhAP8Tx8jkw     |
| test_340 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Dingiri                      | OpmIzMikUgb         | Kulinto Wally                   | lNZ1yIY3cb5     |
| test_341 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Dampha Kunda                 | WsvcwF16nOD         | Kulkuley                        | EA8eVymCMoo     |
| test_342 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Kuloro                          | NDUNA0DCGFG     |
| test_343 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Sabi Circuit                 | sxPzOXHGb3F         | Kumbija                         | SzH7WPAIKyE     |
| test_344 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Fatoto (circuit)             | U3xOxX9xxv4         | Kumbul                          | rsR2ezy1Kuf     |
| test_345 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Kulari                       | FrELcNpqo3x         | Kundam Demba                    | vBYpPZfLuoc     |
| test_346 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Kulari                       | FrELcNpqo3x         | Kundam Foday                    | TDeLa8udxiJ     |
| test_347 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Kulari                       | FrELcNpqo3x         | Kundam Mafatty                  | okpWcqx0kO0     |
| test_348 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Kulari                       | FrELcNpqo3x         | Kundam Mballow                  | B8W0W3xTX1x     |
| test_349 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Kunjen Jeng                     | Swskt8nDTmv     |
| test_350 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Dingiri                      | OpmIzMikUgb         | Kunkandi                        | Ch6zbih2Jfw     |
| test_351 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | Mandinary Zone               | ctTDw9c199R         | Kunkujang Jattaya               | rZSsxep18x8     |
| test_352 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Tujereng zone                | YhE8nieVLdk         | Kunkujang Mariama               | vqN7imucCw8     |
| test_353 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Kuraw Arfang                    | f1tJOrdW2gg     |
| test_354 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Kuraw Kemo                      | TyrSntt3FS3     |
| test_355 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Kurinolai                       | XszdsBikXAt     |
| test_356 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Kusi                            | t7dHM9eZXLG     |
| test_357 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Fatoto (circuit)             | U3xOxX9xxv4         | Kusun                           | nK9Q9DLLzBE     |
| test_358 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Kuwonku Ba                      | XX1YsCIF6VX     |
| test_359 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Kuwonkunding                    | mG03S7VaW2u     |
| test_360 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | Jabang Zone                  | iKAbh5EAylG         | Labakoreh                       | qUTwRie6jt9     |
| test_361 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Laibeh Kunda                    | XidiOl5MRDq     |
| test_362 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Fatoto (circuit)             | U3xOxX9xxv4         | Lamoi                           | kHNRdMB3BzU     |
| test_363 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | Jabang Zone                  | iKAbh5EAylG         | Latriya                         | msdVhys9i7m     |
| test_364 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Sifoe zone                   | a2TR06RstRv         | Lemuna Messeng                  | HdcUu6q3LkU     |
| test_365 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | Librass                         | EAaC23OPNPS     |
| test_366 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Limbanbulu Bambo                | fKLSfX7JFJA     |
| test_367 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Limbanbulu Yamadu               | g8v2kbP1cKT     |
| test_368 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Luluchore                       | LhP9Iu7IHYl     |
| test_369 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | Mabali koto                     | NTB84U97dhz     |
| test_370 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | Mabali kuta                     | oakBbeQRitN     |
| test_371 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Tujereng zone                | YhE8nieVLdk         | Madiana                         | SfWmROCoHNm     |
| test_372 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Madina Balla                    | X2wO2RQkIkP     |
| test_373 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Madina Karim                    | d1C0Q9f8SGB     |
| test_374 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Madina Koto                     | oai7kOlwuJt     |
| test_375 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Madina Mbaye                    | n8jH2fK4avQ     |
| test_376 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Madina Njain                    | GkRJr0oIJF8     |
| test_377 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Madina Nyantanba                | eY1Q6nhPKvA     |
| test_378 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Madina Saho                     | W4kL7b5mXI5     |
| test_379 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Gunjur zone                  | zmvR7h1519q         | Madina Salaam                   | E5DLXYXQrBZ     |
| test_380 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Dingiri                      | OpmIzMikUgb         | Madina Samako                   | K1edazJe9Ca     |
| test_381 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Madina Talo Koto                | caLekKdQqUK     |
| test_382 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Dampha Kunda                 | WsvcwF16nOD         | Madina Yoro                     | oDVDWPzDwdD     |
| test_383 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | Madina challen                  | I6MgYxyiLDx     |
| test_384 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Madinayel                       | Wr3htgGxhBv     |
| test_385 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Maka Masireh                    | rtpZZ5cZyi4     |
| test_386 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | Mandinary Zone               | ctTDw9c199R         | Makumbaya                       | YqxOQkCdaC0     |
| test_387 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Mamadi Ceesay Kunda             | N7O43W5EJ2h     |
| test_388 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Mamadina Yoro/Banni Bakala      | CfBrydK5ndc     |
| test_389 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Mamasutu                        | UXgnYBb3N8Z     |
| test_390 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Mamkamang Kunda                 | r0nlzCNHmjk     |
| test_391 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Sabi Circuit                 | sxPzOXHGb3F         | Mampatayel                      | h6HbKt6FADf     |
| test_392 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Sanyang zone                 | iN4zYiLgz9N         | Mamuda                          | J4f9mdhiC30     |
| test_393 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Mandina                         | hNDMI2Vh6Oo     |
| test_394 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Mandina Ba                      | eCbgGl5czYN     |
| test_395 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | Mandinary Zone               | ctTDw9c199R         | Mandinary                       | YF04MTplXdi     |
| test_396 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Darsilameh zone              | RC8nwUH79ib         | Manduar                         | rAyMXtwdzzZ     |
| test_397 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Manjakharr                      | fbzkrRv0IRV     |
| test_398 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Mankamang Kunda                 | eWUmFIhuGPt     |
| test_399 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Basse (Fulladu East Circuit) | Q4z6iT2INEg         | Manneh Kunda                    | UwB98WBz4Ua     |
| test_400 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | Manneh kunda                    | aPXbTqQpzOD     |
| test_401 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Mano Koto Foday                 | YJYb80HKhiX     |
| test_402 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Mano Koto Keita                 | LdK1JYqeyFP     |
| test_403 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Basse (Fulladu East Circuit) | Q4z6iT2INEg         | Mansajang Kunda                 | xAqb364awH0     |
| test_404 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Darsilameh zone              | RC8nwUH79ib         | Marakissa                       | QHsbLBqoG9a     |
| test_405 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | Jabang Zone                  | iKAbh5EAylG         | Mariama Kunda                   | xVG1HOl8lVK     |
| test_406 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Marsay                          | eIrjimdx9tj     |
| test_407 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Mbafafu                         | ouw5p1WvRZR     |
| test_408 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Mbaien Burama Bah               | ME6bimJ8YY5     |
| test_409 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Mballow Kunda                   | ySP6yq8fAgI     |
| test_410 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Mbaye Kunda                     | xpcHw2OKgsm     |
| test_411 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Medina Saho                     | Xj9palOCwJY     |
| test_412 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Darsilameh zone              | RC8nwUH79ib         | Medina Salanding                | wrFvVDWDUAE     |
| test_413 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Misera                          | MAOoX2JPHIR     |
| test_414 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Fatoto (circuit)             | U3xOxX9xxv4         | Miseraba Mariama                | TDEISxLRNOt     |
| test_415 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | Misira                          | VIq6LWEfgBN     |
| test_416 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Misira Amadou Badjan            | RwbpE4pUllU     |
| test_417 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Missira Mbye Sowe               | optoKRXnXJU     |
| test_418 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Missira Pateh Ganno             | RCzTHxsHQXY     |
| test_419 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Missiranding                    | RKlf79Hmsf0     |
| test_420 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Modikaya                        | NCYfSx09JJt     |
| test_421 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Modu Jawo Kunda                 | wv3ofqGL2A4     |
| test_422 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Monom                           | Vl7zqRQBS0X     |
| test_423 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Murreh Kunda                    | yNa1dmkd9PP     |
| test_424 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Musa Kunda                      | a0sBXx1vhLZ     |
| test_425 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Basse (Fulladu East Circuit) | Q4z6iT2INEg         | Nafugan Jawando                 | AWNhJVzavZv     |
| test_426 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Basse (Fulladu East Circuit) | Q4z6iT2INEg         | Nafugan Jomel                   | eiSur0UlKwC     |
| test_427 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Basse (Fulladu East Circuit) | Q4z6iT2INEg         | Nafugan Pateh                   | iw4n1NJCOVz     |
| test_428 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Darsilameh zone              | RC8nwUH79ib         | Naneto Siwon                    | nwBdxHdmjSH     |
| test_429 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Nawdeh                          | IFN48WIp9WL     |
| test_430 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Nawell                          | awImn3eZfiI     |
| test_431 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | Ndakaru                         | Gl891lp9xAa     |
| test_432 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Ndakaru                         | MhWwwy5Xi2O     |
| test_433 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Sare Alpha                   | b2XRfRDmjCw         | Ndimbu                          | jH7GS9sJz01     |
| test_434 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | Ndorna                          | AWRgWgJ5tY1     |
| test_435 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Nema                            | aS4tdjvineQ     |
| test_436 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Sanyang zone                 | iN4zYiLgz9N         | Nema Fula Kunda                 | XYo26KyBltl     |
| test_437 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | Nema Kunku Zone              | GFTEa5ym7AF         | Nema Kunku                      | obuF7hNha6s     |
| test_438 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | Nema Kunku Zone              | GFTEa5ym7AF         | Nema Naseer                     | fLP4LU9Q4We     |
| test_439 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | New Yundum Zone              | mtMgCX5U1gN         | New Yundum                      | TGkxm2nTX4f     |
| test_440 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Ngike                           | q3OBgujIoWO     |
| test_441 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Nigie                           | o8UqahMlZ6f     |
| test_442 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Jarrol          | kAxFyJFfYV8 | Foni Jarrol zone             | y81dl12FCm5         | Nioro Jarrol                    | z56O0qYkJjE     |
| test_443 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Njaibeh                         | D4VeZQmNOG8     |
| test_444 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Njallal toro                    | PSSomtmGVlT     |
| test_445 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Sare Alpha                   | b2XRfRDmjCw         | Njayel                          | aBIRmMGrGMl     |
| test_446 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | Njoben                          | Wj7FPW966kN     |
| test_447 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Njoben Samba Narr               | l7dgutMy73u     |
| test_448 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Jarrol          | kAxFyJFfYV8 | Foni Jarrol zone             | y81dl12FCm5         | Njonkel                         | r3uSUw7q9m2     |
| test_449 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Jarrol          | kAxFyJFfYV8 | Foni Jarrol zone             | y81dl12FCm5         | Njorem Bondi Kunda              | NjhuYV8NruB     |
| test_450 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Jarrol          | kAxFyJFfYV8 | Foni Jarrol zone             | y81dl12FCm5         | Njorem Drammeh Kunda            | hc138AdXAQS     |
| test_451 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Jarrol          | kAxFyJFfYV8 | Foni Jarrol zone             | y81dl12FCm5         | Njorem Sanneh Kunda             | D9jxhd9DcoZ     |
| test_452 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Njum Bakary                     | ZQ3HjGR0M14     |
| test_453 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Njum Bakary                     | gVuRRMR2The     |
| test_454 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Gambisara                    | M2siBeFtFW6         | Numuyel                         | pZ056m5SlLo     |
| test_455 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Nyadinding                      | ugDR22ZgwxL     |
| test_456 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Nyamanarr                       | fcL2whiwoiv     |
| test_457 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Nyambai zone                 | Rya1IVjQgYe         | Nyambai                         | NKjMbTqSYhd     |
| test_458 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | Nyameng kunda                   | YRLa89UUUID     |
| test_459 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Nyankui                         | NAV9vZZtt3Q     |
| test_460 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Dingiri                      | OpmIzMikUgb         | Nyankuma                        | ShlIP2xKluo     |
| test_461 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Gunjur zone                  | zmvR7h1519q         | Nyantang Faraba                 | mOdiyI7Xk6c     |
| test_462 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Sifoe zone                   | a2TR06RstRv         | Nyoffeleh                       | zxC2KTOyp1s     |
| test_463 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | New Yundum Zone              | mtMgCX5U1gN         | Old Yundum                      | YEZdZemIiib     |
| test_464 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Omorto                          | Vn2nM2l5Zko     |
| test_465 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Oukass                          | HA1N8OjDpxA     |
| test_466 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Sanyang zone                 | iN4zYiLgz9N         | Pacholling Malang               | Sjc7oZ0nSTV     |
| test_467 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Passamas Fula                   | FoamCeD4ryC     |
| test_468 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Passamas Mandinka               | maCWgbGogKe     |
| test_469 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Passonto Kadry                  | jNV3P1mTXNb     |
| test_470 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Darsilameh zone              | RC8nwUH79ib         | Penyem                          | n5oXcsXxFxS     |
| test_471 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Kulari                       | FrELcNpqo3x         | Perai                           | OdhScs26aW5     |
| test_472 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Pilinki Korta                   | Tzw8Zhztwof     |
| test_473 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Pilinki Tumani                  | WoVEGFe16qt     |
| test_474 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Pirang                          | ae35mb4elhs     |
| test_475 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Raneru Fula                     | ogNuf8aUBSD     |
| test_476 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Raneru wollof                   | R9qD5usWCAC     |
| test_477 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Kulari                       | FrELcNpqo3x         | Refugee Camp (Kerr Alhasan)     | OPgtCRjEqQN     |
| test_478 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Sanyang zone                 | iN4zYiLgz9N         | Rumba                           | lRh4grk6NDC     |
| test_479 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Sabari                          | LOBcuaOZ7Cr     |
| test_480 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Sabi Circuit                 | sxPzOXHGb3F         | Sabi                            | Y0WPPGfUsUK     |
| test_481 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Fatoto (circuit)             | U3xOxX9xxv4         | Sabi Kalilu                     | hb1c9YcROXk     |
| test_482 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Basse (Fulladu East Circuit) | Q4z6iT2INEg         | Sabu Sireh                      | LpHFVHAoW37     |
| test_483 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Sahadatou                       | yDFu2hBPScK     |
| test_484 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Sakoli Kunda                    | zimeiihdIkb     |
| test_485 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Sifoe zone                   | a2TR06RstRv         | Sala/TAF City                   | C1OcrEEwEDC     |
| test_486 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Sare Alpha                   | b2XRfRDmjCw         | Salikene                        | uI4VRuUNT7S     |
| test_487 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Gunjur zone                  | zmvR7h1519q         | Samabung/Sinchu Wuri            | uSs2gapV7Dt     |
| test_488 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Samba Kabudeh                   | ST6fzC4LPNC     |
| test_489 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Kulari                       | FrELcNpqo3x         | Samba Kunda                     | qgSAqc4iPhM     |
| test_490 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Sabi Circuit                 | sxPzOXHGb3F         | Samba Lolo                      | dufU0HOENWW     |
| test_491 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Basse (Fulladu East Circuit) | Q4z6iT2INEg         | Samba Tacko                     | CYOvuDe1H7q     |
| test_492 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Sambang Wollof                  | m5r6Nnc3ILK     |
| test_493 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Gunjur zone                  | zmvR7h1519q         | Sambuya                         | qDabL2rVD9V     |
| test_494 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Gunjur zone                  | zmvR7h1519q         | Sambuya amisong                 | qxRDR2iH2Wj     |
| test_495 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Sami                            | KmVulo6OeDj     |
| test_496 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Fatoto (circuit)             | U3xOxX9xxv4         | Sami Koto                       | D9GxNUuLteB     |
| test_497 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Fatoto (circuit)             | U3xOxX9xxv4         | Sami Kuta                       | nuGdwo0M3Ds     |
| test_498 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Sami madina                     | Xi9HhEvk6sw     |
| test_499 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Sami pachonki                   | WiIZ4uUBQWl     |
| test_500 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Sancha Lowen                    | w6Jm8SgZ4mU     |
| test_501 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Gunjur zone                  | zmvR7h1519q         | Sandally                        | DufpMselMOT     |
| test_502 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Sandi Kunda(Sare Sandi)         | Wc76o2fV9oc     |
| test_503 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Sandy Kunda                     | eMofajJFXGH     |
| test_504 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Sangajorr                       | nS0zbHB5p5J     |
| test_505 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Sankabarry                      | T3sak5c4SD2     |
| test_506 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Sankabary                       | EOugp1uTOBP     |
| test_507 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Sankurang                       | QM4yg7wjvKP     |
| test_508 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Santanba                        | OdgN5PMtP8P     |
| test_509 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Dingiri                      | OpmIzMikUgb         | Sanunding                       | QsVCAgo2LkU     |
| test_510 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Sanyang zone                 | iN4zYiLgz9N         | Sanyang                         | ru8GVxLa1tR     |
| test_511 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Sanyanga                        | Uy2yiIA8OKK     |
| test_512 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Sara Bayo                       | kuJFepIeQkg     |
| test_513 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | Sare Ali                        | UILXJe0gOEb     |
| test_514 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Sare Ali                        | xFEC84c6mcw     |
| test_515 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Sare Ali Jawo                   | aiZ96jfDIAO     |
| test_516 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Sare Alpha                   | b2XRfRDmjCw         | Sare Alpha                      | FA5pwtk1qGR     |
| test_517 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Sare Bakary                     | KcW07L6LxyT     |
| test_518 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Sare Batch /Hamdalai            | eIoclWruLzE     |
| test_519 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Sanyang zone                 | iN4zYiLgz9N         | Sare Biji (Biji-Ya)             | jva5YFiUyFM     |
| test_520 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Sare Birom                      | LXt0RMBbZaU     |
| test_521 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Sare Biru                       | dbPeHzaO9m5     |
| test_522 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Gambisara                    | M2siBeFtFW6         | Sare Boche                      | K5lPQIBKnQm     |
| test_523 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Sare Bojo Baga                  | Bqj5hhsWwwE     |
| test_524 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Sare Bojo Gamana                | EE8iko2lCQH     |
| test_525 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Sare Bojo Sambou                | b7wF7HfVsms     |
| test_526 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Gambisara                    | M2siBeFtFW6         | Sare Bondo                      | xHE1pfCKLn5     |
| test_527 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Basse (Fulladu East Circuit) | Q4z6iT2INEg         | Sare Bonna                      | pfDMu5UUnaG     |
| test_528 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Sare Bouche                     | NgM8ZsEUdKu     |
| test_529 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Sare Cherno                     | O05fo1pv2IZ     |
| test_530 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | Sare Chewto                     | JlZx9eJIzgp     |
| test_531 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Sare Dadi                       | q2rZ0rADzpV     |
| test_532 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Sare Demba                      | pRqVbEqpNS1     |
| test_533 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Sare Demba Dabo                 | COHxIAMRMOb     |
| test_534 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Sare Demba Dado                 | lXYUtrgwziU     |
| test_535 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Sare Demba Eyo                  | luyOjyxzx1p     |
| test_536 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Sare Demba Toro                 | niDHCLqzwIf     |
| test_537 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Sare Donfo                      | ALzlv9kZiRK     |
| test_538 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Sabi Circuit                 | sxPzOXHGb3F         | Sare Dullo                      | HyUHtqCpH8o     |
| test_539 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Sare Fodikay                    | OxWVyO27qnj     |
| test_540 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Sare Galo Mballow               | e8YqpX0qlgX     |
| test_541 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Sare Galo Mballow               | tTdi61oLtzQ     |
| test_542 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Sare Ganyado                    | ReVbGoTwceP     |
| test_543 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Sare Ganye                      | zKPW9K4Ks5j     |
| test_544 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Kulari                       | FrELcNpqo3x         | Sare Garaba                     | v3ToLPr6mC9     |
| test_545 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Sare Gayo                       | nnN1BeZ2O5B     |
| test_546 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Dingiri                      | OpmIzMikUgb         | Sare Gella                      | tgj2m1zMGpe     |
| test_547 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Sare Gidda                      | WpSfI58UUNG     |
| test_548 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Sare Giddeh                     | p6rFOsMNCES     |
| test_549 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Sare Gubu                       | feI2jI0GHdB     |
| test_550 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Sare Gubu Basiru                | FpxQRTPQPt6     |
| test_551 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Sare Gubu Muntaga               | LNiSwC1AguG     |
| test_552 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Sare Hamadi                     | m8xf8w4tVl5     |
| test_553 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Fatoto (circuit)             | U3xOxX9xxv4         | Sare Handeh                     | EAltO7mN0BI     |
| test_554 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Sare Jajeh                      | KDNMyiBv00d     |
| test_555 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Sare Jallow                     | m3Ij2IxYQsw     |
| test_556 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Sare Jamu Mballow               | holbPD5ltux     |
| test_557 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Gambisara                    | M2siBeFtFW6         | Sare Jatta                      | IYQuJj8xEI8     |
| test_558 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Sare Jawbeh                     | RpU57bbMuk3     |
| test_559 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Gambisara                    | M2siBeFtFW6         | Sare Jawbeh                     | lM5udT0PZVt     |
| test_560 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Sare Kali                       | xTyv1h0lrDH     |
| test_561 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Sare Keita                      | sAMqnVxGc86     |
| test_562 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Sare Kokeh                      | xrudH3k6tQs     |
| test_563 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Sare Kolli/Jamjam Kolly         | ODlPoi3lef7     |
| test_564 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Sare Kungel (Sare Manjang)      | qHUzRho54uq     |
| test_565 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Sare Leigh                      | AUErxiKuLDx     |
| test_566 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Sare Mala                       | MGBYonFM4y3     |
| test_567 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Sare Malla                      | RgDk0UR697d     |
| test_568 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Dingiri                      | OpmIzMikUgb         | Sare Mamadi                     | VPkOSNbpdNu     |
| test_569 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Gambisara                    | M2siBeFtFW6         | Sare Mamudou                    | Z2HbD8wNjrC     |
| test_570 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Sare Manasally                  | uR4XJ3Es6Aa     |
| test_571 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Sare Mansally                   | Mc3zEfIiCU9     |
| test_572 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Sare Mansally                   | oA6XDiQf9Qf     |
| test_573 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Gambisara                    | M2siBeFtFW6         | Sare Mansally Jewru             | n0NIk8pEQ1S     |
| test_574 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Sare Mansong                    | Q6fBg92VhHU     |
| test_575 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Gambisara                    | M2siBeFtFW6         | Sare Mbye                       | CEPIqxTNUic     |
| test_576 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Sabi Circuit                 | sxPzOXHGb3F         | Sare Musa                       | K5NoYDEkvms     |
| test_577 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Sare Musa                       | voVRbt8penW     |
| test_578 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Sare N’Gai                      | Q0CtmiDSau4     |
| test_579 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Sare Ngaba                      | THdGr2O5zWK     |
| test_580 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Sare Ngai                       | TD6sod0mUC3     |
| test_581 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | Sare Ngallen                    | NaIzWozhjA2     |
| test_582 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Sare Ngatam                     | Z6GObyuQi7o     |
| test_583 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Sare Ngengudeh                  | iZ8xqmHyseO     |
| test_584 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Sare Njobo                      | tjb6bZAiihC     |
| test_585 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Gambisara                    | M2siBeFtFW6         | Sare Njuburu                    | ksDM8hJQmjv     |
| test_586 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Sare Pateh                      | QXqfhTA9z7l     |
| test_587 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Sare Pateh                      | m7JUq5k0CBs     |
| test_588 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Sare Pateh (Sankabary)          | OboMeGVxjgJ     |
| test_589 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Sabi Circuit                 | sxPzOXHGb3F         | Sare Pirasu                     | jYuBIAaOfeJ     |
| test_590 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Gambisara                    | M2siBeFtFW6         | Sare Sacho                      | ofZhtqQCDhO     |
| test_591 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Sare Sada                       | QoWfe2wQuFH     |
| test_592 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Sare Samba Baidy                | rnkDN3eFSOx     |
| test_593 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Sare Samba Giddeh               | l8chzFJ5R3I     |
| test_594 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Sare Samba Gideh                | EHMo8mXxb1Q     |
| test_595 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Sare Samba Kekuta               | wdyxmYEvuqn     |
| test_596 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Gambisara                    | M2siBeFtFW6         | Sare Samba Tacko                | rw2GU6QExI3     |
| test_597 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Sare Sambel                     | otxrkT8Eyhm     |
| test_598 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Sare Samburu                    | f71NZgwyzug     |
| test_599 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Gambisara                    | M2siBeFtFW6         | Sare Sammabou                   | VaRQaZ1kCIm     |
| test_600 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Sare Sankulay                   | r6OUiRslvFC     |
| test_601 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Gambisara                    | M2siBeFtFW6         | Sare Sankuley                   | dxLa7dRBWBz     |
| test_602 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Sare Sibo                       | UrLrbEiWk3J     |
| test_603 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Sare Silere                     | PavPF3SGo0T     |
| test_604 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Sare Sillery                    | IHd1TvMn6OU     |
| test_605 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Gambisara                    | M2siBeFtFW6         | Sare Sori                       | GAA1uM0dTEL     |
| test_606 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Sare Talata                     | IdcgE6zB9x5     |
| test_607 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Dingiri                      | OpmIzMikUgb         | Sare Tallo                      | CpXbux4M7CX     |
| test_608 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Sare Teneng                     | LVA6BpplOIi     |
| test_609 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Sare Timbo                      | TlMMfaZr8mj     |
| test_610 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Sare Turi                       | bKIP8HpZFjJ     |
| test_611 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Sare Wallom                     | ohOvXXzBmuu     |
| test_612 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Gambisara                    | M2siBeFtFW6         | Sare Wassa                      | uXE9BhiclEm     |
| test_613 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Sare Woka                       | gASguXA8GfR     |
| test_614 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Sare Wossi/Barry                | nNq2bxYS8pp     |
| test_615 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Sare Wuro                       | mLTttTQUnRh     |
| test_616 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Sabi Circuit                 | sxPzOXHGb3F         | Sare Yero Checkeh               | qPlm88J8xH3     |
| test_617 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Sare Yero Penda                 | jo3nQomb806     |
| test_618 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Dingiri                      | OpmIzMikUgb         | Sare Yeroba(Jarinjofa)          | pyXmPC42k1I     |
| test_619 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Sare Yeroyel                    | JWAkcAckpCm     |
| test_620 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Sare Yerroi                     | EcsBln7Zk2l     |
| test_621 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Saringa                         | q4o9BD0TdvY     |
| test_622 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Sare Alpha                   | b2XRfRDmjCw         | Sarja Kunda                     | gahq8tBCg6u     |
| test_623 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Jarrol          | kAxFyJFfYV8 | Foni Jarrol zone             | y81dl12FCm5         | Satan Koto (Chewel)             | nKQpdpqxu8k     |
| test_624 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | Sendebu                         | QH0cOfWguDG     |
| test_625 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Dingiri                      | OpmIzMikUgb         | Sendebu                         | gUiBozFaRUS     |
| test_626 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Bafuloto zone                | eSqfgzZGsdW         | Serekundading                   | nDcwGViMVLa     |
| test_627 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Sey Kunda                       | ioQrH67KbZu     |
| test_628 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Sifoe zone                   | a2TR06RstRv         | Siffoe                          | Eq6fojNCGs7     |
| test_629 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Sii Fulla Keitel                | aHiEC5Kcp8Z     |
| test_630 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Sii Fulla Suna                  | IbUJbGdLMJY     |
| test_631 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Simbara Khai                    | UzkdxXFCcPq     |
| test_632 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Simbara Manjai                  | gBT1XozbRxw     |
| test_633 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Simbara N’Gorr                  | AwQks2rr8rx     |
| test_634 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Simbara Tukulorr                | fVZJsmNuguP     |
| test_635 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Sare Alpha                   | b2XRfRDmjCw         | Simoto Touba                    | IVr2b4eZqLG     |
| test_636 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Sanyang zone                 | iN4zYiLgz9N         | Sinchang                        | mrTEZ9riaPN     |
| test_637 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Sinchang Banding                | zPyukZaFUjD     |
| test_638 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | Sinchang Galajo                 | oUO5p1yYmDg     |
| test_639 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Fatoto (circuit)             | U3xOxX9xxv4         | Sinchang Geloyel                | sFEthrMeUSz     |
| test_640 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Fatoto (circuit)             | U3xOxX9xxv4         | Sinchang Gidereh                | E8qZE8q4iJM     |
| test_641 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Gambisara                    | M2siBeFtFW6         | Sinchang Janabo                 | BXpZdGw78Sn     |
| test_642 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Sinchang Nyebeh                 | pIFLksyYsxo     |
| test_643 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Sinchang Samba Jawo             | NUGLcYAdSYH     |
| test_644 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Sinchang yero                   | jS5x3ZtZlqH     |
| test_645 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | Sinchu Alhagie Zone          | eH1vxnaZaZi         | Sinchu Alhagie                  | oB5Q5DGmTyF     |
| test_646 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | Sinchu Zone                  | ig3sxWqdREZ         | Sinchu Balia                    | VfcbZADbixm     |
| test_647 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Sinchu Demba                    | IFHQK51ussH     |
| test_648 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Basse (Fulladu East Circuit) | Q4z6iT2INEg         | Sinchu Magai                    | CVdZ19pXxBZ     |
| test_649 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Sinchu Musa                     | U5y1tyJxhsY     |
| test_650 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Sinchu Njaibeh                  | YNZYLEJ2TKp     |
| test_651 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Sinchu Njugary(Madina Njugang)  | dX6L91wWFGK     |
| test_652 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | Sinchu Zone                  | ig3sxWqdREZ         | Sinchu Sorrie                   | ClzxNjWnaBH     |
| test_653 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Sinchu Sura                     | O7hF8HzFLF1     |
| test_654 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Sinchu Welingara/Sinchu Alagie  | dRccc7cRqob     |
| test_655 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | Sinchu samba jawo               | YHp1CPfVnpH     |
| test_656 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | Sinchu samba mbery              | cJjvy8Zu5wF     |
| test_657 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Jarrol          | kAxFyJFfYV8 | Foni Jarrol zone             | y81dl12FCm5         | Sintet Bako                     | gNk3rw7ibTl     |
| test_658 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Jarrol          | kAxFyJFfYV8 | Foni Jarrol zone             | y81dl12FCm5         | Sintet Busonghai                | TLVCRmWRP4Y     |
| test_659 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Jarrol          | kAxFyJFfYV8 | Foni Jarrol zone             | y81dl12FCm5         | Sintet Fula kunda               | S5o39h7DwAY     |
| test_660 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Jarrol          | kAxFyJFfYV8 | Foni Jarrol zone             | y81dl12FCm5         | Sintet Tamba kunda              | o6hMGDKBmFV     |
| test_661 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Jarrol          | kAxFyJFfYV8 | Foni Jarrol zone             | y81dl12FCm5         | Sintet kabombu                  | ix2JsjDJwXB     |
| test_662 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Sohm                            | HM8hzAftrRY     |
| test_663 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | Sololo                          | w61kV03jwbR     |
| test_664 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Song Kunda                      | ISbNWYieHY8     |
| test_665 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Sotokoi                         | GkKnGOWZdEo     |
| test_666 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Sotuma                          | jnW9JB4NUiA     |
| test_667 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Gambisara                    | M2siBeFtFW6         | Sotuma Sainey Kandeh            | Kii77z4pMzm     |
| test_668 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Gambisara                    | M2siBeFtFW6         | Sotuma Samba Koi                | y8gW4lwcOYs     |
| test_669 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Gambisara                    | M2siBeFtFW6         | Sotuma Sere                     | DFleCeZ2AXf     |
| test_670 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Fatoto (circuit)             | U3xOxX9xxv4         | Suduwol                         | juFZgCgWPp8     |
| test_671 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | Sukuta Zone                  | gyJaPIwAG6o         | Sukuta (Central)                | dYgf888gQtU     |
| test_672 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | Sukuta Zone                  | gyJaPIwAG6o         | Sukuta (Nema)                   | odGHsPF22rC     |
| test_673 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | Sukuta Zone                  | gyJaPIwAG6o         | Sukuta (Sanchaba)               | HhpQnSVdoVO     |
| test_674 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Suma Kunda                      | PvADtrdPn9T     |
| test_675 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Suma Kunda                      | UHXj8xrwMTR     |
| test_676 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Suma Kunda Koto                 | o3Mgqo4N6ek     |
| test_677 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Sutu Konding                    | Q61aN6B4k5B     |
| test_678 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Sutukoba                        | Sz6GcRSslC6     |
| test_679 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Tabajang                        | QfF3EKt8v3A     |
| test_680 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Sabi Circuit                 | sxPzOXHGb3F         | Tabajenkeh (Sare Sambel)        | GChQgzZqibJ     |
| test_681 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Tabanani                        | dJ2mrou6Cg9     |
| test_682 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Tabanding                       | PmZp1hSamPI     |
| test_683 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Tabaworo Amat Ann               | BG0YYpr7cDE     |
| test_684 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Lower Saloum         | M9sqWmBWlcS | Lower Saloum (Circuit)       | QWJJ9f3VZLu         | Tabaworo Nyukulum               | qBfwOIkkYhK     |
| test_685 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Tabayel                         | gmJoXCsEvaM     |
| test_686 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Tabuchindeh                     | jBCJqgTWg3Y     |
| test_687 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Sanyang zone                 | iN4zYiLgz9N         | Taibatou Kuta                   | PobeqnnvQgN     |
| test_688 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Taibatu                         | UXtAXy8aWm3     |
| test_689 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Taifa                           | SNEmjsghq7D     |
| test_690 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Sare Alpha                   | b2XRfRDmjCw         | Taimantu                        | fdX6kdzIAAs     |
| test_691 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Gambisara                    | M2siBeFtFW6         | Talto                           | ALuFpssejWI     |
| test_692 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Dampha Kunda                 | WsvcwF16nOD         | Tamba Sangsang                  | wgP2M049Dtt     |
| test_693 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | Tamba kunda                     | X368fwttjRH     |
| test_694 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | Tandi                           | EJZJKtatycS     |
| test_695 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Tandi Bara                      | tugP6P3i7IR     |
| test_696 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Tandi mandinka                  | zsecAvD9ubo     |
| test_697 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Tandi wollof                    | UMh8X8ho568     |
| test_698 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Tanene                          | gQdk2MzqG7w     |
| test_699 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Tanjeh zone                  | rv8g5Lsc9SZ         | Tanjeh                          | miKYGNFURwH     |
| test_700 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | Tankon kunda                    | YtSUddZQkrO     |
| test_701 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Tasili                          | zZj3LdGGWTw     |
| test_702 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | New Yundum Zone              | mtMgCX5U1gN         | Tawto                           | UkacrgP5WDa     |
| test_703 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Fatoto (circuit)             | U3xOxX9xxv4         | Temanto                         | RuYLxeuLecY     |
| test_704 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Temanto                         | rPnfiR6LjE2     |
| test_705 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Dingiri                      | OpmIzMikUgb         | Tenkoli                         | S2kUpDuwliW     |
| test_706 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Tenkolly                        | cI1jC46SVvG     |
| test_707 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Timbinto                        | b1jbUqB8UL0     |
| test_708 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Timpa                           | VWyWZi5d0Q8     |
| test_709 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Kansala         | evqNY2pVQ63 | Foni Kansala zone            | kPSmFiSrziH         | Tintiba                         | yz1UpSsQ0QK     |
| test_710 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Dampha Kunda                 | WsvcwF16nOD         | Tintinjo                        | nSbXATq1GTC     |
| test_711 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Tujereng zone                | YhE8nieVLdk         | Tintinto                        | WFUAtfJJ6Cg     |
| test_712 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Toniataba                       | AvHXRRWGVyD     |
| test_713 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Touba Burey                     | RkGv4WbnEmc     |
| test_714 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Touba Mourie                    | kjJ2OGCGvXn     |
| test_715 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Basse (Fulladu East Circuit) | Q4z6iT2INEg         | Touba Tafsir                    | exr94m4geLc     |
| test_716 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Touba Woppa                     | rWXrGghlh3y     |
| test_717 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Touba Wuli                      | p0l07hYuxOj     |
| test_718 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Kantora              | BgLHlhL3UB3 | Koina (circuit)              | eBvz5W85g61         | Toubanding                      | N21ldSCO9yo     |
| test_719 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Tuba Fula (Tuba Dabbo)          | b4VBKTiv55A     |
| test_720 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Tuba Kuta                       | CHHPkg2jRfo     |
| test_721 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Tuba Sandu                      | ovbaeE615WC     |
| test_722 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | Tuba mbogen                     | dKYDGBxHIvY     |
| test_723 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | Tubanding                       | EBZoYptCdmV     |
| test_724 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Tujereng zone                | YhE8nieVLdk         | Tujereng                        | ZQUlLwbn80j     |
| test_725 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo South          | iayOrTuwOKs | Tujereng zone                | YhE8nieVLdk         | Tujereng Estate                 | RSp9tL3fT9Y     |
| test_726 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo East           | hCqecbkPzwU | Kombo East zone              | ecy2weaSclQ         | Tumani Tenda                    | di9RkObZekG     |
| test_727 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Tumana               | xGYsUdiJb4L | Sare Alpha                   | b2XRfRDmjCw         | Walliba Kunda                   | KKXrPigZqpY     |
| test_728 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Bakadagy                     | fTlLWp1RVzm         | Wassadou                        | cuNNuKj6ZSW     |
| test_729 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Jimara               | Ane8AWzbbZQ | Sandy Kunda                  | sjLys2UJzfg         | Wassadou Jimara                 | OhVAL9PkX2T     |
| test_730 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Foni Jarrol          | kAxFyJFfYV8 | Foni Jarrol zone             | y81dl12FCm5         | Wassadu                         | Teg2DcubEd1     |
| test_731 | Gambia        | jvQPTsCLwPh | Western Region 2     | D18zNdCbRfO | Kombo Central        | I0v1SmdpPzT | Wellingara zone              | pcdArzRLIMO         | Wellingara                      | sWL0ZGVMIMd     |
| test_732 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Wellingara Demba                | FHZBaM7lCxv     |
| test_733 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Wellingara Ello                 | p1BOxI0a11Q     |
| test_734 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Basse (Fulladu East) | Ug7sj97icMt | Basse (Fulladu East Circuit) | Q4z6iT2INEg         | Wellingara Kubeh                | jCQLPmPpv9d     |
| test_735 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Sandu                | iZQOFwckdXL | Sandu (Circuit)              | Ys9e93fU1kc         | Wellingara Susso                | t64SlIXYPC4     |
| test_736 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli East           | j8k3EVlNWYv | Wulli East (Circuit)         | eDCMju6Q1HB         | Wellingara Yarreh               | aWWqe7atK7L     |
| test_737 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Wellingara Yorroba (Kerr Layen) | eJSB178b2ry     |
| test_738 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | Brufut Zone                  | QtTGfgIScf9         | Wullinkama                      | lC6ccgvG7PT     |
| test_739 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | New Yundum Zone              | mtMgCX5U1gN         | Yarambamba                      | Pl1Eu42lTbc     |
| test_740 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | Yona                            | jOfixgQpFVv     |
| test_741 | Gambia        | jvQPTsCLwPh | Upper River Region   | SHRxQEqOPJa | Wulli West           | JIxsOrBFmKP | Wulli West (Circuit)         | LHj1LmJ1bnx         | Yorro Bawol                     | ZBulqyOUtiE     |
| test_742 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Niamina Dankunku     | T55lst07vTj | Niamina Dankunku Circuit     | h2F3f5Aeh2r         | Yorro Ya                        | WjrikyKSzny     |
| test_743 | Gambia        | jvQPTsCLwPh | Western Region 1     | XU50mTRcnAP | Kombo North          | WSAdV3EzE5X | Jabang Zone                  | iKAbh5EAylG         | Yunna                           | EONTq8Z3Dxq     |
| test_744 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | cha kunda                       | o4Es0u0eZgJ     |
| test_745 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | changai Toro                    | zBk4reNTx5n     |
| test_746 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | changai wollof                  | XHNThbxV0lj     |
| test_747 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | charen                          | TtDd89zspEi     |
| test_748 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | charjel                         | l3xyjB1hofI     |
| test_749 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | chewel                          | wPJDqIkZJ2G     |
| test_750 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | farato                          | XsitLPBEcPw     |
| test_751 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | farato Njoben                   | cPWEylM3QKD     |
| test_752 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | jakaba                          | yW3QQK8OKmT     |
| test_753 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | jalakoto                        | y8XzUpPB4C5     |
| test_754 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | jalubeh                         | pX5PoOdDQqU     |
| test_755 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | jamagen                         | TgkTu9vCoPt     |
| test_756 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | jamali Babou                    | GdUNXE3C5sc     |
| test_757 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | jamali Bere                     | f1Q0dyAD5ln     |
| test_758 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | jamali Ganyadou                 | KBM2aycl83Y     |
| test_759 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | jamali Tamsir                   | EVBKKZ7gUkb     |
| test_760 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | jamali kebba jobe               | kAEdtGNXNDm     |
| test_761 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | jamali musa                     | ZZ3wXDbHA95     |
| test_762 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | jamwelly                        | QU4DJuDQSz8     |
| test_763 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | jarumeh koto                    | St0abVjAJRD     |
| test_764 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | kalen jawbeh                    | zm2WchxPc77     |
| test_765 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | kalen sainey                    | vHgZR6rrKji     |
| test_766 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | kally kunda                     | hg2roxMBHh7     |
| test_767 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | karantaba Dutokoto              | fMZvTwdQSbQ     |
| test_768 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | karantaba Tabokoto              | w3ieHYiPvqU     |
| test_769 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | karantaba Tenda                 | WdsZi2T0lVO     |
| test_770 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | karantaba toro                  | PCZLQpMTBPs     |
| test_771 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | karantaba wollof                | BrzZAC2rYpN     |
| test_772 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | kerewan Dumbokono               | qfCoQ3uD6YB     |
| test_773 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | kerr juma                       | RoCzIMtEuVt     |
| test_774 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | kerr ngaga                      | gvLOBQHeOC7     |
| test_775 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | kerr ousman Boye                | UDCTvYPEv00     |
| test_776 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | kesserr kunda                   | KgngCk4z3Yd     |
| test_777 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | kibiri                          | djESdH3oWjI     |
| test_778 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | koli kunda                      | gofwrgE8DJy     |
| test_779 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | konkoduma                       | Sg0VxmQsPZU     |
| test_780 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | korra                           | d2d32QwmVXY     |
| test_781 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | kujew fula                      | XN5W1eZ533b     |
| test_782 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | kujew mandinka                  | Wbc5GERUFSU     |
| test_783 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | kunitng                         | FPxfHWRFeD0     |
| test_784 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | lamin koto                      | ZEiWVeHdE72     |
| test_785 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | logomel                         | N9dbNAZgPZy     |
| test_786 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | madiana                         | QnRypJNVzfD     |
| test_787 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | madina Tunjang                  | rKWyusx4Dpc     |
| test_788 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | madina challen                  | gUrgxny4Ceg     |
| test_789 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | madina jalimadi                 | Ab2VRKso7CK     |
| test_790 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | mama yunkumeh                   | dB9mA27bEX3     |
| test_791 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | manna                           | qDsIgpHz1pB     |
| test_792 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | mban sara kunda /sinchu sara    | fzXIBc84Mf2     |
| test_793 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | mbull manda                     | b8C54FgKMeK     |
| test_794 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | misira                          | VcmIhqDAfP9     |
| test_795 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | njallal fula                    | cK9S483NwNS     |
| test_796 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | njoren                          | V4tSQktrtBu     |
| test_797 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | panchang                        | NcJcwzoWWVS     |
| test_798 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | pateh Gai                       | JqI0Dl1uQCG     |
| test_799 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | salinkeni                       | dAkAbD9DONT     |
| test_800 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | samba Tacko                     | HX4Oy3KsGgq     |
| test_801 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | samboido                        | vImzaxJXGys     |
| test_802 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | sami Tenda                      | uY0rQFmpilw     |
| test_803 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | sami omar jula                  | FtDNzysHVqj     |
| test_804 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | sami suruwa kunda               | jIHqgnVXrlK     |
| test_805 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | sankabary                       | DDeHwBkT2iW     |
| test_806 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | sankulay kunda                  | pMP6SOiER81     |
| test_807 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | santanto Bubu                   | iBLUH5dJ242     |
| test_808 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | santanto mawdo                  | HB33HnhrZ6E     |
| test_809 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | santanto mungdow                | lwpazOi1mYa     |
| test_810 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | santanto ousman                 | plWwkrx7lDU     |
| test_811 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | santanto sambademo              | M0WQzCbhwOX     |
| test_812 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | santanto wurma                  | PoLts9DaqVo     |
| test_813 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | sare Tamanson                   | C6M6iLQ3OYZ     |
| test_814 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | sare Bakary                     | oL4QtL4nddY     |
| test_815 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | sare Daddy                      | hUlOirMWAYi     |
| test_816 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | sare Debo                       | sqlyxm4M7mB     |
| test_817 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | sare Demba sowe                 | NgGraEkuCMi     |
| test_818 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | sare Dembaru                    | hmTBqaQqPo6     |
| test_819 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | sare Gibel                      | CS6uX8t3e00     |
| test_820 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | sare Giddeh                     | QovGUCNpdbf     |
| test_821 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | sare Hamadi                     | keI2i5IhcXZ     |
| test_822 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | sare bakary                     | CrHERji7CzS     |
| test_823 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | sare jabel                      | wicflH3sz6d     |
| test_824 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | sare jarjeh                     | qAMV89DSHWt     |
| test_825 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | sare kaba                       | j1n4WFc70rO     |
| test_826 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | sare kally                      | ZTBxBwodfOd     |
| test_827 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | sare kanimang                   | X1tgXCea4TO     |
| test_828 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | sare kinti                      | cp6zFQMbjCn     |
| test_829 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | sare madi Ngenteh               | qtLXkUlsYln     |
| test_830 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | sare madu                       | ted3VaIjbak     |
| test_831 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | sare manka                      | B4FR5PRH2HQ     |
| test_832 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | sare manson                     | MKyF3ALqb2A     |
| test_833 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | sare mudu                       | a8LTpCY8LnB     |
| test_834 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | sare pateh Gassama              | FRStDRajghE     |
| test_835 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | sare pateh Ibadan               | tf2aAYGPoDN     |
| test_836 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | sare pateh jawo                 | yQ9eALjgkK6     |
| test_837 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | sare sabu                       | ZV1hg4K4OYC     |
| test_838 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | sare sambuya                    | jCvKLnNO2z2     |
| test_839 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | sare sawadi                     | D8FUtjA4eRg     |
| test_840 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | sare silere                     | SlC6zK8jWhV     |
| test_841 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | sare sofie                      | cM7Odx72xcg     |
| test_842 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | sare yero Golory                | YnacaBUV4RE     |
| test_843 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | sare yerro youba                | SVHYLYosQHr     |
| test_844 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | sawma kunda                     | U9nVW18vReH     |
| test_845 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | sinchang saka                   | bxdcpayXoR4     |
| test_846 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | sinchang Demba kandeh           | Wi3Ks4BNaPM     |
| test_847 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | sinchang faramba                | wcMuhGaROZo     |
| test_848 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | sinchang molleh                 | nMsPf3SrfdE     |
| test_849 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | sinchang sambunding             | iKhkXLMd7uR     |
| test_850 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | sinchu Baya                     | W04vTVd0E8J     |
| test_851 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | sinchu Bubacarr                 | DvZ8Uo1JDiP     |
| test_852 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | karantaba (Circuit)          | FbxnJOc70eP         | sinchu Duru                     | HamRT0zkwsG     |
| test_853 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | sinchu Galo                     | AhFlrvQXpZW     |
| test_854 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | sinchu Jatta                    | C8ts25ef6GI     |
| test_855 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | sinchu chamale                  | vvCA9bYd98Z     |
| test_856 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | sinchu chandery                 | wh8WaLqigdN     |
| test_857 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | sinchu chedoyel                 | Su2of0hOm6h     |
| test_858 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | sinchu mudu                     | oPRlj49kSfm     |
| test_859 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | sinchu ngorr                    | d6AKyoLsmhm     |
| test_860 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | sinchu sam pateh                | jyqPI7P4UqJ     |
| test_861 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | sinchu sara lellelh             | HYowSbTaKVu     |
| test_862 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | singhateh kunda                 | TH4qI5RiE83     |
| test_863 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | solo fula kunda                 | bVbJ8oVMnTh     |
| test_864 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | sotokoi                         | Sweher2MUl6     |
| test_865 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | sotokoi lamu                    | sv236PBgTYr     |
| test_866 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | sukurr kunda                    | B2E2NaX29Le     |
| test_867 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Sare sofie (Circuit)         | cpgcybdSn1o         | sukuta                          | FKx4IkDb2HW     |
| test_868 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | weligare Demba                  | OTDKqrDbuDc     |
| test_869 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | yero Beri kunda mandinka        | IHSrU7qkrUn     |
| test_870 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Galleh manda (Circuit)       | mX1isPwdBnU         | yero beri kunda fula            | ONdcHoiEyNv     |
| test_871 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Upper fulladu West   | srjR5LWAoBD | Dobong kunda (Circuit)       | ZuoNjavGDsY         | yerro muka                      | vR6HnjaCa4A     |
| test_872 | Gambia        | jvQPTsCLwPh | Central River Region | gsMpbz5DQsM | Sami                 | ZZNUH1LhS7k | Jarumeh koto (Circuit)       | mUy0x5WmEml         | yonna musa                      | d84Dj2RbKDz     |

``` r
# GET THE LIST OF ALL PROGRAMS
programs <- get_programs(login = dhis2_login)
```

| displayName                    | id          | type      |
|:-------------------------------|:------------|:----------|
| Child Registration & Treatment | E5IUQuHg3Mg | tracker   |
| Daily Drug Reconciliations     | I3bZrR6fLt8 | aggregate |

Similarly, users can also access the list of all data elements and
program stages from a given DHIS2 instance as shown in the code chunks
below.

``` r
# GET THE LIST OF ALL DATA ELEMENTS
data_elements <- get_data_elements(login = dhis2_login)
```

| name                                                                                                                 | id          |
|:---------------------------------------------------------------------------------------------------------------------|:------------|
| 2023 SMC/Population \[12-59\]                                                                                        | dlVMdeVRdMT |
| 2023 SMC/Population \[3-11\]                                                                                         | ivXU8ao61Zc |
| 2023 SMC/Population \[60-120\]                                                                                       | TrK0veWmpCe |
| 2023 SMC/Population \[Estimate\]                                                                                     | MdPPzbTUID6 |
| 2023 SMC/Population \[U5\]                                                                                           | A8yIkpzNnZP |
| Did you have stock-outs of supplies in the last three months of 2019 (October to December)?                          | vKOBV7aw669 |
| District Supervisor Full Name                                                                                        | aBRlo18ToEG |
| Do you LAB_have adequate laboratory equipment for malaria Microscopy diagnosis today                                 | Zsw3gwhNKf0 |
| Do you know the exact number of children living in compound (household)?                                             | VaojuTKSwGm |
| Estimated Pop                                                                                                        | Nz0UE35Z4NV |
| LAB_Did you have stock-outs of supplies in the last three months of 2019 (October to December)?                      | paBSj4Oy8M7 |
| LAB_Do you have a copy of the national plan for QA/QC?                                                               | EhAJXPZ0Bkd |
| LAB_Do you have a system for national Lab QA and QC?                                                                 | OgavoRo6eNp |
| LAB_Do you have adequate RDTs for malaria diagnosis?                                                                 | Swa3LASSR67 |
| LAB_Do you have guidelines on monitoring quality of RDTs from procurement to use in the fields?                      | jYdJ2PuNJ7c |
| LAB_Do you have laboratory guidelines, bench aides and SOPs?                                                         | aWSdph3I8G7 |
| LAB_Do you use a laboratory register that can track malaria patient results?                                         | Ts3fFEPGxux |
| LAB_Does the laboratory participate in External Quality Assessment (EQA) programme?                                  | R377S5ir52y |
| LAB_Does your laboratory participate in Drug Efficacy Studies?                                                       | hSiv77Wne6c |
| LAB_How frequently are you supervised by the Reference lab?                                                          | RfdfPXzGkkI |
| LAB_How is internal quality control done on slide microscopy?                                                        | b1QA0IlvtH1 |
| LAB_How many Laboratory staff are in your Unit?                                                                      | MBm7Ze4v6Wr |
| LAB_How many of your Lab staff members trained on malaria diagnosis in 2018-2019? Provide number trained………          | ns5s1X21f3D |
| LAB_Is there a system for purchase of supplies and consumables?                                                      | OlUOpDy0Ce2 |
| LAB_Is there a system in place to organize the management of laboratory documents and records?                       | cEmFUO9piaI |
| LAB_Is your laboratory prepared for response to a possible malaria epidemic in term of commodities/SoPs availability | Z4W2vIb2fvh |
| LAB_Name three most important things that you think are constraints for the laboratory                               | wLzpM5wJ3c3 |
| LAB_Name three things that you think the laboratory is doing well                                                    | GOwTGwBgTdG |
| LAB_What is the frequency of reporting laboratory data to the RHD/ Hospital)?                                        | lghz06tmPRT |
| LAB_What recommendations can you give in in addressing the constraints in the laboratory                             | RlDipG6ICUt |
| NSP Target SMC \[12-59\]                                                                                             | w0h01mJvCwU |
| NSP Target SMC \[3-11\]                                                                                              | j8OSVtnltzH |
| NSP Target SMC \[60-120\]                                                                                            | I6sfBPO33fe |
| Number of cards distributed                                                                                          | gvJtrsupU3V |
| Number of cards received                                                                                             | txqm3bnG9iT |
| Operational Site Name                                                                                                | cKL9tO471vL |
| Pop Estimate                                                                                                         | Am5j9LfDX8O |
| SMC - Compound Name (Household)                                                                                      | SqyWuQ47yGy |
| SMC Child Location (C1)                                                                                              | jg8H0DkSkLR |
| SMC Child Location (C2)                                                                                              | rVSkHMu4Wt8 |
| SMC Child Location (C3)                                                                                              | sQopKK6tXbt |
| SMC Child Location (C4)                                                                                              | b94da9pygBT |
| SMC \[12-59\] Target                                                                                                 | W7HRWoXHNPE |
| SMC \[3-11\] Target                                                                                                  | e34GQkgSSjy |
| SMC- Estimated eligible children living in compound (Household)?                                                     | dTxDm5Gs2Q9 |
| SMC- How many eligible children living in compound (Household)?                                                      | OBFBzhibtDq |
| SMC- Total number of children not treated (3-11)                                                                     | vtMy6JQeDBx |
| SMC- Total number of children treated (12-59)                                                                        | vhMREn2D9Gb |
| SMC- Total number of children treated (3-11)                                                                         | oNYGot2DdBJ |
| SMC-12-59 Months Initial Quantity                                                                                    | Bdb3UTKEoIy |
| SMC-12-59 Months Quantity Distributed                                                                                | mqWi9gUte4M |
| SMC-12-59 Months Quantity Lost                                                                                       | InkpcrPodiz |
| SMC-12-59 Months Quantity Received                                                                                   | ZLsuUEPqCxc |
| SMC-12-59 Months Quantity Wasted                                                                                     | fYA2vCc0KAX |
| SMC-3-11 Months Initial Quantity                                                                                     | TeDvavBhdRq |
| SMC-3-11 Months Quantity Distributed                                                                                 | diBUBTVZH1J |
| SMC-3-11 Months Quantity Lost                                                                                        | v2F4rVmdBvt |
| SMC-3-11 Months Quantity Received                                                                                    | Dho3una7EIX |
| SMC-3-11 Months Quantity Wasted                                                                                      | XkNtE7hRhIU |
| SMC-60-120 Months Initial Quantity                                                                                   | ZY2odH2HCUf |
| SMC-60-120 Months Quantity Distributed                                                                               | O3Kq4Lras7b |
| SMC-60-120 Months Quantity Lost                                                                                      | S8vfHhspNZL |
| SMC-60-120 Months Quantity Received                                                                                  | BKnRPQ8e92m |
| SMC-60-120 Months Quantity Wasted                                                                                    | IsfdYeW0TC5 |
| SMC-CR Did the child sleep under a bed net last night? (C1)                                                          | yYJeYq74hGL |
| SMC-CR Did the child sleep under a bed net last night? (C2)                                                          | izx3fncF1Ga |
| SMC-CR Did the child sleep under a bed net last night? (C3)                                                          | Fbt6YZb8n8U |
| SMC-CR Did the child sleep under a bed net last night? (C4)                                                          | EtxH1wghyro |
| SMC-CR Is child a resident (C1)                                                                                      | TY96CKEW0u7 |
| SMC-CR Is child a resident (C2)                                                                                      | PYbiL2FD9N6 |
| SMC-CR Is child a resident (C3)                                                                                      | LXCNjnjOm7z |
| SMC-CR Is child a resident (C4)                                                                                      | ZPwORmW6P6T |
| SMC-CT Adverse Drug Reactions-Headache (C1)                                                                          | vEm3AUKer6X |
| SMC-CT Adverse Drug Reactions-Headache (C2)                                                                          | MqvCUmiB69E |
| SMC-CT Adverse Drug Reactions-Headache (C3)                                                                          | bXkzjgRylWw |
| SMC-CT Adverse Drug Reactions-Headache (C4)                                                                          | ujLgKkLgm7w |
| SMC-CT Reaction Date (C1)                                                                                            | Vh5ZKfzd7QL |
| SMC-CT Reaction Date (C2)                                                                                            | DJ9B5OD5B3C |
| SMC-CT Reaction Date (C3)                                                                                            | J1QQ6PTRDVJ |
| SMC-CT Reaction Date (C4)                                                                                            | pWF4XKJdPgK |
| SMC-CT Treatment Date (C1)                                                                                           | fYZJ2x6Nthh |
| SMC-CT Treatment Date (C2)                                                                                           | gtggl72WTpE |
| SMC-CT Treatment Date (C3)                                                                                           | vcPuvFHSJsx |
| SMC-CT Treatment Date (C4)                                                                                           | m9t1MarCuWe |
| SMC-CT Adverse Drug Reactions-Drowsiness (C1)                                                                        | hoYvDr7QZI2 |
| SMC-CT Adverse Drug Reactions-Drowsiness (C2)                                                                        | zpKjzHHzw4B |
| SMC-CT Adverse Drug Reactions-Drowsiness (C3)                                                                        | x0KaZp46rDY |
| SMC-CT Adverse Drug Reactions-Drowsiness (C4)                                                                        | HAah0M2Q6D6 |
| SMC-CT Adverse Drug Reactions-Fever (C1)                                                                             | CYm1mOZLxMt |
| SMC-CT Adverse Drug Reactions-Fever (C2)                                                                             | qJnb9a4hw3V |
| SMC-CT Adverse Drug Reactions-Fever (C3)                                                                             | UwYOL7R1ovL |
| SMC-CT Adverse Drug Reactions-Fever (C4)                                                                             | VhCaNfoG6yZ |
| SMC-CT Adverse Drug Reactions-Mild Skin Reaction (C1)                                                                | VjgO2a0bemg |
| SMC-CT Adverse Drug Reactions-Mild Skin Reaction (C2)                                                                | ZzmWEOERZtn |
| SMC-CT Adverse Drug Reactions-Mild Skin Reaction (C3)                                                                | JVxVojIPCwN |
| SMC-CT Adverse Drug Reactions-Mild Skin Reaction (C4)                                                                | TkpVuihgbYL |
| SMC-CT Adverse Drug Reactions-Other (C1)                                                                             | Qu93R0WSBIi |
| SMC-CT Adverse Drug Reactions-Other (C2)                                                                             | EFlvRrUuzb5 |
| SMC-CT Adverse Drug Reactions-Other (C3)                                                                             | SojcscVpaVE |
| SMC-CT Adverse Drug Reactions-Other (C4)                                                                             | DAVuJcuHjIm |
| SMC-CT Adverse Drug Reactions-Tummy Pain or Diarrhea (C1)                                                            | PX4K3hd50VV |
| SMC-CT Adverse Drug Reactions-Tummy Pain or Diarrhea (C2)                                                            | Y0BFQm6M7W1 |
| SMC-CT Adverse Drug Reactions-Tummy Pain or Diarrhea (C3)                                                            | uXTegjxwrse |
| SMC-CT Adverse Drug Reactions-Tummy Pain or Diarrhea (C4)                                                            | BxzawcHFOTy |
| SMC-CT Adverse Drug Reactions-Vomiting (C1)                                                                          | ADrofFgY5eF |
| SMC-CT Adverse Drug Reactions-Vomiting (C2)                                                                          | UhBK9WPEiWX |
| SMC-CT Adverse Drug Reactions-Vomiting (C3)                                                                          | XKaLh3QZNgf |
| SMC-CT Adverse Drug Reactions-Vomiting (C4)                                                                          | FltcfXwTywn |
| SMC-CT Adverse Drug Reactions-Yellow Eyes (C1)                                                                       | OkhmWMm29dn |
| SMC-CT Adverse Drug Reactions-Yellow Eyes (C2)                                                                       | eTMEnaNtjd9 |
| SMC-CT Adverse Drug Reactions-Yellow Eyes (C3)                                                                       | CQWVeeEx0eI |
| SMC-CT Adverse Drug Reactions-Yellow Eyes (C4)                                                                       | vmmDWUXJWvC |
| SMC-CT Choose day (C1)                                                                                               | hZu9hd95sWO |
| SMC-CT Choose day (C2)                                                                                               | ralfZlfgPDV |
| SMC-CT Choose day (C3)                                                                                               | ca8MSOXDBLO |
| SMC-CT Choose day (C4)                                                                                               | aF6WvHwOpd3 |
| SMC-CT Data Collectors Full Name                                                                                     | ZWySWBFhPVX |
| SMC-CT Data Collectors Full Name (C1)                                                                                | pQUvVF4zOa2 |
| SMC-CT Data Collectors Full Name (C2)                                                                                | VlujkP0ebi3 |
| SMC-CT Data Collectors Full Name (C3)                                                                                | E8XMaL7Vg8E |
| SMC-CT Data Collectors Full Name (C4)                                                                                | hUJ48LzWDd7 |
| SMC-CT Did child consume first treatment dose? (C1)                                                                  | WVd0KsMWCLF |
| SMC-CT Did child consume first treatment dose? (C2)                                                                  | QdushhoCH0T |
| SMC-CT Did child consume first treatment dose? (C3)                                                                  | jO35NALEmbS |
| SMC-CT Did child consume first treatment dose? (C4)                                                                  | ewbO5a5m80X |
| SMC-CT Did child consume redose? (C1)                                                                                | QiJdLldyYo2 |
| SMC-CT Did child consume redose? (C2)                                                                                | UQKSUHZ47zG |
| SMC-CT Did child consume redose? (C3)                                                                                | Wio9yw4k6tG |
| SMC-CT Did child consume redose? (C4)                                                                                | dSkkaHDu7tj |
| SMC-CT Did child previously have an adverse drug Reactions? (C1)                                                     | G0FcB6LSGBt |
| SMC-CT Did child previously have an adverse drug Reactions? (C2)                                                     | DssRzZPxyEM |
| SMC-CT Did child previously have an adverse drug Reactions? (C3)                                                     | CgLE67Z01nz |
| SMC-CT Did child previously have an adverse drug Reactions? (C4)                                                     | KrHVbbDTOi5 |
| SMC-CT Did the child consume the SMC drug in Cycle 1?                                                                | kHolv0n3OY8 |
| SMC-CT Did the child consume the SMC drug in Cycle 2?                                                                | tY3Y6dqamOp |
| SMC-CT Did the child consume the SMC drug in Cycle 3?                                                                | CEymGey7Gwf |
| SMC-CT Did the child consume the SMC drug in this current Cycle 4?                                                   | BCmzGm2Z3IJ |
| SMC-CT Specify other reaction please? (C1)                                                                           | ziHcbP3xHOg |
| SMC-CT Specify other reaction please? (C2)                                                                           | QHUwDLvCexJ |
| SMC-CT Specify other reaction please? (C3)                                                                           | fAUAXkzj0F9 |
| SMC-CT Specify other reaction please? (C4)                                                                           | Y9T4LT6IqRO |
| SMC-CT Was child treated? (C1)                                                                                       | bOjepUKccju |
| SMC-CT Was child treated? (C2)                                                                                       | pWGfufyLZLX |
| SMC-CT Was child treated? (C3)                                                                                       | YzDn5YpXYVR |
| SMC-CT Was child treated? (C4)                                                                                       | iLyelGJ53A8 |
| SMC-CT Was child treated? H/F (C1)                                                                                   | cKDN66JELEa |
| SMC-CT Was child treated? H/F (C2)                                                                                   | iLByL0mOw7Z |
| SMC-CT Was child treated? H/F (C3)                                                                                   | vAf1yOkEvTk |
| SMC-CT Was child treated? H/F (C4)                                                                                   | FeXcubToXXm |
| SMC-CT Was the child taken to health facility? (C1)                                                                  | EOHEsUjnZI2 |
| SMC-CT Was the child taken to health facility? (C2)                                                                  | VGtSo24f0F8 |
| SMC-CT Was the child taken to health facility? (C3)                                                                  | Hwh32NYRvZG |
| SMC-CT Was the child taken to health facility? (C4)                                                                  | liclgmthHHq |
| SMC-CT Why not treated? (C1)                                                                                         | MEgIVHyaSMl |
| SMC-CT Why not treated? (C2)                                                                                         | VL7NVUX57gQ |
| SMC-CT Why not treated? (C3)                                                                                         | rDqUiBkiUMU |
| SMC-CT Why not treated? (C4)                                                                                         | utaOv4rJznn |
| SMC-CTChoose Cycle Number                                                                                            | ZB5o3kDYktx |
| SMC-Total number of children not treated (12-59)                                                                     | C33BbrdIzuT |
| SMC-Total number of children not treated (60-120)                                                                    | TaSnyXcncnt |
| SMC-Total number of children treated (60-120)                                                                        | gE7JaTzSPPF |
| Supervisor’s Full Name                                                                                               | w4BMe3IVHVk |
| Team Number                                                                                                          | MAg56Is2wHg |
| U5                                                                                                                   | ydQOqCsQ8BU |
| Under 5 Pop                                                                                                          | bozvJOyK3qS |

``` r
# GET THE LIST OF ALL PROGRAM STAGES FOR A GIVEN PROGRAM ID
program_stages <- get_program_stages(
  login = dhis2_login,
  program = "E5IUQuHg3Mg",
  programs = programs
)
```

| program_id  | program_name                   | program_stage_name | program_stage_id |
|:------------|:-------------------------------|:-------------------|:-----------------|
| E5IUQuHg3Mg | Child Registration & Treatment | Child Treatment    | JWFEa8t5ini      |

It is important to know that not all organisation units are registered
for a specific program. To know the organisation units that run a
particular program, use the
[`get_program_org_units()`](https://epiverse-trace.github.io/readepi/reference/get_program_org_units.md)
function as shown in the example below.

``` r
# GET THE LIST OF ORGANISATION UNITS RUNNING THE SPECIFIED PROGRAM
target_org_units <- get_program_org_units(
    login = dhis2_login,
    program = "E5IUQuHg3Mg",
    org_units = org_units
  )
```

| org_unit_ids | levels            | org_unit_names |
|:-------------|:------------------|:---------------|
| UrLrbEiWk3J  | Town/Village_name | Sare Sibo      |
| wlVsFVeHSTx  | Town/Village_name | Jawo Kunda     |
| kp0ZYUEqJE8  | Town/Village_name | Chewal         |
| Wr3htgGxhBv  | Town/Village_name | Madinayel      |
| psyHoqeN2Tw  | Town/Village_name | Bolibanna      |
| MGBYonFM4y3  | Town/Village_name | Sare Mala      |
| GcLhRNAFppR  | Town/Village_name | Keneba         |
| y1Z3KuvQyhI  | Town/Village_name | Brikama        |
| W3vH9yBUSei  | Town/Village_name | Gidda          |
| ISbNWYieHY8  | Town/Village_name | Song Kunda     |
| L5qATaT5FUt  | Town/Village_name | Garawol Kuta   |
| XmSlKeE9Kg0  | Town/Village_name | Bogal          |
| ARxWDI1mthS  | Town/Village_name | Chamambugu     |
| VNZl27qAELq  | Town/Village_name | Banni          |
| jnW9JB4NUiA  | Town/Village_name | Sotuma         |
| Zrm5o9nPmgh  | Town/Village_name | Koina          |
| kf5boqdaRGc  | Town/Village_name | Kassi Kunda    |
| X2wO2RQkIkP  | Town/Village_name | Madina Balla   |
| XidiOl5MRDq  | Town/Village_name | Laibeh Kunda   |
| cI1jC46SVvG  | Town/Village_name | Tenkolly       |
| N21ldSCO9yo  | Town/Village_name | Toubanding     |
| v3FGJEBIlZd  | Town/Village_name | Kantel Kunda   |
| jS5x3ZtZlqH  | Town/Village_name | Sinchang yero  |
| jE5sny5JZez  | Town/Village_name | Fantumbung     |
| fcL2whiwoiv  | Town/Village_name | Nyamanarr      |
| dbPeHzaO9m5  | Town/Village_name | Sare Biru      |

After identifying the correct organisation unit and program IDs or
names, users can import the corresponding data using the
[`read_dhis2()`](https://epiverse-trace.github.io/readepi/reference/read_dhis2.md)
with the following syntax:

``` r
# IMPORT DATA FROM DHIS2 FOR THE SPECIFIED ORGANISATION UNIT AND PROGRAM IDs
data <- read_dhis2(
  login = dhis2_login,
  org_unit = "GcLhRNAFppR",
  program = "E5IUQuHg3Mg"
)

# IMPORT DATA FROM DHIS2 FOR THE SPECIFIED ORGANISATION UNIT AND PROGRAM NAMES
data <- read_dhis2(
  login = dhis2_login,
  org_unit = "Keneba",
  program = "Child Registration & Treatment "
)
```

| event       | tracked_entity | org_unit | SMC-CR Scan QR Code | SMC-CR Did the child previously received a card? | SMC-CR Child First Name1 | SMC-CR Child Last Name | SMC-CR Date of Birth | SMC-CR Select Age Category | SMC-CR Child gender1 | SMC-CR Mother/Person responsible full name | SMC-CR Mother/Person responsible phone number1 | Eligibility Status | enrollment  | program                        |
|:------------|:---------------|:---------|:--------------------|:-------------------------------------------------|:-------------------------|:-----------------------|:---------------------|:---------------------------|:---------------------|:-------------------------------------------|:-----------------------------------------------|:-------------------|:------------|:-------------------------------|
| bgSDQbeXlD9 | yv7MOkGD23q    | Keneba   | SMC23-0510989       | 1                                                | ebrima                   | jawara                 | 2019-09-25           | 2                          | Male                 | tankey                                     | 2222222                                        | NA                 | bUY7Xw7Lyl0 | Child Registration & Treatment |
| y4MKmPPpx2I | nibnZ8h0Nse    | Keneba   | SMC2021-018089      | 1                                                | isatou                   | jawara                 | 2021-01-09           | 2                          | Female               | bintou                                     | 2222222                                        | NA                 | daxj4LeWRo6 | Child Registration & Treatment |
| yK7VG3Wtg6b | nibnZ8h0Nse    | Keneba   | SMC2021-018089      | 1                                                | isatou                   | jawara                 | 2021-01-09           | 2                          | Female               | bintou                                     | 2222222                                        | NA                 | daxj4LeWRo6 | Child Registration & Treatment |
| EmNflzCQ2HH | nibnZ8h0Nse    | Keneba   | SMC2021-018089      | 1                                                | isatou                   | jawara                 | 2021-01-09           | 2                          | Female               | bintou                                     | 2222222                                        | NA                 | daxj4LeWRo6 | Child Registration & Treatment |
| UF96msdWwos | nibnZ8h0Nse    | Keneba   | SMC2021-018089      | 1                                                | isatou                   | jawara                 | 2021-01-09           | 2                          | Female               | bintou                                     | 2222222                                        | NA                 | daxj4LeWRo6 | Child Registration & Treatment |
| guQTwcfwbKH | FomREQ2it4n    | Keneba   | SMC23-0510012       | 1                                                | isha                     | jawara                 | 2020-08-11           | 2                          | Female               | nyima                                      | 2222222                                        | NA                 | dgtYzDJI0Pl | Child Registration & Treatment |
| jbkRkLm3ebp | FomREQ2it4n    | Keneba   | SMC23-0510012       | 1                                                | isha                     | jawara                 | 2020-08-11           | 2                          | Female               | nyima                                      | 2222222                                        | NA                 | dgtYzDJI0Pl | Child Registration & Treatment |
| AEeypeLSLhQ | FomREQ2it4n    | Keneba   | SMC23-0510012       | 1                                                | isha                     | jawara                 | 2020-08-11           | 2                          | Female               | nyima                                      | 2222222                                        | NA                 | dgtYzDJI0Pl | Child Registration & Treatment |
| R30SPszqqxp | E5oAWGcdFT4    | Keneba   | koika-smc-22897     | 1                                                | jainaba                  | jawara                 | 2015-08-29           | 3                          | Female               | nyima                                      | 2222222                                        | NA                 | hRKbMGejc5b | Child Registration & Treatment |
| nr03Qy9PCL9 | E5oAWGcdFT4    | Keneba   | koika-smc-22897     | 1                                                | jainaba                  | jawara                 | 2015-08-29           | 3                          | Female               | nyima                                      | 2222222                                        | NA                 | hRKbMGejc5b | Child Registration & Treatment |
| Kp96qdLJfr9 | E5oAWGcdFT4    | Keneba   | koika-smc-22897     | 1                                                | jainaba                  | jawara                 | 2015-08-29           | 3                          | Female               | nyima                                      | 2222222                                        | NA                 | hRKbMGejc5b | Child Registration & Treatment |
| GgyddENOSF5 | vyHX2EjyKBo    | Keneba   | koika-smc-22905     | 1                                                | ali                      | jawara                 | 2017-08-29           | 3                          | Female               | nyima                                      | 2222222                                        | NA                 | eShAivyotfq | Child Registration & Treatment |
| ePmu6AT6uqG | tlQ98SKBwiq    | Keneba   | koika-smc-22901     | 1                                                | ismaila                  | jawara                 | 2017-08-29           | 3                          | Male                 | majang                                     | 2222222                                        | NA                 | LUauQFq8EJ7 | Child Registration & Treatment |
| yzQQL7B801h | tlQ98SKBwiq    | Keneba   | koika-smc-22901     | 1                                                | ismaila                  | jawara                 | 2017-08-29           | 3                          | Male                 | majang                                     | 2222222                                        | NA                 | LUauQFq8EJ7 | Child Registration & Treatment |
| hyPVj1t15qu | tlQ98SKBwiq    | Keneba   | koika-smc-22901     | 1                                                | ismaila                  | jawara                 | 2017-08-29           | 3                          | Male                 | majang                                     | 2222222                                        | NA                 | LUauQFq8EJ7 | Child Registration & Treatment |
| xUyse5UPkWD | tlQ98SKBwiq    | Keneba   | koika-smc-22901     | 1                                                | ismaila                  | jawara                 | 2017-08-29           | 3                          | Male                 | majang                                     | 2222222                                        | NA                 | LUauQFq8EJ7 | Child Registration & Treatment |
| FZVjXIN0Z8Q | lJnZ2QHb2Cq    | Keneba   | SMC23-0510011       | 1                                                | jaka                     | jeibo                  | 2019-08-29           | 2                          | Female               | manjan                                     | 2222222                                        | NA                 | tDStluDY1s5 | Child Registration & Treatment |
| zBO6VgSaNCI | lJnZ2QHb2Cq    | Keneba   | SMC23-0510011       | 1                                                | jaka                     | jeibo                  | 2019-08-29           | 2                          | Female               | manjan                                     | 2222222                                        | NA                 | tDStluDY1s5 | Child Registration & Treatment |
| wosL2s6Hofu | NJEYZjtp1G0    | Keneba   | SMC23-0510014       | 1                                                | nyima                    | jawara                 | 2016-08-29           | 3                          | Female               | jankey                                     | 222222                                         | NA                 | mN8ANaSfQdO | Child Registration & Treatment |
| waOgADGeUXb | NJEYZjtp1G0    | Keneba   | SMC23-0510014       | 1                                                | nyima                    | jawara                 | 2016-08-29           | 3                          | Female               | jankey                                     | 222222                                         | NA                 | mN8ANaSfQdO | Child Registration & Treatment |
| Wy2JSJwxmKi | NJEYZjtp1G0    | Keneba   | SMC23-0510014       | 1                                                | nyima                    | jawara                 | 2016-08-29           | 3                          | Female               | jankey                                     | 222222                                         | NA                 | mN8ANaSfQdO | Child Registration & Treatment |
| C0d9S9dGeYu | tt5svuOWumQ    | Keneba   | SMC2021-030829      | 1                                                | fatima                   | jawara                 | 2018-09-29           | 2                          | Female               | haja                                       | 222222                                         | NA                 | Grv6F26nBMU | Child Registration & Treatment |
| j6ilmrW0SNM | tt5svuOWumQ    | Keneba   | SMC2021-030829      | 1                                                | fatima                   | jawara                 | 2018-09-29           | 2                          | Female               | haja                                       | 222222                                         | NA                 | Grv6F26nBMU | Child Registration & Treatment |
| I5Z00FB2Ek8 | tt5svuOWumQ    | Keneba   | SMC2021-030829      | 1                                                | fatima                   | jawara                 | 2018-09-29           | 2                          | Female               | haja                                       | 222222                                         | NA                 | Grv6F26nBMU | Child Registration & Treatment |
| YknsENJb5AC | WSPJAsWSoYT    | Keneba   | SMC23-0510013       | 1                                                | fatoumatta               | touray                 | 2018-09-29           | 2                          | Female               | mariatou                                   | 2222222                                        | NA                 | vANJ2rCbaSN | Child Registration & Treatment |
| eQoZFgIQ4YT | WSPJAsWSoYT    | Keneba   | SMC23-0510013       | 1                                                | fatoumatta               | touray                 | 2018-09-29           | 2                          | Female               | mariatou                                   | 2222222                                        | NA                 | vANJ2rCbaSN | Child Registration & Treatment |
| r0lRXO74uPZ | tHF5RXQ4eqx    | Keneba   | SMC23-0510015       | 1                                                | jainaba                  | sidibeh                | 2022-02-28           | 2                          | Female               | kujayi                                     | 222222                                         | NA                 | kzEzclM1HOI | Child Registration & Treatment |
| zy4USl3kvce | bZaPTsr4pms    | Keneba   | SMC23-0510018       | 1                                                | fatima                   | sidibeh                | 2020-08-29           | 2                          | Female               | kujaigi                                    | 222222                                         | NA                 | NNJt95KuB6Q | Child Registration & Treatment |
| InZURjtqJjd | XhuL5KS3dJ8    | Keneba   | SMC23-0510016       | NA                                               | ali                      | sidibeh                | 2022-02-03           | 2                          | Male                 | haija                                      | 2222222                                        | NA                 | HXLgN5MNKOz | Child Registration & Treatment |
| pvbWkDQnkHB | XhuL5KS3dJ8    | Keneba   | SMC23-0510016       | NA                                               | ali                      | sidibeh                | 2022-02-03           | 2                          | Male                 | haija                                      | 2222222                                        | NA                 | HXLgN5MNKOz | Child Registration & Treatment |
| wtmMNpEOir3 | XhuL5KS3dJ8    | Keneba   | SMC23-0510016       | NA                                               | ali                      | sidibeh                | 2022-02-03           | 2                          | Male                 | haija                                      | 2222222                                        | NA                 | HXLgN5MNKOz | Child Registration & Treatment |
| VBLZpXqr2eu | gGOnPdQgUme    | Keneba   | SMC23-0510951       | 1                                                | bilali                   | sidibeh                | 2022-01-09           | 2                          | Male                 | fatoumatta                                 | 2222222                                        | NA                 | c1cfFLxITVX | Child Registration & Treatment |
| XCvDzguhzms | gGOnPdQgUme    | Keneba   | SMC23-0510951       | 1                                                | bilali                   | sidibeh                | 2022-01-09           | 2                          | Male                 | fatoumatta                                 | 2222222                                        | NA                 | c1cfFLxITVX | Child Registration & Treatment |
| aONiT8IhQD7 | gGOnPdQgUme    | Keneba   | SMC23-0510951       | 1                                                | bilali                   | sidibeh                | 2022-01-09           | 2                          | Male                 | fatoumatta                                 | 2222222                                        | NA                 | c1cfFLxITVX | Child Registration & Treatment |
| OdX2qAZ37wL | hvFaOWcr8LQ    | Keneba   | SMC23-0510952       | 1                                                | jainaba                  | sidibeh                | 2020-12-31           | 2                          | Female               | nyuma                                      | 2222222                                        | NA                 | c41HR9Ol42j | Child Registration & Treatment |
| zmugixNDAz5 | hvFaOWcr8LQ    | Keneba   | SMC23-0510952       | 1                                                | jainaba                  | sidibeh                | 2020-12-31           | 2                          | Female               | nyuma                                      | 2222222                                        | NA                 | c41HR9Ol42j | Child Registration & Treatment |
| t3sRdNGfFa8 | MnTFRm6T4bj    | Keneba   | SMC2021-014369      | 1                                                | fatoumatta               | krubally               | 2022-02-25           | 2                          | Female               | aminata                                    | 2222222                                        | NA                 | KEiyluseFvV | Child Registration & Treatment |
| sBH4nWsASy0 | MnTFRm6T4bj    | Keneba   | SMC2021-014369      | 1                                                | fatoumatta               | krubally               | 2022-02-25           | 2                          | Female               | aminata                                    | 2222222                                        | NA                 | KEiyluseFvV | Child Registration & Treatment |
| VCVnL6txppW | hzJwlQVirUq    | Keneba   | SMC23-0510027       | 1                                                | seitou                   | touray                 | 2022-01-11           | 2                          | Female               | marro                                      | 2222222                                        | NA                 | maj9TJzQHaX | Child Registration & Treatment |
| YUPdVqPff9v | n9met3gjUZe    | Keneba   | SMC23-0510028       | 1                                                | yusuf                    | touray                 | 2022-07-18           | 2                          | Male                 | bintou                                     | 2222222                                        | NA                 | n98o1rH8g5Z | Child Registration & Treatment |
| ZnzmA3bKq0d | jjhocMbfnqC    | Keneba   | SMC23-0510025       | 1                                                | isa                      | touray                 | 2021-08-29           | 2                          | Female               | haja                                       | 2222222                                        | NA                 | eoACDJTIrBn | Child Registration & Treatment |
| rLI2k1RGuND | SfYqfWkExzK    | Keneba   | SMC2021-018835      | NA                                               | Muhammed                 | touray                 | 2017-11-30           | 3                          | Male                 | hawa                                       | 2222222                                        | NA                 | DfnivM9NwMq | Child Registration & Treatment |
| f6YCwzazpa7 | VDA2K6PUbH5    | Keneba   | SMC2021-018836      | 1                                                | adama                    | touray                 | 2020-08-29           | 2                          | Female               | hawa                                       | 2222222                                        | NA                 | Jj53BF3fyy5 | Child Registration & Treatment |
| uMru05Gl1g4 | sisf0DkHR6A    | Keneba   | SMC2021-090008      | 1                                                | amara                    | touray                 | 2020-02-19           | 2                          | Female               | fatoumatta sano                            | 2222222                                        | NA                 | KDdkXZUU6Gg | Child Registration & Treatment |
| fRuZPtmlX9b | rIvu2Zcj1NL    | Keneba   | SMC23-0510026       | 1                                                | ebrima                   | touray                 | 2021-08-29           | 2                          | Male                 | fatou                                      | 2222222                                        | NA                 | vvKIjm0lPPY | Child Registration & Treatment |
| QmONTcoEAmw | IUlDuanC8VK    | Keneba   | koika-smc-22853     | 1                                                | isa                      | bah                    | 2017-08-29           | 3                          | Female               | fatoumatta                                 | 2222222                                        | NA                 | dVoqZMlOBKX | Child Registration & Treatment |
| MRecGcM0aFF | l7RjaYB6IBP    | Keneba   | SMC2021-014206      | 1                                                | ebrima                   | jaiteh                 | 2020-08-29           | 2                          | Male                 | hatu                                       | 2222222                                        | NA                 | LpnzI8JjyjW | Child Registration & Treatment |
| QL0k08EuWLI | f9oSqp8Enl6    | Keneba   | SMC23-0510019       | NA                                               | nyame                    | jaiteh                 | 2022-10-28           | 1                          | Female               | fatou                                      | 2222222                                        | NA                 | LvNvPSn9d4q | Child Registration & Treatment |
| kXroZtzWZC1 | f9oSqp8Enl6    | Keneba   | SMC23-0510019       | NA                                               | nyame                    | jaiteh                 | 2022-10-28           | 1                          | Female               | fatou                                      | 2222222                                        | NA                 | LvNvPSn9d4q | Child Registration & Treatment |
| vnW6OtmlAnB | Qe0sRHVM8yF    | Keneba   | SMC23-0510022       | 1                                                | ansumana                 | touray                 | 2020-10-21           | 2                          | Male                 | jainaba                                    | 2222222                                        | NA                 | SPpQJYmcltI | Child Registration & Treatment |

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

| case_id                       | person_id                     | date_onset | case_origin | case_status    | outcome    | sex | date_of_birth | country | city | latitude | longitude | contact_id                    | date_last_contact | Ct_values |
|:------------------------------|:------------------------------|:-----------|:------------|:---------------|:-----------|:----|:--------------|:--------|:-----|:---------|:----------|:------------------------------|:------------------|:----------|
| T6ZLGJ-MUE7FE-LJOHL2-SVKKCKNM | WON54L-6DMTNR-5OBN3J-UYP3KBQQ | NA         | IN_COUNTRY  | NOT_CLASSIFIED | NO_OUTCOME | NA  | NA            | NA      | NA   | NA       | NA        | NA                            | NA                | NA        |
| TWRMOD-5MX5IA-3XWJ2P-37BOCP5Y | XC44EN-QTJUFI-6BCFWZ-UFXWSJTY | NA         | IN_COUNTRY  | NOT_CLASSIFIED | NO_OUTCOME | NA  | NA            | NA      | NA   | NA       | NA        | NA                            | NA                | NA        |
| WJHHRV-A2UPKG-R37W4R-3QMFCPSQ | RYBAQX-ABO7P3-O3F4JC-UZNDCB4U | 2025-11-11 | IN_COUNTRY  | NOT_CLASSIFIED | NO_OUTCOME | NA  | NA            | NA      | NA   | NA       | NA        | NA                            | NA                | NA        |
| VPMCMM-YUZENC-P3JNEW-A7K62KMU | U2BJQK-M2FWRH-FNY53G-XC4SCCMQ | 2025-11-01 | IN_COUNTRY  | SUSPECT        | DECEASED   | NA  | NA            | NA      | NA   | NA       | NA        | UI23QN-CERU7E-IU5I6I-VCFISPXQ | NA                | NA        |
