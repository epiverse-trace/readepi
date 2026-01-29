# Check whether the user-provided query is valid

We define a query as valid when it contains either one of the column
names of the table being queried and/or one of the `R` operators
provided in the `lookup_table` object of the package.

## Usage

``` r
query_check(query, login, table_name)
```

## Arguments

- query:

  An R expression that will be converted into an SQL query

- login:

  The connection object obtained from the
  [`login()`](https://epiverse-trace.github.io/readepi/reference/login.md)
  function.

- table_name:

  A character with the table name

## Value

Invisibly returns `TRUE` if the query is valid; throws an error
otherwise.
