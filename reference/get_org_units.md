# Retrieve DHIS2 organization units, along with their IDs, names, parent IDs, and levels.

Retrieve DHIS2 organization units, along with their IDs, names, parent
IDs, and levels.

## Usage

``` r
get_org_units(login)
```

## Arguments

- login:

  A httr2_response object returned by the
  [`dhis2_login()`](https://epiverse-trace.github.io/readepi/reference/dhis2_login.md)
  function

## Value

A data frame of organization units with the following fields:
organisation unit id and name, as well as the corresponding parent
organisation unit id, and level.
