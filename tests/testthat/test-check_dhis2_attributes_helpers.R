httptest::with_mock_api({
  test_that("the API request is working fine", {
    response <- make_api_request(
      base_url = file.path("https:/", "play.dhis2.org", "dev"),
      username = "admin",
      password = "district",
      which = "dataElements"
    )
    expect_type(response, "list")
  })

  test_that("dhis2_get_relevant_attributes works as expected with valid
            dataSets", {
    result <- dhis2_get_relevant_attributes(
      attribute_id = "pBOMPrpg1QX,BfMAe6Itzgt",
      base_url = file.path("https:/", "play.dhis2.org", "dev"),
      username = "admin",
      password = "district",
      which = "dataSets"
    )
    expect_type(result, "list")
    expect_identical(result$dataset, "pBOMPrpg1QX,BfMAe6Itzgt")
    expect_s3_class(result$data_sets, "data.frame")
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
              expect_identical(result$organisation_unit, "Rp268JB6Ne4")
              expect_s3_class(result$org_units, "data.frame")
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
              expect_identical(result$data_element_group, "oDkJh5Ddh7d")
              expect_s3_class(result$data_elt_groups, "data.frame")
            })
})
