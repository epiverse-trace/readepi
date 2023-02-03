#' Example of a function to read stuff
#'
#' This function reads stuff into R. More details...
#'
#' @param x the path to the file to read stuff from
#'
#' @author Thibaut Jombart
#'
#' @export
#'
#' @examples
#' some_path <- "path to your file"
#' read_stuff(some_path)
read_stuff <- function(x) {
  # check inputs
  checkmate::assertCharacter(x, len = 1L)

  # do stuff
  x
}



#' function to read data from all supported file types in the `rio` package.
#' @param file.path the path to the file to be read. When several files need to be imported from a directory, this should be the path to that directory
#' @param sep the separator between the columns in the file. This is only required for space-separated files
#' @param format a string used to specify the file format. This is useful when a file does not have an extension, or has a file extension that does not match its actual type
#' @param which a string used to specify the name of the excel sheet to import
#' @param pattern when specified, only files with this suffix will be imported from the specified directory
#' @returns  a data frame (import from file) or a list (import several files from directory)
#' @examples data = read_from_file(file.path = system.file("extdata", "test.txt", package = "readepi"), sep=NULL, format=NULL, which=NULL, pattern=NULL)
#' @export
read_from_file = function(file.path, sep=NULL, format=NULL, which=NULL, pattern=NULL){
  # check if the file exists
  if(!file.exists(file.path) & !dir.exists(file.path)){
    stop(file.path, " No such file or directory!")
  }

  # reading data from file
  if(file.exists(file.path) & !dir.exists(file.path)){
    if(is.null(sep)){
      if(!is.null(which) & !is.null(format)) data = rio::import(file.path, format = format, which = which)
      else if(!is.null(which) & is.null(format)) data = rio::import(file.path, which = which)
      else if(!is.null(format) & is.null(which)) data = rio::import(file.path, format = format)
      else data = rio::import(file.path)
    }else if(!is.null(sep) & sep==" "){
      data = data.table::fread(file.path, sep = sep)
    }
  }

  # reading several files from a directory
  if(dir.exists(file.path) & length(list.files(file.path))>0){
    if(!is.null(pattern)) data = rio::import_list(list.files(file.path, full.names = TRUE, pattern = pattern))
    else data = rio::import_list(list.files(file.path, full.names = TRUE))
  }
  data
}

# read_from_file = function(file.path, sep=NULL, sheet.name=NULL){
#   # check if the file exists
#   if(!file.exists(file.path)){
#     stop(file.path, " not found!")
#   }

#   # reading the file
#   file.extension = getExtension(file.path)
#   if(file.extension %in% c("xlsx","xls")){
#     if(!is.null(sheet.name)) data = readxl::read_excel(file.path, sheet=sheet.name)
#     else data = readxl::read_excel(file.path)
#   }else if(file.extension %in% c("json","JSON")){
#     data = jsonlite::fromJSON(file.path, simplifyDataFrame=TRUE)
#   }else if(file.extension %in% c("xml","XML")){
#
#   }else{
#     if(!is.null(sep)) data = fread(file.path, sep = sep, nThread = 4)
#     else data = fread(file.path, nThread = 4)
#   }
# }

# function to return the file extension
getExtension = function(file.path){
  splits = unlist(strsplit(basename(file.path),".",fixed = TRUE))
  extension = splits[length(splits)]
  extension
}


#' function to subset fields
#' @param data.frame the input data frame
#' @param fields the list of columns of interest
#' @param table.name the table names
#' @examples data = subsetFields(data.frame=res, fields="id,name,balance,created_by", table.name="accounts")
#' @returns a list of 2 elements: the subset data frame and an integer that tells whether all fields were missing in the table (1) or not (0)
#' @importFrom magrittr %>%
#' @export
subsetFields = function(data.frame, fields, table.name){
  not.found = 0
  target.fields = as.character(unlist(strsplit(fields, ",")))
  idx = which(target.fields %in% names(data.frame))
  if(length(idx)==0){
    message("\nThere is no column named as: ",paste(target.fields, collapse = ", ")," in ",table.name)
    not.found=1
  }else if(length(idx) != length(target.fields)){
    message("\nThe following fields were not found in ",table.name,": ",paste(target.fields[-idx], collapse = ", "))
    target.fields = target.fields[idx]
    data = data.frame %>% dplyr::select(all_of(target.fields))
  }else{
    data = data.frame %>% dplyr::select(all_of(target.fields))
  }
  list(data=data, not_found=not.found)
}

