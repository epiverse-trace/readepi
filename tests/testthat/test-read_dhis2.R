testthat::skip_on_cran()
testthat::skip_if_offline()
testthat::skip_on_ci()

test_that("read_dhis2 works as expected", {
  # establish the connection to the system
  dhis2_login <- login(
    type = "dhis2",
    from = "https://smc.moh.gm/dhis",
    user_name = "test",
    password = "Gambia@123"
  )

  # use the program and organisation unit IDs
  program <- "E5IUQuHg3Mg"
  org_unit <- "GcLhRNAFppR"

  # import data from the specified program and org unit
  data <- read_dhis2(
    login = dhis2_login,
    org_unit = org_unit,
    program = program
  )
  expect_s3_class(data, "data.frame")
  expect_identical(dim(data), c(1116L, 69L))

  # use the program and organisation unit names
  program <- "Child Registration & Treatment "
  org_unit <- "Keneba"

  # import data from the specified program and org unit
  data <- read_dhis2(
    login = dhis2_login,
    org_unit = org_unit,
    program = program
  )
  expect_s3_class(data, "data.frame")
  expect_identical(dim(data), c(1116L, 69L))
})

test_that("read_dhis2 fails as expected", {
  expect_error(
    program <-
    read_dhis2(
      login = dhis2_login,
      org_unit = "I0v1SmdpPzT",
      program = "Child Registration & Treatment "
    ),
    regexp = cat(
      "The specified organisation unit does not run the program E5IUQuHg3Mg"
    )
  )
})
