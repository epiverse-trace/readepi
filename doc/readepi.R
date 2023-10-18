## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk[["set"]](collapse = TRUE, comment = "#>", eval = FALSE,
                           fig.width = 7L, fig.height = 7L, message = FALSE,
                           fig.align = "center", warning = FALSE, dpi = 300L)
row_id <- group_id <- NULL

## ----setup, eval=TRUE---------------------------------------------------------
# LOAD readepi
library("readepi") # nolint

## ----eval=FALSE---------------------------------------------------------------
#  odbc::odbcListDrivers()

## ----eval=TRUE----------------------------------------------------------------
# DISPLAY THE STRUCTURE OF THE TEMPLATE CREDENTIALS FILE
show_example_file()

## ----eval=TRUE----------------------------------------------------------------
# DEFINING THE PATH TO THE TEMPLATE CREDENTIALS FILE
credentials_file <- system.file("extdata", "test.ini", package = "readepi")

## ----eval=FALSE---------------------------------------------------------------
#  show_tables(
#    data_source      = "mysql-rfam-public.ebi.ac.uk",
#    credentials_file = credentials_file,
#    driver_name      = ""
#  )
#  # use driver_name = "ODBC Driver 17 for SQL Server" when reading from MS SQL
#  # server

## ----eval=FALSE---------------------------------------------------------------
#  # VISUALIZING THE FIRST 5 ROWS OF THE TABLE 'author'
#  visualise_table(
#    data_source      = "mysql-rfam-public.ebi.ac.uk",
#    credentials_file = credentials_file,
#    from             = "author", # this is the table name
#    driver_name      = ""
#  )
#  
#  # READING ALL FIELDS AND ALL RECORDS FROM ONE TABLE (`author`)
#  dat <- readepi(
#    data_source      = "mysql-rfam-public.ebi.ac.uk",
#    credentials_file = credentials_file,
#    from             = "author", # this is the table name
#    driver_name      = ""
#  )
#  
#  # READING SPECIFIED FIELDS AND ALL RECORDS FROM ONE TABLE
#  fields <- "author_id,name,last_name,initials"
#  dat    <- readepi(
#    data_source      = "mysql-rfam-public.ebi.ac.uk",
#    credentials_file = credentials_file,
#    from             = "author", # this is the table name
#    driver_name      = "",
#    fields           = fields # these are  the columns of interest.
#  )
#  
#  # READING SPECIFIED RECORDS AND ALL FIELDS FROM ONE TABLE
#  records <- "1, 34, 15, 70, 118, 20"
#  dat     <- readepi(
#    data_source      = "mysql-rfam-public.ebi.ac.uk",
#    credentials_file = credentials_file,
#    from             = "author", # this is the table name
#    driver_name      = "",
#    records          = records,
#    id_position      = 1L
#  )
#  
#  # READING SPECIFIED FIELDS AND RECORDS ONE THE TABLE
#  dat <- readepi(
#    data_source      = "mysql-rfam-public.ebi.ac.uk",
#    credentials_file = credentials_file,
#    from             = "author", # this is the table name
#    driver_name      = "",
#    records          = records,
#    fields           = fields,
#    id_col_name      = "author_id"
#  )
#  
#  # READING DATA FROM SEVERAL TABLES
#  table_names <- c("author", "family_author")
#  dat <- readepi(
#    data_source      = "mysql-rfam-public.ebi.ac.uk",
#    credentials_file = credentials_file,
#    from             = table_names, # this is the table name
#    driver_name      = ""
#  )
#  
#  # READING DATA FROM SEVERAL TABLES AND SUBSETTING FIELDS ACROSS TABLES
#  fields <- c(
#    "author_id,name,last_name,initials",
#    "rfam_acc,author_id"
#  )
#  # the first string in the field vector corresponds to the name of the
#  # columns of interest from the first table specified in the `table_names`
#  # argument and so on...
#  dat <- readepi(
#    data_source      = "mysql-rfam-public.ebi.ac.uk",
#    credentials_file = credentials_file,
#    from             = table_names, # this is the table name
#    driver_name      = "",
#    fields           = fields
#  )
#  
#  # READING DATA FROM SEVERAL TABLES AND SUBSETTING RECORDS ACROSS TABLES
#  records <- c(
#    "1, 34, 15, 70, 118, 20",
#    "RF00591,RF01420,RF01421"
#  )
#  # "note that first string in the records vector corresponds to the records of
#  # interest from the first table specified in the `table_name` argument and so
#  # on... when the id column is not the first column in a table,
#  # use the `id_position`"
#  dat <- readepi(
#    data_source      = "mysql-rfam-public.ebi.ac.uk",
#    credentials_file = credentials_file,
#    from             = table_names, # this is the table name
#    driver_name      = "",
#    records          = records,
#    id_position      = c(1, 1) # nolint
#  )
#  
#  # READING DATA FROM SEVERAL TABLES AND SUBSETTING RECORDS AND FIELDS ACROSS
#  # TABLES
#  dat <- readepi(
#    data_source      = "mysql-rfam-public.ebi.ac.uk",
#    credentials_file = credentials_file,
#    from             = table_names, # this is the table name
#    driver_name      = "",
#    records          = records,
#    fields           = fields,
#    id_col_name      = c("author_id", "rfam_acc")
#  )

