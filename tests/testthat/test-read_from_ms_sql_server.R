test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "epiverse",
    password = "epiverse-trace1",
    host = "172.23.33.99",
    port = 1433,
    database.name = "TEST_READEPI",
    driver.name = "ODBC Driver 17 for SQL Server",
    table.names = "covid",
    records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
    fields = "date,sex,age,ccg_code",
    id.position = 5,
    id.col.name = NULL
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "epiverse",
    password = "epiverse-trace1",
    host = "172.23.33.99",
    port = 1433,
    database.name = "TEST_READEPI",
    driver.name = "ODBC Driver 17 for SQL Server",
    table.names = "covid",
    records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
    fields = "date,sex,age,ccg_code",
    id.position = NULL,
    id.col.name = "ccg_code"
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "epiverse",
    password = "epiverse-trace1",
    host = "172.23.33.99",
    port = 1433,
    database.name = "TEST_READEPI",
    driver.name = "ODBC Driver 17 for SQL Server",
    table.names = "covid",
    records = NULL,
    fields = "date,sex,age,ccg_code",
    id.position = NULL,
    id.col.name = NULL
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "epiverse",
    password = "epiverse-trace1",
    host = "172.23.33.99",
    port = 1433,
    database.name = "TEST_READEPI",
    driver.name = "ODBC Driver 17 for SQL Server",
    table.names = "covid",
    records = NULL,
    fields = NULL,
    id.position = NULL,
    id.col.name = NULL
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "epiverse",
    password = "epiverse-trace1",
    host = "172.23.33.99",
    port = 1433,
    database.name = "TEST_READEPI",
    driver.name = "ODBC Driver 17 for SQL Server",
    table.names = "covid",
    records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
    fields = NULL,
    id.position = NULL,
    id.col.name = "ccg_code"
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "epiverse",
    password = "epiverse-trace1",
    host = "172.23.33.99",
    port = 1433,
    database.name = "TEST_READEPI",
    driver.name = "ODBC Driver 17 for SQL Server",
    table.names = "covid",
    records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
    fields = NULL,
    id.position = 5,
    id.col.name = NULL
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "epiverse",
    password = "epiverse-trace1",
    host = "172.23.33.99",
    port = 1433,
    database.name = "TEST_READEPI",
    driver.name = "ODBC Driver 17 for SQL Server",
    table.names = "covid",
    records = c(
      "e38000191", "e38000247", "e38000020", "e38000130",
      "e38000122", "e38000223"
    ),
    fields = c("date", "sex", "age", "ccg_code"),
    id.position = 5,
    id.col.name = NULL
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "epiverse",
    password = "epiverse-trace1",
    host = "172.23.33.99",
    port = 1433,
    database.name = "TEST_READEPI",
    driver.name = "ODBC Driver 17 for SQL Server",
    table.names = "covid",
    records = c(
      "e38000191", "e38000247", "e38000020", "e38000130",
      "e38000122", "e38000223"
    ),
    fields = c("date", "sex", "age", "ccg_code"),
    id.position = NULL,
    id.col.name = "ccg_code"
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "epiverse",
    password = "epiverse-trace1",
    host = "172.23.33.99",
    port = 1433,
    database.name = "TEST_READEPI",
    driver.name = "ODBC Driver 17 for SQL Server",
    table.names = "covid",
    records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
    fields = "date, sex, age, ccg_code",
    id.position = 5,
    id.col.name = NULL
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "epiverse",
    password = "epiverse-trace1",
    host = "172.23.33.99",
    port = 1433,
    database.name = "TEST_READEPI",
    driver.name = "ODBC Driver 17 for SQL Server",
    table.names = "covid",
    records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
    fields = "date, sex, age, ccg_code",
    id.position = NULL,
    id.col.name = "ccg_code"
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "epiverse",
    password = "epiverse-trace1",
    host = "172.23.33.99",
    port = 1433,
    database.name = "TEST_READEPI",
    driver.name = "ODBC Driver 17 for SQL Server",
    table.names = "covid,ebola,iris",
    records = NULL,
    fields = NULL,
    id.position = NULL,
    id.col.name = NULL
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "epiverse",
    password = "epiverse-trace1",
    host = "172.23.33.99",
    port = 1433,
    database.name = "TEST_READEPI",
    driver.name = "ODBC Driver 17 for SQL Server",
    table.names = "covid,ebola,iris",
    records = NULL,
    fields = c("date,sex,age,ccg_code", "id,date_of_onset,district",
               "Sepal.Length,Species"),
    id.position = NULL,
    id.col.name = NULL
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "epiverse",
    password = "epiverse-trace1",
    host = "172.23.33.99",
    port = 1433,
    database.name = "TEST_READEPI",
    driver.name = "ODBC Driver 17 for SQL Server",
    table.names = "covid,ebola,iris",
    records = c("e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
                "9375,881,4539",
                "setosa"),
    fields = NULL,
    id.position = c(5,1,5),
    id.col.name = NULL
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "epiverse",
    password = "epiverse-trace1",
    host = "172.23.33.99",
    port = 1433,
    database.name = "TEST_READEPI",
    driver.name = "ODBC Driver 17 for SQL Server",
    table.names = "covid,ebola,iris",
    records = c("e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
                "9375,881,4539",
                "setosa"),
    fields = NULL,
    id.position = NULL,
    id.col.name = c("ccg_code","id","Species")
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "epiverse",
    password = "epiverse-trace1",
    host = "172.23.33.99",
    port = 1433,
    database.name = "TEST_READEPI",
    driver.name = "ODBC Driver 17 for SQL Server",
    table.names = "covid,ebola,iris",
    records = c("e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
                "9375,881,4539",
                "setosa"),
    fields = c("date,sex,age,ccg_code", "id,date_of_onset,district",
               "Sepal.Length,Species"),
    id.position = c(5,1,5),
    id.col.name = NULL
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(
    user = "epiverse",
    password = "epiverse-trace1",
    host = "172.23.33.99",
    port = 1433,
    database.name = "TEST_READEPI",
    driver.name = "ODBC Driver 17 for SQL Server",
    table.names = "covid,ebola,iris",
    records = c("e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
                "9375,881,4539",
                "setosa"),
    fields = c("date,sex,age,ccg_code", "id,date_of_onset,district",
               "Sepal.Length,Species"),
    id.position = NULL,
    id.col.name = c("ccg_code","id","Species")
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server fails with port of type character", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = "1433",
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date", "sex", "age", "ccg_code"),
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric', not 'character'.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = "1433",
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date", "sex", "age", "ccg_code"),
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric', not 'character'.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = "1433",
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = NULL,
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric', not 'character'.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = "1433",
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric', not 'character'.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = "1433",
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric', not 'character'.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = "1433",
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = c("date", "sex", "age", "ccg_code"),
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric', not 'character'.")
  )
})

