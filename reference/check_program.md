# Validate and retrieve program IDs

Checks whether the specified program ID or name is valid in a DHIS2
instance. If the name provided is a valid program name or ID, it returns
the corresponding ID; otherwise, an error message is shown and a
function listing all available programs is provided.

## Usage

``` r
check_program(login, program)
```

## Arguments

- login:

  A httr2 request object preconfigured for authentication carrying the
  base url, user name, and password.

- program:

  A character of the program name to be validated

## Value

The program ID if the provide program name or ID exists; otherwise, an
error is thrown with a suggestion to use the function that lists all
available programs from the target DHIS2 instance.