#' function to subset records
#' @param data.frame the input data frame
#' @param records the list of columns of interest
#' @param id.position a vector of the column position of the variable that unique identifies the subjects. If not provided, it will assumes the first column as the subject ID column in all the tables
#' @param table.name the table name
#' @examples data = subsetRecords(data.frame, records, id.position=1, table.name)
#' @returns a list of 2 elements: the subset data frame and an integer that tells whether all fields were missing in the table (1) or not (0)
#' @importFrom magrittr %>%
#' @export
subsetRecords = function(data.frame, records, id.position=1, table.name){
  not.found = 0
  records = as.character(unlist(strsplit(records, ",")))
  id.column.name = names(data.frame)[id.position]
  if(is.numeric(data.frame[[id.column.name]])){
    records = as.numeric(records)
  }
  idx = which(records %in% data.frame[[id.column.name]])
  if(length(idx)==0){
    message("\nThere is no subject ID named as: ",paste(records, collapse = ", ")," in ",table.name)
    not.found=1
  }else if(length(idx) != length(records)){
    message("\nThe following records were not found in ",table.name,": ",paste(records[-idx], collapse = ", "))
    records = records[idx]
    data = data.frame %>% dplyr::filter(data.frame[[id.column.name]] %in% records)
  }else{
    data = data.frame %>% dplyr::filter(data.frame[[id.column.name]] %in% records)
  }

  list(data=data, not_found=not.found)
}


#' Function to display the list of tables in a database
#' @param credentials.file the path to the file with the user-specific credential details for the projects of interest. See the help of the `readepi` function for more details.
#' @param project.id the name of the target database
#' @param driver.name the name of the MS driver. use `odbc::odbcListDrivers()` to display the list of installed drivers
#' @examples  showTables(credentials.file=system.file("extdata", "test.ini", package = "readepi"), project.id="my_db", driver.name="ODBC Driver 17 for SQL Server")
#' @returns the list of tables in the specified database
#' @export
#'
showTables = function(credentials.file=NULL, project.id=NULL, driver.name=NULL){
  # reading the credentials from the credential file
  credentials = readCredentials(credentials.file, project.id)

  # establishing the connection to the server
  con = DBI::dbConnect(odbc::odbc(),
                       driver = driver.name,
                       server = credentials$host,
                       database = credentials$project,
                       uid = credentials$user,
                       pwd = credentials$pwd,
                       port = credentials$port)

  # listing the names of the tables present in the database
  tables = DBI::dbListTables(conn = con)
  print(tables)
}



