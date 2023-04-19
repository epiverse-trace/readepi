test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "http://172.23.33.99/redcap_v13.4.8/API/",
    token = "7C9E783877D94E0C1E67B662054CD253",
    id.position = 1,
    id.col.name = NULL,
    records = NULL,
    fields = NULL
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "http://172.23.33.99/redcap_v13.4.8/API/",
    token = "7C9E783877D94E0C1E67B662054CD253",
    id.position = NULL,
    id.col.name = "id",
    records = NULL,
    fields = NULL
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "http://172.23.33.99/redcap_v13.4.8/API/",
    token = "7C9E783877D94E0C1E67B662054CD253",
    id.position = 1,
    id.col.name = NULL,
    fields = c("id", "age", "sex"),
    records = c("SK_1", "SK_2", "SK_3", "SK_97", "SK_98", "SK_99")
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "http://172.23.33.99/redcap_v13.4.8/API/",
    token = "7C9E783877D94E0C1E67B662054CD253",
    id.position = NULL,
    id.col.name = "id",
    fields = c("id", "age", "sex"),
    records = c("SK_1", "SK_2", "SK_3", "SK_97", "SK_98", "SK_99")
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "http://172.23.33.99/redcap_v13.4.8/API/",
    token = "7C9E783877D94E0C1E67B662054CD253",
    id.position = 1,
    id.col.name = NULL,
    fields = "id,age,sex",
    records = "SK_1,SK_2,SK_3,SK_97,SK_98,SK_99"
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "http://172.23.33.99/redcap_v13.4.8/API/",
    token = "7C9E783877D94E0C1E67B662054CD253",
    id.position = NULL,
    id.col.name = "id",
    fields = "id,age,sex",
    records = "SK_1,SK_2,SK_3,SK_97,SK_98,SK_99"
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "http://172.23.33.99/redcap_v13.4.8/API/",
    token = "7C9E783877D94E0C1E67B662054CD253",
    id.position = 1,
    id.col.name = NULL,
    fields = NULL,
    records = "SK_1,SK_2,SK_3,SK_97,SK_98,SK_99"
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "http://172.23.33.99/redcap_v13.4.8/API/",
    token = "7C9E783877D94E0C1E67B662054CD253",
    id.position = NULL,
    id.col.name = "id",
    fields = NULL,
    records = "SK_1,SK_2,SK_3,SK_97,SK_98,SK_99"
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "http://172.23.33.99/redcap_v13.4.8/API/",
    token = "7C9E783877D94E0C1E67B662054CD253",
    id.position = 1,
    id.col.name = NULL,
    fields = "id, sex, age",
    records = NULL
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "http://172.23.33.99/redcap_v13.4.8/API/",
    token = "7C9E783877D94E0C1E67B662054CD253",
    id.position = NULL,
    id.col.name = "id",
    fields = "id, age, sex",
    records = NULL
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "http://172.23.33.99/redcap_v13.4.8/API/",
    token = "7C9E783877D94E0C1E67B662054CD253",
    id.position = 1,
    id.col.name = NULL,
    fields = NULL,
    records = c("SK_1","SK_2","SK_3","SK_97","SK_98","SK_99")
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "http://172.23.33.99/redcap_v13.4.8/API/",
    token = "7C9E783877D94E0C1E67B662054CD253",
    id.position = NULL,
    id.col.name = "id",
    fields = NULL,
    records = c("SK_1","SK_2","SK_3","SK_97","SK_98","SK_99")
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "http://172.23.33.99/redcap_v13.4.8/API/",
    token = "7C9E783877D94E0C1E67B662054CD253",
    id.position = 1,
    id.col.name = NULL,
    fields = c("id", "age", "sex"),
    records = NULL
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(
    uri = "http://172.23.33.99/redcap_v13.4.8/API/",
    token = "7C9E783877D94E0C1E67B662054CD253",
    id.position = NULL,
    id.col.name = "id",
    fields = c("id", "age", "sex"),
    records = NULL
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap fails as expected", {
  expect_error(
    read_from_redcap(
      uri = "http://172.23.33.99/redcap_v13.4.8/API/",
      token = "7C9E783877D94E0C1E67B662054CD253",
      id.position = "1",
      id.col.name = NULL,
      fields = c("id", "age", "sex"),
      records = NULL
    ),
    regexp = cat("Assertion on',id.position,'failed: Must be of type 'numeric' not 'character'.")
  )

  expect_error(
    read_from_redcap(
      uri = "http://172.23.33.99/redcap_v13.4.8/API/",
      token = "7C9E783877D94E0C1E67B662054CD253",
      id.position = -1,
      id.col.name = NULL,
      fields = c("id", "age", "sex"),
      records = NULL
    ),
    regexp = cat("Assertion on',id.position,'failed: Must be >= 1.")
  )

  expect_error(
    read_from_redcap(
      uri = "http://172.23.33.99/redcap_v13.4.8/API/",
      token = 1234,
      id.position = 1,
      id.col.name = NULL,
      fields = c("id", "age", "sex"),
      records = NULL
    ),
    regexp = cat("Assertion on',token,'failed: Must be of type 'character' not 'number'")
  )

  expect_error(
    read_from_redcap(
      uri = "http://172.23.33.99/redcap_v13.4.8/API/",
      token = -1234,
      id.position = 1,
      id.col.name = NULL,
      fields = c("id", "age", "sex"),
      records = NULL
    ),
    regexp = cat("Assertion on',token,'failed: Must be of type 'character' not 'number'")
  )

  expect_error(
    read_from_redcap(
      uri = "http://172.23.33.99/redcap_v13.4.8/API/",
      token = c("7C9E783877D94E0C1E67B662054CD253", "7C9E783877D94E0C1E67B662054CD253"),
      id.position = 1,
      id.col.name = NULL,
      fields = c("id", "age", "sex"),
      records = NULL
    ),
    regexp = cat("Assertion on',token,'failed: Must be of type 'character' of length 1")
  )

  expect_error(
    read_from_redcap(
      uri = NULL,
      token = "7C9E783877D94E0C1E67B662054CD253",
      id.position = 1,
      id.col.name = NULL,
      fields = c("id", "age", "sex"),
      records = NULL
    ),
    regexp = cat("Assertion on',uri,'failed: Must be provided.")
  )

  expect_error(
    read_from_redcap(
      uri = c("http://172.23.33.99/redcap_v13.4.8/API/", "http://172.23.33.99/redcap_v13.4.8/API/"),
      token = "7C9E783877D94E0C1E67B662054CD253",
      id.position = 1,
      id.col.name = NULL,
      fields = c("id", "age", "sex"),
      records = NULL
    ),
    regexp = cat("Assertion on',uri,'failed: Must be of type 'character' of length 1")
  )
})
