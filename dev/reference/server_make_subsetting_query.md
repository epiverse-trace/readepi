# Create a subsetting query

Create a subsetting query

## Usage

``` r
server_make_subsetting_query(filter, target_columns, table)
```

## Arguments

- filter:

  An expression that will be used to subset on rows

- target_columns:

  A comma-separated list of column names to be returned

- table:

  The name of the table of interest

## Value

A string with the SQL query made from the input arguments