#' function to read data from relational databases hosted by online MS SQL server. The user needs to have read access to the database et should install the appropriate MS driver that is compatible with the SQLServer version
#' @param user the user name
#' @param password the user password
#' @param host the name of the host server
#' @param port the port ID
#' @param database.name the name of the database that contains the table from which the data should be pulled
#' @param table.names a vector or a comma-separated list of table names from the project or database. When this is not specified, the function will extract data from all tables in the database.
#' @param driver.name the name of the MS driver. use `odbc::odbcListDrivers()` to display the list of installed drivers
#' @param records a vector or a comma-separated string of subset of subject IDs. When specified, only the records that correspond to these subjects will be imported.
#' @param fields a vector of strings where each string is a comma-separated list of column names. The element of this vector should be a list of column names from the first table specified in the `table.names` argument and so on...
#' @param id.position a vector of the column positions of the variable that unique identifies the subjects in each table. This should only be specified when the column with the subject IDs is not the first column. default is 1.
#' @returns a data frame
#' @examples data = read_from_ms_sql_server(user="kmane", password="****", host="robin.mrc.gm", port=1433, database.name="my_db", table.names="my_table", driver.name="ODBC Driver 17 for SQL Server")
#' @export
#' @importFrom magrittr %>%
read_from_ms_sql_server = function(user, password, host, port, database.name, driver.name, table.names=NULL, records=NULL, fields=NULL, id.position=1){
  # reading in user credentials
  # credentials = readMSsqlCredentials(credentials.file)

  # establishing the connection to the server
  con = DBI::dbConnect(odbc::odbc(),
                       driver = driver.name,
                       server = host,
                       database = database.name,
                       uid = user,
                       pwd = password,
                       port = as.numeric(port))

  # listing the names of the tables present in the database
  tables = DBI::dbListTables(conn = con)

  # checking if the specified table exists in the database
  if(!is.null(table.names)){
    if(is.character(table.names)){
      table.names = as.character(unlist(strsplit(table.names, ",")))
    }
    idx = which(table.names %in% tables)
    if(length(idx)==0){
      message("Could not found tables called ",paste(table.names, collapse = ", ")," in ",database.name,"!\n")
      cat("\nBelow is the list of all tables in the specified database:\n")
      print(tables)
      stop()
    }else if(length(idx) != length(table.names)){
      message("The following tables are not available in the database: ", paste(table.names[-idx], collapse = ", "))
    }
    table.names = table.names[idx]
  }else{
    warning("No table name was specified. Data from all tables will be fetched.")
    for(table in tables){
      cat("\nFetching data from",table)
      sql = DBI::dbSendQuery(con,paste0("select * from ",table))
      data[[table]] = DBI::dbFetch(sql, -1)
      DBI::dbClearResult(sql)
    }
  }


  # extract the data from the given tables and store the output in an R object
  # subsetting the columns
  data = list()
  if(!is.null(fields)){
    j=1
    not.found=0
    for(table in table.names){
      cat("\nFetching data from",table)
      sql = DBI::dbSendQuery(con,paste0("select * from ",table))
      res = DBI::dbFetch(sql, -1)
      DBI::dbClearResult(sql)
      if(!is.na(fields[j])){
        subset.data = subsetFields(res, fields[j], table)
        data[[table]] = subset.data$data
        not.found = not.found+subset.data$not_found
        j=j+1
      }else{
        data[[table]] = res
        j=j+1
      }
    }
    if(not.found == length(table.names)){
      stop("Specified fields not found in the tables of interest!")
    }
  }else{
    for(table in table.names){
      cat("\nFetching data from",table)
      sql = DBI::dbSendQuery(con,paste0("select * from ",table))
      data[[table]] = DBI::dbFetch(sql, -1)
      DBI::dbClearResult(sql)
    }
  }
  cat("\n")

  # subsetting the records
  if(!is.null(records)){
    j=1
    not.found=0
    for(table in names(data)){
      if(!is.na(records[j])){
        id.position = ifelse(!is.na(id.position[j]), id.position[j], id.position[1])
        res = subsetRecords(data[[table]], records[j], id.position, table)
        data[[table]] = res$data
        not.found = not.found+res$not_found
        j=j+1
      }
    }
  }
  cat("\n")
  if(not.found == length(table.names)){
    stop("Specified records not found in the tables of interest!")
  }

  # closing the connection
  DBI::dbDisconnect(conn = con)

  #return the dataset of interest
  data
}

#' function to read user credentials from file
readMSsqlCredentials = function(credentials.file){
  if(!file.exists(credentials.file)){
    stop("Could not find ",credentials.file)
  }
  credentials = data.table::fread(credentials.file, sep = "\t")
  if(ncol(credentials)!=4){
    stop("credential file should be tab-separated file with 4 columns.")
  }
  if(!all((names(credentials) %in% c('user_name', 'password', 'host_name', 'port')))){
    stop("Incorrect column names found in provided credentials file.\nThe column names should be 'user_name', 'password', 'host_name', 'port'")
  }
  list(user=credentials$user_name,
       pwd=credentials$password,
       host=credentials$host_name,
       port=credentials$port)
}

