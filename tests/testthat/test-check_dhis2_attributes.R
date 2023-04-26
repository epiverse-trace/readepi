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
})
