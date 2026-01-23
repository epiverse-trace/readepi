# Transform the organisation units data frame from large to long format

Transform the organisation units data frame from large to long format

## Usage

``` r
get_org_unit_as_long(login, org_units = NULL)
```

## Arguments

- login:

  The login object

- org_units:

  A data frame of all the organisation units obtained from the
  [`get_organisation_units()`](https://epiverse-trace.github.io/readepi/dev/reference/get_organisation_units.md)
  function. Default is `NULL`.

## Value

A data with three columns corresponding to the organisation unit names,
IDs, and levels
