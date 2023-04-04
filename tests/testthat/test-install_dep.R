test_that("install_odbc_driver works", {
  expect_output(
    install_odbc_driver(driver_version = 17,
                        force_install=FALSE),
    ""
  )
})

# test_that("install_odbc_driver works", {
#   expect_output(
#     install_odbc_driver(driver_version = 13.1,
#                         force_install=TRUE),
#     ""
#   )
# })

test_that("install_odbc_driver fails as expected", {
  expect_error(
    install_odbc_driver(driver_version = NULL,
                        force_install=FALSE),
    regexp = cat("Assertion on',driver_version,'failed: Must be provided")
  )

  expect_error(
    install_odbc_driver(driver_version = -17,
                        force_install=FALSE),
    regexp = cat("Assertion on',driver_version,'failed: Negative values not allowed")
  )

  expect_error(
    install_odbc_driver(driver_version = "17",
                        force_install=FALSE),
    regexp = cat("Assertion on',driver_version,'failed: Must be of type numeric")
  )

  expect_error(
    install_odbc_driver(driver_version = NA,
                        force_install=FALSE),
    regexp = cat("Assertion on',driver_version,'failed: Must be provided")
  )
})

test_that("install_odbc_driver fails as expected", {
  expect_error(
    install_odbc_driver(driver_version = 17,
                        force_install=NA),
    regexp = cat("Assertion on',force_install,'failed: Missing value not allowed.")
  )

  expect_error(
    install_odbc_driver(driver_version = 17,
                        force_install=c(FALSE, TRUE)),
    regexp = cat("Assertion on',force_install,'failed: Must be logical of length 1.")
  )

  expect_error(
    install_odbc_driver(driver_version = 17,
                        force_install=NULL),
    regexp = cat("Assertion on',force_install,'failed: Must be specified.")
  )
})

