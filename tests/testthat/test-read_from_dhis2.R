test_that("read_from_dhis2 works as expected", {
  data <- read_from_dhis2(
    base_url           = file.path("https:/", "play.dhis2.org", "dev"),
    user_name          = "admin",
    password           = "district",
    dataset            = "pBOMPrpg1QX",
    organisation_unit  = "DiszpKrYNg8",
    data_element_group = "oDkJh5Ddh7d",
    start_date         = "2014",
    end_date           = "2023",
    records            = NULL,
    fields             = NULL,
    id_col_name        = "dataElement"
  )
  expect_type(data, "list")
  expect_length(data, 1L)
  expect_named(data, "data")
  expect_s3_class(data[["data"]], class = "data.frame")
})

test_that("read_from_dhis2 works as expected when subsetting on columns and
          records is allowed", {
            data <- read_from_dhis2(
              base_url = file.path("https:/", "play.dhis2.org", "dev"),
              user_name = "admin",
              password = "district",
              dataset = "pBOMPrpg1QX",
              organisation_unit = "DiszpKrYNg8",
              data_element_group = "oDkJh5Ddh7d",
              start_date = "2014",
              end_date = "2023",
              records = c("FTRrcoaog83", "eY5ehpbEsB7", "Ix2HsbDMLea"),
              fields = c("dataElement", "period", "value"),
              id_col_name = "dataElement"
            )
            expect_type(data, "list")
            expect_length(data, 1L)
            expect_named(data, "data")
            expect_s3_class(data[["data"]], class = "data.frame")
          })

test_that("read_from_dhis2 fails with a wrong URL", {
  expect_error(
    read_from_dhis2(
      base_url = NULL,
      user_name = "admin",
      password = "district",
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = "oDkJh5Ddh7d",
      start_date = "2014",
      end_date = "2023",
      records = c("FTRrcoaog83", "eY5ehpbEsB7", "Ix2HsbDMLea"),
      fields = c("dataElement", "period", "value"),
      id_col_name = "dataElement"
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be provided.")
  )

  expect_error(
    read_from_dhis2(
      base_url = NA,
      user_name = "admin",
      password = "district",
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = "oDkJh5Ddh7d",
      start_date = "2014",
      end_date = "2023",
      records = c("FTRrcoaog83", "eY5ehpbEsB7", "Ix2HsbDMLea"),
      fields = c("dataElement", "period", "value"),
      id_col_name = "dataElement"
    ),
    regexp = cat("Assertion on',base_url,'failed: Missing value not allowed for
                 base_url argument.")
  )

  expect_error(
    read_from_dhis2(
      base_url = c(file.path("https:/", "play.dhis2.org", "dev"),
                   file.path("https:/", "play.dhis2.org", "dev")),
      user_name = "admin",
      password = "district",
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = "oDkJh5Ddh7d",
      start_date = "2014",
      end_date = "2023",
      records = c("FTRrcoaog83", "eY5ehpbEsB7", "Ix2HsbDMLea"),
      fields = c("dataElement", "period", "value"),
      id_col_name = "dataElement"
    ),
    regexp = cat("Assertion on',base_url,'failed: should provide only one URL at
                 a time.")
  )
})

test_that("read_from_dhis2 fails with a wrong user_name", {
  expect_error(
    read_from_dhis2(
      base_url = file.path("https:/", "play.dhis2.org", "dev"),
      user_name = NULL,
      password = "district",
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = "oDkJh5Ddh7d",
      start_date = "2014",
      end_date = "2023",
      records = c("FTRrcoaog83", "eY5ehpbEsB7", "Ix2HsbDMLea"),
      fields = c("dataElement", "period", "value"),
      id_col_name = "dataElement"
    ),
    regexp = cat("Assertion on',user_name,'failed: Must be provided.")
  )
})
