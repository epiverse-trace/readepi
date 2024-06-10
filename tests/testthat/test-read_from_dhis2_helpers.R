httptest::with_mock_api({
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  testthat::skip_if_not_installed("httptest")
  test_that("dhis2_login works as expected", {
    expect_message(
      dhis2_login(
        base_url  = file.path("https:/", "play.im.dhis2.org", "dev"),
        user_name = "admin",
        password  = "district"
      ),
      "Logged in successfully!"
    )
  })
})

test_that("dhis2_login fails as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  testthat::skip_if_not_installed("httptest")
  expect_error(
    dhis2_login(
      base_url  = file.path("test", "play.im.dhis2.org", "dev"),
      user_name = "admin",
      password  = "district"
    ),
    regexp = cat("The base URL should start with 'https://'")
  )
})

test_that("dhis2_subset_fields works as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  data <- readepi(
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    data_source = file.path("https:/", "play.im.dhis2.org", "dev"),
    query_parameters = list(dataSet   = "pBOMPrpg1QX,BfMAe6Itzgt",
                            orgUnit   = "DiszpKrYNg8",
                            startDate = "2014",
                            endDate   = "2023")
  )[["data"]]
  results <- dhis2_subset_fields(data = data,
                                 fields = c("dataElement", "period", "value"))
  expect_s3_class(results, "data.frame")
  expect_length(results, 3L)
  expect_named(results, c("dataElement", "period", "value"))
})

test_that("dhis2_subset_fields fails as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  data <- readepi(
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    data_source      = file.path("https:/", "play.im.dhis2.org", "dev"),
    query_parameters = list(dataSet   = "pBOMPrpg1QX,BfMAe6Itzgt",
                            orgUnit   = "DiszpKrYNg8",
                            startDate = "2014",
                            endDate   = "2023")
  )[["data"]]
  expect_error(
    dhis2_subset_fields(data = data, fields = c(1L, 2L, 3L)),
    regexp = cat("The value for the 'fields' argument should be a
                            vector of character.")
  )
})

test_that("dhis2_subset_records works as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  data <- readepi(
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    data_source      = file.path("https:/", "play.im.dhis2.org", "dev"),
    query_parameters = list(dataSet   = "pBOMPrpg1QX,BfMAe6Itzgt",
                            orgUnit   = "DiszpKrYNg8",
                            startDate = "2014",
                            endDate   = "2023")
  )[["data"]]
  result <- dhis2_subset_records(
    data        = data,
    records     = c("vI2csg55S9C", "O05mAByOgAv", "pikOziyCXbM"),
    id_col_name = "dataElement"
  )
  expect_s3_class(result, "data.frame")
})

test_that("dhis2_subset_records fails as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  data <- readepi(
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    data_source      = file.path("https:/", "play.im.dhis2.org", "dev"),
    query_parameters = list(dataSet   = "pBOMPrpg1QX,BfMAe6Itzgt",
                            orgUnit   = "DiszpKrYNg8",
                            startDate = "2014",
                            endDate   = "2023")
  )[["data"]]

  expect_error(
    dhis2_subset_records(
      data        = data,
      records     = c(1L, 2L, 3L),
      id_col_name = "dataElement"
    ),
    regexp = cat("The value for the 'records' argument should be a vector of
                 character.")
  )
})

test_that("dhis2_subset_fields sends a warning when the provided field is not
          found", {
            testthat::skip_on_cran()
            testthat::skip_if_offline()
            data <- readepi(
              credentials_file = system.file("extdata", "test.ini",
                                             package = "readepi"),
              data_source      = file.path("https:/", "play.im.dhis2.org",
                                           "dev"),
              query_parameters = list(dataSet   = "pBOMPrpg1QX,BfMAe6Itzgt",
                                      orgUnit   = "DiszpKrYNg8",
                                      startDate = "2014",
                                      endDate   = "2023")
            )[["data"]]

            expect_warning(
              dhis2_subset_fields(
                data        = data,
                fields      = c("dataElement", "period", "test")
              ),
              regexp = cat("Assertion on',fields,'failed: 'test' is not a valid
                           field.")
            )
          })

test_that("dhis2_subset_records sends a warning when the provided record is not
          found", {
            testthat::skip_on_cran()
            testthat::skip_if_offline()
            data <- readepi(
              credentials_file = system.file("extdata", "test.ini",
                                             package = "readepi"),
              data_source      = file.path("https:/", "play.im.dhis2.org",
                                           "dev"),
              query_parameters = list(dataSet   = "BfMAe6Itzgt",
                                      orgUnit   = "DiszpKrYNg8",
                                      startDate = "2014",
                                      endDate   = "2023")
            )[["data"]]

            expect_warning(dhis2_subset_records(data        = data,
                                                records     = c("fClA2Erf6IO",
                                                                "s46m5MS0hxu",
                                                                "test"),
                                                id_col_name = "dataElement"),
                           regexp = cat("Assertion on',records,'failed: 'test' is not a valid record.")) # nolint: line_length_linter
          })

test_that("dhis2_subset_records works as expected", {
  query_parameters <- list(dataSet   = "pBOMPrpg1QX",
                           orgUnit   = "DiszpKrYNg8",
                           startDate = "2014",
                           endDate   = "2023")
  test <- dhis2_get_query_params(
    args_list = list(query_parameters = query_parameters)
  )
  expect_type(test, "list")
  expect_length(test, 4L)
  expect_named(test, expected = c("dataSet", "orgUnit", "startDate", "endDate"))
  expect_identical(test[["dataSet"]], "pBOMPrpg1QX")
  expect_identical(test[["orgUnit"]], "DiszpKrYNg8")
  expect_identical(test[["startDate"]], "2014")
  expect_identical(test[["endDate"]], "2023")
})
