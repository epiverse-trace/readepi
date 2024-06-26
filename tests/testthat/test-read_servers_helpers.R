test_that("sql_connect_to_server works as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  con <- sql_connect_to_server(
    base_url      = "mysql-rfam-public.ebi.ac.uk",
    user_name     = "rfamro",
    password      = "",
    dbms          = "MySQL",
    driver_name   = "",
    database_name = "Rfam",
    port          = 4497L
  )
  expect_type(con, "environment")
})

test_that("sql_identify_table_name works as expected", {
  table_name <- sql_identify_table_name(
    query  = "select * from author",
    tables = c("family_author", "author", "test")
  )
  expect_type(table_name, "character")
  expect_length(table_name, 1L)
  expect_identical(table_name, "author")
})

test_that("sql_identify_table_name fails with an incorrect query", {
  expect_error(
    sql_identify_table_name(
      query  = NA,
      tables = c("family_author", "author", "test")
    ),
    regexp = cat("Assertion on',query,'failed: Missing value not allowed for
                 the 'query' argument.")
  )

  expect_error(
    sql_identify_table_name(
      query  = NULL,
      tables = c("family_author", "author", "test")
    ),
    regexp = cat("Assertion on',query,'failed: Must be provided.")
  )

  expect_error(
    sql_identify_table_name(
      query  = c("select * from author", "select * from family_author"),
      tables = c("family_author", "author", "test")
    ),
    regexp = cat("Assertion on',query,'failed: Must be of type character with
                 length 1.")
  )
})

test_that("sql_identify_table_name fails with incorrect tables", {
  expect_error(
    sql_identify_table_name(
      query  = "select * from author",
      tables = NA
    ),
    regexp = cat("Assertion on',tables,'failed: Missing value not allowed for
                 the 'tables' argument.")
  )

  expect_error(
    sql_identify_table_name(
      query  = "select * from author",
      tables = NULL
    ),
    regexp = cat("Assertion on',tables,'failed: Must be provided.")
  )
})

test_that("sql_sql_fetch_data_from_query works as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  result <- sql_fetch_data_from_query(
    src           = "select author_id, name, last_name from author",
    tables        = c("family_author", "author"),
    base_url      = "mysql-rfam-public.ebi.ac.uk",
    user_name     = "rfamro",
    password      = "",
    dbms          = "MySQL",
    driver_name   = "",
    database_name = "Rfam",
    port          = 4497L
  )
  expect_type(result, "list")
  expect_length(result, 1L)
  expect_named(result, "author")
  expect_s3_class(result[["author"]], "data.frame")
})

test_that("sql_fetch_data_from_query fails with incorrect tables", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  expect_error(
    sql_fetch_data_from_query(
      src           = "select author_id, name, last_name from author",
      tables        = NA,
      base_url      = "mysql-rfam-public.ebi.ac.uk",
      user_name     = "rfamro",
      password      = "",
      dbms          = "MySQL",
      driver_name   = "",
      database_name = "Rfam",
      port          = 4497L
    ),
    regexp = cat("Assertion on',tables,'failed: Missing value not allowed for
                 the 'tables' argument.")
  )

  expect_error(
    sql_fetch_data_from_query(
      src           = "select author_id, name, last_name from author",
      tables        = NULL,
      base_url      = "mysql-rfam-public.ebi.ac.uk",
      user_name     = "rfamro",
      password      = "",
      dbms          = "MySQL",
      driver_name   = "",
      database_name = "Rfam",
      port          = 4497L
    ),
    regexp = cat("Assertion on',tables,'failed: Must be provided.")
  )
})

test_that("sql_select_data works as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  result <- sql_select_data(
    table_names   = "author",
    base_url      = "mysql-rfam-public.ebi.ac.uk",
    user_name     = "rfamro",
    password      = "",
    dbms          = "MySQL",
    driver_name   = "",
    database_name = "Rfam",
    port          = 4497L,
    id_col_name   = "author_id",
    fields        = c("author_id", "name"),
    records       = NULL,
    id_position   = NULL
  )
  expect_type(result, "list")
  expect_length(result, 1L)
  expect_named(result, "author")
  expect_s3_class(result[["author"]], "data.frame")

  result <- sql_select_data(
    table_names   = c("author", "family_author"),
    base_url      = "mysql-rfam-public.ebi.ac.uk",
    user_name     = "rfamro",
    password      = "",
    dbms          = "MySQL",
    driver_name   = "",
    database_name = "Rfam",
    port          = 4497L,
    id_col_name   = "author_id",
    fields        = NULL,
    records       = c("1, 34, 15, 70, 118, 20", "RF00591,RF01420,RF01421"),
    id_position   = NULL
  )
  expect_type(result, "list")
  expect_length(result, 2L)
  expect_named(result, c("author", "family_author"))
  expect_s3_class(result[["author"]], "data.frame")
  expect_s3_class(result[["family_author"]], "data.frame")

  result <- sql_select_data(
    table_names   = c("author", "family_author"),
    base_url      = "mysql-rfam-public.ebi.ac.uk",
    user_name     = "rfamro",
    password      = "",
    dbms          = "MySQL",
    driver_name   = "",
    database_name = "Rfam",
    port          = 4497L,
    id_col_name   = NULL,
    fields        = c("author_id,name,last_name,initials",
                      "rfam_acc,author_id"),
    records       = c("1, 34, 15, 70, 118, 20", "RF00591,RF01420,RF01421"),
    id_position   = c(1L, 1L)
  )
  expect_type(result, "list")
  expect_length(result, 2L)
  expect_named(result, c("author", "family_author"))
  expect_s3_class(result[["author"]], "data.frame")
  expect_s3_class(result[["family_author"]], "data.frame")

  result <- sql_select_data(
    table_names   = c("author", "family_author"),
    base_url      = "mysql-rfam-public.ebi.ac.uk",
    user_name     = "rfamro",
    password      = "",
    dbms          = "MySQL",
    driver_name   = "",
    database_name = "Rfam",
    port          = 4497L,
    id_col_name   = "author_id",
    fields        = c("author_id,name,last_name,initials",
                      "rfam_acc,author_id"),
    records       = NULL,
    id_position   = NULL
  )
  expect_type(result, "list")
  expect_length(result, 2L)
  expect_named(result, c("author", "family_author"))
  expect_s3_class(result[["author"]], "data.frame")
  expect_s3_class(result[["family_author"]], "data.frame")
})

