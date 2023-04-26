test_that("read_from_fingertips works", {
  data <- read_from_fingertips(
    indicator_id = 90362, indicator_name = "Healthy life expectancy at birth",
    area_type_id = 202, parent_area_type_id = 6,
    profile_id = 19, profile_name = "Public Health Outcomes Framework",
    domain_id = 1000049, domain_name = "A. Overarching indicators",
    fields = NULL, records = NULL,
    id_position = NULL, id_col_name = NULL
  )
  expect_type(data, type = "list")
  expect_length(data, 1)
  expect_named(data, "data")
  expect_s3_class(data$data, "data.frame")

  data <- read_from_fingertips(
    indicator_id = 90362, indicator_name = NULL,
    area_type_id = 202, parent_area_type_id = NULL,
    profile_id = NULL, profile_name = NULL,
    domain_id = NULL, domain_name = NULL,
    fields = NULL, records = NULL,
    id_position = NULL, id_col_name = NULL
  )
  expect_type(data, type = "list")
  expect_length(data, 1)
  expect_named(data, "data")
  expect_s3_class(data$data, "data.frame")

  data <- read_from_fingertips(
    indicator_id = c(90362, 90283), indicator_name = NULL,
    area_type_id = 202, parent_area_type_id = NULL,
    profile_id = NULL, profile_name = NULL,
    domain_id = NULL, domain_name = NULL,
    fields = NULL, records = NULL,
    id_position = NULL, id_col_name = NULL
  )
  expect_type(data, type = "list")
  expect_length(data, 1)
  expect_named(data, "data")
  expect_s3_class(data$data, "data.frame")

  data <- read_from_fingertips(
    indicator_id = 90362, indicator_name = NULL,
    area_type_id = 202, parent_area_type_id = NULL,
    profile_id = NULL, profile_name = NULL,
    domain_id = NULL, domain_name = NULL,
    fields = NULL, records = c("E92000001", "E12000002"),
    id_position = NULL, id_col_name = "AreaCode"
  )
  expect_type(data, type = "list")
  expect_length(data, 1)
  expect_named(data, "data")
  expect_s3_class(data$data, "data.frame")

  data <- read_from_fingertips(
    indicator_id = 90362, indicator_name = NULL,
    area_type_id = 202, parent_area_type_id = NULL,
    profile_id = NULL, profile_name = NULL,
    domain_id = NULL, domain_name = NULL,
    fields = c("IndicatorID", "AreaCode", "Age", "Value"), records = NULL,
    id_position = NULL, id_col_name = NULL
  )
  expect_type(data, type = "list")
  expect_length(data, 1)
  expect_named(data, "data")
  expect_s3_class(data$data, "data.frame")

  data <- read_from_fingertips(
    indicator_id = 90362, indicator_name = NULL,
    area_type_id = 202, parent_area_type_id = NULL,
    profile_id = NULL, profile_name = NULL,
    domain_id = NULL, domain_name = NULL,
    fields = c("IndicatorID", "AreaCode", "Age", "Value"),
    records = c("E92000001", "E12000002", "E12000009"),
    id_position = NULL, id_col_name = "AreaCode"
  )
  expect_type(data, type = "list")
  expect_length(data, 1)
  expect_named(data, "data")
  expect_s3_class(data$data, "data.frame")
})

test_that("read_from_fingertips works when only indicator name is provided", {
  data <- read_from_fingertips(
    indicator_id = NULL, indicator_name = "Pupil absence",
    area_type_id = 202, parent_area_type_id = NULL,
    profile_id = NULL, profile_name = NULL,
    domain_id = 1000041, domain_name = NULL,
    fields = NULL, records = NULL,
    id_position = NULL, id_col_name = NULL
  )
  expect_type(data, type = "list")
  expect_length(data, 1)
  expect_named(data, "data")
  expect_s3_class(data$data, "data.frame")

  data <- read_from_fingertips(
    indicator_id = NULL, indicator_name = "Pupil absence",
    area_type_id = 202, parent_area_type_id = 6,
    profile_id = NULL, profile_name = NULL,
    domain_id = 1000041, domain_name = NULL,
    fields = NULL, records = NULL,
    id_position = NULL, id_col_name = NULL
  )
  expect_type(data, type = "list")
  expect_length(data, 1)
  expect_named(data, "data")
  expect_s3_class(data$data, "data.frame")
})

