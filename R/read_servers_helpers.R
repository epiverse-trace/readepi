#' Establish connection to the server
#'
#' @param base_url the host server name
#' @param user_name the user name
#' @param password the user's password
#' @param dbms the database management system type
#' @param driver_name the driver name
#' @param database_name the database name
#' @param port the server port ID
#'
#' @return the `connection` object
#'
#' @examples
#' \dontrun{
#' con <- connect_to_server(
#'   base_url      = "mysql-rfam-public.ebi.ac.uk",
#'   user_name     = "rfamro",
#'   password      = "",
#'   dbms          = "MySQL",
#'   driver_name   = "",
#'   database_name = "Rfam",
#'   port          = 4497
#' )
#' }
#' @keywords internal
#' @noRd
connect_to_server <- function(base_url,
                              user_name,
                              password,
                              dbms,
                              driver_name,
                              database_name,
                              port) {
  con <- switch(
<<<<<<< HEAD
                dbms,
                SQLServer = pool::dbPool(odbc::odbc(),
                                         driver   = driver_name,
                                         server   = host,
                                         database = database_name,
                                         uid      = user_name,
                                         pwd      = password,
                                         port     = port),
                PostgreSQL = pool::dbPool(odbc::odbc(),
                                          driver   = driver_name,
                                          host     = host,
                                          database = database_name,
                                          uid      = user_name,
                                          pwd      = password,
                                          port     = port),
                MySQL = pool::dbPool(drv = RMySQL::MySQL(),
                                     dbname   = database_name,
                                     username = user_name,
                                     password = password,
                                     host     = host,
                                     port     = port,
                                     driver   = driver_name))
=======
    dbms,
    SQLServer = pool::dbPool(odbc::odbc(),
                             driver   = driver_name,
                             server   = base_url,
                             database = database_name,
                             uid      = user_name,
                             pwd      = password,
                             port     = port),
    PostgreSQL = pool::dbPool(odbc::odbc(),
                              driver   = driver_name,
                              host     = base_url,
                              database = database_name,
                              uid      = user_name,
                              pwd      = password,
                              port     = port),
    MySQL = pool::dbPool(drv = RMySQL::MySQL(),
                         dbname   = database_name,
                         username = user_name,
                         password = password,
                         host     = base_url,
                         port     = port,
                         driver   = driver_name)
  )
>>>>>>> aa32101 (replace host with base_url and harmonise on arguments order)
  con
}


#' Detect table names from an SQL query
#'
#' @param query the SQL query
#' @param tables the list of all tables from the database
#'
#' @return a `character` with the identified tables name(s) from the SQL query
#'
#' @examples
#' \dontrun{
#' table_name <- identify_table_name(
#'   query  = "select * from author",
#'   tables = c("family_author", "author", "test")
#' )
#' }
#' @keywords internal
#' @noRd
identify_table_name <- function(query,
                                tables) {
  checkmate::assert_character(query,
                              any.missing = FALSE, len = 1L,
                              null.ok = FALSE)
  checkmate::assert_vector(tables,
                           any.missing = FALSE, min.len = 1L,
                           null.ok = FALSE, unique = TRUE)
  table_name <- NULL
  query      <- unlist(strsplit(query, " ", fixed = TRUE))
  table_name <- query[which(query %in% tables)]
  table_name <- ifelse(length(table_name) == 1L, table_name,
                       glue::glue_collapse(table_name, sep = "_"))
  table_name
}

