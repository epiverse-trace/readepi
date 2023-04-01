test_that("install_odbc_driver works", {
  expect_output(
    install_odbc_driver(
      driver_version = 17
    ),
    ""
  )
})

test_that("install_odbc_driver fails as expected", {
  expect_error(
    install_odbc_driver(
      driver_version = NULL
    ),
    regexp = cat("Assertion on',driver_version,'failed: Must be provided")
  )

  expect_error(
    install_odbc_driver(
      driver_version = -17
    ),
    regexp = cat("Assertion on',driver_version,'failed: Negative values not allowed")
  )

  expect_error(
    install_odbc_driver(
      driver_version = "17"
    ),
    regexp = cat("Assertion on',driver_version,'failed: Must be of type numeric")
  )

  expect_error(
    install_odbc_driver(
      driver_version = NA
    ),
    regexp = cat("Assertion on',driver_version,'failed: Must be provided")
  )
})
