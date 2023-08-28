test_that("Function 'show_tables' correctly displays the table names", {
  tables <- show_tables(
    data_source      = "mysql-rfam-public.ebi.ac.uk",
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    driver_name      = ""
  )
  expect_type(tables, "character")
})

test_that("show_tables fails as expected", {
  expect_error(
    show_tables(
      data_source = "mysql-rfam-public.ebi.ac.uk",
      credentials_file = c(
        system.file("extdata", "test.ini",
          package = "readepi"
        ),
        system.file("extdata", "test.ini",
          package = "readepi"
        )
      ),
      driver_name = ""
    ),
    regexp = cat("Assertion on',credentials_file,'failed: Must be of type
                 'character' of length 1.")
  )

  expect_error(
    show_tables(
      data_source      = "mysql-rfam-public.ebi.ac.uk",
      credentials_file = NULL,
      driver_name      = ""
    ),
    regexp = cat("Assertion on',credentials_file,'failed: Credential file
                 not found.")
  )

  expect_error(
    show_tables(
      data_source = c(
        "mysql-rfam-public.ebi.ac.uk",
        "mysql-rfam-public.ebi.ac.uk"
      ),
      credentials_file = system.file("extdata", "test.ini",
        package = "readepi"
      ),
      driver_name = ""
    ),
    regexp = cat("Assertion on',data_source,'failed: Must be of type 'character'
                 of length 1.")
  )

  expect_error(
    show_tables(
      data_source = NULL,
      credentials_file = system.file("extdata", "test.ini",
        package = "readepi"
      ),
      driver_name = ""
    ),
    regexp = cat("Assertion on',data_source,'failed: Must be specified.")
  )
})
