test_that("subset_fields works as expected", {
  res <- subset_fields(
    data.frame = iris, fields = "Sepal.Length,Sepal.Width",
    table.name = "iris"
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "not_found"))
  expect_s3_class(res$data, class = "data.frame")
  expect_type(res$not_found, "double")
})

test_that("subset_fields works as expected", {
  res <- subset_fields(
    data.frame = iris, fields = c("Sepal.Length", "Sepal.Width"),
    table.name = "iris"
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "not_found"))
  expect_s3_class(res$data, class = "data.frame")
  expect_type(res$not_found, "double")
})

test_that("subset_records works as expected", {
  res <- subset_records(
    data.frame = iris, records = "setosa, virginica",
    id.position = 5, table.name = "iris"
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "not_found"))
  expect_s3_class(res$data, class = "data.frame")
  expect_type(res$not_found, "double")
})

test_that("subset_records works as expected", {
  res <- subset_records(
    data.frame = iris, records = c("setosa", "virginica"),
    id.position = 5, table.name = "iris"
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "not_found"))
  expect_s3_class(res$data, class = "data.frame")
  expect_type(res$not_found, "double")
})

test_that("subset_fields fails as expected", {
  expect_error(
    res <- subset_fields(
      data.frame = NULL, fields = "Sepal.Length,Sepal.Width",
      table.name = "iris"
    ),
    regexp = cat("Assertion on',data.frame,'failed: Must provide the data frame to subset from.")
  )

  expect_error(
    res <- subset_fields(
      data.frame = NULL, fields = c("Sepal.Length", "Sepal.Width"),
      table.name = "iris"
    ),
    regexp = cat("Assertion on',data.frame,'failed: Must provide the data frame to subset from.")
  )


  expect_error(
    res <- subset_fields(
      data.frame = iris, fields = NULL,
      table.name = "iris"
    ),
    regexp = cat("Assertion on',fields,'failed: Must provide a vector or a string with the field to subset.")
  )

  expect_error(
    res <- subset_fields(
      data.frame = iris, fields = "Sepal.Length,Sepal.Width",
      table.name = NULL
    ),
    regexp = cat("Assertion on',table.name,'failed: Must provide the table name.")
  )

  expect_error(
    res <- subset_fields(
      data.frame = iris, fields = c("Sepal.Length", "Sepal.Width"),
      table.name = NULL
    ),
    regexp = cat("Assertion on',table.name,'failed: Must provide the table name.")
  )

  expect_error(
    res <- subset_fields(
      data.frame = iris, fields = "Sepal.Length,Sepal.Width",
      table.name = c("iris", "iris3")
    ),
    regexp = cat("Assertion on',table.name,'failed: Must be of type character of length 1.")
  )

  expect_error(
    res <- subset_fields(
      data.frame = iris, fields = c("Sepal.Length", "Sepal.Width"),
      table.name = c("iris", "iris3")
    ),
    regexp = cat("Assertion on',table.name,'failed: Must be of type character of length 1.")
  )

  expect_error(
    res <- subset_fields(
      data.frame = NULL, fields = NULL,
      table.name = NULL
    ),
    regexp = cat("Assertion on',subset_fields,'failed: Must provide the data frame to subset from, the fields to subset and the table name from which to subset.")
  )

  expect_error(
    res <- subset_fields(
      data.frame = NULL, fields = "Sepal.Length,Sepal.Width",
      table.name = NULL
    ),
    regexp = cat("Assertion on',subset_fields,'failed: Must provide the data frame to subset from, and the table name from which to subset.")
  )

  expect_error(
    res <- subset_fields(
      data.frame = iris, fields = NULL,
      table.name = NULL
    ),
    regexp = cat("Assertion on',subset_fields,'failed: Must provide the fields to subset, and the table name from which to subset.")
  )

  expect_error(
    res <- subset_fields(
      data.frame = NULL, fields = NULL,
      table.name = "iris"
    ),
    regexp = cat("Assertion on',subset_fields,'failed: Must provide the fields to subset, and the data frame from which to subset.")
  )
})

