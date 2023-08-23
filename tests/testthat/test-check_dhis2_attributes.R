httptest::with_mock_api({
  test_that("dhis2_check_attributes works as expected when all attribute
            types are specified", {
              attributes <- dhis2_check_attributes(
                username           = "admin",
                password           = "district",
                base_url        = file.path("https:/", "play.dhis2.org", "dev"),
                dataset            = "pBOMPrpg1QX",
                organisation_unit  = "DiszpKrYNg8",
                data_element_group = "oDkJh5Ddh7d"
              )
              expect_type(attributes, "list")
              expect_length(attributes, 7L)
              expect_named(attributes, c(
                "dataset", "dataset_details", "organisation_unit",
                "org_units_details", "data_element_group",
                "data_element_groups_details", "data_elements"
              ))
              expect_type(attributes[["dataset"]], "character")
              expect_identical(attributes[["dataset"]], "pBOMPrpg1QX")
              expect_s3_class(attributes[["dataset_details"]],
                              class = "data.frame")
              expect_type(attributes[["organisation_unit"]], "character")
              expect_identical(attributes[["organisation_unit"]], "DiszpKrYNg8")
              expect_s3_class(attributes[["org_units_details"]],
                              class = "data.frame")
              expect_s3_class(attributes[["data_elements"]],
                              class = "data.frame")
              expect_type(attributes[["data_element_group"]], "character")
              expect_identical(attributes[["data_element_group"]],
                               "oDkJh5Ddh7d")
              expect_s3_class(attributes[["data_element_groups_details"]],
                              class = "data.frame")
            })

  test_that("dhis2_check_attributes works as expected when only the
            dataSet ID is specified", {
              attributes <- dhis2_check_attributes(
                username = "admin",
                password = "district",
                base_url = file.path("https:/", "play.dhis2.org", "dev"),
                dataset = "pBOMPrpg1QX",
                organisation_unit = NULL,
                data_element_group = NULL
              )
              expect_type(attributes, "list")
              expect_length(attributes, 7L)
              expect_named(attributes, c(
                "dataset", "dataset_details", "organisation_unit",
                "org_units_details", "data_element_group",
                "data_element_groups_details", "data_elements"
              ))
              expect_type(attributes[["dataset"]], "character")
              expect_identical(attributes[["dataset"]], "pBOMPrpg1QX")
              expect_s3_class(attributes[["dataset_details"]],
                              class = "data.frame")
              expect_s3_class(attributes[["data_elements"]],
                              class = "data.frame")
              expect_null(attributes[["organisation_unit"]])
              expect_null(attributes[["org_units_details"]])
              expect_null(attributes[["data_element_group"]])
              expect_null(attributes[["data_element_groups_details"]])
            })

  test_that("dhis2_check_attributes works as expected when only the
            organisation unit ID is specified", {
              attributes <- dhis2_check_attributes(
                username = "admin",
                password = "district",
                base_url = file.path("https:/", "play.dhis2.org", "dev"),
                dataset = NULL,
                organisation_unit = "DiszpKrYNg8",
                data_element_group = NULL
              )
              expect_type(attributes, "list")
              expect_length(attributes, 7L)
              expect_named(attributes, c(
                "dataset", "dataset_details", "organisation_unit",
                "org_units_details", "data_element_group",
                "data_element_groups_details", "data_elements"
              ))
              expect_type(attributes[["organisation_unit"]], "character")
              expect_identical(attributes[["organisation_unit"]], "DiszpKrYNg8")
              expect_s3_class(attributes[["org_units_details"]],
                              class = "data.frame")
              expect_s3_class(attributes[["data_elements"]],
                              class = "data.frame")
              expect_null(attributes[["dataset"]])
              expect_null(attributes[["dataset_details"]])
              expect_null(attributes[["data_element_group"]])
              expect_null(attributes[["data_element_groups_details"]])
            })

  test_that("dhis2_check_attributes works as expected when only the
            data element group ID is specified", {
              attributes <- dhis2_check_attributes(
                username = "admin",
                password = "district",
                base_url = file.path("https:/", "play.dhis2.org", "dev"),
                dataset = NULL,
                organisation_unit = NULL,
                data_element_group = "oDkJh5Ddh7d"
              )
              expect_type(attributes, "list")
              expect_length(attributes, 7L)
              expect_named(attributes, c(
                "dataset", "dataset_details", "organisation_unit",
                "org_units_details", "data_element_group",
                "data_element_groups_details", "data_elements"
              ))
              expect_type(attributes[["data_element_group"]], "character")
              expect_identical(attributes[["data_element_group"]],
                               "oDkJh5Ddh7d")
              expect_s3_class(attributes[["data_element_groups_details"]],
                              class = "data.frame")
              expect_s3_class(attributes[["data_elements"]],
                              class = "data.frame")
              expect_null(attributes[["organisation_unit"]])
              expect_null(attributes[["org_units_details"]])
              expect_null(attributes[["dataset"]])
              expect_null(attributes[["dataset_details"]])
            })

  test_that("dhis2_check_attributes only returns the data elements when none
            of the attributes is specified", {
              attributes <- dhis2_check_attributes(
                username = "admin",
                password = "district",
                base_url = file.path("https:/", "play.dhis2.org", "dev"),
                dataset = NULL,
                organisation_unit = NULL,
                data_element_group = NULL
              )
              expect_type(attributes, "list")
              expect_length(attributes, 7L)
              expect_named(attributes, c(
                "dataset", "dataset_details", "organisation_unit",
                "org_units_details", "data_element_group",
                "data_element_groups_details", "data_elements"
              ))
              expect_s3_class(attributes[["data_elements"]],
                              class = "data.frame")
              expect_null(attributes[["organisation_unit"]])
              expect_null(attributes[["org_units_details"]])
              expect_null(attributes[["dataset"]])
              expect_null(attributes[["dataset_details"]])
              expect_null(attributes[["data_element_group"]])
              expect_null(attributes[["data_element_groups_details"]])
            })

  test_that("dhis2_check_attributes works as expected when the dataset and
            organisation unit IDs are specified", {
              attributes <- dhis2_check_attributes(
                username = "admin",
                password = "district",
                base_url = file.path("https:/", "play.dhis2.org", "dev"),
                dataset = "pBOMPrpg1QX",
                organisation_unit = "DiszpKrYNg8",
                data_element_group = NULL
              )
              expect_type(attributes, "list")
              expect_length(attributes, 7L)
              expect_named(attributes, c(
                "dataset", "dataset_details", "organisation_unit",
                "org_units_details", "data_element_group",
                "data_element_groups_details", "data_elements"
              ))
              expect_type(attributes[["dataset"]], "character")
              expect_identical(attributes[["dataset"]], "pBOMPrpg1QX")
              expect_s3_class(attributes[["dataset_details"]],
                              class = "data.frame")
              expect_type(attributes[["organisation_unit"]], "character")
              expect_identical(attributes[["organisation_unit"]], "DiszpKrYNg8")
              expect_s3_class(attributes[["org_units_details"]],
                              class = "data.frame")
              expect_s3_class(attributes[["data_elements"]],
                              class = "data.frame")
              expect_null(attributes[["data_element_group"]])
              expect_null(attributes[["data_element_groups_details"]])
            })

  test_that("dhis2_check_attributes works as expected when the dataset and
            data element group IDs are specified", {
              attributes <- dhis2_check_attributes(
                username = "admin",
                password = "district",
                base_url = file.path("https:/", "play.dhis2.org", "dev"),
                dataset = "pBOMPrpg1QX",
                organisation_unit = NULL,
                data_element_group = "oDkJh5Ddh7d"
              )
              expect_type(attributes, "list")
              expect_length(attributes, 7L)
              expect_named(attributes, c(
                "dataset", "dataset_details", "organisation_unit",
                "org_units_details", "data_element_group",
                "data_element_groups_details", "data_elements"
              ))
              expect_type(attributes[["dataset"]], "character")
              expect_identical(attributes[["dataset"]], "pBOMPrpg1QX")
              expect_s3_class(attributes[["dataset_details"]],
                              class = "data.frame")
              expect_null(attributes[["organisation_unit"]])
              expect_null(attributes[["org_units_details"]])
              expect_s3_class(attributes[["data_elements"]],
                              class = "data.frame")
              expect_type(attributes[["data_element_group"]], "character")
              expect_identical(attributes[["data_element_group"]],
                               "oDkJh5Ddh7d")
              expect_s3_class(attributes[["data_element_groups_details"]],
                              class = "data.frame")
            })

  test_that("dhis2_check_attributes works as expected when the organisation unit
            and data element group IDs are specified", {
              attributes <- dhis2_check_attributes(
                username = "admin",
                password = "district",
                base_url = file.path("https:/", "play.dhis2.org", "dev"),
                dataset = NULL,
                organisation_unit = "DiszpKrYNg8",
                data_element_group = "oDkJh5Ddh7d"
              )
              expect_type(attributes, "list")
              expect_length(attributes, 7L)
              expect_named(attributes, c(
                "dataset", "dataset_details", "organisation_unit",
                "org_units_details", "data_element_group",
                "data_element_groups_details", "data_elements"
              ))
              expect_null(attributes[["dataset"]])
              expect_null(attributes[["dataset_details"]])
              expect_type(attributes[["organisation_unit"]], "character")
              expect_identical(attributes[["organisation_unit"]], "DiszpKrYNg8")
              expect_s3_class(attributes[["org_units_details"]],
                              class = "data.frame")
              expect_s3_class(attributes[["data_elements"]],
                              class = "data.frame")
              expect_type(attributes[["data_element_group"]], "character")
              expect_identical(attributes[["data_element_group"]],
                               "oDkJh5Ddh7d")
              expect_s3_class(attributes[["data_element_groups_details"]],
                              class = "data.frame")
            })
})
