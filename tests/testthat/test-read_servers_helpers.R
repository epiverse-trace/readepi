test_that("connect_to_server works as expected", {
  con <- connect_to_server(
    dbms = "MySQL",
    driver_name = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    database_name = "Rfam",
    user = "rfamro",
    password = "",
    port = 4497
  )
})

test_that("connect_to_server fails with incorrect dbms", {
  expect_error(
    connect_to_server(
      dbms = NA,
      driver_name = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = "Rfam",
      user = "rfamro",
      password = "",
      port = 4497
    ),
    regexp = cat("Assertion on',dbms,'failed: Missing value not
                 allowed.")
  )

  expect_error(
    connect_to_server(
      dbms = NULL,
      driver_name = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = "Rfam",
      user = "rfamro",
      password = "",
      port = 4497
    ),
    regexp = cat("Assertion on',dbms,'failed: Must be provided.")
  )

  expect_error(
    connect_to_server(
      dbms = c("MySQL", "test"),
      driver_name = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = "Rfam",
      user = "rfamro",
      password = "",
      port = 4497
    ),
    regexp = cat("Assertion on',dbms,'failed: Must be of type character
                 with length 1.")
  )
})

test_that("connect_to_server fails with incorrect driver_name", {
  expect_error(
    connect_to_server(
      dbms = "MySQL",
      driver_name = NA,
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = "Rfam",
      user = "rfamro",
      password = "",
      port = 4497
    ),
    regexp = cat("Assertion on',driver_name,'failed: Missing value not
                 allowed.")
  )

  expect_error(
    connect_to_server(
      dbms = "MySQL",
      driver_name = NULL,
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = "Rfam",
      user = "rfamro",
      password = "",
      port = 4497
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must be provided.")
  )

  expect_error(
    connect_to_server(
      dbms = "MySQL",
      driver_name = c("ODBC Driver 17 for SQL Server", ""),
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = "Rfam",
      user = "rfamro",
      password = "",
      port = 4497
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must be of type charater
                 with length 1.")
  )
})

test_that("connect_to_server fails with incorrect host", {
  expect_error(
    connect_to_server(
      dbms = "MySQL",
      driver_name = "",
      host = NA,
      database_name = "Rfam",
      user = "rfamro",
      password = "",
      port = 4497
    ),
    regexp = cat("Assertion on',host,'failed: Missing value not
                 allowed for host name.")
  )

  expect_error(
    connect_to_server(
      dbms = "MySQL",
      driver_name = "",
      host = NULL,
      database_name = "Rfam",
      user = "rfamro",
      password = "",
      port = 4497
    ),
    regexp = cat("Assertion on',host,'failed: Must be provided.")
  )

  expect_error(
    connect_to_server(
      dbms = "MySQL",
      driver_name = "",
      host = c("mysql-rfam-public.ebi.ac.uk", "test"),
      database_name = "Rfam",
      user = "rfamro",
      password = "",
      port = 4497
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character
                 with length 1.")
  )
})

test_that("connect_to_server fails with incorrect database_name", {
  expect_error(
    connect_to_server(
      dbms = "MySQL",
      driver_name = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = NA,
      user = "rfamro",
      password = "",
      port = 4497
    ),
    regexp = cat("Assertion on',database_name,'failed: Missing value not
                 allowed for database_name name.")
  )

  expect_error(
    connect_to_server(
      dbms = "MySQL",
      driver_name = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = NULL,
      user = "rfamro",
      password = "",
      port = 4497
    ),
    regexp = cat("Assertion on',database_name,'failed: Must be provided.")
  )

  expect_error(
    connect_to_server(
      dbms = "MySQL",
      driver_name = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = c("Rfam", "test"),
      user = "rfamro",
      password = "",
      port = 4497
    ),
    regexp = cat("Assertion on',database_name,'failed: Must be of type character
                 with length 1.")
  )
})

test_that("connect_to_server fails with incorrect user", {
  expect_error(
    connect_to_server(
      dbms = "MySQL",
      driver_name = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = "Rfam",
      user = NA,
      password = "",
      port = 4497
    ),
    regexp = cat("Assertion on',user,'failed: Missing value not
                 allowed for user name.")
  )

  expect_error(
    connect_to_server(
      dbms = "MySQL",
      driver_name = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = "Rfam",
      user = NULL,
      password = "",
      port = 4497
    ),
    regexp = cat("Assertion on',user,'failed: Must be provided.")
  )

  expect_error(
    connect_to_server(
      dbms = "MySQL",
      driver_name = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = "Rfam",
      user = c("rfamro", "test"),
      password = "",
      port = 4497
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character
                 with length 1.")
  )
})

test_that("connect_to_server fails with incorrect password", {
  expect_error(
    connect_to_server(
      dbms = "MySQL",
      driver_name = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = "Rfam",
      user = "rfamro",
      password = NA,
      port = 4497
    ),
    regexp = cat("Assertion on',password,'failed: Missing value not
                 allowed for password name.")
  )

  expect_error(
    connect_to_server(
      dbms = "MySQL",
      driver_name = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = "Rfam",
      user = "rfamro",
      password = NULL,
      port = 4497
    ),
    regexp = cat("Assertion on',user,'failed: Must be provided.")
  )

  expect_error(
    connect_to_server(
      dbms = "MySQL",
      driver_name = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = "Rfam",
      user = "rfamro",
      password = c("", "pass"),
      port = 4497
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 with length 1.")
  )
})

test_that("connect_to_server fails with incorrect port", {
  expect_error(
    connect_to_server(
      dbms = "MySQL",
      driver_name = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = "Rfam",
      user = "rfamro",
      password = "",
      port = -4497
    ),
    regexp = cat("Assertion on',port,'failed: Negative value not
                 allowed for port name.")
  )

  expect_error(
    connect_to_server(
      dbms = "MySQL",
      driver_name = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = "Rfam",
      user = "rfamro",
      password = "",
      port = 0
    ),
    regexp = cat("Assertion on',port,'failed: Must be greater than or
                 equal to 1.")
  )
})

test_that("identify_table_name works as expected", {
  table_name <- identify_table_name(
    query = "select * from author",
    tables = c("family_author", "author", "test")
  )
  expect_type(table_name, "character")
})

test_that("identify_table_name fails with an incorrect query", {
  expect_error(
    identify_table_name(
      query = NA,
      tables = c("family_author", "author", "test")
    ),
    regexp = cat("Assertion on',query,'failed: Missing value not allowed for
                 query.")
  )

  expect_error(
    identify_table_name(
      query = NULL,
      tables = c("family_author", "author", "test")
    ),
    regexp = cat("Assertion on',query,'failed: Must be provided.")
  )

  expect_error(
    identify_table_name(
      query = c("select * from author", "select * from family_author"),
      tables = c("family_author", "author", "test")
    ),
    regexp = cat("Assertion on',query,'failed: Must be of type character with
                 length 1.")
  )
})

test_that("identify_table_name fails with incorrect tables", {
  expect_error(
    identify_table_name(
      query = "select * from author",
      tables = NA
    ),
    regexp = cat("Assertion on',tables,'failed: Missing value not allowed for
                 tables.")
  )

  expect_error(
    identify_table_name(
      query = "select * from author",
      tables = NULL
    ),
    regexp = cat("Assertion on',tables,'failed: Must be provided.")
  )
})

test_that("fetch_data_from_query works as expected", {
  result <- fetch_data_from_query(
    source = "select author_id, name, last_name from author",
    dbms = "MySQL",
    tables = c("family_author", "author"),
    driver_name = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    database_name = "Rfam",
    user = "rfamro",
    password = "",
    port = 4497
  )
  expect_type(result, "list")
})

test_that("sql_select_data works as expected", {
  result <- sql_select_data(
    table_names = "author",
    dbms = "MySQL",
    id_col_name = "author_id",
    fields = c("author_id", "name"),
    records = NULL,
    id_position = NULL,
    driver_name = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    database_name = "Rfam",
    user = "rfamro",
    password = "",
    port = 4497
    )
  expect_type(result, "list")
})

test_that("get_id_column_name works as expected", {
  result <- get_id_column_name(
    id_col_name = c("author_id", "rfam_acc"),
    j = 1,
    id_position = c(1, 1)
  )
  expect_type(result, "list")
})

test_that("sql_select_entire_dataset works as expected", {
  result <- sql_select_entire_dataset(
    table = "author",
    dbms = "MySQL",
    driver_name = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    database_name = "Rfam",
    user = "rfamro",
    password = "",
    port = 4497
  )
  expect_s3_class(result, "data.frame")
})

test_that("sql_select_records_and_fields works as expected", {
  result <- sql_select_records_and_fields(
      table = "author",
      record = c("1", "20", "50"),
      id_column_name = "author_id",
      field = c("author_id", "last_name"),
      id_pos = NULL,
      dbms = "MySQL",
      driver_name = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = "Rfam",
      user = "rfamro",
      password = "",
      port = 4497
  )
  expect_s3_class(result, "data.frame")
})

test_that("visualise_table works as expected", {
  result <- visualise_table(
    credentials_file <- system.file("extdata", "test.ini", package = "readepi"),
    source = "author",
    project_id = "Rfam",
    driver_name = ""
  )
  expect_s3_class(result, "data.frame")
})

test_that("sql_select_records_only works as expected", {
  result <- sql_select_records_only(
      table = "author",
      record = c("1", "20", "50"),
      id_column_name = NULL,
      id_pos = 1,
      dbms = "MySQL",
      driver_name = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = "Rfam",
      user = "rfamro",
      password = "",
      port = 4497
  )
  expect_s3_class(result, "data.frame")
})

test_that("sql_select_fields_only works as expected", {
  result <- sql_select_fields_only(
      table = "author",
      field = c("author_id", "name", "last_name"),
      dbms = "MySQL",
      driver_name = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = "Rfam",
      user = "rfamro",
      password = "",
      port = 4497
  )
  expect_s3_class(result, "data.frame")
})
