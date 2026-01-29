# Get the organization units from a specific DHIS2 instance

Retrieves all organisational reporting units and their levels, then
builds a hierarchy for each unit by tracing its ancestries from the
deepest level up to the root.

## Usage

``` r
get_organisation_units(login)
```

## Arguments

- login:

  A httr2_response object returned by the
  [`dhis2_login()`](https://epiverse-trace.github.io/readepi/reference/dhis2_login.md)
  function

## Value

A data frame where each row represents a full hierarchy for the
last-level unit by keeping the hierarchical organizational unit's name
and ID at each level, using the official level names provided by the
DHIS2 instance like "Country Name", "Country ID", etc.

## Details

1.  Fetches all organisation units via the
    [`get_org_units()`](https://epiverse-trace.github.io/readepi/reference/get_org_units.md)
    function,

2.  Fetches all organisational unit levels via the
    [`get_org_unit_levels()`](https://epiverse-trace.github.io/readepi/reference/get_org_unit_levels.md)
    function,

3.  Filters for organisational units at the deepest level,

4.  Traces the parent hierarchy of each deepest unit up to the root,

5.  Constructs a tabular structure where each row is a full lineage.

## Examples

``` r
if (FALSE) { # \dontrun{
  # establish the connection to the system
  dhis2_login <- login(
    type = "dhis2",
    from = "https://smc.moh.gm/dhis",
    user_name = "test",
    password = "Gambia@123"
  )

  # fetch the organisation units
  org_units <- get_organisation_units(login = dhis2_login)
} # }
```
