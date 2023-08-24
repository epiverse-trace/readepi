test_that("readepi works as expected when reading from DBMS", {
  data <- readepi(
    data_source      = "mysql-rfam-public.ebi.ac.uk",
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    sep              = NULL,
    format           = NULL,
    which            = NULL,
    pattern          = NULL,
    driver_name      = "",
    table_name       = "author",
    records          = NULL,
    fields           = NULL,
    id_position      = 1L,
    id_col_name      = NULL
  )
  expect_type(data, "list")
})

test_that("readepi works as expected when reading from Fingertips", {
  data <- readepi(
    indicator_id = 90362L,
    area_type_id = 202L,
    indicator_name = "Healthy life expectancy at birth",
    domain_id = 1000049L,
    domain_name = "A. Overarching indicators",
    profile_id = 19L,
    profile_name = "Public Health Outcomes Framework",
    fields = c("IndicatorID", "AreaCode", "Age", "Value"),
    records = c("E12000002", "E12000001", "E12000009"),
    id_col_name = "AreaCode"
  )
  expect_type(data, "list")

  data <- readepi(
    indicator_id = 90362L,
    area_type_id = 202L,
    records = NULL,
    fields = NULL,
    id_position = NULL,
    id_col_name = NULL
  )
  expect_type(data, "list")

  data <- readepi(
    indicator_id = 90362L,
    area_type_id = 202L,
    indicator_name = "Healthy life expectancy at birth",
    records = NULL,
    fields = NULL,
    id_position = NULL,
    id_col_name = NULL
  )
  expect_type(data, "list")

  data <- readepi(
    area_type_id = 202L,
    indicator_name = "Healthy life expectancy at birth",
    records = NULL,
    fields = NULL,
    id_position = NULL,
    id_col_name = NULL
  )
  expect_type(data, "list")
  expect_length(data, 1L)
  expect_named(data, "data")
  expect_s3_class(data[["data"]], "data.frame")

  data <- readepi(
    area_type_id = 202L,
    domain_name = "A. Overarching indicators",
    records = NULL,
    fields = NULL,
    id_position = NULL,
    id_col_name = NULL
  )
  expect_type(data, "list")

  data <- readepi(
    area_type_id = 202L,
    domain_id = 1000049L,
    records = NULL,
    fields = NULL,
    id_position = NULL,
    id_col_name = NULL
  )
  expect_type(data, "list")

  data <- readepi(
    area_type_id = 202L,
    profile_id = 19L,
    records = NULL,
    fields = NULL,
    id_position = NULL,
    id_col_name = NULL
  )
  expect_type(data, "list")

  data <- readepi(
    area_type_id = 202L,
    profile_name = "Public Health Outcomes Framework",
    records = NULL,
    fields = NULL,
    id_position = NULL,
    id_col_name = NULL
  )
  expect_type(data, "list")
})


test_that("readepi works as expected when reading from file", {
  data <- readepi(
    data_source      = system.file("extdata", "test.json", package = "readepi"),
    sep              = NULL,
    format           = NULL,
    which            = NULL,
    pattern          = NULL,
    driver_name      = NULL,
    table_name       = NULL,
    records          = NULL,
    fields           = NULL,
    id_position      = 1L
  )
  expect_type(data, "list")
})

test_that("readepi works as expected when reading from DBMS", {
  data <- readepi(
    data_source      = "mysql-rfam-public.ebi.ac.uk",
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    sep              = NULL,
    format           = NULL,
    which            = NULL,
    pattern          = NULL,
    driver_name      = "",
    table_name       = "author",
    records          = NULL,
    fields           = NULL,
    id_position      = 1L
  )
  expect_type(data, "list")
})

test_that("readepi works as expected when reading from a directory", {
  data <- readepi(
    data_source      = system.file("extdata", package = "readepi"),
    sep              = NULL,
    format           = NULL,
    which            = NULL,
    pattern          = "txt",
    driver_name      = NULL,
    table_name       = NULL,
    records          = NULL,
    fields           = NULL,
    id_position      = 1L
  )
  expect_type(data, "list")
})

