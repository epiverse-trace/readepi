# Check whether the user-specified fields are valid

A valid field is the one that corresponds to a column name of the
specified table.

## Usage

``` r
fields_check(fields, table_name, login)
```

## Arguments

- fields:

  A character vector of column names

- table_name:

  A character with the table name

- login:

  The connection object obtained from the
  [`login()`](https://epiverse-trace.github.io/readepi/reference/login.md)
  function.

## Value

A character vector with the valid fields
