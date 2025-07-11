
#' Establish connection to the DHIS2 instance
#'
#' @param base_url A character with the base URL of the target DHIS2 instance
#' @param user_name A character with the user name
#' @param password A character with the user's password
#'
#' @returns An `httr2_response` object if the connection was successfully
#'    established
#' @export
#'
#' @examples
#' login <- dhis2_login(
#'   base_url = "https://play.im.dhis2.org/stable-2-42-1",
#'   user_name = "admin",
#'   password = "district"
#' )
dhis2_login <- function(base_url,
                        user_name,
                        password) {
  url <- file.path(base_url, "api", "me")
  resp <- httr2::request(url) |>
    httr2::req_auth_basic(user_name, password) |>
    httr2::req_perform()
  message("\nLogged in successfully!")
  return(invisible(resp))
}

#' Extract DHSI2 aggregated and tracked programs
#'
#' The function first fetches all programs from the DHIS2 Aggregate system,
#' then retrieves the ones from the Tracker system.
#'
#' @param login A httr2 request object preconfigured for authentication
#'    conveying the base url, user name, and password.
#'
#' @returns A data frame with the following columns: the program ID, the program
#'    name, and the program type specifying whether the program is part of the
#'    Aggregate or Tracker system.
#'
#' @export
#' @examples
#' # establish the connexion to the system
#' login <- dhis2_login(
#'   base_url = "https://play.im.dhis2.org/stable-2-42-0",
#'   user_name = "admin",
#'   password = "district"
#' )
#'
#' # fetching the programs
#' programs <- get_programs(login)
#'
get_programs <- function(login) {
  # get the base URL the login object
  base_url <- gsub("/api/me", "", login[["url"]])

  # construct the URL to target the program endpoint
  url <- paste0(
    file.path(base_url, "api", "programs"),
    "?fields=id,displayName&paging=false"
  )

  # modify the request URL and perform the request to get all programs
  all_programs <- login[["request"]] |>
    httr2::req_url(url) |>
    httr2::req_method("GET") |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    dplyr::bind_rows()

  # add a label to the programs to identify Tracker and Aggregate programs
  all_programs[["type"]] <- "aggregate"

  # identify the programs registered in the Tracker
  url <- paste0(url, "&filter=programType:eq:WITH_REGISTRATION")

  # perform the request to fetch the programs
  tracker_programs <- login[["request"]] |>
    httr2::req_url(url) |>
    httr2::req_method("GET") |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    dplyr::bind_rows()

  # change the labels of the Tracker programs
  matches <- all_programs[["id"]] %in% tracker_programs[["id"]]
  all_programs[["type"]][matches] <- "tracker"

  return(all_programs)
}

#' Retrieve DHS2 data elements
#'
#' @param login A httr2 request object preconfigured for authentication
#'    conveying the base url, user name, and password.
#'
#' @returns A data frame with the following two columns: the data elements IDs
#'    and their corresponding names.
#' @export
#'
#' @examples
#' # establish the connexion to the system
#' login <- dhis2_login(
#'   base_url = "https://play.im.dhis2.org/stable-2-42-0",
#'   user_name = "admin",
#'   password = "district"
#' )
#'
#' # retrieve the data elements
#' data_elements <- get_data_elements(login)
#'
get_data_elements <- function(login) {
  # get the base URL from the login object
  base_url <- gsub("/api/me", "", login[["url"]])

  # construct the URL to target the dataElements endpoint
  url <- paste0(
    file.path(base_url, "api", "dataElements"),
    "?fields=id,name&paging=false"
  )

  # modify the request URL and perform the request
  data_elements <- login[["request"]] %>%
    httr2::req_url(url) %>%
    httr2::req_method("GET") %>%
    httr2::req_perform() %>%
    httr2::resp_body_json() %>%
    dplyr::bind_rows()

  return(data_elements)
}


