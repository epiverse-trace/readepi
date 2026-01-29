# Get the list of disease names from a SORMAS instance

Get the list of disease names from a SORMAS instance

## Usage

``` r
sormas_get_diseases(login)
```

## Arguments

- login:

  A list with the user's authentication details

## Value

A vector of the list of disease names in a SORMAS instance

## Examples

``` r
if (FALSE) { # \dontrun{
  # establish the connection to the SORMAS system
  sormas_login <- login(
    type = "sormas",
    from = "https://demo.sormas.org/sormas-rest",
    user_name = "SurvSup",
    password = "Lk5R7JXeZSEc"
  )
  disease_names <- sormas_get_diseases(
    login = sormas_login
  )
} # }
```
