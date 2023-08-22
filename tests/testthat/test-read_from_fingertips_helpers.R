data <- readepi(source = NULL, profile_id = 19, area_type_id = 202)$data

test_that("fingertips_subset_rows works as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  res <- fingertips_subset_rows(
    data    = data,
    records = c("E92000001", "E12000002", "E12000009"),
    id_col_name = "AreaCode"
  )
  expect_s3_class(res, "data.frame")
  expect_length(unique(res$AreaCode), 3)
  expect_identical(unique(res$AreaCode),
                   c("E92000001", "E12000002", "E12000009"))
})

test_that("fingertips_subset_columns works as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  res <- fingertips_subset_columns(
    data   = data,
    fields = c("IndicatorID", "AreaCode", "Age", "Value")
  )
  expect_s3_class(res, "data.frame")
  expect_named(res, c("IndicatorID", "AreaCode", "Age", "Value"))
  expect_identical(ncol(res), 4L)
})

httptest::with_mock_api({
  test_that("get_fingertips_metadata works as expected", {
    metadata <- get_fingertips_metadata()
    expect_type(metadata, "list")
    expect_length(metadata, 3)
    expect_named(metadata, c("indicator_profile_domain",
                             "indicator_ids_names",
                             "area_type"))
    expect_s3_class(metadata$indicator_profile_domain, "data.frame")
    expect_s3_class(metadata$indicator_ids_names, "data.frame")
    expect_s3_class(metadata$area_type, "data.frame")
  })

  test_that("get_ind_id_from_ind_name works as expected", {
    indicator_id <- get_ind_id_from_ind_name(
      metadata = list(
        indicator_profile_domain = fingertipsR::indicators(),
        indicator_ids_names      = fingertipsR::indicators_unique(),
        area_type                = fingertipsR::area_types()),
      indicator_name = "Pupil absence"
    )
    expect_vector(indicator_id)
    expect_type(indicator_id, "integer")
    expect_length(indicator_id, 1)
    expect_identical(indicator_id, 10301L)
  })

  test_that("get_ind_id_from_ind_name fails with numeric indicator_name", {
    expect_error(
      get_ind_id_from_ind_name(
        metadata       = list(
          indicator_profile_domain = fingertipsR::indicators(),
          indicator_ids_names      = fingertipsR::indicators_unique(),
          area_type                = fingertipsR::area_types()),
        indicator_name = 10
      ),
      regexp = cat("Indicator_name should be of type character.")
    )
  })

  test_that("get_ind_id_from_domain_id works as expected", {
    indicator_id <- get_ind_id_from_domain_id(
      metadata       = list(
        indicator_profile_domain = fingertipsR::indicators(),
        indicator_ids_names      = fingertipsR::indicators_unique(),
        area_type                = fingertipsR::area_types()),
      domain_id      = 1000041,
      indicator_name = "Pupil absence"
    )
    expect_vector(indicator_id)
    expect_type(indicator_id, "integer")
    expect_length(indicator_id, 1)

    indicator_id <- get_ind_id_from_domain_id(
      metadata       = list(
        indicator_profile_domain = fingertipsR::indicators(),
        indicator_ids_names      = fingertipsR::indicators_unique(),
        area_type                = fingertipsR::area_types()),
      domain_id      = 1000041,
      indicator_name = NULL
    )
    expect_vector(indicator_id)
    expect_type(indicator_id, "integer")
    expect_length(indicator_id, 42)
  })

  test_that("get_ind_id_from_domain_id works as expected", {
    expect_error(
      get_ind_id_from_domain_id(
        metadata = list(
          indicator_profile_domain = fingertipsR::indicators(),
          indicator_ids_names = fingertipsR::indicators_unique(),
          area_type = fingertipsR::area_types()),
        domain_id = 1000041,
        indicator_name = 10
      ),
      regexp = cat("Indicator_name should be of type character.")
    )
  })

  test_that("get_ind_id_from_domain_name works as expected", {
    indicator_id <- get_ind_id_from_domain_name(
      metadata = list(
        indicator_profile_domain = fingertipsR::indicators(),
        indicator_ids_names = fingertipsR::indicators_unique(),
        area_type = fingertipsR::area_types()),
      domain_name = "B. Wider determinants of health",
      indicator_name = "Pupil absence"
    )
    expect_vector(indicator_id)
    expect_type(indicator_id, "integer")
    expect_length(indicator_id, 1)

    indicator_id <- get_ind_id_from_domain_name(
      metadata = list(
        indicator_profile_domain = fingertipsR::indicators(),
        indicator_ids_names = fingertipsR::indicators_unique(),
        area_type = fingertipsR::area_types()),
      domain_name = "B. Wider determinants of health",
      indicator_name = NULL
    )
    expect_vector(indicator_id)
    expect_type(indicator_id, "integer")
    expect_length(indicator_id, 42)
  })

  test_that("get_ind_id_from_profile works as expected when all arguments are
            provided", {
    indicator_id <- get_ind_id_from_profile(
      metadata = list(
        indicator_profile_domain = fingertipsR::indicators(),
        indicator_ids_names = fingertipsR::indicators_unique(),
        area_type = fingertipsR::area_types()),
      domain_id = 1000041,
      domain_name = "B. Wider determinants of health",
      indicator_name = "Pupil absence",
      profile_name = "Public Health Outcomes Framework",
      profile_id = 19
    )
    expect_vector(indicator_id)
    expect_type(indicator_id, "integer")
    expect_length(indicator_id, 1)
  })

  test_that("get_ind_id_from_profile works as expected when only the profile
            name is provided", {
              indicator_id <- get_ind_id_from_profile(
                metadata = list(
                  indicator_profile_domain = fingertipsR::indicators(),
                  indicator_ids_names = fingertipsR::indicators_unique(),
                  area_type = fingertipsR::area_types()),
                domain_id = NULL,
                domain_name = NULL,
                indicator_name = NULL,
                profile_name = "Public Health Outcomes Framework",
                profile_id = NULL
              )
              expect_vector(indicator_id)
              expect_type(indicator_id, "integer")
              expect_length(indicator_id, 179)
  })

  test_that("get_ind_id_from_profile works as expected when only the profile
            and indicator names is provided", {
              indicator_id <- get_ind_id_from_profile(
                metadata = list(
                  indicator_profile_domain = fingertipsR::indicators(),
                  indicator_ids_names = fingertipsR::indicators_unique(),
                  area_type = fingertipsR::area_types()),
                domain_id = NULL,
                domain_name = NULL,
                indicator_name = "Pupil absence",
                profile_name = "Public Health Outcomes Framework",
                profile_id = NULL
              )
              expect_vector(indicator_id)
              expect_type(indicator_id, "integer")
              expect_length(indicator_id, 1)
              expect_identical(indicator_id, 10301L)

              indicator_id <- get_ind_id_from_profile(
                metadata = list(
                  indicator_profile_domain = fingertipsR::indicators(),
                  indicator_ids_names = fingertipsR::indicators_unique(),
                  area_type = fingertipsR::area_types()),
                domain_id = NULL,
                domain_name = NULL,
                indicator_name = "Pupil absence",
                profile_name = NULL,
                profile_id = 19
              )
              expect_vector(indicator_id)
              expect_type(indicator_id, "integer")
              expect_length(indicator_id, 1)
              expect_identical(indicator_id, 10301L)
  })

  test_that("get_ind_id_from_profile works as expected when only the profile
            name is provided", {
    indicator_id <- get_ind_id_from_profile(
      metadata = list(
        indicator_profile_domain = fingertipsR::indicators(),
        indicator_ids_names = fingertipsR::indicators_unique(),
        area_type = fingertipsR::area_types()),
      domain_id = NULL,
      domain_name = NULL,
      indicator_name = NULL,
      profile_name = NULL,
      profile_id = 19
    )
    expect_vector(indicator_id)
    expect_type(indicator_id, "integer")
    expect_length(indicator_id, 179)
  })

  test_that("get_ind_id_from_profile works as expected when the profile ID and
            domain name is provided", {
              indicator_id <- get_ind_id_from_profile(
                metadata = list(
                  indicator_profile_domain = fingertipsR::indicators(),
                  indicator_ids_names = fingertipsR::indicators_unique(),
                  area_type = fingertipsR::area_types()),
                domain_id = NULL,
                domain_name = "B. Wider determinants of health",
                indicator_name = NULL,
                profile_name = NULL,
                profile_id = 19
              )
              expect_vector(indicator_id)
              expect_type(indicator_id, "integer")
              expect_length(indicator_id, 42)
  })

  test_that("get_ind_id_from_profile works as expected when the profile ID and
            domain name is provided", {
              indicator_id <- get_ind_id_from_profile(
                metadata = list(
                  indicator_profile_domain = fingertipsR::indicators(),
                  indicator_ids_names = fingertipsR::indicators_unique(),
                  area_type = fingertipsR::area_types()),
                domain_id = 1000041,
                domain_name = NULL,
                indicator_name = NULL,
                profile_name = NULL,
                profile_id = 19
              )
              expect_vector(indicator_id)
              expect_type(indicator_id, "integer")
              expect_length(indicator_id, 42)
            })

  test_that("get_profile_name works as expected", {
    res <- get_profile_name(
      profile_id = 19,
      profile_name = "Public Health Outcomes Framework",
      metadata = list(
        indicator_profile_domain = fingertipsR::indicators(),
        indicator_ids_names = fingertipsR::indicators_unique(),
        area_type = fingertipsR::area_types())
    )
    expect_type(res, "list")
    expect_length(res, 2)
    expect_named(res, c("profile_name", "profile_index"))
    expect_type(res$profile_name, "character")
    expect_identical(res$profile_name, "Public Health Outcomes Framework")
    expect_vector(res$profile_index)
    expect_type(res$profile_index, "integer")
    expect_length(res$profile_index, 179)
  })
})