#' Return the organisation units in a long data frame
#'
#' @param login The login object
#' @param org_units A data frame of all the organisation units obtained from the
#'    `get_organisation_units()` function.
#'
#' @returns A data with three columns corresponding to the organisation unit
#'    names, IDs, and levels
#'
#' @keywords internal
get_org_unit_as_long <- function(login, org_units = "NULL") {
  # get all org units
  if (is.null(org_units)) {
    org_units <- get_organisation_units(login)
  }
  longer_names <- org_units |>
    dplyr::select(dplyr::ends_with("_name")) |>
    tidyr::pivot_longer(
      cols = dplyr::ends_with("_name")
    )
  names(longer_names) <- c("levels", "org_unit_names")

  # pivot longer on ids to get all the organisation unit ids
  longer_ids <- org_units |>
    dplyr::select(dplyr::ends_with("_id")) |>
    tidyr::pivot_longer(
      cols = dplyr::ends_with("_id")
    )
  tmp_org_units <- cbind(longer_names, longer_ids[["value"]])
  names(tmp_org_units)[[3]] <- "org_unit_ids"

  return(tmp_org_units)
}

#' Extract the DHSI2 organization unit's hierarchical levels.
#'
#' The level is a numerical number, with 1 referring to the "Country",
#' 2 "Region", and so on to the deepest level denoting the health care
#' reporting unit.
#'
#' @param login A httr2 request object preconfigured for authentication
#' conveying the base url, user name, and password.
#'
#' @return A data frame with three columns containing the organization unit's
#'    names, IDs, and their hierarchical levels.
#' @keywords internal
#'
#' @examples
#' # establish the connexion to the system
#' login <- dhis2_login(
#'   base_url = "https://play.im.dhis2.org/stable-2-42-0",
#'   user_name = "admin",
#'   password = "district"
#' )
#'
#' # get the organisation unit levels
#' org_unit_levels <- get_org_unit_levels(login)
#'
get_org_unit_levels <- function(login) {
  # get the base URL the login object
  base_url <- gsub("/api/me", "", login[["url"]])

  # construct the URL to target the organisationUnitLevels
  url <- paste0(
    file.path(base_url, "api", "organisationUnitLevels"),
    "?paging=false&fields=level,name,id"
  )

  # update the URL and perform the query
  levels <- login[["request"]] %>%
    httr2::req_url(url) %>%
    httr2::req_method("GET") %>%
    httr2::req_perform() %>%
    httr2::resp_body_json()

  # combine the response as a data frame
  levels <- dplyr::bind_rows(levels)

  return(levels)
}


#' Retrieve The DHIS2 organization units, along with their IDs, names, parent IDs,
#' and levels.
#'
#' @param login A httr2 request object preconfigured for authentication
#' conveying the base url, user name, and password.
#'
#' @return A data frame of organization units with the following fields:
#'    organisation unit id and name, as well as the corresponding parent
#'    organisation unit id, and level.
#' @keywords internal
#' @examples
#' # establish the connection to the system
#' login <- dhis2_login(
#'   base_url = "https://play.im.dhis2.org/stable-2-42-0",
#'   user_name = "admin",
#'   password = "district"
#' )
#'
#' # fetch the organisation units
#' org_units <- get_org_units(login)
#'
get_org_units <- function(login) {
  # get the base URL the login object
  base_url <- gsub("/api/me", "", login[["url"]])

  # construct the URL to target the organisationUnits endpoint
  url <- paste0(
    file.path(base_url, "api", "organisationUnits"),
    "?paging=false&fields=id,name,parent[id],level"
  )

  # update the URL and perform the query
  response <- login[["request"]] |>
    httr2::req_url(url) |>
    httr2::req_method("GET") |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  # combine the response as a data frame
  org_units <- dplyr::bind_rows(response)

}

