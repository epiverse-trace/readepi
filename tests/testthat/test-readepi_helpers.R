test_that("read_credentials works as expected", {
  res <- read_credentials(
    file_path  = system.file("extdata", "test.ini", package = "readepi"),
    url        = "mysql-rfam-public.ebi.ac.uk"
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

test_that("get_read_file_args works as expected", {
  res <- get_read_file_args(
    list(
      sep = "\t",
      format = ".txt",
      which = NULL
    )
  )
  expect_type(res, "list")
  expect_length(res, 4L)
  expect_named(res, c("sep", "format", "which", "pattern"))
  expect_identical(res[["sep"]], "\t")
  expect_identical(res[["format"]], ".txt")
  expect_null(res[["which"]])
  expect_null(res[["pattern"]])
})

test_that("get_read_fingertips_args works as expected", {
  res <- get_read_fingertips_args(
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

test_that("get_read_fingertips_args works as expected with all arguments", {
  res <- get_read_fingertips_args(
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

test_that("get_read_fingertips_args works as expected", {
  res <- get_read_fingertips_args(
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

test_that("get_read_fingertips_args works as expected", {
  res <- get_read_fingertips_args(
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
