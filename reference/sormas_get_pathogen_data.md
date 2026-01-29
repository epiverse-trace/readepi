# Get pathogen tests data from SORMAS

Get pathogen tests data from SORMAS

## Usage

``` r
sormas_get_pathogen_data(login, since)
```

## Arguments

- login:

  A list with the user's authentication details

- since:

  A Date value in ISO8601 format (YYYY-mm-dd). Default is `0` i.e. to
  fetch all cases from the beginning of data collection.

## Value

A data frame with the following two columns: 'case_id', 'Ct_values'