test_that("read_from_fingertips works with domain name or ID", {
  data <- read_from_fingertips(
    indicator_id = NULL, indicator_name = "Pupil absence",
    area_type_id = 202, parent_area_type_id = NULL,
    profile_id = NULL, profile_name = NULL,
    domain_id = NULL, domain_name = "B. Wider determinants of health",
    fields = NULL, records = NULL,
    id_position = NULL, id_col_name = NULL
  )
  expect_type(data, type = "list")
  expect_length(data, 1)
  expect_named(data, "data")
  expect_s3_class(data$data, "data.frame")

  data <- read_from_fingertips(
    indicator_id = NULL, indicator_name = "Pupil absence",
    area_type_id = 202, parent_area_type_id = NULL,
    profile_id = NULL, profile_name = NULL,
    domain_id = 1000049, domain_name = NULL,
    fields = NULL, records = NULL,
    id_position = NULL, id_col_name = NULL
  )
  expect_type(data, type = "list")
  expect_length(data, 1)
  expect_named(data, "data")
  expect_s3_class(data$data, "data.frame")
})

test_that("read_from_fingertips works with profile name or ID", {
  data <- read_from_fingertips(
    indicator_id = NULL, indicator_name = "Pupil absence",
    area_type_id = 202, parent_area_type_id = NULL,
    profile_id = 19, profile_name = NULL,
    domain_id = NULL, domain_name = NULL,
    fields = NULL, records = NULL,
    id_position = NULL, id_col_name = NULL
  )
  expect_type(data, type = "list")
  expect_length(data, 1)
  expect_named(data, "data")
  expect_s3_class(data$data, "data.frame")

  data <- read_from_fingertips(
    indicator_id = NULL, indicator_name = "Pupil absence",
    area_type_id = 202, parent_area_type_id = NULL,
    profile_id = NULL, profile_name = "Public Health Outcomes Framework",
    domain_id = NULL, domain_name = NULL,
    fields = NULL, records = NULL,
    id_position = NULL, id_col_name = NULL
  )
  expect_type(data, type = "list")
  expect_length(data, 1)
  expect_named(data, "data")
  expect_s3_class(data$data, "data.frame")
})


