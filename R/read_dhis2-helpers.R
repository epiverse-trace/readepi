#' Get DHIS2 API version
#'
#' @inheritParams read_dhis2
#'
#' @returns A numeric with minor version of the API
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
#'
#'   # get the API version
#'   api_version <- get_api_version(login = dhis2_login)
#' }
get_api_version <- function(login) {
  base_url <- gsub("/api/me", "", login[["url"]], fixed = TRUE) # nolint: absolute_path_linter
  target_url <- paste0(file.path(base_url, "api", "system", "info"))
  api_version <- login[["request"]] |>
    httr2::req_url(target_url) |>
    httr2::req_method("GET") |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  minor <- unlist(strsplit(api_version[["version"]], ".", fixed = TRUE))[[2]]
  return(as.numeric(minor))
}


#' Establish connection to a DHIS2 instance
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
#' \dontrun{
#'   dhis2_log <- dhis2_login(
#'     base_url = "https://play.im.dhis2.org/stable-2-42-1",
#'     user_name = "admin",
#'     password = "district"
#'   )
#' }
dhis2_login <- function(base_url,
                        user_name,
                        password) {
  target_url <- file.path(base_url, "api", "me")
  resp <- httr2::request(target_url) |>
    httr2::req_auth_basic(user_name, password) |>
    httr2::req_perform()
  cli::cli_alert_success("Logged in successfully!")
  return(invisible(resp))
}

#' get all programs from a given specific DHIS2 instance
#'
#' The function first fetches all programs from the DHIS2 Aggregate system,
#' then distinguishes the Tracker and Aggregate programs.
#'
#' @inheritParams read_dhis2
#'
#' @returns A data frame with the following columns: the program ID, the program
#'    name, and the program type specifying whether the program is part of the
#'    Aggregate or Tracker system.
#'
#' @export
#' @examples
#' \dontrun{
#'   # establish the connection to the system
#'   dhis2_login <- login(
#'     type = "dhis2",
#'     from = "https://smc.moh.gm/dhis",
#'     user_name = "test",
#'     password = "Gambia@123"
#'   )
#'
#'   # fetch the programs
#'   programs <- get_programs(login = dhis2_login)
#' }
#'
get_programs <- function(login) {
  # get the base URL the login object
  base_url <- gsub("/api/me", "", login[["url"]], fixed = TRUE) # nolint: absolute_path_linter

  # construct the URL to target the program endpoint
  target_url <- paste0(
    file.path(base_url, "api", "programs"),
    "?fields=id,displayName&paging=false"
  )

  # modify the request URL and perform the request to get all programs
  all_programs <- login[["request"]] |>
    httr2::req_url(target_url) |>
    httr2::req_method("GET") |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    dplyr::bind_rows()

  # add a label to the programs to identify Tracker and Aggregate programs
  all_programs[["type"]] <- "aggregate"

  # identify the programs registered in the Tracker
  target_url <- paste0(target_url, "&filter=programType:eq:WITH_REGISTRATION")

  # perform the request to fetch the programs
  tracker_programs <- login[["request"]] |>
    httr2::req_url(target_url) |>
    httr2::req_method("GET") |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    dplyr::bind_rows()

  # change the labels of the Tracker programs
  matches <- all_programs[["id"]] %in% tracker_programs[["id"]]
  all_programs[["type"]][matches] <- "tracker"

  return(all_programs)
}

#' Get all data elements from a specific DHIS2 instance
#'
#' @inheritParams read_dhis2
#'
#' @returns A data frame with the following two columns: the data elements IDs
#'    and their corresponding names.
#' @export
#'
#' @examples
#' \dontrun{
#'   # establish the connection to the system
#'   dhis2_login <- login(
#'     type = "dhis2",
#'     from = "https://smc.moh.gm/dhis",
#'     user_name = "test",
#'     password = "Gambia@123"
#'   )
#'
#'   # retrieve the data elements
#'   data_elements <- get_data_elements(login = dhis2_login)
#' }
#'
get_data_elements <- function(login) {
  # get the base URL from the login object
  base_url <- gsub("/api/me", "", login[["url"]], fixed = TRUE) # nolint: absolute_path_linter

  # construct the URL to target the dataElements endpoint
  target_url <- paste0(
    file.path(base_url, "api", "dataElements"),
    "?fields=id,name&paging=false"
  )

  # modify the request URL and perform the request
  data_elements <- login[["request"]] |>
    httr2::req_url(target_url) |>
    httr2::req_method("GET") |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    dplyr::bind_rows()

  return(data_elements)
}


