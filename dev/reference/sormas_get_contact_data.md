# Get contact data from SORMAS

Get contact data from SORMAS

## Usage

``` r
sormas_get_contact_data(login, since)
```

## Arguments

- login:

  A list with the user's authentication details

- since:

  A Date value in ISO8601 format (YYYY-mm-dd). Default is `0` i.e. to
  fetch all cases from the beginning of data collection.

## Value

A data frame with the following three columns: 'case_id', 'contact_id',
'date_last_contact', 'date_first_contact'. When not available,
'date_last_contact' will not be returned
