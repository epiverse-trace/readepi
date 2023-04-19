test_that("readepi works as expected when reading from DBMS", {
  data <- readepi(
    credentials.file = system.file("extdata", "test.ini", package = "readepi"),
    project.id = "Rfam",
    file.path = NULL,
    sep = NULL,
    format = NULL,
    which = NULL,
    pattern = NULL,
    driver.name = "",
    table.name = "author",
    records = NULL,
    fields = NULL,
    id.position = 1
  )
  expect_type(data, "list")
})

test_that("readepi works as expected when reading from Fingertips", {
  data <- readepi(
    indicator_id = 90362,
    area_type_id = 202,
    indicator_name = "Healthy life expectancy at birth",
    domain_id = 1000049,
    domain_name = "A. Overarching indicators",
    profile_id = 19,
    profile_name = "Public Health Outcomes Framework",
    fields=c("IndicatorID","AreaCode","Age","Value"),
    records=c("E12000002","E12000001","E12000009"),
    id.col.name="AreaCode"
  )
  expect_type(data, "list")

  data <- readepi(
    indicator_id = 90362,
    area_type_id = 202,
    records = NULL,
    fields = NULL,
    id.position = NULL,
    id.col.name = NULL
  )
  expect_type(data, "list")

  data <- readepi(
    indicator_id = 90362,
    area_type_id = 202,
    indicator_name = "Healthy life expectancy at birth",
    records = NULL,
    fields = NULL,
    id.position = NULL,
    id.col.name = NULL
  )
  expect_type(data, "list")

  data <- readepi(
    area_type_id = 202,
    indicator_name = "Healthy life expectancy at birth",
    records = NULL,
    fields = NULL,
    id.position = NULL,
    id.col.name = NULL
  )
  expect_type(data, "list")

  data <- readepi(
    area_type_id = 202,
    domain_name = "A. Overarching indicators",
    records = NULL,
    fields = NULL,
    id.position = NULL,
    id.col.name = NULL
  )
  expect_type(data, "list")

  data <- readepi(
    area_type_id = 202,
    domain_id = 1000049,
    records = NULL,
    fields = NULL,
    id.position = NULL,
    id.col.name = NULL
  )
  expect_type(data, "list")

  data <- readepi(
    area_type_id = 202,
    profile_id = 19,
    records = NULL,
    fields = NULL,
    id.position = NULL,
    id.col.name = NULL
  )
  expect_type(data, "list")

  data <- readepi(
    area_type_id = 202,
    profile_name = "Public Health Outcomes Framework",
    records = NULL,
    fields = NULL,
    id.position = NULL,
    id.col.name = NULL
  )
  expect_type(data, "list")
})


test_that("readepi works as expected when reading from file", {
  data <- readepi(
    credentials.file = NULL,
    project.id = NULL,
    file.path = system.file("extdata", "test.json", package = "readepi"),
    sep = NULL,
    format = NULL,
    which = NULL,
    pattern = NULL,
    driver.name = NULL,
    table.name = NULL,
    records = NULL,
    fields = NULL,
    id.position = 1
  )
  expect_type(data, "list")
})

test_that("readepi works as expected when reading from DBMS", {
  data <- readepi(
    credentials.file = system.file("extdata", "test.ini", package = "readepi"),
    project.id = "Rfam",
    file.path = NULL,
    sep = NULL,
    format = NULL,
    which = NULL,
    pattern = NULL,
    driver.name = "",
    table.name = "author",
    records = NULL,
    fields = NULL,
    id.position = 1
  )
  expect_type(data, "list")
})

test_that("readepi works as expected when reading from a directory", {
  data <- readepi(
    credentials.file = NULL,
    project.id = NULL,
    file.path = system.file("extdata", package = "readepi"),
    sep = NULL,
    format = NULL,
    which = NULL,
    pattern = "txt",
    driver.name = NULL,
    table.name = NULL,
    records = NULL,
    fields = NULL,
    id.position = 1
  )
  expect_type(data, "list")
})

test_that("readepi works as expected when reading from DHIS2", {
  data <- readepi(
    credentials.file = system.file("extdata", "test.ini", package = "readepi"),
    project.id = "DHIS2_DEMO",
    dataset = "pBOMPrpg1QX",
    organisation.unit = "DiszpKrYNg8",
    data.element.group = NULL,
    start.date = "2014",
    end.date = "2023"
  )
  expect_type(data, "list")
})

