test_that("readepi works as expected when reading from DBMS", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  data <- readepi(
    data_source      = "mysql-rfam-public.ebi.ac.uk",
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    driver_name      = "",
    from             = "author",
    records          = NULL,
    fields           = NULL,
    id_position      = 1L,
    id_col_name      = NULL
  )
  expect_type(data, "list")
})

test_that("readepi works as expected when reading from Fingertips", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  data <- readepi(
    indicator_id   = 90362L,
    area_type_id   = 6L,
    indicator_name = "Healthy life expectancy at birth",
    domain_id      = 1000049L,
    domain_name    = "A. Overarching indicators",
    profile_id     = 19L,
    profile_name   = "Public Health Outcomes Framework",
    fields         = c("IndicatorID", "AreaCode", "Age", "Value"),
    records        = c("E12000002", "E12000001", "E12000009"),
    id_col_name    = "AreaCode"
  )
  expect_type(data, "list")
  expect_length(data, 2L)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data[["data"]], class = "data.frame")
  expect_identical(data[["metadata"]], NA)

  data <- readepi(
    indicator_id = 90362L,
    area_type_id = 6L,
    records      = NULL,
    fields       = NULL,
    id_position  = NULL,
    id_col_name  = NULL
  )
  expect_type(data, "list")
  expect_length(data, 2L)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data[["data"]], class = "data.frame")
  expect_identical(data[["metadata"]], NA)

  data <- readepi(
    indicator_id   = 90362L,
    area_type_id   = 6L,
    indicator_name = "Healthy life expectancy at birth",
    records        = NULL,
    fields         = NULL,
    id_position    = NULL,
    id_col_name    = NULL
  )
  expect_type(data, "list")
  expect_length(data, 2L)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data[["data"]], class = "data.frame")
  expect_identical(data[["metadata"]], NA)

  data <- readepi(
    area_type_id   = 6L,
    indicator_name = "Healthy life expectancy at birth",
    records        = NULL,
    fields         = NULL,
    id_position    = NULL,
    id_col_name    = NULL
  )
  expect_type(data, "list")
  expect_length(data, 2L)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data[["data"]], class = "data.frame")
  expect_identical(data[["metadata"]], NA)

  data <- readepi(
    area_type_id = 6L,
    domain_name  = "A. Overarching indicators",
    records      = NULL,
    fields       = NULL,
    id_position  = NULL,
    id_col_name  = NULL
  )
  expect_type(data, "list")
  expect_length(data, 2L)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data[["data"]], class = "data.frame")
  expect_identical(data[["metadata"]], NA)

  data <- readepi(
    area_type_id = 6L,
    domain_id    = 1000049L,
    records      = NULL,
    fields       = NULL,
    id_position  = NULL,
    id_col_name  = NULL
  )
  expect_type(data, "list")
  expect_length(data, 2L)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data[["data"]], class = "data.frame")
  expect_identical(data[["metadata"]], NA)

  data <- readepi(
    area_type_id = 6L,
    profile_id   = 19L,
    records      = NULL,
    fields       = NULL,
    id_position  = NULL,
    id_col_name  = NULL
  )
  expect_type(data, "list")
  expect_length(data, 2L)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data[["data"]], class = "data.frame")
  expect_identical(data[["metadata"]], NA)

  data <- readepi(
    area_type_id = 6L,
    profile_name = "Public Health Outcomes Framework",
    records      = NULL,
    fields       = NULL,
    id_position  = NULL,
    id_col_name  = NULL
  )
  expect_type(data, "list")
  expect_length(data, 2L)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data[["data"]], class = "data.frame")
  expect_identical(data[["metadata"]], NA)
})

test_that("readepi works as expected when reading from DBMS", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  data <- readepi(
    data_source      = "mysql-rfam-public.ebi.ac.uk",
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    driver_name      = "",
    from             = "author",
    records          = NULL,
    fields           = NULL,
    id_position      = 1L
  )
  expect_type(data, "list")
})

test_that("readepi fails as expected when reading from DHIS2", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  expect_error(
    readepi(
      data_source      = "https://play.dhis2.org/dev",
      credentials_file = NULL,
      query_parameters = list(dataSet   = "pBOMPrpg1QX",
                              orgUnit   = "DiszpKrYNg8",
                              startDate = "2014",
                              endDate   = "202L3")

    ),
    regexp = cat("Assertion on',credentials_file,'failed: Must be specified.")
  )

  expect_error(
    readepi(
      data_source = "https://play.dhis2.org/dev",
      credentials_file   = c(system.file("extdata", "test.ini",
                                         package = "readepi"),
                             system.file("extdata", "fake_test.ini",
                                         package = "readepi")),
      query_parameters = list(dataSet   = "pBOMPrpg1QX",
                              orgUnit   = "DiszpKrYNg8",
                              startDate = "2014",
                              endDate   = "202L3")
    ),
    regexp = cat("Assertion on',credentials_file,'failed: Must be of type
                 character with length 1.")
  )
})

