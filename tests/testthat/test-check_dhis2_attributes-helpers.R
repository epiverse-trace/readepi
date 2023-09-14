test_that("get_data_sets works as expected", {
  dataset <- get_data_sets(
    username = "admin",
    password = "district",
    base_url = file.path("https:/", "play.dhis2.org", "dev", "")
  )
  expect_s3_class(dataset, class = "data.frame")
})

test_that("get_data_sets fails as expected", {
  expect_error(
    dataset = get_data_sets(
      username = NULL,
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    dataset = get_data_sets(
      username = NA,
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    dataset = get_data_sets(
      username = c("admin", "admin1"),
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    dataset = get_data_sets(
      username = "admin",
      password = NULL,
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    dataset = get_data_sets(
      username = "admin",
      password = NA,
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    dataset = get_data_sets(
      username = "admin",
      password = c("district", "district1"),
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    dataset = get_data_sets(
      username = "admin",
      password = "district",
      base_url = NULL
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be specified.")
  )

  expect_error(
    dataset = get_data_sets(
      username = "admin",
      password = "district",
      base_url = NA
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be specified.")
  )

  expect_error(
    dataset = get_data_sets(
      username = "admin",
      password = c("district", "district1"),
      base_url = c(file.path("https:/", "play.dhis2.org", "dev", ""),
                   "https://play.dhis2.org/dev/test/")
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be of type character
                 with length 1.")
  )
})

test_that("get_relevant_dataset works as expected", {
  result <- get_relevant_dataset(
    dataset = "pBOMPrpg1QX,BfMAe6Itzgt",
    base_url = "https://play.dhis2.org/dev/",
    username = "admin",
    password = "district"
  )
  expect_type(result, "list")
  expect_length(result, 2)
})

test_that("get_relevant_organisation_unit works as expected", {
  result <- get_relevant_organisation_unit(
    organisation_unit = "DiszpKrYNg8",
    base_url = "https://play.dhis2.org/dev/",
    username = "admin",
    password = "district"
  )
  expect_type(result, "list")
  expect_length(result, 2)
})

test_that("get_data_elements works as expected", {
  data_element <- get_data_elements(
    username = "admin",
    password = "district",
    base_url = file.path("https:/", "play.dhis2.org", "dev", "")
  )
  expect_s3_class(data_element, class = "data.frame")
})

test_that("get_data_elements fails as expected", {
  expect_error(
    data_element = get_data_elements(
      username = NULL,
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    data_element = get_data_elements(
      username = NA,
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    data_element = get_data_elements(
      username = c("admin", "admin1"),
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    data_element = get_data_elements(
      username = "admin",
      password = NULL,
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    data_element = get_data_elements(
      username = "admin",
      password = NA,
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    data_element = get_data_elements(
      username = "admin",
      password = c("district", "district1"),
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    data_element = get_data_elements(
      username = "admin",
      password = "district",
      base_url = NULL
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be specified.")
  )

  expect_error(
    data_element = get_data_elements(
      username = "admin",
      password = "district",
      base_url = NA
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be specified.")
  )

  expect_error(
    data_element = get_data_elements(
      username = "admin",
      password = "district",
      base_url = c(file.path("https:/", "play.dhis2.org", "dev", ""),
                   "https://play.dhis2.org/dev/test/")
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be of type character
                 with length 1.")
  )
})

test_that("get_organisation_units works as expected", {
  organisation_units <- get_organisation_units(
    base_url = file.path("https:/", "play.dhis2.org", "dev", ""),
    username = "admin",
    password = "district"
  )
  expect_s3_class(organisation_units, class = "data.frame")
})

test_that("get_organisation_units fails as expected", {
  expect_error(
    organisation_units = get_organisation_units(
      base_url = file.path("https:/", "play.dhis2.org", "dev", ""),
      username = NULL,
      password = "district"
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = NA,
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = c("admin", "admin1"),
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = "admin",
      password = NULL,
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = "admin",
      password = NA,
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = "admin",
      password = c("district", "district1"),
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = "admin",
      password = "district",
      base_url = NULL
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = "admin",
      password = "district",
      base_url = NA
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = "admin",
      password = "district",
      base_url = c(file.path("https:/", "play.dhis2.org", "dev", ""),
                   "https://play.dhis2.org/dev/test/")
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be of type character
                 with length 1.")
  )
})
