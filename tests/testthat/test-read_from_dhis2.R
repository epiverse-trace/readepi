test_that("read_from_dhis2 works as expected", {
  data <- read_from_dhis2(
    base_url = "https://play.dhis2.org/dev/",
    user_name = "admin",
    password = "district",
    dataset = "pBOMPrpg1QX",
    organisation_unit = "DiszpKrYNg8",
    data_element_group = NULL,
    start_date = "2014",
    end_date = "2023",
    records = NULL,
    fields = NULL,
    id_col_name = "dataElement"
  )
  expect_type(data, "list")

  data <- read_from_dhis2(
    base_url = "https://play.dhis2.org/dev/",
    user_name = "admin",
    password = "district",
    dataset = "pBOMPrpg1QX,eZDhcZi6FLP",
    organisation_unit = "DiszpKrYNg8",
    data_element_group = NULL,
    start_date = "2014",
    end_date = "2023",
    records = NULL,
    fields = NULL,
    id_col_name = "dataElement"
  )
  expect_type(data, "list")

  data <- read_from_dhis2(
    base_url = "https://play.dhis2.org/dev/",
    user_name = "admin",
    password = "district",
    dataset = c("pBOMPrpg1QX", "eZDhcZi6FLP"),
    organisation_unit = "DiszpKrYNg8",
    data_element_group = NULL,
    start_date = "2014",
    end_date = "2023",
    records = NULL,
    fields = NULL,
    id_col_name = "dataElement"
  )
  expect_type(data, "list")

  data <- read_from_dhis2(
    base_url = "https://play.dhis2.org/dev/",
    user_name = "admin",
    password = "district",
    dataset = "pBOMPrpg1QX",
    organisation_unit = "DiszpKrYNg8,LOpWauwwghf",
    data_element_group = NULL,
    start_date = "2014",
    end_date = "2023",
    records = NULL,
    fields = NULL,
    id_col_name = "dataElement"
  )
  expect_type(data, "list")

  data <- read_from_dhis2(
    base_url = "https://play.dhis2.org/dev/",
    user_name = "admin",
    password = "district",
    dataset = "pBOMPrpg1QX",
    organisation_unit = c("DiszpKrYNg8", "LOpWauwwghf"),
    data_element_group = NULL,
    start_date = "2014",
    end_date = "2023",
    records = NULL,
    fields = NULL,
    id_col_name = "dataElement"
  )
  expect_type(data, "list")
})

test_that("read_from_dhis2 fails as expected", {
  expect_error(
    data <- read_from_dhis2(
      base_url = NULL,
      user_name = "admin",
      password = "district",
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL,
      start_date = "2014",
      end_date = "2023",
      records = NULL,
      fields = NULL,
      id_col_name = "dataElement"
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be provided.")
  )

  expect_error(
    data <- read_from_dhis2(
      base_url = "https://play.dhis2.org/dev/",
      user_name = NULL,
      password = "district",
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL,
      start_date = "2014",
      end_date = "2023",
      records = NULL,
      fields = NULL,
      id_col_name = "dataElement"
    ),
    regexp = cat("Assertion on',user_name,'failed: Must be provided.")
  )

  expect_error(
    data <- read_from_dhis2(
      base_url = "https://play.dhis2.org/dev/",
      user_name = "admin",
      password = NULL,
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL,
      start_date = "2014",
      end_date = "2023",
      records = NULL,
      fields = NULL,
      id_col_name = "dataElement"
    ),
    regexp = cat("Assertion on',password,'failed: Must be provided.")
  )

  expect_error(
    data <- read_from_dhis2(
      base_url = "https://play.dhis2.org/dev/",
      user_name = "admin",
      password = "district",
      dataset = NULL,
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL,
      start_date = "2014",
      end_date = "2023",
      records = NULL,
      fields = NULL,
      id_col_name = "dataElement"
    ),
    regexp = cat("Assertion on',dataset,'failed: Must be provided.")
  )

  expect_error(
    data <- read_from_dhis2(
      base_url = "https://play.dhis2.org/dev/",
      user_name = "admin",
      password = "district",
      dataset = "pBOMPrpg1QX",
      organisation_unit = NULL,
      data_element_group = NULL,
      start_date = "2014",
      end_date = "2023",
      records = NULL,
      fields = NULL,
      id_col_name = "dataElement"
    ),
    regexp = cat("Assertion on',organisation_unit,'failed: Must be provided.")
  )

  expect_error(
    data <- read_from_dhis2(
      base_url = "https://play.dhis2.org/dev/",
      user_name = "admin",
      password = "district",
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL,
      start_date = NULL,
      end_date = "2023",
      records = NULL,
      fields = NULL,
      id_col_name = "dataElement"
    ),
    regexp = cat("Assertion on',start_date,'failed: Must be provided.")
  )

  expect_error(
    data <- read_from_dhis2(
      base_url = "https://play.dhis2.org/dev/",
      user_name = "admin",
      password = "district",
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL,
      start_date = "2014",
      end_date = NULL,
      records = NULL,
      fields = NULL,
      id_col_name = "dataElement"
    ),
    regexp = cat("Assertion on',end_date,'failed: Must be provided.")
  )
})
