httptest::with_mock_api({
  test_that("login works as expected", {
    expect_message(
      login(username = "admin", password = "district",
            base_url = file.path("https:/", "play.dhis2.org", "dev")),
      "Logged in successfully!")
  })
})

test_that("dhis2_subset_fields works as expected", {
  results <- dhis2_subset_fields(
    data = readepi(
      credentials_file = system.file("extdata", "test.ini",
                                     package = "readepi"),
      project_id = "DHIS2_DEMO",
      dataset = "pBOMPrpg1QX,BfMAe6Itzgt",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL,
      start_date = "2014",
      end_date = "2023"
    )$data,
    fields = c("dataElement", "period", "value")
  )
  expect_s3_class(results, "data.frame")
})

test_that("dhis2_subset_records works as expected", {
  result <- dhis2_subset_records(
    data = readepi(
      credentials_file = system.file("extdata", "test.ini",
                                     package = "readepi"
      ),
      project_id = "DHIS2_DEMO",
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL,
      start_date = "2014",
      end_date = "2023"
    )$data,
    records = c("FTRrcoaog83", "eY5ehpbEsB7", "Ix2HsbDMLea"),
    id_col_name = "dataElement"
  )
  expect_s3_class(result, "data.frame")
})