#' function to read data from REDCap
#' @param uri the URI of the server
#' @param token the user-specific string that serves as the password for a project
#' @param project.id the name of the project you want to import data from
#' @param id.position the column position of the variable that unique identifies the subjects. This should only be specified when the column with the subject IDs is not the first column. default is 1.
#' @param records a vector or a comma-separated string of subset of subject IDs. When specified, only the records that correspond to these subjects will be imported.
#' @param fields a vector or a comma-separated string of column names. If provided, only those columns will be imported.
#' @examples redcap.data = read_from_redcap(uri="https://redcap.mrc.gm:8443/redcap/api/", token="9B11857D60F4019GK7BFFDA65970B007", project.id="Pats__Covid_19_Cohort_1_Screening", id.position=1, records=NULL, fields=NULL)
#' @returns a list with 2 data frames: the data of interest and the metadata associated to the data.
#' @export
read_from_redcap = function(uri, token, project.id, id.position=1L, records=NULL, fields=NULL){
  # importing the credentials
  # credentials = readCredentials(credentials.file, project.id)
  # redcap.uri = uri
  # token = token

  # importing data and the metadata into R
  if(is.null(records) & is.null(fields)){
    # redcap.data = REDCapR::redcap_read_oneshot(redcap_uri = redcap.uri, token = token, records=NULL, fields=NULL, verbose = FALSE)
    redcap.data = REDCapR::redcap_read(redcap_uri = uri, token = token, records=NULL, fields=NULL, verbose = FALSE,id_position=as.integer(id.position))
    metadata = REDCapR::redcap_metadata_read(redcap_uri = uri, token = token, fields=NULL, verbose = FALSE)
  }else if(!is.null(records) & !is.null(fields)){
    if(is.vector(fields)){
      fields = paste(fields, collapse = ", ")
    }
    redcap.data = REDCapR::redcap_read(redcap_uri = uri, token = token, id_position=as.integer(id.position), fields_collapsed=fields, verbose = FALSE)
    metadata = REDCapR::redcap_metadata_read(redcap_uri = uri, token = token, fields_collapsed=fields, verbose = FALSE)
    id.column.name = names(redcap.data$data)[id.position]
    if(is.character(records)){
      records = as.character(unlist(strsplit(records,",")))
    }
    if(is.numeric(redcap.data$data[[id.column.name]])){
      records = as.numeric(records)
    }
    redcap.data$data = redcap.data$data[which(redcap.data$data[[id.column.name]] %in% records),]
  }else if(!is.null(fields) & is.null(records)){
    if(is.vector(fields)){
      fields = paste(fields, collapse = ", ")
    }
    redcap.data = REDCapR::redcap_read(redcap_uri = uri, token = token, id_position=as.integer(id.position), fields_collapsed=fields, verbose = FALSE)
    metadata = REDCapR::redcap_metadata_read(redcap_uri = uri, token = token, fields_collapsed=fields, verbose = FALSE)
  }else if(!is.null(records) & is.null(fields)){
    if(is.vector(records)){
      records = paste(records, collapse = ", ")
    }
    redcap.data = REDCapR::redcap_read(redcap_uri = uri, token = token, id_position=as.integer(id.position), records_collapsed=records, verbose = FALSE)
    metadata = REDCapR::redcap_metadata_read(redcap_uri = uri, token = token, verbose = FALSE)
  }

  # checking whether the importing was successful and extract the desired records and columns
  if(redcap.data$success & metadata$success){
    data = redcap.data$data
    meta = metadata$data
  }

  # return the imported data
  list(data = data,
       metadata = meta)
}


#' function to read credentials from a configuration file
#' @param file.path the path to the file with the user-specific credential details for the projects of interest.
#' @param project.id for relational DB, this is the name of the database that contains the table from which the data should be pulled. Otherwise, it is the project ID you were given access to.
#' @returns  a list with the user credential details.
#' @examples credentials = readCredentials(file.path=system.file("extdata", "test.ini", package = "readepi"), project.id="Pats__Covid_19_Cohort_1_Screening")
#' @export
readCredentials = function(file.path=NULL, project.id=NULL){
  if(!file.exists(file.path) | is.null(file.path)){
    stop("Could not find ",file.path)
  }
  if(is.null(project.id)){
    stop("Database name or project ID nor specified!")
  }

  credentials = data.table::fread(file.path, sep = "\t")
  if(ncol(credentials)!=7){
    stop("credential file should be tab-separated file with 7 columns.")
  }
  if(!all((names(credentials) %in% c('user_name', 'password', 'host_name', 'project_id', 'comment', 'dbms', 'port')))){
    stop("Incorrect column names found in provided credentials file.\nThe column names should be 'user_name', 'password', 'host_name', 'project_id', 'comment', 'dbms', 'port'")
  }
  idx = which(credentials$project_id==project.id)
  if(length(idx)==0){
    stop("Credential details for ",project.id," not found in credential file.")
  }else if(length(idx)>1){
    stop("Multiple credential lines found for the specified project ID.\nCredentials file should contain one line per project.")
  }else{
    project.credentials = list(user=credentials$user_name[idx],
                               pwd=credentials$password[idx],
                               host=credentials$host_name[idx],
                               project=credentials$project_id[idx],
                               dbms=credentials$dbms[idx],
                               port=credentials$port[idx])
  }
  project.credentials
}


#' function to display the structure of the credentials file
#' @export
#' @examples show_example_file()
show_example_file = function(){
  example.data = data.table::fread(system.file("extdata", "test.ini", package = "readepi"))
  print(example.data)
}


