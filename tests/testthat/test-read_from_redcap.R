test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id_position = 1,
    id_col_name = NULL,
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
    id_position = NULL,
    id_col_name = "record_id",
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
    id_position = 1,
    id_col_name = NULL,
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
    id_position = NULL,
    id_col_name = "record_id",
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
    id_position = 1,
    id_col_name = NULL,
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
    id_position = NULL,
    id_col_name = "record_id",
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
    id_position = 1,
    id_col_name = NULL,
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
    id_position = NULL,
    id_col_name = "record_id",
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
    id_position = 1,
    id_col_name = NULL,
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
    id_position = NULL,
    id_col_name = "record_id",
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
    id_position = NULL,
    id_col_name = "record_id",
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
    id_position = 1,
    id_col_name = NULL,
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
    id_position = 1,
    id_col_name = NULL,
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
    id_position = NULL,
    id_col_name = "record_id",
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
    id_position = 1,
    id_col_name = NULL,
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
    id_position = NULL,
    id_col_name = "record_id",
    fields = c("record_id", "name_first", "age", "bmi"),
    records = NULL
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap fails with incorrect id_position", {
  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id_position = "1",
      id_col_name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',id_position,'failed: Must be of type 'numeric'
                 not 'character'.")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id_position = -1,
      id_col_name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',id_position,'failed: Negative value not
                 allowed.")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id_position = 0,
      id_col_name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',id_position,'failed: Must be greater than or
                 equal to 1.")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id_position = NA,
      id_col_name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',id_position,'failed: Missing value not
                 allowed.")
  )
})

test_that("read_from_redcap fails with wrong token", {
  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = 1234,
      id_position = 1,
      id_col_name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',token,'failed: Must be of type 'character'
                 not numeric")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "1234",
      id_position = 1,
      id_col_name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',token,'failed: Must be of length 32.")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = c(
        "9A81268476645C4E5F03428B8AC3AA7B",
        "9A81268476645C4E5F03428B8AC3AA7B"
      ),
      id_position = 1,
      id_col_name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',token,'failed: Multiple tokens not allowed.
                 Please provide only 1 token.")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = NULL,
      id_position = 1,
      id_col_name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',token,'failed: Must be provided.")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = NA,
      id_position = 1,
      id_col_name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',token,'failed: Missing value not allowed.")
  )
})

test_that("read_from_redcap fails with incorrect URI", {
  expect_error(
    read_from_redcap(
      uri = NULL,
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id_position = 1,
      id_col_name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',uri,'failed: Must be provided.")
  )

  expect_error(
    read_from_redcap(
      uri = NA,
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id_position = 1,
      id_col_name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',uri,'failed: Missing value not allowed.")
  )

  expect_error(
    read_from_redcap(
      uri = c(
        "https://bbmc.ouhsc.edu/redcap/api/",
        "https://bbmc.ouhsc.edu/redcap/api/"
      ),
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id_position = 1,
      id_col_name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "3", "5")
    ),
    regexp = cat("Assertion on',uri,'failed: Multiple URI not allowed. Please
                 provide only 1 URI.")
  )
})

test_that("read_from_redcap fails with incorrect records", {
  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id_position = 1,
      id_col_name = NULL,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = NA
    ),
    regexp = cat("Assertion on',records,'failed: Missing value not allowed.")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id_position = NULL,
      id_col_name = "record_id",
      fields = c("record_id", "name_first", "age", "bmi"),
      records = NA
    ),
    regexp = cat("Assertion on',records,'failed: Missing value not allowed.")
  )
})

test_that("read_from_redcap fails with incorrect fields", {
  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id_position = 1,
      id_col_name = NULL,
      fields = NA,
      records = c("1", "2", "3")
    ),
    regexp = cat("Assertion on',fileds,'failed: Missing value not allowed.")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id_position = NULL,
      id_col_name = "record_id",
      fields = NA,
      records = c("1", "2", "3")
    ),
    regexp = cat("Assertion on',fileds,'failed: Missing value not allowed.")
  )
})

test_that("read_from_redcap fails with incorrect id_col_name", {
  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id_position = NULL,
      id_col_name = NA,
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "2", "3")
    ),
    regexp = cat("Assertion on',id_col_name,'failed: Missing value
                 not allowed.")
  )

  expect_error(
    read_from_redcap(
      uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      id_position = NULL,
      id_col_name = c("record_id", "name_first"),
      fields = c("record_id", "name_first", "age", "bmi"),
      records = c("1", "2", "3")
    ),
    regexp = cat("Assertion on',id_col_name,'failed: Multiple ID columns not
                 allowed. Please specify 1 ID column name.")
  )
})