#' Fetch data from server using an SQL query
#'
#' @param src the SQL query
#' @param tables the list of tables from the database
#' @param base_url the host server name
#' @param user_name the user name
#' @param password the user's password
#' @param dbms the database management system type
#' @param driver_name the driver name
#' @param database_name the database name
#' @param port the server port ID
#'
#' @return a `list` of 1 or more objects of type `data.frame` containing each
#'    data fetched from one table.
#'
#' @examples
#' \dontrun{
#' result <- fetch_data_from_query(
#'   src           = "select author_id, name, last_name from author",
#'   tables        = c("family_author", "author"),
#'   base_url      = "mysql-rfam-public.ebi.ac.uk",
#'   user_name     = "rfamro",
#'   password      = "",
#'   dbms          = "MySQL",
#'   driver_name   = "",
#'   database_name = "Rfam",
#'   port          = 4497
#' )
#' }
#' @keywords internal
#' @noRd
fetch_data_from_query <- function(src,
                                  tables,
                                  base_url,
                                  user_name,
                                  password,
                                  dbms,
                                  driver_name,
                                  database_name,
                                  port) {
  checkmate::assert_vector(tables,
                           any.missing = FALSE, min.len = 1L,
                           null.ok = FALSE, unique = TRUE)

  pool    <- connect_to_server(
    base_url      = base_url,
    user_name     = user_name,
    password      = password,
    dbms          = dbms,
    driver_name   = driver_name,
    database_name = database_name,
    port          = port
  )
  result  <- list()
  for (query in src) {
    table <- identify_table_name(query, tables)
    stopifnot("Could not detect table name from the query" = !is.null(table))
    result[[table]] <- DBI::dbGetQuery(pool, src)
  }
  pool::poolClose(pool)

  result
}


#' Subset data read from servers
#'
#' @param table_names the name of the tables where the data was fetched from
#' @param base_url the host server name
#' @param user_name the user name
#' @param password the user's password
#' @param dbms the database management system type
#' @param driver_name the driver name
#' @param database_name the database name
#' @param port the server port ID
#' @param id_col_name the column names that unique identify the records in the
#'    tables
#' @param fields a vector of strings where each string is a comma-separated list
#'    of column names.
#' @param records a vector or a comma-separated string of subset of subject IDs.
#' @param id_position a vector of the column positions of the variable that
#'    unique identifies the subjects in each table
#'
#' @return a `list` of 1 or more elements of type `data.frame` where every
#'    element contains the subset of the data from the corresponding table.
#' @examples
#' \dontrun{
#' result <- sql_select_data(
#'   table_names   = "author",
#'   base_url      = "mysql-rfam-public.ebi.ac.uk",
#'   user_name     = "rfamro",
#'   password      = "",
#'   dbms          = "MySQL",
#'   driver_name   = "",
#'   database_name = "Rfam",
#'   port          = 4497,
#'   id_col_name   = "author_id",
#'   fields        = c("author_id", "name"),
#'   records       = NULL,
#'   id_position   = NULL
#' )
#' }
#' @keywords internal
#' @noRd
sql_select_data <- function(table_names,
                            base_url,
                            user_name,
                            password,
                            dbms,
                            driver_name,
                            database_name,
                            port,
                            id_col_name,
                            fields,
                            records     = NULL,
                            id_position = NULL) {
  checkmate::assert_vector(table_names,
                           any.missing = FALSE, min.len = 1L,
                           null.ok = FALSE, unique = FALSE)

  result <- list()
  j <- 1L
  for (table in table_names) {
    message("\nFetching data from: ", table)

    # select records from table
    if (is.null(records) && is.null(fields)) {
      result[[table]] <- sql_select_entire_dataset(
        table, base_url, user_name, password, dbms, driver_name,
        database_name, port
      )
    } else if (!is.null(records) && is.null(fields)) {
      record <- ifelse(all(grepl(",", records, fixed = TRUE) &
                             length(records) > 1L),
                       records[j], records)
      result[[table]] <- sql_select_records_only(
        table, base_url, user_name, password, dbms, driver_name,
        database_name, port, record, id_col_name, id_position
      )
    } else if (!is.null(fields) && is.null(records)) {
      field <- ifelse(all(grepl(",", fields, fixed = TRUE) &
                            length(fields) > 1L),
                      fields[j], fields)
      result[[table]] <- sql_select_fields_only(table, base_url, user_name,
                                                password, dbms, driver_name,
                                                database_name, port, field)
    } else {
      record <- ifelse(all(grepl(",", records, fixed = TRUE) &
                             length(records) > 1L),
                       records[j], records)
      field  <- ifelse(all(grepl(",", fields, fixed = TRUE) &
                             length(fields) > 1L),
                       fields[j], fields)
      id_column_name <- get_id_column_name(id_col_name,
                                           j,
                                           id_position)[["id_column_name"]]
      id_pos <- get_id_column_name(id_col_name, j, id_position)[["id_pos"]]
      result[[table]] <- sql_select_records_and_fields(
        table, base_url, user_name, password, dbms,
        driver_name, database_name, port,
        record, id_column_name, field, id_pos
      )
    }
    j <- j + 1L
  }

  result
}

