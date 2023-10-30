test_that("sql_server_read_data works as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  result <- sql_server_read_data(
    dbms          = "MySQL",
    driver_name   = "",
    host          = "mysql-rfam-public.ebi.ac.uk",
    database_name = "Rfam",
    user_name     = "rfamro",
    password      = "",
    port          = 4497L,
    src           = "author",
    records       = NULL,
    fields        = NULL,
    id_position   = NULL,
<<<<<<< Updated upstream
    id_col_name   = NULL
=======
    id_col_name   = NULL,
>>>>>>> Stashed changes
  )
  expect_type(result, "list")

  result <- sql_server_read_data(
    dbms          = "MySQL",
    driver_name   = "",
    host          = "mysql-rfam-public.ebi.ac.uk",
    database_name = "Rfam",
    user_name     = "rfamro",
    password      = "",
    port          = 4497L,
    src           = "select * from author",
    records       = NULL,
    fields        = NULL,
    id_position   = NULL,
<<<<<<< Updated upstream
    id_col_name   = NULL
=======
    id_col_name   = NULL,
>>>>>>> Stashed changes
  )
  expect_type(result, "list")
})
