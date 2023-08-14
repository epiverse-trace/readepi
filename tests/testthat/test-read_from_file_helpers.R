test_that("get_base_name works as expected", {
  x <- system.file("extdata", "test.txt", package = "readepi")
  expect_identical(get_base_name(x), "test")
})

test_that("detect_separator works as expected", {
  x <- "My name is Karim"
  expect_identical(detect_separator(x), c(" "))
})

test_that("read_rio_formats works as expected", {
  result <- read_rio_formats(
    files_extensions = ".txt",
    rio_extensions = c("txt", "xlxs"),
    files = system.file("extdata", "test.txt", package = "readepi"),
    files_base_names = "test"
  )
  expect_type(result, "list")
})

test_that("read_multiple_files works as expected", {
  result <- read_multiple_files(
    files = system.file("extdata", "test.txt", package = "readepi"),
    dirs = list.dirs(
      path = system.file("extdata", package = "readepi")
    ),
    format = c("txt", "csv"),
    which = NULL
  )
  expect_type(result, "list")
})

test_that("read_files_in_directory works as expected", {
  res <- read_files_in_directory(
    file_path = system.file("extdata", package = "readepi"),
    pattern = ".txt"
  )
  expect_type(res, "list")

  res <- read_files_in_directory(
    file_path = system.file("extdata", package = "readepi"),
    pattern = NULL
  )
  expect_type(res, "list")
})

test_that("read_files_in_directory fails as expected", {
  expect_error(
    read_files_in_directory(
      file_path = NULL,
      pattern = ".txt"
    ),
    regexp = cat("Assertion on',file_path,'failed: Must be provided.")
  )

  expect_error(
    read_files_in_directory(
      file_path = NA,
      pattern = ".txt"
    ),
    regexp = cat("Assertion on',file_path,'failed: Missing value not allowed for
                 file_path.")
  )

  expect_error(
    read_files_in_directory(
      file_path = system.file("extdata", package = "readepi"),
      pattern = NA
    ),
    regexp = cat("Assertion on',file_path,'failed: Missing value not allowed for
                 pattern.")
  )
})

test_that("read_files works as expected", {
  res <- read_files(
    file_path = system.file("extdata", "test.xlsx", package = "readepi"),
    sep = NULL,
    format = NULL,
    which = "Sheet1"
  )
  expect_type(res, "list")

  res <- read_files(
    file_path = system.file("extdata", "test.xlsx", package = "readepi"),
    sep = NULL,
    format = NULL,
    which = NULL
  )
  expect_type(res, "list")

  res <- read_files(
    file_path = system.file("extdata", "test.txt", package = "readepi"),
    sep = "\t",
    format = ".txt",
    which = NULL
  )
  expect_type(res, "list")
})
