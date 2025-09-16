testthat::skip_on_cran()
testthat::skip_if_offline()
testthat::skip_on_ci()

# establish the connection to the SORMAS system
sormas_login <- login(
  type = "sormas",
  from = "https://demo.sormas.org/sormas-rest",
  user_name = "SurvSup",
  password = "Lk5R7JXeZSEc"
)

test_that("read_sormas works as expected", {
  covid_cases <- read_sormas(
    login = sormas_login,
    disease = "coronavirus"
  )
  expect_s3_class(covid_cases, "data.frame")
  expect_true(all(
    names(covid_cases) %in% c("case_id", "person_id", "sex", "date_of_birth",
                              "case_origin", "country", "city", "latitude",
                              "longitude", "case_status", "date_onset",
                              "date_admission", "outcome", "date_outcome",
                              "contact_id", "date_last_contact",
                              "date_first_contact", "Ct_values")
  ))

  covid_cases <- read_sormas(
    login = sormas_login,
    disease = "coronavirus",
    since = as.Date("2025-06-01")
  )
  expect_s3_class(covid_cases, "data.frame")
  expect_true(all(
    names(covid_cases) %in% c("case_id", "person_id", "sex", "date_of_birth",
                              "case_origin", "country", "city", "latitude",
                              "longitude", "case_status", "date_onset",
                              "date_admission", "outcome", "date_outcome",
                              "contact_id", "date_last_contact",
                              "date_first_contact", "Ct_values")
  ))
})


test_that("read_sormas fails as expected", {
  # test that it fails when 'since' is incorrect
  expect_error(
    read_sormas(
      login = sormas_login,
      disease = "coronavirus",
      since = "25/08/2025"
    ),
    regexp = cat("Incorrect value for since argument!")
  )

  # test that it fails when 'disease' is incorrect
  expect_error(
    read_sormas(
      login = sormas_login,
      disease = "covid19",
      since = 0
    ),
    regexp = cat("Incorrect disease name supplied!")
  )

  # test that it throws a warning when one 'disease' names is incorrect
  expect_message(
    read_sormas(
      login = sormas_login,
      disease = c("coronavirus", "fake-disease"),
      since = 0
    ),
    regexp = cat(
    "`fake-disease` not found in disease list. Please use",
    "`sormas_get_diseases()` function to see the full list of disease names."
    )
  )
})
