test_that("fingertips_subset_rows works as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  data <- readepi(
    data_source  = NULL,
    profile_id   = 19L,
    area_type_id = 102L
  )[["data"]]
  res <- fingertips_subset_rows(
    data        = data,
    records     = c("E92000001", "E12000002", "E12000009"),
    id_col_name = "AreaCode"
  )
  expect_s3_class(res, "data.frame")
  expect_length(unique(res[["AreaCode"]]), 3L)
  expect_identical(
    unique(res[["AreaCode"]]),
    c("E92000001", "E12000002", "E12000009")
  )
})

test_that("fingertips_subset_rows fails as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  data <- readepi(
    data_source  = NULL,
    profile_id   = 19L,
    area_type_id = 102L
  )[["data"]]
  expect_warning(
    fingertips_subset_rows(
      data        = data,
      records     = c("E92000001", "E12000002", "Karim"),
      id_col_name = "AreaCode"
    ),
    regexp = cat("'Karim' is not a valid record.")
  )
})

test_that("fingertips_subset_columns works as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  data <- readepi(
    data_source  = NULL, profile_id = 19L,
    area_type_id = 102L
  )[["data"]]
  res <- fingertips_subset_columns(
    data   = data,
    fields = c("IndicatorID", "AreaCode", "Age", "Value")
  )
  expect_s3_class(res, "data.frame")
  expect_named(res, c("IndicatorID", "AreaCode", "Age", "Value"))
  expect_identical(ncol(res), 4L)
})

test_that("fingertips_subset_columns fails as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  data <- readepi(
    data_source  = NULL, profile_id = 19L,
    area_type_id = 102L
  )[["data"]]
  expect_error(
    fingertips_subset_columns(
      data   = data,
      fields = c("Karim", "mane")
    ),
    regexp = cat("The provided field names are not part of the data.")
  )

  expect_warning(
    fingertips_subset_columns(
      data   = data,
      fields = c("IndicatorID", "AreaCode", "Age", "mane")
    ),
    regexp = cat("'mane' is an invalid field name.")
  )
})

