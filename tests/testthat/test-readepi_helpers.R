test_that("subset_fields works as expected", {
  res <- subset_fields(
    data.frame = iris, fields = "Sepal.Length,Sepal.Width",
    table.name = "iris"
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "not_found"))
  expect_s3_class(res$data, class = "data.frame")
  expect_type(res$not_found, "double")
})

test_that("subset_fields works as expected", {
  res <- subset_fields(
    data.frame = iris, fields = c("Sepal.Length", "Sepal.Width"),
    table.name = "iris"
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "not_found"))
  expect_s3_class(res$data, class = "data.frame")
  expect_type(res$not_found, "double")
})

test_that("subset_records works as expected", {
  res <- subset_records(
    data.frame = iris, records = "setosa, virginica",
    id.position = 5, table.name = "iris"
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "not_found"))
  expect_s3_class(res$data, class = "data.frame")
  expect_type(res$not_found, "double")
})

test_that("subset_records works as expected", {
  res <- subset_records(
    data.frame = iris, records = c("setosa", "virginica"),
    id.position = 5, table.name = "iris"
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "not_found"))
  expect_s3_class(res$data, class = "data.frame")
  expect_type(res$not_found, "double")
})

test_that("subset_fields fails as expected", {
  expect_error(
    res <- subset_fields(
      data.frame = NULL, fields = "Sepal.Length,Sepal.Width",
      table.name = "iris"
    ),
    regexp = cat("Assertion on',data.frame,'failed: Must provide the data frame to subset from.")
  )

  expect_error(
    res <- subset_fields(
      data.frame = NULL, fields = c("Sepal.Length", "Sepal.Width"),
      table.name = "iris"
    ),
    regexp = cat("Assertion on',data.frame,'failed: Must provide the data frame to subset from.")
  )


  expect_error(
    res <- subset_fields(
      data.frame = iris, fields = NULL,
      table.name = "iris"
    ),
    regexp = cat("Assertion on',fields,'failed: Must provide a vector or a string with the field to subset.")
  )

  expect_error(
    res <- subset_fields(
      data.frame = iris, fields = "Sepal.Length,Sepal.Width",
      table.name = NULL
    ),
    regexp = cat("Assertion on',table.name,'failed: Must provide the table name.")
  )

  expect_error(
    res <- subset_fields(
      data.frame = iris, fields = c("Sepal.Length", "Sepal.Width"),
      table.name = NULL
    ),
    regexp = cat("Assertion on',table.name,'failed: Must provide the table name.")
  )

  expect_error(
    res <- subset_fields(
      data.frame = iris, fields = "Sepal.Length,Sepal.Width",
      table.name = c("iris", "iris3")
    ),
    regexp = cat("Assertion on',table.name,'failed: Must be of type character of length 1.")
  )

  expect_error(
    res <- subset_fields(
      data.frame = iris, fields = c("Sepal.Length", "Sepal.Width"),
      table.name = c("iris", "iris3")
    ),
    regexp = cat("Assertion on',table.name,'failed: Must be of type character of length 1.")
  )

  expect_error(
    res <- subset_fields(
      data.frame = NULL, fields = NULL,
      table.name = NULL
    ),
    regexp = cat("Assertion on',subset_fields,'failed: Must provide the data frame to subset from, the fields to subset and the table name from which to subset.")
  )

  expect_error(
    res <- subset_fields(
      data.frame = NULL, fields = "Sepal.Length,Sepal.Width",
      table.name = NULL
    ),
    regexp = cat("Assertion on',subset_fields,'failed: Must provide the data frame to subset from, and the table name from which to subset.")
  )

  expect_error(
    res <- subset_fields(
      data.frame = iris, fields = NULL,
      table.name = NULL
    ),
    regexp = cat("Assertion on',subset_fields,'failed: Must provide the fields to subset, and the table name from which to subset.")
  )

  expect_error(
    res <- subset_fields(
      data.frame = NULL, fields = NULL,
      table.name = "iris"
    ),
    regexp = cat("Assertion on',subset_fields,'failed: Must provide the fields to subset, and the data frame from which to subset.")
  )
})

