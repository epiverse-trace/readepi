
<!-- README.md is generated from README.Rmd. Please edit that file -->

# readepi

*readepi* provides functions for importing epidemiological data into
**R** from common *health information systems*.

<!-- badges: start -->

[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R-CMD-check](https://github.com/epiverse-trace/readepi/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/epiverse-trace/readepi/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/epiverse-trace/readepi/branch/main/graph/badge.svg)](https://app.codecov.io/gh/epiverse-trace/readepi?branch=main)
[![lifecycle-concept](https://raw.githubusercontent.com/reconverse/reconverse.github.io/master/images/badge-concept.svg)](https://www.reconverse.org/lifecycle.html#concept)
<!-- badges: end -->

## Installation

You can install the development version of readepi from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
#devtools::install_github("epiverse-trace/readepi", build_vignettes = TRUE)
suppressPackageStartupMessages(library(readepi))
```

## Vignette

``` r
browseVignettes("readepi")
```

# Reading data from file or directory

The **readepi()** function can read read data from various source
including various file formats. It is based on the **rio** R package,
hence can import data from all file format supported by that one. See
[here](https://cran.r-project.org/web/packages/rio/vignettes/rio.html)
for more details about the file formats allowed by `rio`.  
Additionally, it can read in data from a space-separated file or read
specific or all files from a specified directory. When reading data from
file or directory, the function expects the following arguments:  
`file.path`: the path to the file to be read. When several files need to
be imported from a directory, this should be the path to that
directory,  
`sep`: the separator between the columns in the file. This is only
required for space-separated files,  
`format`: a string used to specify the file format. This is useful when
a file does not have an extension, or has a file extension that does not
match its actual type,  
`which`: which a string used to specify which objects should be
extracted (e.g. the name of the excel sheet to import),  
`pattern`: when specified, only files with this suffix will be imported
from the specified directory.  
The function will return either a data frame (if import from file) or a
list of data frames (if several files were imported from a directory).

## importing data from JSON file

``` r
file = system.file("extdata", "test.json", package = "readepi")
data = readepi(file.path = file)
```

## importing data from excel file with 2 sheets

here we are importing from the second excel sheet

``` r
file = system.file("extdata", "test.xlsx", package = "readepi")
data = readepi(file.path = file, which = "Sheet2")
```

## importing data from several files in a directory

``` r
# reading all files in the given directory
dir.path = "inst/extdata"
data = readepi(file.path = dir.path)

# reading only txt files
data = readepi(file.path = dir.path, pattern = "txt")
```

# Reading data from relational database management systems (RDBMS): HDSS, EMRS, REDCap

Research data are usually stored in either relational databases or NoSQL
databases. At the MRCG, project data are stored in relational databases.
The HDSS and EMRS host databases that run under MS SQL Server, while
REDCap (that uses an EAV schema) run under a MySQL server.  
To import data from a HDSS or EMRS (MS SQL Server) into R, some
dependencies need to be installed first.

## installation of dependencies

If you are using a Unix-based system, you will need to install the MS
ODBC driver that is compatible with the version of the target MS SQL
server. For **SQL server 2019, version 15.0**, we installed **ODBC
Driver 17 for SQL Server** on the mac OS. This is compatible with the
MRCG test server `robin.mrc.gm`. Details about how to install a driver
can be found
[here](https://learn.microsoft.com/en-us/sql/connect/odbc/linux-mac/install-microsoft-odbc-driver-sql-server-macos?view=sql-server-ver15).  
Once installed, the list of drivers can be displayed in R using:
`odbc::odbcListDrivers()`.  
It is important to view the data that is stored in the MS SQL server. I
recommend to install a GUI such as `Azure Data Studio`.

## importing data from RDBMS into R

For testing purpose, we were given access to the test server
`robin.mrc.gm`. Users should be granted with read access to be able to
pull data from the test server.  
The **read_epi()** function can read data from the above RDBMS. It
expects the following arguments:  
`credentials.file`: the path to the file with the user-specific
credential details for the projects of interest. This is a tab-delimited
file with the following columns:

- user_name: the user name,  
- password: the user password (for REDCap, this corresponds to the
  **token** that serves as password to the project),  
- host_name: the host name (for HDSS and EMRS) or the URI (for
  REDCap),  
- project_id: the project ID (for REDCap) or the name of the database
  (for HDSS and EMRS) you are access to,  
- comment: a summary description about the project or database of
  interest,  
- dbms: the name of the DBMS: ‘redcap’ or ‘REDCap’ when reading from
  REDCap, ‘sqlserver’ or ‘SQLServer’ when reading from MS SQL Server,  
- port: the port ID (used for MS SQL Servers only).  
  `project.id` for relational DB, this is the name of the database that
  contains the table from which the data should be pulled. Otherwise, it
  is the project ID you were given access to. Note that this should be
  similar to the value of the **project_id** field in the credential
  file.  
  `driver.name` the name of the MS driver (only for HDSS and EMRS). use
  `odbc::odbcListDrivers()` to display the list of installed drivers,  
  `table.name`: the name of the target table (only for HDSS and EMRS),  
  `records`: a vector or a comma-separated string of a subset of subject
  IDs. When specified, only the records that correspond to these
  subjects will be imported,  
  `fields`: a vector or a comma-separated string of column names. If
  provided, only those columns will be imported,  
  `id.position`: the column position of the variable that unique
  identifies the subjects. This should only be specified when the column
  with the subject IDs is not the first column. default is 1.

The function returns a list with 2 data frames (data and metadata) when
reading from REDCap. A data frame otherwise.

### importing from REDCap

we were given access to the
\*\*Pats\_\_Covid_19_Cohort_1\_Screening\*\*.

``` r
# display the structure of the credentials file
show_example_file()
# credentials.file = system.file("extdata", "test.ini", package = "readepi")

# reading all fields and records the project
data = readepi(credentials.file, project.id="Pats__Covid_19_Cohort_1_Screening")
project.data = data$data
project.metadeta = data$metadata

# reading specified fields and all records from the project
fields = c("day_1_q_ran_id","redcap_event_name","day_1_q_1a","day_1_q_1b","day_1_q_1c","day_1_q_1","day_1_q_2","day_1_q_3","day_1_q_4","day_1_q_5")
data = readepi(credentials.file, project.id="Pats__Covid_19_Cohort_1_Screening", fields = fields)

# reading specified records and all fields from the project
records = c("C10001/3","C10002/1","C10003/7","C10004/5","C10005/9","C10006/8","C10007/6","C10008/4","C10009/2","C10010/1")
data = readepi(credentials.file, project.id="Pats__Covid_19_Cohort_1_Screening", records =  records)

# reading specified records and fields from the project
data = readepi(credentials.file, project.id="Pats__Covid_19_Cohort_1_Screening", records =  records, fields = fields)
```

### importing from HDSS or EMRS

#### show list of tables in the database

To show the list of tables in the database of interest:

``` r
showTables(credentials.file=system.file("extdata", "test.ini", package = "readepi"), project.id="IBS_BHDSS", driver.name="ODBC Driver 17 for SQL Server")
#>   [1] "account_books"                                           
#>   [2] "account_books_definitions"                               
#>   [3] "account_currencies"                                      
#>   [4] "account_journals"                                        
#>   [5] "account_ledgers"                                         
#>   [6] "account_snapshots"                                       
#>   [7] "account_transactions"                                    
#>   [8] "accounts"                                                
#>   [9] "base_notifications"                                      
#>  [10] "bo_archive_reports"                                      
#>  [11] "bo_archive_widgets"                                      
#>  [12] "bo_console_actions"                                      
#>  [13] "bo_consoles"                                             
#>  [14] "bo_custom_actions"                                       
#>  [15] "bo_custom_apps"                                          
#>  [16] "bo_custom_wizards"                                       
#>  [17] "bo_data_sets"                                            
#>  [18] "bo_definitions"                                          
#>  [19] "bo_filters"                                              
#>  [20] "bo_import_schemes"                                       
#>  [21] "bo_journal_logs"                                         
#>  [22] "bo_journal_templates"                                    
#>  [23] "bo_namespace_keys"                                       
#>  [24] "bo_plugins"                                              
#>  [25] "bo_references"                                           
#>  [26] "calendar_entries"                                        
#>  [27] "calendar_events"                                         
#>  [28] "ClusterList"                                             
#>  [29] "collections"                                             
#>  [30] "compound_updates"                                        
#>  [31] "compounds"                                               
#>  [32] "contact_records"                                         
#>  [33] "contacts"                                                
#>  [34] "data_supervisors"                                        
#>  [35] "deliveries"                                              
#>  [36] "document_dispatches"                                     
#>  [37] "document_keywords"                                       
#>  [38] "document_keywords_documents"                             
#>  [39] "document_series"                                         
#>  [40] "dss_events"                                              
#>  [41] "dtproperties"                                            
#>  [42] "dynamic_contents"                                        
#>  [43] "education_levels"                                        
#>  [44] "engine_schema_info"                                      
#>  [45] "episodes"                                                
#>  [46] "event_follow_throughs"                                   
#>  [47] "event_loop_triggers"                                     
#>  [48] "extensions"                                              
#>  [49] "facility_workers"                                        
#>  [50] "field_workers"                                           
#>  [51] "file_packets"                                            
#>  [52] "file_versions"                                           
#>  [53] "files"                                                   
#>  [54] "health_facilities"                                       
#>  [55] "household_updates"                                       
#>  [56] "households"                                              
#>  [57] "individual_updates"                                      
#>  [58] "individuals"                                             
#>  [59] "keyword_dictionaries"                                    
#>  [60] "kiosk_consoles"                                          
#>  [61] "mail_conversations"                                      
#>  [62] "mail_expressions"                                        
#>  [63] "mail_filters"                                            
#>  [64] "mail_messages"                                           
#>  [65] "mail_prefs"                                              
#>  [66] "meta_data"                                               
#>  [67] "model_accessors"                                         
#>  [68] "notes"                                                   
#>  [69] "process_automaton_trackers"                              
#>  [70] "process_automatons"                                      
#>  [71] "profiles"                                                
#>  [72] "pwd_complexities"                                        
#>  [73] "pwd_replacement_logs"                                    
#>  [74] "rch_clinics"                                             
#>  [75] "RCHbyVillage"                                            
#>  [76] "registrations"                                           
#>  [77] "residential_eligibilities"                               
#>  [78] "rounds"                                                  
#>  [79] "schema_migrations"                                       
#>  [80] "screenings"                                              
#>  [81] "section1_verbal_autopsies"                               
#>  [82] "section10_verbal_autopsies"                              
#>  [83] "section11_va_adults"                                     
#>  [84] "section11_verbal_autopsies"                              
#>  [85] "section2_verbal_autopsies"                               
#>  [86] "section3_verbal_autopsies"                               
#>  [87] "section4_va_neonates"                                    
#>  [88] "section4_verbal_autopsies"                               
#>  [89] "section5_va_neonates"                                    
#>  [90] "section5_verbal_autopsies"                               
#>  [91] "section6_va_neonates"                                    
#>  [92] "section6_verbal_autopsies"                               
#>  [93] "section7_va_adults"                                      
#>  [94] "section7_va_children"                                    
#>  [95] "section8_va_children"                                    
#>  [96] "section8_va_neonates"                                    
#>  [97] "section9_va_adults"                                      
#>  [98] "section9_verbal_autopsies"                               
#>  [99] "sessions"                                                
#> [100] "settlements"                                             
#> [101] "social_groups"                                           
#> [102] "socio_economic_surveys"                                  
#> [103] "static_resource_permissions"                             
#> [104] "survey_groups"                                           
#> [105] "survey_logs"                                             
#> [106] "sysdiagrams"                                             
#> [107] "task_documents"                                          
#> [108] "task_lists"                                              
#> [109] "tasks"                                                   
#> [110] "tbl_AllinOne_Cur_HHD"                                    
#> [111] "tbl_DSSVacDetails"                                       
#> [112] "tbl_DSSVacdetails_backup"                                
#> [113] "tbl_popcountbyYear"                                      
#> [114] "tbl_RoundProgressByVillage"                              
#> [115] "UpdateMotherID"                                          
#> [116] "upp"                                                     
#> [117] "users"                                                   
#> [118] "va_observations"                                         
#> [119] "vacc_details_old_forms"                                  
#> [120] "vaccination_details"                                     
#> [121] "vaccination_health_cards"                                
#> [122] "vaccine_visit_infos"                                     
#> [123] "verbal_autopsies"                                        
#> [124] "village_updates"                                         
#> [125] "villages"                                                
#> [126] "web_file_publications"                                   
#> [127] "work_flow_stages"                                        
#> [128] "work_flows"                                              
#> [129] "trace_xe_action_map"                                     
#> [130] "trace_xe_event_map"                                      
#> [131] "AllinOne_Cur_HHD"                                        
#> [132] "AllinOne_Cur_HHD_p"                                      
#> [133] "AllinOne_Curr"                                           
#> [134] "AllInOneNew"                                             
#> [135] "AllInOneNewForVIDAControl"                               
#> [136] "CurrentPopByAgeStrata"                                   
#> [137] "CurrentPopByVillageByAgeStrata"                          
#> [138] "DSSVaccinationInfo"                                      
#> [139] "EthnicityCount"                                          
#> [140] "ForVIDAControl11111"                                     
#> [141] "IndividualLinkWithResEpisode"                            
#> [142] "MultipleActiveResident"                                  
#> [143] "PopByVillages"                                           
#> [144] "Qry_DSS_EXT_DTHList4Search"                              
#> [145] "QryHouseholdHeadsOus"                                    
#> [146] "RoundProgress"                                           
#> [147] "RoundUpdateProgressByRegion"                             
#> [148] "tblBirthEvent"                                           
#> [149] "tblDeathEvent"                                           
#> [150] "tblHouseholdHeadEpisode"                                 
#> [151] "tblHouseholdHeadEpisode_WideFormat"                      
#> [152] "tblIndividual"                                           
#> [153] "tblInMigration"                                          
#> [154] "tblInmigration_WideFormat"                               
#> [155] "tblOutMigration"                                         
#> [156] "tblOutMigration_WideFormat"                              
#> [157] "tblPregnancyEpisode"                                     
#> [158] "tblPregnancyEpisode_WideFormat"                          
#> [159] "tblregion"                                               
#> [160] "tblRelationship2HH"                                      
#> [161] "tblRelationshipEpisode"                                  
#> [162] "tblRelationshipEpisode_WideFormat"                       
#> [163] "tblResidentEpisode"                                      
#> [164] "tblResidentEpisode_WideFormat"                           
#> [165] "TotalBirthAndDeathByYear"                                
#> [166] "U5EthnicityCount"                                        
#> [167] "CHECK_CONSTRAINTS"                                       
#> [168] "COLUMN_DOMAIN_USAGE"                                     
#> [169] "COLUMN_PRIVILEGES"                                       
#> [170] "COLUMNS"                                                 
#> [171] "CONSTRAINT_COLUMN_USAGE"                                 
#> [172] "CONSTRAINT_TABLE_USAGE"                                  
#> [173] "DOMAIN_CONSTRAINTS"                                      
#> [174] "DOMAINS"                                                 
#> [175] "KEY_COLUMN_USAGE"                                        
#> [176] "PARAMETERS"                                              
#> [177] "REFERENTIAL_CONSTRAINTS"                                 
#> [178] "ROUTINE_COLUMNS"                                         
#> [179] "ROUTINES"                                                
#> [180] "SCHEMATA"                                                
#> [181] "SEQUENCES"                                               
#> [182] "TABLE_CONSTRAINTS"                                       
#> [183] "TABLE_PRIVILEGES"                                        
#> [184] "TABLES"                                                  
#> [185] "VIEW_COLUMN_USAGE"                                       
#> [186] "VIEW_TABLE_USAGE"                                        
#> [187] "VIEWS"                                                   
#> [188] "all_columns"                                             
#> [189] "all_objects"                                             
#> [190] "all_parameters"                                          
#> [191] "all_sql_modules"                                         
#> [192] "all_views"                                               
#> [193] "allocation_units"                                        
#> [194] "assemblies"                                              
#> [195] "assembly_files"                                          
#> [196] "assembly_modules"                                        
#> [197] "assembly_references"                                     
#> [198] "assembly_types"                                          
#> [199] "asymmetric_keys"                                         
#> [200] "availability_databases_cluster"                          
#> [201] "availability_group_listener_ip_addresses"                
#> [202] "availability_group_listeners"                            
#> [203] "availability_groups"                                     
#> [204] "availability_groups_cluster"                             
#> [205] "availability_read_only_routing_lists"                    
#> [206] "availability_replicas"                                   
#> [207] "backup_devices"                                          
#> [208] "certificates"                                            
#> [209] "change_tracking_databases"                               
#> [210] "change_tracking_tables"                                  
#> [211] "check_constraints"                                       
#> [212] "column_encryption_key_values"                            
#> [213] "column_encryption_keys"                                  
#> [214] "column_master_keys"                                      
#> [215] "column_store_dictionaries"                               
#> [216] "column_store_row_groups"                                 
#> [217] "column_store_segments"                                   
#> [218] "column_type_usages"                                      
#> [219] "column_xml_schema_collection_usages"                     
#> [220] "columns"                                                 
#> [221] "computed_columns"                                        
#> [222] "configurations"                                          
#> [223] "conversation_endpoints"                                  
#> [224] "conversation_groups"                                     
#> [225] "conversation_priorities"                                 
#> [226] "credentials"                                             
#> [227] "crypt_properties"                                        
#> [228] "cryptographic_providers"                                 
#> [229] "data_spaces"                                             
#> [230] "database_audit_specification_details"                    
#> [231] "database_audit_specifications"                           
#> [232] "database_automatic_tuning_mode"                          
#> [233] "database_automatic_tuning_options"                       
#> [234] "database_credentials"                                    
#> [235] "database_files"                                          
#> [236] "database_filestream_options"                             
#> [237] "database_mirroring"                                      
#> [238] "database_mirroring_endpoints"                            
#> [239] "database_mirroring_witnesses"                            
#> [240] "database_permissions"                                    
#> [241] "database_principals"                                     
#> [242] "database_query_store_options"                            
#> [243] "database_recovery_status"                                
#> [244] "database_role_members"                                   
#> [245] "database_scoped_configurations"                          
#> [246] "database_scoped_credentials"                             
#> [247] "databases"                                               
#> [248] "default_constraints"                                     
#> [249] "destination_data_spaces"                                 
#> [250] "dm_audit_actions"                                        
#> [251] "dm_audit_class_type_map"                                 
#> [252] "dm_broker_activated_tasks"                               
#> [253] "dm_broker_connections"                                   
#> [254] "dm_broker_forwarded_messages"                            
#> [255] "dm_broker_queue_monitors"                                
#> [256] "dm_cache_hit_stats"                                      
#> [257] "dm_cache_size"                                           
#> [258] "dm_cache_stats"                                          
#> [259] "dm_cdc_errors"                                           
#> [260] "dm_cdc_log_scan_sessions"                                
#> [261] "dm_clr_appdomains"                                       
#> [262] "dm_clr_loaded_assemblies"                                
#> [263] "dm_clr_properties"                                       
#> [264] "dm_clr_tasks"                                            
#> [265] "dm_cluster_endpoints"                                    
#> [266] "dm_column_encryption_enclave"                            
#> [267] "dm_column_encryption_enclave_operation_stats"            
#> [268] "dm_column_store_object_pool"                             
#> [269] "dm_cryptographic_provider_properties"                    
#> [270] "dm_database_encryption_keys"                             
#> [271] "dm_db_column_store_row_group_operational_stats"          
#> [272] "dm_db_column_store_row_group_physical_stats"             
#> [273] "dm_db_data_pools"                                        
#> [274] "dm_db_external_language_stats"                           
#> [275] "dm_db_external_script_execution_stats"                   
#> [276] "dm_db_file_space_usage"                                  
#> [277] "dm_db_fts_index_physical_stats"                          
#> [278] "dm_db_index_usage_stats"                                 
#> [279] "dm_db_log_space_usage"                                   
#> [280] "dm_db_mirroring_auto_page_repair"                        
#> [281] "dm_db_mirroring_connections"                             
#> [282] "dm_db_mirroring_past_actions"                            
#> [283] "dm_db_missing_index_details"                             
#> [284] "dm_db_missing_index_group_stats"                         
#> [285] "dm_db_missing_index_group_stats_query"                   
#> [286] "dm_db_missing_index_groups"                              
#> [287] "dm_db_partition_stats"                                   
#> [288] "dm_db_persisted_sku_features"                            
#> [289] "dm_db_rda_migration_status"                              
#> [290] "dm_db_rda_schema_update_status"                          
#> [291] "dm_db_script_level"                                      
#> [292] "dm_db_session_space_usage"                               
#> [293] "dm_db_storage_pools"                                     
#> [294] "dm_db_task_space_usage"                                  
#> [295] "dm_db_tuning_recommendations"                            
#> [296] "dm_db_uncontained_entities"                              
#> [297] "dm_db_xtp_checkpoint_files"                              
#> [298] "dm_db_xtp_checkpoint_internals"                          
#> [299] "dm_db_xtp_checkpoint_stats"                              
#> [300] "dm_db_xtp_gc_cycle_stats"                                
#> [301] "dm_db_xtp_hash_index_stats"                              
#> [302] "dm_db_xtp_index_stats"                                   
#> [303] "dm_db_xtp_memory_consumers"                              
#> [304] "dm_db_xtp_nonclustered_index_stats"                      
#> [305] "dm_db_xtp_object_stats"                                  
#> [306] "dm_db_xtp_table_memory_stats"                            
#> [307] "dm_db_xtp_transactions"                                  
#> [308] "dm_distributed_exchange_stats"                           
#> [309] "dm_exec_background_job_queue"                            
#> [310] "dm_exec_background_job_queue_stats"                      
#> [311] "dm_exec_cached_plans"                                    
#> [312] "dm_exec_compute_node_errors"                             
#> [313] "dm_exec_compute_node_status"                             
#> [314] "dm_exec_compute_nodes"                                   
#> [315] "dm_exec_compute_pools"                                   
#> [316] "dm_exec_connections"                                     
#> [317] "dm_exec_distributed_request_steps"                       
#> [318] "dm_exec_distributed_requests"                            
#> [319] "dm_exec_distributed_sql_requests"                        
#> [320] "dm_exec_dms_services"                                    
#> [321] "dm_exec_dms_workers"                                     
#> [322] "dm_exec_external_operations"                             
#> [323] "dm_exec_external_work"                                   
#> [324] "dm_exec_function_stats"                                  
#> [325] "dm_exec_procedure_stats"                                 
#> [326] "dm_exec_query_memory_grants"                             
#> [327] "dm_exec_query_optimizer_info"                            
#> [328] "dm_exec_query_optimizer_memory_gateways"                 
#> [329] "dm_exec_query_parallel_workers"                          
#> [330] "dm_exec_query_profiles"                                  
#> [331] "dm_exec_query_resource_semaphores"                       
#> [332] "dm_exec_query_stats"                                     
#> [333] "dm_exec_query_transformation_stats"                      
#> [334] "dm_exec_requests"                                        
#> [335] "dm_exec_session_wait_stats"                              
#> [336] "dm_exec_sessions"                                        
#> [337] "dm_exec_trigger_stats"                                   
#> [338] "dm_exec_valid_use_hints"                                 
#> [339] "dm_external_script_execution_stats"                      
#> [340] "dm_external_script_requests"                             
#> [341] "dm_external_script_resource_usage_stats"                 
#> [342] "dm_filestream_file_io_handles"                           
#> [343] "dm_filestream_file_io_requests"                          
#> [344] "dm_filestream_non_transacted_handles"                    
#> [345] "dm_fts_active_catalogs"                                  
#> [346] "dm_fts_fdhosts"                                          
#> [347] "dm_fts_index_population"                                 
#> [348] "dm_fts_memory_buffers"                                   
#> [349] "dm_fts_memory_pools"                                     
#> [350] "dm_fts_outstanding_batches"                              
#> [351] "dm_fts_population_ranges"                                
#> [352] "dm_fts_semantic_similarity_population"                   
#> [353] "dm_hadr_ag_threads"                                      
#> [354] "dm_hadr_auto_page_repair"                                
#> [355] "dm_hadr_automatic_seeding"                               
#> [356] "dm_hadr_availability_group_states"                       
#> [357] "dm_hadr_availability_replica_cluster_nodes"              
#> [358] "dm_hadr_availability_replica_cluster_states"             
#> [359] "dm_hadr_availability_replica_states"                     
#> [360] "dm_hadr_cluster"                                         
#> [361] "dm_hadr_cluster_members"                                 
#> [362] "dm_hadr_cluster_networks"                                
#> [363] "dm_hadr_database_replica_cluster_states"                 
#> [364] "dm_hadr_database_replica_states"                         
#> [365] "dm_hadr_db_threads"                                      
#> [366] "dm_hadr_instance_node_map"                               
#> [367] "dm_hadr_name_id_map"                                     
#> [368] "dm_hadr_physical_seeding_stats"                          
#> [369] "dm_hpc_device_stats"                                     
#> [370] "dm_hpc_thread_proxy_stats"                               
#> [371] "dm_io_backup_tapes"                                      
#> [372] "dm_io_cluster_shared_drives"                             
#> [373] "dm_io_cluster_valid_path_names"                          
#> [374] "dm_io_pending_io_requests"                               
#> [375] "dm_logpool_hashentries"                                  
#> [376] "dm_logpool_stats"                                        
#> [377] "dm_os_buffer_descriptors"                                
#> [378] "dm_os_buffer_pool_extension_configuration"               
#> [379] "dm_os_child_instances"                                   
#> [380] "dm_os_cluster_nodes"                                     
#> [381] "dm_os_cluster_properties"                                
#> [382] "dm_os_dispatcher_pools"                                  
#> [383] "dm_os_dispatchers"                                       
#> [384] "dm_os_enumerate_fixed_drives"                            
#> [385] "dm_os_host_info"                                         
#> [386] "dm_os_hosts"                                             
#> [387] "dm_os_job_object"                                        
#> [388] "dm_os_latch_stats"                                       
#> [389] "dm_os_loaded_modules"                                    
#> [390] "dm_os_memory_allocations"                                
#> [391] "dm_os_memory_broker_clerks"                              
#> [392] "dm_os_memory_brokers"                                    
#> [393] "dm_os_memory_cache_clock_hands"                          
#> [394] "dm_os_memory_cache_counters"                             
#> [395] "dm_os_memory_cache_entries"                              
#> [396] "dm_os_memory_cache_hash_tables"                          
#> [397] "dm_os_memory_clerks"                                     
#> [398] "dm_os_memory_node_access_stats"                          
#> [399] "dm_os_memory_nodes"                                      
#> [400] "dm_os_memory_objects"                                    
#> [401] "dm_os_memory_pools"                                      
#> [402] "dm_os_nodes"                                             
#> [403] "dm_os_performance_counters"                              
#> [404] "dm_os_process_memory"                                    
#> [405] "dm_os_ring_buffers"                                      
#> [406] "dm_os_schedulers"                                        
#> [407] "dm_os_server_diagnostics_log_configurations"             
#> [408] "dm_os_spinlock_stats"                                    
#> [409] "dm_os_stacks"                                            
#> [410] "dm_os_sublatches"                                        
#> [411] "dm_os_sys_info"                                          
#> [412] "dm_os_sys_memory"                                        
#> [413] "dm_os_tasks"                                             
#> [414] "dm_os_threads"                                           
#> [415] "dm_os_virtual_address_dump"                              
#> [416] "dm_os_wait_stats"                                        
#> [417] "dm_os_waiting_tasks"                                     
#> [418] "dm_os_windows_info"                                      
#> [419] "dm_os_worker_local_storage"                              
#> [420] "dm_os_workers"                                           
#> [421] "dm_pal_cpu_stats"                                        
#> [422] "dm_pal_disk_stats"                                       
#> [423] "dm_pal_net_stats"                                        
#> [424] "dm_pal_processes"                                        
#> [425] "dm_pal_spinlock_stats"                                   
#> [426] "dm_pal_vm_stats"                                         
#> [427] "dm_pal_wait_stats"                                       
#> [428] "dm_qn_subscriptions"                                     
#> [429] "dm_repl_articles"                                        
#> [430] "dm_repl_schemas"                                         
#> [431] "dm_repl_tranhash"                                        
#> [432] "dm_repl_traninfo"                                        
#> [433] "dm_resource_governor_configuration"                      
#> [434] "dm_resource_governor_external_resource_pool_affinity"    
#> [435] "dm_resource_governor_external_resource_pools"            
#> [436] "dm_resource_governor_resource_pool_affinity"             
#> [437] "dm_resource_governor_resource_pool_volumes"              
#> [438] "dm_resource_governor_resource_pools"                     
#> [439] "dm_resource_governor_workload_groups"                    
#> [440] "dm_server_audit_status"                                  
#> [441] "dm_server_memory_dumps"                                  
#> [442] "dm_server_registry"                                      
#> [443] "dm_server_services"                                      
#> [444] "dm_tcp_listener_states"                                  
#> [445] "dm_tran_aborted_transactions"                            
#> [446] "dm_tran_active_snapshot_database_transactions"           
#> [447] "dm_tran_active_transactions"                             
#> [448] "dm_tran_commit_table"                                    
#> [449] "dm_tran_current_snapshot"                                
#> [450] "dm_tran_current_transaction"                             
#> [451] "dm_tran_database_transactions"                           
#> [452] "dm_tran_global_recovery_transactions"                    
#> [453] "dm_tran_global_transactions"                             
#> [454] "dm_tran_global_transactions_enlistments"                 
#> [455] "dm_tran_global_transactions_log"                         
#> [456] "dm_tran_locks"                                           
#> [457] "dm_tran_persistent_version_store"                        
#> [458] "dm_tran_persistent_version_store_stats"                  
#> [459] "dm_tran_session_transactions"                            
#> [460] "dm_tran_top_version_generators"                          
#> [461] "dm_tran_transactions_snapshot"                           
#> [462] "dm_tran_version_store"                                   
#> [463] "dm_tran_version_store_space_usage"                       
#> [464] "dm_xe_map_values"                                        
#> [465] "dm_xe_object_columns"                                    
#> [466] "dm_xe_objects"                                           
#> [467] "dm_xe_packages"                                          
#> [468] "dm_xe_session_event_actions"                             
#> [469] "dm_xe_session_events"                                    
#> [470] "dm_xe_session_object_columns"                            
#> [471] "dm_xe_session_targets"                                   
#> [472] "dm_xe_sessions"                                          
#> [473] "dm_xtp_gc_queue_stats"                                   
#> [474] "dm_xtp_gc_stats"                                         
#> [475] "dm_xtp_system_memory_consumers"                          
#> [476] "dm_xtp_threads"                                          
#> [477] "dm_xtp_transaction_recent_rows"                          
#> [478] "dm_xtp_transaction_stats"                                
#> [479] "edge_constraint_clauses"                                 
#> [480] "edge_constraints"                                        
#> [481] "endpoint_webmethods"                                     
#> [482] "endpoints"                                               
#> [483] "event_notification_event_types"                          
#> [484] "event_notifications"                                     
#> [485] "events"                                                  
#> [486] "extended_procedures"                                     
#> [487] "extended_properties"                                     
#> [488] "external_data_sources"                                   
#> [489] "external_file_formats"                                   
#> [490] "external_language_files"                                 
#> [491] "external_languages"                                      
#> [492] "external_libraries"                                      
#> [493] "external_libraries_installed"                            
#> [494] "external_library_files"                                  
#> [495] "external_library_setup_errors"                           
#> [496] "external_table_columns"                                  
#> [497] "external_tables"                                         
#> [498] "filegroups"                                              
#> [499] "filetable_system_defined_objects"                        
#> [500] "filetables"                                              
#> [501] "foreign_key_columns"                                     
#> [502] "foreign_keys"                                            
#> [503] "fulltext_catalogs"                                       
#> [504] "fulltext_document_types"                                 
#> [505] "fulltext_index_catalog_usages"                           
#> [506] "fulltext_index_columns"                                  
#> [507] "fulltext_index_fragments"                                
#> [508] "fulltext_indexes"                                        
#> [509] "fulltext_languages"                                      
#> [510] "fulltext_semantic_language_statistics_database"          
#> [511] "fulltext_semantic_languages"                             
#> [512] "fulltext_stoplists"                                      
#> [513] "fulltext_stopwords"                                      
#> [514] "fulltext_system_stopwords"                               
#> [515] "function_order_columns"                                  
#> [516] "hash_indexes"                                            
#> [517] "http_endpoints"                                          
#> [518] "identity_columns"                                        
#> [519] "index_columns"                                           
#> [520] "index_resumable_operations"                              
#> [521] "indexes"                                                 
#> [522] "internal_partitions"                                     
#> [523] "internal_tables"                                         
#> [524] "key_constraints"                                         
#> [525] "key_encryptions"                                         
#> [526] "linked_logins"                                           
#> [527] "login_token"                                             
#> [528] "masked_columns"                                          
#> [529] "master_files"                                            
#> [530] "master_key_passwords"                                    
#> [531] "memory_optimized_tables_internal_attributes"             
#> [532] "message_type_xml_schema_collection_usages"               
#> [533] "messages"                                                
#> [534] "module_assembly_usages"                                  
#> [535] "numbered_procedure_parameters"                           
#> [536] "numbered_procedures"                                     
#> [537] "objects"                                                 
#> [538] "openkeys"                                                
#> [539] "parameter_type_usages"                                   
#> [540] "parameter_xml_schema_collection_usages"                  
#> [541] "parameters"                                              
#> [542] "partition_functions"                                     
#> [543] "partition_parameters"                                    
#> [544] "partition_range_values"                                  
#> [545] "partition_schemes"                                       
#> [546] "partitions"                                              
#> [547] "periods"                                                 
#> [548] "plan_guides"                                             
#> [549] "procedures"                                              
#> [550] "query_context_settings"                                  
#> [551] "query_store_plan"                                        
#> [552] "query_store_query"                                       
#> [553] "query_store_query_text"                                  
#> [554] "query_store_runtime_stats"                               
#> [555] "query_store_runtime_stats_interval"                      
#> [556] "query_store_wait_stats"                                  
#> [557] "registered_search_properties"                            
#> [558] "registered_search_property_lists"                        
#> [559] "remote_data_archive_databases"                           
#> [560] "remote_data_archive_tables"                              
#> [561] "remote_logins"                                           
#> [562] "remote_service_bindings"                                 
#> [563] "resource_governor_configuration"                         
#> [564] "resource_governor_external_resource_pool_affinity"       
#> [565] "resource_governor_external_resource_pools"               
#> [566] "resource_governor_resource_pool_affinity"                
#> [567] "resource_governor_resource_pools"                        
#> [568] "resource_governor_workload_groups"                       
#> [569] "routes"                                                  
#> [570] "schemas"                                                 
#> [571] "securable_classes"                                       
#> [572] "security_policies"                                       
#> [573] "security_predicates"                                     
#> [574] "selective_xml_index_namespaces"                          
#> [575] "selective_xml_index_paths"                               
#> [576] "sensitivity_classifications"                             
#> [577] "sequences"                                               
#> [578] "server_assembly_modules"                                 
#> [579] "server_audit_specification_details"                      
#> [580] "server_audit_specifications"                             
#> [581] "server_audits"                                           
#> [582] "server_event_notifications"                              
#> [583] "server_event_session_actions"                            
#> [584] "server_event_session_events"                             
#> [585] "server_event_session_fields"                             
#> [586] "server_event_session_targets"                            
#> [587] "server_event_sessions"                                   
#> [588] "server_events"                                           
#> [589] "server_file_audits"                                      
#> [590] "server_memory_optimized_hybrid_buffer_pool_configuration"
#> [591] "server_permissions"                                      
#> [592] "server_principal_credentials"                            
#> [593] "server_principals"                                       
#> [594] "server_role_members"                                     
#> [595] "server_sql_modules"                                      
#> [596] "server_trigger_events"                                   
#> [597] "server_triggers"                                         
#> [598] "servers"                                                 
#> [599] "service_broker_endpoints"                                
#> [600] "service_contract_message_usages"                         
#> [601] "service_contract_usages"                                 
#> [602] "service_contracts"                                       
#> [603] "service_message_types"                                   
#> [604] "service_queue_usages"                                    
#> [605] "service_queues"                                          
#> [606] "services"                                                
#> [607] "soap_endpoints"                                          
#> [608] "spatial_index_tessellations"                             
#> [609] "spatial_indexes"                                         
#> [610] "spatial_reference_systems"                               
#> [611] "sql_dependencies"                                        
#> [612] "sql_expression_dependencies"                             
#> [613] "sql_feature_restrictions"                                
#> [614] "sql_logins"                                              
#> [615] "sql_modules"                                             
#> [616] "stats"                                                   
#> [617] "stats_columns"                                           
#> [618] "symmetric_keys"                                          
#> [619] "synonyms"                                                
#> [620] "sysaltfiles"                                             
#> [621] "syscacheobjects"                                         
#> [622] "syscharsets"                                             
#> [623] "syscolumns"                                              
#> [624] "syscomments"                                             
#> [625] "sysconfigures"                                           
#> [626] "sysconstraints"                                          
#> [627] "syscscontainers"                                         
#> [628] "syscurconfigs"                                           
#> [629] "syscursorcolumns"                                        
#> [630] "syscursorrefs"                                           
#> [631] "syscursors"                                              
#> [632] "syscursortables"                                         
#> [633] "sysdatabases"                                            
#> [634] "sysdepends"                                              
#> [635] "sysdevices"                                              
#> [636] "sysfilegroups"                                           
#> [637] "sysfiles"                                                
#> [638] "sysforeignkeys"                                          
#> [639] "sysfulltextcatalogs"                                     
#> [640] "sysindexes"                                              
#> [641] "sysindexkeys"                                            
#> [642] "syslanguages"                                            
#> [643] "syslockinfo"                                             
#> [644] "syslogins"                                               
#> [645] "sysmembers"                                              
#> [646] "sysmessages"                                             
#> [647] "sysobjects"                                              
#> [648] "sysoledbusers"                                           
#> [649] "sysopentapes"                                            
#> [650] "sysperfinfo"                                             
#> [651] "syspermissions"                                          
#> [652] "sysprocesses"                                            
#> [653] "sysprotects"                                             
#> [654] "sysreferences"                                           
#> [655] "sysremotelogins"                                         
#> [656] "sysservers"                                              
#> [657] "system_columns"                                          
#> [658] "system_components_surface_area_configuration"            
#> [659] "system_internals_allocation_units"                       
#> [660] "system_internals_partition_columns"                      
#> [661] "system_internals_partitions"                             
#> [662] "system_objects"                                          
#> [663] "system_parameters"                                       
#> [664] "system_sql_modules"                                      
#> [665] "system_views"                                            
#> [666] "systypes"                                                
#> [667] "sysusers"                                                
#> [668] "table_types"                                             
#> [669] "tables"                                                  
#> [670] "tcp_endpoints"                                           
#> [671] "time_zone_info"                                          
#> [672] "trace_categories"                                        
#> [673] "trace_columns"                                           
#> [674] "trace_event_bindings"                                    
#> [675] "trace_events"                                            
#> [676] "trace_subclass_values"                                   
#> [677] "traces"                                                  
#> [678] "transmission_queue"                                      
#> [679] "trigger_event_types"                                     
#> [680] "trigger_events"                                          
#> [681] "triggers"                                                
#> [682] "trusted_assemblies"                                      
#> [683] "type_assembly_usages"                                    
#> [684] "types"                                                   
#> [685] "user_token"                                              
#> [686] "via_endpoints"                                           
#> [687] "views"                                                   
#> [688] "xml_indexes"                                             
#> [689] "xml_schema_attributes"                                   
#> [690] "xml_schema_collections"                                  
#> [691] "xml_schema_component_placements"                         
#> [692] "xml_schema_components"                                   
#> [693] "xml_schema_elements"                                     
#> [694] "xml_schema_facets"                                       
#> [695] "xml_schema_model_groups"                                 
#> [696] "xml_schema_namespaces"                                   
#> [697] "xml_schema_types"                                        
#> [698] "xml_schema_wildcard_namespaces"                          
#> [699] "xml_schema_wildcards"
```

#### importing data

``` r
# reading all fields and all records from one table (`dss_events`)
data = readepi(credentials.file, project.id="IBS_BHDSS", driver.name = "ODBC Driver 17 for SQL Server", table.name = "dss_events")

# reading specified fields and all records from one table
data = readepi(credentials.file, project.id="IBS_BHDSS", driver.name = "ODBC Driver 17 for SQL Server", table.name = "dss_events", fields = fields)

# reading specified records and all fields from one table
data = readepi(credentials.file, project.id="IBS_BHDSS", driver.name = "ODBC Driver 17 for SQL Server", table.name = "dss_events", records = records)

# reading specified fields and records one the table
data = readepi(credentials.file, project.id="IBS_BHDSS", driver.name = "ODBC Driver 17 for SQL Server", table.name = "dss_events", records = records, fields = fields)

# reading data from several tables
table.names = "accounts,account_books,account_currencies" #can also be table.names = c("account"s,"account_books","account_currencies")
data = readepi(credentials.file, project.id="IBS_BHDSS", driver.name = "ODBC Driver 17 for SQL Server", table.name = table.names)

# reading data from several tables and subsetting fields across tables
table.names = "accounts,account_books,account_currencies" #can also be table.names = c("account"s,"account_books","account_currencies")
#note that first string in the field vector corresponds to names to be subset from the first table specified in the `table.name` argument  
fields = c("id,name,balance,created_by", "id,status,name", "id,name")
data = readepi(credentials.file, project.id="IBS_BHDSS", driver.name = "ODBC Driver 17 for SQL Server", table.name = table.names, fields = fields)

# reading data from several tables and subsetting records across tables 
#note that first string in the records vector corresponds to the subject ID to be subset from the first table specified in the `table.name` argument and so on... When the ID column is not the first column in a table, use the `id.position` 
records = c("3,8,13", "1,2,3", "1")
data = readepi(credentials.file, project.id="IBS_BHDSS", driver.name = "ODBC Driver 17 for SQL Server", table.name = table.names, records = records)

# reading data from several tables and subsetting records and fields across tables 
fields = c("id,name,balance,created_by", "id,status,name", "id,name")
records = c("3,8,13", "1,2,3", "1")
data = readepi(credentials.file, project.id="IBS_BHDSS", driver.name = "ODBC Driver 17 for SQL Server", table.name = table.names, records = records, fields = fields)
```

# Processing the genomic data

To account for the genomic data in the analysis, our suggested input
file format is: [FASTQ](https://en.wikipedia.org/wiki/FASTQ_format)
format. This is a common file format in the field of
**Bioinformatics**.  
The `readepi` package contains functions that can perform genome
assembly on genomic sequences from [nanopore](https://nanoporetech.com)
as well as [illumina](https://www.illumina.com) platform.  
It also contains a function for **clade assignment** using both
[nextclade](https://clades.nextstrain.org/) and
[pangolin](https://cov-lineages.org/resources/pangolin.html).  
Currently, these function can only be run on a **Linux system** or **Mac
OS**.

## Genome assembly of nanopore reads

Nanopore sequences are assembled using the
[ARTIC](https://artic.network/ncov-2019/ncov2019-bioinformatics-sop.html)
pipeline. After creating the **conda environment** for ARTIC, use the
function `genome_assembly()` with the following parameters:

- `input.dir`: the path to the folder with the input fastq files. Each
  sample/barcode will have a directory in this folder,  
- `assembly.dir`: the path to the folder where the output files from the
  genome assembly will be stored,  
- `consensus.fasta.dir`: the path to the folder where the merged
  consensus fasta file will be stored. That file is the one that will be
  used for the subsequent analysis,  
- `num.samples`: the number of samples in the dataset. This will serve
  for the parallelisation purpose to speed up the genome assembly
  process,  
- `device`: the name of the nanopore sequencing device (either *MinION*
  or *PromethION*),  
- `partition`: the partition name. Only set this when running on a HPC,
  default is NULL.

### Genome assembly of nanopore reads on PC (Mac OS or linux system)

``` r
genome_assembly(input.dir="/Users/karimmane/Documents/Karim/LSHTM/TRACE_dev/Genomic_data/Covadis", 
                assembly.dir="/Users/karimmane/Documents/Karim/LSHTM/TRACE_dev/Genomic_data/genome_assembly", 
                consensus.fasta.dir="/Users/karimmane/Documents/Karim/LSHTM/TRACE_dev/Genomic_data/consensus_dir", 
                num.samples=60, 
                device="MinION", 
                partition=NULL)
```

### Genome assembly of nanopore reads on HPC

``` r
genome_assembly(input.dir="/nfsscratch/Karim/LSHTM/Covadis", 
                assembly.dir="/nfsscratch/Karim/LSHTM/assembly_results", 
                consensus.fasta.dir="/nfsscratch/Karim/LSHTM/consensus_dir", 
                num.samples=60, 
                device="MinION", 
                partition="standard")
```

## Genome assembly of illumina reads

## Clade assignment

After generating the consensus genome for each samples and merging them
into a single file (this is done by the step above), the clade
assignment can be performed using the `clade_assignment()`. This
function assumes that both **nextclade** and **pangolin** are installed
using **conda**. The `clade_assignment()` function needs arguments
below:

- `merged.fasta`: path to the fasta file with the sequences from all
  samples. This corresponds to file in the folder specified by the
  `consensus.fasta.dir` argument in the genome assembly step,  
- `output.dir`: path to the folder where the clade assignment results
  will be stored.

``` r
clade_assignment(merged.fasta="/Users/karimmane/Documents/Karim/LSHTM/TRACE_dev/Genomic_data/consensu_dir/consensus_genomes.fasta", 
                 output.dir="/Users/karimmane/Documents/Karim/LSHTM/TRACE_dev/Genomic_data/clade_assignment")
```

## Development

### Lifecycle

This package is currently a *concept*, as defined by the [RECON software
lifecycle](https://www.reconverse.org/lifecycle.html). This means that
essential features and mechanisms are still being developed, and the
package is not ready for use outside of the development team.

### Contributions

Contributions are welcome via [pull
requests](https://github.com/epiverse-trace/readepi/pulls).

Contributors to the project include:

- Karim Mané (author)
- Thibaut Jombart (author)

### Code of Conduct

Please note that the linelist project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
