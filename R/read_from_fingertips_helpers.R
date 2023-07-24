#' get fingertips metadata
#'
#' @return a `list` of 3 objects of type `data.frame`. They contain information
#'    about the indicators in the Fingertips repository.
#'
#' @examples
#' \dontrun{
#' metadata <- get_fingertips_metadata()
#' }
#' @keywords internal
get_fingertips_metadata <- function() {
  list(
    indicator_profile_domain =
      fingertipsR::indicators(), # indicators, profiles, domains
    indicator_ids_names =
      fingertipsR::indicators_unique(), # indicators, ids, names
    area_type =
      fingertipsR::area_types() # area type ids, descriptions,
    # mapping of parent area types
  )
}

#' Get indicator ID from indicator name
#'
#' @param metadata a list with the fingertips metadata
#' @param indicator_name the indicator name
#'
#' @return an object of type `numeric` that contains the indicator ID
#' @examples
#' \dontrun{
#' indicator_id <- get_ind_id_from_ind_name(
#'   metadata = list(
#'     indicator_profile_domain = fingertipsR::indicators(),
#'     indicator_ids_names = fingertipsR::indicators_unique(),
#'     area_type = fingertipsR::area_types()
#'   ),
#'   indicator_name = "Pupil absence"
#' )
#' }
#'
get_ind_id_from_ind_name <- function(metadata, indicator_name) {
  indicator_name <- unlist(strsplit(indicator_name, ",", fixed = TRUE))
  idx <- as.numeric(lapply(indicator_name, grep,
                           metadata$indicator_ids_names$IndicatorName,
                           ignore.case=TRUE))
  if (all(is.na(idx))) {
    message("\nCould not find specified indicator name.\n
             Below is the list of all indicator names in Fingertips.\n")
    print(metadata$indicator_ids_names)
    stop()
  } else{
    if (length(which(is.na(idx))) > 0) {
      message("\nThe following indicator names were not found: ",
              glue::glue_collapse(indicator_name[which(is.na(idx))],
                                  sep = ", "))
    }
    indicator_id <- metadata$indicator_ids_names$IndicatorID[idx[!is.na(idx)]]
  }
  indicator_id
}

#' Get indicator ID from domain ID
#'
#' @param metadata a list with the fingertips metadata
#' @param domain_id the domain ID
#' @param indicator_name the indicator name
#'
#' @return an object of type `numeric` that contains the indicator ID
#' @examples
#' \dontrun{
#' indicator_id <- get_ind_id_from_domain_id(
#'   metadata = list(
#'     indicator_profile_domain = fingertipsR::indicators(),
#'     indicator_ids_names = fingertipsR::indicators_unique(),
#'     area_type = fingertipsR::area_types()
#'   ),
#'   domain_id = 1000041,
#'   indicator_name = NULL
#' )
#' }
#'
get_ind_id_from_domain_id <- function(metadata, domain_id,
                                      indicator_name = NULL) {

  # check if the provided domain_id is part of the Fingertips
  idx <- domain_id %in% metadata$indicator_profile_domain$DomainID

  # return an error message if all domain ids provided by the user are not found
  if (!any(idx)) {
    message("\nCould not find specified domain ID.\n
             Below is the list of all domain IDs in Fingertips.\n")
    print(metadata$indicator_profile_domain[, c("DomainID", "DomainName")])
    stop()
  } else{
    # send a message to user if he provided some domain ids that were not found
    # in Fingertips
    if (length(which(!(idx))) > 0) {
      message("\nThe following indicator names were not found: ",
              glue::glue_collapse(domain_id[which(!(idx))],
                                  sep = ", "))
      domain_id <- domain_id[-(which(!(idx)))]
    }

    # get the indicator ids
    idx <- which(domain_id == metadata$indicator_profile_domain$DomainID)
    if (!is.null(indicator_name)) {
      indicator_name <- unlist(strsplit(indicator_name, ",", fixed = TRUE))
      subs <- metadata$indicator_profile_domain[idx, ]
      subs <- subs[which(subs$IndicatorName %in% indicator_name), ]
      indicator_id <- subs$IndicatorID
    } else {
      indicator_id <-
        unique(metadata$indicator_profile_domain$IndicatorID[idx])
    }
  }
  indicator_id
}

#' Get indicator ID from domain name
#'
#' @param metadata a list with the fingertips metadata
#' @param domain_name the domain name
#' @param indicator_name the indicator name
#'
#' @return an object of type `numeric` that contains the indicator ID
#' @examples
#' \dontrun{
#' indicator_id <- get_ind_id_from_domain_name(
#'   metadata = list(
#'     indicator_profile_domain = fingertipsR::indicators(),
#'     indicator_ids_names = fingertipsR::indicators_unique(),
#'     area_type = fingertipsR::area_types()
#'   ),
#'   domain_name = "B. Wider determinants of health",
#' )
#' }
#'
get_ind_id_from_domain_name <- function(metadata, domain_name,
                                        indicator_name = NULL) {
  domain_name <- unlist(strsplit(domain_name, ",", fixed = TRUE))
  idx <- unique(unlist(lapply(metadata$indicator_profile_domain$DomainName,
                              grep,
                              domain_name,
                              ignore.case=TRUE)))
  if (all(is.na(idx)) || length(idx) == 0) {
    message("\nCould not find the specified domain name.\n
             Below is the list of all domain names in Fingertips.\n")
    print(metadata$indicator_profile_domain[, c("DomainID", "DomainName")])
    stop()
  } else{
    if (length(idx) < length(domain_name)) {
      message("\nThe following domain names were not found: ",
              glue::glue_collapse(domain_name[-idx],
                                  sep = ", "))
    }
    domain_name <- domain_name[idx]
    # get the indicator ids
    idx <- which(domain_name == metadata$indicator_profile_domain$DomainName)
    if (!is.null(indicator_name)) {
      indicator_name <- unlist(strsplit(indicator_name, ",", fixed = TRUE))
      subs <- metadata$indicator_profile_domain[idx, ]
      subs <- subs[which(subs$IndicatorName %in% indicator_name), ]
      indicator_id <- subs$IndicatorID
    } else {
      indicator_id <-
        unique(metadata$indicator_profile_domain$IndicatorID[idx])
    }
  }
  indicator_id
}


#' Get profile name from Fingertips
#'
#' @param profile_id the profile ID
#' @param profile_name the profile name
#' @param metadata the Fingertips metadata
#'
#' @return a `list` of 2 elements of type `character` and `numeric`. These are
#'    the `profile name` and their correspondent indexes.
#' @examples
#' \dontrun{
#' res <- get_profile_name(
#'   profile_id = 19,
#'   profile_name = "Public Health Outcomes Framework",
#'   metadata = list(
#'     indicator_profile_domain = fingertipsR::indicators(),
#'     indicator_ids_names = fingertipsR::indicators_unique(),
#'     area_type = fingertipsR::area_types()
#'   )
#' )
#' }
#'
get_profile_name <- function(profile_id, profile_name, metadata) {
  if (all(!is.null(profile_id) & !is.null(profile_name))) {
    profile_name <- unlist(strsplit(profile_name, ",", fixed = TRUE))
    idx <- which(metadata$indicator_profile_domain$ProfileID == profile_id &
      metadata$indicator_profile_domain$ProfileName == profile_name)
  } else if (!is.null(profile_id) && is.null(profile_name)) {
    idx <- which(metadata$indicator_profile_domain$ProfileID == profile_id)
  } else if (!is.null(profile_name) && is.null(profile_id)) {
    profile_name <- unlist(strsplit(profile_name, ",", fixed = TRUE))
    idx <- which(metadata$indicator_profile_domain$ProfileName == profile_name)
  }

  list(
    profile_name = profile_name,
    profile_index = idx
  )
}

#' Get indicator ID from profile ID and/or profile name
#'
#' @param metadata a list with the fingertips metadata
#' @param domain_id the domain ID
#' @param domain_name the domain name
#' @param indicator_name the indicator name
#' @param profile_name the profile name
#' @param profile_id the profile ID
#'
#' @return an object of type `numeric` that contains the indicator ID
#' @examples
#' \dontrun{
#' res <- get_ind_id_from_profile(
#'   metadata = list(
#'     indicator_profile_domain = fingertipsR::indicators(),
#'     indicator_ids_names = fingertipsR::indicators_unique(),
#'     area_type = fingertipsR::area_types()
#'   ),
#'   profile_id = 19
#' )
#' }
#'
get_ind_id_from_profile <- function(metadata, domain_id = NULL,
                                    domain_name = NULL,
                                    indicator_name = NULL,
                                    profile_name = NULL,
                                    profile_id = NULL) {
  tmp_res <- get_profile_name(profile_id, profile_name, metadata)
  profile_name <- tmp_res$profile_name
  idx <- tmp_res$profile_index

  if (length(idx) == 0) {
    message("\nCould not find the specified profile ID or name.\n
             Below is the list of all profile IDs and names in Fingertips.\n")
    print(metadata$indicator_profile_domain[, c("ProfileID", "ProfileName")])
    stop()
  } else {
    subs <- metadata$indicator_profile_domain[idx, ]
    if (!is.null(domain_id)) {
      subs <- subs %>% dplyr::filter(subs$DomainID == domain_id)
    }
    if (!is.null(domain_name)) {
      domain_name <- unlist(strsplit(domain_name, ",", fixed = TRUE))
      subs <- subs %>% dplyr::filter(subs$DomainName == domain_name)
    }
    if (!is.null(indicator_name)) {
      indicator_name <- unlist(strsplit(indicator_name, ",", fixed = TRUE))
      subs <- subs %>% dplyr::filter(subs$IndicatorName == indicator_name)
    }
    indicator_id <- subs$IndicatorID
  }
  indicator_id
}

#' Subset records when reading from Fingertips
#'
#' @param data the data read from Fingertips
#' @param records a vector or a comma-separated string of records
#' @param id_col_name the column name with the subject IDs
#'
#' @return an object of type `data.frame` with the Fingertips dataset that
#'    contains only the records of interest
#' @examples
#' \dontrun{
#' res <- fingertips_subset_rows(
#'   data = readepi(
#'     profile_id = 19,
#'     area_type_id = 202
#'   )$data,
#'   records = c("E92000001", "E12000002", "E12000009"),
#'   id_col_name = "AreaCode"
#' )
#' }
#'
fingertips_subset_rows <- function(data, records, id_col_name) {
  if (!is.null(records)) {
    records <- unlist(strsplit(records, ",", fixed = TRUE))
    records <- gsub(" ", "", records, fixed = TRUE)
    if (all(records %in% data[[id_col_name]])) {
      data <- data[which(data[[id_col_name]] %in% records), ]
    } else {
      idx <- which(records %in% data[[id_col_name]])
      warning("\n", length(records[-idx]), " records were not found in
              the data.")
      data <- data[which(data[[id_col_name]] %in% records[idx]), ]
    }
  }
  data
}


#' Subset columns when reading from Fingertips
#'
#' @param data the data read from Fingertips
#' @param fields a vector or a comma-separated string of column names
#'
#' @return an object of type `data.frame` with the Fingertips dataset that
#'    contains only the fields of interest
#' @examples
#' \dontrun{
#' res <- fingertips_subset_columns(
#'   data = readepi(
#'     profile_id = 19,
#'     area_type_id = 202
#'   )$data,
#'   fields = c("IndicatorID", "AreaCode", "Age", "Value")
#' )
#' }
#'
fingertips_subset_columns <- function(data, fields) {
  if (!is.null(fields)) {
    fields <- unlist(strsplit(fields, ",", fixed = TRUE))
    fields <- gsub(" ", "", fields, fixed = TRUE)
    idx <- which(fields %in% names(data))
    if (length(idx) == 0) {
      stop("\nCould not find specified fields. The field names in the dataset
           are:\n", print(names(data)))
    } else if (length(idx) != length(fields)) {
      warning("\nCould not find the following fields:\n", print(fields[-idx]))
    } else {
      data <- data %>% dplyr::select(dplyr::all_of(fields[idx]))
    }
  }
  data
}
