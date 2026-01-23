# Package index

## Exported functions

[readepi](https://epiverse-trace.github.io/readepi/) functions available
to end-users

- [`dhis2_login()`](https://epiverse-trace.github.io/readepi/dev/reference/dhis2_login.md)
  : Establish connection to a DHIS2 instance
- [`get_api_version()`](https://epiverse-trace.github.io/readepi/dev/reference/get_api_version.md)
  : Get DHIS2 API version
- [`get_data_elements()`](https://epiverse-trace.github.io/readepi/dev/reference/get_data_elements.md)
  : Get all data elements from a specific DHIS2 instance
- [`get_organisation_units()`](https://epiverse-trace.github.io/readepi/dev/reference/get_organisation_units.md)
  : Get the organization units from a specific DHIS2 instance
- [`get_program_org_units()`](https://epiverse-trace.github.io/readepi/dev/reference/get_program_org_units.md)
  : Get organisation units that are associated with a given program
- [`get_program_stages()`](https://epiverse-trace.github.io/readepi/dev/reference/get_program_stages.md)
  : Get program stages for one or more DHSI2 programs
- [`get_programs()`](https://epiverse-trace.github.io/readepi/dev/reference/get_programs.md)
  : get all programs from a given specific DHIS2 instance
- [`get_tracked_entities()`](https://epiverse-trace.github.io/readepi/dev/reference/get_tracked_entities.md)
  : Get tracked entity attributes, their corresponding IDs and event IDs
- [`login()`](https://epiverse-trace.github.io/readepi/dev/reference/login.md)
  : Establish a connection to the HIS of interest.
- [`lookup_table`](https://epiverse-trace.github.io/readepi/dev/reference/lookup_table.md)
  : Lookup table
- [`read_dhis2()`](https://epiverse-trace.github.io/readepi/dev/reference/read_dhis2.md)
  : Import data from DHIS2
- [`read_rdbms()`](https://epiverse-trace.github.io/readepi/dev/reference/read_rdbms.md)
  : Import data from relational database management systems (RDBMS).
- [`read_sormas()`](https://epiverse-trace.github.io/readepi/dev/reference/read_sormas.md)
  : Import data from SORMAS
- [`request_parameters`](https://epiverse-trace.github.io/readepi/dev/reference/request_parameters.md)
  : Request parameters
- [`show_tables()`](https://epiverse-trace.github.io/readepi/dev/reference/show_tables.md)
  : Display the list of tables in a database
- [`sormas_get_api_specification()`](https://epiverse-trace.github.io/readepi/dev/reference/sormas_get_api_specification.md)
  : Download the API specification file from SORMAS
- [`sormas_get_data_dictionary()`](https://epiverse-trace.github.io/readepi/dev/reference/sormas_get_data_dictionary.md)
  : Download SORMAS data dictionary
- [`sormas_get_diseases()`](https://epiverse-trace.github.io/readepi/dev/reference/sormas_get_diseases.md)
  : Get the list of disease names from a SORMAS instance

## Internal functions

[readepi](https://epiverse-trace.github.io/readepi/) functions for
internal use

### Shared helpers

- [`url_check()`](https://epiverse-trace.github.io/readepi/dev/reference/url_check.md)
  : Check if the value for the base_url argument has a correct structure

### SORMAS

- [`sormas_get_api_specification()`](https://epiverse-trace.github.io/readepi/dev/reference/sormas_get_api_specification.md)
  : Download the API specification file from SORMAS
- [`sormas_get_cases_data()`](https://epiverse-trace.github.io/readepi/dev/reference/sormas_get_cases_data.md)
  : Get case data from a SORMAS instance
- [`sormas_get_contact_data()`](https://epiverse-trace.github.io/readepi/dev/reference/sormas_get_contact_data.md)
  : Get contact data from SORMAS
- [`sormas_get_data_dictionary()`](https://epiverse-trace.github.io/readepi/dev/reference/sormas_get_data_dictionary.md)
  : Download SORMAS data dictionary
- [`sormas_get_diseases()`](https://epiverse-trace.github.io/readepi/dev/reference/sormas_get_diseases.md)
  : Get the list of disease names from a SORMAS instance
- [`sormas_get_pathogen_data()`](https://epiverse-trace.github.io/readepi/dev/reference/sormas_get_pathogen_data.md)
  : Get pathogen tests data from SORMAS
- [`sormas_get_persons_data()`](https://epiverse-trace.github.io/readepi/dev/reference/sormas_get_persons_data.md)
  : Get personal data of cases from a SORMAS instance
- [`convert_to_date()`](https://epiverse-trace.github.io/readepi/dev/reference/convert_to_date.md)
  : Convert numeric values into POSIXct,then into Date

### DHIS2

- [`get_org_unit_as_long()`](https://epiverse-trace.github.io/readepi/dev/reference/get_org_unit_as_long.md)
  : Transform the organisation units data frame from large to long
  format
- [`get_org_unit_levels()`](https://epiverse-trace.github.io/readepi/dev/reference/get_org_unit_levels.md)
  : Extract the DHSI2 organization unit's hierarchical levels.
- [`get_org_units()`](https://epiverse-trace.github.io/readepi/dev/reference/get_org_units.md)
  : Retrieve DHIS2 organization units, along with their IDs, names,
  parent IDs, and levels.
- [`check_org_unit()`](https://epiverse-trace.github.io/readepi/dev/reference/check_org_unit.md)
  : Validate user-specified organisation unit ID or name.
- [`check_program()`](https://epiverse-trace.github.io/readepi/dev/reference/check_program.md)
  : Validate and retrieve program IDs
- [`get_entity_attributes()`](https://epiverse-trace.github.io/readepi/dev/reference/get_entity_attributes.md)
  : Get the attribute names and ids of the tracked entities
- [`get_event_data()`](https://epiverse-trace.github.io/readepi/dev/reference/get_event_data.md)
  : Get event data from the newer DHIS2 versions (version \>= 2.41)
- [`get_entity_data()`](https://epiverse-trace.github.io/readepi/dev/reference/get_entity_data.md)
  : Get tracked entity attributes
- [`get_event_ids()`](https://epiverse-trace.github.io/readepi/dev/reference/get_event_ids.md)
  : Get event IDs for specific tracked entity
- [`get_request_params()`](https://epiverse-trace.github.io/readepi/dev/reference/get_request_params.md)
  : Get the request query parameters for a specific API version

### RDBMS

- [`server_fetch_data()`](https://epiverse-trace.github.io/readepi/dev/reference/server_fetch_data.md)
  : Fetch all or specific rows and columns from a table
- [`server_make_query()`](https://epiverse-trace.github.io/readepi/dev/reference/server_make_query.md)
  : Make an SQL query from a list of query parameters
- [`server_make_sql_expression()`](https://epiverse-trace.github.io/readepi/dev/reference/server_make_sql_expression.md)
  : Convert R expression into SQL expression
- [`server_make_subsetting_query()`](https://epiverse-trace.github.io/readepi/dev/reference/server_make_subsetting_query.md)
  : Create a subsetting query
- [`query_check()`](https://epiverse-trace.github.io/readepi/dev/reference/query_check.md)
  : Check whether the user-provided query is valid
- [`fields_check()`](https://epiverse-trace.github.io/readepi/dev/reference/fields_check.md)
  : Check whether the user-specified fields are valid