test_that("readepi fails as expected when reading from DHIS2", {
  expect_error(
    data <- readepi(
      credentials.file = NULL,
      project.id = "DHIS2_DEMO",
      dataset = "pBOMPrpg1QX",
      organisation.unit = "DiszpKrYNg8",
      data.element.group = NULL,
      start.date = "2014",
      end.date = "2023"
    ),
    regexp = cat("Assertion on',credentials.file,'failed: Must be specified.")
  )

  expect_error(
    data <- readepi(
      credentials.file = c(system.file("extdata", "test.ini", package = "readepi"),
                           system.file("extdata", "fake_test.ini", package = "readepi")),
      project.id = "DHIS2_DEMO",
      dataset = "pBOMPrpg1QX",
      organisation.unit = "DiszpKrYNg8",
      data.element.group = NULL,
      start.date = "2014",
      end.date = "2023"
    ),
    regexp = cat("Assertion on',credentials.file,'failed: Must be of type character with length 1.")
  )

  expect_error(
    data <- readepi(
      credentials.file = system.file("extdata", "test.ini", package = "readepi"),
      project.id = c("DHIS2_DEMO","test"),
      dataset = "pBOMPrpg1QX",
      organisation.unit = "DiszpKrYNg8",
      data.element.group = NULL,
      start.date = "2014",
      end.date = "2023"
    ),
    regexp = cat("Assertion on',project.id,'failed: Must be of type character with length 1.")
  )

  expect_error(
    data <- readepi(
      credentials.file = system.file("extdata", "test.ini", package = "readepi"),
      project.id = "DHIS2_DEMO",
      dataset = NA,
      organisation.unit = "DiszpKrYNg8",
      data.element.group = NULL,
      start.date = "2014",
      end.date = "2023"
    ),
    regexp = cat("Assertion on',dataset,'failed: Missing value not allowed.")
  )

  expect_error(
    data <- readepi(
      credentials.file = system.file("extdata", "test.ini", package = "readepi"),
      project.id = "DHIS2_DEMO",
      dataset = NULL,
      organisation.unit = "DiszpKrYNg8",
      data.element.group = NULL,
      start.date = "2014",
      end.date = "2023"
    ),
    regexp = cat("Assertion on',dataset,'failed: Must be specified.")
  )

  expect_error(
    data <- readepi(
      credentials.file = system.file("extdata", "test.ini", package = "readepi"),
      project.id = "DHIS2_DEMO",
      dataset = "pBOMPrpg1QX",
      organisation.unit = NA,
      data.element.group = NULL,
      start.date = "2014",
      end.date = "2023"
    ),
    regexp = cat("Assertion on',organisation.unit,'failed: Missing value not allowed.")
  )

  expect_error(
    data <- readepi(
      credentials.file = system.file("extdata", "test.ini", package = "readepi"),
      project.id = "DHIS2_DEMO",
      dataset = "pBOMPrpg1QX",
      organisation.unit = NULL,
      data.element.group = NULL,
      start.date = "2014",
      end.date = "2023"
    ),
    regexp = cat("Assertion on',organisation.unit,'failed: Must be specified.")
  )

  expect_error(
    data <- readepi(
      credentials.file = system.file("extdata", "test.ini", package = "readepi"),
      project.id = "DHIS2_DEMO",
      dataset = "pBOMPrpg1QX",
      organisation.unit = "DiszpKrYNg8",
      data.element.group = NA,
      start.date = "2014",
      end.date = "2023"
    ),
    regexp = cat("Assertion on',data.element.group,'failed: Missing value not allowed.")
  )

  expect_error(
    data <- readepi(
      credentials.file = system.file("extdata", "test.ini", package = "readepi"),
      project.id = "DHIS2_DEMO",
      dataset = "pBOMPrpg1QX",
      organisation.unit = "DiszpKrYNg8",
      data.element.group = NULL,
      start.date = NA,
      end.date = "2023"
    ),
    regexp = cat("Assertion on',start.date,'failed: Missing value not allowed.")
  )

  expect_error(
    data <- readepi(
      credentials.file = system.file("extdata", "test.ini", package = "readepi"),
      project.id = "DHIS2_DEMO",
      dataset = "pBOMPrpg1QX",
      organisation.unit = "DiszpKrYNg8",
      data.element.group = NULL,
      start.date = "2014",
      end.date = NA
    ),
    regexp = cat("Assertion on',end.date,'failed: Missing value not allowed.")
  )
})

