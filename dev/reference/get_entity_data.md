# Get tracked entity attributes

Get tracked entity attributes

## Usage

``` r
get_entity_data(login, api_version, tracked_entities, org_units)
```

## Arguments

- login:

  A httr2_response object returned by the
  [`dhis2_login()`](https://epiverse-trace.github.io/readepi/dev/reference/dhis2_login.md)
  function

- api_version:

  A numeric with the API version obtained from the
  [`get_api_version()`](https://epiverse-trace.github.io/readepi/dev/reference/get_api_version.md)
  function

- org_units:

  A data frame with all organisation units from target DHIS2 instance.
  This is the output from the
  [`get_organisation_units()`](https://epiverse-trace.github.io/readepi/dev/reference/get_organisation_units.md)
  function

## Value

A data frame with the tracked entity attributes
