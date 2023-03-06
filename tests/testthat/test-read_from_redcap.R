test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(uri = "https://redcap.mrc.gm:8443/redcap/api/",
                          token = "9D71857D60F4016AB7BFFDA65970D737",
                          id.position = 1,
                          records = NULL,
                          fields = NULL)
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(uri = "https://redcap.mrc.gm:8443/redcap/api/",
                          token = "9D71857D60F4016AB7BFFDA65970D737",
                          id.position = 1,
                          fields = c("day_1_q_ran_id","redcap_event_name","day_1_q_1a"),
                          records = c("C10001/3", "C10002/1", "C10003/7")
                          )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(uri = "https://redcap.mrc.gm:8443/redcap/api/",
                          token = "9D71857D60F4016AB7BFFDA65970D737",
                          id.position = 1,
                          fields = "day_1_q_ran_id,redcap_event_name,day_1_q_1a",
                          records = "C10001/3,C10002/1,C10003/7"
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(uri = "https://redcap.mrc.gm:8443/redcap/api/",
                          token = "9D71857D60F4016AB7BFFDA65970D737",
                          id.position = 1,
                          fields = NULL,
                          records = "C10001/3,C10002/1,C10003/7"
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(uri = "https://redcap.mrc.gm:8443/redcap/api/",
                          token = "9D71857D60F4016AB7BFFDA65970D737",
                          id.position = 1,
                          fields = "day_1_q_ran_id,redcap_event_name,day_1_q_1a",
                          records = NULL
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(uri = "https://redcap.mrc.gm:8443/redcap/api/",
                          token = "9D71857D60F4016AB7BFFDA65970D737",
                          id.position = 1,
                          fields = NULL,
                          records = c("C10001/3", "C10002/1", "C10003/7")
  )
  expect_type(res, "list")
  expect_length(res, 2)
  expect_named(res, c("data", "metadata"))
  expect_s3_class(res$data, class = "data.frame")
  expect_s3_class(res$metadata, class = "data.frame")
})

test_that("read_from_redcap works with valid input", {
  res <- read_from_redcap(uri = "https://redcap.mrc.gm:8443/redcap/api/",
                          token = "9D71857D60F4016AB7BFFDA65970D737",
                          id.position = 1,
                          fields = c("day_1_q_ran_id","redcap_event_name","day_1_q_1a"),
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
    read_from_redcap(uri = "https://redcap.mrc.gm:8443/redcap/api/",
                     token = "9D71857D60F4016AB7BFFDA65970D737",
                     id.position = "1",
                     fields = c("day_1_q_ran_id","redcap_event_name","day_1_q_1a"),
                     records = NULL),
    regexp = cat("Assertion on',id.position,'failed: Must be of type 'numeric' not 'character'.")
    )

  expect_error(
    read_from_redcap(uri = "https://redcap.mrc.gm:8443/redcap/api/",
                     token = "9D71857D60F4016AB7BFFDA65970D737",
                     id.position = -1,
                     fields = c("day_1_q_ran_id","redcap_event_name","day_1_q_1a"),
                     records = NULL),
    regexp = cat("Assertion on',id.position,'failed: Must be >= 1.")
  )

  expect_error(
    read_from_redcap(uri = "https://redcap.mrc.gm:8443/redcap/api/",
                     token = 1234,
                     id.position = 1,
                     fields = c("day_1_q_ran_id","redcap_event_name","day_1_q_1a"),
                     records = NULL),
    regexp = cat("Assertion on',token,'failed: Must be of type 'character' not 'number'")
  )

  expect_error(
    read_from_redcap(uri = "https://redcap.mrc.gm:8443/redcap/api/",
                     token = -1234,
                     id.position = 1,
                     fields = c("day_1_q_ran_id","redcap_event_name","day_1_q_1a"),
                     records = NULL),
    regexp = cat("Assertion on',token,'failed: Must be of type 'character' not 'number'")
  )

  expect_error(
    read_from_redcap(uri = "https://redcap.mrc.gm:8443/redcap/api/",
                     token = c("9D71857D60F4016AB7BFFDA65970D737","9D71857D60F4016AB7BFFDA65970D737"),
                     id.position = 1,
                     fields = c("day_1_q_ran_id","redcap_event_name","day_1_q_1a"),
                     records = NULL),
    regexp = cat("Assertion on',token,'failed: Must be of type 'character' of length 1")
  )

  expect_error(
    read_from_redcap(uri = 123.00,
                     token = "9D71857D60F4016AB7BFFDA65970D737",
                     id.position = 1,
                     fields = c("day_1_q_ran_id","redcap_event_name","day_1_q_1a"),
                     records = NULL),
    regexp = cat("Assertion on',uri,'failed: Must be of type 'character' not 'number'")
  )

  expect_error(
    read_from_redcap(uri = -123.00,
                     token = "9D71857D60F4016AB7BFFDA65970D737",
                     id.position = 1,
                     fields = c("day_1_q_ran_id","redcap_event_name","day_1_q_1a"),
                     records = NULL),
    regexp = cat("Assertion on',uri,'failed: Must be of type 'character' not 'number'")
  )

  expect_error(
    read_from_redcap(uri = c("https://redcap.mrc.gm:8443/redcap/api/","https://redcap.mrc.gm:8443/redcap/api/"),
                     token = "9D71857D60F4016AB7BFFDA65970D737",
                     id.position = 1,
                     fields = c("day_1_q_ran_id","redcap_event_name","day_1_q_1a"),
                     records = NULL),
    regexp = cat("Assertion on',uri,'failed: Must be of type 'character' of length 1")
  )
})