test_that("readepi works as expected when reading from REDCap", {
  data <- readepi(credentials.file = system.file("extdata", "test.ini", package = "readepi"),
                  project.id = "TEST_REDCap",
                  records = c("SK_1", "SK_2", "SK_3", "SK_97", "SK_98", "SK_99"),
                  fields = c("id", "age", "sex"),
                  id.col.name = "id"
  )
  expect_type(data, "list")
  expect_length(data, 2)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data$data, class = "data.frame")
  expect_s3_class(data$metadata, class = "data.frame")

  data <- readepi(credentials.file = system.file("extdata", "test.ini", package = "readepi"),
                  project.id = "TEST_REDCap",
                  records = c("SK_1", "SK_2", "SK_3", "SK_97", "SK_98", "SK_99"),
                  fields = c("id", "age", "sex"),
                  id.position =  1
  )
  expect_type(data, "list")
  expect_length(data, 2)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data$data, class = "data.frame")
  expect_s3_class(data$metadata, class = "data.frame")

  data <- readepi(credentials.file = system.file("extdata", "test.ini", package = "readepi"),
                  project.id = "TEST_REDCap",
                  records = "SK_1, SK_2, SK_3, SK_97, SK_98, SK_99",
                  fields = "id, age, sex",
                  id.position = 1
  )
  expect_type(data, "list")
  expect_length(data, 2)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data$data, class = "data.frame")
  expect_s3_class(data$metadata, class = "data.frame")

  data <- readepi(credentials.file = system.file("extdata", "test.ini", package = "readepi"),
                  project.id = "TEST_REDCap",
                  records = "SK_1, SK_2, SK_3, SK_97, SK_98, SK_99",
                  fields = "id, age, sex",
                  id.col.name = "id"
  )
  expect_type(data, "list")
  expect_length(data, 2)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data$data, class = "data.frame")
  expect_s3_class(data$metadata, class = "data.frame")

  data <- readepi(credentials.file = system.file("extdata", "test.ini", package = "readepi"),
                  project.id = "TEST_REDCap",
                  records = NULL,
                  fields = NULL
  )
  expect_type(data, "list")
  expect_length(data, 2)
  expect_named(data, c("data", "metadata"))
  expect_s3_class(data$data, class = "data.frame")
  expect_s3_class(data$metadata, class = "data.frame")
})

