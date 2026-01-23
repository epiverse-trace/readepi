# Get tracked entity attributes, their corresponding IDs and event IDs

Get tracked entity attributes, their corresponding IDs and event IDs

## Usage

``` r
get_tracked_entities(login, api_version, org_unit, program, org_units)
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

- org_unit:

  A character with the organisation unit ID or name

- program:

  A character with the program ID or name

- org_units:

  A data frame with all organisation units from target DHIS2 instance.
  This is the output from the
  [`get_organisation_units()`](https://epiverse-trace.github.io/readepi/dev/reference/get_organisation_units.md)
  function

## Value

A data frame with the tracked entity attributes alongside their events
and tracked entity IDs

## Examples

``` r
if (FALSE) { # \dontrun{
  # login to the DHIS2 instance
  dhis2_login <- login(
    type = "dhis2",
    from = "https://smc.moh.gm/dhis",
    user_name = "test",
    password = "Gambia@123"
  )

  # set the program and org unit IDs
  program <- "E5IUQuHg3Mg"
  org_unit <- "GcLhRNAFppR"

  # get the api version
  api_version <- get_api_version(login = dhis2_login)

  # get all the organisation units from the DHIS2 instance
  org_units <- get_organisation_units(login = dhis2_login)

  # get the tracked entity attributes
  tracked_entity_attributes <- get_tracked_entities(
    login = dhis2_login,
    api_version = api_version,
    org_unit = org_unit,
    program = program,
    org_units = org_units
  )
} # }
```
