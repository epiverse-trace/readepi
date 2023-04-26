test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "rfamro",
    password = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    port = 4497,
    database_name = "Rfam",
    driver_name = "",
    table_names = "author",
    records = "1,34,15,70,118,20",
    fields = "author_id,name,last_name,initials",
    id_position = 1,
    id_col_name = NULL,
    dbms = "MySQL"
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "rfamro",
    password = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    port = 4497,
    database_name = "Rfam",
    driver_name = "",
    table_names = "author",
    records = "1,34,15,70,118,20",
    fields = "author_id,name,last_name,initials",
    id_position = NULL,
    id_col_name = "author_id",
    dbms = "MySQL"
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "rfamro",
    password = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    port = 4497,
    database_name = "Rfam",
    driver_name = "",
    table_names = "author",
    records = NULL,
    fields = "author_id,name,last_name,initials",
    id_position = NULL,
    id_col_name = NULL,
    dbms = "MySQL"
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "rfamro",
    password = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    port = 4497,
    database_name = "Rfam",
    driver_name = "",
    table_names = "author",
    records = NULL,
    fields = NULL,
    id_position = NULL,
    id_col_name = NULL,
    dbms = "MySQL"
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "rfamro",
    password = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    port = 4497,
    database_name = "Rfam",
    driver_name = "",
    table_names = "author",
    records = "1,34,15,70,118,20",
    fields = NULL,
    id_position = NULL,
    id_col_name = "author_id",
    dbms = "MySQL"
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "rfamro",
    password = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    port = 4497,
    database_name = "Rfam",
    driver_name = "",
    table_names = "author",
    records = "1,34,15,70,118,20",
    fields = NULL,
    id_position = 1,
    id_col_name = NULL,
    dbms = "MySQL"
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "rfamro",
    password = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    port = 4497,
    database_name = "Rfam",
    driver_name = "",
    table_names = "author",
    records = c("1", "34", "15", "70", "118", "20"),
    fields = c("author_id", "name", "last_name", "initials"),
    id_position = 1,
    id_col_name = NULL,
    dbms = "MySQL"
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "rfamro",
    password = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    port = 4497,
    database_name = "Rfam",
    driver_name = "",
    table_names = "author",
    records = c("1", "34", "15", "70", "118", "20"),
    fields = c("author_id", "name", "last_name", "initials"),
    id_position = NULL,
    id_col_name = "author_id",
    dbms = "MySQL"
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "rfamro",
    password = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    port = 4497,
    database_name = "Rfam",
    driver_name = "",
    table_names = "author",
    records = "1, 34, 15, 70, 118, 20",
    fields = "author_id, name, last_name, initials",
    id_position = 1,
    id_col_name = NULL,
    dbms = "MySQL"
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "rfamro",
    password = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    port = 4497,
    database_name = "Rfam",
    driver_name = "",
    table_names = "author",
    records = "1, 34, 15, 70, 118, 20",
    fields = "author_id, name, last_name, initials",
    id_position = NULL,
    id_col_name = "author_id",
    dbms = "MySQL"
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "rfamro",
    password = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    port = 4497,
    database_name = "Rfam",
    driver_name = "",
    table_names = "author,family_author",
    records = NULL,
    fields = NULL,
    id_position = NULL,
    id_col_name = NULL,
    dbms = "MySQL"
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "rfamro",
    password = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    port = 4497,
    database_name = "Rfam",
    driver_name = "",
    table_names = "author,family_author",
    records = NULL,
    fields = c("author_id,name,last_name,initials", "rfam_acc,author_id"),
    id_position = NULL,
    id_col_name = NULL,
    dbms = "MySQL"
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "rfamro",
    password = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    port = 4497,
    database_name = "Rfam",
    driver_name = "",
    table_names = "author,family_author",
    records = c(
      "1,34,15,70,118,20",
      "RF00520,RF00592,RF01421,RF01527"
    ),
    fields = NULL,
    id_position = c(1, 1),
    id_col_name = NULL,
    dbms = "MySQL"
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "rfamro",
    password = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    port = 4497,
    database_name = "Rfam",
    driver_name = "",
    table_names = "author,family_author",
    records = c(
      "1,34,15,70,118,20",
      "RF00520,RF00592,RF01421,RF01527"
    ),
    fields = NULL,
    id_position = NULL,
    id_col_name = c("author_id", "rfam_acc"),
    dbms = "MySQL"
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "rfamro",
    password = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    port = 4497,
    database_name = "Rfam",
    driver_name = "",
    table_names = "author,family_author",
    records = c(
      "1,34,15,70,118,20",
      "RF00520,RF00592,RF01421,RF01527"
    ),
    fields = c(
      "author_id,name,last_name,initials",
      "rfam_acc", "author_id"
    ),
    id_position = c(1, 1),
    id_col_name = NULL,
    dbms = "MySQL"
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "rfamro",
    password = "",
    host = "mysql-rfam-public.ebi.ac.uk",
    port = 4497,
    database_name = "Rfam",
    driver_name = "",
    table_names = "author,family_author",
    records = c(
      "1,34,15,70,118,20",
      "RF00520,RF00592,RF01421,RF01527"
    ),
    fields = c(
      "author_id,name,last_name,initials",
      "rfam_acc", "author_id"
    ),
    id_position = NULL,
    id_col_name = c("author_id", "rfam_acc"),
    dbms = "MySQL"
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server fails with port of type character", {
  expect_error(
    res <- read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = "4497",
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric',
                 not 'character'.")
  )

  expect_error(
    res <- read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = "4497",
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = 1,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric',
                 not 'character'.")
  )

  expect_error(
    res <- read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = "4497",
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = NULL,
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric',
                 not 'character'.")
  )

  expect_error(
    res <- read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = "4497",
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = 1,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric',
                 not 'character'.")
  )

  expect_error(
    res <- read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = "4497",
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric',
                 not 'character'.")
  )

  expect_error(
    res <- read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = "4497",
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric',
                 not 'character'.")
  )
})

