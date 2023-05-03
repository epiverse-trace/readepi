test_that("get_extension works as expected", {
  result <- get_extension(
    file_path = system.file("extdata", "test.txt", package = "readepi")
  )
  expect_type(result, "character")
})

test_that("get_base_name works as expected", {
  result <- get_base_name(
    x = system.file("extdata", "test.txt", package = "readepi")
  )
  expect_type(result, "character")
})

test_that("detect_separator works as expected", {
  result <- detect_separator(
    x = "My name is Karim"
  )
  expect_type(result, "character")
})

test_that("read_rio_formats works as expected", {
  result <- read_rio_formats(
    files_extensions = ".txt",
    rio_extensions = c("txt", "xlxs"),
    files = system.file("extdata", "test.txt", package = "readepi"),
    files_base_names = "test"
  )
  expect_type(result, "list")
})

test_that("read_multiple_files works as expected", {
  result <- read_multiple_files(
    files = system.file("extdata", "test.txt", package = "readepi"),
    dirs = list.dirs(
      path = system.file("extdata", package = "readepi")
    ),
    format = c("txt", "csv"),
    which = NULL
  )
  expect_type(result, "list")
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
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    ""
  )
})

test_that("login fails as expected", {
  expect_error(
    login(
      username = NULL,
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    login(
      username = NA,
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    login(
      username = c("admin", "admin1"),
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    login(
      username = "admin",
      password = NULL,
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    login(
      username = "admin",
      password = NA,
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    login(
      username = "admin",
      password = c("district", "district1"),
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
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
      base_url = c(file.path("https:/", "play.dhis2.org", "dev", ""),
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
    base_url = file.path("https:/", "play.dhis2.org", "dev", "")
  )
  expect_s3_class(data_element, class = "data.frame")
})

test_that("get_data_elements fails as expected", {
  expect_error(
    data_element = get_data_elements(
      username = NULL,
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    data_element = get_data_elements(
      username = NA,
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    data_element = get_data_elements(
      username = c("admin", "admin1"),
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    data_element = get_data_elements(
      username = "admin",
      password = NULL,
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    data_element = get_data_elements(
      username = "admin",
      password = NA,
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    data_element = get_data_elements(
      username = "admin",
      password = c("district", "district1"),
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
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
      base_url = c(file.path("https:/", "play.dhis2.org", "dev", ""),
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
    base_url = file.path("https:/", "play.dhis2.org", "dev", "")
  )
  expect_s3_class(dataset, class = "data.frame")
})

test_that("get_data_sets fails as expected", {
  expect_error(
    dataset = get_data_sets(
      username = NULL,
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    dataset = get_data_sets(
      username = NA,
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    dataset = get_data_sets(
      username = c("admin", "admin1"),
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    dataset = get_data_sets(
      username = "admin",
      password = NULL,
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    dataset = get_data_sets(
      username = "admin",
      password = NA,
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    dataset = get_data_sets(
      username = "admin",
      password = c("district", "district1"),
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
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
      base_url = c(file.path("https:/", "play.dhis2.org", "dev", ""),
                   "https://play.dhis2.org/dev/test/")
    ),
    regexp = cat("Assertion on',base_url,'failed: Must be of type character
                 with length 1.")
  )
})

test_that("get_organisation_units works as expected", {
  organisation_units <- get_organisation_units(
    base_url = file.path("https:/", "play.dhis2.org", "dev", ""),
    username = "admin",
    password = "district"
  )
  expect_s3_class(organisation_units, class = "data.frame")
})

test_that("get_organisation_units fails as expected", {
  expect_error(
    organisation_units = get_organisation_units(
      base_url = file.path("https:/", "play.dhis2.org", "dev", ""),
      username = NULL,
      password = "district"
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = NA,
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = c("admin", "admin1"),
      password = "district",
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',username,'failed: Must be of type character
                 with length 1.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = "admin",
      password = NULL,
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = "admin",
      password = NA,
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
    ),
    regexp = cat("Assertion on',password,'failed: Must be specified.")
  )

  expect_error(
    organisation_units = get_organisation_units(
      username = "admin",
      password = c("district", "district1"),
      base_url = file.path("https:/", "play.dhis2.org", "dev", "")
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
      base_url = c(file.path("https:/", "play.dhis2.org", "dev", ""),
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


test_that("get_profile_name works as expected", {
  res <- get_profile_name(profile_id = 19,
                          profile_name = "Public Health Outcomes Framework",
                          metadata = list(
                        indicator_profile_domain = fingertipsR::indicators(),
                        indicator_ids_names = fingertipsR::indicators_unique(),
                        area_type = fingertipsR::area_types()
                      ))
  expect_type(res, "list")
  expect_length(res, 2)
  expect_type(res[[1]], "character")
  expect_type(res[[2]], "integer")
})

test_that("get_profile_name fails as expected", {
  expect_error(
    get_profile_name(
      profile_id = NA,
      profile_name = "Public Health Outcomes Framework",
      metadata = list(
        indicator_profile_domain = fingertipsR::indicators(),
        indicator_ids_names = fingertipsR::indicators_unique(),
        area_type = fingertipsR::area_types()
      )),
    regexp = cat("Assertion on',profile_id,'failed: Missing value not allowed
                 for profile_id.")
  )

  expect_error(
    get_profile_name(
      profile_id = 19,
      profile_name = NA,
      metadata = list(
        indicator_profile_domain = fingertipsR::indicators(),
        indicator_ids_names = fingertipsR::indicators_unique(),
        area_type = fingertipsR::area_types()
      )),
    regexp = cat("Assertion on',profile_name,'failed: Missing value not allowed
                 for profile_name.")
  )

  expect_error(
    get_profile_name(
      profile_id = 19,
      profile_name = NA,
      metadata = NA
    ),
    regexp = cat("Assertion on',metadata,'failed: Missing value not allowed
                 for metadata")
  )

  expect_error(
    get_profile_name(
      profile_id = 19,
      profile_name = NA,
      metadata = NULL
    ),
    regexp = cat("Assertion on',metadata,'failed: Must be provided.")
  )
})

test_that("read_files_in_directory works as expected", {
  res <- read_files_in_directory(
    file_path = system.file("extdata", package = "readepi"),
    pattern = ".txt"
  )
  expect_type(res, "list")

  res <- read_files_in_directory(
    file_path = system.file("extdata", package = "readepi"),
    pattern = NULL
  )
  expect_type(res, "list")
})

test_that("read_files_in_directory fails as expected", {
  expect_error(
    read_files_in_directory(
      file_path = NULL,
      pattern = ".txt"
    ),
    regexp = cat("Assertion on',file_path,'failed: Must be provided.")
  )

  expect_error(
    read_files_in_directory(
      file_path = NA,
      pattern = ".txt"
    ),
    regexp = cat("Assertion on',file_path,'failed: Missing value not allowed for
                 file_path.")
  )

  expect_error(
    read_files_in_directory(
      file_path = system.file("extdata", package = "readepi"),
      pattern = NA
    ),
    regexp = cat("Assertion on',file_path,'failed: Missing value not allowed for
                 pattern.")
  )
})

test_that("read_files works as expected", {
  res <- read_files(
    file_path = system.file("extdata", "test.xlsx", package = "readepi"),
    sep = NULL,
    format = NULL,
    which = "Sheet1"
  )
  expect_type(res, "list")

  res <- read_files(
    file_path = system.file("extdata", "test.xlsx", package = "readepi"),
    sep = NULL,
    format = NULL,
    which = NULL
  )
  expect_type(res, "list")

  res <- read_files(
    file_path = system.file("extdata", "test.txt", package = "readepi"),
    sep = "\t",
    format = ".txt",
    which = NULL
  )
  expect_type(res, "list")
})

test_that("read_files fails as expected", {
  expect_error(
    read_files(
      file_path = NULL,
      sep = NULL,
      format = NULL,
      which = NULL
    ),
    regexp = cat("Assertion on',file_path,'failed: Must be provided.")
  )

  expect_error(
    read_files(
      file_path = NA,
      sep = NULL,
      format = NULL,
      which = NULL
    ),
    regexp = cat("Assertion on',file_path,'failed: Missing value not allowed for
                 file_path.")
  )

  expect_error(
    read_files(
      file_path = system.file("extdata", "test.xlsx", package = "readepi"),
      sep = c(" ", "\t"),
      format = NULL,
      which = NULL
    ),
    regexp = cat("Assertion on',sep,'failed: Must be a character of length 1.")
  )

  expect_error(
    read_files(
      file_path = system.file("extdata", "test.xlsx", package = "readepi"),
      sep = NA,
      format = NULL,
      which = NULL
    ),
    regexp = cat("Assertion on',sep,'failed: Missing value not allowed
                 for sep.")
  )

  expect_error(
    read_files(
      file_path = system.file("extdata", "test.txt", package = "readepi"),
      sep = "\t",
      format = NA,
      which = NULL
    ),
    regexp = cat("Assertion on',sep,'failed: Missing value not allowed
                 for format")
  )

  expect_error(
    read_files(
      file_path = system.file("extdata", "test.txt", package = "readepi"),
      sep = "\t",
      format = NULL,
      which = NA
    ),
    regexp = cat("Assertion on',sep,'failed: Missing value not allowed
                 for which")
  )
})

test_that("fingertips_subset_rows works as expected", {
  res <- fingertips_subset_rows(
    records = "setosa",
    id_col_name = "Species",
    data = iris
  )
  expect_s3_class(res, "data.frame")
})

test_that("read_files fails as expected", {
  expect_error(
    fingertips_subset_rows(
      records = NA,
      id_col_name = "Species",
      data = iris
    ),
    regexp = cat("Assertion on',records,'failed: Missing value not allowed for
                 records.")
  )

  expect_error(
    fingertips_subset_rows(
      records = "setosa",
      id_col_name = NULL,
      data = iris
    ),
    regexp = cat("Assertion on',id_col_name,'failed: Must be specified.")
  )

  expect_error(
    fingertips_subset_rows(
      records = "setosa",
      id_col_name = "Species",
      data = NULL
    ),
    regexp = cat("Assertion on',data,'failed: Must be specified.")
  )
})

test_that("fingertips_subset_columns works as expected", {
  res <- fingertips_subset_columns(
    fields = c("Sepal.Width", "Petal.Length"),
    data = iris
  )
  expect_s3_class(res, "data.frame")
})

test_that("read_files fails as expected", {
  expect_error(
    fingertips_subset_columns(
      fields = "Sepal.Width,Petal.Length",
      data = NULL
    ),
    regexp = cat("Assertion on',data,'failed: Must be provided")
  )
})

test_that("redcap_read works as expected", {
  res <- redcap_read(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id_position = 1
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("redcap_data", "metadata"))
  expect_type(res$redcap_data, "list")
  expect_type(res$metadata, "list")
})

test_that("redcap_read works as expected", {
  res <- redcap_read(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id_position = 1
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("redcap_data", "metadata"))
  expect_type(res$redcap_data, "list")
  expect_type(res$metadata, "list")
})

test_that("redcap_read_rows_columns works as expected", {
  res <- redcap_read_rows_columns(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id_position = 1,
    id_col_name = NULL,
    fields = c("record_id", "name_first", "age", "bmi"),
    records = c("1", "3", "5")
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("redcap_data", "metadata"))
  expect_type(res$redcap_data, "list")
  expect_type(res$metadata, "list")
})

test_that("redcap_read_fields works as expected", {
  res <- redcap_read_fields(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id_position = 1,
    fields = c("record_id", "name_first", "age", "bmi")
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("redcap_data", "metadata"))
  expect_type(res$redcap_data, "list")
  expect_type(res$metadata, "list")
})

test_that("redcap_read_records works as expected", {
  res <- redcap_read_records(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    id_position = 1,
    records = c("1", "2", "3"),
    id_col_name = NULL
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("redcap_data", "metadata"))
  expect_type(res$redcap_data, "list")
  expect_type(res$metadata, "list")
})

test_that("get_read_file_args works as expected", {
  res <- get_read_file_args(
    list(
      sep = "\t",
      format = ".txt",
      which = NULL
    )
  )
  expect_type(res, "list")
  expect_length(res, 4)
  expect_named(res, c("sep", "format", "which", "pattern"))
})

test_that("get_read_fingertips_args works as expected", {
  res <- get_read_fingertips_args(
    list(
      indicator_id = 90362,
      area_type_id = 202
    )
  )
  expect_type(res, "list")
  expect_length(res, 8)
  expect_named(res, c("indicator_id", "indicator_name", "area_type_id",
                      "profile_id", "profile_name", "domain_id", "domain_name",
                      "parent_area_type_id"))
})

test_that("get_relevant_dataset works as expected", {
  result <- get_relevant_dataset(
    dataset = "pBOMPrpg1QX,BfMAe6Itzgt",
    base_url = "https://play.dhis2.org/dev/",
    username = "admin",
    password = "district"
  )
  expect_type(result, "list")
  expect_length(result, 2)
})

test_that("get_relevant_organisation_unit works as expected", {
  result <- get_relevant_organisation_unit(
    organisation_unit = "DiszpKrYNg8",
    base_url = "https://play.dhis2.org/dev/",
    username = "admin",
    password = "district"
  )
  expect_type(result, "list")
  expect_length(result, 2)
})

test_that("import_redcap_data works as expected", {
  result <- import_redcap_data(
    uri = "https://bbmc.ouhsc.edu/redcap/api/",
    token = "9A81268476645C4E5F03428B8AC3AA7B",
    records = c("1", "3", "5"),
    fields = c("record_id", "name_first", "age", "bmi"),
    id_col_name = NULL,
    id_position = 1
  )
  expect_type(result, "list")
  expect_length(result, 2)
})

test_that("dhis2_subset_fields works as expected", {
  result <- dhis2_subset_fields(
    fields = c("dataElement", "period", "value"),
    data = readepi(
      credentials_file = system.file("extdata", "test.ini", package = "readepi")
      , project_id = "DHIS2_DEMO",
      dataset = "pBOMPrpg1QX,BfMAe6Itzgt",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL,
      start_date = "2014",
      end_date = "2023"
    )$data
  )
  expect_s3_class(result, "data.frame")
})

test_that("dhis2_subset_records works as expected", {
  result <- dhis2_subset_records(
    records = c("FTRrcoaog83", "eY5ehpbEsB7", "Ix2HsbDMLea"),
    id_col_name = "dataElement",
    data = readepi(
      credentials_file = system.file("extdata", "test.ini",
                                     package = "readepi"),
      project_id = "DHIS2_DEMO",
      dataset = "pBOMPrpg1QX",
      organisation_unit = "DiszpKrYNg8",
      data_element_group = NULL,
      start_date = "2014",
      end_date = "2023"
    )$data
  )
  expect_s3_class(result, "data.frame")
})

test_that("redcap_get_results works as expected", {
  result <- redcap_get_results(
    redcap_data = REDCapR::redcap_read(
      redcap_uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      records = c("1", "3", "5"),
      fields = c("record_id", "name_first", "age", "bmi"), verbose = FALSE,
      id_position = 1L),
    metadata = REDCapR::redcap_metadata_read(
      redcap_uri = "https://bbmc.ouhsc.edu/redcap/api/",
      token = "9A81268476645C4E5F03428B8AC3AA7B",
      fields = NULL,
      verbose = FALSE)
  )
  expect_type(result, "list")
  expect_length(result, 2)
})
