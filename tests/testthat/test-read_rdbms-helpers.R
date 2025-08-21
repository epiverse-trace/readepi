test_that("read_rdbms fails as expected when the query is incorrect", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  testthat::skip_on_ci()

  rdbms_login <- login(
    from = "mysql-rfam-public.ebi.ac.uk",
    type = "MySQL",
    user_name = "rfamro",
    password = "",
    driver_name = "",
    db_name = "Rfam",
    port = 4497
  )

  expect_error(
    read_rdbms(
      login = rdbms_login,
      query = list(table = "author", fields = NULL,
                   filter = "this is a fake query")
    ),
    regexp = cat("You provided an incorrect SQL query.")
  )

  expect_warning(
    read_rdbms(
      login = rdbms_login,
      query = list(table = "author", fields = c("author_id", "test"),
                   filter = NULL)
    ),
    regexp = cat("Cannot find the following field names: test in table author.")
  )

  expect_error(
    read_rdbms(
      login = rdbms_login,
      query = list(table = "author", fields = c("kabuga", "test"),
                   filter = NULL)
    ),
    regexp = cat("Incorrect column names provided in 'fields' argument.")
  )
})
