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
#' # login to the DHIS2 instance
#' login <- login(
#'   from = "https://smc.moh.gm/dhis",
#'   user_name = "test",
#'   password = "Gambia@123"
#' )
#' program = "E5IUQuHg3Mg"
#' org_unit = "GcLhRNAFppR"
#' data <- read_dhis2(
#'   login = login,
#'   org_unit = org_unit,
#'   program = program
#' )
#'
#' # fetch data from the test DHIS2 instance
#' login <- login(
#'   from = "https://play.im.dhis2.org/stable-2-42-1",
#'   user_name = "admin",
#'   password = "district"
#' )
#' org_unit <- "DiszpKrYNg8"
#' program <- "IpHINAT79UW"
#'
#' data <- read_dhis2(
#'   login = login,
#'   org_unit = org_unit,
#'   program = program
#' )
read_dhis2 <- function(login, org_unit, program) {
  checkmate::assert_class(login, classes = "httr2_response", null.ok = FALSE)
  checkmate::assert_character(org_unit, any.missing = FALSE, null.ok = FALSE)
  checkmate::assert_character(program, any.missing = FALSE, null.ok = FALSE)

  # get the api_version
  api_version <- get_api_version(login = login)

  # get the data elements
  message("Getting the data elements")
  data_elements <- get_data_elements(login = login)

  # get all organisation units
  message("Getting the organisation units")
  org_units <- get_organisation_units(login = login)

  # get all the programs
  message("Getting the programs")
  programs <- get_programs(login = login)

  # convert program names into program ID when necessary
  program <- check_program(
    login = login,
    program = program
  )

  # get program stages
  message("Getting the program stages")
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

  # convert organisation unit name into organisation unit ID when necessary
  org_unit <- check_org_unit(login = login, org_unit = org_unit)

  # get the tracked entities attributes
  message("Getting the tracked entity attributes")
  tracked_entities <- get_tracked_entities(
    login = login,
    api_version = api_version,
    org_unit = org_unit,
    program = program,
    org_units = org_units
  )

  # get event data
  message("Getting the events")
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
