test_that("install_odbc_driver works", {
  expect_output(
    install_odbc_driver(
      driver.version=17
    ),
    ""
  )
})

test_that("show_tables fails as expected", {
  expect_error(
    install_odbc_driver(
      driver.version=NULL
    ),
    regexp = cat("Assertion on',driver.version,'failed: Must be provided")
  )

  expect_error(
    install_odbc_driver(
      driver.version=-17
    ),
    regexp = cat("Assertion on',driver.version,'failed: Negative values not allowed")
  )
})
