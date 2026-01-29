# Establish a connection to the HIS of interest.

The current version of the package supports basic authentication (using
the username and password) and personal authentication key (using API
key and bearer token).

## Usage

``` r
login(
  from,
  type,
  user_name = NULL,
  password = NULL,
  driver_name = NULL,
  db_name = NULL,
  port = NULL
)
```

## Arguments

- from:

  The URL to the HIS of interest. For APIs, this must be the base URL
  (required).

- type:

  The source name (required). The current version of the package covers
  the following RDBMS and HIS types: "ms sql", "mysql", "postgresql",
  "sqlite", "dhis2", and "sormas".

- user_name:

  The user name (optional).

- password:

  The user's password (optional). When the password is not provided (set
  to `NULL`), the user will be prompt to enter the password.

- driver_name:

  The driver name (optional). This is only needed for connecting to
  RDBMS only.

- db_name:

  The database name (optional). This is only needed for connecting to
  RDBMS only.

- port:

  The port ID (optional). This is only needed for connecting to RDBMS
  only.

## Value

A connection object

## Examples

``` r
# connect to the test MySQL server
if (FALSE) { # \dontrun{
  login <- login(
    from = "mysql-rfam-public.ebi.ac.uk",
    type = "mysql",
    user_name = "rfamro",
    password = "",
    driver_name = "",
    db_name = "Rfam",
    port = 4497
  )
} # }

# connect to a DHIS2 instance
if (FALSE) { # \dontrun{
  dhi2s_login <- login(
    type = "dhis2",
    from = "https://smc.moh.gm/dhis",
    user_name = "test",
    password = "Gambia@123"
  )
} # }

# connect to SORMAS
if (FALSE) { # \dontrun{
  sormas_login <- login(
    type = "sormas",
    from = "https://demo.sormas.org/sormas-rest",
    user_name = "SurvSup",
    password = "Lk5R7JXeZSEc"
  )
} # }
```