test_that("subset_records fails as expected", {
  expect_error(
    res <- subset_records(
      data.frame = NULL, records = "setosa, virginica",
      id.position = 5, table.name = "iris"
    ),
    regexp = cat("Assertion on',data.frame,'failed: Must provide the data frame to subset from.")
  )

  expect_error(
    res <- subset_records(
      data.frame = NULL, records = c("setosa", "virginica"),
      id.position = 5, table.name = "iris"
    ),
    regexp = cat("Assertion on',data.frame,'failed: Must provide the data frame to subset from.")
  )

  expect_error(
    res <- subset_records(
      data.frame = iris, records = NULL,
      id.position = 5, table.name = "iris"
    ),
    regexp = cat("Assertion on',records,'failed: Must provide a vector or a string with the field to subset.")
  )

  expect_error(
    res <- subset_records(
      data.frame = iris, records = "setosa, virginica",
      id.position = -1, table.name = NULL
    ),
    regexp = cat("Assertion on',id.position,'failed: Negative column number not allowed.")
  )

  expect_error(
    res <- subset_records(
      data.frame = iris, records = c("setosa", "virginica"),
      id.position = -1, table.name = NULL
    ),
    regexp = cat("Assertion on',id.position,'failed: Negative column number not allowed.")
  )

  expect_error(
    res <- subset_records(
      data.frame = iris, records = "setosa, virginica",
      id.position = "1", table.name = NULL
    ),
    regexp = cat("Assertion on',id.position,'failed: Must be of type numeric not character.")
  )

  expect_error(
    res <- subset_records(
      data.frame = iris, records = c("setosa", "virginica"),
      id.position = "1", table.name = NULL
    ),
    regexp = cat("Assertion on',id.position,'failed: Must be of type numeric not character.")
  )

  expect_error(
    res <- subset_records(
      data.frame = iris, records = "setosa, virginica",
      id.position = 5, table.name = c("iris", "iris")
    ),
    regexp = cat("Assertion on',table.name,'failed: Must be of type character of length 1.")
  )

  expect_error(
    res <- subset_records(
      data.frame = iris, records = c("setosa", "virginica"),
      id.position = 5, table.name = c("iris", "iris")
    ),
    regexp = cat("Assertion on',table.name,'failed: Must be of type character of length 1.")
  )
})

test_that("read_credentials works as expected", {
  res <- read_credentials(
    file.path = system.file("extdata", "test.ini", package = "readepi"),
    project.id = "Pats__Covid_19_Cohort_1_Screening"
  )
  expect_type(res, "list")
  expect_length(res, 6)
  expect_named(res, c("user", "pwd", "host", "project", "dbms", "port"))
  expect_type(res$user, "character")
  expect_type(res$pwd, "character")
  expect_type(res$host, "character")
  expect_type(res$project, "character")
  expect_type(res$dbms, "character")
  expect_type(res$port, "integer")
})

test_that("read_credentials fails as expected", {
  expect_error(
    res <- read_credentials(
      file.path = NULL,
      project.id = "Pats__Covid_19_Cohort_1_Screening"
    ),
    regexp = cat("Assertion on',file.path,'failed: Must provide a path to the credential file.")
  )

  expect_error(
    res <- read_credentials(
      file.path = c(system.file("extdata", "test.ini", package = "readepi"), system.file("extdata", "test.ini", package = "readepi")),
      project.id = "Pats__Covid_19_Cohort_1_Screening"
    ),
    regexp = cat("Assertion on',file.path,'failed: Impossible to read from multiple credential files.")
  )

  expect_error(
    res <- read_credentials(
      file.path = system.file("extdata", "test.ini", package = "readepi"),
      project.id = NULL
    ),
    regexp = cat("Assertion on',project.id,'failed: Must provide the database name (for MS SQLserver) or the project ID (for REDCap).")
  )

  expect_error(
    res <- read_credentials(
      file.path = system.file("extdata", "test.ini", package = "readepi"),
      project.id = c("Pats__Covid_19_Cohort_1_Screening", "Pats__Covid_19_Cohort_1_Screening")
    ),
    regexp = cat("Assertion on',project.id,'failed: Impossible to read from multiple databases or projects.")
  )
})


test_that("login works as expected", {
  expect_output(
    login(
      username = "admin",
      password = "district",
      base.url = "https://play.dhis2.org/dev/"
    ),
    ""
  )
})

