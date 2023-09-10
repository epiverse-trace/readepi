test_that("Function 'show_tables' correctly displays the table names", {
<<<<<<< HEAD
  expect_output(
    show_tables(
      credentials_file = system.file("extdata", "test.ini",
                                     package = "readepi"),
      project_id = "Rfam",
      driver_name = ""
    ),
    ""
  )
=======
  tables <- show_tables(
    data_source      = "mysql-rfam-public.ebi.ac.uk",
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    driver_name      = ""
  )
  expect_type(tables, "character")
>>>>>>> review
})

test_that("show_tables fails as expected", {
  expect_error(
    show_tables(
<<<<<<< HEAD
      credentials_file = c(system.file("extdata", "test.ini",
                                       package = "readepi"),
                           system.file("extdata", "test.ini",
                                       package = "readepi")),
      project_id = "Rfam",
=======
      data_source = "mysql-rfam-public.ebi.ac.uk",
      credentials_file = c(
        system.file("extdata", "test.ini",
          package = "readepi"
        ),
        system.file("extdata", "test.ini",
          package = "readepi"
        )
      ),
>>>>>>> review
      driver_name = ""
    ),
    regexp = cat("Assertion on',credentials_file,'failed: Must be of type
                 'character' of length 1.")
  )

  expect_error(
    show_tables(
<<<<<<< HEAD
      credentials_file = NULL,
      project_id = "Rfam",
      driver_name = ""
=======
      data_source      = "mysql-rfam-public.ebi.ac.uk",
      credentials_file = NULL,
      driver_name      = ""
>>>>>>> review
    ),
    regexp = cat("Assertion on',credentials_file,'failed: Credential file
                 not found.")
  )

  expect_error(
    show_tables(
<<<<<<< HEAD
      credentials_file = system.file("extdata", "fake_test.ini",
                                     package = "readepi"),
      project_id = c("Rfam", "TEST_READEPI"),
      driver_name = ""
    ),
    regexp = cat("Assertion on',project_id,'failed: Must be of type 'character'
=======
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
>>>>>>> review
                 of length 1.")
  )

  expect_error(
    show_tables(
<<<<<<< HEAD
      credentials_file = system.file("extdata", "fake_test.ini",
                                     package = "readepi"),
      project_id = NULL,
      driver_name = ""
    ),
    regexp = cat("Assertion on',project_id,'failed: Must be specified.")
  )

  expect_error(
    show_tables(
      credentials_file = system.file("extdata", "fake_test.ini",
                                     package = "readepi"),
      project_id = "Rfam",
      driver_name = c("", "ODBC Driver 17 for SQL Server")
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must be of type
                 'character' of length 1.")
=======
      data_source = NULL,
      credentials_file = system.file("extdata", "test.ini",
        package = "readepi"
      ),
      driver_name = ""
    ),
    regexp = cat("Assertion on',data_source,'failed: Must be specified.")
>>>>>>> review
  )
})
