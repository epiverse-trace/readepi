test_that("all_datasets works as expected", {
  dataset <- all_datasets(
    username = "admin",
    password = "district",
    base_url = file.path("https:/", "play.dhis2.org", "dev", "")
  )
  expect_s3_class(dataset, class = "data.frame")
})

test_that("all_datasets fails as expected", {
  expect_error(
    dataset = all_datasets(
      username = NULL,
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    dataset = all_datasets(
      username = NA,
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    dataset = all_datasets(
      username = c("admin", "admin1"),
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    dataset = all_datasets(
      username = "admin",
      password = NULL,
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    dataset = all_datasets(
      username = "admin",
      password = NA,
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    dataset = all_datasets(
      username = "admin",
      password = c("district", "district1"),
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    dataset = all_datasets(
      username = "admin",
      password = "district",
      base_url = NULL
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be specified.")
  )

  expect_error(
    dataset = all_datasets(
      username = "admin",
      password = "district",
      base_url = NA
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be specified.")
  )

  expect_error(
    dataset = all_datasets(
      username = "admin",
      password = c("district", "district1"),
      base_url = c(file.path("https:/", "play.dhis2.org", "dev", ""),
                   "https://play.dhis2.org/dev/test/")
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be of type character
                 with length 1.")
  )
})

test_that("get_datasets works as expected", {
  result <- get_datasets(
    dataset = "pBOMPrpg1QX,BfMAe6Itzgt",
    base_url = "https://play.dhis2.org/dev/",
    username = "admin",
    password = "district"
  )
  expect_type(result, "list")
  expect_length(result, 2)
})

test_that("get_organisation_units works as expected", {
  result <- get_organisation_units(
    organisation_unit = "DiszpKrYNg8",
    base_url = "https://play.dhis2.org/dev/",
    username = "admin",
    password = "district"
  )
  expect_type(result, "list")
  expect_length(result, 2)
})

test_that("all_data_elements works as expected", {
  data_element <- all_data_elements(
    username = "admin",
    password = "district",
    base_url = file.path("https:/", "play.dhis2.org", "dev", "")
  )
  expect_s3_class(data_element, class = "data.frame")
})

test_that("all_data_elements fails as expected", {
  expect_error(
    data_element = all_data_elements(
      username = NULL,
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    data_element = all_data_elements(
      username = NA,
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    data_element = all_data_elements(
      username = c("admin", "admin1"),
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    data_element = all_data_elements(
      username = "admin",
      password = NULL,
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    data_element = all_data_elements(
      username = "admin",
      password = NA,
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    data_element = all_data_elements(
      username = "admin",
      password = c("district", "district1"),
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    data_element = all_data_elements(
      username = "admin",
      password = "district",
      base_url = NULL
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be specified.")
  )

  expect_error(
    data_element = all_data_elements(
      username = "admin",
      password = "district",
      base_url = NA
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be specified.")
  )

  expect_error(
    data_element = all_data_elements(
      username = "admin",
      password = "district",
      base_url = c(file.path("https:/", "play.dhis2.org", "dev", ""),
                   "https://play.dhis2.org/dev/test/")
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be of type character
                 with length 1.")
  )
})

test_that("all_organisation_units works as expected", {
  organisation_units <- all_organisation_units(
    base_url = file.path("https:/", "play.dhis2.org", "dev", ""),
    username = "admin",
    password = "district"
  )
  expect_s3_class(organisation_units, class = "data.frame")
})

test_that("all_organisation_units fails as expected", {
  expect_error(
    organisation_units = all_organisation_units(
      base_url = file.path("https:/", "play.dhis2.org", "dev", ""),
      username = NULL,
      password = "district"
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = all_organisation_units(
      username = NA,
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = all_organisation_units(
      username = c("admin", "admin1"),
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    organisation_units = all_organisation_units(
      username = "admin",
      password = NULL,
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = all_organisation_units(
      username = "admin",
      password = NA,
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = all_organisation_units(
      username = "admin",
      password = c("district", "district1"),
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    organisation_units = all_organisation_units(
      username = "admin",
      password = "district",
      base_url = NULL
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = all_organisation_units(
      username = "admin",
      password = "district",
      base_url = NA
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = all_organisation_units(
      username = "admin",
      password = "district",
      base_url = c(file.path("https:/", "play.dhis2.org", "dev", ""),
                   "https://play.dhis2.org/dev/test/")
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be of type character
                 with length 1.")
  )
})
