httptest::with_mock_api({
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  testthat::skip_if_not_installed("httptest")
  test_that("redcap_import_data works as expected", {
    result <- redcap_import_data(
      base_url    = file.path("https:/", "bbmc.ouhsc.edu", "redcap", "api", ""),
      token       = "9A81268476645C4E5F03428B8AC3AA7B",
      records     = c("1", "3", "5"),
      fields      = c("record_id", "name_first", "age", "bmi"),
      id_position = 1L,
      id_col_name = NULL
    )
    expect_type(result, "list")
    expect_length(result, 2L)
    expect_named(result, c("redcap_data", "metadata"))
    expect_type(result[["redcap_data"]], "list")
    expect_type(result[["metadata"]], "list")
    expect_length(result[["redcap_data"]], 12L)
    expect_length(result[["metadata"]], 8L)
  })

  test_that("redcap_get_results works as expected", {
    result <- redcap_get_results(
      redcap_data = REDCapR::redcap_read(
        redcap_uri  = "https://bbmc.ouhsc.edu/redcap/api/",
        token       = "9A81268476645C4E5F03428B8AC3AA7B",
        records     = c("1", "3", "5"),
        fields      = c("record_id", "name_first", "age", "bmi"),
        verbose     = FALSE,
        id_position = 1L
      ),
      metadata = REDCapR::redcap_metadata_read(
        redcap_uri = "https://bbmc.ouhsc.edu/redcap/api/",
        token      = "9A81268476645C4E5F03428B8AC3AA7B",
        fields     = NULL,
        verbose    = FALSE
      )
    )
    expect_type(result, "list")
    expect_length(result, 2L)
    expect_named(result, c("data", "meta"))
    expect_s3_class(result[["data"]], "data.frame")
    expect_s3_class(result[["meta"]], "data.frame")
  })

  test_that("redcap_get_results fails with bad redcap_data", {
    expect_error(
      redcap_get_results(
        redcap_data = NULL,
        metadata    = REDCapR::redcap_metadata_read(
          redcap_uri = "https://bbmc.ouhsc.edu/redcap/api/",
          token      = "9A81268476645C4E5F03428B8AC3AA7B",
          fields     = NULL,
          verbose    = FALSE
        )
      ),
      regexp = cat("Assertion on',redcap_data,'failed: Must be provided")
    )

    expect_error(
      redcap_get_results(
        redcap_data = NA,
        metadata    = REDCapR::redcap_metadata_read(
          redcap_uri = "https://bbmc.ouhsc.edu/redcap/api/",
          token      = "9A81268476645C4E5F03428B8AC3AA7B",
          fields     = NULL,
          verbose    = FALSE
        )
      ),
      regexp = cat("Assertion on',redcap_data,'failed: Missing value not allowed
                   for redcap_data")
    )
  })

  test_that("redcap_get_results fails with bad metadata", {
    expect_error(
      redcap_get_results(
        redcap_data = REDCapR::redcap_read(
          redcap_uri  = "https://bbmc.ouhsc.edu/redcap/api/",
          token       = "9A81268476645C4E5F03428B8AC3AA7B",
          records     = c("1", "3", "5"),
          fields      = c("record_id", "name_first", "age", "bmi"),
          verbose     = FALSE,
          id_position = 1L
        ),
        metadata = NULL
      ),
      regexp = cat("Assertion on',metadata,'failed: Must be provided")
    )

    expect_error(
      redcap_get_results(
        redcap_data = REDCapR::redcap_read(
          redcap_uri  = "https://bbmc.ouhsc.edu/redcap/api/",
          token       = "9A81268476645C4E5F03428B8AC3AA7B",
          records     = c("1", "3", "5"),
          fields      = c("record_id", "name_first", "age", "bmi"),
          verbose     = FALSE,
          id_position = 1L
        ),
        metadata = NA
      ),
      regexp = cat("Assertion on',metadata,'failed: Missing value not allowed
                   for metadata")
    )
  })

  test_that("redcap_read_data works as expected", {
    result <- redcap_read_data(
      base_url    = "https://bbmc.ouhsc.edu/redcap/api/",
      token       = "9A81268476645C4E5F03428B8AC3AA7B",
      id_position = 1L
    )
    expect_type(result, "list")
    expect_length(result, 2L)
    expect_named(result, c("redcap_data", "metadata"))
    expect_type(result[["redcap_data"]], "list")
    expect_type(result[["metadata"]], "list")
    expect_length(result[["redcap_data"]], 12L)
    expect_length(result[["metadata"]], 8L)
  })

  test_that("redcap_read_rows_columns works as expected", {
    result <- redcap_read_rows_columns(
      base_url    = "https://bbmc.ouhsc.edu/redcap/api/",
      token       = "9A81268476645C4E5F03428B8AC3AA7B",
      fields      = c("record_id", "name_first", "age", "bmi"),
      records     = c("1", "3", "5"),
      id_position = 1L,
      id_col_name = NULL
    )
    expect_type(result, "list")
    expect_length(result, 2L)
    expect_named(result, c("redcap_data", "metadata"))
    expect_type(result[["redcap_data"]], "list")
    expect_type(result[["metadata"]], "list")
    expect_length(result[["redcap_data"]], 12L)
    expect_length(result[["metadata"]], 8L)
  })

  test_that("redcap_read_fields works as expected", {
    result <- redcap_read_fields(
      base_url    = "https://bbmc.ouhsc.edu/redcap/api/",
      token       = "9A81268476645C4E5F03428B8AC3AA7B",
      fields      = c("record_id", "name_first", "age", "bmi"),
      id_position = 1L
    )
    expect_type(result, "list")
    expect_length(result, 2L)
    expect_named(result, c("redcap_data", "metadata"))
    expect_type(result[["redcap_data"]], "list")
    expect_type(result[["metadata"]], "list")
    expect_length(result[["redcap_data"]], 12L)
    expect_length(result[["metadata"]], 8L)
  })

  test_that("redcap_read_records works as expected", {
    result <- redcap_read_records(
      base_url    = "https://bbmc.ouhsc.edu/redcap/api/",
      token       = "9A81268476645C4E5F03428B8AC3AA7B",
      records     = c("1", "2", "3"),
      id_position = 1L,
      id_col_name = NULL
    )
    expect_type(result, "list")
    expect_length(result, 2L)
    expect_named(result, c("redcap_data", "metadata"))
    expect_type(result[["redcap_data"]], "list")
    expect_type(result[["metadata"]], "list")
    expect_length(result[["redcap_data"]], 12L)
    expect_length(result[["metadata"]], 8L)
  })

  test_that("redcap_read_records fails as expected", {
    expect_error(
      redcap_read_records(
        base_url    = "https://bbmc.ouhsc.edu/redcap/api/",
        token       = "9A81268476645C4E5F03428B8AC3AA7B",
        records     = c("1", "2", "3"),
        id_position = NULL,
        id_col_name = "Karim"
      ),
      regexp = cat("'Karim' is an invalid column name.")
    )
  })
})