#' get the id column name
#'
#' @param id_col_name the id column name
#' @param j the index
#' @param id_position the id position
#'
#' @returns a `list` of 2 elements of type `character` and `numeric`
#'    corresponding to the ID column name and position.
#' @keywords internal
#' @noRd
#'
#' @examples
#' id <- get_id_column_name(
#'   id_col_name = c("author_id", "rfam_acc"),
#'   j           = 1L,
#'   id_position = c(1L, 1L)
#' )
#'
get_id_column_name <- function(id_col_name,
                               j,
                               id_position) {
  checkmate::assert_numeric(j,
                            lower = 1L, any.missing = FALSE,
                            len = 1L, null.ok = FALSE)
  id_column_name   <- id_pos <- NULL
  if (!is.null(id_col_name)) {
    id_col_name    <- gsub(" ", "", id_col_name, fixed = TRUE)
    id_col_name    <- unlist(strsplit(id_col_name, ",", fixed = TRUE))
    id_column_name <- ifelse(!is.na(id_col_name[j]), id_col_name[j], NULL)
  }

  if (!is.null(id_position)) {
    id_position    <- gsub(" ", "", id_position, fixed = TRUE)
    id_position    <- unlist(strsplit(id_position, ",", fixed = TRUE))
    id_pos         <- ifelse(!is.na(id_position[j]), id_position[j], NULL)
  }

  list(
    id_column_name = id_column_name,
    id_pos         = id_pos
  )
}

#' Fetch entire dataset in a table
#'
#' @param table the table name
#' @param base_url host server name
#' @param user_name the user name
#' @param password the user's password
#' @param dbms the database management system type
#' @param driver_name the driver name
#' @param database_name the database name
#' @param port the server port ID
#'
#' @return an object of type `data.frame` with the entire dataset fetched from
#'    the specified table.
#'
#' @examples
#' \dontrun{
#' result <- sql_select_entire_dataset(
#'   table         = "author",
#'   base_url      = "mysql-rfam-public.ebi.ac.uk",
#'   user_name     = "rfamro",
#'   password      = "",
#'   dbms          = "MySQL",
#'   driver_name   = "",
#'   database_name = "Rfam",
#'   port          = 4497
#' )
#' }
#' @keywords internal
#' @noRd
sql_select_entire_dataset <- function(table,
                                      base_url,
                                      user_name,
                                      password,
                                      dbms,
                                      driver_name,
                                      database_name,
                                      port) {
  checkmate::assert_character(table,
                              any.missing = FALSE, len = 1L,
                              null.ok = FALSE)

  con   <- connect_to_server(
    base_url, user_name, password, dbms, driver_name, database_name, port
  )
  query <- sprintf("select * from %s", table)
  res   <- DBI::dbGetQuery(con, query)
  pool::poolClose(con)
  res
}

