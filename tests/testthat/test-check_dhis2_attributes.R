<<<<<<< HEAD
test_that("check_dhis2_attributes works as expected", {
  attributes <- check_dhis2_attributes(
    username = "admin",
    password = "district",
    base_url = "https://play.dhis2.org/dev/",
    dataset = "pBOMPrpg1QX",
    organisation_unit = "DiszpKrYNg8",
    data_element_group = NULL
  )
  expect_type(attributes, "list")
  expect_length(attributes, 7)
  expect_named(attributes, c(
    "dataset", "dataset_details", "organisation_unit",
    "org_units_details", "data_element_group",
    "data_element_groups_details", "data_elements"
  ))
  expect_type(attributes$dataset, "character")
  expect_s3_class(attributes$dataset_details, class = "data.frame")
  expect_type(attributes$organisation_unit, "character")
  expect_s3_class(attributes$org_units_details, class = "data.frame")
  expect_s3_class(attributes$data_elements, class = "data.frame")
})

test_that("check_dhis2_attributes fails as expected", {
  expect_error(
    attributes = check_dhis2_attributes(
      username = NULL,
      password = "district",
      base_url = "https://play.dhis2.org/dev/",
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL
    ),
    regexp = cat("Assertion on',username,'failed: Must be provided.")
  )

  expect_error(
    attributes = check_dhis2_attributes(
      username = NA,
      password = "district",
      base_url = "https://play.dhis2.org/dev/",
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL
    ),
    regexp = cat("Assertion on',username,'failed: Missing value not allowed for
                 user name.")
  )

  expect_error(
    attributes = check_dhis2_attributes(
      username = c("admin1", "admin2"),
      password = "district",
      base_url = "https://play.dhis2.org/dev/",
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL
    ),
    regexp = cat("Assertion on',username,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    attributes = check_dhis2_attributes(
      username = "admin",
      password = NULL,
      base_url = "https://play.dhis2.org/dev/",
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must be provided.")
  )

  expect_error(
    attributes = check_dhis2_attributes(
      username = "admin",
      password = NA,
      base_url = "https://play.dhis2.org/dev/",
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Missing value not allowed
                 for password.")
  )

  expect_error(
    attributes = check_dhis2_attributes(
      username = "admin",
      password = c("district", "district1"),
      base_url = "https://play.dhis2.org/dev/",
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character with
                 length 1.")
  )

  expect_error(
    attributes = check_dhis2_attributes(
      username = "admin",
      password = "district",
      base_url = NULL,
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be provided.")
  )

  expect_error(
    attributes = check_dhis2_attributes(
      username = "admin",
      password = "district",
      base_url = NA,
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL
    ),
    regexp = cat("Assertion on',base_url,'failed: Missing value not allowed for
                 base_url.")
  )

  expect_error(
    attributes = check_dhis2_attributes(
      username = "admin",
      password = "district",
      base_url = c("https://play.dhis2.org/dev/",
                   "https://play.dhis2.org/dep/"),
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be a character of
    length 1.")
  )

  expect_error(
    attributes = check_dhis2_attributes(
      username = "admin",
      password = "district",
      base_url = "https://play.dhis2.org/dev/",
      dataset = NULL,
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL
    ),
    regexp = cat("Assertion on',dataset,'failed: Must be provided.")
  )

  expect_error(
    attributes = check_dhis2_attributes(
      username = "admin",
      password = "district",
      base_url = "https://play.dhis2.org/dev/",
      dataset = NA,
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL
    ),
    regexp = cat("Assertion on',dataset,'failed: Missing value not allowed for
                 dataset.")
  )

  expect_error(
    attributes = check_dhis2_attributes(
      username = "admin",
      password = "district",
      base_url = "https://play.dhis2.org/dev/",
      dataset = "pBOMPrpg1QX",
      organisation_unit = NULL,
      data_element_group = NULL
    ),
    regexp = cat("Assertion on',organisation_unit,'failed: Must be provided.")
  )

  expect_error(
    attributes = check_dhis2_attributes(
      username = "admin",
      password = "district",
      base_url = "https://play.dhis2.org/dev/",
      dataset = "pBOMPrpg1QX",
      organisation_unit = NA,
      data_element_group = NULL
    ),
    regexp = cat("Assertion on',organisation_unit,'failed: Missing value not
                 allowed for organisation_unit.")
  )

  expect_error(
    attributes <- check_dhis2_attributes(
      username = "admin",
      password = "district",
      base_url = "https://play.dhis2.org/dev/",
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NA
    ),
    regexp = cat("Assertion on',data_element_group,'failed: Missing value not
                 allowed for data_element_group")
  )
=======
httptest::with_mock_api({
  test_that("dhis2_check_attributes works as expected when all attribute
            types are specified", {
              attributes <- dhis2_check_attributes(
                username = "admin",
                password = "district",
                base_url = file.path("https:/", "play.dhis2.org", "dev"),
                dataset = "pBOMPrpg1QX",
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
              expect_type(attributes[["dataset"]], "character")
              expect_identical(attributes[["dataset"]], "pBOMPrpg1QX")
              expect_s3_class(attributes[["dataset_details"]],
                class = "data.frame"
              )
              expect_type(attributes[["organisation_unit"]], "character")
              expect_identical(attributes[["organisation_unit"]], "DiszpKrYNg8")
              expect_s3_class(attributes[["org_units_details"]],
                class = "data.frame"
              )
              expect_s3_class(attributes[["data_elements"]],
                class = "data.frame"
              )
              expect_type(attributes[["data_element_group"]], "character")
              expect_identical(
                attributes[["data_element_group"]],
                "oDkJh5Ddh7d"
              )
              expect_s3_class(attributes[["data_element_groups_details"]],
                class = "data.frame"
              )
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
                class = "data.frame"
              )
              expect_s3_class(attributes[["data_elements"]],
                class = "data.frame"
              )
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
                class = "data.frame"
              )
              expect_s3_class(attributes[["data_elements"]],
                class = "data.frame"
              )
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
              expect_identical(
                attributes[["data_element_group"]],
                "oDkJh5Ddh7d"
              )
              expect_s3_class(attributes[["data_element_groups_details"]],
                class = "data.frame"
              )
              expect_s3_class(attributes[["data_elements"]],
                class = "data.frame"
              )
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
                class = "data.frame"
              )
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
                class = "data.frame"
              )
              expect_type(attributes[["organisation_unit"]], "character")
              expect_identical(attributes[["organisation_unit"]], "DiszpKrYNg8")
              expect_s3_class(attributes[["org_units_details"]],
                class = "data.frame"
              )
              expect_s3_class(attributes[["data_elements"]],
                class = "data.frame"
              )
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
                class = "data.frame"
              )
              expect_null(attributes[["organisation_unit"]])
              expect_null(attributes[["org_units_details"]])
              expect_s3_class(attributes[["data_elements"]],
                class = "data.frame"
              )
              expect_type(attributes[["data_element_group"]], "character")
              expect_identical(
                attributes[["data_element_group"]],
                "oDkJh5Ddh7d"
              )
              expect_s3_class(attributes[["data_element_groups_details"]],
                class = "data.frame"
              )
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
                class = "data.frame"
              )
              expect_s3_class(attributes[["data_elements"]],
                class = "data.frame"
              )
              expect_type(attributes[["data_element_group"]], "character")
              expect_identical(
                attributes[["data_element_group"]],
                "oDkJh5Ddh7d"
              )
              expect_s3_class(attributes[["data_element_groups_details"]],
                class = "data.frame"
              )
            })
>>>>>>> review
})