#' Retrieve the DHIS2 organization units
#'
#' Retrieves all organisational reporting units and their levels,
#' then builds a hierarchy for each unit by tracing its ancestries from
#' the deepest level up to the root.
#'
#' @details
#' 1. Fetches all organisation units via the `get_org_units()` function,
#' 2. Fetches all organisational unit levels via the `get_org_unit_levels()`
#'    function,
#' 3. Filters for organisational units at the deepest level,
#' 4. Traces the parent hierarchy of each deepest unit up to the root,
#' 5. Constructs a tabular structure where each row is a full lineage.
#'
#' @param login A httr2 request object preconfigured for authentication
#'    conveying the base url, user name, and password.
#'
#' @return A data frame where each row represents a full hierarchy for the
#'    last-level unit by keeping the hierarchical organizational unit's name and
#'    ID at each level, using the official level names provided by the DHIS2
#'    instance like "Country Name", "Country ID", etc.
#'
#' @export
#'
#' @examples
#' # establish the connexion to the system
#' login <- dhis2_login(
#'   base_url = "https://play.im.dhis2.org/stable-2-42-0",
#'   user_name = "admin",
#'   password = "district"
#' )
#'
#' # fetch the organisation units
#' org_units <- get_organisation_units(login)
#'
get_organisation_units <- function(login) {
  # get all organisation units and their levels
  org_units <- get_org_units(login)
  org_unit_levels <- get_org_unit_levels(login)

  # get the org units ids and the maximum organisation unit level
  org_unit_ids <- org_units[["id"]]
  max_level <- max(org_unit_levels[["level"]])
  org_units_of_interest <- org_units |> dplyr::filter(level == max_level)
  result <- vector(mode = "list", length = nrow(org_units_of_interest))
  for (i in seq_len(nrow(org_units_of_interest))) {
    current <- org_units_of_interest[i, ]
    level <- current[["level"]]
    hierarchy <- rep("", level * 2)  # Each level: name + ID
    while (!is.null(current)) {
      idx <- (current[["level"]] - 1) * 2
      hierarchy[idx + 1] <- current[["name"]]
      hierarchy[idx + 2] <- current[["id"]]
      parent_id <- current[["parent"]][["id"]]
      if (!is.null(parent_id) && parent_id %in% org_units[["id"]]) {
        current <- org_units |> dplyr::filter(id == parent_id)
      } else {
        break
      }
    }
    result[[paste0("test_", i)]] <- hierarchy
  }
  result <- data.frame(t(result |> dplyr::bind_rows()))

  # in case of an empty line, remove it
  result <- Filter(Negate(is.null), result)

  # use human-readable names as column headers
  test_fn <- function(i, org_unit_levels) {
    idx <- which(org_unit_levels[["level"]] == i)
    level_name <- org_unit_levels[["name"]][idx]
    return(
      c(paste0(level_name, "_name"), paste0(level_name, "_id"))
    )
  }
  col_names <- unlist(lapply(1:max_level, test_fn, org_unit_levels))
  names(result) <- col_names
  return(result)
}

#' Filter out all element of type list from a list object
#'
#' @param x A list object
#' @keywords internal
remove_list <- function(x) {
  # filter out list elements from a given enrollment
  return(Filter(Negate(is.list), x))
}

#' Get organization units as a long data frame
#'
#' This function reshapes the organisation unit data from a large to a
#' long-format data frame containing unit names, levels, and IDs.
#'
#' @param login A httr2 request object preconfigured for authentication
#' carrying the base url, user name, and password.
#' @param org_units A data frame of organisation units returned by the
#'    `get_organisation_units()` function. If `org_units` is not provided, the
#'    function calls `get_organisation_units()` to fetch all organisation units.
#'
#' @returns A data frame with the following three columns:
#'    - `levels` the level of the organization unit (1,2,3, etc.)
#'    - `org_unit_names` the names of the organization units
#'    - `org_unit_ids` the IDs of the organization units
#'
#' @export
#'
#' @examples
#' # establish the connection to the system
#' login <- dhis2_login(
#'   base_url = "https://play.im.dhis2.org/stable-2-42-0",
#'   user_name = "admin",
#'   password = "district"
#' )
#'
#' # get the organisation units data frame in large format
#' org_units <- get_organisation_units(login)
#' long_org_units <- get_org_units_as_long(login, org_units)
#'