test_that("read_from_ms_sql_server fails with port of type character", {
  expect_error(
    res <- read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = "4497",
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = 1,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric',
                 not 'character'.")
  )

  expect_error(
    res <- read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = "4497",
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric',
                 not 'character'.")
  )

  expect_error(
    res <- read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = "4497",
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = NULL,
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric',
                 not 'character'.")
  )

  expect_error(
    res <- read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = "4497",
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = 1,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric',
                 not 'character'.")
  )

  expect_error(
    res <- read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = "4497",
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric',
                 not 'character'.")
  )

  expect_error(
    res <- read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = "4497",
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric',
                 not 'character'.")
  )
})

test_that("read_from_ms_sql_server fails with port of type character", {
  expect_error(
    res <- read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = "4497",
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric',
                 not 'character'.")
  )

  expect_error(
    res <- read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = "4497",
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = 1,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric',
                 not 'character'.")
  )

  expect_error(
    res <- read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = "4497",
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = 1,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric',
                 not 'character'.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = "4497",
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric',
                 not 'character'.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = "4497",
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric',
                 not 'character'.")
  )
})

test_that("read_from_ms_sql_server fails with negative port", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = -4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = -4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = -4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = -4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = -4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = -4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = NULL,
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )
})

test_that("read_from_ms_sql_server fails with negative port", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = -4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = -4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = -4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "rfamro",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = -4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = -4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = -4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = NULL,
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )
})

test_that("read_from_ms_sql_server fails with negative port", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = -4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = -4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = -4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = -4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = -4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = -4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = NULL,
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )
})

test_that("read_from_ms_sql_server fails with invalid id_position", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = -5,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',id_position,'failed: Negative column number
                 not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = -5,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',id_position,'failed: Negative column number
                 not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = -5,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',id_position,'failed: Negative column number
                 not allowed.")
  )
})

test_that("read_from_ms_sql_server fails with invalid id_position", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = -5,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',id_position,'failed: Negative column number
                 not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = -5,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',id_position,'failed: Negative column number
                 not allowed.")
  )
})

test_that("read_from_ms_sql_server fails with invalid id_position", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = -5,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',id_position,'failed: Negative column number
                 not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = -5,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',id_position,'failed: Negative column number
                 not allowed.")
  )
})

test_that("read_from_ms_sql_server fails with invalid id_position", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = NA,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',id_position,'failed: Missing values
                 not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = NA,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',id_position,'failed: Missing values
                 not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = NA,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',id_position,'failed: Missing values
                 not allowed.")
  )
})

test_that("read_from_ms_sql_server fails with invalid id_position", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = NA,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',id_position,'failed: Missing values
                 not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = NA,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',id_position,'failed: Missing values
                 not allowed.")
  )
})

test_that("read_from_ms_sql_server fails with invalid id_position", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NA,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',id_position,'failed: Missing values
                 not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = NA,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',id_position,'failed: Missing values
                 not allowed.")
  )
})

# user name not null
test_that("read_from_ms_sql_server fails with bad user name", {
  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = NULL,
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = 5,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )
})

test_that("read_from_ms_sql_server fails with bad user name", {
  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )
})

test_that("read_from_ms_sql_server fails with bad user name", {
  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )
})

# user name not missing
test_that("read_from_ms_sql_server fails with bad user name", {
  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = NULL,
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = 5,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )
})

test_that("read_from_ms_sql_server fails with bad user name", {
  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )
})

test_that("read_from_ms_sql_server fails with bad user name", {
  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )
})

