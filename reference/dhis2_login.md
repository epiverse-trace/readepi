# Establish connection to a DHIS2 instance

Establish connection to a DHIS2 instance

## Usage

``` r
dhis2_login(base_url, user_name, password)
```

## Arguments

- base_url:

  A character with the base URL of the target DHIS2 instance

- user_name:

  A character with the user name

- password:

  A character with the user's password

## Value

An `httr2_response` object if the connection was successfully
established

## Examples

``` r
if (FALSE) { # \dontrun{
  dhis2_log <- dhis2_login(
    base_url = "https://play.im.dhis2.org/stable-2-42-1",
    user_name = "admin",
    password = "district"
  )
} # }
```
