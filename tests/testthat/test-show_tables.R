test_that("Function 'show_tables' correctly displays the table names", {
  expect_output(
    show_tables(
      credentials.file = system.file("extdata", "test.ini", package = "readepi"),
      project.id = "Rfam",
      driver.name = ""
    ),
    ""
  )
})

test_that("show_tables fails as expected", {
  expect_error(
    show_tables(
      credentials.file = c(system.file("extdata", "test.ini", package = "readepi"), system.file("extdata", "test.ini", package = "readepi")),
      project.id = "Rfam",
      driver.name = ""
    ),
    regexp = cat("Assertion on',credentials.file,'failed: Must be of type 'character' of length 1.")
  )

  expect_error(
    show_tables(
      credentials.file = NULL,
      project.id = "Rfam",
      driver.name = ""
    ),
    regexp = cat("Assertion on',credentials.file,'failed: Credential file not found.")
  )

  expect_error(
    show_tables(
      credentials.file = system.file("extdata", "fake_test.ini", package = "readepi"),
      project.id = c("Rfam", "TEST_READEPI"),
      driver.name = ""
    ),
    regexp = cat("Assertion on',project.id,'failed: Must be of type 'character' of length 1.")
  )

  expect_error(
    show_tables(
      credentials.file = system.file("extdata", "fake_test.ini", package = "readepi"),
      project.id = NULL,
      driver.name = ""
    ),
    regexp = cat("Assertion on',project.id,'failed: Must be specified.")
  )

  expect_error(
    show_tables(
      credentials.file = system.file("extdata", "fake_test.ini", package = "readepi"),
      project.id = "Rfam",
      driver.name = c("", "ODBC Driver 17 for SQL Server")
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must be of type 'character' of length 1.")
  )
})