get_org_units_as_long <- function(login, org_units = NULL) {
  # get all org units
  if (is.null(org_units)) {
    org_units <- get_organisation_units(login)
  }
  longer_names <- org_units |>
    dplyr::select(dplyr::ends_with("_name")) |>
    tidyr::pivot_longer(
      cols = dplyr::ends_with("_name")
    )
  names(longer_names) <- c("levels", "org_unit_names")

  # pivot longer on ids to get all the organisation unit ids
  longer_ids <- org_units |>
    dplyr::select(dplyr::ends_with("_id")) |>
    tidyr::pivot_longer(
      cols = dplyr::ends_with("_id")
    )
  tmp_org_units <- cbind(longer_names, longer_ids[["value"]])
  names(tmp_org_units)[[3]] <- "org_unit_ids"

  return(tmp_org_units)
}

#' Validate and retrieve organisation unit ID.
#'
#' Check whether a given organisation unit identifier or name is valid
#' within a DHIS2 instance. If a valid name is provided, the corresponding
#' organisation unit ID is returned. Otherwise, an informative error message is
#' thrown.
#'
#' @param login A httr2 request object preconfigured for authentication
#'    carrying the base url, user name, and password.
#' @param org_unit A character denoting the name or id of the organisation unit
#' @param org_units An optional data frame of organisation units as returned by
#'    the `get_organisation_units()` function.
#' @return The provided organization ID if it exists; otherwise, an error is
#' thrown and the function that lists all available org units is provided.
#'
#' @example
#' login <- dhis2_login(base_url, user_name, password)
#' org_unit_id <- check_org_unit(login = login, org_unit = "Freetown")
#'
check_org_unit <- function(login, org_unit, org_units = NULL) {
  if (is.null(org_units)) {
    org_units <- get_organisation_units(login = login)
  }
  # get all org units
  tmp_org_units <- get_org_unit_as_long(login, org_units)

  # if the provided organisation unit is a correct ID, return it
  if (org_unit %in% tmp_org_units[["org_unit_ids"]]) {
    return(org_unit)
  }

  # if not, check if it is an organisation unit name. If yes, get the
  # organisation unit ID.
  if (org_unit %in% tmp_org_units[["org_unit_names"]]) {
    idx <- which(tmp_org_units[["org_unit_names"]] == org_unit)
    return(unique(tmp_org_units[["org_unit_ids"]][idx]))
  }

  # If no, return an error that the provided organisation unit is incorrect
  # and give the name of the function to be used for getting the available
  # organisation units
  message("You provided an incorrect organisation unit ID or name")
  stop("Use the `get_organisation_units()` function to get the list of all
       available organisation units.")
}

#' Validate and retrieve program IDs
#'
#' Checks whether the specified program ID or name is valid in a DHIS2 instance.
#' If the name provided is a valid program name or ID, it returns
#' the corresponding ID; otherwise, an error message is shown and a function
#' listing all available programs is provided.
#'
#' @param login A httr2 request object preconfigured for authentication
#' carrying the base url, user name, and password.
#' @param program A character of the program name to be validated
#'
#' @example
#' login <- dhis2_login(base_url, user_name, password)
#' program_id <- check_program(
#' login = login,
#' program = "Malaria focus investigation"
#' )
#'
#'
check_program <- function(login, program) {
  # get all programs
  programs <- get_programs(login)

  # check if the specified programs are part of the program ids
  idx <- match(program, programs[["id"]])
  if (all(is.na(idx))) {
    # if not, check if the specified programs are part of the program names. If
    # yes, get the corresponding program ID.
    idx <- match(program, programs[["displayName"]])
    stopifnot("You provided an incorrect program IDs or names.
    Use the `get_programs()` function to get the available programs." =
                !all(is.na(idx)))
  }

  # send a message if there are some programs that were not found
  if (anyNA(idx)) {
    not_avail <- program[is.na(idx)]
    message("Could not find the following programs: ", toString(not_avail))
  }

  # if not, get the corresponding program IDs.
  idx <- idx[!is.na(idx)]
  return(programs[["id"]][idx])
}

#' Get program stages for one or more DHSI2 programs
#'
#' Retrieves the stages associated with specified DHIS2 program IDs, or all
#' programs if none are specified. If any of the supplied program names or IDs
#' are not found, the function displays a message and proceeds with
#' the valid ones.
#'
#' @param login A httr2 request object preconfigured for authentication
#' carrying the base url, user name, and password.
#' @param program A character vector of program ids for which we want to return
#' the program stages.
#' @return A data frame with the following columns:
#' 1. `program_id`: the unique ID of the program
#' 2. `program_name`: the displayed name of the program
#' 3. `program_stage_name`: the name of each stage associate with the program
#' 4. `program_stage_id`: the ID of each program stage
#' @example
#' login = <- dhis2_login(base_url, user_name, password)
#' all_program_stages <- get_program_stages(
#'   login = login,
#'   program = NULL
#' )
#' @export

get_program_stages <- function(login, program = NULL) {
  # 'login' is the authentication object
  # 'program' is a vector of program ids for which we want to return the
  # program stages
  # get all the programs and match the ids with the provided ones
  message("getting all programs...")
  programs <- get_programs(login)

  # check if the provided program IDs actually exist in the system
  if (!is.null(program)) {
    idx <- match(program, programs[["id"]])
    if (all(is.na(idx))) {
      idx <- match(program, programs[["displayName"]])
      stopifnot("You provided incorrect program IDs" = !all(is.na(idx)))
    }

    # send a message if there are some programs that were not found
    if (anyNA(idx)) {
      not_avail <- program[is.na(idx)]
      message("Could not find the following programs: ", toString(not_avail))
    }

    # only keep the programs that match the ones found in the system
    idx <- idx[!is.na(idx)]
    programs <- programs[idx, ]
  }


  # get the base URL the login object
  base_url <- gsub("/api/me", "", login[["url"]])

  program_stages <- vector("list", length = nrow(programs))
  for (i in seq_len(nrow(programs))) {
    program_id <- programs[["id"]][i]
    program_name <- programs[["displayName"]][i]

    # construct the URL to a specific program
    url <- paste0(
      file.path(base_url, "api", "programs", program_id),
      "?fields=programStages[id,name]&paging=false"
    )

    # modify the request URL and perform the request
    program_stage <- login[["request"]] %>%
      httr2::req_url(url) %>%
      httr2::req_method("GET") %>%
      httr2::req_perform() %>%
      httr2::resp_body_json() %>%
      dplyr::bind_rows()

    # rename the output data frame
    names(program_stage) <- c("program_stage_name", "program_stage_id")

    program_stages[[i]] <- data.frame(cbind(
      "program_id" = program_id,
      "program_name" = program_name,
      program_stage
    ))
  }

  program_stages <- dplyr::bind_rows(program_stages)
  return(program_stages)
}


#' Get enrollments from DHSI2
#'
#' Retrieve enrollments records for a specific program and organization unit.
#'
#' @param login A httr2 request object preconfigured for authentication
#' carrying the base url, user name, and password.
#' @param program A character of program ID or name. It will be validated
#' using the `check_program` function.
#' @param org_unit A character of organisation unit ID or name.
#' It will be validated using the `check_org_unit` function.
#' @return A data frame with enrollment information retrieved from DHIS2
#'

#' @example
#' login = <- dhis2_login(base_url, user_name, password)
#' enrollments <- get_enrollments(
#'   login = login,
#'   org_unit = "DiszpKrYNg8",
#'   program = "M3xtLkYBlKI"
#' )
#' @export
#'
get_enrollments <- function(login, program, org_unit, org_units = NULL) {
  if (is.null(org_units)) {
    org_units <- get_organisation_units(login = login)
  }
  # check whether the provided program and organisation unit exist
  program <- check_program(login, program)
  org_unit <- check_org_unit(login, org_unit = org_unit, org_units = org_units)

  # get the base URL the login object
  base_url <- gsub("/api/me", "", login[["url"]])

  # construct the query parameter as a string
  query_parameters <- sprintf(
    "?orgUnit=%s&program=%s&paging=false",
    org_unit, program
  )

  # construct the URL to a specific program
  url <- paste0(
    file.path(base_url, "api", "tracker", "enrollments"),
    # file.path(base_url, "api", "enrollments"),
    query_parameters
  )

  # modify the request URL send the request to fetch all enrollments at the
  # specified organisation unit and program ids
  response <- login[["request"]] %>%
    httr2::req_url(url) %>%
    httr2::req_method("GET") %>%
    httr2::req_perform() %>%
    httr2::resp_body_json()

  # apply the filtration function above and
  # combine the enrollment information as a data frame
  enrollments <- dplyr::bind_rows(
    purrr::map(response[["enrollments"]], remove_list)
  )

  return(enrollments)
}

#' Get event data from DHIS2 tracker
#'
#' Retrieves event-level data for a given program and organisation unit.
#' The function also replaces the IDs of data elements, organisation units,
#' program stages, and programs by their corresponding real names for more
#' readable output.
#'
#' @param login A httr2 request object preconfigured for authentication
#' carrying the base url, user name, and password.
#' @param program A character of program ID or name to retrieve events for.
#' It is validated through the `check_program` function.
#' @param org_unit A character of organisation unit ID or name.
#' It is validated by the `check_org_unit` function.
#' @param data_elements A data frame of data elements, typically retrieved
#' using the `get_data_elements` function. If `NULL`, the function will fetch
#' all data elements.
#' @param org_units A data frame of organisation units, typically retrieved
#' using the `get_org_unit_as_long` function.
#' @param programs A data frame of programs, used to map program IDs to names.
#' @param program_stages A data frame of program stages, used to map stage
#' IDs to stage names.
#'
#' @return A data frame with event-level data, including metadata (event ID,
#'  status, program, stage, enrollment, tracked entity, and organisation unit)
#'  and data element values as columns.
#'
#' @example
#' login <- dhis2_login(
#'   base_url = "https://cbs.apps.moh.gm/dhis/dhis-web-tracker-capture",
#'   user_name = "kebba.jobarteh",
#'   password = "Cbs@2025"
#' )
#' program <- "IpHINAT79UW"
#' org_unit <- "DiszpKrYNg8"
#' data_elements <- get_data_elements(login = login)
#' org_units <- get_organisation_units(login = login)
#' org_units <- get_org_unit_as_long(login = login, org_units)
#' programs <- get_programs(login)
#' program_stages <- get_program_stages(login, program)
#'
#' events <- get_event_data(login, program, org_unit, data_elements, org_units,
#' programs, program_stages)
#'
get_event_data <- function(login, program, org_unit, data_elements,
                           org_units, programs, program_stages) {
  # check whether the provided program and organisation unit exist
  program <- check_program(login, program)
  org_unit <- check_org_unit(login, org_unit, org_units = org_units)

  if (is.null(data_elements)) {
    data_elements <- get_data_elements(login = login)
  }
  # if (is.null(org_units)) {
  #   org_units <- get_org_unit_as_long(login = login, org_units = org_units)
  # }
  if (is.null(program_stages)) {
    program_stages <- get_program_stages(login, program)
  }
  org_units <- get_org_unit_as_long(login = login, org_units = org_units)

  # get the base URL the login object
  base_url <- gsub("/api/me", "", login[["url"]])

  # construct the query parameter as a string
  query_parameters <- sprintf(
    "?orgUnit=%s&program=%s&paging=false", #&program=%s&paging=false
    org_unit, program
  )

  # construct the URL to a specific program
  "/api/tracker/events?orgUnit=DiszpKrYNg8&program=eBAyeGv0exc"
  url <- paste0(
    # file.path(base_url, "api", "tracker", "events"),
    file.path(base_url, "api", "events"),
    query_parameters
  )

  # modify the request URL and send the request to fetch all events at the
  # specified organisation unit and program ids
  response <- login[["request"]] %>%
    httr2::req_url(url) %>%
    httr2::req_method("GET") %>%
    httr2::req_perform() %>%
    httr2::resp_body_json()
  events <- response[["events"]]

  # send a message if no event was found
  if (length(events) == 0) {
    stop("No events found from the specified program and organisation unit.")
  }

  # extract the relevant information from the events object
  # Extract names and ages using map
  event_attributes <- purrr::map(
    events, ~ c(event_id = .x$event, status = .x$status, program = .x$program,
                program_stage = .x$programStage, enrollment = .x$enrollment,
                tracked_entity = .x$trackedEntity, org_unit = .x$orgUnit)
  ) |>
    dplyr::bind_rows()

  # Extract the data values elements from the events list
  data_values_list <- purrr::map(events, ~ .x$dataValues)

  target_data_elements <- lapply(data_values_list, function(group) {
    sapply(group, function(x) x$dataElement)
  })

  # Flatten the list of data element
  target_data_elements <- unique(unlist(target_data_elements))

  # construct the data frame that will contain the event data
  event_data <- as.data.frame(
    matrix(nrow = length(events), ncol = length(target_data_elements))
  )
  names(event_data) <- target_data_elements

  # loop through the dataValues list to get the data elements and values for
  # every event entry
  for (i in seq_along(data_values_list)) {
    # skip when there is no data values a given event
    if (length(data_values_list[[i]]) == 0) {
      next
    }

    # get the data elements and their values from a given event
    target <- data_values_list[[i]]
    target_data_elements <- unlist(purrr::map(target, ~ .x$dataElement))
    target_data_values <- unlist(
      purrr::map(target, ~ ifelse("value" %in% names(.x), .x$value, NA))
    )


    # fill the event data frame at the corresponding line and columns
    idx <- match(target_data_elements, names(event_data))
    event_data[i, idx] <- target_data_values
  }

  # get the data elements and rename the columns of the event_data using the
  # data element names
  idx <- match(names(event_data), data_elements[["id"]])
  names(event_data) <- data_elements[["name"]][idx]

  # combine the event attributes and their data
  event_data <- cbind(event_attributes, event_data)

  # replace the program id by the program name
  idx <- match(event_data[["program"]], programs[["id"]])
  event_data[["program"]] <- programs[["displayName"]][idx]

  # replace the program stage ids by the program stage names
  idx <- match(event_data[["program_stage"]], program_stages[["program_stage_id"]])
  event_data[["program_stage"]] <- program_stages[["program_stage_name"]][idx]

  # replace the organisation unit ids by their names
  idx <- match(event_data[["org_unit"]], org_units[["org_unit_ids"]])
  event_data[["org_unit"]] <- org_units[["org_unit_names"]][idx]


  return(event_data)
}

get_one_entity_data <- function(x, login) {
  base_url <- gsub("/api/me", "", login[["url"]])
  url <- paste0(
    file.path(base_url, "api", "tracker", "trackedEntities", x)
  )

  query_parameters <- sprintf(
    "?trackedEntities=%s", #&orgUnit=%s&paging=false
    x
  )

  url <- paste0(
    file.path(base_url, "api", "tracker", "trackedEntities"),
    query_parameters
  )


  response <- login[["request"]] |>
    httr2::req_url(url) |>
    httr2::req_method("GET") |>
    # httr2::req_timeout(120) |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  return(response)
}

# function to get the attribute names and ids of the tracked entities
# Use this function to get the ids and names of the features collected about
# each tracked entities. The ids and names will be used to update the list
# of query parameters
get_entity_attributes <- function(x) {
  tmp <- x$attributes %>%
    dplyr::bind_rows()
  display_names <- tmp$displayName
  attribute_names <- data.frame(id = tmp$attribute, name = tmp$displayName)
  return(attribute_names)
}

#' Get metadata and attributes associated with tracked entities
#'
#' The function retrieves metadata and attributes for the supplied tracked
#' entities. It also replaces organisation unit IDs with their corresponding
#' names. It returns a unified data frame. Warnings are issued if no attributes
#' are found for the entities.
#'
#' @param login A httr2 request object preconfigured for authentication
#' carrying the base url, user name, and password.
#' @param target_entities A character vector of tracked entity IDs to retrieve.
#' @param org_units A data frame of organisation units, typically retrieved
#' using the `get_org_unit_as_long` function.
#'
#' @return A data frame where each row corresponds to a tracked entity
#' and includes:
#' - `Metadata`: tracked entity ID, type, organisation unit name
#' - `Attributes`: columns named using attribute display names
#'
#' @Exemple
#' login = <- dhis2_login(base_url, user_name, password)
#' target_entities <- paste(unique(event_data$tracked_entity), collapse = ",")
#' tracked_entities <- get_tracked_entities(login, target_entities, org_units)
#'
get_tracked_entities <- function(login, target_entities, org_units) {
  # get the base URL from the login object
  base_url <- gsub("/api/me", "", login[["url"]])

  # construct the URL to a specific program
  query_parameters <- sprintf(
    "?trackedEntities=%s", #&orgUnit=%s&paging=false
    target_entities
  )
  url <- paste0(
    file.path(base_url, "api", "tracker", "trackedEntities"),
    query_parameters
  )

  # response <- lapply(target_entities, get_one_entity_data, login)

  # querying the track entities endpoint
  response <- login[["request"]] |>
    httr2::req_url(url) |>
    httr2::req_method("GET") |>
    # httr2::req_timeout(120) |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  tracked_entities <- response[["trackedEntities"]]
  # stop and send a message if no tracked entity was found
  stopifnot("No tracked entity was found" = !length(tracked_entities) == 0)

  entity_attributes <- purrr::map(
    tracked_entities, ~ c(tracked_entity = .x$trackedEntity,
                          tracked_entity_type = .x$trackedEntityType,
                          org_unit = .x$orgUnit)
  ) |>
    dplyr::bind_rows()

  # get the attribute names and ids
  attributes_names <- suppressWarnings(
    dplyr::bind_rows(purrr::map(tracked_entities, get_entity_attributes))
  ) |>
    dplyr::distinct()

  # send a message when no tracked entity has an attribute
  if (nrow(attributes_names) == 0) {
    warning("No attribute found across all tracked entities.")
  }

  # get the list of all attributes
  all_attributes <- purrr::map(tracked_entities, ~ .x$attributes)

  # construct the data frame that will contain the event data
  entity_data <- as.data.frame(
    matrix(nrow = length(tracked_entities), ncol = nrow(attributes_names))
  )
  names(entity_data) <- attributes_names[["name"]]

  # loop through the tracked entity list to get the data elements and values for
  # every entry
  for (i in seq_along(all_attributes)) {
    # skip when there is no data values a given event
    if (length(all_attributes[[i]]) == 0) {
      next
    }

    # get the data elements and their values from a given event
    target <- all_attributes[[i]]
    tmp_data <- dplyr::bind_rows(target)
    idx <- match(tmp_data[["displayName"]], names(entity_data))
    entity_data[i, idx] <- tmp_data[["value"]]
  }

  # combine the entity attributes with the entity data
  tracked_entities <- cbind(entity_attributes, entity_data)

  # replace the org unit id with the org unit name
  org_units <- get_org_unit_as_long(login = login, org_units = org_units)
  idx <- match(tracked_entities[["org_unit"]], org_units[["org_unit_ids"]])
  tracked_entities[["org_unit"]] <- org_units[["org_unit_names"]][idx]

  return(tracked_entities)
}