#' Select specified records and fields from a table
#'
#' @param table the table name
#' @param base_url the host server name
#' @param user_name the user name
#' @param password the user's password
#' @param dbms the database management system type
#' @param driver_name the driver name
#' @param database_name the database name
#' @param port the server port ID
#' @param record a vector or a comma-separated string of subset of subject IDs.
#' @param id_column_name the column names that unique identify the records in
#'    the tables
#' @param field a vector of strings where each string is a comma-separated list
#'    of column names.
#' @param id_pos a vector of the column positions of the variable that
#'    unique identifies the subjects in each table
#'
#' @return an object of type `data.frame` that contains the dataset with the
#'    specified fields and records.
#'
#' @examples
#' \dontrun{
#' result <- sql_select_records_and_fields(
#'   table          = "author",
#'   base_url       = "mysql-rfam-public.ebi.ac.uk",
#'   user_name      = "rfamro",
#'   password       = "",
#'   dbms           = "MySQL",
#'   driver_name    = "",
#'   database_name  = "Rfam",
#'   port           = 4497,
#'   record         = c("1", "20", "50"),
#'   id_column_name = "author_id",
#'   field          = c("author_id", "last_name"),
#'   id_pos         = NULL
#' )
#' }
#' @keywords internal
#' @noRd
sql_select_records_and_fields <- function(table,
                                          base_url,
                                          user_name,
                                          password,
                                          dbms,
                                          driver_name,
                                          database_name,
                                          port,
                                          record         = NULL,
                                          id_column_name = NULL,
                                          field          = NULL,
                                          id_pos         = NULL) {
  checkmate::assert_character(id_column_name,
                              any.missing = FALSE,
                              null.ok = TRUE, unique = TRUE)
  checkmate::assert_character(id_pos,
                              any.missing = FALSE,
                              null.ok = TRUE, unique = TRUE)
  checkmate::assert_character(table,
                              any.missing = FALSE, len = 1L,
                              null.ok = FALSE)
  checkmate::assert_vector(record,
                           any.missing = FALSE, min.len = 1L,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_vector(field,
                           any.missing = FALSE, min.len = 1L,
                           null.ok = TRUE, unique = TRUE)

  con <- connect_to_server(base_url, user_name, password, dbms, driver_name,
                           database_name, port)
  res <- sql_select_records_only(table, base_url, user_name, password, dbms,
                                 driver_name,  database_name, port,
                                 record, id_column_name, id_pos)
  if (is.character(field)) {
    field <- as.character(lapply(field, function(x) {
      gsub(" ", "", x, fixed = TRUE)
    }))
    field <- unlist(strsplit(field, ",", fixed = TRUE))
  }
  res <- res %>% dplyr::select(dplyr::all_of(field))
  pool::poolClose(con)
  res
}


#' Visualize the first 5 rows of the data from a table
#'
#' @param data_source the the URL of the HIS
#' @param credentials_file the path to the file with the user-specific
#' credential details for the projects of interest
#' @param from the table name
#' @param driver_name the name of the MS driver
#'
#' @return prints the first 5 rows of the specified table.
#'
#' @examples
#' \dontrun{
#' visualise_table(
#'   data_source      = "mysql-rfam-public.ebi.ac.uk",
#'   credentials_file = system.file("extdata", "test.ini", package = "readepi"),
#'   from             = "author",
#'   driver_name      = ""
#' )
#' }
#' @export
#'
visualise_table <- function(data_source,
                            credentials_file,
                            from,
                            driver_name) {
  checkmate::assert_character(from,
                              any.missing = FALSE, len = 1L,
                              null.ok = FALSE)
  checkmate::assert_character(credentials_file, null.ok = FALSE, len = 1L)
  checkmate::assert_file_exists(credentials_file)
  checkmate::assert_character(data_source, null.ok = FALSE, len = 1L)

  credentials <- read_credentials(credentials_file, data_source)
  con <- connect_to_server(
    credentials[["dbms"]], driver_name, credentials[["host"]],
    credentials[["project"]], credentials[["user"]], credentials[["pwd"]],
    credentials[["port"]]
  )
  query <- ifelse(credentials[["dbms"]] == "MySQL",
                  sprintf("select * from %s limit 5", from),
                  sprintf("select top 5 * from %s", from))
  res <- DBI::dbGetQuery(con, query)
  pool::poolClose(con)
  print(res)
}


#' Select specified records from a table
#'
#' @param table the table name
#' @param base_url the host server name
#' @param user_name the user name
#' @param password the user's password
#' @param dbms the database management system type
#' @param driver_name the driver name
#' @param database_name the database name
#' @param port the server port ID
#' @param record a vector or a comma-separated string of subset of subject IDs.
#' @param id_column_name the column names that unique identify the records in
#'    the tables
#' @param id_pos a vector of the column positions of the variable that
#'    unique identifies the subjects in each table
#'
#' @return an object of type `data.frame` that contains the data fetched from
#'    the specific table with only the records of interest.
#'
#' @examples
#' \dontrun{
#' result <- sql_select_records_only(
#'   table          = "author",
#'   base_url       = "mysql-rfam-public.ebi.ac.uk",
#'   user_name      = "rfamro",
#'   password       = "",
#'   dbms           = "MySQL",
#'   driver_name    = "",
#'   database_name  = "Rfam",
#'   port           = 4497,
#'   record         = c("1", "20", "50"),
#'   id_column_name = NULL,
#'   id_pos         = 1
#' )
#' }
#' @keywords internal
#' @noRd
sql_select_records_only <- function(table,
                                    base_url,
                                    user_name,
                                    password,
                                    dbms,
                                    driver_name,
                                    database_name,
                                    port           = 4497L,
                                    record         = NULL,
                                    id_column_name = NULL,
                                    id_pos         = NULL) {
  checkmate::assert_vector(id_pos,
                           any.missing = FALSE, min.len = 0L,
                           null.ok = TRUE, unique = FALSE)
  checkmate::assert_vector(id_column_name,
                           any.missing = FALSE, min.len = 1L,
                           null.ok = TRUE, unique = FALSE)
  checkmate::assert_character(table,
                              any.missing = FALSE, len = 1L,
                              null.ok = FALSE)
  checkmate::assert_vector(record,
                           any.missing = FALSE, min.len = 1L,
                           null.ok = TRUE, unique = TRUE)

  con   <- connect_to_server(base_url, user_name, password, dbms, driver_name,
                             database_name, port)
  query <- ifelse(dbms == "MySQL",
                  sprintf("select * from %s limit 5", table),
                  sprintf("select top 5 * from %s", table))
  first_5_rows <- DBI::dbGetQuery(con, query)
  id_col_name  <- ifelse(!is.null(id_column_name),
                         id_column_name,
                         names(first_5_rows)[id_pos])
  stopifnot("Missing or NULL value found in record argument" =
              (anyNA(record) || !any(is.null(record))))

  if (is.vector(record)) {
    record <- glue::glue_collapse(record, sep = ", ")
  }
  record   <- as.character(lapply(record, function(x) {
    gsub(" ", "", x, fixed = TRUE)
  }))
  record   <- gsub(",", "','", record, fixed = TRUE)
  sprintf("select * from %s where (%s in ('%s'))", table, id_col_name, record)
  res      <- DBI::dbGetQuery(con, query)
  pool::poolClose(con)
  res
}


#' Select specified fields from a table
#'
#' @param table the table name
#' @param base_url the host server name
#' @param user_name the user name
#' @param password the user's password
#' @param dbms the database management system type
#' @param driver_name the driver name
#' @param database_name the database name
#' @param port the server port ID
#' @param field a vector of column names of interest
#'
#' @return an object of type `data.frame` that contains the data fetched from
#'    the specific table with only the fields of interest.
#'
#' @examples
#' \dontrun{
#' result <- sql_select_fields_only(
#'   table         = "author",
#'   base_url      = "mysql-rfam-public.ebi.ac.uk",
#'   user_name     = "rfamro",
#'   password      = "",
#'   dbms          = "MySQL",
#'   driver_name   = "",
#'   database_name = "Rfam",
#'   port          = 4497,
#'   field         = c("author_id", "name", "last_name")
#' )
#' }
#' @keywords internal
#' @noRd
sql_select_fields_only <- function(table,
                                   base_url,
                                   user_name,
                                   password,
                                   dbms,
                                   driver_name,
                                   database_name,
                                   port,
                                   field          = NULL) {
  checkmate::assert_character(table,
                              any.missing = FALSE, len = 1L,
                              null.ok = FALSE)
  checkmate::assert_vector(field,
                           any.missing = FALSE, min.len = 1L,
                           null.ok = TRUE, unique = TRUE)

  stopifnot(
    "Missing or NULL value found in record argument" =
      (anyNA(field) || !any(is.null(field)))
  )
  con <- connect_to_server(
    base_url, user_name, password, dbms, driver_name, database_name, port
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
  query <- sprintf("select %s from %s", field, table)
  res <- DBI::dbGetQuery(con, query)
  pool::poolClose(con)
  res
}

#' Identify queries or tables names from the user supplied string
#'
#' @param src the user supplied string. This is usually an SQL query or a table
#'    name or a combination of both.
#' @param tables the list of all tables in the database
#'
#' @return a list with the identified queries and tables
#' @keywords internal
#' @noRd
#'
#' @examples
#' test <- identify_tables_and_queries(
#'   src    = "select * from author",
#'   tables = c("author", "karim")
#' )
identify_tables_and_queries <- function(src,
                                        tables) {
  # detect the SQL queries
  # I assume that a query will contain at least 'select' and 'from' or both of
  # them
  queries <- table_names <- NULL
  for (s in src) {
    if (grepl("select", s, fixed = TRUE) || grepl("from", s, fixed = TRUE)) {
      queries <- c(queries, s)
    } else {
      if (s %in% tables) {
        table_names <- c(table_names, s)
      }
    }
  }
  list(
    queries = queries,
    tables  = table_names
  )
}
