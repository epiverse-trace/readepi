test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id.position = 1,
    id.col.name = NULL,
    records = NULL,
    fields = NULL
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id.position = NULL,
    id.col.name = "record_id",
    records = NULL,
    fields = NULL
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id.position = 1,
    id.col.name = NULL,
    fields = c("record_id", "name_first", "age", "bmi"),
    records = c("1", "3", "5")
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id.position = NULL,
    id.col.name = "record_id",
    fields = c("record_id", "name_first", "age", "bmi"),
    records = c("1", "3", "5")
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id.position = 1,
    id.col.name = NULL,
    fields = "record_id,name_first,age,bmi",
    records = "1,3,5"
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id.position = NULL,
    id.col.name = "record_id",
    fields = "record_id,name_first,age,bmi",
    records = "1,3,5"
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id.position = 1,
    id.col.name = NULL,
    fields = NULL,
    records = "1,3,5"
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id.position = NULL,
    id.col.name = "record_id",
    fields = NULL,
    records = "1,3,5"
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id.position = 1,
    id.col.name = NULL,
    fields = "record_id, name_first, age, bmi",
    records = NULL
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id.position = NULL,
    id.col.name = "record_id",
    fields = "record_id, name_first, age, bmi",
    records = NULL
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id.position = NULL,
    id.col.name = "record_id",
    fields = "record_id, name_first, age, bmi",
    records = "1, 3, 5"
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id.position = 1,
    id.col.name = NULL,
    fields = "record_id, name_first, age, bmi",
    records = "1, 3, 5"
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id.position = 1,
    id.col.name = NULL,
    fields = NULL,
    records = c("1", "3", "5")
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id.position = NULL,
    id.col.name = "record_id",
    fields = NULL,
    records = c("1", "3", "5")
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id.position = 1,
    id.col.name = NULL,
    fields = c("record_id", "name_first", "age", "bmi"),
    records = NULL
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id.position = NULL,
    id.col.name = "record_id",
    fields = c("record_id", "name_first", "age", "bmi"),
    records = NULL
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap fails with id.position as string", {
  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id.position = "1",
      id.col.name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = NULL
    ),
    regexp = cat("Assertion on',id.position,'failed: Must be of type 'numeric' not 'character'.")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id.position = "1",
      id.col.name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',id.position,'failed: Must be of type 'numeric' not 'character'.")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id.position = "1",
      id.col.name = NULL,
      fields = NULL,
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',id.position,'failed: Must be of type 'numeric' not 'character'.")
  )
})

test_that("read_from_redcap fails with negative id.position", {
  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id.position = -1,
      id.col.name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = NULL
    ),
    regexp = cat("Assertion on',id.position,'failed: Must be >= 1.")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id.position = -1,
      id.col.name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',id.position,'failed: Must be >= 1.")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id.position = -1,
      id.col.name = NULL,
      fields = NULL,
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',id.position,'failed: Must be >= 1.")
  )
})

test_that("read_from_redcap fails with id.position = 0", {
  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id.position = 0,
      id.col.name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = NULL
    ),
    regexp = cat("Assertion on',id.position,'failed: Must be >= 1.")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id.position = 0,
      id.col.name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',id.position,'failed: Must be >= 1.")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id.position = 0,
      id.col.name = NULL,
      fields = NULL,
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',id.position,'failed: Must be >= 1.")
  )
})

test_that("read_from_redcap fails with missing id.position", {
  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id.position = NA,
      id.col.name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = NULL
    ),
    regexp = cat("Assertion on',id.position,'failed: Must be >= 1.")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id.position = NA,
      id.col.name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',id.position,'failed: Must be >= 1.")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id.position = NA,
      id.col.name = NULL,
      fields = NULL,
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',id.position,'failed: Must be >= 1.")
  )
})

test_that("read_from_redcap fails with wrong token length", {
  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = 1234,
      id.position = 1,
      id.col.name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = NULL
    ),
    regexp = cat("Assertion on',token,'failed: Must be a 'character' of length 32")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = 1234,
      id.position = 1,
      id.col.name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',token,'failed: Must be a 'character' of length 32")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = 1234,
      id.position = NULL,
      id.col.name = "record_id",
      fields = c("record_id", "name_first", "age", "bmi"),
      records = NULL
    ),
    regexp = cat("Assertion on',token,'failed: Must be a 'character' of length 32")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = 1234,
      id.position = NULL,
      id.col.name = "record_id",
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',token,'failed: Must be a 'character' of length 32")
  )
})

