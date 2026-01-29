# get all programs from a given specific DHIS2 instance

The function first fetches all programs from the DHIS2 Aggregate system,
then distinguishes the Tracker and Aggregate programs.

## Usage

``` r
get_programs(login)
```

## Arguments

- login:

  A httr2_response object returned by the
  [`dhis2_login()`](https://epiverse-trace.github.io/readepi/reference/dhis2_login.md)
  function

## Value

A data frame with the following columns: the program ID, the program
name, and the program type specifying whether the program is part of the
Aggregate or Tracker system.

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

  # fetch the programs
  programs <- get_programs(login = dhis2_login)
} # }
```
