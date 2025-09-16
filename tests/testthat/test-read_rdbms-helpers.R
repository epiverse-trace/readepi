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

test_that("read_rdbms fails as expected when the filter is incorrect", {
  expect_error(
    read_rdbms(
      login = rdbms_login,
      query = list(table = "author", fields = NULL,
                   filter = "this is a fake query")
    ),
    regexp = cat("You provided an incorrect SQL query.")
  )
})

test_that("read_rdbms send a message when some fields are incorrect", {
  expect_message(
    read_rdbms(
      login = rdbms_login,
      query = list(table = "author", fields = c("author_id", "test"),
                   filter = NULL)
    ),
    regexp = cat("Cannot find the following field name: test in table author.")
  )
})

test_that("read_rdbms fails as expected when the field is incorrect", {
  expect_error(
    read_rdbms(
      login = rdbms_login,
      query = list(table = "author", fields = c("kabuga", "test"),
                   filter = NULL)
    ),
    regexp = cat("Incorrect column names provided in 'fields' argument.")
  )
})
