testthat::skip_on_cran()
testthat::skip_if_offline()
testthat::skip_on_ci()

test_that("get_org_unit_as_long with a non-data frame object", {
  dhis2_login <- login(
    type = "dhis2",
    from = "https://play.im.dhis2.org/stable-2-41-8",
    user_name = "admin",
    password = "district"
  )
  expect_error(
    get_org_unit_as_long(
      login = dhis2_login,
      org_units = "bad_org_unit_structure"
    ),
    regexp = cat("Value for 'org_units' argument must be a data frame-like
                 object")
  )

  expect_error(
    get_org_unit_as_long(
      login = dhis2_login,
      org_units = 10
    ),
    regexp = cat("Value for 'org_units' argument must be a data frame-like
                 object")
  )

  expect_error(
    get_org_unit_as_long(
      login = dhis2_login,
      org_units = TRUE
    ),
    regexp = cat("Value for 'org_units' argument must be a data frame-like
                 object")
  )
})


test_that("check_program fails as expected", {
  dhis2_login <- login(
    type = "dhis2",
    from = "https://play.im.dhis2.org/stable-2-41-8",
    user_name = "admin",
    password = "district"
  )
  programs <- get_programs(login = dhis2_login)
  program_name <- "fake_program"
  program_id <- "IpHINAT7XXX"

  expect_error(
    check_program(
      login = dhis2_login,
      program = program_name
    ),
    regexp = cat("You provided an incorrect program ID or name.")
  )

  expect_error(
    check_program(
      login = dhis2_login,
      program = program_id
    ),
    regexp = cat("You provided an incorrect program ID or name.")
  )

  program_id <- c("IpHINAT79UW", "E5IUQuHgXXX")
  expect_message(
    check_program(
      login = dhis2_login,
      program = program_id
    ),
    regexp = cat("Could not find the following program: E5IUQuHgXXX")
  )
})

test_that("get_program_stages fails as expected", {
  expect_error(
    get_programs(login = dhis2_login),
    regexp = cat("Value for 'org_units' argument must be a data frame-like
                 object")
  )
})
