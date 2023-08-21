test_that("Function 'show_tables' correctly displays the table names", {
    tables <- show_tables(
      credentials_file = system.file("extdata", "test.ini",
                                     package = "readepi"),
      url = "mysql-rfam-public.ebi.ac.uk",
      driver_name = ""
    )
    expect_type(tables, "character")
})

test_that("show_tables fails as expected", {
  expect_error(
    show_tables(
      credentials_file = c(
        system.file("extdata", "test.ini",
          package = "readepi"
        ),
        system.file("extdata", "test.ini",
          package = "readepi"
        )
      ),
      url = "mysql-rfam-public.ebi.ac.uk",
      driver_name = ""
    ),
    regexp = cat("Assertion on',credentials_file,'failed: Must be of type
                 'character' of length 1.")
  )

  expect_error(
    show_tables(
      credentials_file = NULL,
      url = "mysql-rfam-public.ebi.ac.uk",
      driver_name = ""
    ),
    regexp = cat("Assertion on',credentials_file,'failed: Credential file
                 not found.")
  )

  expect_error(
    show_tables(
      credentials_file = system.file("extdata", "fake_test.ini",
        package = "readepi"
      ),
      url = c("mysql-rfam-public.ebi.ac.uk", "mysql-rfam-public.ebi.ac.uk"),
      driver_name = ""
    ),
    regexp = cat("Assertion on',url,'failed: Must be of type 'character'
                 of length 1.")
  )

  expect_error(
    show_tables(
      credentials_file = system.file("extdata", "fake_test.ini",
        package = "readepi"
      ),
      url = NULL,
      driver_name = ""
    ),
    regexp = cat("Assertion on',url,'failed: Must be specified.")
  )

  expect_error(
    show_tables(
      credentials_file = system.file("extdata", "fake_test.ini",
        package = "readepi"
      ),
      url = "mysql-rfam-public.ebi.ac.uk",
      driver_name = c("", "ODBC Driver 17 for SQL Server")
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must be of type
                 'character' of length 1.")
  )
})
