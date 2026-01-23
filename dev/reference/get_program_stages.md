# Get program stages for one or more DHSI2 programs

Retrieves the stages associated with specified DHIS2 program IDs, or all
programs if none are specified. If any of the supplied program names or
IDs are not found, the function displays a message and proceeds with the
valid ones.

## Usage

``` r
get_program_stages(login, programs = NULL, program = NULL)
```

## Arguments

- login:

  A httr2_response object returned by the
  [`dhis2_login()`](https://epiverse-trace.github.io/readepi/dev/reference/dhis2_login.md)
  function

- programs:

  A data frame with the program IDs and names obtained from the
  [`get_programs()`](https://epiverse-trace.github.io/readepi/dev/reference/get_programs.md)
  function

- program:

  A character with the program ID or name

## Value

A data frame with the following columns:

1.  `program_id`: the unique ID of the program

2.  `program_name`: the displayed name of the program

3.  `program_stage_name`: the name of each stage associate with the
    program

4.  `program_stage_id`: the ID of each program stage

## Examples

``` r
if (FALSE) { # \dontrun{
  # establish the connection to the DHIS2 instance
  dhis2_login <- login(
    type = "dhis2",
    from = "https://smc.moh.gm/dhis",
    user_name = "test",
    password = "Gambia@123"
  )

  # get the list of all program stages from the DHIS2 instance
  all_program_stages <- get_program_stages(
    login = dhis2_login,
    program = "E5IUQuHg3Mg",
    programs = NULL
  )
} # }
```