# read_from_dhis2 = function(base.url, user, password, records=NULL, fields=NULL){
#   if(!is.null(records) & !is.null(fields)){
#     # use datimutils package to read user specified records and fields
#     if(is.vector(fields)){
#       fields = paste(fields, collapse = ",")
#     }
#     if(is.character(records)){
#       records = as.character(unlist(strsplit(records,",")))
#     }
#     datimutils::loginToDATIM(username = user, password = password, base_url = base.url)
#     data = datimutils::getDataElementGroups(records, fields = fields)
#   }else if(is.null(records) & is.null(fields)){
#     # use httr and readr packages to read the entire dataset
#     login = httr::GET(base.url, httr::authenticate(user,password))
#     if(login$status != 200L){
#       stop("Could not login")
#     }
#     data = paste0(base.url,"api/reportTables/KJFbpIymTAo/data.csv") %>% #Define the API endpoint
#       httr::GET(.,httr::authenticate(user,password)) %>% #Make the HTTP call
#       httr::content(.,"text") %>% #Read the response
#       readr::read_csv() #Parse the CSV
#   }
#
#   data
# }



#' Function to import epidemiology-related data from different sources into R
#' @description the function allows import of data stored in database management systems (DBMS) including both relational and NoSQL databases. It also contains functions to import data from common file types such as csv, txt, xlsx, xml, json, etc.
#' @param credentials.file the path to the file with the user-specific credential details for the projects of interest. It is required when importing data from DBMS. This is a tab-delimited file with the following columns:
#' \enumerate{
#'   \item user_name: the user name
#'   \item password: the user password (for REDCap, this corresponds to the **token** that serves as password to the project)
#'   \item host_name: the host name (for MS SQL servers) or the URI (for REDCap)
#'   \item project_id: the project ID or the name of the database you are access to.
#'   \item comment: a summary description about the project or database of interest
#'   \item dbms: the name of the DBMS: 'redcap' or 'REDCap' when reading from REDCap, 'sqlserver' or 'SQLServer' when reading from MS SQLServer
#'   \item port: the port ID (used for MS SQLServers)
#'   }
#' @param file.path the path to the file to be read. When several files need to be imported from a directory, this should be the path to that directory
#' @param sep the separator between the columns in the file. This is only required for space-separated files.
#' @param format a string used to specify the file format. This is useful when a file does not have an extension, or has a file extension that does not match its actual type
#' @param which a string used to specify which objects should be extracted (the name of the excel sheet to import)
#' @param pattern when specified, only files with this suffix will be imported from the specified directory
#' @param project.id for relational DB, this is the name of the database that contains the table from which the data should be pulled. Otherwise, it is the project ID you were given access to.
#' @param driver.name the name of the MS driver. use `odbc::odbcListDrivers()` to display the list of installed drivers
#' @param table.name the name of the target table
#' @param records a vector or a comma-separated string of subset of subject IDs. When specified, only the records that correspond to these subjects will be imported.
#' @param fields a vector or a comma-separated string of column names. If provided, only those columns will be imported.
#' @param id.position the column position of the variable that unique identifies the subjects. This should only be specified when the column with the subject IDs is not the first column. default is 1.
#' @examples data = readepi(credentials.file=system.file("extdata", "test.ini", package = "readepi"), project.id="Pats__Covid_19_Cohort_1_Screening")
#' @returns a list with 2 data frames (data and metadata) when reading from REDCap. A data frame otherwise.
#' @export
readepi = function(credentials.file=NULL,
                   file.path=NULL,
                   sep=NULL,
                   format=NULL,
                   which=NULL,
                   pattern=NULL,
                   project.id = NULL,
                   driver.name=NULL,
                   table.name=NULL,
                   records=NULL,
                   fields=NULL,
                   id.position=1){

  # some check points
  if(!is.null(credentials.file) & !is.null(file.path)){
    stop("Impossible to import data from DBMS and file at the same time.")
  }

  # reading from file
  if(!is.null(file.path)){
    res = read_from_file(file.path, sep=sep, format=format, which=which, pattern=pattern)
  }

  # reading from DBMS
  if(!is.null(credentials.file)){
    credentials = readCredentials(credentials.file, project.id)
    if(credentials$dbms %in% c('redcap','REDCap')){
      res = read_from_redcap(uri=credentials$host, token=credentials$pwd, project.id=credentials$project, id.position=id.position,
                             records=records, fields=fields)
    }else if(credentials$dbms %in% c('sqlserver','SQLServer')){
      res = read_from_ms_sql_server(user=credentials$user, password=credentials$pwd, host=credentials$host, port=credentials$port,
                                    database.name=credentials$project, table.names=table.name, driver.name=driver.name, records=records,
                                    fields=fields)
    }else if(credentials$dbms %in% c('dhis2','DHIS2')){
      res = read_from_dhis2(base.url=credentials$host, password=credentials$pwd, user=credentials$user, project.id=credentials$project,
                            id.position=id.position, records=records, fields=fields)
    }
  }

  res
}