test_that("readepi works as expected when reading from REDCap", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  data <- readepi(
    data_source      = "https://bbmc.ouhsc.edu/redcap/api/",
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    records          = c("1", "3", "5"),
    fields           = c("record_id", "name_first", "age", "bmi"),
    id_col_name      = "record_id"
  )
  expect_type(data, "list")
  expect_length(data, 2L)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data[["data"]], class = "data.frame")
  expect_s3_class(data[["metadata"]], class = "data.frame")

  data <- readepi(
    data_source      = "https://bbmc.ouhsc.edu/redcap/api/",
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    records          = c("1", "3", "5"),
    fields           = c("record_id", "name_first", "age", "bmi"),
    id_position      = 1L
  )
  expect_type(data, "list")
  expect_length(data, 2L)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data[["data"]], class = "data.frame")
  expect_s3_class(data[["metadata"]], class = "data.frame")

  data <- readepi(
    data_source      = "https://bbmc.ouhsc.edu/redcap/api/",
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    records          = "1, 3, 5",
    fields           = "record_id, name_first, age, bmi",
    id_position      = 1L
  )
  expect_type(data, "list")
  expect_length(data, 2L)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data[["data"]], class = "data.frame")
  expect_s3_class(data[["metadata"]], class = "data.frame")

  data <- readepi(
    data_source      = "https://bbmc.ouhsc.edu/redcap/api/",
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    records          = "1, 3, 5",
    fields           = "record_id, name_first, age, bmi",
    id_col_name      = "record_id"
  )
  expect_type(data, "list")
  expect_length(data, 2L)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data[["data"]], class = "data.frame")
  expect_s3_class(data[["metadata"]], class = "data.frame")

  data <- readepi(
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    data_source      = "https://bbmc.ouhsc.edu/redcap/api/",
    records          = NULL,
    fields           = NULL
  )
  expect_type(data, "list")
  expect_length(data, 2L)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data[["data"]], class = "data.frame")
  expect_s3_class(data[["metadata"]], class = "data.frame")
})

