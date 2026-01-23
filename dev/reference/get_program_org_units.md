# Get organisation units that are associated with a given program

Get organisation units that are associated with a given program

## Usage

``` r
get_program_org_units(login, program, org_units = NULL)
```

## Arguments

- login:

  A httr2_response object returned by the
  [`dhis2_login()`](https://epiverse-trace.github.io/readepi/dev/reference/dhis2_login.md)
  function

- program:

  A character with the program ID or name

- org_units:

  A data frame with all organisation units from target DHIS2 instance.
  This is the output from the
  [`get_organisation_units()`](https://epiverse-trace.github.io/readepi/dev/reference/get_organisation_units.md)
  function

## Value

A data frame with the organisation units associated with the provided
program

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

  # fetch the organisation units
  org_units <- get_organisation_units(login = dhis2_login)

  # get the organisation units associated with the following program
  'E5IUQuHg3Mg'
  target_org_units <- get_program_org_units(
    login = dhis2_login,
    program = "E5IUQuHg3Mg",
    org_units = org_units
  )
} # }
```
