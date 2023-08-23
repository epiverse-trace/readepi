httptest::with_mock_api({
  test_that("login works as expected", {
    expect_message(
                   login(
                     username = "admin",
                     password = "district",
                     base_url = file.path("https:/", "play.dhis2.org", "dev")
                   ),
                   "Logged in successfully!")
  })
})

test_that("login fails as expected", {
  expect_error(
    login(
      username = "admin",
      password = "district",
      base_url = file.path("test", "play.dhis2.org", "dev")
    ),
    regexp = cat("The base URL should start with 'https://'")
  )
})

test_that("dhis2_subset_fields works as expected", {
  data <- readepi(
    credentials_file   = system.file("extdata", "test.ini", package = "readepi"),
    source             = "https://play.dhis2.org/dev",
    dataset            = "pBOMPrpg1QX,BfMAe6Itzgt",
    organisation_unit  = "DiszpKrYNg8",
    data_element_group = NULL,
    start_date         = "2014",
    end_date           = "2023"
  )[["data"]]
  results <- dhis2_subset_fields(
    data = data,
    fields = c("dataElement", "period", "value")
  )
  expect_s3_class(results, "data.frame")
  expect_length(results, 3L)
  expect_named(results, c("dataElement", "period", "value"))
})

test_that("dhis2_subset_fields fails as expected", {
  data <- readepi(
    credentials_file   = system.file("extdata", "test.ini", package = "readepi"),
    source             = "https://play.dhis2.org/dev",
    dataset            = "pBOMPrpg1QX,BfMAe6Itzgt",
    organisation_unit  = "DiszpKrYNg8",
    data_element_group = NULL,
    start_date         = "2014",
    end_date           = "2023"
  )[["data"]]
  expect_error(
    dhis2_subset_fields(
      data   = data,
      fields = c(1, 2, 3) # nolint
    ),
    regexp = cat("The value for the 'fields' argument should be a vector of
                 character.")
  )
})

test_that("dhis2_subset_records works as expected", {
  data <- readepi(
    credentials_file   = system.file("extdata", "test.ini", package = "readepi"),
    source             = "https://play.dhis2.org/dev",
    dataset            = "pBOMPrpg1QX,BfMAe6Itzgt",
    organisation_unit  = "DiszpKrYNg8",
    data_element_group = NULL,
    start_date         = "2014",
    end_date           = "2023"
  )[["data"]]
  result <- dhis2_subset_records(
    data        = data,
    records     = c("FTRrcoaog83", "eY5ehpbEsB7", "Ix2HsbDMLea"),
    id_col_name = "dataElement"
  )
  expect_s3_class(result, "data.frame")
})

test_that("dhis2_subset_records fails as expected", {
  data <- readepi(
    credentials_file   = system.file("extdata", "test.ini", package = "readepi"),
    source             = "https://play.dhis2.org/dev",
    dataset            = "pBOMPrpg1QX,BfMAe6Itzgt",
    organisation_unit  = "DiszpKrYNg8",
    data_element_group = NULL,
    start_date         = "2014",
    end_date           = "2023"
  )[["data"]]
  expect_error(
    dhis2_subset_records(
      data        = data,
      records     = c(1, 2, 3), # nolint
      id_col_name = "dataElement"
    ),
    regexp = cat("The value for the 'records' argument should be a vector of
                 character.")
  )
})