test_that("readepi fails as expected when reading from REDCap", {
  expect_error(
    data <- readepi(credentials.file = c(system.file("extdata", "test.ini", package = "readepi"),
                                         system.file("extdata", "fake_test.ini", package = "readepi")),
                    project.id = "TEST_REDCap",
                    records = "SK_1, SK_2, SK_3, SK_97, SK_98, SK_99",
                    fields = "id, age, sex",
                    id.col.name = "id"
    ),
    regexp = cat("Assertion on',credentials.file,'failed: Must be of type character of length 1.")
  )

  expect_error(
    data <- readepi(credentials.file = NULL,
                    project.id = "TEST_REDCap",
                    records = "SK_1, SK_2, SK_3, SK_97, SK_98, SK_99",
                    fields = "id, age, sex",
                    id.col.name = "id"
    ),
    regexp = cat("Assertion on',credentials.file,'failed: Must be specified.")
  )

  expect_error(
    data <- readepi(credentials.file = system.file("extdata", "test.ini", package = "readepi"),
                    project.id = NULL,
                    records = "SK_1, SK_2, SK_3, SK_97, SK_98, SK_99",
                    fields = "id, age, sex",
                    id.col.name = "id"
    ),
    regexp = cat("Assertion on',project.id,'failed: Must be specified.")
  )

  expect_error(
    data <- readepi(credentials.file = system.file("extdata", "test.ini", package = "readepi"),
                    project.id = NA,
                    records = "SK_1, SK_2, SK_3, SK_97, SK_98, SK_99",
                    fields = "id, age, sex",
                    id.col.name = "id"
    ),
    regexp = cat("Assertion on',project.id,'failed: Missing value not allowed.")
  )

  expect_error(
    data <- readepi(credentials.file = system.file("extdata", "test.ini", package = "readepi"),
                    project.id = "TEST_REDCap",
                    records = NA,
                    fields = "id, age, sex",
                    id.col.name = "id"
    ),
    regexp = cat("Assertion on',records,'failed: Missing value not allowed.")
  )

  expect_error(
    data <- readepi(credentials.file = system.file("extdata", "test.ini", package = "readepi"),
                    project.id = "TEST_REDCap",
                    records = "SK_1, SK_2, SK_3, SK_97, SK_98, SK_99",
                    fields = NA,
                    id.col.name = "id"
    ),
    regexp = cat("Assertion on',fields,'failed: Missing value not allowed.")
  )

  expect_error(
    data <- readepi(credentials.file = system.file("extdata", "test.ini", package = "readepi"),
                    project.id = "TEST_REDCap",
                    records = "SK_1, SK_2, SK_3, SK_97, SK_98, SK_99",
                    fields = "id, age, sex",
                    id.col.name = NA
    ),
    regexp = cat("Assertion on',id.col.name,'failed: Missing value not allowed.")
  )

  expect_error(
    data <- readepi(credentials.file = system.file("extdata", "test.ini", package = "readepi"),
                    project.id = "TEST_REDCap",
                    records = "SK_1, SK_2, SK_3, SK_97, SK_98, SK_99",
                    fields = "id, age, sex",
                    id.col.name = NULL,
                    id.position = NA
    ),
    regexp = cat("Assertion on',id.position,'failed: Missing value not allowed.")
  )
})

test_that("readepi fails as expected when reading from DBMS, files and folders", {
  expect_error(
    data <- readepi(
      credentials.file = system.file("extdata", "test.ini", package = "readepi"),
      project.id = "TEST_READEPI",
      file.path = system.file("extdata", "test.json", package = "readepi"),
      sep = NULL,
      format = NULL,
      which = NULL,
      pattern = NULL,
      driver.name = "ODBC Driver 17 for SQL Server",
      table.name = "covid",
      records = NULL,
      fields = NULL,
      id.position = 1
    ),
    regexp = cat("Assertion on',credentials.file,' and,'file.path',failed: Must specify either the file path or the credential file, not both at the same time.")
  )

  expect_error(
    data <- readepi(
      credentials.file = system.file("extdata", "test.ini", package = "readepi"),
      project.id = c("TEST_READEPI", "TEST_READEPI"),
      file.path = NULL,
      sep = NULL,
      format = NULL,
      which = NULL,
      pattern = NULL,
      driver.name = "ODBC Driver 17 for SQL Server",
      table.name = "covid",
      records = NULL,
      fields = NULL,
      id.position = 1
    ),
    regexp = cat("Assertion on',project.id,failed: Must be of type type character of length 1.")
  )

  expect_error(
    data <- readepi(
      credentials.file = system.file("extdata", "test.ini", package = "readepi"),
      project.id = "TEST_READEPI",
      file.path = NULL,
      sep = NULL,
      format = NULL,
      which = NULL,
      pattern = NULL,
      driver.name = NULL,
      table.name = "covid",
      records = NULL,
      fields = NULL,
      id.position = 1
    ),
    regexp = cat("Assertion on',driver.name,failed: MS driver name must be provided.")
  )

  expect_error(
    data <- readepi(
      credentials.file = NULL,
      project.id = "TEST_READEPI",
      file.path = NULL,
      sep = NULL,
      format = NULL,
      which = NULL,
      pattern = NULL,
      driver.name = NULL,
      table.name = "covid",
      records = NULL,
      fields = NULL,
      id.position = 1
    ),
    regexp = cat("Assertion on',credentials.file,and,'file.path',failed: Must provide either a file path, or a directory or a credential file.")
  )

  expect_error(
    data <- readepi(
      credentials.file = NULL,
      project.id = NULL,
      file.path = system.file("extdata", "test.txt", package = "readepi"),
      sep = c(",", "\t"),
      format = NULL,
      which = NULL,
      pattern = NULL,
      driver.name = NULL,
      table.name = NULL,
      records = NULL,
      fields = NULL,
      id.position = 1
    ),
    regexp = cat("Assertion on',sep,'failed: Must be a character of length 1.")
  )
})