test_that("subset_records fails as expected", {
  expect_error(
    res <- subset_records(
      data.frame = NULL, records = "setosa, virginica",
      id.position = 5, table.name = "iris"
    ),
    regexp = cat("Assertion on',data.frame,'failed: Must provide the data frame to subset from.")
  )

  expect_error(
    res <- subset_records(
      data.frame = NULL, records = c("setosa", "virginica"),
      id.position = 5, table.name = "iris"
    ),
    regexp = cat("Assertion on',data.frame,'failed: Must provide the data frame to subset from.")
  )

  expect_error(
    res <- subset_records(
      data.frame = iris, records = NULL,
      id.position = 5, table.name = "iris"
    ),
    regexp = cat("Assertion on',records,'failed: Must provide a vector or a string with the field to subset.")
  )

  expect_error(
    res <- subset_records(
      data.frame = iris, records = "setosa, virginica",
      id.position = -1, table.name = NULL
    ),
    regexp = cat("Assertion on',id.position,'failed: Negative column number not allowed.")
  )

  expect_error(
    res <- subset_records(
      data.frame = iris, records = c("setosa", "virginica"),
      id.position = -1, table.name = NULL
    ),
    regexp = cat("Assertion on',id.position,'failed: Negative column number not allowed.")
  )

  expect_error(
    res <- subset_records(
      data.frame = iris, records = "setosa, virginica",
      id.position = "1", table.name = NULL
    ),
    regexp = cat("Assertion on',id.position,'failed: Must be of type numeric not character.")
  )

  expect_error(
    res <- subset_records(
      data.frame = iris, records = c("setosa", "virginica"),
      id.position = "1", table.name = NULL
    ),
    regexp = cat("Assertion on',id.position,'failed: Must be of type numeric not character.")
  )

  expect_error(
    res <- subset_records(
      data.frame = iris, records = "setosa, virginica",
      id.position = 5, table.name = c("iris", "iris")
    ),
    regexp = cat("Assertion on',table.name,'failed: Must be of type character of length 1.")
  )

  expect_error(
    res <- subset_records(
      data.frame = iris, records = c("setosa", "virginica"),
      id.position = 5, table.name = c("iris", "iris")
    ),
    regexp = cat("Assertion on',table.name,'failed: Must be of type character of length 1.")
  )
})

test_that("read_credentials works as expected", {
  res <- read_credentials(
    file.path = system.file("extdata", "test.ini", package = "readepi"),
    project.id = "Pats__Covid_19_Cohort_1_Screening"
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
      file.path = NULL,
      project.id = "Pats__Covid_19_Cohort_1_Screening"
    ),
    regexp = cat("Assertion on',file.path,'failed: Must provide a path to the credential file.")
  )

  expect_error(
    res <- read_credentials(
      file.path = c(system.file("extdata", "test.ini", package = "readepi"), system.file("extdata", "test.ini", package = "readepi")),
      project.id = "Pats__Covid_19_Cohort_1_Screening"
    ),
    regexp = cat("Assertion on',file.path,'failed: Impossible to read from multiple credential files.")
  )

  expect_error(
    res <- read_credentials(
      file.path = system.file("extdata", "test.ini", package = "readepi"),
      project.id = NULL
    ),
    regexp = cat("Assertion on',project.id,'failed: Must provide the database name (for MS SQLserver) or the project ID (for REDCap).")
  )

  expect_error(
    res <- read_credentials(
      file.path = system.file("extdata", "test.ini", package = "readepi"),
      project.id = c("Pats__Covid_19_Cohort_1_Screening", "Pats__Covid_19_Cohort_1_Screening")
    ),
    regexp = cat("Assertion on',project.id,'failed: Impossible to read from multiple databases or projects.")
  )
})
