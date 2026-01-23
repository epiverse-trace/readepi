# Get DHIS2 API version

Get DHIS2 API version

## Usage

``` r
get_api_version(login)
```

## Arguments

- login:

  A httr2_response object returned by the
  [`dhis2_login()`](https://epiverse-trace.github.io/readepi/dev/reference/dhis2_login.md)
  function

## Value

A numeric with minor version of the API

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

  # get the API version
  api_version <- get_api_version(login = dhis2_login)
} # }
```
