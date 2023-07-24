test_that("import_redcap_data works as expected", {
  result <- import_redcap_data(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    records = c("1", "3", "5"),
    fields = c("record_id", "name_first", "age", "bmi"),
    id_col_name = NULL,
    id_position = 1
  )
  expect_type(result, "list")
  expect_length(result, 2)
})

test_that("redcap_get_results works as expected", {
  result <- redcap_get_results(
    redcap_data = REDCapR::redcap_read(
      redcap_uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      records = c("1", "3", "5"),
      fields = c("record_id", "name_first", "age", "bmi"), verbose = FALSE,
      id_position = 1L
    ),
    metadata = REDCapR::redcap_metadata_read(
      redcap_uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      fields = NULL,
      verbose = FALSE
    )
  )
  expect_type(result, "list")
  expect_length(result, 2)
})

test_that("redcap_get_results fails with bad redcap_data", {
  expect_error(
    redcap_get_results(
      redcap_data = NULL,
      metadata = REDCapR::redcap_metadata_read(
        redcap_uri = "https://bbmc.ouhsc.edu/redcap/api/",
        token = "9A81268476645C4E5F03428B8AC3AA7B",
        fields = NULL,
        verbose = FALSE
      )
    ),
    regexp = cat("Assertion on',redcap_data,'failed: Must be provided")
  )

  expect_error(
    redcap_get_results(
      redcap_data = NA,
      metadata = REDCapR::redcap_metadata_read(
        redcap_uri = "https://bbmc.ouhsc.edu/redcap/api/",
        token = "9A81268476645C4E5F03428B8AC3AA7B",
        fields = NULL,
        verbose = FALSE
      )
    ),
    regexp = cat("Assertion on',redcap_data,'failed: Missing value not allowed
                 for redcap_data")
  )
})

test_that("redcap_get_results fails with bad redcap_data", {
  expect_error(
    redcap_get_results(
      redcap_data = REDCapR::redcap_read(
        redcap_uri = "https://bbmc.ouhsc.edu/redcap/api/",
        token = "9A81268476645C4E5F03428B8AC3AA7B",
        records = c("1", "3", "5"),
        fields = c("record_id", "name_first", "age", "bmi"), verbose = FALSE,
        id_position = 1L
      ),
      metadata = NULL
    ),
    regexp = cat("Assertion on',metadata,'failed: Must be provided")
  )

  expect_error(
    redcap_get_results(
      redcap_data = REDCapR::redcap_read(
        redcap_uri = "https://bbmc.ouhsc.edu/redcap/api/",
        token = "9A81268476645C4E5F03428B8AC3AA7B",
        records = c("1", "3", "5"),
        fields = c("record_id", "name_first", "age", "bmi"), verbose = FALSE,
        id_position = 1L
      ),
      metadata = NA
    ),
    regexp = cat("Assertion on',metadata,'failed: Missing value not allowed
                 for metadata")
  )
})

test_that("redcap_read works as expected", {
  res <- redcap_read(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id_position = 1
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("redcap_data", "metadata"))
  expect_type(res$redcap_data, "list")
  expect_type(res$metadata, "list")
})

test_that("redcap_read works as expected", {
  res <- redcap_read(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id_position = 1
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("redcap_data", "metadata"))
  expect_type(res$redcap_data, "list")
  expect_type(res$metadata, "list")
})

test_that("redcap_read_rows_columns works as expected", {
  res <- redcap_read_rows_columns(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id_position = 1,
    id_col_name = NULL,
    fields = c("record_id", "name_first", "age", "bmi"),
    records = c("1", "3", "5")
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("redcap_data", "metadata"))
  expect_type(res$redcap_data, "list")
  expect_type(res$metadata, "list")
})

test_that("redcap_read_fields works as expected", {
  res <- redcap_read_fields(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id_position = 1,
    fields = c("record_id", "name_first", "age", "bmi")
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("redcap_data", "metadata"))
  expect_type(res$redcap_data, "list")
  expect_type(res$metadata, "list")
})

test_that("redcap_read_records works as expected", {
  res <- redcap_read_records(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id_position = 1,
    records = c("1", "2", "3"),
    id_col_name = NULL
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("redcap_data", "metadata"))
  expect_type(res$redcap_data, "list")
  expect_type(res$metadata, "list")
})
