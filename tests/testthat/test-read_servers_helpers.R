test_that("connect_to_server works as expected", {
  con <- connect_to_server(
    dbms = "MySQL",
    driver_name = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    database_name = "Rfam",
    user = "rfamro",
    password = "",
<<<<<<< HEAD
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
=======
    port = 4497L
  )
  expect_type(con, "environment")
>>>>>>> review
})

test_that("identify_table_name works as expected", {
  table_name <- identify_table_name(
    query = "select * from author",
    tables = c("family_author", "author", "test")
  )
  expect_type(table_name, "character")
<<<<<<< HEAD
=======
  expect_length(table_name, 1L)
  expect_identical(table_name, "author")
>>>>>>> review
})

test_that("identify_table_name fails with an incorrect query", {
  expect_error(
    identify_table_name(
      query = NA,
      tables = c("family_author", "author", "test")
    ),
    regexp = cat("Assertion on',query,'failed: Missing value not allowed for
<<<<<<< HEAD
                 query.")
=======
                 the 'query' argument.")
>>>>>>> review
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
<<<<<<< HEAD
                 tables.")
=======
                 the 'tables' argument.")
>>>>>>> review
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
<<<<<<< HEAD
    port = 4497
  )
  expect_type(result, "list")
=======
    port = 4497L
  )
  expect_type(result, "list")
  expect_length(result, 1L)
  expect_named(result, "author")
  expect_s3_class(result[["author"]], "data.frame")
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
      port = 4497L
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
      port = 4497L
    ),
    regexp = cat("Assertion on',tables,'failed: Must be provided.")
  )
>>>>>>> review
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
<<<<<<< HEAD
    port = 4497
    )
  expect_type(result, "list")
=======
    port = 4497L
  )
  expect_type(result, "list")
  expect_length(result, 1L)
  expect_named(result, "author")
  expect_s3_class(result[["author"]], "data.frame")

  result <- sql_select_data(
    table_names   = c("author", "family_author"),
    dbms          = "MySQL",
    id_col_name   = "author_id",
    fields        = NULL,
    records       = c("1, 34, 15, 70, 118, 20", "RF00591,RF01420,RF01421"),
    id_position   = NULL,
    driver_name   = "",
    host          = "mysql-rfam-public.ebi.ac.uk",
    database_name = "Rfam",
    user          = "rfamro",
    password      = "",
    port          = 4497L
  )
  expect_type(result, "list")
  expect_length(result, 2L)
  expect_named(result, c("author", "family_author"))
  expect_s3_class(result[["author"]], "data.frame")
  expect_s3_class(result[["family_author"]], "data.frame")

  result <- sql_select_data(
    table_names = c("author", "family_author"),
    dbms = "MySQL",
    id_position = c(1, 1), # nolint
    fields = c("author_id,name,last_name,initials", "rfam_acc,author_id"),
    records = c("1, 34, 15, 70, 118, 20", "RF00591,RF01420,RF01421"),
    driver_name = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    database_name = "Rfam",
    user = "rfamro",
    password = "",
    port = 4497L,
    id_col_name = NULL
  )
  expect_type(result, "list")
  expect_length(result, 2L)
  expect_named(result, c("author", "family_author"))
  expect_s3_class(result[["author"]], "data.frame")
  expect_s3_class(result[["family_author"]], "data.frame")

  result <- sql_select_data(
    table_names = c("author", "family_author"),
    dbms = "MySQL",
    id_col_name = "author_id",
    fields = c("author_id,name,last_name,initials", "rfam_acc,author_id"),
    records = NULL,
    id_position = NULL,
    driver_name = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    database_name = "Rfam",
    user = "rfamro",
    password = "",
    port = 4497L
  )
  expect_type(result, "list")
  expect_length(result, 2L)
  expect_named(result, c("author", "family_author"))
  expect_s3_class(result[["author"]], "data.frame")
  expect_s3_class(result[["family_author"]], "data.frame")
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
      port = 4497L
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
      port = 4497L
    ),
    regexp = cat("Assertion on',tables,'failed: Must be provided.")
  )
>>>>>>> review
})

test_that("get_id_column_name works as expected", {
  result <- get_id_column_name(
    id_col_name = c("author_id", "rfam_acc"),
<<<<<<< HEAD
    j = 1,
    id_position = c(1, 1)
  )
  expect_type(result, "list")
=======
    j = 1L,
    id_position = c(1, 1) # nolint
  )
  expect_type(result, "list")
  expect_length(result, 2L)
  expect_type(result[["id_column_name"]], "character")
  expect_type(result[["id_pos"]], "character")
  expect_identical(result[["id_column_name"]], "author_id")
  expect_identical(result[["id_pos"]], "1")
})

