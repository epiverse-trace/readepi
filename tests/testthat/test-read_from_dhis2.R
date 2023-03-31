test_that("read_from_dhis2 works as expected", {
  data <- read_from_dhis2(
    base.url = "https://play.dhis2.org/dev/",
    user.name = "admin",
    password = "district",
    dataset = "pBOMPrpg1QX",
    organisation.unit = "DiszpKrYNg8",
    data.element.group = NULL,
    start.date = "2014",
    end.date = "2023",
    records = NULL,
    fields = NULL,
    id.col.name = "dataElement"
  )
  expect_type(data, "list")

  data <- read_from_dhis2(
    base.url = "https://play.dhis2.org/dev/",
    user.name = "admin",
    password = "district",
    dataset = "pBOMPrpg1QX,eZDhcZi6FLP",
    organisation.unit = "DiszpKrYNg8",
    data.element.group = NULL,
    start.date = "2014",
    end.date = "2023",
    records = NULL,
    fields = NULL,
    id.col.name = "dataElement"
  )
  expect_type(data, "list")

  data <- read_from_dhis2(
    base.url = "https://play.dhis2.org/dev/",
    user.name = "admin",
    password = "district",
    dataset = c("pBOMPrpg1QX", "eZDhcZi6FLP"),
    organisation.unit = "DiszpKrYNg8",
    data.element.group = NULL,
    start.date = "2014",
    end.date = "2023",
    records = NULL,
    fields = NULL,
    id.col.name = "dataElement"
  )
  expect_type(data, "list")

  data <- read_from_dhis2(
    base.url = "https://play.dhis2.org/dev/",
    user.name = "admin",
    password = "district",
    dataset = "pBOMPrpg1QX",
    organisation.unit = "DiszpKrYNg8,LOpWauwwghf",
    data.element.group = NULL,
    start.date = "2014",
    end.date = "2023",
    records = NULL,
    fields = NULL,
    id.col.name = "dataElement"
  )
  expect_type(data, "list")

  data <- read_from_dhis2(
    base.url = "https://play.dhis2.org/dev/",
    user.name = "admin",
    password = "district",
    dataset = "pBOMPrpg1QX",
    organisation.unit = c("DiszpKrYNg8", "LOpWauwwghf"),
    data.element.group = NULL,
    start.date = "2014",
    end.date = "2023",
    records = NULL,
    fields = NULL,
    id.col.name = "dataElement"
  )
  expect_type(data, "list")
})

test_that("read_from_dhis2 fails as expected", {
  expect_error(
    data <- read_from_dhis2(
      base.url = NULL,
      user.name = "admin",
      password = "district",
      dataset = "pBOMPrpg1QX",
      organisation.unit = "DiszpKrYNg8",
      data.element.group = NULL,
      start.date = "2014",
      end.date = "2023",
      records = NULL,
      fields = NULL,
      id.col.name = "dataElement"
    ),
    regexp = cat("Assertion on',base.url,'failed: Must be provided.")
  )

  expect_error(
    data <- read_from_dhis2(
      base.url = "https://play.dhis2.org/dev/",
      user.name = NULL,
      password = "district",
      dataset = "pBOMPrpg1QX",
      organisation.unit = "DiszpKrYNg8",
      data.element.group = NULL,
      start.date = "2014",
      end.date = "2023",
      records = NULL,
      fields = NULL,
      id.col.name = "dataElement"
    ),
    regexp = cat("Assertion on',user.name,'failed: Must be provided.")
  )

  expect_error(
    data <- read_from_dhis2(
      base.url = "https://play.dhis2.org/dev/",
      user.name = "admin",
      password = NULL,
      dataset = "pBOMPrpg1QX",
      organisation.unit = "DiszpKrYNg8",
      data.element.group = NULL,
      start.date = "2014",
      end.date = "2023",
      records = NULL,
      fields = NULL,
      id.col.name = "dataElement"
    ),
    regexp = cat("Assertion on',password,'failed: Must be provided.")
  )

  expect_error(
    data <- read_from_dhis2(
      base.url = "https://play.dhis2.org/dev/",
      user.name = "admin",
      password = "district",
      dataset = NULL,
      organisation.unit = "DiszpKrYNg8",
      data.element.group = NULL,
      start.date = "2014",
      end.date = "2023",
      records = NULL,
      fields = NULL,
      id.col.name = "dataElement"
    ),
    regexp = cat("Assertion on',dataset,'failed: Must be provided.")
  )

  expect_error(
    data <- read_from_dhis2(
      base.url = "https://play.dhis2.org/dev/",
      user.name = "admin",
      password = "district",
      dataset = "pBOMPrpg1QX",
      organisation.unit = NULL,
      data.element.group = NULL,
      start.date = "2014",
      end.date = "2023",
      records = NULL,
      fields = NULL,
      id.col.name = "dataElement"
    ),
    regexp = cat("Assertion on',organisation.unit,'failed: Must be provided.")
  )

  expect_error(
    data <- read_from_dhis2(
      base.url = "https://play.dhis2.org/dev/",
      user.name = "admin",
      password = "district",
      dataset = "pBOMPrpg1QX",
      organisation.unit = "DiszpKrYNg8",
      data.element.group = NULL,
      start.date = NULL,
      end.date = "2023",
      records = NULL,
      fields = NULL,
      id.col.name = "dataElement"
    ),
    regexp = cat("Assertion on',start.date,'failed: Must be provided.")
  )

  expect_error(
    data <- read_from_dhis2(
      base.url = "https://play.dhis2.org/dev/",
      user.name = "admin",
      password = "district",
      dataset = "pBOMPrpg1QX",
      organisation.unit = "DiszpKrYNg8",
      data.element.group = NULL,
      start.date = "2014",
      end.date = NULL,
      records = NULL,
      fields = NULL,
      id.col.name = "dataElement"
    ),
    regexp = cat("Assertion on',end.date,'failed: Must be provided.")
  )
})
