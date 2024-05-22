
test_that("read_from_fingertips works", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  data <- read_from_fingertips(
    indicator_id = 90362L, indicator_name = "Healthy life expectancy at birth",
    area_type_id = 6L, parent_area_type_id = NULL,
    profile_id = 19L, profile_name = "Public Health Outcomes Framework",
    domain_id = 1000049L, domain_name = "A. Overarching indicators",
    fields = NULL, records = NULL,
    id_position = NULL, id_col_name = NULL
  )
  expect_type(data, type = "list")
  expect_length(data, 2L)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data[["data"]], "data.frame")
  expect_identical(data[["metadata"]], NA)

  data <- read_from_fingertips(
    indicator_id = 90362L, indicator_name = NULL,
    area_type_id = 6L, parent_area_type_id = NULL,
    profile_id = NULL, profile_name = NULL,
    domain_id = NULL, domain_name = NULL,
    fields = NULL, records = NULL,
    id_position = NULL, id_col_name = NULL
  )
  expect_type(data, type = "list")
  expect_length(data, 2L)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data[["data"]], "data.frame")
  expect_identical(data[["metadata"]], NA)

  data <- read_from_fingertips(
    indicator_id = c(90362L, 90283L), indicator_name = NULL,
    area_type_id = 6L, parent_area_type_id = NULL,
    profile_id = NULL, profile_name = NULL,
    domain_id = NULL, domain_name = NULL,
    fields = NULL, records = NULL,
    id_position = NULL, id_col_name = NULL
  )
  expect_type(data, type = "list")
  expect_length(data, 2L)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data[["data"]], "data.frame")
  expect_identical(data[["metadata"]], NA)

  data <- read_from_fingertips(
    indicator_id = 90362L, indicator_name = NULL,
    area_type_id = 6L, parent_area_type_id = NULL,
    profile_id = NULL, profile_name = NULL,
    domain_id = NULL, domain_name = NULL,
    fields = NULL, records = c("E92000001", "E12000002"),
    id_position = NULL, id_col_name = "AreaCode"
  )
  expect_type(data, type = "list")
  expect_length(data, 2L)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data[["data"]], "data.frame")
  expect_identical(data[["metadata"]], NA)

  data <- read_from_fingertips(
    indicator_id = 90362L, indicator_name = NULL,
    area_type_id = 6L, parent_area_type_id = NULL,
    profile_id = NULL, profile_name = NULL,
    domain_id = NULL, domain_name = NULL,
    fields = c("IndicatorID", "AreaCode", "Age", "Value"), records = NULL,
    id_position = NULL, id_col_name = NULL
  )
  expect_type(data, type = "list")
  expect_length(data, 2L)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data[["data"]], "data.frame")
  expect_identical(data[["metadata"]], NA)

  data <- read_from_fingertips(
    indicator_id = 90362L, indicator_name = NULL,
    area_type_id = 6L, parent_area_type_id = NULL,
    profile_id = NULL, profile_name = NULL,
    domain_id = NULL, domain_name = NULL,
    fields = c("IndicatorID", "AreaCode", "Age", "Value"),
    records = c("E92000001", "E12000002", "E12000009"),
    id_position = NULL, id_col_name = "AreaCode"
  )
  expect_type(data, type = "list")
  expect_length(data, 2L)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data[["data"]], "data.frame")
  expect_identical(data[["metadata"]], NA)
})


test_that("read_from_fingertips fails with bad indicator ID", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  expect_error(
    read_from_fingertips(
      indicator_id = NA, indicator_name = NULL,
      area_type_id = 102L, parent_area_type_id = NULL,
      profile_id = NULL, profile_name = NULL,
      domain_id = NULL, domain_name = NULL,
      fields = NULL, records = NULL,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',indicator_id,'failed: Missing value
                 not allowed.")
  )
})

test_that("read_from_fingertips fails with bad indicator name", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  expect_error(
    read_from_fingertips(
      indicator_id = 90362L, indicator_name = NA,
      area_type_id = 102L, parent_area_type_id = NULL,
      profile_id = NULL, profile_name = NULL,
      domain_id = NULL, domain_name = NULL,
      fields = NULL, records = NULL,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',indicator_name,'failed: Missing value
                 not allowed.")
  )
})

test_that("read_from_fingertips fails with bad area type ID", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  expect_error(
    read_from_fingertips(
      indicator_id = 90362L, indicator_name = NULL,
      area_type_id = NA, parent_area_type_id = NULL,
      profile_id = NULL, profile_name = NULL,
      domain_id = NULL, domain_name = NULL,
      fields = NULL, records = NULL,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',area_type_id,'failed: Missing value
                 not allowed.")
  )
})