# user name should be of length 1
test_that("read_from_ms_sql_server fails with bad user name", {
  expect_error(
    read_from_ms_sql_server(
      user = c("rfamro", "trace"),
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = NULL,
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("rfamro", "trace"),
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("rfamro", "trace"),
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("rfamro", "trace"),
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("rfamro", "trace"),
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("rfamro", "trace"),
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = 5,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character
                 of length 1.")
  )
})

test_that("read_from_ms_sql_server fails with bad user name", {
  expect_error(
    read_from_ms_sql_server(
      user = c("rfamro", "trace"),
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("rfamro", "trace"),
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("rfamro", "trace"),
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("rfamro", "trace"),
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("rfamro", "trace"),
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character
                 of length 1.")
  )
})

test_that("read_from_ms_sql_server fails with bad user name", {
  expect_error(
    read_from_ms_sql_server(
      user = c("rfamro", "trace"),
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("rfamro", "trace"),
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("rfamro", "trace"),
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("rfamro", "trace"),
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("rfamro", "trace"),
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character
                 of length 1.")
  )
})









# password not null
test_that("read_from_ms_sql_server fails with incorrect password", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NULL,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = NULL,
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NULL,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NULL,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NULL,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NULL,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NULL,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = 5,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect password", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NULL,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NULL,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NULL,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NULL,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NULL,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect password", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NULL,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NULL,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NULL,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NULL,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NULL,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )
})

# user name not missing
test_that("read_from_ms_sql_server fails with incorrect password", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NA,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = NULL,
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NA,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NA,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NA,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NA,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NA,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = 5,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect password", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NA,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NA,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NA,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NA,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NA,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect password", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NA,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NA,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NA,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NA,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = NA,
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's
                 password.")
  )
})

# user name should be of length 1
test_that("read_from_ms_sql_server fails with incorrect password", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = c("rfamro", "trace"),
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = NULL,
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = c("rfamro", "trace"),
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = c("rfamro", "trace"),
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = c("rfamro", "trace"),
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = c("rfamro", "trace"),
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = c("rfamro", "trace"),
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = 5,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character of
                 length 1.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect password", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = c("rfamro", "trace"),
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = c("rfamro", "trace"),
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = c("rfamro", "trace"),
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = c("rfamro", "trace"),
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = c("rfamro", "trace"),
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 of length 1.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect password", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = c("rfamro", "trace"),
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = c("rfamro", "trace"),
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = c("rfamro", "trace"),
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = c("rfamro", "trace"),
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = c("rfamro", "trace"),
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 of length 1.")
  )
})













# host not null
test_that("read_from_ms_sql_server fails with incorrect host name", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NULL,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = NULL,
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NULL,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NULL,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NULL,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NULL,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = 5,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect host name", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NULL,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NULL,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NULL,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NULL,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NULL,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect host name", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NULL,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NULL,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NULL,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NULL,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NULL,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )
})

# user name not missing
test_that("read_from_ms_sql_server fails with incorrect password", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NA,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = NULL,
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NA,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NA,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NA,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NA,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NA,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = 5,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect host name", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NA,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NA,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NA,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NA,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NA,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect host name", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NA,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NA,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NA,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NA,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = NA,
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )
})

# host name should be of length 1
test_that("read_from_ms_sql_server fails with incorrect host name", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = c("mysql-rfam-public.ebi.ac.uk", "172.23.33.90"),
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = NULL,
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character of
                 length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "mysql-rfam-public.ebi.ac.uk",
      host = c("mysql-rfam-public.ebi.ac.uk", "172.23.33.90"),
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = c("mysql-rfam-public.ebi.ac.uk", "172.23.33.90"),
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = c("mysql-rfam-public.ebi.ac.uk", "172.23.33.90"),
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = c("mysql-rfam-public.ebi.ac.uk", "172.23.33.90"),
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = c("mysql-rfam-public.ebi.ac.uk", "172.23.33.90"),
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = 5,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character
                 of length 1.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect password", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = c("mysql-rfam-public.ebi.ac.uk", "172.23.33.90"),
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = c("mysql-rfam-public.ebi.ac.uk", "172.23.33.90"),
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = c("mysql-rfam-public.ebi.ac.uk", "172.23.33.90"),
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = c("mysql-rfam-public.ebi.ac.uk", "172.23.33.90"),
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = c("mysql-rfam-public.ebi.ac.uk", "172.23.33.90"),
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character
                 of length 1.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect host", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = c("mysql-rfam-public.ebi.ac.uk", "172.23.33.90"),
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = c("mysql-rfam-public.ebi.ac.uk", "172.23.33.90"),
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = c("mysql-rfam-public.ebi.ac.uk", "172.23.33.90"),
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = c("mysql-rfam-public.ebi.ac.uk", "172.23.33.90"),
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = c("mysql-rfam-public.ebi.ac.uk", "172.23.33.90"),
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character
                 of length 1.")
  )
})