test_that("sql_select_data fails with incorrect table_names", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  expect_error(
    sql_select_data(
      table_names   = NA,
      base_url      = "mysql-rfam-public.ebi.ac.uk",
      user_name     = "rfamro",
      password      = "",
      dbms          = "MySQL",
      driver_name   = "",
      database_name = "Rfam",
      port          = 4497L,
      id_col_name   = "author_id",
      fields        = c("author_id", "name"),
      records       = NULL,
      id_position   = NULL
    ),
    regexp = cat("Assertion on',tables,'failed: Missing value not allowed for
                 the 'tables' argument.")
  )

  expect_error(
    sql_select_data(
      table_names   = NULL,
      base_url      = "mysql-rfam-public.ebi.ac.uk",
      user_name     = "rfamro",
      password      = "",
      dbms          = "MySQL",
      driver_name   = "",
      database_name = "Rfam",
      port          = 4497L,
      id_col_name   = "author_id",
      fields        = c("author_id", "name"),
      records       = NULL,
      id_position   = NULL
    ),
    regexp = cat("Assertion on',tables,'failed: Must be provided.")
  )
})

test_that("sql_get_id_column_name works as expected", {
  result <- sql_get_id_column_name(
    id_col_name = c("author_id", "rfam_acc"),
    j           = 1L,
    id_position = c(1L, 1L)
  )
  expect_type(result, "list")
  expect_length(result, 2L)
  expect_type(result[["id_column_name"]], "character")
  expect_type(result[["id_pos"]], "character")
  expect_identical(result[["id_column_name"]], "author_id")
  expect_identical(result[["id_pos"]], "1")
})

