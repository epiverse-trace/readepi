test_that("readepi works as expected when reading from DBMS", {
  data <- readepi(
    credentials.file = system.file("extdata", "test.ini", package = "readepi"),
    project.id = "IBS_BHDSS",
    file.path = NULL,
    sep = NULL,
    format = NULL,
    which = NULL,
    pattern = NULL,
    driver.name = "ODBC Driver 17 for SQL Server",
    table.name = "dss_events",
    records = NULL,
    fields = NULL,
    id.position = 1
  )
  expect_type(data, "list")
})

test_that("readepi works as expected when reading from file", {
  data <- readepi(
    credentials.file = NULL,
    project.id = NULL,
    file.path = system.file("extdata", "test.json", package = "readepi"),
    sep = NULL,
    format = NULL,
    which = NULL,
    pattern = NULL,
    driver.name = NULL,
    table.name = NULL,
    records = NULL,
    fields = NULL,
    id.position = 1
  )
  expect_type(data, "list")
})

test_that("readepi works as expected when reading from DBMS", {
  data <- readepi(
    credentials.file = system.file("extdata", "test.ini", package = "readepi"),
    project.id = "IBS_BHDSS",
    file.path = NULL,
    sep = NULL,
    format = NULL,
    which = NULL,
    pattern = NULL,
    driver.name = "ODBC Driver 17 for SQL Server",
    table.name = "dss_events",
    records = NULL,
    fields = NULL,
    id.position = 1
  )
  expect_type(data, "list")
})

test_that("readepi works as expected when reading from a directory", {
  data <- readepi(
    credentials.file = NULL,
    project.id = NULL,
    file.path = system.file("extdata", package = "readepi"),
    sep = NULL,
    format = NULL,
    which = NULL,
    pattern = "txt",
    driver.name = NULL,
    table.name = NULL,
    records = NULL,
    fields = NULL,
    id.position = 1
  )
  expect_type(data, "list")
})

test_that("readepi fails as expected", {
  expect_error(
    data <- readepi(
      credentials.file = system.file("extdata", "test.ini", package = "readepi"),
      project.id = "IBS_BHDSS",
      file.path = system.file("extdata", "test.json", package = "readepi"),
      sep = NULL,
      format = NULL,
      which = NULL,
      pattern = NULL,
      driver.name = "ODBC Driver 17 for SQL Server",
      table.name = "dss_events",
      records = NULL,
      fields = NULL,
      id.position = 1
    ),
    regexp = cat("Assertion on',credentials.file,' and,'file.path',failed: Must specify either the file path or the credential file, not both at the same time.")
  )

  expect_error(
    data <- readepi(
      credentials.file = system.file("extdata", "test.ini", package = "readepi"),
      project.id = c("IBS_BHDSS", "IBS_BHDSS"),
      file.path = NULL,
      sep = NULL,
      format = NULL,
      which = NULL,
      pattern = NULL,
      driver.name = "ODBC Driver 17 for SQL Server",
      table.name = "dss_events",
      records = NULL,
      fields = NULL,
      id.position = 1
    ),
    regexp = cat("Assertion on',project.id,failed: Must be of type type character of length 1.")
  )

  expect_error(
    data <- readepi(
      credentials.file = system.file("extdata", "test.ini", package = "readepi"),
      project.id = "IBS_BHDSS",
      file.path = NULL,
      sep = NULL,
      format = NULL,
      which = NULL,
      pattern = NULL,
      driver.name = "ODBC Driver 17 for SQL Server",
      table.name = "dss_events",
      records = NULL,
      fields = NULL,
      id.position = -1
    ),
    regexp = cat("Assertion on',id.position,failed: Must be greater than or equal 1.")
  )

  expect_error(
    data <- readepi(
      credentials.file = system.file("extdata", "test.ini", package = "readepi"),
      project.id = "IBS_BHDSS",
      file.path = NULL,
      sep = NULL,
      format = NULL,
      which = NULL,
      pattern = NULL,
      driver.name = NULL,
      table.name = "dss_events",
      records = NULL,
      fields = NULL,
      id.position = 1
    ),
    regexp = cat("Assertion on',driver.name,failed: MS driver name must be provided.")
  )

  expect_error(
    data <- readepi(
      credentials.file = NULL,
      project.id = "IBS_BHDSS",
      file.path = NULL,
      sep = NULL,
      format = NULL,
      which = NULL,
      pattern = NULL,
      driver.name = NULL,
      table.name = "dss_events",
      records = NULL,
      fields = NULL,
      id.position = 1
    ),
    regexp = cat("Assertion on',credentials.file,and,'file.path',failed: Must provide either a file path, or a directory or a credential file.")
  )

  expect_error(
    data <- readepi(
      credentials.file = NULL,
      project.id = NULL,
      file.path = system.file("extdata", "test.txt", package = "readepi"),
      sep = c(",", "\t"),
      format = NULL,
      which = NULL,
      pattern = NULL,
      driver.name = NULL,
      table.name = NULL,
      records = NULL,
      fields = NULL,
      id.position = 1
    ),
    regexp = cat("Assertion on',sep,'failed: Must be a character of length 1.")
  )

  expect_error(
    data <- readepi(
      credentials.file = NULL,
      project.id = NULL,
      file.path = system.file("extdata", "test.txt", package = "readepi"),
      sep = "\t",
      format = c("txt", ".csv"),
      which = NULL,
      pattern = NULL,
      driver.name = NULL,
      table.name = NULL,
      records = NULL,
      fields = NULL,
      id.position = 1
    ),
    regexp = cat("Assertion on',format,'failed: Must be a character of length 1.")
  )
})


# might need 'register_new_user()' to register a new user

#
