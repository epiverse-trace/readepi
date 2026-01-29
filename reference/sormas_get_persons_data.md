# Get personal data of cases from a SORMAS instance

Get personal data of cases from a SORMAS instance

## Usage

``` r
sormas_get_persons_data(login, since)
```

## Arguments

- login:

  A list with the user's authentication details

- since:

  A Date value in ISO8601 format (YYYY-mm-dd). Default is `0` i.e. to
  fetch all cases from the beginning of data collection.

## Value

A data frame with the following eight columns: 'case_id', 'sex',
'date_of_birth', 'country', 'city', 'latitude', 'longitude'
