# Display the list of tables in a database

Display the list of tables in a database

## Usage

``` r
show_tables(login)
```

## Arguments

- login:

  The connection object obtained from the
  [`login()`](https://epiverse-trace.github.io/readepi/dev/reference/login.md)
  function.

## Value

a `character` that contains the list of all tables found in the
specified database.

## Examples

``` r
if (FALSE) { # \dontrun{
# connect to the test MySQL server
  rdbms_login <- login(
    from        = "mysql-rfam-public.ebi.ac.uk",
    type        = "mysql",
    user_name   = "rfamro",
    password    = "",
    driver_name = "",
    db_name     = "Rfam",
    port        = 4497
  )

# display the list of available tables from this database
tables <- show_tables(login = rdbms_login)
} # }
```
