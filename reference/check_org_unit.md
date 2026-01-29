# Validate user-specified organisation unit ID or name.

Check whether a given organisation unit identifier or name is valid
within a DHIS2 instance. If a valid name is provided, the corresponding
organisation unit ID is returned. Otherwise, an informative error
message is thrown.

## Usage

``` r
check_org_unit(login, org_unit, org_units = NULL)
```

## Arguments

- login:

  A httr2 request object preconfigured for authentication carrying the
  base url, user name, and password.

- org_unit:

  A character denoting the name or id of the organisation unit

- org_units:

  An optional data frame of organisation units as returned by the
  [`get_organisation_units()`](https://epiverse-trace.github.io/readepi/reference/get_organisation_units.md)
  function.

## Value

The organisation unit ID if the provided organisation unit ID or name
exists; otherwise, an error is thrown with a suggestion to use the
function that lists all available organisation units from the target
DHIS2 instance.