#' Transform the organisation units data frame from large to long format
#'
#' @param login The login object
#' @param org_units A data frame of all the organisation units obtained from the
#'    `get_organisation_units()` function. Default is `NULL`.
#'
#' @returns A data with three columns corresponding to the organisation unit
#'    names, IDs, and levels
#'
#' @keywords internal
get_org_unit_as_long <- function(login, org_units = NULL) {
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
#' @inheritParams read_dhis2
#'
#' @return A data frame with three columns containing the organization unit's
#'    names, IDs, and their hierarchical levels.
#' @keywords internal
#'
get_org_unit_levels <- function(login) {
  # get the base URL the login object
  base_url <- gsub("/api/me", "", login[["url"]], fixed = TRUE) # nolint: absolute_path_linter

  # construct the URL to target the organisationUnitLevels
  target_url <- paste0(
    file.path(base_url, "api", "organisationUnitLevels"),
    "?paging=false&fields=level,name,id"
  )

  # update the URL and perform the query
  org_unit_levels <- login[["request"]] |>
    httr2::req_url(target_url) |>
    httr2::req_method("GET") |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  # combine the response as a data frame
  org_unit_levels <- dplyr::bind_rows(org_unit_levels)

  return(org_unit_levels)
}


#' Retrieve  DHIS2 organization units, along with their IDs, names,
#' parent IDs, and levels.
#'
#' @inheritParams read_dhis2
#'
#' @returns A data frame of organization units with the following fields:
#'    organisation unit id and name, as well as the corresponding parent
#'    organisation unit id, and level.
#' @keywords internal
#'
get_org_units <- function(login) {
  # get the base URL the login object
  base_url <- gsub("/api/me", "", login[["url"]], fixed = TRUE) # nolint: absolute_path_linter

  # construct the URL to target the organisationUnits endpoint
  target_url <- paste0(
    file.path(base_url, "api", "organisationUnits"),
    "?paging=false&fields=id,name,parent[id],level"
  )

  # update the URL and perform the query
  response <- login[["request"]] |>
    httr2::req_url(target_url) |>
    httr2::req_method("GET") |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  # combine the response as a data frame
  org_units <- dplyr::bind_rows(response)
  return(org_units)
}

#' Get the organization units from a specific DHIS2 instance
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
#' @inheritParams read_dhis2
#'
#' @return A data frame where each row represents a full hierarchy for the
#'    last-level unit by keeping the hierarchical organizational unit's name and
#'    ID at each level, using the official level names provided by the DHIS2
#'    instance like "Country Name", "Country ID", etc.
#'
#' @export
#'
#' @examples
#' \dontrun{
#'   # establish the connection to the system
#'   dhis2_login <- login(
#'     type = "dhis2",
#'     from = "https://smc.moh.gm/dhis",
#'     user_name = "test",
#'     password = "Gambia@123"
#'   )
#'
#'   # fetch the organisation units
#'   org_units <- get_organisation_units(login = dhis2_login)
#' }
#'
get_organisation_units <- function(login) {
  id <- NULL
  # get all organisation units and their levels
  org_units <- get_org_units(login)
  org_unit_levels <- get_org_unit_levels(login)

  # get the org units ids and the maximum organisation unit level
  max_level <- max(org_unit_levels[["level"]])
  org_units_of_interest <- org_units |> dplyr::filter(level == max_level)
  result <- vector(mode = "list", length = nrow(org_units_of_interest))
  for (i in seq_len(nrow(org_units_of_interest))) {
    current <- org_units_of_interest[i, ]
    level <- current[["level"]]
    hierarchy <- rep("", level * 2)
    while (!is.null(current)) {
      idx <- (current[["level"]] - 1) * 2
      hierarchy[idx + 1] <- current[["name"]]
      hierarchy[idx + 2] <- current[["id"]]
      parent_id <- current[["parent"]][["id"]]
      if (!is.null(parent_id) && parent_id %in% org_units[["id"]]) {
        current <- org_units |> dplyr::filter(id == parent_id) # nolint: object_usage_linter
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


#' Validate user-specified organisation unit ID or name.
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
#' @returns The organisation unit ID if the provided organisation unit ID or
#' name exists; otherwise, an error is thrown with a suggestion to use the
#' function that lists all available organisation units from the target DHIS2
#' instance.
#'
#' @keywords internal
#'
check_org_unit <- function(login, org_unit, org_units = NULL) {
  if (is.null(org_units)) {
    org_units <- get_organisation_units(login = login)
  }
  # get all org units
  tmp_org_units <- get_org_unit_as_long(login, org_units = org_units)

  if (!(org_unit %in% tmp_org_units[["org_unit_ids"]])) {
    if (org_unit %in% tmp_org_units[["org_unit_names"]]) {
      idx <- which(tmp_org_units[["org_unit_names"]] == org_unit)
      org_unit <- unique(tmp_org_units[["org_unit_ids"]][idx])
    } else {
      # If no, return an error that the provided organisation unit is incorrect
      # and give the name of the function to be used for getting the available
      # organisation units
      cli::cli_abort(c(
        x = "You provided an incorrect organisation unit ID or name.",
        i = "Use the {.fn get_organisation_units} function to get the list of \\
             all available organisation units."
      ))
    }
  }

  return(org_unit)
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
#' @returns The program ID if the provide program name or ID exists; otherwise,
#' an error is thrown with a suggestion to use the function that lists all
#' available programs from the target DHIS2 instance.
#'
#' @keywords internal
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
    if (all(is.na(idx))) {
      cli::cli_abort(c(
        x = "You provided {cli::qty(length(idx))} {?an/} incorrect program \\
             ID{?s} or name{?s}.",
        i = "Use the {.fn get_programs} function to get the list of all \\
             available programs."
      ))
    }
  }

  # send a message if there are some programs that were not found
  if (anyNA(idx)) {
    not_avail <- program[is.na(idx)] # nolint: object_usage_linter
    cli::cli_alert_warning(
      "Could not find the following {cli::qty(length(not_avail))}\\
       program{?s}: {.strong {toString(not_avail)}}"
    )
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
#' @inheritParams read_dhis2
#' @inheritParams get_event_data
#' @returns A data frame with the following columns:
#'    1. `program_id`: the unique ID of the program
#'    2. `program_name`: the displayed name of the program
#'    3. `program_stage_name`: the name of each stage associate with the program
#'    4. `program_stage_id`: the ID of each program stage
#' @examples
#' \dontrun{
#'   # establish the connection to the DHIS2 instance
#'   dhis2_login <- login(
#'     type = "dhis2",
#'     from = "https://smc.moh.gm/dhis",
#'     user_name = "test",
#'     password = "Gambia@123"
#'   )
#'
#'   # get the list of all program stages from the DHIS2 instance
#'   all_program_stages <- get_program_stages(
#'     login = dhis2_login,
#'     program = "E5IUQuHg3Mg",
#'     programs = NULL
#'   )
#' }
#' @export
get_program_stages <- function(login, programs = NULL, program = NULL) {
  # get all the programs and match the ids with the provided ones
  if (is.null(programs)) {
    programs <- get_programs(login)
  }

  # check if the provided program IDs actually exist in the system
  if (!is.null(program)) {
    idx <- match(program, programs[["id"]])
    if (all(is.na(idx))) {
      idx <- match(program, programs[["displayName"]])
      if (all(is.na(idx))) {
        cli::cli_abort(c(
          x = "You provided {cli::qty(sum(is.na(idx)))} {?an/} incorrect \\
               program ID{?s}"
        ))
      }
    }

    # send a message if there are some programs that were not found
    if (anyNA(idx)) {
      not_avail <- program[is.na(idx)] # nolint: object_usage_linter
      cli::cli_alert_warning(
        "Could not find the following {cli::qty(length(not_avail))}\\
         program{?s}: {.strong {toString(not_avail)}}"
      )
    }

    # only keep the programs that match the ones found in the system
    idx <- idx[!is.na(idx)]
    programs <- programs[idx, ]
  }


  # get the base URL the login object
  base_url <- gsub("/api/me", "", login[["url"]], fixed = TRUE) # nolint: absolute_path_linter

  program_stages <- vector("list", length = nrow(programs))
  for (i in seq_len(nrow(programs))) {
    program_id <- programs[["id"]][i]
    program_name <- programs[["displayName"]][i]

    # construct the URL to a specific program
    target_url <- paste0(
      file.path(base_url, "api", "programs", program_id),
      "?fields=programStages[id,name]&paging=false"
    )

    # modify the request URL and perform the request
    program_stage <- login[["request"]] |>
      httr2::req_url(target_url) |>
      httr2::req_method("GET") |>
      httr2::req_perform() |>
      httr2::resp_body_json() |>
      dplyr::bind_rows()

    # rename the output data frame
    names(program_stage) <- c("program_stage_name", "program_stage_id")

    program_stages[[i]] <- data.frame(cbind(
      program_id = program_id,
      program_name = program_name,
      program_stage
    ))
  }

  program_stages <- dplyr::bind_rows(program_stages)
  return(program_stages)
}

#' Get the attribute names and ids of the tracked entities
#'
#' Use this function to get the ids and names of the features collected about
#' each tracked entities. The ids and names will be used to update the list
#' of query parameters.
#'
#' @param x A list with the tracked entity attributes
#'
#' @returns A data frame with two columns representing the tracked entity
#'    attributes IDs and display names.
#' @keywords internal
#'
get_entity_attributes <- function(x) {
  tmp <- x[["attributes"]] |>
    dplyr::bind_rows()
  attribute_names <- data.frame(
    id = tmp[["attribute"]],
    name = tmp[["displayName"]]
  )
  return(attribute_names)
}




#' Get event data from the newer DHIS2 versions (version >= 2.41)
#'
#' @inheritParams read_dhis2
#' @param api_version A numeric with the API version returned by the
#'    `get_api_version()` function
#' @param data_elements A data frame with the data element IDs and names
#'    obtained from the `get_data_elements()` function
#' @param programs A data frame with the program IDs and names obtained from the
#'    `get_programs()` function
#' @param program_stages A data frame with the program stages IDs and names
#'    obtained from the `get_program_stages()` function
#' @param org_units A data frame with the organisation units IDs and names
#'    obtained from the `get_organisation_units()` function
#'
#' @returns A data frame with the data elements obtained from each event
#' @keywords internal
#'
get_event_data <- function(login, api_version, org_unit, program, data_elements,
                           programs, program_stages, org_units) {
  checkmate::assert_numeric(api_version, lower = 22, upper = 42,
                            any.missing = FALSE, len = 1, null.ok = FALSE)

  # get the request parameters
  request_params <- get_request_params(api_version)

  # construct the URL to target the events endpoint based on the API version
  base_url <- gsub("/api/me", "", login[["url"]], fixed = TRUE) # nolint: absolute_path_linter
  target_url <- paste0(
    file.path(base_url, "api", request_params[["e_endpoint"]]),
    sprintf(
      "?%s=%s&program=%s&%s&%s=SELECTED",
      request_params[["e_orgunit"]], org_unit, program,
      request_params[["paging"]], request_params[["e_oumode"]]
    )
  )

  # submit a request to fetch the event data
  response <- login[["request"]] |>
    httr2::req_url(target_url) |>
    httr2::req_method("GET") |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  # get the list of all retrieved events and
  # extract the event metadata
  all_events <- response[[request_params[["e_response"]]]]
  event_metadata <- purrr::map(
    all_events, ~ c(event = .x[["event"]],
                    tracked_entity = .x[["trackedEntity"]],
                    enrollment = .x[["enrollment"]],
                    org_unit = .x[["orgUnit"]],
                    program = .x[["program"]],
                    program_stage = .x[["programStage"]],
                    event_date = .x[["occurredAt"]])
  ) |>
    dplyr::bind_rows()

  # get the list of all data values from each event
  data_values_list <- purrr::map(all_events, ~ .x[["dataValues"]])

  # get the data elements recorded from all events
  target_data_elements <- lapply(data_values_list, function(group) {
    sapply(group, function(x) x[["dataElement"]]) # nolint: undesirable_function_linter
  })

  # Flatten the list of data elements
  target_data_elements <- unique(unlist(target_data_elements))

  # construct the data frame that will contain the event data
  event_data <- as.data.frame(
    matrix(nrow = length(all_events), ncol = length(target_data_elements))
  )
  names(event_data) <- target_data_elements

  # loop through the list of data values to get the data elements and their
  # values for every event entry
  for (i in seq_along(data_values_list)) {
    # skip when there is no data values for a given event
    if (length(data_values_list[[i]]) == 0) {
      next
    }

    # get the data elements and their values from a given event
    target <- data_values_list[[i]]
    target_data_elements <- unlist(purrr::map(target, ~ .x[["dataElement"]]))
    target_data_values <- unlist(
      purrr::map(target, ~ ifelse("value" %in% names(.x), .x[["value"]], NA))
    )

    # fill in the event data frame at the corresponding line and columns
    idx <- match(target_data_elements, names(event_data))
    event_data[i, idx] <- target_data_values
  }

  # rename the columns of the event_data using their data element names
  idx <- match(names(event_data), data_elements[["id"]])
  names(event_data) <- data_elements[["name"]][idx]

  # combine the event data and their attributes
  events <- cbind(event_metadata, event_data)

  # replace the program id by the program name
  idx <- match(events[["program"]], programs[["id"]])
  events[["program"]] <- programs[["displayName"]][idx]

  # replace the program stage ids by the program stage names
  idx <- match(events[["program_stage"]], program_stages[["program_stage_id"]])
  events[["program_stage"]] <- program_stages[["program_stage_name"]][idx]

  # replace the organisation unit ids by their names
  org_units <- get_org_unit_as_long(login = login, org_units = org_units)
  idx <- match(events[["org_unit"]], org_units[["org_unit_ids"]])
  events[["org_unit"]] <- org_units[["org_unit_names"]][idx]

  return(events)
}


#' Get tracked entity attributes, their corresponding IDs and event IDs
#'
#' @inheritParams read_dhis2
#' @param api_version A numeric with the API version obtained from the
#'    `get_api_version()` function
#' @param org_units A data frame with all organisation units from target DHIS2
#'    instance. This is the output from the `get_organisation_units()` function
#'
#' @returns A data frame with the tracked entity attributes alongside their
#'    events and tracked entity IDs
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
#'
#'   # set the program and org unit IDs
#'   program <- "E5IUQuHg3Mg"
#'   org_unit <- "GcLhRNAFppR"
#'
#'   # get the api version
#'   api_version <- get_api_version(login = dhis2_login)
#'
#'   # get all the organisation units from the DHIS2 instance
#'   org_units <- get_organisation_units(login = dhis2_login)
#'
#'   # get the tracked entity attributes
#'   tracked_entity_attributes <- get_tracked_entities(
#'     login = dhis2_login,
#'     api_version = api_version,
#'     org_unit = org_unit,
#'     program = program,
#'     org_units = org_units
#'   )
#' }
get_tracked_entities <- function(login, api_version, org_unit, program,
                                 org_units) {
  checkmate::assert_numeric(api_version, lower = 22, upper = 42,
                            any.missing = FALSE, len = 1, null.ok = FALSE)

  # get the request parameters
  request_params <- get_request_params(api_version)

  # construct the URL to target the events endpoint based on the API version
  base_url <- gsub("/api/me", "", login[["url"]], fixed = TRUE) # nolint: absolute_path_linter
  fields <- sprintf(
    "%s,orgUnit,attributes,enrollments[events[event]]",
    request_params[["te_teid"]]
  )
  target_url <- paste0(
    file.path(base_url, "api", request_params[["te_endpoint"]]),
    sprintf(
      "?%s=%s&program=%s&%s&fields=%s&%s=SELECTED",
      request_params[["te_orgunit"]], org_unit, program,
      request_params[["paging"]], fields, request_params[["te_oumode"]]
    )
  )

  # query the track entity endpoint
  response <- login[["request"]] |>
    httr2::req_url(target_url) |>
    httr2::req_method("GET") |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  # get the list of tracked entity data
  tracked_entities <- response[[request_params[["te_response"]]]]

  # stop and send a message if no tracked entity was found
  if (length(tracked_entities) == 0) {
    cli::cli_abort(
      x = "No tracked entity was found."
    )
  }

  # get the tracked entity attributes
  entity_attributes <- get_entity_data(
    login, api_version, tracked_entities, org_units
  )

  # get the event IDs
  event_ids <- lapply(tracked_entities, get_event_ids)
  names(event_ids) <- entity_attributes[["tracked_entity"]]
  event_ids <- suppressWarnings(utils::stack(event_ids))
  names(event_ids) <- c("event", "tracked_entity")

  # merge event IDs with entity attributes
  tracked_entities_data <- event_ids |>
    dplyr::left_join(
      entity_attributes,
      by = "tracked_entity",
      relationship = "many-to-many"
    )

  return(tracked_entities_data)
}


#' Get tracked entity attributes
#'
#' @inheritParams get_tracked_entities
#'
#' @returns A data frame with the tracked entity attributes
#' @keywords internal
#'
get_entity_data <- function(login, api_version, tracked_entities, org_units) {
  entity_metadata <- purrr::map(
    tracked_entities, ~ c(tracked_entity = .x[["trackedEntity"]],
                          tracked_entity_type = .x[["trackedEntityType"]],
                          org_unit = .x[["orgUnit"]])
  ) |>
    dplyr::bind_rows()

  # get the tracked entity attribute names and ids
  attributes_names <- suppressWarnings(
    dplyr::bind_rows(purrr::map(tracked_entities, get_entity_attributes))
  ) |>
    dplyr::distinct()

  # send a message when no tracked entity has an attribute
  if (nrow(attributes_names) == 0) {
    cli::cli_alert_warning("No attribute found across all tracked entities.")
  }

  # access the list of all tracked entity attributes
  all_attributes <- purrr::map(tracked_entities, ~ .x[["attributes"]])

  # construct the data frame that will contain the tracked entity attribute data
  entity_data <- as.data.frame(
    matrix(nrow = length(tracked_entities), ncol = nrow(attributes_names))
  )
  names(entity_data) <- attributes_names[["name"]]

  # loop through the tracked entity list of attributes to get the data elements
  # and values for every entry
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
  tracked_entities <- cbind(entity_metadata, entity_data)

  # replace the org unit id with the org unit name
  org_units <- get_org_unit_as_long(login = login, org_units = org_units)
  idx <- match(tracked_entities[["org_unit"]], org_units[["org_unit_ids"]])
  tracked_entities[["org_unit"]] <- org_units[["org_unit_names"]][idx]

  return(tracked_entities)
}

#' Get event IDs for specific tracked entity
#'
#' @param tracked_entity A list with tracked entity data
#'
#' @returns A data frame of event IDs associated with the specific tracked
#'    entity
#' @keywords internal
#'
get_event_ids <- function(tracked_entity) {
  # fetch the event information from the enrollment element of the list,
  # and the event from that object
  enrollments <- tracked_entity[["enrollments"]]
  events <- enrollments[[1]][["events"]]
  if (length(events) == 0) {
    return(NULL)
  }
  event_ids <- dplyr::bind_rows(purrr::map(events, ~ c(event = .x[["event"]])))
  return(event_ids[["event"]])
}


#' Get the request query parameters for a specific API version
#'
#' @param api_version A numeric with the API version
#'
#' @returns A data frame with single row containing the query parameters needed
#'    to submit a request
#' @keywords internal
#'
get_request_params <- function(api_version) {
  # get the target data set
  req_params <- dplyr::case_when(
    api_version <= 37 ~ readepi::request_parameters[1, -1],
    38 <= api_version & api_version <= 40 ~ readepi::request_parameters[2, -1],
    api_version >= 41 ~ readepi::request_parameters[3, -1]
  )
  return(req_params)
}


#' Get organisation units that are associated with a given program
#'
#' @inheritParams read_dhis2
#' @inheritParams get_tracked_entities
#'
#' @returns A data frame with the organisation units associated with the
#'    provided program
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
#'
#'   # fetch the organisation units
#'   org_units <- get_organisation_units(login = dhis2_login)
#'
#'   # get the organisation units associated with the following program
#'   'E5IUQuHg3Mg'
#'   target_org_units <- get_program_org_units(
#'     login = dhis2_login,
#'     program = "E5IUQuHg3Mg",
#'     org_units = org_units
#'   )
#' }
get_program_org_units <- function(login, program, org_units = NULL) {
  # construct the URL to target the programs endpoint
  base_url <- gsub("/api/me", "", login[["url"]], fixed = TRUE) # nolint: absolute_path_linter
  target_url <- paste0(
    file.path(base_url, "api", "programs", "orgUnits"),
    sprintf("?programs=%s", program)
  )

  # query the programs endpoint
  response <- login[["request"]] |>
    httr2::req_url(target_url) |>
    httr2::req_method("GET") |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  target_org_units <- data.frame(
    org_unit_ids = unlist(response[[program]]),
    stringsAsFactors = FALSE
  )

  # convert the org units into long format
  if (is.null(org_units)) {
    org_units <- get_organisation_units(login = login)
  }
  tmp_org_units <- get_org_unit_as_long(login = login, org_units = org_units)
  target_org_units <- target_org_units |>
    dplyr::left_join(tmp_org_units, by = "org_unit_ids")

  return(target_org_units)
}