httptest::with_mock_api({
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  testthat::skip_if_not_installed("httptest")
  test_that("fingertips_get_metadata works as expected", {
    metadata <- fingertips_get_metadata()
    expect_type(metadata, "list")
    expect_length(metadata, 3L)
    expect_named(metadata, c(
      "indicator_profile_domain",
      "indicator_ids_names",
      "area_type"
    ))
    expect_s3_class(metadata[["indicator_profile_domain"]], "data.frame")
    expect_s3_class(metadata[["indicator_ids_names"]], "data.frame")
    expect_s3_class(metadata[["area_type"]], "data.frame")
  })

  test_that("fingertips_get_id_from_name works as expected", {
    testthat::skip_on_cran()
    testthat::skip_if_offline()
    indicator_id <- fingertips_get_id_from_name(
      metadata       = list(
        indicator_profile_domain = fingertipsR::indicators(),
        indicator_ids_names      = fingertipsR::indicators_unique(),
        area_type                = fingertipsR::area_types()
      ),
      indicator_name = "Pupil absence"
    )
    expect_vector(indicator_id)
    expect_type(indicator_id, "integer")
    expect_length(indicator_id, 1L)
    expect_identical(indicator_id, 10301L)
  })

  test_that("fingertips_get_id_from_name fails as expected", {
    testthat::skip_on_cran()
    testthat::skip_if_offline()
    expect_error(
      fingertips_get_id_from_name(
        metadata      = list(
          indicator_profile_domain = fingertipsR::indicators(),
          indicator_ids_names      = fingertipsR::indicators_unique(),
          area_type                = fingertipsR::area_types()
        ),
        indicator_name = 10L
      ),
      regexp = cat("Indicator_name should be of type character.")
    )

    expect_error(
      fingertips_get_id_from_name(
        metadata = list(
          indicator_profile_domain = fingertipsR::indicators(),
          indicator_ids_names      = fingertipsR::indicators_unique(),
          area_type                = fingertipsR::area_types()
        ),
        indicator_name = "test"
      ),
      regexp = cat("'test' is not a valid indicator name.")
    )

    expect_warning(
      fingertips_get_id_from_name(
        metadata = list(
          indicator_profile_domain = fingertipsR::indicators(),
          indicator_ids_names      = fingertipsR::indicators_unique(),
          area_type                = fingertipsR::area_types()
        ),
        indicator_name = c("Pupil absence", "test")
      ),
      regexp = cat("'test' is not a valid indicator name.")
    )
  })

  test_that("fingertips_get_id_from_dm_id works as expected", {
    testthat::skip_on_cran()
    testthat::skip_if_offline()
    indicator_id <- fingertips_get_id_from_dm_id(
      metadata = list(
        indicator_profile_domain = fingertipsR::indicators(),
        indicator_ids_names      = fingertipsR::indicators_unique(),
        area_type                = fingertipsR::area_types()
      ),
      domain_id      = 1000041L,
      indicator_name = "Pupil absence"
    )
    expect_vector(indicator_id)
    expect_type(indicator_id, "integer")
    expect_length(indicator_id, 1L)

    indicator_id <- fingertips_get_id_from_dm_id(
      metadata = list(
        indicator_profile_domain = fingertipsR::indicators(),
        indicator_ids_names      = fingertipsR::indicators_unique(),
        area_type                = fingertipsR::area_types()
      ),
      domain_id      = 1000041L,
      indicator_name = NULL
    )
    expect_vector(indicator_id)
    expect_type(indicator_id, "integer")
    expect_length(indicator_id, 42L)
  })

  test_that("fingertips_get_id_from_dm_id works as expected", {
    testthat::skip_on_cran()
    testthat::skip_if_offline()
    expect_error(
      fingertips_get_id_from_dm_id(
        metadata = list(
          indicator_profile_domain = fingertipsR::indicators(),
          indicator_ids_names      = fingertipsR::indicators_unique(),
          area_type                = fingertipsR::area_types()
        ),
        domain_id      = 1000041L,
        indicator_name = 10L
      ),
      regexp = cat("Indicator_name should be of type character.")
    )

    expect_warning(
      fingertips_get_id_from_dm_id(
        metadata = list(
          indicator_profile_domain = fingertipsR::indicators(),
          indicator_ids_names      = fingertipsR::indicators_unique(),
          area_type                = fingertipsR::area_types()
        ),
        domain_id      = c(1000041L, 0L),
        indicator_name = NULL
      ),
      regexp = cat("'0' is an invalid domain ID.")
    )

    expect_error(
      fingertips_get_id_from_dm_id(
        metadata = list(
          indicator_profile_domain = fingertipsR::indicators(),
          indicator_ids_names      = fingertipsR::indicators_unique(),
          area_type                = fingertipsR::area_types()
        ),
        domain_id      = c(-1L, 0L),
        indicator_name = NULL
      ),
      regexp = cat("Provided domain IDs are invalid.")
    )
  })

  test_that("fingertips_get_id_from_dm_name works as expected", {
    testthat::skip_on_cran()
    testthat::skip_if_offline()
    indicator_id <- fingertips_get_id_from_dm_name(
      metadata = list(
        indicator_profile_domain = fingertipsR::indicators(),
        indicator_ids_names      = fingertipsR::indicators_unique(),
        area_type                = fingertipsR::area_types()
      ),
      domain_name    = "B. Wider determinants of health",
      indicator_name = "Pupil absence"
    )
    expect_vector(indicator_id)
    expect_type(indicator_id, "integer")
    expect_length(indicator_id, 1L)

    indicator_id <- fingertips_get_id_from_dm_name(
      metadata = list(
        indicator_profile_domain = fingertipsR::indicators(),
        indicator_ids_names      = fingertipsR::indicators_unique(),
        area_type                = fingertipsR::area_types()
      ),
      domain_name    = "B. Wider determinants of health",
      indicator_name = NULL
    )
    expect_vector(indicator_id)
    expect_type(indicator_id, "integer")
    expect_length(indicator_id, 42L)
  })

  test_that("fingertips_get_id_from_dm_name fails as expected", {
    testthat::skip_on_cran()
    testthat::skip_if_offline()
    expect_error(
      fingertips_get_id_from_dm_name(
        metadata = list(
          indicator_profile_domain = fingertipsR::indicators(),
          indicator_ids_names      = fingertipsR::indicators_unique(),
          area_type                = fingertipsR::area_types()
        ),
        domain_name    = c("Karim", "Mane"),
        indicator_name = NULL
      ),
      regexp = cat("The provided domain names are invalid.")
    )

    expect_warning(
      fingertips_get_id_from_dm_name(
        metadata = list(
          indicator_profile_domain = fingertipsR::indicators(),
          indicator_ids_names      = fingertipsR::indicators_unique(),
          area_type                = fingertipsR::area_types()
        ),
        domain_name    = c("B. Wider determinants of health", "Mane"),
        indicator_name = NULL
      ),
      regexp = cat("'Mane' is an invalid domain name.")
    )
  })

  test_that("fingertips_get_id_from_profile works as expected when all arguments
            are provided", {
              testthat::skip_on_cran()
              testthat::skip_if_offline()
              indicator_id <- fingertips_get_id_from_profile(
                metadata = list(
                  indicator_profile_domain =
                    fingertipsR::indicators(),
                  indicator_ids_names =
                    fingertipsR::indicators_unique(),
                  area_type = fingertipsR::area_types()
                ),
                domain_id      = 1000041L,
                domain_name    = "B. Wider determinants of health",
                indicator_name = "Pupil absence",
                profile_name   = "Public Health Outcomes Framework",
                profile_id     = 19L
              )
              expect_vector(indicator_id)
              expect_type(indicator_id, "integer")
              expect_length(indicator_id, 1L)
            })

  test_that("fingertips_get_id_from_profile works as expected when only the
            profile name is provided", {
              testthat::skip_on_cran()
              testthat::skip_if_offline()
              indicator_id <- fingertips_get_id_from_profile(
                metadata = list(
                  indicator_profile_domain =
                    fingertipsR::indicators(),
                  indicator_ids_names =
                    fingertipsR::indicators_unique(),
                  area_type = fingertipsR::area_types()
                ),
                domain_id      = NULL,
                domain_name    = NULL,
                indicator_name = NULL,
                profile_name   = "Public Health Outcomes Framework",
                profile_id     = NULL
              )
              expect_vector(indicator_id)
              expect_type(indicator_id, "integer")
              expect_length(indicator_id, 179L)
            })

  test_that("fingertips_get_id_from_profile works as expected when only the
            profile and indicator names is provided", {
              testthat::skip_on_cran()
              testthat::skip_if_offline()
              indicator_id <- fingertips_get_id_from_profile(
                metadata = list(
                  indicator_profile_domain =
                    fingertipsR::indicators(),
                  indicator_ids_names =
                    fingertipsR::indicators_unique(),
                  area_type = fingertipsR::area_types()
                ),
                domain_id      = NULL,
                domain_name    = NULL,
                indicator_name = "Pupil absence",
                profile_name   = "Public Health Outcomes Framework",
                profile_id     = NULL
              )
              expect_vector(indicator_id)
              expect_type(indicator_id, "integer")
              expect_length(indicator_id, 1L)
              expect_identical(indicator_id, 10301L)

              indicator_id <- fingertips_get_id_from_profile(
                metadata = list(
                  indicator_profile_domain =
                    fingertipsR::indicators(),
                  indicator_ids_names =
                    fingertipsR::indicators_unique(),
                  area_type = fingertipsR::area_types()
                ),
                domain_id      = NULL,
                domain_name    = NULL,
                indicator_name = "Pupil absence",
                profile_name   = NULL,
                profile_id     = 19L
              )
              expect_vector(indicator_id)
              expect_type(indicator_id, "integer")
              expect_length(indicator_id, 1L)
              expect_identical(indicator_id, 10301L)
            })

  test_that("fingertips_get_id_from_profile works as expected when only the
            profile name is provided", {
              testthat::skip_on_cran()
              testthat::skip_if_offline()
              indicator_id <- fingertips_get_id_from_profile(
                metadata = list(
                  indicator_profile_domain =
                    fingertipsR::indicators(),
                  indicator_ids_names =
                    fingertipsR::indicators_unique(),
                  area_type = fingertipsR::area_types()
                ),
                domain_id      = NULL,
                domain_name    = NULL,
                indicator_name = NULL,
                profile_name   = NULL,
                profile_id     = 19L
              )
              expect_vector(indicator_id)
              expect_type(indicator_id, "integer")
              expect_length(indicator_id, 179L)
            })

  test_that("fingertips_get_id_from_profile works as expected when the profile
            ID and domain name is provided", {
              testthat::skip_on_cran()
              testthat::skip_if_offline()
              indicator_id <- fingertips_get_id_from_profile(
                metadata = list(
                  indicator_profile_domain =
                    fingertipsR::indicators(),
                  indicator_ids_names =
                    fingertipsR::indicators_unique(),
                  area_type = fingertipsR::area_types()
                ),
                domain_id      = NULL,
                domain_name    = "B. Wider determinants of health",
                indicator_name = NULL,
                profile_name   = NULL,
                profile_id     = 19L
              )
              expect_vector(indicator_id)
              expect_type(indicator_id, "integer")
              expect_length(indicator_id, 42L)
            })

  test_that("fingertips_get_id_from_profile works as expected when the profile
            ID and domain name is provided", {
              testthat::skip_on_cran()
              testthat::skip_if_offline()
              indicator_id <- fingertips_get_id_from_profile(
                metadata = list(
                  indicator_profile_domain =
                    fingertipsR::indicators(),
                  indicator_ids_names =
                    fingertipsR::indicators_unique(),
                  area_type = fingertipsR::area_types()
                ),
                domain_id      = 1000041L,
                domain_name    = NULL,
                indicator_name = NULL,
                profile_name   = NULL,
                profile_id     = 19L
              )
              expect_vector(indicator_id)
              expect_type(indicator_id, "integer")
              expect_length(indicator_id, 42L)
            })

  test_that("fingertips_get_id_from_profile fails as expected", {
    testthat::skip_on_cran()
    testthat::skip_if_offline()
    expect_error(
      fingertips_get_id_from_profile(
        metadata = list(
          indicator_profile_domain = fingertipsR::indicators(),
          indicator_ids_names      = fingertipsR::indicators_unique(),
          area_type                = fingertipsR::area_types()
        ),
        domain_id = NULL,
        domain_name = NULL,
        indicator_name = NULL,
        profile_name = "Karim",
        profile_id = NULL
      ),
      regexp = cat("'Karim' is an invalid profile name.")
    )
  })

  test_that("fingertips_get_profile_name works as expected", {
    testthat::skip_on_cran()
    testthat::skip_if_offline()
    res <- fingertips_get_profile_name(
      profile_id   = 19L,
      profile_name = "Public Health Outcomes Framework",
      metadata = list(
        indicator_profile_domain = fingertipsR::indicators(),
        indicator_ids_names      = fingertipsR::indicators_unique(),
        area_type                = fingertipsR::area_types()
      )
    )
    expect_type(res, "list")
    expect_length(res, 2L)
    expect_named(res, c("profile_name", "profile_index"))
    expect_type(res[["profile_name"]], "character")
    expect_identical(res[["profile_name"]], "Public Health Outcomes Framework")
    expect_vector(res[["profile_index"]])
    expect_type(res[["profile_index"]], "integer")
    expect_length(res[["profile_index"]], 179L)
  })
})