test_that("sql_get_id_column_name fails with incorrect j", {
  expect_error(
    sql_get_id_column_name(
      id_col_name = c("author_id", "rfam_acc"),
      j           = NA,
      id_position = c(1L, 1L)
    ),
    regexp = cat("Assertion on',j,'failed: Missing value not allowed for
                 the 'j' argument.")
  )

  expect_error(
    sql_get_id_column_name(
      id_col_name = c("author_id", "rfam_acc"),
      j           = NULL,
      id_position = c(1L, 1L)
    ),
    regexp = cat("Assertion on',j,'failed: Must be provided.")
  )

  expect_error(
    sql_get_id_column_name(
      id_col_name = c("author_id", "rfam_acc"),
      j           = 1L:2L,
      id_position = c(1L, 1L)
    ),
    regexp = cat("Assertion on',j,'failed: Must be a numeric with length 1.")
  )
})

test_that("sql_select_entire_dataset works as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  result <- sql_select_entire_dataset(
    table         = "author",
    base_url      = "mysql-rfam-public.ebi.ac.uk",
    user_name     = "rfamro",
    password      = "",
    dbms          = "MySQL",
    driver_name   = "",
    database_name = "Rfam",
    port          = 4497L
  )
  expect_s3_class(result, "data.frame")
})

test_that("sql_select_entire_dataset fails with incorrect table", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  expect_error(
    sql_select_entire_dataset(
      table         = NA,
      base_url      = "mysql-rfam-public.ebi.ac.uk",
      user_name     = "rfamro",
      password      = "",
      dbms          = "MySQL",
      driver_name   = "",
      database_name = "Rfam",
      port          = 4497L
    ),
    regexp = cat("Assertion on',table,'failed: Missing value not allowed for
                 the 'table' argument.")
  )

  expect_error(
    sql_select_entire_dataset(
      table         = NULL,
      base_url      = "mysql-rfam-public.ebi.ac.uk",
      user_name     = "rfamro",
      password      = "",
      dbms          = "MySQL",
      driver_name   = "",
      database_name = "Rfam",
      port          = 4497L
    ),
    regexp = cat("Assertion on',table,'failed: Must be provided.")
  )
})

test_that("sql_select_records_and_fields works as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  result <- sql_select_records_and_fields(
    table          = "author",
    base_url       = "mysql-rfam-public.ebi.ac.uk",
    user_name      = "rfamro",
    password       = "",
    dbms           = "MySQL",
    driver_name    = "",
    database_name  = "Rfam",
    port           = 4497L,
    record         = c("1", "20", "50"),
    id_column_name = "author_id",
    field          = c("author_id", "last_name"),
    id_pos         = NULL
  )
  expect_s3_class(result, "data.frame")
})

