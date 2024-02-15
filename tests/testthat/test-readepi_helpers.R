test_that("read_credentials works as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  res <- read_credentials(
    file_path = system.file("extdata", "test.ini", package = "readepi"),
    base_url  = "mysql-rfam-public.ebi.ac.uk"
  )
  expect_type(res, "list")
  expect_length(res, 6L)
  expect_named(res, c("user", "pwd", "host", "project", "dbms", "port"))
  expect_type(res[["user"]], "character")
  expect_identical(res[["user"]], "rfamro")
  expect_type(res[["pwd"]], "character")
  expect_identical(res[["pwd"]], "")
  expect_type(res[["host"]], "character")
  expect_identical(res[["host"]], "mysql-rfam-public.ebi.ac.uk")
  expect_type(res[["project"]], "character")
  expect_identical(res[["project"]], "Rfam")
  expect_type(res[["dbms"]], "character")
  expect_identical(res[["dbms"]], "MySQL")
  expect_type(res[["port"]], "integer")
  expect_identical(res[["port"]], 4497L)
})

test_that("read_credentials fails as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  expect_error(
    read_credentials(
      file_path = system.file("extdata", "fake_test.ini", package = "readepi"),
      base_url  = "mysql-rfam-public.ebi.ac.uk"
    ),
    regexp = cat("The credential file is expected to have 7 columns.")
  )

  expect_error(
    read_credentials(
      file_path = system.file("extdata", "bad_column_name.ini",
                              package = "readepi"),
      base_url  = "mysql-rfam-public.ebi.ac.uk"
    ),
    regexp = cat("Unexpected column name(s) in the provided credential file.
                 The expected column names are: 'user_name', 'password',
                 'host_name', 'project_id', 'comment', 'dbms', 'port'")
  )

  expect_error(
    read_credentials(
      file_path = system.file("extdata", "bad_url.ini", package = "readepi"),
      base_url  = "mysql-rfam-public.ebi.ac.uk"
    ),
    regexp = cat("No user credential file found for the specified URL.")
  )

  expect_error(
    read_credentials(
      file_path = system.file("extdata", "multiple_urls.ini",
                              package = "readepi"),
      base_url  = "mysql-rfam-public.ebi.ac.uk"
    ),
    regexp = cat("Found multiple credentials for the specified URL.")
  )
})

test_that("fingertips_get_args works as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  res <- fingertips_get_args(
    list(
      indicator_id = 90362L,
      area_type_id = 202L
    )
  )
  expect_type(res, "list")
  expect_length(res, 8L)
  expect_named(res, c(
    "indicator_id", "indicator_name", "area_type_id",
    "profile_id", "profile_name", "domain_id", "domain_name",
    "parent_area_type_id"
  ))
  expect_identical(res[["indicator_id"]], 90362L)
  expect_identical(res[["area_type_id"]], 202L)
  expect_null(res[["indicator_name"]])
  expect_null(res[["profile_id"]])
  expect_null(res[["profile_name"]])
  expect_null(res[["domain_id"]])
  expect_null(res[["domain_name"]])
  expect_null(res[["parent_area_type_id"]])
})

test_that("fingertips_get_args works as expected with all arguments", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  res <- fingertips_get_args(
    list(
      indicator_id   = 90362L,
      area_type_id   = 202L,
      indicator_name = "Healthy life expectancy at birth",
      domain_id      = 1000049L,
      domain_name    = "A. Overarching indicators",
      profile_id     = 19L,
      profile_name   = "Public Health Outcomes Framework"
    )
  )
  expect_type(res, "list")
  expect_length(res, 8L)
  expect_named(res, c(
    "indicator_id", "indicator_name", "area_type_id",
    "profile_id", "profile_name", "domain_id", "domain_name",
    "parent_area_type_id"
  ))
  expect_identical(res[["indicator_id"]], 90362L)
  expect_identical(res[["area_type_id"]], 202L)
  expect_identical(res[["indicator_name"]], "Healthy life expectancy at birth")
  expect_identical(res[["profile_id"]], 19L)
  expect_identical(res[["profile_name"]], "Public Health Outcomes Framework")
  expect_identical(res[["domain_id"]], 1000049L)
  expect_identical(res[["domain_name"]], "A. Overarching indicators")
  expect_null(res[["parent_area_type_id"]])
})

