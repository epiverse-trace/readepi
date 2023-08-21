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
  expect_type(con, "environment")
})

test_that("identify_table_name works as expected", {
  table_name <- identify_table_name(
    query = "select * from author",
    tables = c("family_author", "author", "test")
  )
  expect_type(table_name, "character")
  expect_length(table_name, 1)
  expect_identical(table_name, "author")
})

test_that("identify_table_name fails with an incorrect query", {
  expect_error(
    identify_table_name(
      query = NA,
      tables = c("family_author", "author", "test")
    ),
    regexp = cat("Assertion on',query,'failed: Missing value not allowed for
                 the 'query' argument.")
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
                 the 'tables' argument.")
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
  expect_length(result, 1)
  expect_named(result, "author")
  expect_s3_class(result$author, "data.frame")
})

test_that("fetch_data_from_query fails with incorrect tables", {
  expect_error(
    fetch_data_from_query(
      source = "select author_id, name, last_name from author",
      dbms = "MySQL",
      tables = NA,
      driver_name = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = "Rfam",
      user = "rfamro",
      password = "",
      port = 4497
    ),
    regexp = cat("Assertion on',tables,'failed: Missing value not allowed for
                 the 'tables' argument.")
  )

  expect_error(
    fetch_data_from_query(
      source = "select author_id, name, last_name from author",
      dbms = "MySQL",
      tables = NULL,
      driver_name = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = "Rfam",
      user = "rfamro",
      password = "",
      port = 4497
    ),
    regexp = cat("Assertion on',tables,'failed: Must be provided.")
  )
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
  expect_length(result, 1)
  expect_named(result, "author")
  expect_s3_class(result$author, "data.frame")
})

test_that("sql_select_data fails with incorrect table_names", {
  expect_error(
    sql_select_data(
      table_names = NA,
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
    ),
    regexp = cat("Assertion on',tables,'failed: Missing value not allowed for
                 the 'tables' argument.")
  )

  expect_error(
    sql_select_data(
      table_names = NULL,
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
    ),
    regexp = cat("Assertion on',tables,'failed: Must be provided.")
  )
})

test_that("get_id_column_name works as expected", {
  result <- get_id_column_name(
    id_col_name = c("author_id", "rfam_acc"),
    j = 1,
    id_position = c(1, 1)
  )
  expect_type(result, "list")
  expect_length(result, 2)
  expect_type(result$id_column_name, "character")
  expect_type(result$id_pos, "character")
  expect_identical(result$id_column_name, "author_id")
  expect_identical(result$id_pos, "1")
})

test_that("sql_select_data fails with incorrect j", {
  expect_error(
    get_id_column_name(
      id_col_name = c("author_id", "rfam_acc"),
      j = NA,
      id_position = c(1, 1)
    ),
    regexp = cat("Assertion on',j,'failed: Missing value not allowed for
                 the 'j' argument.")
  )

  expect_error(
    get_id_column_name(
      id_col_name = c("author_id", "rfam_acc"),
      j = NULL,
      id_position = c(1, 1)
    ),
    regexp = cat("Assertion on',j,'failed: Must be provided.")
  )

  expect_error(
    get_id_column_name(
      id_col_name = c("author_id", "rfam_acc"),
      j = 1:2,
      id_position = c(1, 1)
    ),
    regexp = cat("Assertion on',j,'failed: Must be a numeric with length 1.")
  )
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

test_that("sql_select_entire_dataset fails with incorrect table", {
  expect_error(
    sql_select_entire_dataset(
      table = NA,
      dbms = "MySQL",
      driver_name = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = "Rfam",
      user = "rfamro",
      password = "",
      port = 4497
    ),
    regexp = cat("Assertion on',table,'failed: Missing value not allowed for
                 the 'table' argument.")
  )

  expect_error(
    sql_select_entire_dataset(
      table = NULL,
      dbms = "MySQL",
      driver_name = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = "Rfam",
      user = "rfamro",
      password = "",
      port = 4497
    ),
    regexp = cat("Assertion on',table,'failed: Must be provided.")
  )
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

test_that("sql_select_records_and_fields fails as expected", {
  expect_error(
    sql_select_records_and_fields(
      table = "author", record = c("1", "20", "50"),
      id_column_name = NA, field = c("author_id", "last_name"),
      id_pos = NULL, dbms = "MySQL", driver_name = "",
      host = "mysql-rfam-public.ebi.ac.uk", database_name = "Rfam",
      user = "rfamro", password = "", port = 4497
    ),
    regexp = cat("Assertion on',id_column_name,'failed: Missing value not
                 allowed for the 'id_column_name' argument.")
  )

  expect_error(
    sql_select_records_and_fields(
      table = "author", record = c("1", "20", "50"),
      id_column_name = c("author_id", "last_name", "author_id"),
      field = c("author_id", "last_name"), id_pos = NULL, dbms = "MySQL",
      driver_name = "", host = "mysql-rfam-public.ebi.ac.uk",
      database_name = "Rfam", user = "rfamro", password = "", port = 4497
    ),
    regexp = cat("Assertion on',id_column_name,'failed: Must be a character
                 vector of unique elements.")
  )

  expect_error(
    sql_select_records_and_fields(
      table          = "author",
      record         = c("1", "20", "50"),
      id_column_name = c("author_id", "last_name", "author_id"),
      field          = c("author_id", "last_name"),
      id_pos         = NA,
      dbms           = "MySQL",
      driver_name    = "",
      host           = "mysql-rfam-public.ebi.ac.uk",
      database_name  = "Rfam",
      user           = "rfamro",
      password       = "",
      port           = 4497
    ),
    regexp = cat("Assertion on',id_pos,'failed: Missing value not allowed
                 for the 'id_pos' argument.")
  )

  expect_error(
    sql_select_records_and_fields(
      table          = NA,
      record         = c("1", "20", "50"),
      id_column_name = c("author_id", "last_name", "author_id"),
      field          = c("author_id", "last_name"),
      id_pos         = NULL,
      dbms           = "MySQL",
      driver_name    = "",
      host           = "mysql-rfam-public.ebi.ac.uk",
      database_name  = "Rfam",
      user           = "rfamro",
      password       = "",
      port           = 4497
    ),
    regexp = cat("Assertion on',table,'failed: Missing value not allowed
                 for the 'table' argument.")
  )

  expect_error(
    sql_select_records_and_fields(
      table          = NULL,
      record         = c("1", "20", "50"),
      id_column_name = c("author_id", "last_name", "author_id"),
      field          = c("author_id", "last_name"),
      id_pos         = NULL,
      dbms           = "MySQL",
      driver_name    = "",
      host           = "mysql-rfam-public.ebi.ac.uk",
      database_name  = "Rfam",
      user           = "rfamro",
      password       = "",
      port           = 4497
    ),
    regexp = cat("Assertion on',table,'failed: Must be provided.")
  )
})

test_that("visualise_table works as expected", {
  result <- visualise_table(
    from             = "mysql-rfam-public.ebi.ac.uk",
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    source           = "author",
    driver_name      = ""
  )
  expect_s3_class(result, "data.frame")
})

test_that("sql_select_records_only works as expected", {
  result <- sql_select_records_only(
    table          = "author",
    record         = c("1", "20", "50"),
    id_column_name = NULL,
    id_pos         = 1,
    dbms           = "MySQL",
    driver_name    = "",
    host           = "mysql-rfam-public.ebi.ac.uk",
    database_name  = "Rfam",
    user           = "rfamro",
    password       = "",
    port           = 4497
  )
  expect_s3_class(result, "data.frame")
})

test_that("sql_select_fields_only works as expected", {
  result <- sql_select_fields_only(
    table         = "author",
    field         = c("author_id", "name", "last_name"),
    dbms          = "MySQL",
    driver_name   = "",
    host          = "mysql-rfam-public.ebi.ac.uk",
    database_name = "Rfam",
    user          = "rfamro",
    password      = "",
    port          = 4497
  )
  expect_s3_class(result, "data.frame")
})
