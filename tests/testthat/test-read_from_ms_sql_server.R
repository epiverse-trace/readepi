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

test_that("read_from_ms_sql_server fails as expected", {
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
      records = NULL,
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
      records = NULL,
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
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
      fields = NULL,
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
      records = NULL,
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
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
      fields = NULL,
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
      records = NULL,
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
      host = "172.23.33.99",
      port = NULL,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Must provide the port ID.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = NULL,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = NULL,
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',port,'failed: Must provide the port ID.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = NULL,
      database.name = "TEST_READEPI",
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',port,'failed: Must provide the port ID.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = NULL,
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',database.name,'failed: Must provide the database name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = NULL,
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = NULL,
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',database.name,'failed: Must provide the database name.")
  )

  expect_error(
    read_from_ms_sql_server(
      user = "epiverse",
      password = "epiverse-trace1",
      host = "172.23.33.99",
      port = 1433,
      database.name = NULL,
      driver.name = "ODBC Driver 17 for SQL Server",
      table.names = "covid",
      records = NULL,
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',database.name,'failed: Must provide the database name.")
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
      fields = NULL,
      id.position = 5,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide the driver name.")
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
      fields = NULL,
      id.position = NULL,
      id.col.name = NULL
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide the driver name.")
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
      fields = NULL,
      id.position = NULL,
      id.col.name = "ccg_code"
    ),
    regexp = cat("Assertion on',driver.name,'failed: Must provide the driver name.")
  )
})