# MS driver name not null
test_that("read_from_ms_sql_server fails with incorrect driver name", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NULL,
      table_names = "author",
      records = NULL,
      fields = NULL,
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NULL,
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NULL,
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NULL,
      table_names = "author",
      records = NULL,
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NULL,
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = 5,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect host name", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NULL,
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NULL,
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NULL,
      table_names = "author",
      records = NULL,
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NULL,
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NULL,
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect host name", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NULL,
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NULL,
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NULL,
      table_names = "author",
      records = NULL,
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NULL,
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NULL,
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )
})

# driver name not missing
test_that("read_from_ms_sql_server fails with missing MS SQL driver name", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NA,
      table_names = "author",
      records = NULL,
      fields = NULL,
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NA,
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NA,
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NA,
      table_names = "author",
      records = NULL,
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NA,
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NA,
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = 5,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect host name", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NA,
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NA,
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NA,
      table_names = "author",
      records = NULL,
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NA,
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NA,
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect MS SQL driver name", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NA,
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NA,
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NA,
      table_names = "author",
      records = NULL,
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NA,
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = NA,
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must provide MS SQL
                 driver name.")
  )
})

# driver name should be of length 1
test_that("read_from_ms_sql_server fails with incorrect MS SQL driver name", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = c("", "ODBC Driver 18 for SQL Server"),
      table_names = "author",
      records = NULL,
      fields = NULL,
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = c("", "ODBC Driver 18 for SQL Server"),
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = c("", "ODBC Driver 18 for SQL Server"),
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = c("", "ODBC Driver 18 for SQL Server"),
      table_names = "author",
      records = NULL,
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = c("", "ODBC Driver 18 for SQL Server"),
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = c("", "ODBC Driver 18 for SQL Server"),
      table_names = "author",
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = 5,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must be of type character
                 of length 1.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect MS SQL driver name", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = c("", "ODBC Driver 18 for SQL Server"),
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = c("", "ODBC Driver 18 for SQL Server"),
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = c("", "ODBC Driver 18 for SQL Server"),
      table_names = "author",
      records = NULL,
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = c("", "ODBC Driver 18 for SQL Server"),
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = c("", "ODBC Driver 18 for SQL Server"),
      table_names = "author",
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',driver_name,'failed: Must be of type character
                 of length 1.")
  )
})




























test_that("read_from_ms_sql_server fails with incorrect password", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = c("mysql-rfam-public.ebi.ac.uk", "172.23.33.90"),
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = c("mysql-rfam-public.ebi.ac.uk", "172.23.33.90"),
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = c("mysql-rfam-public.ebi.ac.uk", "172.23.33.90"),
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = NULL,
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = c("mysql-rfam-public.ebi.ac.uk", "172.23.33.90"),
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = c("mysql-rfam-public.ebi.ac.uk", "172.23.33.90"),
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = "author",
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character
                 of length 1.")
  )
})








# driver name not missing
test_that("read_from_ms_sql_server fails with missing MS SQL driver name", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = NA,
      records = NULL,
      fields = NULL,
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',table_names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = NA,
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',table_names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = NA,
      records = c("1", "34", "15", "70", "118", "20"),
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',table_names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = NA,
      records = NULL,
      fields = c("author_id", "name", "last_name", "initials"),
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',table_names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = NA,
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',table_names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = NA,
      records = c("1", "34", "15", "70", "118", "20"),
      fields = NULL,
      id_position = 5,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',table_names,'failed: Must provide table name.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect host name", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = NA,
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',table_names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = NA,
      records = "1,34,15,70,118,20",
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',table_names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = NA,
      records = NULL,
      fields = "author_id,name,last_name,initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',table_names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = NA,
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',table_names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = NA,
      records = "1,34,15,70,118,20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',table_names,'failed: Must provide table name.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect MS SQL driver name", {
  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = NA,
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',table_names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = NA,
      records = "1, 34, 15, 70, 118, 20",
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',table_names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = NA,
      records = NULL,
      fields = "author_id, name, last_name, initials",
      id_position = NULL,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',table_names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = NA,
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = NULL,
      id_col_name = "author_id",
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',table_names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "rfamro",
      password = "",
      host = "mysql-rfam-public.ebi.ac.uk",
      port = 4497,
      database_name = "Rfam",
      driver_name = "",
      table_names = NA,
      records = "1, 34, 15, 70, 118, 20",
      fields = NULL,
      id_position = 5,
      id_col_name = NULL,
      dbms = "MySQL"
    ),
    regexp = cat("Assertion on',table_names,'failed: Must provide table name.")
  )
})
