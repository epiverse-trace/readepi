
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
#'   base_url = "https://play.im.dhis2.org/stable-2-42-0",
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




# function to get the list of programs
# returns the list of programs from both the Aggregate and Tracker systems
get_programs <- function(login) {
  # get the base URL the login object
  base_url <- gsub("/api/me", "", login[["url"]])

  # construct the URL to a specific program
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

# get data elements
get_data_elements <- function(login) {
  # get the base URL from the login object
  base_url <- gsub("/api/me", "", login[["url"]])

  # construct the URL to a specific program
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

#' Fetch the names, IDs and numeric levels defined in the DHIS2 instance, such
#' as "Country", "Region", "District", etc.
#'
#' @return A data frame with three columns that contain the numeric levels and
#' their corresponding names and IDs.
#' @examples
#' login <- dhis2_login(base_url, user_name, password)
#' org_unit_levels <- get_org_unit_levels(login)
get_org_unit_levels <- function(login) {
  # get the base URL the login object
  base_url <- gsub("/api/me", "", login[["url"]])

  # construct the URL to a specific program
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


#' Retrieves all organization units, along with their ID, name, parent ID, and
#' level.
#'
#' @return A data frame of organization units with fields: id, name, parent$id,
#' and level.
#' @examples
#' org_units <- get_org_units(login)
get_org_units <- function(login) {
  # get the base URL the login object
  base_url <- gsub("/api/me", "", login[["url"]])

  # construct the URL to a specific program
  url <- paste0(
    file.path(base_url, "api", "organisationUnits"),
    "?paging=false&fields=id,name,parent[id],level"
  )

  # update the URL and perform the query
  response <- login[["request"]] %>%
    httr2::req_url(url) %>%
    httr2::req_method("GET") %>%
    httr2::req_perform() %>%
    httr2::resp_body_json()

  # combine the response as a data frame
  org_units <- dplyr::bind_rows(response)

}


#' Build a hierarchical DataFrame of last-level organization units with readable level names
#'
#' This function filters out only the leaf-level organization units (i.e., those at the
#' maximum depth) and reconstructs the full path from root to leaf in a tabular format.
#' It also labels columns using the human-readable level names (e.g., "Country Name").
#'
#' @param org_units A list of all organization units returned by \code{fetch_org_units}.
#' @param level_name_map A named vector mapping level numbers to human-readable names.
#'
#' @return A \code{data.frame} where each row represents a last-level unit,
#' with columns labeled like "Country Name", "Country ID", etc.
#'
#' @examples
#' df <- get_organisation_units(login)
get_organisation_units <- function(login) {
  org_units <- get_org_units(login)
  org_unit_levels <- get_org_unit_levels(login)
  # get the org units ids and the maximum organisation unit level
  org_unit_ids <- org_units[["id"]]
  max_level <- max(org_unit_levels[["level"]])
  org_units_of_interest <- org_units |>
    dplyr::filter(level == max_level)
  # rows <- apply(org_units_of_interest, 1, trace_hierarchy)
  rows <- vector(mode = "list", length = nrow(org_units_of_interest))
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
    rows[[paste0("test_", i)]] <- hierarchy
  }
  rows <- data.frame(t(rows |> dplyr::bind_rows()))

  # in case of an empty line, remove it
  rows <- Filter(Negate(is.null), rows)

  # use human-readable names as column headers
  test_fn <- function(i, org_unit_levels) {
    idx <- which(org_unit_levels[["level"]] == i)
    level_name <- org_unit_levels[["name"]][idx]
    return(
      c(paste0(level_name, "_name"), paste0(level_name, "_id"))
    )
  }
  col_names <- unlist(lapply(1:max_level, test_fn, org_unit_levels))
  names(rows) <- col_names
  return(rows)
}

#' function to filter out all element of type list from a list object
#' in this particular case, it is used to filter out the 'createdBy' and
#' 'updatedBy' elements of the returned enrollment.
remove_list <- function(x) {
  # filter out list elements from a given enrollment
  # this will remove the 'createdBy' and 'updatedBy' elements of the list
  return(Filter(Negate(is.list), x))
}

get_org_unit_as_df <- function(login, org_units) {
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

#' org_unit_id <- check_org_unit(
#'   login = login,
#'   org_unit = "Freetown",
#'   org_units = org_units
#' )
check_org_unit <- function(login, org_unit, org_units) {
  # get all org units
  tmp_org_units <- get_org_unit_as_df(login, org_units)

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

#' program_id <- check_program(
#'   login = login,
#'   program = "Malaria focus investigation"
#' )
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


#' all_program_stages <- get_program_stages(
#'   login = login,
#'   program = NULL
#' )
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


#' function to return all enrollments from a specified organisation unit and
#' program
#'
#' It assumes that the program and org unit ids are already retrieved if the
#' user provided the names
#'
#' enrollments <- get_enrollments(
#'   login = login,
#'   org_unit = "DiszpKrYNg8",
#'   program = "M3xtLkYBlKI"
#' )
get_enrollments <- function(login, program, org_unit) {
  # check whether the provided program and organisation unit exist
  program <- check_program(login, program)
  org_unit <- check_org_unit(login, org_unit)

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


# Get event data
#' login <- dhis2_login(
#'   base_url = "https://cbs.apps.moh.gm/dhis/dhis-web-tracker-capture",
#'   user_name = "kebba.jobarteh",
#'   password = "Cbs@2025"
#' )
#' program <- "IpHINAT79UW"
#' org_unit <- "DiszpKrYNg8"
#' data_elements <- get_data_elements(login = login)
#' org_units <- get_organisation_units(login = login)
#' org_units <- get_org_unit_as_df(login = login, org_units)
#' program_stages <- get_program_stages(login, program)
#'
#' events <- get_event_data(login, program, org_unit)
get_event_data <- function(login, program, org_unit, data_elements,
                           org_units, programs, program_stages) {
  # check whether the provided program and organisation unit exist
  program <- check_program(login, program)
  org_unit <- check_org_unit(login, org_unit, org_units = org_units)

  if (is.null(data_elements)) {
    data_elements <- get_data_elements(login = login)
  }
  # if (is.null(org_units)) {
  #   org_units <- get_org_unit_as_df(login = login, org_units = org_units)
  # }
  if (is.null(program_stages)) {
    program_stages <- get_program_stages(login, program)
  }
  org_units <- get_org_unit_as_df(login = login, org_units = org_units)

  # get the base URL the login object
  base_url <- gsub("/api/me", "", login[["url"]])

  # construct the query parameter as a string
  query_parameters <- sprintf(
    "?orgUnit=%s&program=%s&paging=false",
    org_unit, program
  )

  # construct the URL to a specific program
  url <- paste0(
    file.path(base_url, "api", "tracker", "events"),
    # file.path(base_url, "api", "events"),
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
# Use this function to get the ids and names of the features collected about each tracked entities. The ids and names will be used to update the list of query parameters
get_entity_attributes <- function(x) {
  tmp <- x$attributes %>%
    dplyr::bind_rows()
  display_names <- tmp$displayName
  attribute_names <- data.frame(id = tmp$attribute, name = tmp$displayName)
  return(attribute_names)
}

# get the tracked entities
# target_entities <- paste(unique(event_data$tracked_entity), collapse = ",")
# tracked_entities <- get_tracked_entities(login, target_entities, org_units)
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
  org_units <- get_org_unit_as_df(login = login, org_units = org_units)
  idx <- match(tracked_entities[["org_unit"]], org_units[["org_unit_ids"]])
  tracked_entities[["org_unit"]] <- org_units[["org_unit_names"]][idx]

  return(tracked_entities)
}

