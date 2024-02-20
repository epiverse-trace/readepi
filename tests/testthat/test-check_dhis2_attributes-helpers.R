httptest::with_mock_api({
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  testthat::skip_if_not_installed("httptest")
  test_that("the API request is working fine", {
    response <- dhis2_make_api_request(
      base_url  = file.path("https:/", "play.dhis2.org", "dev"),
      user_name = "admin",
      password  = "district",
      which     = "dataElements"
    )
    expect_type(response, "list")
    expect_length(response, 7L)
    expect_identical(response[["status_code"]], 200L)
    expect_identical(response[["method"]], "GET")
  })

  test_that("dhis2_get_relevant_attributes works as expected with valid
            dataSets", {
              result <- dhis2_get_relevant_attributes(
                attribute_id = "pBOMPrpg1QX,BfMAe6Itzgt",
                base_url     = file.path("https:/", "play.dhis2.org", "dev"),
                user_name    = "admin",
                password     = "district",
                which        = "dataSets"
              )
              expect_type(result, "list")
              expect_identical(result[["dataset"]], "pBOMPrpg1QX,BfMAe6Itzgt")
              expect_s3_class(result[["data_sets"]], "data.frame")
            })

  test_that("dhis2_get_relevant_attributes works as expected with valid
            dataElements", {
              result <- dhis2_get_relevant_attributes(
                attribute_id = "FTRrcoaog83",
                base_url     = file.path("https:/", "play.dhis2.org", "dev"),
                user_name    = "admin",
                password     = "district",
                which        = "dataElements"
              )
              expect_s3_class(result, "data.frame")
            })

  test_that("dhis2_get_relevant_attributes works as expected with valid
            organisationUnits", {
              result <- dhis2_get_relevant_attributes(
                attribute_id = "Rp268JB6Ne4",
                base_url     = file.path("https:/", "play.dhis2.org", "dev"),
                user_name    = "admin",
                password     = "district",
                which        = "organisationUnits"
              )
              expect_type(result, "list")
              expect_identical(result[["organisation_unit"]], "Rp268JB6Ne4")
              expect_s3_class(result[["org_units"]], "data.frame")
            })

  test_that("dhis2_get_relevant_attributes works as expected with valid
            dataElementGroups", {
              result <- dhis2_get_relevant_attributes(
                attribute_id = "oDkJh5Ddh7d",
                base_url     = file.path("https:/", "play.dhis2.org", "dev"),
                user_name    = "admin",
                password     = "district",
                which        = "dataElementGroups"
              )
              expect_type(result, "list")
              expect_identical(result[["data_element_group"]], "oDkJh5Ddh7d")
              expect_s3_class(result[["data_elt_groups"]], "data.frame")
            })

  test_that("dhis2_get_attributes works as expected", {
    attributes <- dhis2_get_attributes(
      base_url  = file.path("https:/", "play.dhis2.org", "dev"),
      user_name = "admin",
      password  = "district",
      which     = "dataSets"
    )
    expect_s3_class(attributes, "data.frame")
    expect_identical(ncol(attributes), 3L)
    expect_named(attributes, c("name", "shortName", "id"))
  })
})

test_that("the API request fails as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  testthat::skip_if_not_installed("httptest")
  expect_error(
    dhis2_make_api_request(
      base_url  = file.path("test", "play.dhis2.org", "dev"),
      user_name = "admin",
      password  = "district",
      which     = "dataElements"
    ),
    regexp = cat("The 'base_url' should start with 'https://'")
  )
})

test_that("the API request fails with an incorrect attribute", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  testthat::skip_if_not_installed("httptest")
  expect_error(
    dhis2_make_api_request(
      base_url  = file.path("test", "play.dhis2.org", "dev"),
      user_name = "admin",
      password  = "district",
      which     = "test"
    ),
    regexp = cat("The expected values for the 'which' argument are:
          'dataSets, 'organisationUnits', 'dataElementGroups', 'dataElements'")
  )
})

test_that("dhis2_get_relevant_attributes fails as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  expect_error(
    dhis2_get_relevant_attributes(
      attribute_id = "pBOMPrpg1QX,BfMAe6Itzgt",
      base_url     = file.path("test", "play.dhis2.org", "dev"),
      user_name    = "admin",
      password     = "district",
      which        = "dataSets"
    ),
    regexp = cat("The 'base_url' should start with 'https://'")
  )

  expect_error(
    dhis2_get_relevant_attributes(
      attribute_id = "pBOMPrpg1QX,BfMAe6Itzgt",
      base_url     = file.path("https:/", "play.dhis2.org", "dev"),
      user_name    = "admin",
      password     = "district",
      which        = "test"
    ),
    regexp = cat("The expected values for the 'which' argument are:
          'dataSets, 'organisationUnits', 'dataElementGroups', 'dataElements'")
  )

  expect_error(
    dhis2_get_relevant_attributes(
      attribute_id = "test",
      base_url     = file.path("https:/", "play.dhis2.org", "dev"),
      user_name    = "admin",
      password     = "district",
      which        = "dataSets"
    ),
    regexp = cat("The provided attribute ID not found.")
  )

  expect_warning(
    dhis2_get_relevant_attributes(
      attribute_id = "pBOMPrpg1QX, test",
      base_url     = file.path("https:/", "play.dhis2.org", "dev"),
      user_name    = "admin",
      password     = "district",
      which        = "dataSets"
    ),
    regexp = cat("Assertion on',attribute_id,'failed: 'test' is not a valid
                 dataSet ID.")
  )
})
