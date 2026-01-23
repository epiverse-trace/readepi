# Get case data from a SORMAS instance

Get case data from a SORMAS instance

## Usage

``` r
sormas_get_cases_data(login, disease, since)
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

A data frame with the following eight columns: 'case_id', 'person_id',
'date_onset', 'date_admission', 'case_origin', 'case_status', 'outcome',
'date_outcome'. When not available, the 'person_id' and 'date_outcome'
will not be returned.
