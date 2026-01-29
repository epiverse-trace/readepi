# Get event data from the newer DHIS2 versions (version \>= 2.41)

Get event data from the newer DHIS2 versions (version \>= 2.41)

## Usage

``` r
get_event_data(
  login,
  api_version,
  org_unit,
  program,
  data_elements,
  programs,
  program_stages,
  org_units
)
```

## Arguments

- login:

  A httr2_response object returned by the
  [`dhis2_login()`](https://epiverse-trace.github.io/readepi/reference/dhis2_login.md)
  function

- api_version:

  A numeric with the API version returned by the
  [`get_api_version()`](https://epiverse-trace.github.io/readepi/reference/get_api_version.md)
  function

- org_unit:

  A character with the organisation unit ID or name

- program:

  A character with the program ID or name

- data_elements:

  A data frame with the data element IDs and names obtained from the
  [`get_data_elements()`](https://epiverse-trace.github.io/readepi/reference/get_data_elements.md)
  function

- programs:

  A data frame with the program IDs and names obtained from the
  [`get_programs()`](https://epiverse-trace.github.io/readepi/reference/get_programs.md)
  function

- program_stages:

  A data frame with the program stages IDs and names obtained from the
  [`get_program_stages()`](https://epiverse-trace.github.io/readepi/reference/get_program_stages.md)
  function

- org_units:

  A data frame with the organisation units IDs and names obtained from
  the
  [`get_organisation_units()`](https://epiverse-trace.github.io/readepi/reference/get_organisation_units.md)
  function

## Value

A data frame with the data elements obtained from each event