test_that("read_from_fingertips fails with bad parent area type ID", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  expect_error(
    read_from_fingertips(
      indicator_id = 90362L, indicator_name = NULL,
      area_type_id = 102L, parent_area_type_id = NA,
      profile_id = NULL, profile_name = NULL,
      domain_id = NULL, domain_name = NULL,
      fields = NULL, records = NULL,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',parent_area_type_id,'failed: Missing value
                 not allowed.")
  )
})

test_that("read_from_fingertips fails with bad profile ID", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  expect_error(
    read_from_fingertips(
      indicator_id = 10301L, indicator_name = NULL,
      area_type_id = 102L, parent_area_type_id = NULL,
      profile_id = NA, profile_name = NULL,
      domain_id = NULL, domain_name = NULL,
      fields = NULL, records = NULL,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',profile_id,'failed: Missing value not
                 allowed.")
  )

  expect_error(
    read_from_fingertips(
      indicator_id = 10301L, indicator_name = NULL,
      area_type_id = 102L, parent_area_type_id = NULL,
      profile_id = "19", profile_name = NULL,
      domain_id = NULL, domain_name = NULL,
      fields = NULL, records = NULL,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',profile_id,'failed: Must be of type numeric.")
  )
})

test_that("read_from_fingertips fails with bad profile name", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  expect_error(
    read_from_fingertips(
      indicator_id = 10301L, indicator_name = NULL,
      area_type_id = 102L, parent_area_type_id = NULL,
      profile_id = NULL, profile_name = NA,
      domain_id = NULL, domain_name = NULL,
      fields = NULL, records = NULL,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',profile_name,'failed: Missing value
                 not allowed.")
  )
})

test_that("read_from_fingertips fails with bad domain ID", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  expect_error(
    read_from_fingertips(
      indicator_id = 10301L, indicator_name = NULL,
      area_type_id = 102L, parent_area_type_id = NULL,
      profile_id = NULL, profile_name = NULL,
      domain_id = NA, domain_name = NULL,
      fields = NULL, records = NULL,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',domain_id,'failed: Missing value not
                 allowed.")
  )

  expect_error(
    read_from_fingertips(
      indicator_id = 10301L, indicator_name = NULL,
      area_type_id = 102L, parent_area_type_id = NULL,
      profile_id = NULL, profile_name = NULL,
      domain_id = "1000041", domain_name = NULL,
      fields = NULL, records = NULL,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',domain_id,'failed: Must be of type numeric.")
  )
})

test_that("read_from_fingertips fails with bad domain name", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  expect_error(
    read_from_fingertips(
      indicator_id = 10301L, indicator_name = NULL,
      area_type_id = 102L, parent_area_type_id = NULL,
      profile_id = NULL, profile_name = NULL,
      domain_id = NULL, domain_name = NA,
      fields = NULL, records = NULL,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',domain_name,'failed: Missing value
                 not allowed.")
  )
})

test_that("read_from_fingertips fails with bad records", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  expect_error(
    read_from_fingertips(
      indicator_id = 10301L, indicator_name = NULL,
      area_type_id = 102L, parent_area_type_id = NULL,
      profile_id = NULL, profile_name = NULL,
      domain_id = NULL, domain_name = NULL,
      fields = NULL, records = NA,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',records,'failed: Missing value not allowed.")
  )
})

test_that("read_from_fingertips fails with bad fields", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  expect_error(
    read_from_fingertips(
      indicator_id = 10301L, indicator_name = NULL,
      area_type_id = 102L, parent_area_type_id = NULL,
      profile_id = NULL, profile_name = NULL,
      domain_id = NULL, domain_name = NULL,
      fields = NA, records = NULL,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',fields,'failed: Missing value not allowed.")
  )
})

test_that("read_from_fingertips fails when no argument is provided", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  expect_error(
    read_from_fingertips(
      indicator_id = NULL, indicator_name = NULL,
      area_type_id = NULL, parent_area_type_id = NULL,
      profile_id = NULL, profile_name = NULL,
      domain_id = NULL, domain_name = NULL,
      fields = NULL, records = NULL,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',Fingertips arguments,'failed: Must provide a
                 value for the area_type_id and one of the remaining
                 arguments.")
  )
})

test_that("read_from_fingertips fails when the area_type_id is not provided", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  expect_error(
    read_from_fingertips(
      indicator_id = 10301L, indicator_name = NULL,
      area_type_id = NULL, parent_area_type_id = NULL,
      profile_id = NULL, profile_name = NULL,
      domain_id = NULL, domain_name = NULL,
      fields = NA, records = NULL,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',area_type_id,'failed: Must be provided.")
  )
})