test_that("readepi fails as expected when reading from Fingertips", {
  expect_error(
    data <- readepi(
      indicator_id = NA,
      area_type_id = 202,
      indicator_name = "Healthy life expectancy at birth",
      domain_id = 1000049,
      domain_name = "A. Overarching indicators",
      profile_id = 19,
      profile_name = "Public Health Outcomes Framework",
      fields=c("IndicatorID","AreaCode","Age","Value"),
      records=c("E12000002","E12000001","E12000009"),
      id.col.name="AreaCode"
    ),
    regexp = cat("Assertion on',indicator_id,'failed: Missing value not allowed.")
  )

  expect_error(
    data <- readepi(
      indicator_id = 90362,
      area_type_id = 202,
      indicator_name = NA,
      domain_id = 1000049,
      domain_name = "A. Overarching indicators",
      profile_id = 19,
      profile_name = "Public Health Outcomes Framework",
      fields=c("IndicatorID","AreaCode","Age","Value"),
      records=c("E12000002","E12000001","E12000009"),
      id.col.name="AreaCode"
    ),
    regexp = cat("Assertion on',indicator_name,'failed: Missing value not allowed.")
  )

  expect_error(
    data <- readepi(
      indicator_id = 90362,
      area_type_id = NA,
      indicator_name = "Healthy life expectancy at birth",
      domain_id = 1000049,
      domain_name = "A. Overarching indicators",
      profile_id = 19,
      profile_name = "Public Health Outcomes Framework",
      fields=c("IndicatorID","AreaCode","Age","Value"),
      records=c("E12000002","E12000001","E12000009"),
      id.col.name="AreaCode"
    ),
    regexp = cat("Assertion on',area_type_id,'failed: Missing value not allowed.")
  )

  expect_error(
    data <- readepi(
      indicator_id = 90362,
      area_type_id = 202,
      indicator_name = "Healthy life expectancy at birth",
      domain_id = NA,
      domain_name = "A. Overarching indicators",
      profile_id = 19,
      profile_name = "Public Health Outcomes Framework",
      fields=c("IndicatorID","AreaCode","Age","Value"),
      records=c("E12000002","E12000001","E12000009"),
      id.col.name="AreaCode"
    ),
    regexp = cat("Assertion on',domain_id,'failed: Missing value not allowed.")
  )

  expect_error(
    data <- readepi(
      indicator_id = 90362,
      area_type_id = 202,
      indicator_name = "Healthy life expectancy at birth",
      domain_id = 1000049,
      domain_name = NA,
      profile_id = 19,
      profile_name = "Public Health Outcomes Framework",
      fields=c("IndicatorID","AreaCode","Age","Value"),
      records=c("E12000002","E12000001","E12000009"),
      id.col.name="AreaCode"
    ),
    regexp = cat("Assertion on',domain_name,'failed: Missing value not allowed.")
  )

  expect_error(
    data <- readepi(
      indicator_id = 90362,
      area_type_id = 202,
      indicator_name = "Healthy life expectancy at birth",
      domain_id = 1000049,
      domain_name = "A. Overarching indicators",
      profile_id = NA,
      profile_name = "Public Health Outcomes Framework",
      fields=c("IndicatorID","AreaCode","Age","Value"),
      records=c("E12000002","E12000001","E12000009"),
      id.col.name="AreaCode"
    ),
    regexp = cat("Assertion on',profile_id,'failed: Missing value not allowed.")
  )

  expect_error(
    data <- readepi(
      indicator_id = 90362,
      area_type_id = 202,
      indicator_name = "Healthy life expectancy at birth",
      domain_id = 1000049,
      domain_name = "A. Overarching indicators",
      profile_id = 19,
      profile_name = NA,
      fields=c("IndicatorID","AreaCode","Age","Value"),
      records=c("E12000002","E12000001","E12000009"),
      id.col.name="AreaCode"
    ),
    regexp = cat("Assertion on',profile_name,'failed: Missing value not allowed.")
  )
})
