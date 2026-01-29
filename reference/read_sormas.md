# Import data from SORMAS

The function returns the following columns by default:
`case_id, person_id, sex, date_of_birth, case_origin, country, city, latitude, longitude, case_status, date_onset, date_admission, outcome, date_outcome, contact_id, date_last_contact, date_first_contact, Ct_values`.

## Usage

``` r
read_sormas(login, disease, since = 0)
```

## Arguments

- login:

  A list with the user's authentication details

- disease:

  A character with the target disease name

- since:

  A Date value in ISO8601 format (YYYY-mm-dd). Default is `0` i.e. to
  fetch all cases from the beginning of data collection.

## Value

A data frame with the case data of the specified disease.

## Details

Note that the some values in the `date_of_birth` column of the output
object might not have some missing elements such a missing year
(NA-12-26), month (2025-NA-01) or date (2025-12-NA), or a combination of
two missing elements.

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
  # fetch all COVID (coronavirus) cases from the test SORMAS instance
  covid_cases <- read_sormas(
    login = sormas_login,
    disease = "coronavirus"
  )
} # }
```
