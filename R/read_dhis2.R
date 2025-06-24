# for the DHIS2 test server
base_url <- "https://play.im.dhis2.org/stable-2-42-0"
user_name <- "admin"
password <- "district"
org_unit <- "DiszpKrYNg8"
program <- "qDkgAbB5Jlk"

login <- dhis2_login(
  base_url = base_url,
  user_name = user_name,
  password = password
)
# base_url <- "https:/smc.moh.gm/staging"
# user_name <- "karim"
# password <- "Gambia@123"




#' Title
#'
#' @param login
#' @param org_unit
#' @param program
#'
#' @returns
#' @export
#'
#' @examples
#' security/login.action
#' login <- dhis2_login(
#'   base_url = "https://smc.moh.gm/dhis",
#'   user_name = "test",
#'   password = "Gambia@123"
#' )
#' program = "E5IUQuHg3Mg"
#' org_unit = "jvQPTsCLwPh"
read_dhis2 <- function(login, org_unit, program) {

  # get the data elements
  message("Getting the data elements")
  data_elements <- get_data_elements(login = login)

  # get all organisation units
  message("Getting the organisation units")
  org_units <- get_organisation_units(login = login)

  # get all the programs
  message("Getting the programs")
  programs <- get_programs(login = login)

  # get program stages
  message("Getting the program stages")
  program_stages <- get_program_stages(login = login, program = program)

  # get enrollments
  # message("Getting the enrollments")
  # enrollments <- get_enrollments(
  #   login = login,
  #   program = program,
  #   org_unit = org_unit
  # )

  # get event data
  message("Getting the events")
  events <- get_event_data(
    login = login,
    org_unit = org_unit,
    program = program,
    org_units = org_units,
    data_elements = data_elements,
    programs = programs,
    program_stages = program_stages
  )

  # get the tracked entities
  message("Getting the tracked entities")
  target_entities <- paste(
    unique(events[["tracked_entity"]]),
    collapse = ","
  )
  tracked_entities <- get_tracked_entities(
    login = login,
    target_entities = target_entities,
    org_units = org_units
  )

  # finally join the event data with the tracked entity data based on the
  # tracked entity IDs and their organisation unit
  final_result <- tracked_entities |>
    dplyr::left_join(
      events,
      by = c("tracked_entity", "org_unit"),
      relationship = "many-to-many"
    )

  return(final_result)
}
