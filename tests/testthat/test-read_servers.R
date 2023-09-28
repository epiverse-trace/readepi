test_that("sql_server_read_data works as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  result <- sql_server_read_data(
    user = "rfamro",
    password = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    port = 4497L,
    database_name = "Rfam",
    src = "author",
    driver_name = "",
    dbms = "MySQL"
  )
  expect_type(result, "list")

  result <- sql_server_read_data(
    user = "rfamro",
    password = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    port = 4497L,
    database_name = "Rfam",
    src = "select * from author",
    driver_name = "",
    dbms = "MySQL"
  )
  expect_type(result, "list")
})