test_that("read_from_ms_sql_server fails with port of type character", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = "1433",
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric', not 'character'.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = "1433",
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric', not 'character'.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = "1433",
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = NULL,
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric', not 'character'.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = "1433",
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric', not 'character'.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = "1433",
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric', not 'character'.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = "1433",
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric', not 'character'.")
  )
})

test_that("read_from_ms_sql_server fails with port of type character", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = "1433",
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric', not 'character'.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = "1433",
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric', not 'character'.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = "1433",
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = NULL,
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric', not 'character'.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = "1433",
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric', not 'character'.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = "1433",
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric', not 'character'.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = "1433",
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric', not 'character'.")
  )
})

test_that("read_from_ms_sql_server fails with negative port", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = -1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date", "sex", "age", "ccg_code"),
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = -1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date", "sex", "age", "ccg_code"),
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = -1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = c("date", "sex", "age", "ccg_code"),
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = -1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = -1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = -1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = NULL,
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )
})

test_that("read_from_ms_sql_server fails with negative port", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = -1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = -1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = -1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = -1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = -1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = -1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = NULL,
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )
})

test_that("read_from_ms_sql_server fails with negative port", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = -1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = -1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = -1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = -1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = -1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = -1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = NULL,
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )
})

test_that("read_from_ms_sql_server fails with invalid id.position", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = -5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',id.position,'failed: Negative column number not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = -5,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',id.position,'failed: Negative column number not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = -5,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',id.position,'failed: Negative column number not allowed.")
  )
})

test_that("read_from_ms_sql_server fails with invalid id.position", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = -5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',id.position,'failed: Negative column number not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = -5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',id.position,'failed: Negative column number not allowed.")
  )
})

test_that("read_from_ms_sql_server fails with invalid id.position", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date", "sex", "age", "ccg_code"),
      id.position = -5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',id.position,'failed: Negative column number not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = -5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',id.position,'failed: Negative column number not allowed.")
  )
})

test_that("read_from_ms_sql_server fails with invalid id.position", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = NA,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',id.position,'failed: Missing values not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = NA,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',id.position,'failed: Missing values not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = NA,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',id.position,'failed: Missing values not allowed.")
  )
})

test_that("read_from_ms_sql_server fails with invalid id.position", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = NA,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',id.position,'failed: Missing values not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = NA,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',id.position,'failed: Missing values not allowed.")
  )
})

test_that("read_from_ms_sql_server fails with invalid id.position", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date", "sex", "age", "ccg_code"),
      id.position = NA,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',id.position,'failed: Missing values not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = NA,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',id.position,'failed: Missing values not allowed.")
  )
})

