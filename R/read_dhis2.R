#' Import data from DHIS2
#'
#' @param login A httr2_response object returned by the `dhis2_login()` function
#' @param org_unit A character with the organisation unit ID or name
#' @param program A character with the program ID or name
#'
#' @returns A data frame that contains both the tracked entity attributes and
#'    their event data.
#' @export
#'
#' @examples
#' \dontrun{
#'   # login to the DHIS2 instance
#'   dhis2_login <- login(
#'     type = "dhis2",
#'     from = "https://smc.moh.gm/dhis",
#'     user_name = "test",
#'     password = "Gambia@123"
#'   )
#'   program = "E5IUQuHg3Mg"
#'   org_unit = "GcLhRNAFppR"
#'   data <- read_dhis2(
#'     login = dhis2_login,
#'     org_unit = org_unit,
#'     program = program
#'   )
#'
#'   # fetch data from the test DHIS2 instance
#'   dhis2_login <- login(
#'     type = "dhis2",
#'     from = "https://play.im.dhis2.org/stable-2-42-1",
#'     user_name = "admin",
#'     password = "district"
#'   )
#'   org_unit <- "DiszpKrYNg8"
#'   program <- "IpHINAT79UW"
#'
#'   data <- read_dhis2(
#'     login = dhis2_login,
#'     org_unit = org_unit,
#'     program = program
#'   )
#' }
read_dhis2 <- function(login, org_unit, program) {
  checkmate::assert_class(login, classes = "httr2_response", null.ok = FALSE)
  checkmate::assert_character(org_unit, any.missing = FALSE, null.ok = FALSE)
  checkmate::assert_character(program, any.missing = FALSE, null.ok = FALSE)

  cli::cli_progress_step("Checking whether the API version is accounted for")
  # get the api_version
  api_version <- get_api_version(login = login)

  cli::cli_progress_step("Getting the data elements")
  # get the data elements
  data_elements <- get_data_elements(login = login)

  cli::cli_progress_step("Getting organisation units")
  # get all organisation units
  org_units <- get_organisation_units(login = login)

  # convert organisation unit name into organisation unit ID when necessary
  org_unit <- check_org_unit(login = login, org_unit = org_unit)

  cli::cli_progress_step("Getting the programs")
  # get all the programs
  programs <- get_programs(login = login)

  # convert program names into program ID when necessary
  program <- check_program(
    login = login,
    program = program
  )

  cli::cli_progress_step("Getting the program stages")
  # get program stages
  program_stages <- get_program_stages(
    login = login,
    programs = programs,
    program = program
  )

  # check if the provided organisation unit is associated with the provided
  # program. Send an error message if not.
  target_org_units <- get_program_org_units(
    login = login,
    program = program,
    org_units = org_units
  )
  if (!org_unit %in% target_org_units[["org_unit_ids"]]) {
    cli::cli_abort(c(
      x = "The specified organisation unit does not run the program \\
           {.strong {program}}",
      i = "Please use {.fn target_org_units} function to see the full list of \\
           organisation units that run the specified program."
    ))
  }


  cli::cli_progress_step("Getting the tracked entity attributes")
  # get the tracked entities attributes
  tracked_entities <- get_tracked_entities(
    login = login,
    api_version = api_version,
    org_unit = org_unit,
    program = program,
    org_units = org_units
  )

  cli::cli_progress_step("Getting the event data")
  # get event data
  events <- get_event_data(
    login = login,
    api_version = api_version,
    org_unit = org_unit,
    program = program,
    data_elements = data_elements,
    programs = programs,
    program_stages = program_stages,
    org_units = org_units
  )

  # finally join the event data with the tracked entity data based on the
  # tracked entity IDs and their organisation unit
  final_result <- tracked_entities |>
    dplyr::left_join(
      events,
      by = c("tracked_entity", "event", "org_unit"),
      relationship = "many-to-many"
    )

  return(final_result)
}
