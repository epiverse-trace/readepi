test_that("check_dhis2_attributes works as expected", {
  attributes <- check_dhis2_attributes(
    username = "admin",
    password = "district",
    base.url = "https://play.dhis2.org/dev/",
    dataset = "pBOMPrpg1QX",
    organisation.unit = "DiszpKrYNg8",
    data.element.group = NULL
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
      base.url = "https://play.dhis2.org/dev/",
      dataset = "pBOMPrpg1QX",
      organisation.unit = "DiszpKrYNg8",
      data.element.group = NULL
    ),
    regexp = cat("Assertion on',username,'failed: Must be provided.")
  )

  expect_error(
    attributes = check_dhis2_attributes(
      username = "admin",
      password = NULL,
      base.url = "https://play.dhis2.org/dev/",
      dataset = "pBOMPrpg1QX",
      organisation.unit = "DiszpKrYNg8",
      data.element.group = NULL
    ),
    regexp = cat("Assertion on',password,'failed: Must be provided.")
  )

  expect_error(
    attributes = check_dhis2_attributes(
      username = "admin",
      password = "district",
      base.url = NULL,
      dataset = "pBOMPrpg1QX",
      organisation.unit = "DiszpKrYNg8",
      data.element.group = NULL
    ),
    regexp = cat("Assertion on',base.url,'failed: Must be provided.")
  )

  expect_error(
    attributes = check_dhis2_attributes(
      username = "admin",
      password = "district",
      base.url = "https://play.dhis2.org/dev/",
      dataset = NULL,
      organisation.unit = "DiszpKrYNg8",
      data.element.group = NULL
    ),
    regexp = cat("Assertion on',dataset,'failed: Must be provided.")
  )

  expect_error(
    attributes = check_dhis2_attributes(
      username = "admin",
      password = "district",
      base.url = "https://play.dhis2.org/dev/",
      dataset = "pBOMPrpg1QX",
      organisation.unit = NULL,
      data.element.group = NULL
    ),
    regexp = cat("Assertion on',organisation.unit,'failed: Must be provided.")
  )
})
