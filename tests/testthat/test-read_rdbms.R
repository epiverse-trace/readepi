testthat::skip_on_cran()
testthat::skip_if_offline()
testthat::skip_on_ci()

# authenticate the user
rdbms_login <- login(
  from = "mysql-rfam-public.ebi.ac.uk",
  type = "mysql",
  user_name = "rfamro",
  password = "",
  driver_name = "",
  db_name = "Rfam",
  port = 4497
)

test_that("read_rdbms works as expected", {
  # read data from a table where the name is specified in a list of query
  # parameters
  authors_list <- read_rdbms(
    login = rdbms_login,
    query = list(table = "author", select = NULL, filter = NULL)
  )
  expect_s3_class(authors_list, "data.frame")
  expect_identical(dim(authors_list), c(131L, 6L))
  expect_named(authors_list, c("author_id", "name", "last_name", "initials",
                               "orcid", "synonyms"))

  # read data using query parameters within an SQL query
  authors_list <- read_rdbms(
    login = rdbms_login,
    query = "select * from author"
  )
  expect_s3_class(authors_list, "data.frame")
  expect_identical(dim(authors_list), c(131L, 6L))
  expect_named(authors_list, c("author_id", "name", "last_name", "initials",
                               "orcid", "synonyms"))

  # subset a few columns from the table
  dat <- read_rdbms(
    login = rdbms_login,
    query = "select author_id, name, last_name from author"
  )
  expect_s3_class(dat, "data.frame")
  expect_identical(dim(dat), c(131L, 3L))
  expect_named(dat, c("author_id", "name", "last_name"))
})
