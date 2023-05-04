#' Establish connection to the server
#'
#' @param dbms the database management system type
#' @param driver_name the driver name
#' @param host the host server name
#' @param database_name the database name
#' @param user the user name
#' @param password the user's password
#' @param port the server port ID
#'
#' @return the connection object
#' @export
#'
#' @examples
#' con <- connect_to_server(
#'  dbms = "MySQL",
#'  driver_name = "",
#'  host = "mysql-rfam-public.ebi.ac.uk",
#'  database_name = "Rfam",
#'  user = "rfamro",
#'  password = "",
#'  port = 4497
#' )
connect_to_server <- function(dbms, driver_name, host, database_name,
                              user, password, port) {
  checkmate::assert_character(dbms, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_character(driver_name, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_character(host, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_character(database_name, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_character(user, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_character(password, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_number(port, lower = 1)
  con <- switch(dbms,
                "SQLServer" = DBI::dbConnect(odbc::odbc(),
                                             driver = driver_name,
                                             server = host,
                                             database = database_name,
                                             uid = user, pwd = password,
                                             port = as.numeric(port)
                ),
                "PostgreSQL" = DBI::dbConnect(odbc::odbc(),
                                              driver = driver_name,
                                              host = host,
                                              database = database_name,
                                              uid = user, pwd = password,
                                              port = as.numeric(port)
                ),
                "MySQL" = DBI::dbConnect(RMySQL::MySQL(),
                                         dbname = database_name,
                                         username = user, password = password,
                                         host = host, port = as.numeric(port),
                                         driver = driver_name
                )
  )
  con
}


#' Detect table names from an SQL query
#'
#' @param query the SQL query
#' @param tables the list of all tables from the database
#'
#' @return the table name of interest
#' @export
#'
#' @examples
#' table_name = identify_table_name(
#'  query = "select * from author",
#'  tables = c("family_author", "author", "test")
#' )
#'
identify_table_name <- function(query, tables) {
  checkmate::assert_character(query, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_vector(tables,
                           any.missing = FALSE, min.len = 1,
                           null.ok = FALSE, unique = TRUE)
  table_name <- NULL
  query <- unlist(strsplit(query, " ", fixed = TRUE))
  table_name <- query[which(query %in% tables)]
  table_name <- ifelse(length(table_name) == 1, table_name,
                       glue::glue_collapse(table_name, sep = "_"))
  table_name
}

#' Fetch data from server using an SQL query
#'
#' @param source the SQL query
#' @param dbms the database management system type
#' @param tables the list of tables from the database
#' @param driver_name the driver name
#' @param host the host server name
#' @param database_name the database name
#' @param user the user name
#' @param password the user's password
#' @param port the server port ID
#'
#' @return a list with the data fetched from the tables of interest
#' @export
#'
#' @examples
#' result <- fetch_data_from_query(
#'  source = "select author_id, name, last_name from author",
#'  dbms = "MySQL",
#'  tables = c("family_author", "author"),
#'  driver_name = "",
#'  host = "mysql-rfam-public.ebi.ac.uk",
#'  database_name = "Rfam",
#'  user = "rfamro",
#'  password = "",
#'  port = 4497
#' )
#'
fetch_data_from_query <- function(source, dbms, tables,
                                 driver_name, host, database_name,
                                 user, password, port) {
  checkmate::assert_vector(source,
                           any.missing = FALSE, min.len = 1,
                           null.ok = FALSE, unique = TRUE
  )
  checkmate::assert_character(dbms, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_vector(tables,
                           any.missing = FALSE, min.len = 1,
                           null.ok = FALSE, unique = TRUE)
  checkmate::assert_character(driver_name, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_character(host, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_character(database_name, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_character(user, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_character(password, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_number(port, lower = 1)

  con <- connect_to_server(dbms, driver_name, host, database_name,
                           user, password, port)
  result <- list()
  for (query in source) {
    table <- identify_table_name(query, tables)
    stopifnot("Could not detect table name from the query" = !is.null(table))
    sql <- DBI::dbSendQuery(con, source)
    result[[table]] <- DBI::dbFetch(sql, -1)
    DBI::dbClearResult(sql)
  }
  DBI::dbDisconnect(conn = con)
  result
}


#' Subset data read from servers
#'
#' @param table_names the name of the tables where the data was fetched from
#' @param dbms the database management system type
#' @param id_col_name the column names that unique identify the records in the
#' tables
#' @param fields a vector of strings where each string is a comma-separated list
#' of column names.
#' @param records a vector or a comma-separated string of subset of subject IDs.
#' @param id_position a vector of the column positions of the variable that
#' unique identifies the subjects in each table
#' @param driver_name the driver name
#' @param host host server name
#' @param database_name the database name
#' @param user the user name
#' @param password the user's password
#' @param port the server port ID
#'
#' @return a subset of the data in the specified tables
#' @export
#' @examples
#' result = sql_select_data(
#'  table_names = "author",
#'  dbms = "MySQL",
#'  id_col_name = "author_id",
#'  fields = c("author_id", "name"),
#'  records = NULL,
#'  id_position = NULL,
#'  driver_name = "",
#'  host = "mysql-rfam-public.ebi.ac.uk",
#'  database_name = "Rfam",
#'  user = "rfamro",
#'  password = "",
#'  port = 4497
#' )
#'
sql_select_data <- function(table_names, dbms, id_col_name,
                            fields, records, id_position,
                            driver_name, host, database_name,
                            user, password, port) {
  checkmate::assert_number(port, lower = 1)
  checkmate::assert_character(password, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_character(user, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_character(host, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_character(driver_name, len = 1, null.ok = FALSE,
                              any.missing = FALSE)
  checkmate::assert_vector(table_names,
                           any.missing = FALSE, min.len = 1,
                           null.ok = FALSE, unique = FALSE
  )
  checkmate::assert_character(dbms, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_vector(id_col_name,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = FALSE
  )
  checkmate::assert_vector(records,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(fields,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(id_position,
                           any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = FALSE
  )
  checkmate::assert_character(database_name, any.missing = FALSE, len = 1,
                              null.ok = FALSE)

  con <- connect_to_server(dbms, driver_name, host, database_name,
                           user, password, port)
  result <- list()
  j <- 1
  for (table in table_names) {
    R.utils::cat("\nFetching data from", table)

    # select records from table
    if (all(is.null(records) & is.null(fields))) {
      result[[table]] <- sql_select_entire_dataset(table, con)
    } else if (!is.null(records) && is.null(fields)) {
      record <- ifelse(all(grepl(",", records, fixed = TRUE) == TRUE &
                             length(records) > 1),
                       records[j], records)
      result[[table]] <- sql_select_records_only(table, record, con, dbms,
                                                 id_col_name, id_position)
    } else if (!is.null(fields) && is.null(records)) {
      field <- ifelse(all(grepl(",", fields, fixed = TRUE) == TRUE &
                            length(fields) > 1),
                      fields[j], fields)
      result[[table]] <- sql_select_fields_only(table, field, con)
    } else {
      record <- ifelse(all(grepl(",", records, fixed = TRUE) == TRUE &
                             length(records) > 1),
                       records[j], records)
      field <- ifelse(all(grepl(",", fields, fixed = TRUE) == TRUE &
                            length(fields) > 1),
                      fields[j], fields)
      id_column_name <- get_id_column_name(id_col_name, j, id_position)[[1]]
      id_pos <- get_id_column_name(id_col_name, j, id_position)[[2]]
      result[[table]] <- sql_select_records_and_fields(table, record, con,
                                                       id_column_name, field,
                                                       dbms, id_pos)
    }

    j <- j + 1
  }
  DBI::dbDisconnect(conn = con)
  result
}

#' get the id column name
#'
#' @param id_col_name the id column name
#' @param j the index
#' @param id_position the id position
#'
get_id_column_name <- function(id_col_name, j, id_position) {
  checkmate::assert_vector(id_col_name,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = FALSE
  )
  checkmate::assert_numeric(j, lower = 1, any.missing = FALSE,
                            len = 1, null.ok = FALSE)
  checkmate::assert_vector(id_position,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = FALSE
  )
  id_column_name <- id_pos <- NULL
  if (!is.null(id_col_name)) {
    id_col_name <- gsub(" ", "", id_col_name, fixed = TRUE)
    id_col_name <- unlist(strsplit(id_col_name, ",", fixed = TRUE))
    id_column_name <- ifelse(!is.na(id_col_name[j]), id_col_name[j], NULL)
  }

  if (!is.null(id_position)) {
    id_position <- gsub(" ", "", id_position, fixed = TRUE)
    id_position <- unlist(strsplit(id_position, ",", fixed = TRUE))
    id_pos <- ifelse(!is.na(id_position[j]), id_position[j], NULL)
  }

  list(
    id_column_name,
    id_pos
  )
}

#' Fetch entire dataset in a table
#'
#' @param table the table name
#' @param con the connection object
#'
#' @return a data frame with the entire dataset that is contained in the table
#' @export
#'
#' @examples
#' result <- sql_select_entire_dataset(
#'  table = "author",
#'  con = DBI::dbConnect(RMySQL::MySQL(),
#'    driver = "",
#'    host = "mysql-rfam-public.ebi.ac.uk",
#'    dbname = "Rfam",
#'    user = "rfamro",
#'    password = "",
#'    port = 4497
#'  )
#' )
#'
sql_select_entire_dataset <- function(table, con) {
  checkmate::assert_character(table, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  query <- paste0("select * from ", table)
  sql <- DBI::dbSendQuery(con, query)
  res <- DBI::dbFetch(sql, -1)
  DBI::dbClearResult(sql)

  res
}

#' Select specified records and fields from a table
#'
#' @param table the table name
#' @param record a vector or a comma-separated string of subset of subject IDs.
#' @param con the connection object
#' @param id_column_name the column names that unique identify the records in
#' the tables
#' @param field a vector of strings where each string is a comma-separated list
#' of column names.
#' @param dbms the database management system type
#' @param id_pos a vector of the column positions of the variable that
#' unique identifies the subjects in each table
#'
#' @return a data frame with the specified columns and records
#' @export
#'
#' @examples
#' result <- sql_select_records_and_fields(
#'  table = "author",
#'  record = c("1", "20", "50"),
#'  con = DBI::dbConnect(RMySQL::MySQL(),
#'    driver = "",
#'    host = "mysql-rfam-public.ebi.ac.uk",
#'    dbname = "Rfam",
#'    user = "rfamro",
#'    password = "",
#'    port = 4497
#'  ),
#'  id_column_name = "author_id",
#'  field = c("author_id", "last_name"),
#'  dbms = "MySQL",
#'  id_pos = NULL
#' )
#'
sql_select_records_and_fields <- function(table, record, con,
                                          id_column_name, field, dbms,
                                          id_pos) {
  checkmate::assert_character(dbms, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_character(id_column_name,
                           any.missing = FALSE,
                           null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_character(id_pos,
                              any.missing = FALSE,
                              null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_character(table, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_vector(record,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(field,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
  res <- sql_select_records_only(table, record, con, dbms,
                                 id_column_name, id_pos)
  if (is.character(field)) {
    field <- as.character(lapply(field, function(x) {
      gsub(" ", "", x, fixed = TRUE)
    }))
    field <- unlist(strsplit(field, ",", fixed = TRUE))
  }
  res <- res %>% dplyr::select(dplyr::all_of(field))

  res
}


#' Visualize the first 5 rows of the data from a table
#'
#' @param table the table name
#' @param con the connection object
#' @param display a boolean that specify whether to display the first 5 rows or
#' not. default = TRUE
#' @param dbms the database management system type
#'
#' @return return the first 5 rows of the table if display=TRUE
#' @export
#'
#' @examples
#' visualise_table(
#'  table = "author",
#'  con = DBI::dbConnect(RMySQL::MySQL(),
#'    driver = "",
#'    host = "mysql-rfam-public.ebi.ac.uk",
#'    dbname = "Rfam",
#'    user = "rfamro",
#'    password = "",
#'    port = 4497
#'  ),
#'    display = TRUE,
#'    dbms =  "MySQL"
#' )
#'
visualise_table <- function(table, con, dbms, display = TRUE) {
  checkmate::assert_character(table, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_character(dbms, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_logical(display, any.missing = FALSE,
                            len = 1, null.ok = FALSE)
  query <- ifelse(dbms == "MySQL",
                  paste0("select * from ", table, " limit 5"),
                  paste0("select top 5 * from ", table))
  sql <- DBI::dbSendQuery(conn = con, query)
  res <- DBI::dbFetch(sql, -1)
  DBI::dbClearResult(sql)
  if (display) {
    print(res)
  } else {
    return(res)
  }
}


#' Select specified records from a table
#'
#' @param table the table name
#' @param record a vector or a comma-separated string of subset of subject IDs.
#' @param con the connection object
#' @param dbms the database management system type
#' @param id_column_name the column names that unique identify the records in
#' the tables
#' @param id_pos a vector of the column positions of the variable that
#' unique identifies the subjects in each table
#'
#' @return a data frame with the records of interest
#' @export
#'
#' @examples
#' result <- sql_select_records_only(
#'  table = "author",
#'  record = c("1", "20", "50"),
#'  con = DBI::dbConnect(RMySQL::MySQL(),
#'    driver = "",
#'    host = "mysql-rfam-public.ebi.ac.uk",
#'    dbname = "Rfam",
#'    user = "rfamro",
#'    password = "",
#'    port = 4497
#'  ),
#'  dbms = "MySQL",
#'  id_column_name = NULL,
#'  id_pos = 1
#' )
sql_select_records_only <- function(table, record, con, dbms,
                                    id_column_name, id_pos) {
  checkmate::assert_vector(id_pos,
                           any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = FALSE
  )
  checkmate::assert_vector(id_column_name,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = FALSE
  )
  checkmate::assert_character(table, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_character(dbms, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_vector(record,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
  tmp <- visualise_table(table, con, display = FALSE, dbms)
  id_col_name <- ifelse(!is.null(id_column_name),
                       id_column_name,
                       names(tmp)[id_pos])
  stopifnot("Missing or NULL value found in record argument" = (anyNA(record) ||
                                                          !any(is.null(record)))
  )

  if (is.vector(record)) {
    record <- glue::glue_collapse(record, sep = ", ")
  }
  record <- as.character(lapply(record, function(x) {
    gsub(" ", "", x, fixed = TRUE)
  }))
  record <- gsub(",", "','", record, fixed = TRUE)
  query <- paste0("select * from ", table,
                  " where (", id_col_name, " in ('", record, "'))")
  sql <- DBI::dbSendQuery(con, query)
  res <- DBI::dbFetch(sql, -1)
  DBI::dbClearResult(sql)

  res
}


#' Select specified fields from a table
#'
#' @param table the table name
#' @param field a vector of column names of interest
#' @param con the connection object
#'
#' @return a data frame with the specified fileds
#' @export
#'
#' @examples
#' result <- sql_select_fields_only(
#'  table = "author",
#'  field = c("author_id", "name", "last_name"),
#'  con = DBI::dbConnect(RMySQL::MySQL(),
#'    driver = "",
#'    host = "mysql-rfam-public.ebi.ac.uk",
#'    dbname = "Rfam",
#'    user = "rfamro",
#'    password = "",
#'    port = 4497
#'  )
#' )
#'
sql_select_fields_only <- function(table, field, con) {
  checkmate::assert_character(table, any.missing = FALSE, len = 1,
                              null.ok = FALSE)
  checkmate::assert_vector(field,
                           any.missing = FALSE, min.len = 1,
                           null.ok = TRUE, unique = TRUE
  )
  stopifnot("Missing or NULL value found in record argument" = (anyNA(field) ||
                                                          !any(is.null(field)))
  )
  if (is.vector(field)) {
    field <- glue::glue_collapse(field, sep = ", ")
  }
  field <- as.character(lapply(field, function(x) {
    gsub(" ", "", x, fixed = TRUE)
  }))
  field <- as.character(lapply(field, function(x) {
    gsub(",", ", ", x, fixed = TRUE)
  }))
  query <- paste0("select ", field, " from ", table)
  sql <- DBI::dbSendQuery(con, query)
  res <- DBI::dbFetch(sql, -1)
  DBI::dbClearResult(sql)

  res
}
