# Make an SQL query from a list of query parameters

Make an SQL query from a list of query parameters

## Usage

``` r
server_make_query(table_name, login, filter, select)
```

## Arguments

- table_name:

  The name of the table in the server function

- login:

  The connection object obtained from the
  [`login()`](https://epiverse-trace.github.io/readepi/reference/login.md)
  function.

- filter:

  A vector or a comma-separated string of subset of subject IDs

- select:

  A vector of column names

## Value

A string with the constructed SQL query from the provided query
parameter.