# user name not null
test_that("read_from_ms_sql_server fails with bad user name", {
  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = NULL,
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = 5,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )
})

test_that("read_from_ms_sql_server fails with bad user name", {
  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )
})

test_that("read_from_ms_sql_server fails with bad user name", {
  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NULL,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )
})

# user name not missing
test_that("read_from_ms_sql_server fails with bad user name", {
  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = NULL,
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = 5,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )
})

test_that("read_from_ms_sql_server fails with bad user name", {
  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )
})

test_that("read_from_ms_sql_server fails with bad user name", {
  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = NA,
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )
})

# user name should be of length 1
test_that("read_from_ms_sql_server fails with bad user name", {
  expect_error(
    read_from_ms_sql_server(
      user = c("epiverse","trace"),
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = NULL,
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("epiverse","trace"),
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("epiverse","trace"),
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("epiverse","trace"),
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("epiverse","trace"),
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("epiverse","trace"),
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = 5,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character of length 1.")
  )
})

test_that("read_from_ms_sql_server fails with bad user name", {
  expect_error(
    read_from_ms_sql_server(
      user = c("epiverse","trace"),
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("epiverse","trace"),
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("epiverse","trace"),
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("epiverse","trace"),
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("epiverse","trace"),
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character of length 1.")
  )
})

test_that("read_from_ms_sql_server fails with bad user name", {
  expect_error(
    read_from_ms_sql_server(
      user = c("epiverse","trace"),
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("epiverse","trace"),
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("epiverse","trace"),
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("epiverse","trace"),
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = c("epiverse","trace"),
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must be of type character of length 1.")
  )
})









# password not null
test_that("read_from_ms_sql_server fails with incorrect password", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NULL,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = NULL,
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NULL,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NULL,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NULL,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NULL,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NULL,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = 5,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect password", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NULL,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NULL,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NULL,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NULL,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NULL,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect password", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NULL,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NULL,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NULL,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NULL,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NULL,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )
})

# user name not missing
test_that("read_from_ms_sql_server fails with incorrect password", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NA,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = NULL,
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NA,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NA,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NA,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NA,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NA,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = 5,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect password", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NA,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NA,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NA,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NA,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NA,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect password", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NA,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NA,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NA,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NA,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = NA,
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )
})

# user name should be of length 1
test_that("read_from_ms_sql_server fails with incorrect password", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = c("epiverse","trace"),
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = NULL,
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = c("epiverse","trace"),
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = c("epiverse","trace"),
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = c("epiverse","trace"),
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = c("epiverse","trace"),
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = c("epiverse","trace"),
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = 5,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character of length 1.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect password", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = c("epiverse","trace"),
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = c("epiverse","trace"),
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = c("epiverse","trace"),
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = c("epiverse","trace"),
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = c("epiverse","trace"),
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character of length 1.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect password", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = c("epiverse","trace"),
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = c("epiverse","trace"),
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = c("epiverse","trace"),
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = c("epiverse","trace"),
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = c("epiverse","trace"),
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character of length 1.")
  )
})













# host not null
test_that("read_from_ms_sql_server fails with incorrect host name", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NULL,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = NULL,
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NULL,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NULL,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NULL,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NULL,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = 5,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect host name", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NULL,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NULL,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NULL,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NULL,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NULL,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect host name", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NULL,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NULL,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NULL,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NULL,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NULL,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )
})

# user name not missing
test_that("read_from_ms_sql_server fails with incorrect password", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NA,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = NULL,
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NA,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NA,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NA,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NA,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NA,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = 5,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect host name", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NA,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NA,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NA,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NA,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NA,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect host name", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NA,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NA,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NA,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NA,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = NA,
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )
})

# host name should be of length 1
test_that("read_from_ms_sql_server fails with incorrect host name", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = c("172.23.33.99","172.23.33.90"),
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = NULL,
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "172.23.33.99",
      host = c("172.23.33.99","172.23.33.90"),
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = c("172.23.33.99","172.23.33.90"),
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = c("172.23.33.99","172.23.33.90"),
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = c("172.23.33.99","172.23.33.90"),
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = c("172.23.33.99","172.23.33.90"),
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = 5,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character of length 1.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect password", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = c("172.23.33.99","172.23.33.90"),
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = c("172.23.33.99","172.23.33.90"),
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = c("172.23.33.99","172.23.33.90"),
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = c("172.23.33.99","172.23.33.90"),
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = c("172.23.33.99","172.23.33.90"),
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character of length 1.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect password", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = c("172.23.33.99","172.23.33.90"),
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = c("172.23.33.99","172.23.33.90"),
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = c("172.23.33.99","172.23.33.90"),
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = c("172.23.33.99","172.23.33.90"),
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = c("172.23.33.99","172.23.33.90"),
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character of length 1.")
  )
})