## ----eval=FALSE---------------------------------------------------------------
#  # SELECT FEW COLUMNS FROM ONE TABLE AND LEFT JOIN WITH ANOTHER TABLE
#  dat <- readepi(
#    data_source      = "mysql-rfam-public.ebi.ac.uk",
#    credentials_file = credentials_file,
#    from             = "select author.author_id, author.name,
#    family_author.author_id from author left join family_author on
#    author.author_id = family_author.author_id",
#    driver_name      = ""
#  )
#  
#  # SELECT ALL DATA FROM THE author TABLE
#  dat <- readepi(
#    data_source      = "mysql-rfam-public.ebi.ac.uk",
#    credentials_file = credentials_file,
#    from             = "select * from author",
#    driver_name      = ""
#  )
#  
#  # SELECT FEW COLUMNS FROM THE author TABLE
#  dat <- readepi(
#    data_source      = "mysql-rfam-public.ebi.ac.uk",
#    credentials_file = credentials_file,
#    from             = "select author_id, name, last_name from author",
#    driver_name      = ""
#  )
#  
#  # SELECT FEW RECORDS FROM THE author TABLE
#  dat <- readepi(
#    data_source = "mysql-rfam-public.ebi.ac.uk",
#    credentials_file = credentials_file,
#    source = "select * from author where author_id in ('1','20','50')",
#    driver_name = ""
#  )
#  
#  # SELECT FEW RECORDS AND FIELDS FROM THE author TABLE
#  dat <- readepi(
#    data_source      = "mysql-rfam-public.ebi.ac.uk",
#    credentials_file = credentials_file,
#    from             = "select author_id, name, last_name from author where
#    author_id in ('1','20','50')",
#    driver_name      = ""
#  )

## ----eval=FALSE---------------------------------------------------------------
#  # READING ALL FIELDS AND RECORDS FROM A REDCap PROJECT
#  dat <- readepi(
#    data_source      = "https://bbmc.ouhsc.edu/redcap/api/",
#    credentials_file = credentials_file
#  )
#  project_data <- dat[["data"]]
#  project_metadeta <- dat[["metadata"]]
#  
#  # READING SPECIFIC FIELDS AND ALL RECORDS FROM THE PROJECT
#  fields <- c("record_id", "name_first", "age", "bmi")
#  dat <- readepi(
#    data_source      = "https://bbmc.ouhsc.edu/redcap/api/",
#    credentials_file = credentials_file,
#    fields           = fields
#  )
#  
#  # READING SPECIFIC RECORDS AND ALL FIELDS FROM THE PROJECT
#  records <- c("1", "3", "5")
#  dat <- readepi(
#    data_source      = "https://bbmc.ouhsc.edu/redcap/api/",
#    credentials_file = credentials_file,
#    records          = records,
#    id_col_name      = "record_id"
#  )
#  
#  # READING SPECIFIC RECORDS AND FIELDS FROM THE PROJECT
#  dat <- readepi(
#    data_source      = "https://bbmc.ouhsc.edu/redcap/api/",
#    credentials_file = credentials_file,
#    records          = records,
#    fields           = fields,
#    id_col_name      = "record_id"
#  )
#  project_data <- dat[["data"]]
#  project_metadeta <- dat[["metadata"]]

