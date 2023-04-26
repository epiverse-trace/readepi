test_that("subset_fields works as expected", {
  res <- subset_fields(
    data_frame = iris, fields = "Sepal.Length,Sepal.Width",
    table_name = "iris"
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "not_found"))
  expect_s3_class(res$data, class = "data.frame")
  expect_type(res$not_found, "double")
})

test_that("subset_fields works as expected", {
  res <- subset_fields(
    data_frame = iris,
    fields = c("Sepal.Length", "Sepal.Width"),
    table_name = "iris"
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "not_found"))
  expect_s3_class(res$data, class = "data.frame")
  expect_type(res$not_found, "double")
})

test_that("subset_records works as expected", {
  res <- subset_records(
    data_frame = iris,
    records = "setosa, virginica",
    id_position = 5, table_name = "iris"
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "not_found"))
  expect_s3_class(res$data, class = "data.frame")
  expect_type(res$not_found, "double")
})

test_that("subset_records works as expected", {
  res <- subset_records(
    data_frame = iris, records = c("setosa", "virginica"),
    id_position = 5, table_name = "iris"
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
      data_frame = NULL,
      fields = "Sepal.Length,Sepal.Width",
      table_name = "iris"
    ),
    regexp = cat("Assertion on',data_frame,'failed: Must provide the data frame
                 to subset from.")
  )

  expect_error(
    res <- subset_fields(
      data_frame = NULL,
      fields = c("Sepal.Length", "Sepal.Width"),
      table_name = "iris"
    ),
    regexp = cat("Assertion on',data_frame,'failed: Must provide the data frame
                 to subset from.")
  )

  expect_error(
    res <- subset_fields(
      data_frame = NA,
      fields = "Sepal.Length,Sepal.Width",
      table_name = "iris"
    ),
    regexp = cat("Assertion on',data_frame,'failed: Missing value not allowed.")
  )

  expect_error(
    res <- subset_fields(
      data_frame = NA,
      fields = c("Sepal.Length", "Sepal.Width"),
      table_name = "iris"
    ),
    regexp = cat("Assertion on',data_frame,'failed: Missing value not allowed.")
  )

  expect_error(
    res <- subset_fields(
      data_frame = iris,
      fields = NULL,
      table_name = "iris"
    ),
    regexp = cat("Assertion on',fields,'failed: Must provide a vector or a
                 string with the field to subset.")
  )

  expect_error(
    res <- subset_fields(
      data_frame = iris,
      fields = NA,
      table_name = "iris"
    ),
    regexp = cat("Assertion on',fields,'failed: Missing value not allowed.")
  )

  expect_error(
    res <- subset_fields(
      data_frame = iris,
      fields = "Sepal.Length,Sepal.Width",
      table_name = NULL
    ),
    regexp = cat("Assertion on',table_name,'failed: Must provide the
                 table name.")
  )

  expect_error(
    res <- subset_fields(
      data_frame = iris,
      fields = c("Sepal.Length", "Sepal.Width"),
      table_name = NULL
    ),
    regexp = cat("Assertion on',table_name,'failed: Must provide the
                 table name.")
  )

  expect_error(
    res <- subset_fields(
      data_frame = iris,
      fields = "Sepal.Length,Sepal.Width",
      table_name = NA
    ),
    regexp = cat("Assertion on',table_name,'failed: Missing value not allowed.")
  )

  expect_error(
    res <- subset_fields(
      data_frame = iris,
      fields = c("Sepal.Length", "Sepal.Width"),
      table_name = NA
    ),
    regexp = cat("Assertion on',table_name,'failed: Missing value not allowed.")
  )

  expect_error(
    res <- subset_fields(
      data_frame = iris, fields = "Sepal.Length,Sepal.Width",
      table_name = c("iris", "iris3")
    ),
    regexp = cat("Assertion on',table_name,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    res <- subset_fields(
      data_frame = iris, fields = c("Sepal.Length", "Sepal.Width"),
      table_name = c("iris", "iris3")
    ),
    regexp = cat("Assertion on',table_name,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    res <- subset_fields(
      data_frame = NULL, fields = NULL,
      table_name = NULL
    ),
    regexp = cat("Assertion on',subset_fields,'failed: Must provide the data
                 frame to subset from, the fields to subset and the table name
                 from which to subset.")
  )

  expect_error(
    res <- subset_fields(
      data_frame = NULL, fields = "Sepal.Length,Sepal.Width",
      table_name = NULL
    ),
    regexp = cat("Assertion on',subset_fields,'failed: Must provide the data
                 frame to subset from, and the table name from which
                 to subset.")
  )

  expect_error(
    res <- subset_fields(
      data_frame = iris, fields = NULL,
      table_name = NULL
    ),
    regexp = cat("Assertion on',subset_fields,'failed: Must provide the fields
                 to subset, and the table name from which to subset.")
  )

  expect_error(
    res <- subset_fields(
      data_frame = NULL, fields = NULL,
      table_name = "iris"
    ),
    regexp = cat("Assertion on',subset_fields,'failed: Must provide the fields
                 to subset, and the data frame from which to subset.")
  )
})

test_that("subset_records fails as expected", {
  expect_error(
    res <- subset_records(
      data_frame = NULL, records = "setosa, virginica",
      id_position = 5, table_name = "iris"
    ),
    regexp = cat("Assertion on',data_frame,'failed: Must provide the data frame
                 to subset from.")
  )

  expect_error(
    res <- subset_records(
      data_frame = NULL, records = c("setosa", "virginica"),
      id_position = 5, table_name = "iris"
    ),
    regexp = cat("Assertion on',data_frame,'failed: Must provide the data frame
                 to subset from.")
  )

  expect_error(
    res <- subset_records(
      data_frame = NA, records = "setosa, virginica",
      id_position = 5, table_name = "iris"
    ),
    regexp = cat("Assertion on',data_frame,'failed: Missing value not allowed.")
  )

  expect_error(
    res <- subset_records(
      data_frame = NA, records = c("setosa", "virginica"),
      id_position = 5, table_name = "iris"
    ),
    regexp = cat("Assertion on',data_frame,'failed: Missing value not allowed.")
  )

  expect_error(
    res <- subset_records(
      data_frame = iris, records = NULL,
      id_position = 5, table_name = "iris"
    ),
    regexp = cat("Assertion on',records,'failed: Must provide a vector or a
                 string with the field to subset.")
  )

  expect_error(
    res <- subset_records(
      data_frame = iris, records = NA,
      id_position = 5, table_name = "iris"
    ),
    regexp = cat("Assertion on',records,'failed: Missing value not allowed.")
  )

  expect_error(
    res <- subset_records(
      data_frame = iris, records = "setosa, virginica",
      id_position = -1, table_name = NULL
    ),
    regexp = cat("Assertion on',id_position,'failed: Negative column number
                 not allowed.")
  )

  expect_error(
    res <- subset_records(
      data_frame = iris, records = c("setosa", "virginica"),
      id_position = -1, table_name = NULL
    ),
    regexp = cat("Assertion on',id_position,'failed: Negative column number
                 not allowed.")
  )

  expect_error(
    res <- subset_records(
      data_frame = iris, records = "setosa, virginica",
      id_position = "1", table_name = NULL
    ),
    regexp = cat("Assertion on',id_position,'failed: Must be of type numeric
                 not character.")
  )

  expect_error(
    res <- subset_records(
      data_frame = iris, records = c("setosa", "virginica"),
      id_position = "1", table_name = NULL
    ),
    regexp = cat("Assertion on',id_position,'failed: Must be of type numeric
                 not character.")
  )

  expect_error(
    res <- subset_records(
      data_frame = iris, records = c("setosa", "virginica"),
      id_position = NA, table_name = "iris"
    ),
    regexp = cat("Assertion on',id_position,'failed: Missing value
                 not allowed.")
  )

  expect_error(
    res <- subset_records(
      data_frame = iris, records = "setosa, virginica",
      id_position = 5, table_name = c("iris", "iris3")
    ),
    regexp = cat("Assertion on',table_name,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    res <- subset_records(
      data_frame = iris, records = c("setosa", "virginica"),
      id_position = 5, table_name = c("iris", "iris3")
    ),
    regexp = cat("Assertion on',table_name,'failed: Must be of type character
                 of length 1.")
  )

  expect_error(
    res <- subset_records(
      data_frame = iris, records = "setosa, virginica",
      id_position = 5, table_name = NULL
    ),
    regexp = cat("Assertion on',table_name,'failed: Must be provided.")
  )

  expect_error(
    res <- subset_records(
      data_frame = iris, records = c("setosa", "virginica"),
      id_position = 5, table_name = NULL
    ),
    regexp = cat("Assertion on',table_name,'failed: Must be provided.")
  )

  expect_error(
    res <- subset_records(
      data_frame = iris, records = "setosa, virginica",
      id_position = 5, table_name = NA
    ),
    regexp = cat("Assertion on',table_name,'failed: Missing value not allowed.")
  )

  expect_error(
    res <- subset_records(
      data_frame = iris, records = c("setosa", "virginica"),
      id_position = 5, table_name = NA
    ),
    regexp = cat("Assertion on',table_name,'failed: Missing value not allowed.")
  )
})

test_that("read_credentials works as expected", {
  res <- read_credentials(
    file_path = system.file("extdata", "test.ini", package = "readepi"),
    project_id = "Rfam"
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
      file_path = NULL,
      project_id = "Rfam"
    ),
    regexp = cat("Assertion on',file_path,'failed: Must provide a path to
                 the credential file.")
  )

  expect_error(
    res <- read_credentials(
      file_path = c(system.file("extdata", "test.ini", package = "readepi"),
                    system.file("extdata", "test.ini", package = "readepi")),
      project_id = "Rfam"
    ),
    regexp = cat("Assertion on',file_path,'failed: Impossible to read from
                 multiple credential files.")
  )

  expect_error(
    res <- read_credentials(
      file_path = system.file("extdata", "test.ini", package = "readepi"),
      project_id = NULL
    ),
    regexp = cat("Assertion on',project_id,'failed: Must provide the database
                 name or the project ID (for REDCap).")
  )

  expect_error(
    res <- read_credentials(
      file_path = system.file("extdata", "test.ini", package = "readepi"),
      project_id = c("Rfam", "TEST_REDCap")
    ),
    regexp = cat("Assertion on',project_id,'failed: Impossible to read from
                 multiple databases or projects.")
  )
})


test_that("login works as expected", {
  expect_output(
    login(
      username = "admin",
      password = "district",
      base_url = "https://play.dhis2.org/dev/"
    ),
    ""
  )
})

test_that("login fails as expected", {
  expect_error(
    login(
      username = NULL,
      password = "district",
      base_url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    login(
      username = NA,
      password = "district",
      base_url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    login(
      username = c("admin", "admin1"),
      password = "district",
      base_url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    login(
      username = "admin",
      password = NULL,
      base_url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    login(
      username = "admin",
      password = NA,
      base_url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    login(
      username = "admin",
      password = c("district", "district1"),
      base_url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    login(
      username = "admin",
      password = "district",
      base_url = NULL
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be specified.")
  )

  expect_error(
    login(
      username = "admin",
      password = "district",
      base_url = NA
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be specified.")
  )

  expect_error(
    login(
      username = "admin",
      password = "district",
      base_url = c("https://play.dhis2.org/dev/",
                   "https://play.dhis2.org/dev/test/")
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be of type character
                 with length 1.")
  )
})


test_that("get_data_elements works as expected", {
  data_element <- get_data_elements(
    username = "admin",
    password = "district",
    base_url = "https://play.dhis2.org/dev/"
  )
  expect_s3_class(data_element, class = "data.frame")
})

test_that("get_data_elements fails as expected", {
  expect_error(
    data_element = get_data_elements(
      username = NULL,
      password = "district",
      base_url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    data_element = get_data_elements(
      username = NA,
      password = "district",
      base_url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    data_element = get_data_elements(
      username = c("admin", "admin1"),
      password = "district",
      base_url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    data_element = get_data_elements(
      username = "admin",
      password = NULL,
      base_url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    data_element = get_data_elements(
      username = "admin",
      password = NA,
      base_url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    data_element = get_data_elements(
      username = "admin",
      password = c("district", "district1"),
      base_url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    data_element = get_data_elements(
      username = "admin",
      password = "district",
      base_url = NULL
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be specified.")
  )

  expect_error(
    data_element = get_data_elements(
      username = "admin",
      password = "district",
      base_url = NA
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be specified.")
  )

  expect_error(
    data_element = get_data_elements(
      username = "admin",
      password = "district",
      base_url = c("https://play.dhis2.org/dev/",
                   "https://play.dhis2.org/dev/test/")
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be of type character
                 with length 1.")
  )
})


test_that("get_data_sets works as expected", {
  dataset <- get_data_sets(
    username = "admin",
    password = "district",
    base_url = "https://play.dhis2.org/dev/"
  )
  expect_s3_class(dataset, class = "data.frame")
})

test_that("get_data_sets fails as expected", {
  expect_error(
    dataset = get_data_sets(
      username = NULL,
      password = "district",
      base_url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    dataset = get_data_sets(
      username = NA,
      password = "district",
      base_url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    dataset = get_data_sets(
      username = c("admin", "admin1"),
      password = "district",
      base_url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    dataset = get_data_sets(
      username = "admin",
      password = NULL,
      base_url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    dataset = get_data_sets(
      username = "admin",
      password = NA,
      base_url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    dataset = get_data_sets(
      username = "admin",
      password = c("district", "district1"),
      base_url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    dataset = get_data_sets(
      username = "admin",
      password = "district",
      base_url = NULL
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be specified.")
  )

  expect_error(
    dataset = get_data_sets(
      username = "admin",
      password = "district",
      base_url = NA
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be specified.")
  )

  expect_error(
    dataset = get_data_sets(
      username = "admin",
      password = c("district", "district1"),
      base_url = c("https://play.dhis2.org/dev/",
                   "https://play.dhis2.org/dev/test/")
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be of type character
                 with length 1.")
  )
})

test_that("get_organisation_units works as expected", {
  organisation_units <- get_organisation_units(
    base_url = "https://play.dhis2.org/dev/",
    username = "admin",
    password = "district"
  )
  expect_s3_class(organisation_units, class = "data.frame")
})

test_that("get_organisation_units fails as expected", {
  expect_error(
    organisation_units = get_organisation_units(
      base_url = "https://play.dhis2.org/dev/",
      username = NULL,
      password = "district"
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = NA,
      password = "district",
      base_url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = c("admin", "admin1"),
      password = "district",
      base_url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',username,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = "admin",
      password = NULL,
      base_url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = "admin",
      password = NA,
      base_url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = "admin",
      password = c("district", "district1"),
      base_url = "https://play.dhis2.org/dev/"
    ),
    regexp = cat("Assertion on',password,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = "admin",
      password = "district",
      base_url = NULL
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = "admin",
      password = "district",
      base_url = NA
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = "admin",
      password = "district",
      base_url = c("https://play.dhis2.org/dev/",
                   "https://play.dhis2.org/dev/test/")
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be of type character
                 with length 1.")
  )
})


test_that("get_ind_id_from_ind_name works as expected", {
  indicator_id <- get_ind_id_from_ind_name(
    metadata = list(
      indicator_profile_domain = fingertipsR::indicators(),
      indicator_ids_names = fingertipsR::indicators_unique(),
      area_type = fingertipsR::area_types()
    ),
    indicator_name = "Pupil absence"
  )
  expect_vector(indicator_id)
})

test_that("get_ind_id_from_ind_name fails with a bad metadata list", {
  expect_error(
    indicator_id = get_ind_id_from_ind_name(
      metadata = list(),
      indicator_name = "Pupil absence"
    ),
    regexp = cat("Assertion on',metadata,'failed: Must be a list of 3
                 data frames")
  )

  expect_error(
    indicator_id = get_ind_id_from_ind_name(
      metadata = NA,
      indicator_name = "Pupil absence"
    ),
    regexp = cat("Assertion on',metadata,'failed: Must be provided.")
  )

  expect_error(
    indicator_id = get_ind_id_from_ind_name(
      metadata = NULL,
      indicator_name = "Pupil absence"
    ),
    regexp = cat("Assertion on',metadata,'failed: Must be provided.")
  )

  expect_error(
    indicator_id = get_ind_id_from_ind_name(
      metadata = metadata,
      indicator_name = NA
    ),
    regexp = cat("Assertion on',indicator_name,'failed: Missing indicator_name
                 not allowed.")
  )
})


test_that("get_ind_id_from_domain_id works as expected", {
  indicator_id <- get_ind_id_from_domain_id(
    metadata = list(
      indicator_profile_domain = fingertipsR::indicators(),
      indicator_ids_names = fingertipsR::indicators_unique(),
      area_type = fingertipsR::area_types()
    ),
    domain_id = 1000041,
    indicator_name = "Pupil absence"
  )
  expect_vector(indicator_id)

  indicator_id <- get_ind_id_from_domain_id(
    metadata = list(
      indicator_profile_domain = fingertipsR::indicators(),
      indicator_ids_names = fingertipsR::indicators_unique(),
      area_type = fingertipsR::area_types()
    ),
    domain_id = 1000041,
    indicator_name = NULL
  )
  expect_vector(indicator_id)
})

test_that("get_ind_id_from_domain_id fails as expected", {
  expect_error(
    indicator_id = get_ind_id_from_domain_id(
      metadata = list(),
      domain_id = 1000041,
      indicator_name = "Pupil absence"
    ),
    regexp = cat("Assertion on',metadata,'failed: Must be a list of 3
                 data frames")
  )

  expect_error(
    indicator_id = get_ind_id_from_domain_id(
      metadata = NA,
      domain_id = 1000041,
      indicator_name = "Pupil absence"
    ),
    regexp = cat("Assertion on',metadata,'failed: Must be provided.")
  )

  expect_error(
    indicator_id = get_ind_id_from_domain_id(
      metadata = NULL,
      domain_id = 1000041,
      indicator_name = "Pupil absence"
    ),
    regexp = cat("Assertion on',metadata,'failed: Must be provided.")
  )

  expect_error(
    indicator_id = get_ind_id_from_domain_id(
      metadata = list(
        indicator_profile_domain = fingertipsR::indicators(),
        indicator_ids_names = fingertipsR::indicators_unique(),
        area_type = fingertipsR::area_types()
      ),
      domain_id = 1000041,
      indicator_name = NA
    ),
    regexp = cat("Assertion on',indicator_name,'failed: Missing indicator_name
                 not allowed.")
  )

  expect_error(
    indicator_id = get_ind_id_from_domain_id(
      metadata = list(
        indicator_profile_domain = fingertipsR::indicators(),
        indicator_ids_names = fingertipsR::indicators_unique(),
        area_type = fingertipsR::area_types()
      ),
      domain_id = NA,
      indicator_name = "Pupil absence"
    ),
    regexp = cat("Assertion on',domain_id,'failed: Missing domain_id
                 not allowed.")
  )
})


test_that("get_ind_id_from_domain_name works as expected", {
  indicator_id <- get_ind_id_from_domain_name(
    metadata = list(
      indicator_profile_domain = fingertipsR::indicators(),
      indicator_ids_names = fingertipsR::indicators_unique(),
      area_type = fingertipsR::area_types()
    ),
    domain_name = "B. Wider determinants of health",
    indicator_name = "Pupil absence"
  )
  expect_vector(indicator_id)

  indicator_id <- get_ind_id_from_domain_name(
    metadata = list(
      indicator_profile_domain = fingertipsR::indicators(),
      indicator_ids_names = fingertipsR::indicators_unique(),
      area_type = fingertipsR::area_types()
    ),
    domain_name = "B. Wider determinants of health",
    indicator_name = NULL
  )
  expect_vector(indicator_id)
})

test_that("get_ind_id_from_domain_name fails as expected", {
  expect_error(
    indicator_id = get_ind_id_from_domain_name(
      metadata = list(),
      domain_name = "B. Wider determinants of health",
      indicator_name = "Pupil absence"
    ),
    regexp = cat("Assertion on',metadata,'failed: Must be a list of 3
                 data frames")
  )

  expect_error(
    indicator_id = get_ind_id_from_domain_name(
      metadata = NA,
      domain_name = "B. Wider determinants of health",
      indicator_name = "Pupil absence"
    ),
    regexp = cat("Assertion on',metadata,'failed: Must be provided.")
  )

  expect_error(
    indicator_id = get_ind_id_from_domain_name(
      metadata = NULL,
      domain_name = "B. Wider determinants of health",
      indicator_name = "Pupil absence"
    ),
    regexp = cat("Assertion on',metadata,'failed: Must be provided.")
  )

  expect_error(
    indicator_id = get_ind_id_from_domain_name(
      metadata = list(
        indicator_profile_domain = fingertipsR::indicators(),
        indicator_ids_names = fingertipsR::indicators_unique(),
        area_type = fingertipsR::area_types()
      ),
      domain_name = "B. Wider determinants of health",
      indicator_name = NA
    ),
    regexp = cat("Assertion on',indicator_name,'failed: Missing indicator_name
                 not allowed.")
  )

  expect_error(
    indicator_id = get_ind_id_from_domain_name(
      metadata = list(
        indicator_profile_domain = fingertipsR::indicators(),
        indicator_ids_names = fingertipsR::indicators_unique(),
        area_type = fingertipsR::area_types()
      ),
      domain_name = NA,
      indicator_name = "Pupil absence"
    ),
    regexp = cat("Assertion on',domain_name,'failed: Missing domain_name
                 not allowed.")
  )
})


test_that("get_ind_id_from_profile works as expected", {
  indicator_id <- get_ind_id_from_profile(
    metadata = list(
      indicator_profile_domain = fingertipsR::indicators(),
      indicator_ids_names = fingertipsR::indicators_unique(),
      area_type = fingertipsR::area_types()
    ),
    domain_id = 1000041,
    domain_name = "B. Wider determinants of health",
    indicator_name = "Pupil absence",
    profile_name = "Public Health Outcomes Framework",
    profile_id = 19
  )
  expect_vector(indicator_id)

  indicator_id <- get_ind_id_from_profile(
    metadata = list(
      indicator_profile_domain = fingertipsR::indicators(),
      indicator_ids_names = fingertipsR::indicators_unique(),
      area_type = fingertipsR::area_types()
    ),
    domain_id = NULL,
    domain_name = NULL,
    indicator_name = NULL,
    profile_name = "Public Health Outcomes Framework",
    profile_id = NULL
  )
  expect_vector(indicator_id)

  indicator_id <- get_ind_id_from_profile(
    metadata = list(
      indicator_profile_domain = fingertipsR::indicators(),
      indicator_ids_names = fingertipsR::indicators_unique(),
      area_type = fingertipsR::area_types()
    ),
    domain_id = NULL,
    domain_name = NULL,
    indicator_name = NULL,
    profile_name = NULL,
    profile_id = 19
  )
  expect_vector(indicator_id)
})


test_that("get_ind_id_from_profile fails as expected", {
  expect_error(
    indicator_id = get_ind_id_from_profile(
      metadata = list(),
      domain_id = 1000041,
      domain_name = "B. Wider determinants of health",
      indicator_name = "Pupil absence",
      profile_name = "Public Health Outcomes Framework",
      profile_id = 19
    ),
    regexp = cat("Assertion on',metadata,'failed: Must be a list of 3
                 data frames")
  )

  expect_error(
    indicator_id = get_ind_id_from_profile(
      metadata = NA,
      domain_id = 1000041,
      domain_name = "B. Wider determinants of health",
      indicator_name = "Pupil absence",
      profile_name = "Public Health Outcomes Framework",
      profile_id = 19
    ),
    regexp = cat("Assertion on',metadata,'failed: Must be provided.")
  )

  expect_error(
    indicator_id = get_ind_id_from_profile(
      metadata = NULL,
      domain_id = 1000041,
      domain_name = "B. Wider determinants of health",
      indicator_name = "Pupil absence",
      profile_name = "Public Health Outcomes Framework",
      profile_id = 19
    ),
    regexp = cat("Assertion on',metadata,'failed: Must be provided.")
  )

  expect_error(
    indicator_id = get_ind_id_from_profile(
      metadata = list(
        indicator_profile_domain = fingertipsR::indicators(),
        indicator_ids_names = fingertipsR::indicators_unique(),
        area_type = fingertipsR::area_types()
      ),
      domain_id = 1000041,
      domain_name = "B. Wider determinants of health",
      indicator_name = NA,
      profile_name = "Public Health Outcomes Framework",
      profile_id = 19
    ),
    regexp = cat("Assertion on',indicator_name,'failed: Missing indicator_name
                 not allowed.")
  )

  expect_error(
    indicator_id = get_ind_id_from_profile(
      metadata = list(
        indicator_profile_domain = fingertipsR::indicators(),
        indicator_ids_names = fingertipsR::indicators_unique(),
        area_type = fingertipsR::area_types()
      ),
      domain_id = 1000041,
      domain_name = NA,
      indicator_name = "Pupil absence",
      profile_name = "Public Health Outcomes Framework",
      profile_id = 19
    ),
    regexp = cat("Assertion on',domain_name,'failed: Missing domain_name
                 not allowed.")
  )

  expect_error(
    indicator_id = get_ind_id_from_profile(
      metadata = list(
        indicator_profile_domain = fingertipsR::indicators(),
        indicator_ids_names = fingertipsR::indicators_unique(),
        area_type = fingertipsR::area_types()
      ),
      domain_id = NA,
      domain_name = "B. Wider determinants of health",
      indicator_name = "Pupil absence",
      profile_name = "Public Health Outcomes Framework",
      profile_id = 19
    ),
    regexp = cat("Assertion on',domain_id,'failed: Missing domain_id
                 not allowed.")
  )

  expect_error(
    indicator_id = get_ind_id_from_profile(
      metadata = list(
        indicator_profile_domain = fingertipsR::indicators(),
        indicator_ids_names = fingertipsR::indicators_unique(),
        area_type = fingertipsR::area_types()
      ),
      domain_id = 1000041,
      domain_name = "B. Wider determinants of health",
      indicator_name = "Pupil absence",
      profile_name = NA,
      profile_id = 19
    ),
    regexp = cat("Assertion on',profile_name,'failed: Missing profile_name
                 not allowed.")
  )

  expect_error(
    indicator_id = get_ind_id_from_profile(
      metadata = list(
        indicator_profile_domain = fingertipsR::indicators(),
        indicator_ids_names = fingertipsR::indicators_unique(),
        area_type = fingertipsR::area_types()
      ),
      domain_id = 1000041,
      domain_name = "B. Wider determinants of health",
      indicator_name = "Pupil absence",
      profile_name = "Public Health Outcomes Framework",
      profile_id = NA
    ),
    regexp = cat("Assertion on',profile_id,'failed: Missing profile_id
                 not allowed.")
  )
})


test_that("get_fingertips_metadata works as expected", {
  metadata <- get_fingertips_metadata()
  expect_type(metadata, "list")
  expect_length(metadata, 3)
  expect_named(metadata, c("indicator_profile_domain", "indicator_ids_names",
                           "area_type"))
  expect_s3_class(metadata$indicator_profile_domain, "data.frame")
  expect_s3_class(metadata$indicator_ids_names, "data.frame")
  expect_s3_class(metadata$area_type, "data.frame")
})