test_that("read_from_fingertips fails with bad indicator ID", {
  expect_error(
    data = read_from_fingertips(
      indicator_id = NA, indicator_name = NULL,
      area_type_id = 202, parent_area_type_id = NULL,
      profile_id = NULL, profile_name = NULL,
      domain_id = NULL, domain_name = NULL,
      fields = NULL, records = NULL,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',indicator_id,'failed: Missing value
                 not allowed.")
  )

  expect_error(
    data = read_from_fingertips(
      indicator_id = "90362", indicator_name = NULL,
      area_type_id = 202, parent_area_type_id = NULL,
      profile_id = NULL, profile_name = NULL,
      domain_id = NULL, domain_name = NULL,
      fields = NULL, records = NULL,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',indicator_id,'failed: Must be of type numeric.")
  )
})

test_that("read_from_fingertips fails with bad indicator name", {
  expect_error(
    data = read_from_fingertips(
      indicator_id = 90362, indicator_name = NA,
      area_type_id = 202, parent_area_type_id = NULL,
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
  expect_error(
    data = read_from_fingertips(
      indicator_id = 90362, indicator_name = NULL,
      area_type_id = NA, parent_area_type_id = NULL,
      profile_id = NULL, profile_name = NULL,
      domain_id = NULL, domain_name = NULL,
      fields = NULL, records = NULL,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',area_type_id,'failed: Missing value
                 not allowed.")
  )

  expect_error(
    data = read_from_fingertips(
      indicator_id = 90362, indicator_name = NULL,
      area_type_id = "202", parent_area_type_id = NULL,
      profile_id = NULL, profile_name = NULL,
      domain_id = NULL, domain_name = NULL,
      fields = NULL, records = NULL,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',area_type_id,'failed: Must be of type numeric.")
  )
})

test_that("read_from_fingertips fails with bad parent area type ID", {
  expect_error(
    data = read_from_fingertips(
      indicator_id = 90362, indicator_name = NULL,
      area_type_id = 202, parent_area_type_id = NA,
      profile_id = NULL, profile_name = NULL,
      domain_id = NULL, domain_name = NULL,
      fields = NULL, records = NULL,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',parent_area_type_id,'failed: Missing value
                 not allowed.")
  )

  expect_error(
    data = read_from_fingertips(
      indicator_id = 90362, indicator_name = NULL,
      area_type_id = 202, parent_area_type_id = "6",
      profile_id = NULL, profile_name = NULL,
      domain_id = NULL, domain_name = NULL,
      fields = NULL, records = NULL,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',parent_area_type_id,'failed: Must be of
                 type numeric.")
  )
})

test_that("read_from_fingertips fails with bad profile ID", {
  expect_error(
    data = read_from_fingertips(
      indicator_id = 10301, indicator_name = NULL,
      area_type_id = 202, parent_area_type_id = NULL,
      profile_id = NA, profile_name = NULL,
      domain_id = NULL, domain_name = NULL,
      fields = NULL, records = NULL,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',profile_id,'failed: Missing value not allowed.")
  )

  expect_error(
    data = read_from_fingertips(
      indicator_id = 10301, indicator_name = NULL,
      area_type_id = 202, parent_area_type_id = NULL,
      profile_id = "19", profile_name = NULL,
      domain_id = NULL, domain_name = NULL,
      fields = NULL, records = NULL,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',profile_id,'failed: Must be of type numeric.")
  )
})

test_that("read_from_fingertips fails with bad profile name", {
  expect_error(
    data = read_from_fingertips(
      indicator_id = 10301, indicator_name = NULL,
      area_type_id = 202, parent_area_type_id = NULL,
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
  expect_error(
    data = read_from_fingertips(
      indicator_id = 10301, indicator_name = NULL,
      area_type_id = 202, parent_area_type_id = NULL,
      profile_id = NULL, profile_name = NULL,
      domain_id = NA, domain_name = NULL,
      fields = NULL, records = NULL,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',domain_id,'failed: Missing value not allowed.")
  )

  expect_error(
    data = read_from_fingertips(
      indicator_id = 10301, indicator_name = NULL,
      area_type_id = 202, parent_area_type_id = NULL,
      profile_id = NULL, profile_name = NULL,
      domain_id = "1000041", domain_name = NULL,
      fields = NULL, records = NULL,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',domain_id,'failed: Must be of type numeric.")
  )
})

test_that("read_from_fingertips fails with bad domain name", {
  expect_error(
    data = read_from_fingertips(
      indicator_id = 10301, indicator_name = NULL,
      area_type_id = 202, parent_area_type_id = NULL,
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
  expect_error(
    data = read_from_fingertips(
      indicator_id = 10301, indicator_name = NULL,
      area_type_id = 202, parent_area_type_id = NULL,
      profile_id = NULL, profile_name = NULL,
      domain_id = NULL, domain_name = NULL,
      fields = NULL, records = NA,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',records,'failed: Missing value not allowed.")
  )
})

test_that("read_from_fingertips fails with bad fields", {
  expect_error(
    data = read_from_fingertips(
      indicator_id = 10301, indicator_name = NULL,
      area_type_id = 202, parent_area_type_id = NULL,
      profile_id = NULL, profile_name = NULL,
      domain_id = NULL, domain_name = NULL,
      fields = NA, records = NULL,
      id_position = NULL, id_col_name = NULL
    ),
    regexp = cat("Assertion on',fields,'failed: Missing value not allowed.")
  )
})
