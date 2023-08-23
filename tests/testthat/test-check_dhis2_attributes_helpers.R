httptest::with_mock_api({
  test_that("the API request is working fine", {
    response <- make_api_request(
      base_url = file.path("https:/", "play.dhis2.org", "dev"),
      username = "admin",
      password = "district",
      which    = "dataElements"
    )
    expect_type(response, "list")
    expect_length(response, 8L)
    expect_identical(response[["status_code"]], 200L)
  })

  test_that("dhis2_get_relevant_attributes works as expected with valid
            dataSets", {
              result <- dhis2_get_relevant_attributes(
                attribute_id = "pBOMPrpg1QX,BfMAe6Itzgt",
                base_url     = file.path("https:/", "play.dhis2.org", "dev"),
                username     = "admin",
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
                base_url = file.path("https:/", "play.dhis2.org", "dev"),
                username = "admin",
                password = "district",
                which = "dataElements"
              )
              expect_s3_class(result, "data.frame")
            })

  test_that("dhis2_get_relevant_attributes works as expected with valid
            organisationUnits", {
              result <- dhis2_get_relevant_attributes(
                attribute_id = "Rp268JB6Ne4",
                base_url = file.path("https:/", "play.dhis2.org", "dev"),
                username = "admin",
                password = "district",
                which = "organisationUnits"
              )
              expect_type(result, "list")
              expect_identical(result[["organisation_unit"]], "Rp268JB6Ne4")
              expect_s3_class(result[["org_units"]], "data.frame")
            })

  test_that("dhis2_get_relevant_attributes works as expected with valid
            dataElementGroups", {
              result <- dhis2_get_relevant_attributes(
                attribute_id = "oDkJh5Ddh7d",
                base_url = file.path("https:/", "play.dhis2.org", "dev"),
                username = "admin",
                password = "district",
                which = "dataElementGroups"
              )
              expect_type(result, "list")
              expect_identical(result[["data_element_group"]], "oDkJh5Ddh7d")
              expect_s3_class(result[["data_elt_groups"]], "data.frame")
            })
})

test_that("the API request fails as expected", {
  expect_error(
    make_api_request(
      base_url = file.path("test", "play.dhis2.org", "dev"),
      username = "admin",
      password = "district",
      which    = "dataElements"
    ),
    regexp = cat("The 'base_url' should start with 'https://'")
  )
})

test_that("the API request fails with an incorrect attribute", {
  expect_error(
    make_api_request(
      base_url = file.path("test", "play.dhis2.org", "dev"),
      username = "admin",
      password = "district",
      which    = "test"
    ),
    regexp = cat("The expected values for the 'which' argument are:
          'dataSets, 'organisationUnits', 'dataElementGroups', 'dataElements'")
  )
})

test_that("dhis2_get_relevant_attributes fails as expected", {
  expect_error(
    dhis2_get_relevant_attributes(
      attribute_id = "pBOMPrpg1QX,BfMAe6Itzgt",
      base_url = file.path("test", "play.dhis2.org", "dev"),
      username = "admin",
      password = "district",
      which = "dataSets"
    ),
    regexp = cat("The 'base_url' should start with 'https://'")
  )

  expect_error(
    dhis2_get_relevant_attributes(
      attribute_id = "pBOMPrpg1QX,BfMAe6Itzgt",
      base_url = file.path("https:/", "play.dhis2.org", "dev"),
      username = "admin",
      password = "district",
      which = "test"
    ),
    regexp = cat("The expected values for the 'which' argument are:
          'dataSets, 'organisationUnits', 'dataElementGroups', 'dataElements'")
  )
})
