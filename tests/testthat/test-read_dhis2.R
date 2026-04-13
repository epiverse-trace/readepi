testthat::skip_on_cran()
testthat::skip_if_offline()
testthat::skip_on_ci()

test_that("read_dhis2 works as expected", {
  # establish the connection to the system
  dhis2_login <- login(
    type = "dhis2",
    from = "https://play.im.dhis2.org/stable-2-41-8",
    user_name = "admin",
    password = "district"
  )

  # use the program and organisation unit IDs
  program <- "IpHINAT79UW"
  org_unit <- "XjpmsLNjyrz"

  # import data from the specified program and org unit
  data <- read_dhis2(
    login = dhis2_login,
    org_unit = org_unit,
    program = program
  )
  expect_s3_class(data, "data.frame")
  expect_identical(dim(data), c(40L, 26L))

  # use the program and organisation unit names
  program <- "Child Programme"
  org_unit <- "Magbaft MCHP"

  # import data from the specified program and org unit
  data <- read_dhis2(
    login = dhis2_login,
    org_unit = org_unit,
    program = program
  )
  expect_s3_class(data, "data.frame")
  expect_identical(dim(data), c(40L, 26L))
})

test_that("read_dhis2 fails as expected", {
  expect_error(
    program <-
    read_dhis2(
      login = dhis2_login,
      org_unit = "I0v1SmdpPzT",
      program = "Child Programme"
    ),
    regexp = cat(
      "The specified organisation unit does not run the program IpHINAT79UW"
    )
  )
})
