test_that("sql_server_read_data works as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  result <- sql_server_read_data(
    base_url      = "mysql-rfam-public.ebi.ac.uk",
    user_name     = "rfamro",
    password      = "",
    dbms          = "MySQL",
    driver_name   = "",
    database_name = "Rfam",
    port          = 4497L,
    src           = "author",
    records       = NULL,
    fields        = NULL,
    id_position   = NULL,
    id_col_name   = NULL
  )
  expect_type(result, "list")

  result <- sql_server_read_data(
    base_url      = "mysql-rfam-public.ebi.ac.uk",
    user_name     = "rfamro",
    password      = "",
    dbms          = "MySQL",
    driver_name   = "",
    database_name = "Rfam",
    port          = 4497L,
    src           = "select * from author",
    records       = NULL,
    fields        = NULL,
    id_position   = NULL,
    id_col_name   = NULL
  )
  expect_type(result, "list")
})
