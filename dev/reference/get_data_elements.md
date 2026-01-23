# Get all data elements from a specific DHIS2 instance

Get all data elements from a specific DHIS2 instance

## Usage

``` r
get_data_elements(login)
```

## Arguments

- login:

  A httr2_response object returned by the
  [`dhis2_login()`](https://epiverse-trace.github.io/readepi/dev/reference/dhis2_login.md)
  function

## Value

A data frame with the following two columns: the data elements IDs and
their corresponding names.

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

  # retrieve the data elements
  data_elements <- get_data_elements(login = dhis2_login)
} # }
```
