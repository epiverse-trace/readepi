test_that("readepi works as expected when reading from DBMS", {
  data <- readepi(
<<<<<<< HEAD
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    project_id = "Rfam",
    file_path = NULL,
    sep = NULL,
    format = NULL,
    which = NULL,
    pattern = NULL,
    driver_name = "",
    table_name = "author",
    records = NULL,
    fields = NULL,
    id_position = 1,
    id_col_name = NULL
=======
    data_source      = "mysql-rfam-public.ebi.ac.uk",
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    driver_name      = "",
    table_name       = "author",
    records          = NULL,
    fields           = NULL,
    id_position      = 1L,
    id_col_name      = NULL
>>>>>>> review
  )
  expect_type(data, "list")
})

test_that("readepi works as expected when reading from Fingertips", {
  data <- readepi(
<<<<<<< HEAD
    indicator_id = 90362,
    area_type_id = 202,
    indicator_name = "Healthy life expectancy at birth",
    domain_id = 1000049,
    domain_name = "A. Overarching indicators",
    profile_id = 19,
=======
    indicator_id = 90362L,
    area_type_id = 202L,
    indicator_name = "Healthy life expectancy at birth",
    domain_id = 1000049L,
    domain_name = "A. Overarching indicators",
    profile_id = 19L,
>>>>>>> review
    profile_name = "Public Health Outcomes Framework",
    fields = c("IndicatorID", "AreaCode", "Age", "Value"),
    records = c("E12000002", "E12000001", "E12000009"),
    id_col_name = "AreaCode"
  )
  expect_type(data, "list")

  data <- readepi(
<<<<<<< HEAD
    indicator_id = 90362,
    area_type_id = 202,
=======
    indicator_id = 90362L,
    area_type_id = 202L,
>>>>>>> review
    records = NULL,
    fields = NULL,
    id_position = NULL,
    id_col_name = NULL
  )
  expect_type(data, "list")

  data <- readepi(
<<<<<<< HEAD
    indicator_id = 90362,
    area_type_id = 202,
=======
    indicator_id = 90362L,
    area_type_id = 202L,
>>>>>>> review
    indicator_name = "Healthy life expectancy at birth",
    records = NULL,
    fields = NULL,
    id_position = NULL,
    id_col_name = NULL
  )
  expect_type(data, "list")

  data <- readepi(
<<<<<<< HEAD
    area_type_id = 202,
=======
    area_type_id = 202L,
>>>>>>> review
    indicator_name = "Healthy life expectancy at birth",
    records = NULL,
    fields = NULL,
    id_position = NULL,
    id_col_name = NULL
  )
  expect_type(data, "list")
<<<<<<< HEAD

  data <- readepi(
    area_type_id = 202,
=======
  expect_length(data, 1L)
  expect_named(data, "data")
  expect_s3_class(data[["data"]], "data.frame")

  data <- readepi(
    area_type_id = 202L,
>>>>>>> review
    domain_name = "A. Overarching indicators",
    records = NULL,
    fields = NULL,
    id_position = NULL,
    id_col_name = NULL
  )
  expect_type(data, "list")

  data <- readepi(
<<<<<<< HEAD
    area_type_id = 202,
    domain_id = 1000049,
=======
    area_type_id = 202L,
    domain_id = 1000049L,
>>>>>>> review
    records = NULL,
    fields = NULL,
    id_position = NULL,
    id_col_name = NULL
  )
  expect_type(data, "list")

  data <- readepi(
<<<<<<< HEAD
    area_type_id = 202,
    profile_id = 19,
=======
    area_type_id = 202L,
    profile_id = 19L,
>>>>>>> review
    records = NULL,
    fields = NULL,
    id_position = NULL,
    id_col_name = NULL
  )
  expect_type(data, "list")

  data <- readepi(
<<<<<<< HEAD
    area_type_id = 202,
=======
    area_type_id = 202L,
>>>>>>> review
    profile_name = "Public Health Outcomes Framework",
    records = NULL,
    fields = NULL,
    id_position = NULL,
    id_col_name = NULL
  )
  expect_type(data, "list")
})

<<<<<<< HEAD

test_that("readepi works as expected when reading from file", {
  data <- readepi(
    credentials_file = NULL,
    project_id = NULL,
    file_path = system.file("extdata", "test.json", package = "readepi"),
    sep = NULL,
    format = NULL,
    which = NULL,
    pattern = NULL,
    driver_name = NULL,
    table_name = NULL,
    records = NULL,
    fields = NULL,
    id_position = 1
  )
  expect_type(data, "list")
})

test_that("readepi works as expected when reading from DBMS", {
  data <- readepi(
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    project_id = "Rfam",
    file_path = NULL,
    sep = NULL,
    format = NULL,
    which = NULL,
    pattern = NULL,
    driver_name = "",
    table_name = "author",
    records = NULL,
    fields = NULL,
    id_position = 1
  )
  expect_type(data, "list")
})

test_that("readepi works as expected when reading from a directory", {
  data <- readepi(
    credentials_file = NULL,
    project_id = NULL,
    file_path = system.file("extdata", package = "readepi"),
    sep = NULL,
    format = NULL,
    which = NULL,
    pattern = "txt",
    driver_name = NULL,
    table_name = NULL,
    records = NULL,
    fields = NULL,
    id_position = 1
  )
  expect_type(data, "list")
})

test_that("readepi works as expected when reading from DHIS2", {
  data <- readepi(
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    project_id = "DHIS2_DEMO",
    dataset = "pBOMPrpg1QX",
    organisation_unit = "DiszpKrYNg8",
    data_element_group = NULL,
    start_date = "2014",
    end_date = "2023"
=======
test_that("readepi works as expected when reading from DBMS", {
  data <- readepi(
    data_source      = "mysql-rfam-public.ebi.ac.uk",
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    driver_name      = "",
    table_name       = "author",
    records          = NULL,
    fields           = NULL,
    id_position      = 1L
>>>>>>> review
  )
  expect_type(data, "list")
})

test_that("readepi fails as expected when reading from DHIS2", {
  expect_error(
<<<<<<< HEAD
    data <- readepi(
      credentials_file = NULL,
      project_id = "DHIS2_DEMO",
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL,
      start_date = "2014",
      end_date = "2023"
=======
    readepi(
      data_source        = "https://play.dhis2.org/dev",
      credentials_file   = NULL,
      dataset            = "pBOMPrpg1QX",
      organisation_unit  = "DiszpKrYNg8",
      data_element_group = NULL,
      start_date         = "2014",
      end_date           = "202L3"
>>>>>>> review
    ),
    regexp = cat("Assertion on',credentials_file,'failed: Must be specified.")
  )

  expect_error(
<<<<<<< HEAD
    data <- readepi(
      credentials_file = c(
        system.file("extdata", "test.ini", package = "readepi"),
        system.file("extdata", "fake_test.ini", package = "readepi")
      ),
      project_id = "DHIS2_DEMO",
=======
    readepi(
      data_source = "https://play.dhis2.org/dev",
      credentials_file = c(
        system.file("extdata", "test.ini",
          package = "readepi"
        ),
        system.file("extdata", "fake_test.ini",
          package = "readepi"
        )
      ),
>>>>>>> review
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL,
      start_date = "2014",
<<<<<<< HEAD
      end_date = "2023"
=======
      end_date = "202L3"
>>>>>>> review
    ),
    regexp = cat("Assertion on',credentials_file,'failed: Must be of type
                 character with length 1.")
  )

  expect_error(
<<<<<<< HEAD
    data <- readepi(
      credentials_file = system.file("extdata", "test.ini",
                                     package = "readepi"),
      project_id = "DHIS2_DEMO",
=======
    readepi(
      data_source = "https://play.dhis2.org/dev",
      credentials_file = system.file("extdata", "test.ini",
        package = "readepi"
      ),
>>>>>>> review
      dataset = NA,
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL,
      start_date = "2014",
<<<<<<< HEAD
      end_date = "2023"
=======
      end_date = "202L3"
>>>>>>> review
    ),
    regexp = cat("Assertion on',dataset,'failed: Missing value not allowed.")
  )

  expect_error(
<<<<<<< HEAD
    data <- readepi(
      credentials_file = system.file("extdata", "test.ini",
                                     package = "readepi"),
      project_id = "DHIS2_DEMO",
=======
    readepi(
      data_source = "https://play.dhis2.org/dev",
      credentials_file = system.file("extdata", "test.ini",
        package = "readepi"
      ),
>>>>>>> review
      dataset = NULL,
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL,
      start_date = "2014",
<<<<<<< HEAD
      end_date = "2023"
=======
      end_date = "202L3"
>>>>>>> review
    ),
    regexp = cat("Assertion on',dataset,'failed: Must be specified.")
  )

  expect_error(
<<<<<<< HEAD
    data <- readepi(
      credentials_file = system.file("extdata", "test.ini",
                                     package = "readepi"),
      project_id = "DHIS2_DEMO",
=======
    readepi(
      data_source = "https://play.dhis2.org/dev",
      credentials_file = system.file("extdata", "test.ini",
        package = "readepi"
      ),
>>>>>>> review
      dataset = "pBOMPrpg1QX",
      organisation_unit = NA,
      data_element_group = NULL,
      start_date = "2014",
<<<<<<< HEAD
      end_date = "2023"
=======
      end_date = "202L3"
>>>>>>> review
    ),
    regexp = cat("Assertion on',organisation_unit,'failed: Missing value
                 not allowed.")
  )

  expect_error(
<<<<<<< HEAD
    data <- readepi(
      credentials_file = system.file("extdata", "test.ini",
                                     package = "readepi"),
      project_id = "DHIS2_DEMO",
=======
    readepi(
      data_source = "https://play.dhis2.org/dev",
      credentials_file = system.file("extdata", "test.ini",
        package = "readepi"
      ),
>>>>>>> review
      dataset = "pBOMPrpg1QX",
      organisation_unit = NULL,
      data_element_group = NULL,
      start_date = "2014",
<<<<<<< HEAD
      end_date = "2023"
=======
      end_date = "202L3"
>>>>>>> review
    ),
    regexp = cat("Assertion on',organisation_unit,'failed: Must be specified.")
  )

  expect_error(
<<<<<<< HEAD
    data <- readepi(
      credentials_file = system.file("extdata", "test.ini",
                                     package = "readepi"),
      project_id = "DHIS2_DEMO",
=======
    readepi(
      data_source = "https://play.dhis2.org/dev",
      credentials_file = system.file("extdata", "test.ini",
        package = "readepi"
      ),
>>>>>>> review
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NA,
      start_date = "2014",
<<<<<<< HEAD
      end_date = "2023"
=======
      end_date = "202L3"
>>>>>>> review
    ),
    regexp = cat("Assertion on',data_element_group,'failed: Missing value
                 not allowed.")
  )

  expect_error(
<<<<<<< HEAD
    data <- readepi(
      credentials_file = system.file("extdata", "test.ini",
                                     package = "readepi"),
      project_id = "DHIS2_DEMO",
=======
    readepi(
      data_source = "https://play.dhis2.org/dev",
      credentials_file = system.file("extdata", "test.ini",
        package = "readepi"
      ),
>>>>>>> review
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL,
      start_date = NA,
<<<<<<< HEAD
      end_date = "2023"
=======
      end_date = "202L3"
>>>>>>> review
    ),
    regexp = cat("Assertion on',start_date,'failed: Missing value not allowed.")
  )

  expect_error(
<<<<<<< HEAD
    data <- readepi(
      credentials_file = system.file("extdata", "test.ini",
                                     package = "readepi"),
      project_id = "DHIS2_DEMO",
=======
    readepi(
      data_source = "https://play.dhis2.org/dev",
      credentials_file = system.file("extdata", "test.ini",
        package = "readepi"
      ),
>>>>>>> review
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL,
      start_date = "2014",
      end_date = NA
    ),
    regexp = cat("Assertion on',end_date,'failed: Missing value not allowed.")
  )
})

test_that("readepi works as expected when reading from REDCap", {
  data <- readepi(
<<<<<<< HEAD
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    project_id = "SD_DATA",
    records = c("1", "3", "5"),
    fields = c("record_id", "name_first", "age", "bmi"),
    id_col_name = "record_id"
  )
  expect_type(data, "list")
  expect_length(data, 2)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data$data, class = "data.frame")
  expect_s3_class(data$metadata, class = "data.frame")

  data <- readepi(
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    project_id = "SD_DATA",
    records = c("1", "3", "5"),
    fields = c("record_id", "name_first", "age", "bmi"),
    id_position = 1
  )
  expect_type(data, "list")
  expect_length(data, 2)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data$data, class = "data.frame")
  expect_s3_class(data$metadata, class = "data.frame")

  data <- readepi(
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    project_id = "SD_DATA",
    records = "1, 3, 5",
    fields = "record_id, name_first, age, bmi",
    id_position = 1
  )
  expect_type(data, "list")
  expect_length(data, 2)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data$data, class = "data.frame")
  expect_s3_class(data$metadata, class = "data.frame")

  data <- readepi(
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    project_id = "SD_DATA",
    records = "1, 3, 5",
    fields = "record_id, name_first, age, bmi",
    id_col_name = "record_id"
  )
  expect_type(data, "list")
  expect_length(data, 2)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data$data, class = "data.frame")
  expect_s3_class(data$metadata, class = "data.frame")

  data <- readepi(
    credentials_file = system.file("extdata", "test.ini", package = "readepi"),
    project_id = "SD_DATA",
    records = NULL,
    fields = NULL
  )
  expect_type(data, "list")
  expect_length(data, 2)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data$data, class = "data.frame")
  expect_s3_class(data$metadata, class = "data.frame")
=======
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
>>>>>>> review
})

test_that("readepi fails as expected when reading from REDCap", {
  expect_error(
<<<<<<< HEAD
    data <- readepi(
      credentials_file = c(
        system.file("extdata", "test.ini", package = "readepi"),
        system.file("extdata", "fake_test.ini", package = "readepi")
      ),
      project_id = "SD_DATA",
=======
    readepi(
      credentials_file = c(
        system.file("extdata", "test.ini",
          package = "readepi"
        ),
        system.file("extdata", "fake_test.ini",
          package = "readepi"
        )
      ),
      data_source = "https://bbmc.ouhsc.edu/redcap/api/",
>>>>>>> review
      records = "1, 3, 5",
      fields = "record_id, name_first, age, bmi",
      id_col_name = "id"
    ),
    regexp = cat("Assertion on',credentials_file,'failed: Must be of type
                 character of length 1.")
  )

  expect_error(
<<<<<<< HEAD
    data <- readepi(
      credentials_file = NULL,
      project_id = "SD_DATA",
      records = "1, 3, 5",
      fields = "record_id, name_first, age, bmi",
      id_col_name = "id"
=======
    readepi(
      credentials_file = NULL,
      data_source      = "https://bbmc.ouhsc.edu/redcap/api/",
      records          = "1, 3, 5",
      fields           = "record_id, name_first, age, bmi",
      id_col_name      = "id"
>>>>>>> review
    ),
    regexp = cat("Assertion on',credentials_file,'failed: Must be specified.")
  )

  expect_error(
<<<<<<< HEAD
    data <- readepi(
      credentials_file = system.file("extdata", "test.ini",
                                     package = "readepi"),
      project_id = "SD_DATA",
=======
    readepi(
      credentials_file = system.file("extdata", "test.ini",
        package = "readepi"
      ),
      data_source = "https://bbmc.ouhsc.edu/redcap/api/",
>>>>>>> review
      records = NA,
      fields = "record_id, name_first, age, bmi",
      id_col_name = "id"
    ),
    regexp = cat("Assertion on',records,'failed: Missing value not allowed.")
  )

  expect_error(
<<<<<<< HEAD
    data <- readepi(
      credentials_file = system.file("extdata", "test.ini",
                                     package = "readepi"),
      project_id = "SD_DATA",
=======
    readepi(
      credentials_file = system.file("extdata", "test.ini",
        package = "readepi"
      ),
      data_source = "https://bbmc.ouhsc.edu/redcap/api/",
>>>>>>> review
      records = "1, 3, 5",
      fields = NA,
      id_col_name = "id"
    ),
    regexp = cat("Assertion on',fields,'failed: Missing value not allowed.")
  )

  expect_error(
<<<<<<< HEAD
    data <- readepi(
      credentials_file = system.file("extdata", "test.ini",
                                     package = "readepi"),
      project_id = "SD_DATA",
=======
    readepi(
      credentials_file = system.file("extdata", "test.ini",
        package = "readepi"
      ),
      data_source = "https://bbmc.ouhsc.edu/redcap/api/",
>>>>>>> review
      records = "1, 3, 5",
      fields = "record_id, name_first, age, bmi",
      id_col_name = NA
    ),
    regexp = cat("Assertion on',id_col_name,'failed: Missing value
                 not allowed.")
  )

  expect_error(
<<<<<<< HEAD
    data <- readepi(
      credentials_file = system.file("extdata", "test.ini",
                                     package = "readepi"),
      project_id = "SD_DATA",
=======
    readepi(
      credentials_file = system.file("extdata", "test.ini",
        package = "readepi"
      ),
      data_source = "https://bbmc.ouhsc.edu/redcap/api/",
>>>>>>> review
      records = "1, 3, 5",
      fields = "record_id, name_first, age, bmi",
      id_col_name = NULL,
      id_position = NA
    ),
    regexp = cat("Assertion on',id_position,'failed: Missing value
                 not allowed.")
  )
})

<<<<<<< HEAD
test_that("readepi fails as expected when reading from DBMS,
          files and folders", {
  expect_error(
    data <- readepi(
      credentials_file = system.file("extdata", "test.ini",
                                     package = "readepi"),
      project_id = "Rfam",
      file_path = system.file("extdata", "test.json", package = "readepi"),
      sep = NULL,
      format = NULL,
      which = NULL,
      pattern = NULL,
      driver_name = "",
      table_name = "author",
      records = NULL,
      fields = NULL,
      id_position = 1
    ),
    regexp = cat("Assertion on',credentials_file,' and,'file_path',failed:
                 Must specify either the file path or the credential file,
                 not both at the same time.")
  )

  expect_error(
    data <- readepi(
      credentials_file = system.file("extdata", "test.ini",
                                     package = "readepi"),
      project_id = "Rfam",
      file_path = NULL,
      sep = NULL,
      format = NULL,
      which = NULL,
      pattern = NULL,
=======
test_that("readepi fails as expected when reading from DBMS", {
  expect_error(
    readepi(
      credentials_file = system.file("extdata", "test.ini",
                                     package = "readepi"),
      data_source = "mysql-rfam-public.ebi.ac.uk",
>>>>>>> review
      driver_name = NULL,
      table_name = "author",
      records = NULL,
      fields = NULL,
<<<<<<< HEAD
      id_position = 1
=======
      id_position = 1L
>>>>>>> review
    ),
    regexp = cat("Assertion on',driver_name,failed: MS driver name
                 must be provided.")
  )

  expect_error(
<<<<<<< HEAD
    data <- readepi(
      credentials_file = NULL,
      project_id = "Rfam",
      file_path = NULL,
      sep = NULL,
      format = NULL,
      which = NULL,
      pattern = NULL,
      driver_name = NULL,
      table_name = "author",
      records = NULL,
      fields = NULL,
      id_position = 1
    ),
    regexp = cat("Assertion on',credentials_file,and,'file_path',failed:
                 Must provide either a file path, or a directory or a credential
                 file.")
  )

  expect_error(
    data <- readepi(
      credentials_file = NULL,
      project_id = NULL,
      file_path = system.file("extdata", "test.txt", package = "readepi"),
      sep = c(",", "\t"),
      format = NULL,
      which = NULL,
      pattern = NULL,
      driver_name = NULL,
      table_name = NULL,
      records = NULL,
      fields = NULL,
      id_position = 1
    ),
    regexp = cat("Assertion on',sep,'failed: Must be a character of length 1.")
=======
    readepi(
      credentials_file = NULL,
      data_source      = "mysql-rfam-public.ebi.ac.uk",
      driver_name      = NULL,
      table_name       = "author",
      records          = NULL,
      fields           = NULL,
      id_position      = 1L
    ),
    regexp = cat("Assertion on',credentials_file,and,'file_path',
    failed: Must provide either a file path, or a directory or a
    credential file.")
>>>>>>> review
  )
})


test_that("readepi fails as expected when reading from Fingertips", {
  expect_error(
<<<<<<< HEAD
    data <- readepi(
      indicator_id = NA,
      area_type_id = 202,
      indicator_name = "Healthy life expectancy at birth",
      domain_id = 1000049,
      domain_name = "A. Overarching indicators",
      profile_id = 19,
=======
    readepi(
      indicator_id = NA,
      area_type_id = 202L,
      indicator_name = "Healthy life expectancy at birth",
      domain_id = 1000049L,
      domain_name = "A. Overarching indicators",
      profile_id = 19L,
>>>>>>> review
      profile_name = "Public Health Outcomes Framework",
      fields = c("IndicatorID", "AreaCode", "Age", "Value"),
      records = c("E12000002", "E12000001", "E12000009"),
      id_col_name = "AreaCode"
    ),
    regexp = cat("Assertion on',indicator_id,'failed: Missing value
                 not allowed.")
  )

  expect_error(
<<<<<<< HEAD
    data <- readepi(
      indicator_id = 90362,
      area_type_id = 202,
      indicator_name = NA,
      domain_id = 1000049,
      domain_name = "A. Overarching indicators",
      profile_id = 19,
=======
    readepi(
      indicator_id = 90362L,
      area_type_id = 202L,
      indicator_name = NA,
      domain_id = 1000049L,
      domain_name = "A. Overarching indicators",
      profile_id = 19L,
>>>>>>> review
      profile_name = "Public Health Outcomes Framework",
      fields = c("IndicatorID", "AreaCode", "Age", "Value"),
      records = c("E12000002", "E12000001", "E12000009"),
      id_col_name = "AreaCode"
    ),
    regexp = cat("Assertion on',indicator_name,'failed: Missing value
                 not allowed.")
  )

  expect_error(
<<<<<<< HEAD
    data <- readepi(
      indicator_id = 90362,
      area_type_id = NA,
      indicator_name = "Healthy life expectancy at birth",
      domain_id = 1000049,
      domain_name = "A. Overarching indicators",
      profile_id = 19,
=======
    readepi(
      indicator_id = 90362L,
      area_type_id = NA,
      indicator_name = "Healthy life expectancy at birth",
      domain_id = 1000049L,
      domain_name = "A. Overarching indicators",
      profile_id = 19L,
>>>>>>> review
      profile_name = "Public Health Outcomes Framework",
      fields = c("IndicatorID", "AreaCode", "Age", "Value"),
      records = c("E12000002", "E12000001", "E12000009"),
      id_col_name = "AreaCode"
    ),
    regexp = cat("Assertion on',area_type_id,'failed: Missing value
                 not allowed.")
  )

  expect_error(
<<<<<<< HEAD
    data <- readepi(
      indicator_id = 90362,
      area_type_id = 202,
      indicator_name = "Healthy life expectancy at birth",
      domain_id = NA,
      domain_name = "A. Overarching indicators",
      profile_id = 19,
=======
    readepi(
      indicator_id = 90362L,
      area_type_id = 202L,
      indicator_name = "Healthy life expectancy at birth",
      domain_id = NA,
      domain_name = "A. Overarching indicators",
      profile_id = 19L,
>>>>>>> review
      profile_name = "Public Health Outcomes Framework",
      fields = c("IndicatorID", "AreaCode", "Age", "Value"),
      records = c("E12000002", "E12000001", "E12000009"),
      id_col_name = "AreaCode"
    ),
    regexp = cat("Assertion on',domain_id,'failed: Missing value not allowed.")
  )

  expect_error(
<<<<<<< HEAD
    data <- readepi(
      indicator_id = 90362,
      area_type_id = 202,
      indicator_name = "Healthy life expectancy at birth",
      domain_id = 1000049,
      domain_name = NA,
      profile_id = 19,
=======
    readepi(
      indicator_id = 90362L,
      area_type_id = 202L,
      indicator_name = "Healthy life expectancy at birth",
      domain_id = 1000049L,
      domain_name = NA,
      profile_id = 19L,
>>>>>>> review
      profile_name = "Public Health Outcomes Framework",
      fields = c("IndicatorID", "AreaCode", "Age", "Value"),
      records = c("E12000002", "E12000001"),
      id_col_name = "AreaCode"
    ),
    regexp = cat("Assertion on',domain_name,'failed: Missing value
                 not allowed.")
  )

  expect_error(
<<<<<<< HEAD
    data <- readepi(
      indicator_id = 90362,
      area_type_id = 202,
      indicator_name = "Healthy life expectancy at birth",
      domain_id = 1000049,
=======
    readepi(
      indicator_id = 90362L,
      area_type_id = 202L,
      indicator_name = "Healthy life expectancy at birth",
      domain_id = 1000049L,
>>>>>>> review
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
<<<<<<< HEAD
    data <- readepi(
      indicator_id = 90362,
      area_type_id = 202,
      indicator_name = "Healthy life expectancy at birth",
      domain_id = 1000049,
      domain_name = "A. Overarching indicators",
      profile_id = 19,
=======
    readepi(
      indicator_id = 90362L,
      area_type_id = 202L,
      indicator_name = "Healthy life expectancy at birth",
      domain_id = 1000049L,
      domain_name = "A. Overarching indicators",
      profile_id = 19L,
>>>>>>> review
      profile_name = NA,
      fields = c("IndicatorID", "AreaCode", "Age", "Value"),
      records = c("E12000002", "E12000001", "E12000009"),
      id_col_name = "AreaCode"
    ),
    regexp = cat("Assertion on',profile_name,'failed: Missing value
                 not allowed.")
  )
})