test_that("login fails as expected", {
  expect_error(
    login(
      username = NULL,
      password = "district",
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    login(
      username = NA,
      password = "district",
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    login(
      username = c("admin","admin1"),
      password = "district",
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be of type character with length 1.")
  )

  expect_error(
    login(
      username = "admin",
      password = NULL,
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    login(
      username = "admin",
      password = NA,
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    login(
      username = "admin",
      password = c("district","district1"),
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character with length 1.")
  )

  expect_error(
    login(
      username = "admin",
      password = "district",
      base.url = NULL
    ),
    regexp = cat("Assertion on',base.url,'failed: Must be specified.")
  )

  expect_error(
    login(
      username = "admin",
      password = "district",
      base.url = NA
    ),
    regexp = cat("Assertion on',base.url,'failed: Must be specified.")
  )

  expect_error(
    login(
      username = "admin",
      password = "district",
      base.url = c("https://play.dhis2.org/dev/","https://play.dhis2.org/dev/test/")
    ),
    regexp = cat("Assertion on',base.url,'failed: Must be of type character with length 1.")
  )
})


test_that("get_data_elements works as expected", {
  data_element = get_data_elements(
    username = "admin",
    password = "district",
    base.url = "https://play.dhis2.org/dev/"
  )
  expect_s3_class(data_element, class = "data.frame")
})

test_that("get_data_elements fails as expected", {
  expect_error(
    data_element = get_data_elements(
      username = NULL,
      password = "district",
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    data_element = get_data_elements(
      username = NA,
      password = "district",
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    data_element = get_data_elements(
      username = c("admin","admin1"),
      password = "district",
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be of type character with length 1.")
  )

  expect_error(
    data_element = get_data_elements(
      username = "admin",
      password = NULL,
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    data_element = get_data_elements(
      username = "admin",
      password = NA,
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    data_element = get_data_elements(
      username = "admin",
      password = c("district","district1"),
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character with length 1.")
  )

  expect_error(
    data_element = get_data_elements(
      username = "admin",
      password = "district",
      base.url = NULL
    ),
    regexp = cat("Assertion on',base.url,'failed: Must be specified.")
  )

  expect_error(
    data_element = get_data_elements(
      username = "admin",
      password = "district",
      base.url = NA
    ),
    regexp = cat("Assertion on',base.url,'failed: Must be specified.")
  )

  expect_error(
    data_element = get_data_elements(
      username = "admin",
      password = "district",
      base.url = c("https://play.dhis2.org/dev/","https://play.dhis2.org/dev/test/")
    ),
    regexp = cat("Assertion on',base.url,'failed: Must be of type character with length 1.")
  )
})


test_that("get_data_sets works as expected", {
  dataset = get_data_sets(
    username = "admin",
    password = "district",
    base.url = "https://play.dhis2.org/dev/"
  )
  expect_s3_class(dataset, class = "data.frame")
})

test_that("get_data_sets fails as expected", {
  expect_error(
    dataset = get_data_sets(
      username = NULL,
      password = "district",
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    dataset = get_data_sets(
      username = NA,
      password = "district",
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    dataset = get_data_sets(
      username = c("admin","admin1"),
      password = "district",
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be of type character with length 1.")
  )

  expect_error(
    dataset = get_data_sets(
      username = "admin",
      password = NULL,
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    dataset = get_data_sets(
      username = "admin",
      password = NA,
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    dataset = get_data_sets(
      username = "admin",
      password = c("district","district1"),
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character with length 1.")
  )

  expect_error(
    dataset = get_data_sets(
      username = "admin",
      password = "district",
      base.url = NULL
    ),
    regexp = cat("Assertion on',base.url,'failed: Must be specified.")
  )

  expect_error(
    dataset = get_data_sets(
      username = "admin",
      password = "district",
      base.url = NA
    ),
    regexp = cat("Assertion on',base.url,'failed: Must be specified.")
  )

  expect_error(
    dataset = get_data_sets(
      username = "admin",
      password = c("district","district1"),
      base.url = c("https://play.dhis2.org/dev/","https://play.dhis2.org/dev/test/")
    ),
    regexp = cat("Assertion on',base.url,'failed: Must be of type character with length 1.")
  )
})

test_that("get_organisation_units works as expected", {
  organisation_units = get_organisation_units(
    username = "admin",
    password = "district",
    base.url = "https://play.dhis2.org/dev/"
  )
  expect_s3_class(organisation_units, class = "data.frame")
})

test_that("get_organisation_units fails as expected", {
  expect_error(
    organisation_units = get_organisation_units(
      username = NULL,
      password = "district",
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = NA,
      password = "district",
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = c("admin","admin1"),
      password = "district",
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be of type character with length 1.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = "admin",
      password = NULL,
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = "admin",
      password = NA,
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = "admin",
      password = c("district","district1"),
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character with length 1.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = "admin",
      password = "district",
      base.url = NULL
    ),
    regexp = cat("Assertion on',base.url,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = "admin",
      password = "district",
      base.url = NA
    ),
    regexp = cat("Assertion on',base.url,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = "admin",
      password = "district",
      base.url = c("https://play.dhis2.org/dev/","https://play.dhis2.org/dev/test/")
    ),
    regexp = cat("Assertion on',base.url,'failed: Must be of type character with length 1.")
  )
})


test_that("get_data_element_groups works as expected", {
  data_element_groups = get_data_element_groups(
    username = "admin",
    password = "district",
    base.url = "https://play.dhis2.org/dev/"
  )
  expect_s3_class(data_element_groups, class = "data.frame")
})

test_that("get_data_element_groups fails as expected", {
  expect_error(
    data_element_groups = get_data_element_groups(
      username = NULL,
      password = "district",
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    data_element_groups = get_data_element_groups(
      username = NA,
      password = "district",
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    data_element_groups = get_data_element_groups(
      username = c("admin","admin1"),
      password = "district",
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be of type character with length 1.")
  )

  expect_error(
    data_element_groups = get_data_element_groups(
      username = "admin",
      password = NULL,
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    data_element_groups = get_data_element_groups(
      username = "admin",
      password = NA,
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    data_element_groups = get_data_element_groups(
      username = "admin",
      password = c("district","district1"),
      base.url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character with length 1.")
  )

  expect_error(
    data_element_groups = get_data_element_groups(
      username = "admin",
      password = "district",
      base.url = NULL
    ),
    regexp = cat("Assertion on',base.url,'failed: Must be specified.")
  )

  expect_error(
    data_element_groups = get_data_element_groups(
      username = "admin",
      password = "district",
      base.url = NA
    ),
    regexp = cat("Assertion on',base.url,'failed: Must be specified.")
  )

  expect_error(
    data_element_groups = get_data_element_groups(
      username = "admin",
      password = "district",
      base.url = c("https://play.dhis2.org/dev/", "https://play.dhis2.org/dev/test/")
    ),
    regexp = cat("Assertion on',base.url,'failed: Must be of type character with length 1.")
  )
})


test_that("install_driver works as expected", {
  expect_output(
    install_driver(
      driver_version = 17,
      force_install = FALSE
    ),
    ""
  )
})

test_that("install_driver fails as expected", {
  expect_error(
    install_driver(
      driver_version = NULL,
      force_install = FALSE
    ),
    regexp = cat("Assertion on',driver_version,'failed: Must be specified.")
  )

  expect_error(
    install_driver(
      driver_version = NA,
      force_install = FALSE
    ),
    regexp = cat("Assertion on',driver_version,'failed: Must be specified.")
  )

  expect_error(
    install_driver(
      driver_version = "17",
      force_install = FALSE
    ),
    regexp = cat("Assertion on',driver_version,'failed: Must be of type numeric.")
  )

  expect_error(
    install_driver(
      driver_version = 17,
      force_install = NA
    ),
    regexp = cat("Assertion on',force_install,'failed: Must be logical TRUE/FALSE.")
  )

  expect_error(
    install_driver(
      driver_version = 17,
      force_install = c(TRUE,FALSE)
    ),
    regexp = cat("Assertion on',force_install,'failed: Must be logical of lenth 1.")
  )

  expect_error(
    install_driver(
      driver_version = 17,
      force_install = "TRUE"
    ),
    regexp = cat("Assertion on',force_install,'failed: Must be logical not character.")
  )
})


test_that("install_odbc_driver_mac works as expected", {
  expect_output(
    install_odbc_driver_mac(
      driver_version = 17,
      force_install = FALSE
    ),
    ""
  )
})

test_that("install_odbc_driver_mac fails as expected", {
  expect_error(
    install_odbc_driver_mac(
      driver_version = NULL,
      force_install = FALSE
    ),
    regexp = cat("Assertion on',driver_version,'failed: Must be specified.")
  )

  expect_error(
    install_odbc_driver_mac(
      driver_version = NA,
      force_install = FALSE
    ),
    regexp = cat("Assertion on',driver_version,'failed: Must be specified.")
  )

  expect_error(
    install_odbc_driver_mac(
      driver_version = "17",
      force_install = FALSE
    ),
    regexp = cat("Assertion on',driver_version,'failed: Must be of type numeric.")
  )

  expect_error(
    install_odbc_driver_mac(
      driver_version = 17,
      force_install = NA
    ),
    regexp = cat("Assertion on',force_install,'failed: Must be logical TRUE/FALSE.")
  )

  expect_error(
    install_odbc_driver_mac(
      driver_version = 17,
      force_install = c(TRUE,FALSE)
    ),
    regexp = cat("Assertion on',force_install,'failed: Must be logical of lenth 1.")
  )

  expect_error(
    install_odbc_driver_mac(
      driver_version = 17,
      force_install = "TRUE"
    ),
    regexp = cat("Assertion on',force_install,'failed: Must be logical not character.")
  )
})


