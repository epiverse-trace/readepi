test_that("get_extension works as expected", {
  result <- get_extension(
    file_path = system.file("extdata", "test.txt", package = "readepi")
  )
  expect_type(result, "character")
})

test_that("get_base_name works as expected", {
  result <- get_base_name(
    x = system.file("extdata", "test.txt", package = "readepi")
  )
  expect_type(result, "character")
})

test_that("detect_separator works as expected", {
  result <- detect_separator(
    x = "My name is Karim"
  )
  expect_type(result, "character")
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

test_that("read_files fails as expected", {
  expect_error(
    read_files(
      file_path = NULL,
      sep = NULL,
      format = NULL,
      which = NULL
    ),
    regexp = cat("Assertion on',file_path,'failed: Must be provided.")
  )

  expect_error(
    read_files(
      file_path = NA,
      sep = NULL,
      format = NULL,
      which = NULL
    ),
    regexp = cat("Assertion on',file_path,'failed: Missing value not allowed for
                 file_path.")
  )

  expect_error(
    read_files(
      file_path = system.file("extdata", "test.xlsx", package = "readepi"),
      sep = c(" ", "\t"),
      format = NULL,
      which = NULL
    ),
    regexp = cat("Assertion on',sep,'failed: Must be a character of length 1.")
  )

  expect_error(
    read_files(
      file_path = system.file("extdata", "test.xlsx", package = "readepi"),
      sep = NA,
      format = NULL,
      which = NULL
    ),
    regexp = cat("Assertion on',sep,'failed: Missing value not allowed
                 for sep.")
  )

  expect_error(
    read_files(
      file_path = system.file("extdata", "test.txt", package = "readepi"),
      sep = "\t",
      format = NA,
      which = NULL
    ),
    regexp = cat("Assertion on',sep,'failed: Missing value not allowed
                 for format")
  )

  expect_error(
    read_files(
      file_path = system.file("extdata", "test.txt", package = "readepi"),
      sep = "\t",
      format = NULL,
      which = NA
    ),
    regexp = cat("Assertion on',sep,'failed: Missing value not allowed
                 for which")
  )
})

test_that("read_files fails as expected", {
  expect_error(
    fingertips_subset_rows(
      records = NA,
      id_col_name = "Species",
      data = iris
    ),
    regexp = cat("Assertion on',records,'failed: Missing value not allowed for
                 records.")
  )

  expect_error(
    fingertips_subset_rows(
      records = "setosa",
      id_col_name = NULL,
      data = iris
    ),
    regexp = cat("Assertion on',id_col_name,'failed: Must be specified.")
  )

  expect_error(
    fingertips_subset_rows(
      records = "setosa",
      id_col_name = "Species",
      data = NULL
    ),
    regexp = cat("Assertion on',data,'failed: Must be specified.")
  )
})

test_that("read_files fails as expected", {
  expect_error(
    fingertips_subset_columns(
      fields = "Sepal.Width,Petal.Length",
      data = NULL
    ),
    regexp = cat("Assertion on',data,'failed: Must be provided")
  )
})
