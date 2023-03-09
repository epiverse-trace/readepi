
<!-- README.md is generated from README.Rmd. Please edit that file -->

# readepi

*readepi* provides functions for importing data into **R** from files
and common *health information systems*.

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
# devtools::install_github("epiverse-trace/readepi@develop", build_vignettes = TRUE)
suppressPackageStartupMessages(library(readepi))
```

## Importing data in R

The `readepi()` function allows importing data from several file types
and database management systems. These include:

- all file formats in the
  [rio](https://cran.r-project.org/web/packages/rio/vignettes/rio.html)
  package.  
- file formats that are not accounted for by `rio`  
- REDCap  
- relational database management systems (RDBMS)  
- DHIS2

### Importing data from files

``` r
# READING DATA FROM JSON file
file <- system.file("extdata", "test.json", package = "readepi")
data <- readepi(file.path = file)
#> Loading required namespace: jsonlite

# IMPORTING DATA FROM THE SECOND EXCEL SHEET
file <- system.file("extdata", "test.xlsx", package = "readepi")
data <- readepi(file.path = file, which = "Sheet2")
#> New names:
#> • `var1` -> `var1...2`
#> • `var1` -> `var1...3`

# IMPORTING DATA FROM THE FIRST AND SECOND EXCEL SHEETS
file <- system.file("extdata", "test.xlsx", package = "readepi")
data <- readepi(file.path = file, which = c("Sheet2", "Sheet1"))
#> New names:
#> • `var1` -> `var1...2`
#> • `var1` -> `var1...3`
#> New names:
#> • `var1` -> `var1...2`
#> • `var1` -> `var1...3`
```

### Importing data from several files in a directory

``` r
# READING ALL FILES IN A GIVEN DIRECTOR
dir.path <- "inst/extdata"
data <- readepi(file.path = dir.path)
#> New names:
#> • `var1` -> `var1...2`
#> • `var1` -> `var1...3`

# READING ONLY '.txt' FILES
data <- readepi(file.path = dir.path, pattern = ".txt")

# READING '.txt' and '.xlsx' FILES
data <- readepi(file.path = dir.path, pattern = c(".txt", ".xlsx"))
#> New names:
#> • `var1` -> `var1...2`
#> • `var1` -> `var1...3`
```

### Importing data from DBMS

This requires the users to:

1.  install the MS SQL driver that is compatible with their SQL server
    version. Details about this installation process can be found in the
    **vignette**.  
2.  create a credentials file where the credential will be stored. Use
    the `show_example_file()` to see a template of this file.

``` r
# DISPLAY THE STRUCTURE OF THE CREDENTIALS FILE
show_example_file()
#>    user_name                         password
#> 1:     kmane                 Dakabantang@KD23
#> 2:     kmane 9D71857D60F4016AB7BFFDA65970D737
#> 3:     kmane                 Dakabantang@KD23
#>                                 host_name                        project_id
#> 1:                           robin.mrc.gm                         IBS_BHDSS
#> 2: https://redcap.mrc.gm:8443/redcap/api/ Pats__Covid_19_Cohort_1_Screening
#> 3:                           robin.mrc.gm                            CS_OPD
#>                             comment      dbms port
#> 1:                this is a HDSS DB SQLServer 1433
#> 2: testing access to REDCap project    REDCap   NA
#> 3:               this is an EMRS DB SQLServer 1433

# DEFINING THE CREDENTIALS FILE
credentials.file <- system.file("extdata", "test.ini", package = "readepi")

# READING ALL FIELDS AND RECORDS FROM A REDCap PROJECT
data <- readepi(
  credentials.file = credentials.file,
  project.id = "Pats__Covid_19_Cohort_1_Screening"
)
#> Starting to read 280 records  at 2023-03-09 20:39:15.
#> 
#> ── Column specification ────────────────────────────────────────────────────────
#> cols(
#>   .default = col_double(),
#>   day_1_q_ran_id = col_character(),
#>   redcap_event_name = col_character(),
#>   day_1_q_1a = col_character(),
#>   day_1_q_1b = col_character(),
#>   day_1_q_1c = col_character(),
#>   day_1_q_1 = col_character(),
#>   day_1_q_2 = col_datetime(format = ""),
#>   day_1_q_4 = col_character(),
#>   day_1_q_6c = col_character(),
#>   day_1_oth_spc_vac = col_logical(),
#>   day_1_q_9e = col_date(format = ""),
#>   day_1_9hi = col_character(),
#>   day_1_q_9f_2 = col_date(format = ""),
#>   day_1_q_11 = col_time(format = ""),
#>   day_1_q_14 = col_character(),
#>   day_1_q_16 = col_character(),
#>   day_1_q_16a = col_character(),
#>   day_1_q_16d = col_character(),
#>   day_1_q_17 = col_character(),
#>   day_1_q_17a = col_character()
#>   # ... with 509 more columns
#> )
#> ℹ Use `spec()` for the full column specifications.
project.data <- data$data
project.metadeta <- data$metadata

