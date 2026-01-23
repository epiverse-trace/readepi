# Download the API specification file from SORMAS

Download the API specification file from SORMAS

## Usage

``` r
sormas_get_api_specification(path = tempdir(), overwrite = TRUE)
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

Invisibly returns the path to the folder where the file is stored. When
`path = NULL`, the file will be stored in the R temporary folder as:
`api_specification.json`

## Examples

``` r
# save the SORMAS API specification into the temporary R folder
path_api_specs <- sormas_get_api_specification()
```
