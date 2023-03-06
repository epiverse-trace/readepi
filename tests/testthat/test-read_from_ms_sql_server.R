test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(user="kmane",
                                 password="Dakabantang@KD23",
                                 host="robin.mrc.gm",
                                 port=1433,
                                 database.name="IBS_BHDSS",
                                 driver.name="ODBC Driver 17 for SQL Server",
                                 table.names="dss_events",
                                 records = "1,2,3,5,8",
                                 fields = "id,data_entry_date start_date,status",
                                 id.position = 1
                                 )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server works with valid input", {
  res <- read_from_ms_sql_server(user="kmane",
                                 password="Dakabantang@KD23",
                                 host="robin.mrc.gm",
                                 port=1433,
                                 database.name="IBS_BHDSS",
                                 driver.name="ODBC Driver 17 for SQL Server",
                                 table.names="dss_events",
                                 records = c('1','2','3','5','8'),
                                 fields = c("id","data_entry_date","start_date","status"),
                                 id.position = 1
  )
  expect_type(res, "list")
})

test_that("read_from_ms_sql_server fails as expected", {
  expect_error(
    read_from_ms_sql_server(user="kmane",
                            password="Dakabantang@KD23",
                            host="robin.mrc.gm",
                            port="1433",
                            database.name="IBS_BHDSS",
                            driver.name="ODBC Driver 17 for SQL Server",
                            table.names="dss_events",
                            records = "1,2,3,5,8",
                            fields = "id,data_entry_date start_date,status",
                            id.position = 1),
    regexp = cat("Assertion on',port,'failed: Must be of type 'numeric', not 'character'."))

  expect_error(
    read_from_ms_sql_server(user="kmane",
                         password="Dakabantang@KD23",
                         host="robin.mrc.gm",
                         port=1433,
                         database.name="IBS_BHDSS",
                         driver.name="ODBC Driver 17 for SQL Server",
                         table.names="dss_events",
                         records = "1,2,3,5,8",
                         fields = "id,data_entry_date start_date,status",
                         id.position = "1"),
    regexp = cat("Assertion on',id.position,'failed: Must be of type 'numeric' not 'character'.")
  )

  expect_error(
    read_from_ms_sql_server(user="kmane",
                            password="Dakabantang@KD23",
                            host="robin.mrc.gm",
                            port=-1433,
                            database.name="IBS_BHDSS",
                            driver.name="ODBC Driver 17 for SQL Server",
                            table.names="dss_events",
                            records = "1,2,3,5,8",
                            fields = "id,data_entry_date start_date,status",
                            id.position = 1),
    regexp = cat("Assertion on',port,'failed: Negative port not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(user="kmane",
                            password="Dakabantang@KD23",
                            host="robin.mrc.gm",
                            port=1433,
                            database.name="IBS_BHDSS",
                            driver.name="ODBC Driver 17 for SQL Server",
                            table.names="dss_events",
                            records = "1,2,3,5,8",
                            fields = "id,data_entry_date start_date,status",
                            id.position = -1),
    regexp = cat("Assertion on',id.position,'failed: Negative column number not allowed.")
  )

  expect_error(
    read_from_ms_sql_server(user=NULL,
                            password="Dakabantang@KD23",
                            host="robin.mrc.gm",
                            port=1433,
                            database.name="IBS_BHDSS",
                            driver.name="ODBC Driver 17 for SQL Server",
                            table.names="dss_events",
                            records = NULL,
                            fields = NULL,
                            id.position = 1),
    regexp = cat("Assertion on',user,'failed: Must provide user name.")
  )

  expect_error(
    read_from_ms_sql_server(user="kmane",
                            password=NULL,
                            host="robin.mrc.gm",
                            port=1433,
                            database.name="IBS_BHDSS",
                            driver.name="ODBC Driver 17 for SQL Server",
                            table.names="dss_events",
                            records = NULL,
                            fields = NULL,
                            id.position = 1),
    regexp = cat("Assertion on',password,'failed: Must provide user's password.")
  )

  expect_error(
    read_from_ms_sql_server(user="kmane",
                            password="Dakabantang@KD23",
                            host=NULL,
                            port=1433,
                            database.name="IBS_BHDSS",
                            driver.name="ODBC Driver 17 for SQL Server",
                            table.names="dss_events",
                            records = NULL,
                            fields = NULL,
                            id.position = 1),
    regexp = cat("Assertion on',host,'failed: Must provide host name.")
  )

  expect_error(
    read_from_ms_sql_server(user="kmane",
                            password="Dakabantang@KD23",
                            host="robin.mrc.gm",
                            port=NULL,
                            database.name="IBS_BHDSS",
                            driver.name="ODBC Driver 17 for SQL Server",
                            table.names="dss_events",
                            records = NULL,
                            fields = NULL,
                            id.position = 1),
    regexp = cat("Assertion on',host,'failed: Must provide the port ID.")
  )

  expect_error(
    read_from_ms_sql_server(user="kmane",
                            password="Dakabantang@KD23",
                            host="robin.mrc.gm",
                            port=1433,
                            database.name=NULL,
                            driver.name="ODBC Driver 17 for SQL Server",
                            table.names="dss_events",
                            records = NULL,
                            fields = NULL,
                            id.position = 1),
    regexp = cat("Assertion on',database.name,'failed: Must provide the database name.")
  )

  expect_error(
    read_from_ms_sql_server(user="kmane",
                            password="Dakabantang@KD23",
                            host="robin.mrc.gm",
                            port=1433,
                            database.name="IBS_BHDSS",
                            driver.name=NULL,
                            table.names="dss_events",
                            records = NULL,
                            fields = NULL,
                            id.position = 1),
    regexp = cat("Assertion on',driver.name,'failed: Must provide the driver name.")
  )

  # expect_error(
  #   read_from_ms_sql_server(user="kmane",
  #                           password="Dakabantang@KD23",
  #                           host="robin.mrc.gm",
  #                           port=1433,
  #                           database.name="IBS_BHDSS",
  #                           driver.name="ODBC Driver 17 for SQL Server",
  #                           table.names=NULL,
  #                           records = NULL,
  #                           fields = NULL,
  #                           id.position = 1),
  #   regexp = cat("Assertion on',driver.name,'failed: Must provide the table name.")
  # )

  expect_error(
    read_from_ms_sql_server(user="kmane",
                            password="Dakabantang@KD23",
                            host="robin.mrc.gm",
                            port=1433,
                            database.name="IBS_BHDSS",
                            driver.name="ODBC Driver 17 for SQL Server",
                            table.names="dss_events",
                            records = NULL,
                            fields = NULL,
                            id.position = NULL),
    regexp = cat("Assertion on',driver.name,'failed: Must provide the index position of the column to use for subsetting.")
  )
})