# DISPLAY THE LIST OF ALL TABLES IN A DATABASE HOSTED BY AN SQL SERVER
show_tables(
  credentials.file = credentials.file,
  project.id = "IBS_BHDSS",
  driver.name = "ODBC Driver 17 for SQL Server"
)
#> account_books
#> account_books_definitions
#> account_currencies
#> account_journals
#> account_ledgers
#> account_snapshots
#> account_transactions
#> accounts
#> base_notifications
#> bo_archive_reports
#> bo_archive_widgets
#> bo_console_actions
#> bo_consoles
#> bo_custom_actions
#> bo_custom_apps
#> bo_custom_wizards
#> bo_data_sets
#> bo_definitions
#> bo_filters
#> bo_import_schemes
#> bo_journal_logs
#> bo_journal_templates
#> bo_namespace_keys
#> bo_plugins
#> bo_references
#> calendar_entries
#> calendar_events
#> ClusterList
#> collections
#> compound_updates
#> compounds
#> contact_records
#> contacts
#> data_supervisors
#> deliveries
#> document_dispatches
#> document_keywords
#> document_keywords_documents
#> document_series
#> dss_events
#> dtproperties
#> dynamic_contents
#> education_levels
#> engine_schema_info
#> episodes
#> event_follow_throughs
#> event_loop_triggers
#> extensions
#> facility_workers
#> field_workers
#> file_packets
#> file_versions
#> files
#> health_facilities
#> household_updates
#> households
#> individual_updates
#> individuals
#> keyword_dictionaries
#> kiosk_consoles
#> mail_conversations
#> mail_expressions
#> mail_filters
#> mail_messages
#> mail_prefs
#> meta_data
#> model_accessors
#> notes
#> process_automaton_trackers
#> process_automatons
#> profiles
#> pwd_complexities
#> pwd_replacement_logs
#> rch_clinics
#> RCHbyVillage
#> registrations
#> residential_eligibilities
#> rounds
#> schema_migrations
#> screenings
#> section1_verbal_autopsies
#> section10_verbal_autopsies
#> section11_va_adults
#> section11_verbal_autopsies
#> section2_verbal_autopsies
#> section3_verbal_autopsies
#> section4_va_neonates
#> section4_verbal_autopsies
#> section5_va_neonates
#> section5_verbal_autopsies
#> section6_va_neonates
#> section6_verbal_autopsies
#> section7_va_adults
#> section7_va_children
#> section8_va_children
#> section8_va_neonates
#> section9_va_adults
#> section9_verbal_autopsies
#> sessions
#> settlements
#> social_groups
#> socio_economic_surveys
#> static_resource_permissions
#> survey_groups
#> survey_logs
#> sysdiagrams
#> task_documents
#> task_lists
#> tasks
#> tbl_AllinOne_Cur_HHD
#> tbl_DSSVacDetails
#> tbl_DSSVacdetails_backup
#> tbl_popcountbyYear
#> tbl_RoundProgressByVillage
#> UpdateMotherID
#> upp
#> users
#> va_observations
#> vacc_details_old_forms
#> vaccination_details
#> vaccination_health_cards
#> vaccine_visit_infos
#> verbal_autopsies
#> village_updates
#> villages
#> web_file_publications
#> work_flow_stages
#> work_flows
#> trace_xe_action_map
#> trace_xe_event_map
#> AllinOne_Cur_HHD
#> AllinOne_Cur_HHD_p
#> AllinOne_Curr
#> AllInOneNew
#> AllInOneNewForVIDAControl
#> CurrentPopByAgeStrata
#> CurrentPopByVillageByAgeStrata
#> DSSVaccinationInfo
#> EthnicityCount
#> ForVIDAControl11111
#> IndividualLinkWithResEpisode
#> MultipleActiveResident
#> PopByVillages
#> Qry_DSS_EXT_DTHList4Search
#> QryHouseholdHeadsOus
#> RoundProgress
#> RoundUpdateProgressByRegion
#> tblBirthEvent
#> tblDeathEvent
#> tblHouseholdHeadEpisode
#> tblHouseholdHeadEpisode_WideFormat
#> tblIndividual
#> tblInMigration
#> tblInmigration_WideFormat
#> tblOutMigration
#> tblOutMigration_WideFormat
#> tblPregnancyEpisode
#> tblPregnancyEpisode_WideFormat
#> tblregion
#> tblRelationship2HH
#> tblRelationshipEpisode
#> tblRelationshipEpisode_WideFormat
#> tblResidentEpisode
#> tblResidentEpisode_WideFormat
#> TotalBirthAndDeathByYear
#> U5EthnicityCount
#> CHECK_CONSTRAINTS
#> COLUMN_DOMAIN_USAGE
#> COLUMN_PRIVILEGES
#> COLUMNS
#> CONSTRAINT_COLUMN_USAGE
#> CONSTRAINT_TABLE_USAGE
#> DOMAIN_CONSTRAINTS
#> DOMAINS
#> KEY_COLUMN_USAGE
#> PARAMETERS
#> REFERENTIAL_CONSTRAINTS
#> ROUTINE_COLUMNS
#> ROUTINES
#> SCHEMATA
#> SEQUENCES
#> TABLE_CONSTRAINTS
#> TABLE_PRIVILEGES
#> TABLES
#> VIEW_COLUMN_USAGE
#> VIEW_TABLE_USAGE
#> VIEWS
#> all_columns
#> all_objects
#> all_parameters
#> all_sql_modules
#> all_views
#> allocation_units
#> assemblies
#> assembly_files
#> assembly_modules
#> assembly_references
#> assembly_types
#> asymmetric_keys
#> availability_databases_cluster
#> availability_group_listener_ip_addresses
#> availability_group_listeners
#> availability_groups
#> availability_groups_cluster
#> availability_read_only_routing_lists
#> availability_replicas
#> backup_devices
#> certificates
#> change_tracking_databases
#> change_tracking_tables
#> check_constraints
#> column_encryption_key_values
#> column_encryption_keys
#> column_master_keys
#> column_store_dictionaries
#> column_store_row_groups
#> column_store_segments
#> column_type_usages
#> column_xml_schema_collection_usages
#> columns
#> computed_columns
#> configurations
#> conversation_endpoints
#> conversation_groups
#> conversation_priorities
#> credentials
#> crypt_properties
#> cryptographic_providers
#> data_spaces
#> database_audit_specification_details
#> database_audit_specifications
#> database_automatic_tuning_mode
#> database_automatic_tuning_options
#> database_credentials
#> database_files
#> database_filestream_options
#> database_mirroring
#> database_mirroring_endpoints
#> database_mirroring_witnesses
#> database_permissions
#> database_principals
#> database_query_store_options
#> database_recovery_status
#> database_role_members
#> database_scoped_configurations
#> database_scoped_credentials
#> databases
#> default_constraints
#> destination_data_spaces
#> dm_audit_actions
#> dm_audit_class_type_map
#> dm_broker_activated_tasks
#> dm_broker_connections
#> dm_broker_forwarded_messages
#> dm_broker_queue_monitors
#> dm_cache_hit_stats
#> dm_cache_size
#> dm_cache_stats
#> dm_cdc_errors
#> dm_cdc_log_scan_sessions
#> dm_clr_appdomains
#> dm_clr_loaded_assemblies
#> dm_clr_properties
#> dm_clr_tasks
#> dm_cluster_endpoints
#> dm_column_encryption_enclave
#> dm_column_encryption_enclave_operation_stats
#> dm_column_store_object_pool
#> dm_cryptographic_provider_properties
#> dm_database_encryption_keys
#> dm_db_column_store_row_group_operational_stats
#> dm_db_column_store_row_group_physical_stats
#> dm_db_data_pools
#> dm_db_external_language_stats
#> dm_db_external_script_execution_stats
#> dm_db_file_space_usage
#> dm_db_fts_index_physical_stats
#> dm_db_index_usage_stats
#> dm_db_log_space_usage
#> dm_db_mirroring_auto_page_repair
#> dm_db_mirroring_connections
#> dm_db_mirroring_past_actions
#> dm_db_missing_index_details
#> dm_db_missing_index_group_stats
#> dm_db_missing_index_group_stats_query
#> dm_db_missing_index_groups
#> dm_db_partition_stats
#> dm_db_persisted_sku_features
#> dm_db_rda_migration_status
#> dm_db_rda_schema_update_status
#> dm_db_script_level
#> dm_db_session_space_usage
#> dm_db_storage_pools
#> dm_db_task_space_usage
#> dm_db_tuning_recommendations
#> dm_db_uncontained_entities
#> dm_db_xtp_checkpoint_files
#> dm_db_xtp_checkpoint_internals
#> dm_db_xtp_checkpoint_stats
#> dm_db_xtp_gc_cycle_stats
#> dm_db_xtp_hash_index_stats
#> dm_db_xtp_index_stats
#> dm_db_xtp_memory_consumers
#> dm_db_xtp_nonclustered_index_stats
#> dm_db_xtp_object_stats
#> dm_db_xtp_table_memory_stats
#> dm_db_xtp_transactions
#> dm_distributed_exchange_stats
#> dm_exec_background_job_queue
#> dm_exec_background_job_queue_stats
#> dm_exec_cached_plans
#> dm_exec_compute_node_errors
#> dm_exec_compute_node_status
#> dm_exec_compute_nodes
#> dm_exec_compute_pools
#> dm_exec_connections
#> dm_exec_distributed_request_steps
#> dm_exec_distributed_requests
#> dm_exec_distributed_sql_requests
#> dm_exec_dms_services
#> dm_exec_dms_workers
#> dm_exec_external_operations
#> dm_exec_external_work
#> dm_exec_function_stats
#> dm_exec_procedure_stats
#> dm_exec_query_memory_grants
#> dm_exec_query_optimizer_info
#> dm_exec_query_optimizer_memory_gateways
#> dm_exec_query_parallel_workers
#> dm_exec_query_profiles
#> dm_exec_query_resource_semaphores
#> dm_exec_query_stats
#> dm_exec_query_transformation_stats
#> dm_exec_requests
#> dm_exec_session_wait_stats
#> dm_exec_sessions
#> dm_exec_trigger_stats
#> dm_exec_valid_use_hints
#> dm_external_script_execution_stats
#> dm_external_script_requests
#> dm_external_script_resource_usage_stats
#> dm_filestream_file_io_handles
#> dm_filestream_file_io_requests
#> dm_filestream_non_transacted_handles
#> dm_fts_active_catalogs
#> dm_fts_fdhosts
#> dm_fts_index_population
#> dm_fts_memory_buffers
#> dm_fts_memory_pools
#> dm_fts_outstanding_batches
#> dm_fts_population_ranges
#> dm_fts_semantic_similarity_population
#> dm_hadr_ag_threads
#> dm_hadr_auto_page_repair
#> dm_hadr_automatic_seeding
#> dm_hadr_availability_group_states
#> dm_hadr_availability_replica_cluster_nodes
#> dm_hadr_availability_replica_cluster_states
#> dm_hadr_availability_replica_states
#> dm_hadr_cluster
#> dm_hadr_cluster_members
#> dm_hadr_cluster_networks
#> dm_hadr_database_replica_cluster_states
#> dm_hadr_database_replica_states
#> dm_hadr_db_threads
#> dm_hadr_instance_node_map
#> dm_hadr_name_id_map
#> dm_hadr_physical_seeding_stats
#> dm_hpc_device_stats
#> dm_hpc_thread_proxy_stats
#> dm_io_backup_tapes
#> dm_io_cluster_shared_drives
#> dm_io_cluster_valid_path_names
#> dm_io_pending_io_requests
#> dm_logpool_hashentries
#> dm_logpool_stats
#> dm_os_buffer_descriptors
#> dm_os_buffer_pool_extension_configuration
#> dm_os_child_instances
#> dm_os_cluster_nodes
#> dm_os_cluster_properties
#> dm_os_dispatcher_pools
#> dm_os_dispatchers
#> dm_os_enumerate_fixed_drives
#> dm_os_host_info
#> dm_os_hosts
#> dm_os_job_object
#> dm_os_latch_stats
#> dm_os_loaded_modules
#> dm_os_memory_allocations
#> dm_os_memory_broker_clerks
#> dm_os_memory_brokers
#> dm_os_memory_cache_clock_hands
#> dm_os_memory_cache_counters
#> dm_os_memory_cache_entries
#> dm_os_memory_cache_hash_tables
#> dm_os_memory_clerks
#> dm_os_memory_node_access_stats
#> dm_os_memory_nodes
#> dm_os_memory_objects
#> dm_os_memory_pools
#> dm_os_nodes
#> dm_os_performance_counters
#> dm_os_process_memory
#> dm_os_ring_buffers
#> dm_os_schedulers
#> dm_os_server_diagnostics_log_configurations
#> dm_os_spinlock_stats
#> dm_os_stacks
#> dm_os_sublatches
#> dm_os_sys_info
#> dm_os_sys_memory
#> dm_os_tasks
#> dm_os_threads
#> dm_os_virtual_address_dump
#> dm_os_wait_stats
#> dm_os_waiting_tasks
#> dm_os_windows_info
#> dm_os_worker_local_storage
#> dm_os_workers
#> dm_pal_cpu_stats
#> dm_pal_disk_stats
#> dm_pal_net_stats
#> dm_pal_processes
#> dm_pal_spinlock_stats
#> dm_pal_vm_stats
#> dm_pal_wait_stats
#> dm_qn_subscriptions
#> dm_repl_articles
#> dm_repl_schemas
#> dm_repl_tranhash
#> dm_repl_traninfo
#> dm_resource_governor_configuration
#> dm_resource_governor_external_resource_pool_affinity
#> dm_resource_governor_external_resource_pools
#> dm_resource_governor_resource_pool_affinity
#> dm_resource_governor_resource_pool_volumes
#> dm_resource_governor_resource_pools
#> dm_resource_governor_workload_groups
#> dm_server_audit_status
#> dm_server_memory_dumps
#> dm_server_registry
#> dm_server_services
#> dm_tcp_listener_states
#> dm_tran_aborted_transactions
#> dm_tran_active_snapshot_database_transactions
#> dm_tran_active_transactions
#> dm_tran_commit_table
#> dm_tran_current_snapshot
#> dm_tran_current_transaction
#> dm_tran_database_transactions
#> dm_tran_global_recovery_transactions
#> dm_tran_global_transactions
#> dm_tran_global_transactions_enlistments
#> dm_tran_global_transactions_log
#> dm_tran_locks
#> dm_tran_persistent_version_store
#> dm_tran_persistent_version_store_stats
#> dm_tran_session_transactions
#> dm_tran_top_version_generators
#> dm_tran_transactions_snapshot
#> dm_tran_version_store
#> dm_tran_version_store_space_usage
#> dm_xe_map_values
#> dm_xe_object_columns
#> dm_xe_objects
#> dm_xe_packages
#> dm_xe_session_event_actions
#> dm_xe_session_events
#> dm_xe_session_object_columns
#> dm_xe_session_targets
#> dm_xe_sessions
#> dm_xtp_gc_queue_stats
#> dm_xtp_gc_stats
#> dm_xtp_system_memory_consumers
#> dm_xtp_threads
#> dm_xtp_transaction_recent_rows
#> dm_xtp_transaction_stats
#> edge_constraint_clauses
#> edge_constraints
#> endpoint_webmethods
#> endpoints
#> event_notification_event_types
#> event_notifications
#> events
#> extended_procedures
#> extended_properties
#> external_data_sources
#> external_file_formats
#> external_language_files
#> external_languages
#> external_libraries
#> external_libraries_installed
#> external_library_files
#> external_library_setup_errors
#> external_table_columns
#> external_tables
#> filegroups
#> filetable_system_defined_objects
#> filetables
#> foreign_key_columns
#> foreign_keys
#> fulltext_catalogs
#> fulltext_document_types
#> fulltext_index_catalog_usages
#> fulltext_index_columns
#> fulltext_index_fragments
#> fulltext_indexes
#> fulltext_languages
#> fulltext_semantic_language_statistics_database
#> fulltext_semantic_languages
#> fulltext_stoplists
#> fulltext_stopwords
#> fulltext_system_stopwords
#> function_order_columns
#> hash_indexes
#> http_endpoints
#> identity_columns
#> index_columns
#> index_resumable_operations
#> indexes
#> internal_partitions
#> internal_tables
#> key_constraints
#> key_encryptions
#> linked_logins
#> login_token
#> masked_columns
#> master_files
#> master_key_passwords
#> memory_optimized_tables_internal_attributes
#> message_type_xml_schema_collection_usages
#> messages
#> module_assembly_usages
#> numbered_procedure_parameters
#> numbered_procedures
#> objects
#> openkeys
#> parameter_type_usages
#> parameter_xml_schema_collection_usages
#> parameters
#> partition_functions
#> partition_parameters
#> partition_range_values
#> partition_schemes
#> partitions
#> periods
#> plan_guides
#> procedures
#> query_context_settings
#> query_store_plan
#> query_store_query
#> query_store_query_text
#> query_store_runtime_stats
#> query_store_runtime_stats_interval
#> query_store_wait_stats
#> registered_search_properties
#> registered_search_property_lists
#> remote_data_archive_databases
#> remote_data_archive_tables
#> remote_logins
#> remote_service_bindings
#> resource_governor_configuration
#> resource_governor_external_resource_pool_affinity
#> resource_governor_external_resource_pools
#> resource_governor_resource_pool_affinity
#> resource_governor_resource_pools
#> resource_governor_workload_groups
#> routes
#> schemas
#> securable_classes
#> security_policies
#> security_predicates
#> selective_xml_index_namespaces
#> selective_xml_index_paths
#> sensitivity_classifications
#> sequences
#> server_assembly_modules
#> server_audit_specification_details
#> server_audit_specifications
#> server_audits
#> server_event_notifications
#> server_event_session_actions
#> server_event_session_events
#> server_event_session_fields
#> server_event_session_targets
#> server_event_sessions
#> server_events
#> server_file_audits
#> server_memory_optimized_hybrid_buffer_pool_configuration
#> server_permissions
#> server_principal_credentials
#> server_principals
#> server_role_members
#> server_sql_modules
#> server_trigger_events
#> server_triggers
#> servers
#> service_broker_endpoints
#> service_contract_message_usages
#> service_contract_usages
#> service_contracts
#> service_message_types
#> service_queue_usages
#> service_queues
#> services
#> soap_endpoints
#> spatial_index_tessellations
#> spatial_indexes
#> spatial_reference_systems
#> sql_dependencies
#> sql_expression_dependencies
#> sql_feature_restrictions
#> sql_logins
#> sql_modules
#> stats
#> stats_columns
#> symmetric_keys
#> synonyms
#> sysaltfiles
#> syscacheobjects
#> syscharsets
#> syscolumns
#> syscomments
#> sysconfigures
#> sysconstraints
#> syscscontainers
#> syscurconfigs
#> syscursorcolumns
#> syscursorrefs
#> syscursors
#> syscursortables
#> sysdatabases
#> sysdepends
#> sysdevices
#> sysfilegroups
#> sysfiles
#> sysforeignkeys
#> sysfulltextcatalogs
#> sysindexes
#> sysindexkeys
#> syslanguages
#> syslockinfo
#> syslogins
#> sysmembers
#> sysmessages
#> sysobjects
#> sysoledbusers
#> sysopentapes
#> sysperfinfo
#> syspermissions
#> sysprocesses
#> sysprotects
#> sysreferences
#> sysremotelogins
#> sysservers
#> system_columns
#> system_components_surface_area_configuration
#> system_internals_allocation_units
#> system_internals_partition_columns
#> system_internals_partitions
#> system_objects
#> system_parameters
#> system_sql_modules
#> system_views
#> systypes
#> sysusers
#> table_types
#> tables
#> tcp_endpoints
#> time_zone_info
#> trace_categories
#> trace_columns
#> trace_event_bindings
#> trace_events
#> trace_subclass_values
#> traces
#> transmission_queue
#> trigger_event_types
#> trigger_events
#> triggers
#> trusted_assemblies
#> type_assembly_usages
#> types
#> user_token
#> via_endpoints
#> views
#> xml_indexes
#> xml_schema_attributes
#> xml_schema_collections
#> xml_schema_component_placements
#> xml_schema_components
#> xml_schema_elements
#> xml_schema_facets
#> xml_schema_model_groups
#> xml_schema_namespaces
#> xml_schema_types
#> xml_schema_wildcard_namespaces
#> xml_schema_wildcards
# READING ALL FIELDS AND ALL RECORDS FROM A DATABASE HOSTED BY A MS SQL SERVER
data <- readepi(
  credentials.file = credentials.file, 
  project.id = "IBS_BHDSS",  #this is the database name
  driver.name = "ODBC Driver 17 for SQL Server", 
  table.name = "dss_events"
  )
#> 
#> Fetching data from dss_events
#> Fetching data from dss_events


#CS_OPD, robin, 
```

## Vignette

The vignette of the **readepi** contains detailed illustration about the
used of each function. This can be accessed by typing the command below:

``` r
browseVignettes("readepi")
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
