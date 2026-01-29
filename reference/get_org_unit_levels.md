# Extract the DHSI2 organization unit's hierarchical levels.

The level is a numerical number, with 1 referring to the "Country", 2
"Region", and so on to the deepest level denoting the health care
reporting unit.

## Usage

``` r
get_org_unit_levels(login)
```

## Arguments

- login:

  A httr2_response object returned by the
  [`dhis2_login()`](https://epiverse-trace.github.io/readepi/reference/dhis2_login.md)
  function

## Value

A data frame with three columns containing the organization unit's
names, IDs, and their hierarchical levels.
