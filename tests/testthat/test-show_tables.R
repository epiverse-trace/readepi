testthat::skip_on_cran()
testthat::skip_if_offline()
testthat::skip_on_ci()

rdbms_login <- login(
  from = "mysql-rfam-public.ebi.ac.uk",
  type = "mysql",
  user_name = "rfamro",
  password = "",
  driver_name = "",
  db_name = "Rfam",
  port = 4497
)

test_that("Function 'show_tables' correctly displays the table names", {
  tables <- show_tables(
    login = rdbms_login
  )
  expect_type(tables, "character")
})

test_that("show_tables fails as expected", {
  expect_error(
    show_tables(
      login = "fake-login"
    ),
    regexp = cat("Invalid connection object!")
  )
})
