## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(readepi)

## ----eval=FALSE---------------------------------------------------------------
#  file = system.file("extdata", "test.json", package = "readepi")
#  data = readepi(file.path = file)

## ----eval=FALSE---------------------------------------------------------------
#  file = system.file("extdata", "test.xlsx", package = "readepi")
#  data = readepi(file.path = file, which = "Sheet2")

## ----eval=FALSE---------------------------------------------------------------
#  # reading all files in the given directory
#  dir.path = "inst/extdata"
#  data = readepi(file.path = dir.path)
#  
#  # reading only txt files
#  data = readepi(file.path = dir.path, pattern = "txt")

## ----eval=FALSE---------------------------------------------------------------
#  # display the structure of the credentials file
#  show_example_file()
#  credentials.file = system.file("extdata", "test.ini", package = "readepi")
#  
#  # reading all fields and records the project
#  data = readepi(credentials.file, project.id="Pats__Covid_19_Cohort_1_Screening")
#  project.data = data$data
#  project.metadeta = data$metadata
#  
#  # reading specified fields and all records from the project
#  fields = c("day_1_q_ran_id","redcap_event_name","day_1_q_1a","day_1_q_1b","day_1_q_1c","day_1_q_1","day_1_q_2","day_1_q_3","day_1_q_4","day_1_q_5")
#  data = readepi(credentials.file, project.id="Pats__Covid_19_Cohort_1_Screening", fields = fields)
#  
#  # reading specified records and all fields from the project
#  records = c("C10001/3","C10002/1","C10003/7","C10004/5","C10005/9","C10006/8","C10007/6","C10008/4","C10009/2","C10010/1")
#  data = readepi(credentials.file, project.id="Pats__Covid_19_Cohort_1_Screening", records =  records)
#  
#  # reading specified records and fields from the project
#  data = readepi(credentials.file, project.id="Pats__Covid_19_Cohort_1_Screening", records =  records, fields = fields)

## ----eval=FALSE---------------------------------------------------------------
#  showTables(credentials.file=system.file("extdata", "test.ini", package = "readepi"), project.id="IBS_BHDSS", driver.name="ODBC Driver 17 for SQL Server")

## ----eval=FALSE---------------------------------------------------------------
#  # reading all fields and all records from one table (`dss_events`)
#  data = readepi(credentials.file, project.id="IBS_BHDSS", driver.name = "ODBC Driver 17 for SQL Server", table.name = "dss_events")
#  
#  # reading specified fields and all records from one table
#  data = readepi(credentials.file, project.id="IBS_BHDSS", driver.name = "ODBC Driver 17 for SQL Server", table.name = "dss_events", fields = fields)
#  
#  # reading specified records and all fields from one table
#  data = readepi(credentials.file, project.id="IBS_BHDSS", driver.name = "ODBC Driver 17 for SQL Server", table.name = "dss_events", records = records)
#  
#  # reading specified fields and records one the table
#  data = readepi(credentials.file, project.id="IBS_BHDSS", driver.name = "ODBC Driver 17 for SQL Server", table.name = "dss_events", records = records, fields = fields)
#  
#  # reading data from several tables
#  table.names = "accounts,account_books,account_currencies" #can also be table.names = c("account"s,"account_books","account_currencies")
#  data = readepi(credentials.file, project.id="IBS_BHDSS", driver.name = "ODBC Driver 17 for SQL Server", table.name = table.names)
#  
#  # reading data from several tables and subsetting fields across tables
#  table.names = "accounts,account_books,account_currencies" #can also be table.names = c("account"s,"account_books","account_currencies")
#  #note that first string in the field vector corresponds to names to be subset from the first table specified in the `table.name` argument
#  fields = c("id,name,balance,created_by", "id,status,name", "id,name")
#  data = readepi(credentials.file, project.id="IBS_BHDSS", driver.name = "ODBC Driver 17 for SQL Server", table.name = table.names, fields = fields)
#  
#  # reading data from several tables and subsetting records across tables
#  #note that first string in the records vector corresponds to the subject ID to be subset from the first table specified in the `table.name` argument and so on... When the ID column is not the first column in a table, use the `id.position`
#  records = c("3,8,13", "1,2,3", "1")
#  data = readepi(credentials.file, project.id="IBS_BHDSS", driver.name = "ODBC Driver 17 for SQL Server", table.name = table.names, records = records)
#  
#  # reading data from several tables and subsetting records and fields across tables
#  fields = c("id,name,balance,created_by", "id,status,name", "id,name")
#  records = c("3,8,13", "1,2,3", "1")
#  data = readepi(credentials.file, project.id="IBS_BHDSS", driver.name = "ODBC Driver 17 for SQL Server", table.name = table.names, records = records, fields = fields)

