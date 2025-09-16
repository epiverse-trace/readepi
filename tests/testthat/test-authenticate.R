testthat::skip_on_cran()
testthat::skip_if_offline()
testthat::skip_on_ci()

test_that("login works as expected when connecting to a MySQL server", {
  rdbms_login <- login(
    from = "mysql-rfam-public.ebi.ac.uk",
    type = "mysql",
    user_name = "rfamro",
    password = "",
    driver_name = "",
    db_name = "Rfam",
    port = 4497
  )
  expect_true(inherits(rdbms_login, c("Pool", "R6")))
  credentials <- attr(rdbms_login, "credentials")
  expect_type(credentials, "list")
  expect_true(all(
    names(credentials) %in% c("user", "password", "host", "db_name", "driver",
                              "port", "type")
  ))
})

test_that("login fails with a wrong URL", {
  expect_error(
    login(
      from = "fake-url",
      type = "mysql",
      user_name = "rfamro",
      password = "",
      driver_name = "",
      db_name = "Rfam",
      port = 4497
    ),
    regexp = cat("Incorrect domain name in the provided URL!")
  )

  expect_error(
    login(
      from = c("mysql-rfam-public.ebi.ac.uk", "fake-url"),
      type = "mysql",
      user_name = "rfamro",
      password = "",
      driver_name = "",
      db_name = "Rfam",
      port = 4497
    ),
    regexp = cat("Assertion on',from,'failed: only one URL should be provided at
                 a time.")
  )
})


test_that("login works as expected when connecting to DHIS2", {
  dhis2_login <- login(
    type = "dhis2",
    from = "https://smc.moh.gm/dhis",
    user_name = "test",
    password = "Gambia@123"
  )
  expect_true(inherits(dhis2_login, "httr2_response"))
  expect_identical(dhis2_login$status_code, 200L)
})

test_that("login fails with a wrong URL for DHIS2", {
  expect_error(
    login(
      type = "dhis2",
      from = "fake-url",
      user_name = "test",
      password = "Gambia@123"
    ),
    regexp = cat("Incorrect domain name in the provided URL!")
  )
})

test_that("login fails if username is not provided", {
  expect_error(
    login(
      type = "dhis2",
      from = "https://smc.moh.gm/dhis",
      user_name = NULL,
      password = "Gambia@123"
    ),
    regexp = cat("Assertion on',user_name,'failed: user_name must be provided.")
  )
})

test_that("login works as expected when connecting to SORMAS", {
  sormas_login <- login(
    type = "sormas",
    from = "https://demo.sormas.org/sormas-rest",
    user_name = "SurvSup",
    password = "Lk5R7JXeZSEc"
  )
  expect_true(inherits(sormas_login, "list"))
  expect_identical(names(sormas_login), c("base_url", "user_name", "password"))
})
