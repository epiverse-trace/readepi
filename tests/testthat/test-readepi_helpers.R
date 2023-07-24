test_that("read_credentials works as expected", {
  res <- read_credentials(
    file_path = system.file("extdata", "test.ini", package = "readepi"),
    project_id = "Rfam"
  )
  expect_type(res, "list")
  expect_length(res, 6)
  expect_named(res, c("user", "pwd", "host", "project", "dbms", "port"))
  expect_type(res$user, "character")
  expect_type(res$pwd, "character")
  expect_type(res$host, "character")
  expect_type(res$project, "character")
  expect_type(res$dbms, "character")
  expect_type(res$port, "integer")
})

test_that("read_credentials fails as expected", {
  expect_error(
    res <- read_credentials(
      file_path = NULL,
      project_id = "Rfam"
    ),
    regexp = cat("Assertion on',file_path,'failed: Must provide a path to
                 the credential file.")
  )

  expect_error(
    res <- read_credentials(
      file_path = c(
        system.file("extdata", "test.ini", package = "readepi"),
        system.file("extdata", "test.ini", package = "readepi")
      ),
      project_id = "Rfam"
    ),
    regexp = cat("Assertion on',file_path,'failed: Impossible to read from
                 multiple credential files.")
  )

  expect_error(
    res <- read_credentials(
      file_path = system.file("extdata", "test.ini", package = "readepi"),
      project_id = NULL
    ),
    regexp = cat("Assertion on',project_id,'failed: Must provide the database
                 name or the project ID (for REDCap).")
  )

  expect_error(
    res <- read_credentials(
      file_path = system.file("extdata", "test.ini", package = "readepi"),
      project_id = c("Rfam", "TEST_REDCap")
    ),
    regexp = cat("Assertion on',project_id,'failed: Impossible to read from
                 multiple databases or projects.")
  )
})

test_that("get_read_file_args works as expected", {
  res <- get_read_file_args(
    list(
      sep = "\t",
      format = ".txt",
      which = NULL
    )
  )
  expect_type(res, "list")
  expect_length(res, 4)
  expect_named(res, c("sep", "format", "which", "pattern"))
})

test_that("get_read_fingertips_args works as expected", {
  res <- get_read_fingertips_args(
    list(
      indicator_id = 90362,
      area_type_id = 202
    )
  )
  expect_type(res, "list")
  expect_length(res, 8)
  expect_named(res, c(
    "indicator_id", "indicator_name", "area_type_id",
    "profile_id", "profile_name", "domain_id", "domain_name",
    "parent_area_type_id"
  ))
})
