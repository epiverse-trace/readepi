# Import data from relational database management systems (RDBMS).

The function assumes the user has read access to the database. Importing
data from RDBMS requires the installation of the appropriate `driver`
that is compatible with the server version hosting the database. For
more details, see the [Installing
drivers](https://epiverse-trace.github.io/readepi/dev/articles/install_drivers.md)
on how to install the driver.

## Usage

``` r
read_rdbms(login, query)
```

## Arguments

- login:

  The connection object obtained from the
  [`login()`](https://epiverse-trace.github.io/readepi/dev/reference/login.md)
  function.

- query:

  An SQL query or a list with the following elements:

  1.  table: a string with the table name

  2.  fields: a vector of column names. When specified, only those
      columns will be returned. Default is `NULL`.

  3.  filter: an expression or a vector of values used to filter the
      rows from the table of interest. This should be of the same length
      as the value for the 'select'. Default is `NULL`.

## Value

A `data.frame` with the requested data as specified in the `query`
argument.

## Examples

``` r
if (FALSE) { # \dontrun{
  # establish the connection to the database
  rdbms_login <- login(
    from = "mysql-rfam-public.ebi.ac.uk",
    type = "mysql",
    user_name = "rfamro",
    password = "",
    driver_name = "",
    db_name = "Rfam",
    port = 4497
  )

  # import data where query parameters are specified as a list
  authors_list <- read_rdbms(
    login = rdbms_login,
    query = list(table = "author", fields = NULL, filter = NULL)
  )

  # import data where query parameters is within an SQL query
  authors_list <- read_rdbms(
    login = rdbms_login,
    query = "select * from author"
  )
} # }
```