test_that("fingertips_get_args works as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  res <- fingertips_get_args(
    list(
      indicator_id   = 90362L,
      area_type_id   = 202L,
      indicator_name = "Healthy life expectancy at birth"
    )
  )
  expect_type(res, "list")
  expect_length(res, 8L)
  expect_named(res, c(
    "indicator_id", "indicator_name", "area_type_id",
    "profile_id", "profile_name", "domain_id", "domain_name",
    "parent_area_type_id"
  ))
  expect_identical(res[["indicator_id"]], 90362L)
  expect_identical(res[["area_type_id"]], 202L)
  expect_identical(res[["indicator_name"]], "Healthy life expectancy at birth")
  expect_null(res[["profile_id"]])
  expect_null(res[["profile_name"]])
  expect_null(res[["domain_id"]])
  expect_null(res[["domain_name"]])
  expect_null(res[["parent_area_type_id"]])
})

test_that("fingertips_get_args works as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  res <- fingertips_get_args(
    list(
      indicator_id   = 90362L,
      area_type_id   = 202L,
      indicator_name = "Healthy life expectancy at birth",
      profile_id     = 19L
    )
  )
  expect_type(res, "list")
  expect_length(res, 8L)
  expect_named(res, c(
    "indicator_id", "indicator_name", "area_type_id",
    "profile_id", "profile_name", "domain_id", "domain_name",
    "parent_area_type_id"
  ))
  expect_identical(res[["indicator_id"]], 90362L)
  expect_identical(res[["area_type_id"]], 202L)
  expect_identical(res[["indicator_name"]], "Healthy life expectancy at birth")
  expect_identical(res[["profile_id"]], 19L)
  expect_null(res[["profile_name"]])
  expect_null(res[["domain_id"]])
  expect_null(res[["domain_name"]])
  expect_null(res[["parent_area_type_id"]])
})

test_that("fingertips_get_args fails as expected", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  res <- fingertips_get_args(
    list(
      indicator_id   = 90362L,
      area_type_id   = NULL,
      indicator_name = "Healthy life expectancy at birth",
      domain_id      = 1000049L,
      domain_name    = "A. Overarching indicators",
      profile_id     = 19L,
      profile_name   = "Public Health Outcomes Framework"
    )
  )
  expect_null(res[["area_type_id"]])

  res <- fingertips_get_args(
    list(
      indicator_id        = 90362L,
      area_type_id        = NULL,
      parent_area_type_id = 6L
    )
  )
  expect_identical(res[["parent_area_type_id"]], 6L)
})


test_that("url_check works as expected", {
  res <- url_check(base_url = "https://www.karim.sn")
  expect_true(res)
})

test_that("url_check works as expected", {
  res <- url_check(base_url = "stackoverflow.com")
  expect_true(res)
})

test_that("url_check works as expected", {
  res <- url_check(base_url = "stackoverflow.com/questions/ask")
  expect_true(res)
})

test_that("url_check works as expected", {
  res <- url_check(base_url = "https://stackoverflow.com/questions/ask")
  expect_true(res)
})

test_that("url_check works as expected", {
  res <- url_check(base_url = "http://www.amazon.com/Computers-Internet-Books/b/ref=bhp_bb0309A_comint2?ie=UTF8&node=5&pf_rd_m=ATVPDKIKX0DER&pf_rd_s=browse&pf_rd_r=0AH7GM29WF81Q72VPFDH&pf_rd_t=101&pf_rd_p=1273387142&pf_rd_i=283155") # nolint: line_length_linter
  expect_true(res)
})

test_that("url_check fails as expected", {
  expect_error(
    url_check("google"),
    regexp = cat("URL must be in the form of 'https://test.com' or
                 'https://www.test.com' or 'test.com'.")
  )
  expect_error(
    url_check("http://www"),
    regexp = cat("URL must be in the form of 'https://test.com' or
                 'https://www.test.com' or 'test.com'.")
  )
  expect_error(
    url_check("http://www..des"),
    regexp = cat("URL must be in the form of 'https://test.com' or
                 'https://www.test.com' or 'test.com'.")
  )
})
