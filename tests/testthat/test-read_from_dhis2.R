test_that("read_from_dhis2 works as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  data <- read_from_dhis2(
    base_url         = file.path("https:/", "play.im.dhis2.org", "dev"),
    user_name        = "admin",
    password         = "district",
    query_parameters = list(dataSet   = "BfMAe6Itzgt",
                            orgUnit   = "Umh4HKqqFp6",
                            startDate = "2014",
                            endDate   = "2023"),
    records          = NULL,
    fields           = NULL,
    id_col_name      = "dataElement"
  )
  expect_type(data, "list")
  expect_length(data, 2L)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data[["data"]], class = "data.frame")
  expect_identical(data[["metadata"]], NA)
})

test_that("read_from_dhis2 works as expected when subsetting on columns and
          records is allowed", {
            testthat::skip_on_cran()
            testthat::skip_if_offline()
            data <- read_from_dhis2(
              base_url         = file.path("https:/", "play.im.dhis2.org",
                                           "dev"),
              user_name        = "admin",
              password         = "district",
              query_parameters = list(dataSet   = "BfMAe6Itzgt",
                                      orgUnit   = "Umh4HKqqFp6",
                                      startDate = "2014",
                                      endDate   = "2023"),
              records          = c("pikOziyCXbM", "x3Do5e7g4Qo", "ldGXl6SEdqf"),
              fields           = c("dataElement", "period", "value"),
              id_col_name      = "dataElement"
            )
            expect_type(data, "list")
            expect_length(data, 2L)
            expect_named(data, c("data", "metadata"))
            expect_s3_class(data[["data"]], class = "data.frame")
            expect_identical(data[["metadata"]], NA)
          })

test_that("read_from_dhis2 fails with a wrong URL", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  expect_error(
    read_from_dhis2(
      base_url         = NULL,
      user_name        = "admin",
      password         = "district",
      query_parameters = list(dataSet   = "BfMAe6Itzgt",
                              orgUnit   = "Umh4HKqqFp6",
                              startDate = "2014",
                              endDate   = "2023"),
      records          = c("FTRrcoaog83", "eY5ehpbEsB7", "Ix2HsbDMLea"),
      fields           = c("dataElement", "period", "value"),
      id_col_name      = "dataElement"
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be provided.")
  )

  expect_error(
    read_from_dhis2(
      base_url         = NA,
      user_name        = "admin",
      password         = "district",
      query_parameters = list(dataSet   = "BfMAe6Itzgt",
                              orgUnit   = "Umh4HKqqFp6",
                              startDate = "2014",
                              endDate   = "2023"),
      records          = c("pikOziyCXbM", "x3Do5e7g4Qo", "ldGXl6SEdqf"),
      fields           = c("dataElement", "period", "value"),
      id_col_name      = "dataElement"
    ),
    regexp = cat("Assertion on',base_url,'failed: Missing value not allowed for
                 base_url argument.")
  )

  expect_error(
    read_from_dhis2(
      base_url = c(
        file.path("https:/", "play.im.dhis2.org", "dev"),
        file.path("https:/", "play.im.dhis2.org", "dev")
      ),
      user_name        = "admin",
      password         = "district",
      query_parameters = list(dataSet   = "BfMAe6Itzgt",
                              orgUnit   = "Umh4HKqqFp6",
                              startDate = "2014",
                              endDate   = "2023"),
      records          = c("pikOziyCXbM", "x3Do5e7g4Qo", "ldGXl6SEdqf"),
      fields           = c("dataElement", "period", "value"),
      id_col_name      = "dataElement"
    ),
    regexp = cat("Assertion on',base_url,'failed: should provide only one URL at
                 a time.")
  )
})

test_that("read_from_dhis2 fails with a wrong user_name", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  expect_error(
    read_from_dhis2(
      base_url         = file.path("https:/", "play.im.dhis2.org", "dev"),
      user_name        = NULL,
      password         = "district",
      query_parameters = list(dataSet   = "BfMAe6Itzgt",
                              orgUnit   = "Umh4HKqqFp6",
                              startDate = "2014",
                              endDate   = "2023"),
      records          = c("pikOziyCXbM", "x3Do5e7g4Qo", "ldGXl6SEdqf"),
      fields           = c("dataElement", "period", "value"),
      id_col_name      = "dataElement"
    ),
    regexp = cat("Assertion on',user_name,'failed: Must be provided.")
  )
})