test_that("read_from_redcap fails with more than 1 token", {
  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = c("9A81268476645C4E5F03428B8AC3AA7B", "9A81268476645C4E5F03428B8AC3AA7B"),
      id.position = 1,
      id.col.name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = NULL
    ),
    regexp = cat("Assertion on',token,'failed: Must provide only 1 at a time")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = c("9A81268476645C4E5F03428B8AC3AA7B", "9A81268476645C4E5F03428B8AC3AA7B"),
      id.position = 1,
      id.col.name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',token,'failed: Must provide only 1 at a time")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = c("9A81268476645C4E5F03428B8AC3AA7B", "9A81268476645C4E5F03428B8AC3AA7B"),
      id.position = NULL,
      id.col.name = "record_id",
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',token,'failed: Must provide only 1 at a time")
  )
})

test_that("read_from_redcap fails with a NULL token", {
  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = NULL,
      id.position = 1,
      id.col.name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = NULL
    ),
    regexp = cat("Assertion on',token,'failed: Must be provided")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = NULL,
      id.position = 1,
      id.col.name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',token,'failed: Must be provided")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = NULL,
      id.position = NULL,
      id.col.name = "record_id",
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',token,'failed: Must be provided")
  )
})

test_that("read_from_redcap fails with a missing token", {
  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = NA,
      id.position = 1,
      id.col.name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = NULL
    ),
    regexp = cat("Assertion on',token,'failed: Missing value not allowed")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = NA,
      id.position = 1,
      id.col.name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',token,'failed: Missing value not allowed")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = NA,
      id.position = NULL,
      id.col.name = "record_id",
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',token,'failed: Missing value not allowed")
  )
})

test_that("read_from_redcap fails with a NULL URI", {
  expect_error(
    read_from_redcap(
      uri = NULL,
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id.position = 1,
      id.col.name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = NULL
    ),
    regexp = cat("Assertion on',uri,'failed: Must be provided.")
  )

  expect_error(
    read_from_redcap(
      uri = NULL,
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id.position = 1,
      id.col.name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',uri,'failed: Must be provided.")
  )

  expect_error(
    read_from_redcap(
      uri = NULL,
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id.position = NULL,
      id.col.name = "record_id",
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',uri,'failed: Must be provided.")
  )
})

test_that("read_from_redcap fails with a missing URI", {
  expect_error(
    read_from_redcap(
      uri = NA,
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id.position = 1,
      id.col.name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = NULL
    ),
    regexp = cat("Assertion on',uri,'failed: Missing value not allowed.")
  )

  expect_error(
    read_from_redcap(
      uri = NA,
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id.position = 1,
      id.col.name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',uri,'failed: Missing value not allowed.")
  )

  expect_error(
    read_from_redcap(
      uri = NA,
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id.position = NULL,
      id.col.name = "record_id",
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',uri,'failed: Missing value not allowed.")
  )
})

test_that("read_from_redcap fails with multiple URI", {
  expect_error(
    read_from_redcap(
      uri = c("https://bbmc.ouhsc.edu/redcap/api/", "https://bbmc.ouhsc.edu/redcap/api/"),
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id.position = 1,
      id.col.name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = NULL
    ),
    regexp = cat("Assertion on',uri,'failed: Must specify only 1 URI at a time.")
  )

  expect_error(
    read_from_redcap(
      uri = c("https://bbmc.ouhsc.edu/redcap/api/", "https://bbmc.ouhsc.edu/redcap/api/"),
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id.position = 1,
      id.col.name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "2", "3")
    ),
    regexp = cat("Assertion on',uri,'failed: Must specify only 1 URI at a time.")
  )

  expect_error(
    read_from_redcap(
      uri = c("https://bbmc.ouhsc.edu/redcap/api/", "https://bbmc.ouhsc.edu/redcap/api/"),
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id.position = NULL,
      id.col.name = "record_id",
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "2", "3")
    ),
    regexp = cat("Assertion on',uri,'failed: Must specify only 1 URI at a time.")
  )
})

test_that("read_from_redcap fails with missing records", {
  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id.position = 1,
      id.col.name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = NA
    ),
    regexp = cat("Assertion on',records,'failed: Missing value not allowed.")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id.position = NULL,
      id.col.name = "record_id",
      fields = c("record_id", "name_first", "age", "bmi"),
      records = NA
    ),
    regexp = cat("Assertion on',records,'failed: Missing value not allowed.")
  )
})

test_that("read_from_redcap fails with missing fields", {
  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id.position = 1,
      id.col.name = NULL,
      fields = NA,
      records = c("1", "2", "3")
    ),
    regexp = cat("Assertion on',fileds,'failed: Missing value not allowed.")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id.position = NULL,
      id.col.name = "record_id",
      fields = NA,
      records = c("1", "2", "3")
    ),
    regexp = cat("Assertion on',fileds,'failed: Missing value not allowed.")
  )
})