## ----eval=FALSE---------------------------------------------------------------
#  # GETTING THE DATA ELEMENT IDENTIFIERS AND NAMES
#  data_elements <- get_dhis2_attributes(
#    base_url = "https://play.dhis2.org/dev/",
#    username = "admin",
#    password = "district",
#    which    = "dataElements"
#  )
#  
#  # GETTING THE DATASET IDENTIFIERS AND NAMES
#  datasets <- get_dhis2_attributes(
#    base_url = "https://play.dhis2.org/dev/",
#    username = "admin",
#    password = "district",
#    which    = "dataSets"
#  )
#  
#  # GETTING THE ORGANISATION UNIT IDENTIFIERS AND NAMES
#  organisation_units <- get_dhis2_attributes(
#    base_url = "https://play.dhis2.org/dev/",
#    username = "admin",
#    password = "district",
#    which    = "organisationUnits"
#  )
#  
#  # GETTING THE DATA ELEMENT GROUP IDENTIFIERS AND NAMES
#  data_element_groups <- get_dhis2_attributes(
#    base_url = "https://play.dhis2.org/dev/",
#    username = "admin",
#    password = "district",
#    which    = "dataElementGroups"
#  )
#  
#  # READING THE DATASET ID `pBOMPrpg1QX`
#  dat <- readepi(
#    data_source        = "https://play.dhis2.org/dev",
#    credentials_file   = credentials_file,
#    dataset            = "pBOMPrpg1QX",
#    organisation_unit  = "DiszpKrYNg8",
#    data_element_group = NULL,
#    start_date         = "2014",
#    end_date           = "2023"
#  )
#  
#  # READING DATA FROM 2 DATASETS `pBOMPrpg1QX`
#  dat <- readepi(
#    data_source        = "https://play.dhis2.org/dev",
#    credentials_file   = credentials_file,
#    dataset            = "pBOMPrpg1QX,BfMAe6Itzgt",
#    organisation_unit  = "DiszpKrYNg8",
#    data_element_group = NULL,
#    start_date         = "2014",
#    end_date           = "2023"
#  )
#  
#  # READING SPECIFIC DATA ELEMENTS FROM THE DATASET ID `pBOMPrpg1QX`
#  data_elts <- c("FTRrcoaog83", "eY5ehpbEsB7", "Ix2HsbDMLea")
#  dat <- readepi(
#    data_source        = "https://play.dhis2.org/dev",
#    credentials_file   = credentials_file,
#    dataset            = "pBOMPrpg1QX",
#    organisation_unit  = "DiszpKrYNg8",
#    data_element_group = NULL,
#    start_date         = "2014",
#    end_date           = "2023",
#    records            = data_elts,
#    id_col_name        = "dataElement"
#  )
#  
#  # READING SPECIFIC COLUMNS FROM A DATASET
#  dat <- readepi(
#    data_source        = "https://play.dhis2.org/dev",
#    credentials_file   = credentials_file,
#    dataset            = "pBOMPrpg1QX,BfMAe6Itzgt",
#    organisation_unit  = "DiszpKrYNg8",
#    data_element_group = NULL,
#    start_date         = "2014",
#    end_date           = "2023",
#    fields             = c("dataElement", "period", "value")
#  )
#  test_data <- data[["data"]]

## ----eval=FALSE---------------------------------------------------------------
#  # GET THE INFORMATION ABOUT THE INDICATOR PROFILES, DOMAIN, AREA TYPE, ...
#  metadata <- get_fingertips_metadata()
#  head(metadata[["indicator_profile_domain"]])
#  head(metadata[["indicator_ids_names"]])
#  head(metadata[["area_type"]])
#  
#  # IMPORTING DATA USING THE INDICATOR ID
#  dat <- readepi(
#    indicator_id = 90362L,
#    area_type_id = 202L
#  )
#  
#  # IMPORTING DATA USING THE INDICATOR NAME
#  dat <- readepi(
#    indicator_name = "Healthy life expectancy at birth",
#    area_type_id   = 202L
#  )
#  
#  # IMPORTING DATA USING THE DOMAIN NAME
#  dat <- readepi(
#    domain_name  = "A. Overarching indicators",
#    area_type_id = 202L
#  )
#  
#  dat <- readepi(
#    indicator_name = "Healthy life expectancy at birth",
#    area_type_id   = 202L,
#    domain_name    = "A. Overarching indicators"
#  )
#  
#  # IMPORTING DATA USING THE PROFILE ID
#  dat <- readepi(
#    profile_id   = 19L,
#    area_type_id = 202L
#  )
#  
#  # IMPORTING DATA FROM SPECIFIC INDICATOR, DOMAIN, PROFILE, AREA TYPE
#  dat <- readepi(
#    indicator_id        = 90362L,
#    indicator_name      = "Healthy life expectancy at birth",
#    area_type_id        = 202L,
#    parent_area_type_id = 6L,
#    profile_id          = 19L,
#    profile_name        = "Public Health Outcomes Framework",
#    domain_id           = 1000049L,
#    domain_name         = "A. Overarching indicators",
#    fields              = NULL,
#    records             = NULL,
#    id_position         = NULL,
#    id_col_name         = NULL
#  )
#  
#  # IMPORTING DATA AND SUBSETTING SPECIFIC RECORDS AND FIELDS
#  dat <- readepi(
#    indicator_id = 90362L,
#    area_type_id = 202L,
#    fields       = c("IndicatorID", "AreaCode", "Age", "Value"),
#    records      = c("E92000001", "E12000002", "E12000009"),
#    id_col_name  = "AreaCode"
#  )

