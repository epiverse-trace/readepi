# Import data from DHIS2

Import data from DHIS2

## Usage

``` r
read_dhis2(login, org_unit, program)
```

## Arguments

- login:

  A httr2_response object returned by the
  [`dhis2_login()`](https://epiverse-trace.github.io/readepi/reference/dhis2_login.md)
  function

- org_unit:

  A character with the organisation unit ID or name

- program:

  A character with the program ID or name

## Value

A data frame that contains both the tracked entity attributes and their
event data.

## Examples

``` r
if (FALSE) { # \dontrun{
  # login to the DHIS2 instance

  dhis2_login <- login(
    type = "dhis2",
    from = "https://play.im.dhis2.org/stable-2-42-1",
    user_name = "admin",
    password = "district"
  )

  org_unit <- "DiszpKrYNg8"
  program <- "IpHINAT79UW"

 # fetch the data from specific program an unit
  data <- read_dhis2(
    login = dhis2_login,
    org_unit = org_unit,
    program = program
  )
} # }
```
