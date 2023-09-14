test_that("get_fingertips_metadata works as expected", {
  metadata <- get_fingertips_metadata()
  expect_type(metadata, "list")
  expect_length(metadata, 3)
  expect_named(metadata, c("indicator_profile_domain", "indicator_ids_names",
                           "area_type"))
  expect_s3_class(metadata$indicator_profile_domain, "data.frame")
  expect_s3_class(metadata$indicator_ids_names, "data.frame")
  expect_s3_class(metadata$area_type, "data.frame")
})

test_that("get_ind_id_from_ind_name works as expected", {
  indicator_id <- get_ind_id_from_ind_name(
    metadata = list(
      indicator_profile_domain = fingertipsR::indicators(),
      indicator_ids_names = fingertipsR::indicators_unique(),
      area_type = fingertipsR::area_types()
    ),
    indicator_name = "Pupil absence"
  )
  expect_vector(indicator_id)
})

test_that("get_ind_id_from_domain_id works as expected", {
  indicator_id <- get_ind_id_from_domain_id(
    metadata = list(
      indicator_profile_domain = fingertipsR::indicators(),
      indicator_ids_names = fingertipsR::indicators_unique(),
      area_type = fingertipsR::area_types()
    ),
    domain_id = 1000041,
    indicator_name = "Pupil absence"
  )
  expect_vector(indicator_id)

  indicator_id <- get_ind_id_from_domain_id(
    metadata = list(
      indicator_profile_domain = fingertipsR::indicators(),
      indicator_ids_names = fingertipsR::indicators_unique(),
      area_type = fingertipsR::area_types()
    ),
    domain_id = 1000041,
    indicator_name = NULL
  )
  expect_vector(indicator_id)
})


test_that("get_ind_id_from_domain_name works as expected", {
  indicator_id <- get_ind_id_from_domain_name(
    metadata = list(
      indicator_profile_domain = fingertipsR::indicators(),
      indicator_ids_names = fingertipsR::indicators_unique(),
      area_type = fingertipsR::area_types()
    ),
    domain_name = "B. Wider determinants of health",
    indicator_name = "Pupil absence"
  )
  expect_vector(indicator_id)

  indicator_id <- get_ind_id_from_domain_name(
    metadata = list(
      indicator_profile_domain = fingertipsR::indicators(),
      indicator_ids_names = fingertipsR::indicators_unique(),
      area_type = fingertipsR::area_types()
    ),
    domain_name = "B. Wider determinants of health",
    indicator_name = NULL
  )
  expect_vector(indicator_id)
})

test_that("get_ind_id_from_profile works as expected", {
  indicator_id <- get_ind_id_from_profile(
    metadata = list(
      indicator_profile_domain = fingertipsR::indicators(),
      indicator_ids_names = fingertipsR::indicators_unique(),
      area_type = fingertipsR::area_types()
    ),
    domain_id = 1000041,
    domain_name = "B. Wider determinants of health",
    indicator_name = "Pupil absence",
    profile_name = "Public Health Outcomes Framework",
    profile_id = 19
  )
  expect_vector(indicator_id)

  indicator_id <- get_ind_id_from_profile(
    metadata = list(
      indicator_profile_domain = fingertipsR::indicators(),
      indicator_ids_names = fingertipsR::indicators_unique(),
      area_type = fingertipsR::area_types()
    ),
    domain_id = NULL,
    domain_name = NULL,
    indicator_name = NULL,
    profile_name = "Public Health Outcomes Framework",
    profile_id = NULL
  )
  expect_vector(indicator_id)

  indicator_id <- get_ind_id_from_profile(
    metadata = list(
      indicator_profile_domain = fingertipsR::indicators(),
      indicator_ids_names = fingertipsR::indicators_unique(),
      area_type = fingertipsR::area_types()
    ),
    domain_id = NULL,
    domain_name = NULL,
    indicator_name = NULL,
    profile_name = NULL,
    profile_id = 19
  )
  expect_vector(indicator_id)
})

test_that("get_profile_name works as expected", {
  res <- get_profile_name(profile_id = 19,
                          profile_name = "Public Health Outcomes Framework",
                          metadata = list(
                          indicator_profile_domain = fingertipsR::indicators(),
                        indicator_ids_names = fingertipsR::indicators_unique(),
                            area_type = fingertipsR::area_types()
                          ))
  expect_type(res, "list")
  expect_length(res, 2)
  expect_type(res[[1]], "character")
  expect_type(res[[2]], "integer")
})

test_that("fingertips_subset_rows works as expected", {
  res <- fingertips_subset_rows(
    records = "setosa",
    id_col_name = "Species",
    data = iris
  )
  expect_s3_class(res, "data.frame")
})

test_that("fingertips_subset_columns works as expected", {
  res <- fingertips_subset_columns(
    fields = c("Sepal.Width", "Petal.Length"),
    data = iris
  )
  expect_s3_class(res, "data.frame")
})
