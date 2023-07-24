test_that("sql_server_read_data works as expected", {
  result <- sql_server_read_data(
    user = "rfamro",
    password = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    port = 4497,
    database_name = "Rfam",
    source = "author",
    driver_name = "",
    dbms = "MySQL"
  )
  expect_type(result, "list")

  result <- sql_server_read_data(
    user = "rfamro",
    password = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    port = 4497,
    database_name = "Rfam",
    source = "select * from author",
    driver_name = "",
    dbms = "MySQL"
  )
  expect_type(result, "list")
})
