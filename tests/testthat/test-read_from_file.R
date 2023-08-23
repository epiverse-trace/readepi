test_that("read_from_file works properly when reading from an excel file
          with 1 sheet", {
            data <- read_from_file(
              file_path = system.file("extdata", "test.xlsx",
                                      package = "readepi"),
              sep = NULL, format = NULL,
              which = NULL, pattern = NULL
            )
            expect_type(data, "list")
          })

test_that("read_from_file works properly when reading from an excel file with
          several sheets", {
            data <- read_from_file(
              file_path = system.file("extdata", "test.xlsx",
                                      package = "readepi"),
              sep = NULL, format = NULL,
              which = c("Sheet1", "Sheet2"), pattern = NULL
            )
            expect_type(data, "list")
          })

test_that("read_from_file works as expected when reading from file", {
  data <- read_from_file(
    file_path = system.file("extdata", "test.txt", package = "readepi"),
    sep = "\t", format = NULL,
    which = NULL, pattern = NULL
  )
  expect_type(data, "list")
})

test_that("read_from_file works as expected when reading from file", {
  data <- read_from_file(
    file_path = system.file("extdata", "test.txt", package = "readepi"),
    sep = NULL, format = NULL,
    which = NULL, pattern = NULL
  )
  expect_type(data, "list")
})

test_that("read_from_file works as expected when reading from file", {
  data <- read_from_file(
    file_path = system.file("extdata", "test.txt", package = "readepi"),
    sep = NULL, format = "txt",
    which = NULL, pattern = NULL
  )
  expect_type(data, "list")
})

test_that("read_from_file works as expected when reading from directory
          given 1 pattern", {
            data <- read_from_file(
              file_path = system.file("extdata", package = "readepi"),
              pattern = "txt"
            )
            expect_type(data, "list")
          })

test_that("read_from_file works as expected when reading from directory given
          several pattern", {
            data <- read_from_file(
              file_path = system.file("extdata", package = "readepi"),
              pattern = ".txt"
            )
            expect_type(data, "list")
          })

test_that("read_from_file works as expected when reading from directory given
          several pattern", {
            data <- read_from_file(
              file_path = system.file("extdata", package = "readepi"),
              pattern = c(".txt", ".csv")
            )
            expect_type(data, "list")
          })

test_that("read_from_file works as expected when reading from directory", {
  data <- read_from_file(
    file_path = system.file("extdata", package = "readepi")
  )
  expect_type(data, "list")
})

test_that("read_from_file fails as expected", {
  expect_error(
    read_from_file(
      file_path = system.file("extdata", "test.txt", package = "readepi"),
      sep = c(" ", "\t"),
      format = ".txt",
      which = "Sheet2",
      pattern = ".txt"
    ),
    regexp = cat("Assertion on',sep,'failed: Must be of type 'character'
                 of length 1.")
  )

  expect_error(
    read_from_file(
      file_path = system.file("extdata", "test.txt", package = "readepi"),
      sep = NA,
      format = ".txt",
      which = "Sheet2",
      pattern = ".txt"
    ),
    regexp = cat("Assertion on',sep,'failed: Missing value not allowed
                 for sep.")
  )

  expect_error(
    read_from_file(
      file_path = system.file("extdata", "test.txt", package = "readepi"),
      sep = " ",
      format = 1L,
      which = "Sheet2",
      pattern = ".txt"
    ),
    regexp = cat("Assertion on',format,'failed: Must be of type 'character'
                 not 'numeric'.")
  )

  expect_error(
    read_from_file(
      file_path = system.file("extdata", "test.txt", package = "readepi"),
      sep = " ",
      format = NA,
      which = "Sheet2",
      pattern = ".txt"
    ),
    regexp = cat("Assertion on',format,'failed: Missing value not allowed
                 for format.")
  )

  expect_error(
    read_from_file(
      file_path = NULL,
      sep = " ",
      format = "txt",
      which = "Sheet2",
      pattern = NULL
    ),
    regexp = cat("Assertion on',file_path,'failed: Must be provided")
  )

  expect_error(
    read_from_file(
      file_path = NA,
      sep = " ",
      format = "txt",
      which = "Sheet2",
      pattern = NULL
    ),
    regexp = cat("Assertion on',file_path,'failed: Missing value not allowed for
                 file_path")
  )

  expect_error(
    read_from_file(
      file_path = c(
        system.file("extdata", "test.txt", package = "readepi"),
        system.file("extdata", "fake_test.txt", package = "readepi")
      ),
      sep = " ",
      format = "txt",
      which = "Sheet2",
      pattern = NULL
    ),
    regexp = cat("Assertion on',file_path,'failed: Must be a character of
                 length 1")
  )

  expect_error(
    read_from_file(
      file_path = system.file("extdata", "test.txt", package = "readepi"),
      sep = " ",
      format = "txt",
      which = NA,
      pattern = NULL
    ),
    regexp = cat("Assertion on',file_path,'failed: Missing value not allowed
                 for which")
  )

  expect_error(
    read_from_file(
      file_path = system.file("extdata", "test.txt", package = "readepi"),
      sep = " ",
      format = "txt",
      which = "Sheet2",
      pattern = NA
    ),
    regexp = cat("Assertion on',file_path,'failed: Missing value not allowed
                 for pattern")
  )
})
