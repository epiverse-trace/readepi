httptest::with_mock_api({
  testthat::skip_if_not_installed("httptest")
  test_that("dhis2_check_attributes works as expected when all attribute
            types are specified", {
              testthat::skip_on_cran()
              testthat::skip_if_offline()
              attributes <- dhis2_check_attributes(
                base_url        = file.path("https:/", "play.dhis2.org",
                                            "demo"),
                user_name        = "admin",
                password         = "district",
                query_parameters = list(dataSet          = "BfMAe6Itzgt",
                                        orgUnit          = "Umh4HKqqFp6",
                                        dataElementGroup = "oDkJh5Ddh7d")
              )
              expect_type(attributes, "list")
              expect_length(attributes, 9L)
              expect_named(attributes, c(
                "dataset", "dataset_details", "organisation_unit",
                "org_units_details", "data_element_group",
                "data_element_groups_details", "organisation_unit_group",
                "org_units_groups", "data_elements"
              ))
              expect_type(attributes[["dataset"]], "character")
              expect_identical(attributes[["dataset"]], "BfMAe6Itzgt")
              expect_s3_class(attributes[["dataset_details"]],
                              class = "data.frame")
              expect_type(attributes[["organisation_unit"]], "character")
              expect_identical(attributes[["organisation_unit"]], "Umh4HKqqFp6")
              expect_s3_class(attributes[["org_units_details"]],
                              class = "data.frame")
              expect_s3_class(attributes[["data_elements"]],
                              class = "data.frame")
              expect_type(attributes[["data_element_group"]], "character")
              expect_identical(
                               attributes[["data_element_group"]],
                               "oDkJh5Ddh7d")
              expect_s3_class(attributes[["data_element_groups_details"]],
                              class = "data.frame")
              expect_null(attributes[["organisation_unit_group"]])
              expect_null(attributes[["org_units_groups"]])
            })

  test_that("dhis2_check_attributes works as expected when only the
            dataSet ID is specified", {
              testthat::skip_on_cran()
              testthat::skip_if_offline()
              attributes <- dhis2_check_attributes(
                base_url        = file.path("https:/", "play.dhis2.org",
                                            "demo"),
                user_name        = "admin",
                password         = "district",
                query_parameters = list(dataSet = "BfMAe6Itzgt")
              )
              expect_type(attributes, "list")
              expect_length(attributes, 9L)
              expect_named(attributes, c("dataset", "dataset_details",
                                         "organisation_unit",
                                         "org_units_details",
                                         "data_element_group",
                                         "data_element_groups_details",
                                         "organisation_unit_group",
                                         "org_units_groups",
                                         "data_elements"))
              expect_type(attributes[["dataset"]], "character")
              expect_identical(attributes[["dataset"]], "BfMAe6Itzgt")
              expect_s3_class(attributes[["dataset_details"]],
                              class = "data.frame")
              expect_s3_class(attributes[["data_elements"]],
                              class = "data.frame")
              expect_null(attributes[["organisation_unit"]])
              expect_null(attributes[["org_units_details"]])
              expect_null(attributes[["data_element_group"]])
              expect_null(attributes[["data_element_groups_details"]])
              expect_null(attributes[["organisation_unit_group"]])
              expect_null(attributes[["org_units_groups"]])
            })

  test_that("dhis2_check_attributes works as expected when only the
            organisation unit ID is specified", {
              testthat::skip_on_cran()
              testthat::skip_if_offline()
              attributes <- dhis2_check_attributes(
                base_url        = file.path("https:/", "play.dhis2.org",
                                            "demo"),
                user_name        = "admin",
                password         = "district",
                query_parameters = list(orgUnit = "Umh4HKqqFp6")
              )
              expect_type(attributes, "list")
              expect_length(attributes, 9L)
              expect_named(attributes, c("dataset", "dataset_details",
                                         "organisation_unit",
                                         "org_units_details",
                                         "data_element_group",
                                         "data_element_groups_details",
                                         "organisation_unit_group",
                                         "org_units_groups",
                                         "data_elements"))
              expect_type(attributes[["organisation_unit"]], "character")
              expect_identical(attributes[["organisation_unit"]], "Umh4HKqqFp6")
              expect_s3_class(attributes[["org_units_details"]],
                              class = "data.frame")
              expect_s3_class(attributes[["data_elements"]],
                              class = "data.frame")
              expect_null(attributes[["dataset"]])
              expect_null(attributes[["dataset_details"]])
              expect_null(attributes[["data_element_group"]])
              expect_null(attributes[["data_element_groups_details"]])
              expect_null(attributes[["organisation_unit_group"]])
              expect_null(attributes[["org_units_groups"]])
            })

  test_that("dhis2_check_attributes works as expected when only the
            data element group ID is specified", {
              testthat::skip_on_cran()
              testthat::skip_if_offline()
              attributes <- dhis2_check_attributes(
                base_url        = file.path("https:/", "play.dhis2.org",
                                            "demo"),
                user_name        = "admin",
                password         = "district",
                query_parameters = list(dataElementGroup = "oDkJh5Ddh7d")
              )
              expect_type(attributes, "list")
              expect_length(attributes, 9L)
              expect_named(attributes, c("dataset", "dataset_details",
                                         "organisation_unit",
                                         "org_units_details",
                                         "data_element_group",
                                         "data_element_groups_details",
                                         "organisation_unit_group",
                                         "org_units_groups",
                                         "data_elements"))
              expect_type(attributes[["data_element_group"]], "character")
              expect_identical(
                attributes[["data_element_group"]],
                "oDkJh5Ddh7d"
              )
              expect_s3_class(attributes[["data_element_groups_details"]],
                              class = "data.frame")
              expect_s3_class(attributes[["data_elements"]],
                              class = "data.frame")
              expect_null(attributes[["organisation_unit"]])
              expect_null(attributes[["org_units_details"]])
              expect_null(attributes[["dataset"]])
              expect_null(attributes[["dataset_details"]])
              expect_null(attributes[["organisation_unit_group"]])
              expect_null(attributes[["org_units_groups"]])
            })

  test_that("dhis2_check_attributes works as expected when the dataset and
            organisation unit IDs are specified", {
              testthat::skip_on_cran()
              testthat::skip_if_offline()
              attributes <- dhis2_check_attributes(
                base_url        = file.path("https:/", "play.dhis2.org",
                                            "demo"),
                user_name        = "admin",
                password         = "district",
                query_parameters = list(dataSet = "BfMAe6Itzgt",
                                        orgUnit = "Umh4HKqqFp6")
              )
              expect_type(attributes, "list")
              expect_length(attributes, 9L)
              expect_named(attributes, c("dataset", "dataset_details",
                                         "organisation_unit",
                                         "org_units_details",
                                         "data_element_group",
                                         "data_element_groups_details",
                                         "organisation_unit_group",
                                         "org_units_groups",
                                         "data_elements"))
              expect_type(attributes[["dataset"]], "character")
              expect_identical(attributes[["dataset"]], "BfMAe6Itzgt")
              expect_s3_class(attributes[["dataset_details"]],
                              class = "data.frame")
              expect_type(attributes[["organisation_unit"]], "character")
              expect_identical(attributes[["organisation_unit"]], "Umh4HKqqFp6")
              expect_s3_class(attributes[["org_units_details"]],
                              class = "data.frame")
              expect_s3_class(attributes[["data_elements"]],
                              class = "data.frame")
              expect_null(attributes[["data_element_group"]])
              expect_null(attributes[["data_element_groups_details"]])
              expect_null(attributes[["organisation_unit_group"]])
              expect_null(attributes[["org_units_groups"]])
            })

  test_that("dhis2_check_attributes works as expected when the dataset and
            data element group IDs are specified", {
              testthat::skip_on_cran()
              testthat::skip_if_offline()
              attributes <- dhis2_check_attributes(
                base_url        = file.path("https:/", "play.dhis2.org",
                                            "demo"),
                user_name        = "admin",
                password         = "district",
                query_parameters = list(dataSet          = "BfMAe6Itzgt",
                                        dataElementGroup = "oDkJh5Ddh7d")
              )
              expect_type(attributes, "list")
              expect_length(attributes, 9L)
              expect_named(attributes, c("dataset", "dataset_details",
                                         "organisation_unit",
                                         "org_units_details",
                                         "data_element_group",
                                         "data_element_groups_details",
                                         "organisation_unit_group",
                                         "org_units_groups",
                                         "data_elements"))
              expect_type(attributes[["dataset"]], "character")
              expect_identical(attributes[["dataset"]], "BfMAe6Itzgt")
              expect_s3_class(attributes[["dataset_details"]],
                              class = "data.frame")
              expect_null(attributes[["organisation_unit"]])
              expect_null(attributes[["org_units_details"]])
              expect_null(attributes[["organisation_unit_group"]])
              expect_null(attributes[["org_units_groups"]])
              expect_s3_class(attributes[["data_elements"]],
                              class = "data.frame")
              expect_type(attributes[["data_element_group"]], "character")
              expect_identical(
                attributes[["data_element_group"]],
                "oDkJh5Ddh7d"
              )
              expect_s3_class(attributes[["data_element_groups_details"]],
                              class = "data.frame")
            })

  test_that("dhis2_check_attributes works as expected when the organisation unit
            and data element group IDs are specified", {
              testthat::skip_on_cran()
              testthat::skip_if_offline()
              attributes <- dhis2_check_attributes(
                base_url        = file.path("https:/", "play.dhis2.org",
                                            "demo"),
                user_name        = "admin",
                password         = "district",
                query_parameters = list(orgUnit          = "Umh4HKqqFp6",
                                        dataElementGroup = "oDkJh5Ddh7d")
              )
              expect_type(attributes, "list")
              expect_length(attributes, 9L)
              expect_named(attributes, c("dataset", "dataset_details",
                                         "organisation_unit",
                                         "org_units_details",
                                         "data_element_group",
                                         "data_element_groups_details",
                                         "organisation_unit_group",
                                         "org_units_groups",
                                         "data_elements"))
              expect_null(attributes[["dataset"]])
              expect_null(attributes[["dataset_details"]])
              expect_null(attributes[["organisation_unit_group"]])
              expect_null(attributes[["org_units_groups"]])
              expect_type(attributes[["organisation_unit"]], "character")
              expect_identical(attributes[["organisation_unit"]], "Umh4HKqqFp6")
              expect_s3_class(attributes[["org_units_details"]],
                              class = "data.frame")
              expect_s3_class(attributes[["data_elements"]],
                              class = "data.frame")
              expect_type(attributes[["data_element_group"]], "character")
              expect_identical(
                attributes[["data_element_group"]],
                "oDkJh5Ddh7d"
              )
              expect_s3_class(attributes[["data_element_groups_details"]],
                              class = "data.frame")
            })

  test_that("dhis2_check_attributes returns only the data element when the
            query parameters are not provided.", {
              testthat::skip_on_cran()
              testthat::skip_if_offline()
              attributes <- dhis2_check_attributes(
                base_url        = file.path("https:/", "play.dhis2.org",
                                            "demo"),
                user_name        = "admin",
                password         = "district",
                query_parameters = NULL
              )
              expect_s3_class(attributes[["data_elements"]],
                              class = "data.frame")
              expect_null(attributes[["dataset"]])
              expect_null(attributes[["dataset_details"]])
              expect_null(attributes[["organisation_unit_group"]])
              expect_null(attributes[["org_units_groups"]])
              expect_null(attributes[["organisation_unit"]])
              expect_null(attributes[["org_units_details"]])
              expect_null(attributes[["data_element_group"]])
              expect_null(attributes[["data_element_groups_details"]])
            })
})