# MS driver name not null
test_that("read_from_ms_sql_server fails with incorrect driver name", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NULL,
      table.names = "covid",
      records = NULL,
      fields = NULL,
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NULL,
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NULL,
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NULL,
      table.names = "covid",
      records = NULL,
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NULL,
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = 5,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect host name", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NULL,
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NULL,
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NULL,
      table.names = "covid",
      records = NULL,
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NULL,
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NULL,
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect host name", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NULL,
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NULL,
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NULL,
      table.names = "covid",
      records = NULL,
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NULL,
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NULL,
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )
})

# driver name not missing
test_that("read_from_ms_sql_server fails with missing MS SQL driver name", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NA,
      table.names = "covid",
      records = NULL,
      fields = NULL,
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NA,
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NA,
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NA,
      table.names = "covid",
      records = NULL,
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NA,
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NA,
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = 5,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect host name", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NA,
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NA,
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NA,
      table.names = "covid",
      records = NULL,
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NA,
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NA,
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect MS SQL driver name", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NA,
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NA,
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NA,
      table.names = "covid",
      records = NULL,
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NA,
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = NA,
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide MS SQL driver name.")
  )
})

# driver name should be of length 1
test_that("read_from_ms_sql_server fails with incorrect MS SQL driver name", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = c("ODBC Driver 17 for SQL Server","ODBC Driver 18 for SQL Server"),
      table.names = "covid",
      records = NULL,
      fields = NULL,
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = c("ODBC Driver 17 for SQL Server","ODBC Driver 18 for SQL Server"),
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = c("ODBC Driver 17 for SQL Server","ODBC Driver 18 for SQL Server"),
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = c("ODBC Driver 17 for SQL Server","ODBC Driver 18 for SQL Server"),
      table.names = "covid",
      records = NULL,
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = c("ODBC Driver 17 for SQL Server","ODBC Driver 18 for SQL Server"),
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = c("ODBC Driver 17 for SQL Server","ODBC Driver 18 for SQL Server"),
      table.names = "covid",
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = 5,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must be of type character of length 1.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect MS SQL driver name", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = c("ODBC Driver 17 for SQL Server","ODBC Driver 18 for SQL Server"),
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = c("ODBC Driver 17 for SQL Server","ODBC Driver 18 for SQL Server"),
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = c("ODBC Driver 17 for SQL Server","ODBC Driver 18 for SQL Server"),
      table.names = "covid",
      records = NULL,
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = c("ODBC Driver 17 for SQL Server","ODBC Driver 18 for SQL Server"),
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = c("ODBC Driver 17 for SQL Server","ODBC Driver 18 for SQL Server"),
      table.names = "covid",
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must be of type character of length 1.")
  )
})




























test_that("read_from_ms_sql_server fails with incorrect password", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = c("172.23.33.99","172.23.33.90"),
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = c("172.23.33.99","172.23.33.90"),
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = c("172.23.33.99","172.23.33.90"),
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = c("172.23.33.99","172.23.33.90"),
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character of length 1.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = c("172.23.33.99","172.23.33.90"),
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',host,'failed: Must be of type character of length 1.")
  )
})






















# database names not null
test_that("read_from_ms_sql_server fails with incorrect table name", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NULL,
      records = NULL,
      fields = NULL,
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NULL,
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NULL,
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NULL,
      records = NULL,
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NULL,
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = 5,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect host name", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NULL,
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NULL,
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NULL,
      records = NULL,
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NULL,
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NULL,
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect host name", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NULL,
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NULL,
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NULL,
      records = NULL,
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NULL,
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NULL,
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )
})

# driver name not missing
test_that("read_from_ms_sql_server fails with missing MS SQL driver name", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NA,
      records = NULL,
      fields = NULL,
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NA,
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NA,
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = c("date","sex","age","ccg_code"),
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NA,
      records = NULL,
      fields = c("date","sex","age","ccg_code"),
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NA,
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NA,
      records = c("e38000191", "e38000247", "e38000020", "e38000130",
                  "e38000122", "e38000223"),
      fields = NULL,
      id.position = 5,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect host name", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NA,
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NA,
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NA,
      records = NULL,
      fields = "date,sex,age,ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NA,
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NA,
      records = "e38000191,e38000247,e38000020,e38000130,e38000122,e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )
})

test_that("read_from_ms_sql_server fails with incorrect MS SQL driver name", {
  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NA,
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NA,
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NA,
      records = NULL,
      fields = "date, sex, age, ccg_code",
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NA,
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = NA,
      records = "e38000191, e38000247, e38000020, e38000130, e38000122, e38000223",
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',table.names,'failed: Must provide table name.")
  )
})
