# Download SORMAS data dictionary

Download SORMAS data dictionary

## Usage

``` r
sormas_get_data_dictionary(path = tempdir(), overwrite = TRUE)
```

## Arguments

- path:

  A character with the path to the folder where the downloaded data
  dictionary should be stored. Default is `NULL` i.e. the data
  dictionary will be stored in
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html)

- overwrite:

  A logical used to specify whether to overwrite to overwrite the
  existing data dictionary or not. Default is `TRUE`

## Value

A character with path to the folder where the data dictionary is stored.
When `path = NULL`, the file will be stored in the R temporary folder
as: `dictionary.xlsx`

## Examples

``` r
# download and save the data dictionary in the default R temporary directory
path_to_dictionary <- sormas_get_data_dictionary()
```