test_that("readepi fails as expected when reading from REDCap", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  expect_error(
    readepi(
      credentials_file = c(system.file("extdata", "test.ini",
                                       package = "readepi"),
                           system.file("extdata", "fake_test.ini",
                                       package = "readepi")),
      data_source      = "https://bbmc.ouhsc.edu/redcap/api/",
      records          = "1, 3, 5",
      fields           = "record_id, name_first, age, bmi",
      id_col_name      = "id"
    ),
    regexp = cat("Assertion on',credentials_file,'failed: Must be of type
                 character of length 1.")
  )

  expect_error(
    readepi(
      credentials_file = NULL,
      data_source      = "https://bbmc.ouhsc.edu/redcap/api/",
      records          = "1, 3, 5",
      fields           = "record_id, name_first, age, bmi",
      id_col_name      = "id"
    ),
    regexp = cat("Assertion on',credentials_file,'failed: Must be specified.")
  )

  expect_error(
    readepi(
      credentials_file = system.file("extdata", "test.ini",
                                     package = "readepi"),
      data_source      = "https://bbmc.ouhsc.edu/redcap/api/",
      records          = NA,
      fields           = "record_id, name_first, age, bmi",
      id_col_name      = "id"
    ),
    regexp = cat("Assertion on',records,'failed: Missing value not allowed.")
  )

  expect_error(
    readepi(
      credentials_file = system.file("extdata", "test.ini",
                                     package = "readepi"),
      data_source      = "https://bbmc.ouhsc.edu/redcap/api/",
      records          = "1, 3, 5",
      fields           = NA,
      id_col_name      = "id"
    ),
    regexp = cat("Assertion on',fields,'failed: Missing value not allowed.")
  )

  expect_error(
    readepi(
      credentials_file = system.file("extdata", "test.ini",
                                     package = "readepi"),
      data_source      = "https://bbmc.ouhsc.edu/redcap/api/",
      records          = "1, 3, 5",
      fields           = "record_id, name_first, age, bmi",
      id_col_name      = NA
    ),
    regexp = cat("Assertion on',id_col_name,'failed: Missing value
                 not allowed.")
  )

  expect_error(
    readepi(
      credentials_file = system.file("extdata", "test.ini",
                                     package = "readepi"),
      data_source      = "https://bbmc.ouhsc.edu/redcap/api/",
      records          = "1, 3, 5",
      fields           = "record_id, name_first, age, bmi",
      id_col_name      = NULL,
      id_position      = NA
    ),
    regexp = cat("Assertion on',id_position,'failed: Missing value
                 not allowed.")
  )
})

test_that("readepi fails as expected when reading from DBMS", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  expect_error(
    readepi(
      credentials_file = system.file("extdata", "test.ini",
                                     package = "readepi"),
      data_source      = "mysql-rfam-public.ebi.ac.uk",
      driver_name      = NULL,
      from             = "author",
      records          = NULL,
      fields           = NULL,
      id_position      = 1L
    ),
    regexp = cat("Assertion on',driver_name,failed: MS driver name
                 must be provided.")
  )

  expect_error(
    readepi(
      credentials_file = NULL,
      data_source      = "mysql-rfam-public.ebi.ac.uk",
      driver_name      = "",
      from             = "author",
      records          = NULL,
      fields           = NULL,
      id_position      = 1L
    ),
    regexp = cat("Assertion on',credentials_file,and,'file_path',
    failed: Must provide either a file path, or a directory or a
    credential file.")
  )
})


test_that("readepi fails as expected when reading from Fingertips", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  expect_error(
    readepi(
      indicator_id   = NA,
      area_type_id   = 102L,
      indicator_name = "Healthy life expectancy at birth",
      domain_id      = 1000049L,
      domain_name    = "A. Overarching indicators",
      profile_id     = 19L,
      profile_name   = "Public Health Outcomes Framework",
      fields         = c("IndicatorID", "AreaCode", "Age", "Value"),
      records        = c("E12000002", "E12000001", "E12000009"),
      id_col_name    = "AreaCode"
    ),
    regexp = cat("Assertion on',indicator_id,'failed: Missing value
                 not allowed.")
  )

  expect_error(
    readepi(
      indicator_id   = 90362L,
      area_type_id   = 102L,
      indicator_name = NA,
      domain_id      = 1000049L,
      domain_name    = "A. Overarching indicators",
      profile_id     = 19L,
      profile_name   = "Public Health Outcomes Framework",
      fields         = c("IndicatorID", "AreaCode", "Age", "Value"),
      records        = c("E12000002", "E12000001", "E12000009"),
      id_col_name    = "AreaCode"
    ),
    regexp = cat("Assertion on',indicator_name,'failed: Missing value
                 not allowed.")
  )

  expect_error(
    readepi(
      indicator_id   = 90362L,
      area_type_id   = NA,
      indicator_name = "Healthy life expectancy at birth",
      domain_id      = 1000049L,
      domain_name    = "A. Overarching indicators",
      profile_id     = 19L,
      profile_name   = "Public Health Outcomes Framework",
      fields         = c("IndicatorID", "AreaCode", "Age", "Value"),
      records        = c("E12000002", "E12000001", "E12000009"),
      id_col_name    = "AreaCode"
    ),
    regexp = cat("Assertion on',area_type_id,'failed: Missing value
                 not allowed.")
  )

  expect_error(
    readepi(
      indicator_id   = 90362L,
      area_type_id   = 102L,
      indicator_name = "Healthy life expectancy at birth",
      domain_id      = NA,
      domain_name    = "A. Overarching indicators",
      profile_id     = 19L,
      profile_name   = "Public Health Outcomes Framework",
      fields         = c("IndicatorID", "AreaCode", "Age", "Value"),
      records        = c("E12000002", "E12000001", "E12000009"),
      id_col_name    = "AreaCode"
    ),
    regexp = cat("Assertion on',domain_id,'failed: Missing value not allowed.")
  )

  expect_error(
    readepi(
      indicator_id   = 90362L,
      area_type_id   = 102L,
      indicator_name = "Healthy life expectancy at birth",
      domain_id      = 1000049L,
      domain_name    = NA,
      profile_id     = 19L,
      profile_name   = "Public Health Outcomes Framework",
      fields         = c("IndicatorID", "AreaCode", "Age", "Value"),
      records        = c("E12000002", "E12000001"),
      id_col_name    = "AreaCode"
    ),
    regexp = cat("Assertion on',domain_name,'failed: Missing value
                 not allowed.")
  )

  expect_error(
    readepi(
      indicator_id   = 90362L,
      area_type_id   = 102L,
      indicator_name = "Healthy life expectancy at birth",
      domain_id      = 1000049L,
      domain_name    = "A. Overarching indicators",
      profile_id     = NA,
      profile_name   = "Public Health Outcomes Framework",
      fields         = c("IndicatorID", "AreaCode", "Age", "Value"),
      records        = c("E12000002", "E12000001", "E12000009"),
      id_col_name    = "AreaCode"
    ),
    regexp = cat("Assertion on',profile_id,'failed: Missing value not allowed.")
  )

  expect_error(
    readepi(
      indicator_id   = 90362L,
      area_type_id   = 102L,
      indicator_name = "Healthy life expectancy at birth",
      domain_id      = 1000049L,
      domain_name    = "A. Overarching indicators",
      profile_id     = 19L,
      profile_name   = NA,
      fields         = c("IndicatorID", "AreaCode", "Age", "Value"),
      records        = c("E12000002", "E12000001", "E12000009"),
      id_col_name    = "AreaCode"
    ),
    regexp = cat("Assertion on',profile_name,'failed: Missing value
                 not allowed.")
  )
})