test_that("readepi fails as expected when reading from DHIS2", {
  expect_error(
    readepi(
      data_source        = "https://play.dhis2.org/dev",
      credentials_file   = NULL,
      dataset            = "pBOMPrpg1QX",
      organisation_unit  = "DiszpKrYNg8",
      data_element_group = NULL,
      start_date         = "2014",
      end_date           = "202L3"
    ),
    regexp = cat("Assertion on',credentials_file,'failed: Must be specified.")
  )

  expect_error(
    readepi(
      data_source        = "https://play.dhis2.org/dev",
      credentials_file   = c(
                             system.file("extdata", "test.ini",
                                         package = "readepi"),
                             system.file("extdata", "fake_test.ini",
                                         package = "readepi")),
      dataset            = "pBOMPrpg1QX",
      organisation_unit  = "DiszpKrYNg8",
      data_element_group = NULL,
      start_date         = "2014",
      end_date           = "202L3"
    ),
    regexp = cat("Assertion on',credentials_file,'failed: Must be of type
                 character with length 1.")
  )

  expect_error(
    readepi(
      data_source        = "https://play.dhis2.org/dev",
      credentials_file   = system.file("extdata", "test.ini",
                                       package = "readepi"),
      dataset            = NA,
      organisation_unit  = "DiszpKrYNg8",
      data_element_group = NULL,
      start_date         = "2014",
      end_date           = "202L3"
    ),
    regexp = cat("Assertion on',dataset,'failed: Missing value not allowed.")
  )

  expect_error(
    readepi(
      data_source        = "https://play.dhis2.org/dev",
      credentials_file   = system.file("extdata", "test.ini",
                                       package = "readepi"),
      dataset            = NULL,
      organisation_unit  = "DiszpKrYNg8",
      data_element_group = NULL,
      start_date         = "2014",
      end_date           = "202L3"
    ),
    regexp = cat("Assertion on',dataset,'failed: Must be specified.")
  )

  expect_error(
    readepi(
      data_source        = "https://play.dhis2.org/dev",
      credentials_file   = system.file("extdata", "test.ini",
                                       package = "readepi"),
      dataset            = "pBOMPrpg1QX",
      organisation_unit  = NA,
      data_element_group = NULL,
      start_date         = "2014",
      end_date           = "202L3"
    ),
    regexp = cat("Assertion on',organisation_unit,'failed: Missing value
                 not allowed.")
  )

  expect_error(
    readepi(
      data_source        = "https://play.dhis2.org/dev",
      credentials_file   = system.file("extdata", "test.ini",
                                       package = "readepi"),
      dataset            = "pBOMPrpg1QX",
      organisation_unit  = NULL,
      data_element_group = NULL,
      start_date         = "2014",
      end_date           = "202L3"
    ),
    regexp = cat("Assertion on',organisation_unit,'failed: Must be specified.")
  )

  expect_error(
    readepi(
      data_source        = "https://play.dhis2.org/dev",
      credentials_file   = system.file("extdata", "test.ini",
                                       package = "readepi"),
      dataset            = "pBOMPrpg1QX",
      organisation_unit  = "DiszpKrYNg8",
      data_element_group = NA,
      start_date         = "2014",
      end_date           = "202L3"
    ),
    regexp = cat("Assertion on',data_element_group,'failed: Missing value
                 not allowed.")
  )

  expect_error(
    readepi(
      data_source        = "https://play.dhis2.org/dev",
      credentials_file   = system.file("extdata", "test.ini",
                                       package = "readepi"),
      dataset            = "pBOMPrpg1QX",
      organisation_unit  = "DiszpKrYNg8",
      data_element_group = NULL,
      start_date         = NA,
      end_date           = "202L3"
    ),
    regexp = cat("Assertion on',start_date,'failed: Missing value not allowed.")
  )

  expect_error(
    readepi(
      data_source        = "https://play.dhis2.org/dev",
      credentials_file   = system.file("extdata", "test.ini",
                                       package = "readepi"),
      dataset            = "pBOMPrpg1QX",
      organisation_unit  = "DiszpKrYNg8",
      data_element_group = NULL,
      start_date         = "2014",
      end_date           = NA
    ),
    regexp = cat("Assertion on',end_date,'failed: Missing value not allowed.")
  )
})

test_that("readepi works as expected when reading from REDCap", {
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
  expect_error(
    readepi(
      credentials_file = c(
                           system.file("extdata", "test.ini",
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

test_that("readepi fails as expected when reading from DBMS,
          files and folders", {
            expect_error(
              readepi(
                credentials_file = system.file("extdata", "test.ini",
                                               package = "readepi"),
                data_source      = "mysql-rfam-public.ebi.ac.uk",
                sep              = NULL,
                format           = NULL,
                which            = NULL,
                pattern          = NULL,
                driver_name      = NULL,
                table_name       = "author",
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
                sep              = NULL,
                format           = NULL,
                which            = NULL,
                pattern          = NULL,
                driver_name      = NULL,
                table_name       = "author",
                records          = NULL,
                fields           = NULL,
                id_position      = 1L
              ),
              regexp = cat("Assertion on',credentials_file,and,'file_path',failed: # nolint:line_length_linter
                           Must provide either a file path, or a directory or a credential # nolint: line_length_linter
                           file.")
            )

            expect_error(
              readepi(
                credentials_file = NULL,
                data_source      = "mysql-rfam-public.ebi.ac.uk",
                sep              = c(",", "\t"),
                format           = NULL,
                which            = NULL,
                pattern          = NULL,
                driver_name      = NULL,
                table_name       = NULL,
                records          = NULL,
                fields           = NULL,
                id_position      = 1L
              ),
              regexp = cat("Assertion on',sep,'failed: Must be a character of
                           length 1.")
            )
          })


test_that("readepi fails as expected when reading from Fingertips", {
  expect_error(
    readepi(
      indicator_id = NA,
      area_type_id = 202L,
      indicator_name = "Healthy life expectancy at birth",
      domain_id = 1000049L,
      domain_name = "A. Overarching indicators",
      profile_id = 19L,
      profile_name = "Public Health Outcomes Framework",
      fields = c("IndicatorID", "AreaCode", "Age", "Value"),
      records = c("E12000002", "E12000001", "E12000009"),
      id_col_name = "AreaCode"
    ),
    regexp = cat("Assertion on',indicator_id,'failed: Missing value
                 not allowed.")
  )

  expect_error(
    readepi(
      indicator_id = 90362L,
      area_type_id = 202L,
      indicator_name = NA,
      domain_id = 1000049L,
      domain_name = "A. Overarching indicators",
      profile_id = 19L,
      profile_name = "Public Health Outcomes Framework",
      fields = c("IndicatorID", "AreaCode", "Age", "Value"),
      records = c("E12000002", "E12000001", "E12000009"),
      id_col_name = "AreaCode"
    ),
    regexp = cat("Assertion on',indicator_name,'failed: Missing value
                 not allowed.")
  )

  expect_error(
    readepi(
      indicator_id = 90362L,
      area_type_id = NA,
      indicator_name = "Healthy life expectancy at birth",
      domain_id = 1000049L,
      domain_name = "A. Overarching indicators",
      profile_id = 19L,
      profile_name = "Public Health Outcomes Framework",
      fields = c("IndicatorID", "AreaCode", "Age", "Value"),
      records = c("E12000002", "E12000001", "E12000009"),
      id_col_name = "AreaCode"
    ),
    regexp = cat("Assertion on',area_type_id,'failed: Missing value
                 not allowed.")
  )

  expect_error(
    readepi(
      indicator_id = 90362L,
      area_type_id = 202L,
      indicator_name = "Healthy life expectancy at birth",
      domain_id = NA,
      domain_name = "A. Overarching indicators",
      profile_id = 19L,
      profile_name = "Public Health Outcomes Framework",
      fields = c("IndicatorID", "AreaCode", "Age", "Value"),
      records = c("E12000002", "E12000001", "E12000009"),
      id_col_name = "AreaCode"
    ),
    regexp = cat("Assertion on',domain_id,'failed: Missing value not allowed.")
  )

  expect_error(
    readepi(
      indicator_id = 90362L,
      area_type_id = 202L,
      indicator_name = "Healthy life expectancy at birth",
      domain_id = 1000049L,
      domain_name = NA,
      profile_id = 19L,
      profile_name = "Public Health Outcomes Framework",
      fields = c("IndicatorID", "AreaCode", "Age", "Value"),
      records = c("E12000002", "E12000001"),
      id_col_name = "AreaCode"
    ),
    regexp = cat("Assertion on',domain_name,'failed: Missing value
                 not allowed.")
  )

  expect_error(
    readepi(
      indicator_id = 90362L,
      area_type_id = 202L,
      indicator_name = "Healthy life expectancy at birth",
      domain_id = 1000049L,
      domain_name = "A. Overarching indicators",
      profile_id = NA,
      profile_name = "Public Health Outcomes Framework",
      fields = c("IndicatorID", "AreaCode", "Age", "Value"),
      records = c("E12000002", "E12000001", "E12000009"),
      id_col_name = "AreaCode"
    ),
    regexp = cat("Assertion on',profile_id,'failed: Missing value not allowed.")
  )

  expect_error(
    readepi(
      indicator_id = 90362L,
      area_type_id = 202L,
      indicator_name = "Healthy life expectancy at birth",
      domain_id = 1000049L,
      domain_name = "A. Overarching indicators",
      profile_id = 19L,
      profile_name = NA,
      fields = c("IndicatorID", "AreaCode", "Age", "Value"),
      records = c("E12000002", "E12000001", "E12000009"),
      id_col_name = "AreaCode"
    ),
    regexp = cat("Assertion on',profile_name,'failed: Missing value
                 not allowed.")
  )
})
