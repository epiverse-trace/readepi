
test_that("read_from_file works properly when reading from an excel file with 1 sheet", {
  data <- read_from_file(file.path=system.file("extdata", "test.xlsx", package = "readepi"),
                         sep = NULL, format = NULL,
                         which = NULL, pattern = NULL)
  expect_type(data, "list")
})

test_that("read_from_file works properly when reading from an excel file with several sheets", {
  data <- read_from_file(file.path=system.file("extdata", "test.xlsx", package = "readepi"),
                         sep = NULL, format = NULL,
                         which = c('Sheet1','Sheet2'), pattern = NULL)
  expect_type(data, "list")
})

test_that("read_from_file works as expected when reading from file", {
  data <- read_from_file(file.path=system.file("extdata", "test.txt", package = "readepi"),
                         sep = "\t", format = NULL,
                         which = NULL, pattern = NULL)
  expect_type(data, "list")
})

test_that("read_from_file works as expected when reading from file", {
  data <- read_from_file(file.path=system.file("extdata", "test.txt", package = "readepi"),
                         sep = NULL, format = NULL,
                         which = NULL, pattern = NULL)
  expect_type(data, "list")
})

test_that("read_from_file works as expected when reading from file", {
  data <- read_from_file(file.path=system.file("extdata", "test.txt", package = "readepi"),
                         sep = NULL, format = 'txt',
                         which = NULL, pattern = NULL)
  expect_type(data, "list")
})


test_that("read_from_file works as expected when reading from directory given 1 pattern", {
    data = read_from_file(file.path=system.file("extdata", package = "readepi"),
                          pattern = "txt")
    expect_type(data, "list")
})

test_that("read_from_file works as expected when reading from directory given several pattern", {
  data = read_from_file(file.path=system.file("extdata", package = "readepi"),
                        pattern = ".txt")  #pattern = c(".txt",".csv")
  expect_type(data, "list")
})

test_that("read_from_file works as expected when reading from directory given several pattern", {
  data = read_from_file(file.path=system.file("extdata", package = "readepi"),
                        pattern = c(".txt",".csv"))  #pattern = c(".txt",".csv")
  expect_type(data, "list")
})

test_that("read_from_file works as expected when reading from directory", {
  data = read_from_file(file.path=system.file("extdata", package = "readepi"))
  expect_type(data, "list")
})

test_that("read_from_file fails as expected", {
  expect_error(
    data = read_from_file(file.path=system.file("extdata", "test.txt", package = "readepi"),
                   sep = 1,
                   format = '.txt',
                   which = 'Sheet2',
                   pattern = '.txt'),
    regexp = cat("Assertion on',sep,'failed: Must be of type 'character' not 'numeric'.")
  )

  expect_error(
    read_from_file(file.path=system.file("extdata", "test.txt", package = "readepi"),
                   sep = c(' ','\t'),
                   format = '.txt',
                   which = 'Sheet2',
                   pattern = '.txt'),
    regexp = cat("Assertion on',sep,'failed: Must be of type 'character' of length 1.")
  )

  expect_error(
    read_from_file(file.path=system.file("extdata", "test.txt", package = "readepi"),
                   sep = ' ',
                   format = 1,
                   which = 'Sheet2',
                   pattern = '.txt'),
    regexp = cat("Assertion on',format,'failed: Must be of type 'character' not 'numeric'.")
  )

  # expect_error(
  #   read_from_file(file.path=system.file("extdata", "test.txt", package = "readepi"),
  #                  sep = ' ',
  #                  format = 'txt',
  #                  which = 1,
  #                  pattern = '.txt'),
  #   regexp = cat("Assertion on',which,'failed: Must be of type 'character' not 'numeric'.")
  # )

  # expect_error(
  #   read_from_file(file.path=system.file("extdata", "test.txt", package = "readepi"),
  #                  sep = ' ',
  #                  format = 'txt',
  #                  which = 'Sheet2',
  #                  pattern = c(".txt",".csv")),
  #   regexp = cat("Assertion on',pattern,'failed: Must be of type 'character' of length 1.")
  # )

  expect_error(
    read_from_file(file.path=NULL,
                   sep = ' ',
                   format = 'txt',
                   which = 'Sheet2',
                   pattern = NULL),
    regexp = cat("Assertion on',file.path,'failed: Must provide path to input file or directory")
  )
})