test_that("sql_select_records_and_fields fails as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  expect_error(
    sql_select_records_and_fields(
      table          = "author",
      base_url           = "mysql-rfam-public.ebi.ac.uk",
      user_name      = "rfamro",
      password       = "",
      dbms           = "MySQL",
      driver_name    = "",
      database_name  = "Rfam",
      port           = 4497L,
      record         = c("1", "20", "50"),
      id_column_name = NA,
      field          = c("author_id", "last_name"),
      id_pos         = NULL
    ),
    regexp = cat("Assertion on',id_column_name,'failed: Missing value not
                 allowed for the 'id_column_name' argument.")
  )

  expect_error(
    sql_select_records_and_fields(
      table          = "author",
      base_url       = "mysql-rfam-public.ebi.ac.uk",
      user_name      = "rfamro",
      password       = "",
      dbms           = "MySQL",
      driver_name    = "",
      database_name  = "Rfam",
      port           = 4497L,
      record         = c("1", "20", "50"),
      id_column_name = c("author_id", "last_name", "author_id"),
      field          = c("author_id", "last_name"),
      id_pos         = NULL
    ),
    regexp = cat("Assertion on',id_column_name,'failed: Must be a character
                 vector of unique elements.")
  )

  expect_error(
    sql_select_records_and_fields(
      table          = "author",
      base_url       = "mysql-rfam-public.ebi.ac.uk",
      user_name      = "rfamro",
      password       = "",
      dbms           = "MySQL",
      driver_name    = "",
      database_name  = "Rfam",
      port           = 4497L,
      record         = c("1", "20", "50"),
      id_column_name = c("author_id", "last_name", "author_id"),
      field          = c("author_id", "last_name"),
      id_pos         = NA
    ),
    regexp = cat("Assertion on',id_pos,'failed: Missing value not allowed
                 for the 'id_pos' argument.")
  )

  expect_error(
    sql_select_records_and_fields(
      table          = NA,
      base_url       = "mysql-rfam-public.ebi.ac.uk",
      user_name      = "rfamro",
      password       = "",
      dbms           = "MySQL",
      driver_name    = "",
      database_name  = "Rfam",
      port           = 4497L,
      record         = c("1", "20", "50"),
      id_column_name = c("author_id", "last_name", "author_id"),
      field          = c("author_id", "last_name"),
      id_pos         = NULL
    ),
    regexp = cat("Assertion on',table,'failed: Missing value not allowed
                 for the 'table' argument.")
  )

  expect_error(
    sql_select_records_and_fields(
      table          = NULL,
      base_url       = "mysql-rfam-public.ebi.ac.uk",
      user_name      = "rfamro",
      password       = "",
      dbms           = "MySQL",
      driver_name    = "",
      database_name  = "Rfam",
      port           = 4497L,
      record         = c("1", "20", "50"),
      id_column_name = c("author_id", "last_name", "author_id"),
      field          = c("author_id", "last_name"),
      id_pos         = NULL
    ),
    regexp = cat("Assertion on',table,'failed: Must be provided.")
  )
})

test_that("visualise_table works as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  result <- visualise_table(
    data_source      = "mysql-rfam-public.ebi.ac.uk",
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    from             = "author",
    driver_name      = ""
  )
  expect_s3_class(result, "data.frame")
})

test_that("sql_select_records_only works as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  result <- sql_select_records_only(
    table          = "author",
    base_url       = "mysql-rfam-public.ebi.ac.uk",
    user_name      = "rfamro",
    password       = "",
    dbms           = "MySQL",
    driver_name    = "",
    database_name  = "Rfam",
    port           = 4497L,
    record         = c("1", "20", "50"),
    id_column_name = NULL,
    id_pos         = 1L
  )
  expect_s3_class(result, "data.frame")
})

test_that("sql_select_fields_only works as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  result <- sql_select_fields_only(
    table         = "author",
    base_url      = "mysql-rfam-public.ebi.ac.uk",
    user_name     = "rfamro",
    password      = "",
    dbms          = "MySQL",
    driver_name   = "",
    database_name = "Rfam",
    port          = 4497L,
    field         = c("author_id", "name", "last_name")
  )
  expect_s3_class(result, "data.frame")
})

test_that("sql_identify_table_and_query works as expected", {
  test <- sql_identify_table_and_query(
    src    = "select * from author",
    tables = c("karim", "author", "reviewer")
  )
  expect_type(test, "list")
  expect_length(test, 2L)
  expect_named(test, c("queries", "tables"))
  expect_type(test[["queries"]], "character")
  expect_null(test[["tables"]])
})

test_that("sql_identify_table_and_query works as expected", {
  test <- sql_identify_table_and_query(
    src    = "author",
    tables = c("karim", "author", "reviewer")
  )
  expect_type(test, "list")
  expect_length(test, 2L)
  expect_named(test, c("queries", "tables"))
  expect_null(test[["queries"]])
  expect_type(test[["tables"]], "character")
})
