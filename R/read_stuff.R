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
#' @param sep the separator between the columns in the file. This is only required for space-separated files. 
#' @param format a string used to specify the file format. This is useful when a file does not have an extension, or has a file extension that does not match its actual type
#' @param which a string used to specify the name of the excel sheet to import
#' @param pattern when specified, only files with this suffix will be imported from the specified directory
#' @returns  a data frame (import from file) or a list (import several files from directory)
#' @examples data = read_from_file(file.path = "/path/to/test.txt", sep=NULL, format=NULL, which=NULL, pattern=NULL)
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
#   
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
#   as.data.table(data)
# }

# function to return the file extension
getExtension = function(file.path){
  splits = unlist(strsplit(basename(file.path),".",fixed = TRUE))
  extension = splits[length(splits)]
  extension
}

#' function to read data from relational databases hosted by online MS SQL server. The user needs to have read access to the database et should install the appropriate MS driver that is compatible with the SQLServer version
#' @param user the user name
#' @param password the user password
#' @param host the name of the host server
#' @param port the port ID
#' @param database.name the name of the database that contains the table from which the data should be pulled
#' @param table.name the name of the target table
#' @param driver.name the name of the MS driver. use `odbc::odbcListDrivers()` to display the list of installed drivers
#' @param records a vector or a comma-separated string of subset of subject IDs. When specified, only the records that correspond to these subjects will be imported.   
#' @param fields a vector or a comma-separated string of column names. If provided, only those columns will be imported
#' @param id.position the column position of the variable that unique identifies the subjects. This should only be specified when the column with the subject IDs is not the first column. default is 1.  
#' @returns a data frame
#' @export
#' @examples data = read_from_relationalDB(user="kmane", password="****", host="robin.mrc.gm", port=1433, database.name="mrcg_db", table.name="test", driver.name="ODBC Driver 17 for SQL Server")
read_from_ms_sql_server = function(user, password, host, port, database.name, driver.name, table.name, records=NULL, fields=NULL, id.position=1){
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
  if(!(table.name %in% tables)){
    stop("Could not found table called ",table.name," in ",database.name,"!\n")
  }
  
  # extract the data from the given table and store the output in an R object
  sql = DBI::dbSendQuery(con,paste0("select * from ",table.name))
  data = DBI::dbFetch(sql, -1)
  DBI::dbClearResult(sql)
  
  # closing the connection
  DBI::dbDisconnect(conn = con)
  
  # subsetting
  if(!is.null(fields)){
    if(is.character(fields)){
      fields = as.character(unlist(strsplit(fields, ",")))
    }
    if(!all((fields %in% names(data)))){
      stop("Some of the specified fields do not exist in the table ",table.name)
    }
    data = data %>% dplyr::select(all_of(fields))
  }
  if(!is.null(records)){
    if(is.character(records)){
      records = as.character(unlist(strsplit(records, ",")))
    }
    id.column.name = names(data)[id.position]
    if(is.numeric(data[[id.column.name]])){
      records = as.numeric(records)
    }
    if(!all((records %in% data[[id.column.name]]))){
      stop("Some of the specified records do not exist in the table ",table.name)
    }
    data = data %>% filter(data[[id.column.name]] %in% records)
  }
  
  data
}

#' function to read user credentials from file
readMSsqlCredentials = function(credentials.file){
  if(!file.exists(credentials.file)){
    stop("Could not find ",credentials.file)
  }
  credentials = data.table::fread(credentials.file, 
                                  sep = "\t")
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


#' @param uri the URI of the server   
#' @param token the user-specific string that serves as the password for a project
#' @param project.id the name of the project you want to import data from
#' @param id.position the column position of the variable that unique identifies the subjects. This should only be specified when the column with the subject IDs is not the first column. default is 1.   
#' @param records a vector or a comma-separated string of subset of subject IDs. When specified, only the records that correspond to these subjects will be imported.   
#' @param fields a vector or a comma-separated string of column names. If provided, only those columns will be imported.   
#' @examples redcap.data = read_from_redcap(uri, token, project.id, id_position=1, records=NULL, fields=NULL)
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
    data = as.data.table(redcap.data$data)
    meta = as.data.table(metadata$data)
  }
  
  # return the imported data
  list(data = data,
       metadata = meta)
}


#' function to read credentials from a configuration file
readCredentials = function(file.path, project.id){
  if(!file.exists(file.path)){
    stop("Could not find ",file.path)
  }
  credentials = data.table::fread(file.path, 
                                  sep = "\t")
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



#' Function to import epidemiology-related data from different sources into R
#' @description the function is a wrapper around numerous functions that are used to import data stored in database management systems (DBMS) including both relational and NoSQL databases. It also contains functions to import data from common file types such as csv, txt, xlsx, xml, json, etc.
#' @param credentials.file the path to the file with the user-specific credential details for the projects of interest. It is required when importing data from DBMS. This is a tab-delimited file with the following columns:   
#' \enumerate{
#'   \item user_name: the user name
#'   \item password: the user password (for REDCap, this corresponds to the **token** that serves as password to the project)
#'   \item host_name: the host name (for relational DB) or the URI (for NoSQL DB such as REDCap)
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
#' @example data = read_epi(credentials.file, project.id="test")
#' @returns a list with 2 data frames (data and metadata) when reading from REDCap. A data frame otherwise.   
#' @export
#' 
read_epi = function(credentials.file=NULL, 
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
                                    database.name=credentials$project, table.name=table.name, driver.name=driver.name, records=records,
                                    fields=fields)
    }
  }
  
  res
} 