test_that("sql_select_data fails with incorrect j", {
  expect_error(
    get_id_column_name(
      id_col_name = c("author_id", "rfam_acc"),
      j = NA,
      id_position = c(1, 1) # nolint
    ),
    regexp = cat("Assertion on',j,'failed: Missing value not allowed for
                 the 'j' argument.")
  )

  expect_error(
    get_id_column_name(
      id_col_name = c("author_id", "rfam_acc"),
      j = NULL,
      id_position = c(1, 1) # nolint
    ),
    regexp = cat("Assertion on',j,'failed: Must be provided.")
  )

  expect_error(
    get_id_column_name(
      id_col_name = c("author_id", "rfam_acc"),
      j = 1:2, # nolint
      id_position = c(1, 1) # nolint
    ),
    regexp = cat("Assertion on',j,'failed: Must be a numeric with length 1.")
  )
>>>>>>> review
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
<<<<<<< HEAD
    port = 4497
=======
    port = 4497L
>>>>>>> review
  )
  expect_s3_class(result, "data.frame")
})

<<<<<<< HEAD
test_that("sql_select_records_and_fields works as expected", {
  result <- sql_select_records_and_fields(
      table = "author",
      record = c("1", "20", "50"),
      id_column_name = "author_id",
      field = c("author_id", "last_name"),
      id_pos = NULL,
=======
test_that("sql_select_entire_dataset fails with incorrect table", {
  expect_error(
    sql_select_entire_dataset(
      table = NA,
>>>>>>> review
      dbms = "MySQL",
      driver_name = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = "Rfam",
      user = "rfamro",
      password = "",
<<<<<<< HEAD
      port = 4497
=======
      port = 4497L
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
      port = 4497L
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
    port = 4497L
>>>>>>> review
  )
  expect_s3_class(result, "data.frame")
})

<<<<<<< HEAD
test_that("visualise_table works as expected", {
  result <- visualise_table(
    credentials_file <- system.file("extdata", "test.ini", package = "readepi"),
    source = "author",
    project_id = "Rfam",
    driver_name = ""
=======
test_that("sql_select_records_and_fields fails as expected", {
  expect_error(
    sql_select_records_and_fields(
      table = "author", record = c("1", "20", "50"),
      id_column_name = NA, field = c("author_id", "last_name"),
      id_pos = NULL, dbms = "MySQL", driver_name = "",
      host = "mysql-rfam-public.ebi.ac.uk", database_name = "Rfam",
      user = "rfamro", password = "", port = 4497L
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
      database_name = "Rfam", user = "rfamro", password = "", port = 4497L
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
      port           = 4497L
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
      port           = 4497L
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
      port           = 4497L
    ),
    regexp = cat("Assertion on',table,'failed: Must be provided.")
  )
})

test_that("visualise_table works as expected", {
  result <- visualise_table(
    data_source      = "mysql-rfam-public.ebi.ac.uk",
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    from             = "author",
    driver_name      = ""
>>>>>>> review
  )
  expect_s3_class(result, "data.frame")
})

test_that("sql_select_records_only works as expected", {
  result <- sql_select_records_only(
<<<<<<< HEAD
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
=======
    table          = "author",
    record         = c("1", "20", "50"),
    id_column_name = NULL,
    id_pos         = 1L,
    dbms           = "MySQL",
    driver_name    = "",
    host           = "mysql-rfam-public.ebi.ac.uk",
    database_name  = "Rfam",
    user           = "rfamro",
    password       = "",
    port           = 4497L
>>>>>>> review
  )
  expect_s3_class(result, "data.frame")
})

test_that("sql_select_fields_only works as expected", {
  result <- sql_select_fields_only(
<<<<<<< HEAD
      table = "author",
      field = c("author_id", "name", "last_name"),
      dbms = "MySQL",
      driver_name = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      database_name = "Rfam",
      user = "rfamro",
      password = "",
      port = 4497
=======
    table         = "author",
    field         = c("author_id", "name", "last_name"),
    dbms          = "MySQL",
    driver_name   = "",
    host          = "mysql-rfam-public.ebi.ac.uk",
    database_name = "Rfam",
    user          = "rfamro",
    password      = "",
    port          = 4497L
>>>>>>> review
  )
  expect_s3_class(result, "data.frame")
})
