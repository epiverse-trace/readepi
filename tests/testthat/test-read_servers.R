test_that("read_server works as expected with a list of query parameters", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()

  # authenticate the user
  conn <- authenticate(
    from          = "mysql-rfam-public.ebi.ac.uk",
    type          = "MySQL",
    user_name     = "rfamro",
    password      = "",
    driver_name   = "",
    db_name       = "Rfam",
    port          = 4497
  )

  # read data from a table where the name is specified in a list of query
  # parameters
  authors_list <- read_server(
    conn  = conn,
    query = list(table = "author", select = NULL, filter = NULL)
  )
  expect_s3_class(authors_list, "data.frame")
  expect_identical(dim(authors_list), c(119L, 6L))
  expect_named(authors_list, c("author_id", "name", "last_name", "initials",
                               "orcid", "synonyms"))
})

test_that("read_server works as expected with an SQL query", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()

  # authenticate the user
  conn <- authenticate(
    from          = "mysql-rfam-public.ebi.ac.uk",
    type          = "MySQL",
    user_name     = "rfamro",
    password      = "",
    driver_name   = "",
    db_name       = "Rfam",
    port          = 4497
  )

  # read data using query parameters within an SQL query
  authors_list <- read_server(
    conn  = conn,
    query = "select * from author"
  )
  expect_s3_class(authors_list, "data.frame")
  expect_identical(dim(authors_list), c(119L, 6L))
  expect_named(authors_list, c("author_id", "name", "last_name", "initials",
                               "orcid", "synonyms"))
})
