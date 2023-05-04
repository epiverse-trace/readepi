test_that("login works as expected", {
  expect_output(
    login(
      username = "admin",
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    ""
  )
})

test_that("login fails as expected", {
  expect_error(
    login(
      username = NULL,
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    login(
      username = NA,
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    login(
      username = c("admin", "admin1"),
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    login(
      username = "admin",
      password = NULL,
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    login(
      username = "admin",
      password = NA,
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    login(
      username = "admin",
      password = c("district", "district1"),
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    login(
      username = "admin",
      password = "district",
      base_url = NULL
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be specified.")
  )

  expect_error(
    login(
      username = "admin",
      password = "district",
      base_url = NA
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be specified.")
  )

  expect_error(
    login(
      username = "admin",
      password = "district",
      base_url = c(file.path("https:/", "play.dhis2.org", "dev", ""),
                   "https://play.dhis2.org/dev/test/")
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be of type character
                 with length 1.")
  )
})

test_that("dhis2_subset_fields works as expected", {
  result <- dhis2_subset_fields(
    fields = c("dataElement", "period", "value"),
    data = readepi(
      credentials_file = system.file("extdata", "test.ini", package = "readepi")
      , project_id = "DHIS2_DEMO",
      dataset = "pBOMPrpg1QX,BfMAe6Itzgt",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL,
      start_date = "2014",
      end_date = "2023"
    )$data
  )
  expect_s3_class(result, "data.frame")
})

test_that("dhis2_subset_records works as expected", {
  result <- dhis2_subset_records(
    records = c("FTRrcoaog83", "eY5ehpbEsB7", "Ix2HsbDMLea"),
    id_col_name = "dataElement",
    data = readepi(
      credentials_file = system.file("extdata", "test.ini",
                                     package = "readepi"),
      project_id = "DHIS2_DEMO",
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL,
      start_date = "2014",
      end_date = "2023"
    )$data
  )
  expect_s3_class(result, "data.frame")
})
