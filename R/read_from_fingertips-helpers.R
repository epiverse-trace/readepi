#' get fingertips metadata
#'
<<<<<<< HEAD
#' @return a `list` of 3 objects of type `data.frame`. They contain information
#'    about the indicators in the Fingertips repository.
#'
#' @examples
#' \dontrun{
#'   metadata <- get_fingertips_metadata()
#' }
#' @keywords internal
=======
#' @return a list of data frames
#' @export
#' @examples
#' metadata <- get_fingertips_metadata()
>>>>>>> main
#'
get_fingertips_metadata <- function() {
  list(
    indicator_profile_domain =
      fingertipsR::indicators(), # indicators, profiles, domains
    indicator_ids_names =
      fingertipsR::indicators_unique(), # indicators, ids, names
    area_type =
      fingertipsR::area_types() # area type ids, descriptions,
<<<<<<< HEAD
    # mapping of parent area types
=======
    #mapping of parent area types
>>>>>>> main
  )
}

#' Get indicator ID from indicator name
#'
#' @param metadata a list with the fingertips metadata
#' @param indicator_name the indicator name
#'
<<<<<<< HEAD
#' @return an object of type `numeric` that contains the indicator ID
#'
#' @examples
#' \dontrun{
#' indicator_id <- get_ind_id_from_ind_name(
#'   metadata       = list(
#'     indicator_profile_domain = fingertipsR::indicators(),
#'     indicator_ids_names      = fingertipsR::indicators_unique(),
#'     area_type                = fingertipsR::area_types()
#'   ),
#'   indicator_name = "Pupil absence"
#' )
#' }
#' @keywords internal
get_ind_id_from_ind_name <- function(metadata, indicator_name) {
  checkmate::assert_list(metadata,
                         len = 3L, null.ok = FALSE,
                         any.missing = FALSE
  )
  checkmate::assert_vector(indicator_name,
                           min.len = 1L, null.ok = FALSE,
                           any.missing = FALSE
  )
  indicator_name <- unlist(strsplit(indicator_name, ",", fixed = TRUE))
  idx <- suppressWarnings(
    as.numeric(
      as.character(
        unlist(
          lapply(
            indicator_name,
            match,
            metadata[["indicator_ids_names"]][["IndicatorName"]]
          )
        )
      )
    ) # nolint: line_length_linter
  )
  if (all(is.na(idx))) {
    message("\nCould not find specified indicator name.\n
             Below is the list of all indicator names in Fingertips.\n")
    print(metadata[["indicator_ids_names"]])
    stop()
  } else {
    if (anyNA(idx)) {
      warning("\nThe following indicator names were not found: ",
              glue::glue_collapse(indicator_name[which(is.na(idx))],
                                  sep = ", "
              ),
              call. = FALSE
      )
    }
    indicator_id <-
      metadata[["indicator_ids_names"]][["IndicatorID"]][idx[!is.na(idx)]]
=======
#' @return the indicator ID
#' @export
#' @examples
#' indicator_id <- get_ind_id_from_ind_name(
#' metadata = list(
#'   indicator_profile_domain = fingertipsR::indicators(),
#'   indicator_ids_names = fingertipsR::indicators_unique(),
#'   area_type = fingertipsR::area_types()
#'   ),
#' indicator_name = "Pupil absence"
#' )
#'
get_ind_id_from_ind_name <- function(metadata, indicator_name) {
  checkmate::assert_list(metadata, any.missing = FALSE, len = 3,
                         null.ok = FALSE)
  checkmate::assert_vector(indicator_name, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE
  )

  indicator_name <- unlist(strsplit(indicator_name, ",", fixed = TRUE))
  idx <- which(metadata$indicator_ids_names$IndicatorName == indicator_name)
  if (length(idx) == 0) {
    subs <- metadata$indicator_ids_names[grepl(
      tolower(indicator_name),
      tolower(metadata$indicator_ids_names$IndicatorName)
    ), ]
    if (nrow(subs) == 0) {
      R.utils::cat("\nCould not find specified indicator name.\n
             Below is the list of all indicator names in Fingertips.\n")
      print(metadata$indicator_ids_names)
      stop()
    } else {
      R.utils::cat("\nspecified indicator name not found but detected following
                   similar indicator names:\n")
      print(subs)
    }
  } else {
    indicator_id <- metadata$indicator_ids_names$IndicatorID[idx]
>>>>>>> main
  }
  indicator_id
}

#' Get indicator ID from domain ID
#'
#' @param metadata a list with the fingertips metadata
#' @param domain_id the domain ID
#' @param indicator_name the indicator name
#'
<<<<<<< HEAD
#' @return an object of type `numeric` that contains the indicator ID
#' @examples
#' \dontrun{
#' indicator_id <- get_ind_id_from_domain_id(
#'   metadata       = list(
#'     indicator_profile_domain = fingertipsR::indicators(),
#'     indicator_ids_names      = fingertipsR::indicators_unique(),
#'     area_type                = fingertipsR::area_types()
#'   ),
#'   domain_id      = 1000041,
#'   indicator_name = NULL
#' )
#' }
#' @keywords internal
#'
get_ind_id_from_domain_id <- function(metadata, domain_id,
                                      indicator_name = NULL) {
  checkmate::assert_list(metadata,
                         len = 3L, null.ok = FALSE,
                         any.missing = FALSE
  )
  checkmate::assert_vector(domain_id,
                           min.len = 1L, null.ok = FALSE,
                           any.missing = FALSE
  )
  checkmate::assert_vector(indicator_name,
                           min.len = 1L, null.ok = TRUE,
                           any.missing = FALSE
  )
  # check if the provided domain_id is part of the Fingertips
  idx <- domain_id %in% metadata[["indicator_profile_domain"]][["DomainID"]]

  # return an error message if all domain ids provided by the user are not found
  if (!any(idx)) {
    message("\nCould not find specified domain ID.\n
             Below is the list of all domain IDs in Fingertips.")
    print(metadata[["indicator_profile_domain"]][, c("DomainID", "DomainName")])
    stop()
  } else {
    # send a message to user if he provided some domain ids that were not found
    # in Fingertips
    if (!all(idx) > 0L) {
      warning(
        "\nThe following indicator names were not found: ",
        glue::glue_collapse(domain_id[!idx], sep = ", ")
      )
      domain_id <- domain_id[!idx]
    }

    # get the indicator ids
    idx <- which(domain_id ==
                   metadata[["indicator_profile_domain"]][["DomainID"]])
    if (!is.null(indicator_name)) {
      indicator_name <- unlist(strsplit(indicator_name, ",", fixed = TRUE))
      subs <- metadata[["indicator_profile_domain"]][idx, ]
      subs <- subs[which(subs[["IndicatorName"]] %in% indicator_name), ]
      indicator_id <- subs[["IndicatorID"]]
    } else {
      indicator_id <-
        unique(metadata[["indicator_profile_domain"]][["IndicatorID"]][idx])
=======
#' @return the indicator ID
#' @export
#' @examples
#' indicator_id <- get_ind_id_from_domain_id(
#' metadata = list(
#'   indicator_profile_domain = fingertipsR::indicators(),
#'   indicator_ids_names = fingertipsR::indicators_unique(),
#'   area_type = fingertipsR::area_types()
#'   ),
#' domain_id = 1000041,
#' indicator_name = NULL
#' )
#'
get_ind_id_from_domain_id <- function(metadata, domain_id,
                                      indicator_name = NULL) {
  checkmate::assert_list(metadata, any.missing = FALSE, len = 3,
                         null.ok = FALSE)
  checkmate::assert_vector(indicator_name, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE
  )
  checkmate::assert_vector(domain_id, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)

  idx <- which(metadata$indicator_profile_domain$DomainID == domain_id)
  if (length(idx) == 0) {
    subs <- metadata$indicator_profile_domain[grepl(
      domain_id,
      metadata$indicator_profile_domain$DomainID
    ), ]
    if (nrow(subs) == 0) {
      R.utils::cat("\nCould not find specified domain ID.\n
             Below is the list of all domain IDs in Fingertips.\n")
      print(metadata$indicator_profile_domain[, c("DomainID", "DomainName")])
      stop()
    } else {
      R.utils::cat("\nspecified domain ID not found but detected following
                   similar domain IDs:\n")
      print(subs[, c("DomainID", "DomainName")])
    }
  } else {
    if (!is.null(indicator_name)) {
      indicator_name <- unlist(strsplit(indicator_name, ",", fixed = TRUE))
      subs <- metadata$indicator_profile_domain[idx, ]
      subs <- subs[which(subs$IndicatorName %in% indicator_name), ]
      indicator_id <- subs$IndicatorID
    } else {
      indicator_id <- metadata$indicator_profile_domain$IndicatorID[idx]
>>>>>>> main
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
<<<<<<< HEAD
#' @return an object of type `numeric` that contains the indicator ID
#' @examples
#' \dontrun{
#' indicator_id <- get_ind_id_from_domain_name(
#'   metadata    = list(
#'     indicator_profile_domain = fingertipsR::indicators(),
#'     indicator_ids_names      = fingertipsR::indicators_unique(),
#'     area_type                = fingertipsR::area_types()
#'   ),
#'   domain_name = "B. Wider determinants of health",
#' )
#' }
#' @keywords internal
get_ind_id_from_domain_name <- function(metadata, domain_name,
                                        indicator_name = NULL) {
  checkmate::assert_list(metadata,
                         len = 3L, null.ok = FALSE,
                         any.missing = FALSE
  )
  checkmate::assert_vector(domain_name,
                           min.len = 1L, null.ok = FALSE,
                           any.missing = FALSE
  )
  checkmate::assert_vector(indicator_name,
                           min.len = 1L, null.ok = TRUE,
                           any.missing = FALSE
  )
  domain_name <- unlist(strsplit(domain_name, ",", fixed = TRUE))
  idx <- suppressWarnings(
    as.numeric(
      as.character(
        unlist(lapply(
          domain_name,
          match,
          metadata[["indicator_profile_domain"]][["DomainName"]]
        ))
      )
    ) # nolint: line_length_linter
  )
  if (all(is.na(idx))) {
    message("\nCould not find the specified domain name.\n
             Below is the list of all domain names in Fingertips.")
    print(metadata[["indicator_profile_domain"]][, c("DomainID", "DomainName")])
    stop()
  } else {
    if (anyNA(idx)) {
      warning(
        "\nThe following domain names were not found: ",
        glue::glue_collapse(domain_name[is.na(idx)], sep = ", ")
      )
    }
    domain_name <- domain_name[!is.na(idx)]
    # get the indicator ids
    idx <- which(domain_name ==
                   metadata[["indicator_profile_domain"]][["DomainName"]])
    if (!is.null(indicator_name)) {
      indicator_name <- unlist(strsplit(indicator_name, ",", fixed = TRUE))
      subs <- metadata[["indicator_profile_domain"]][idx, ]
      subs <- subs[which(subs[["IndicatorName"]] %in% indicator_name), ]
      indicator_id <- subs[["IndicatorID"]]
    } else {
      indicator_id <-
        unique(metadata[["indicator_profile_domain"]][["IndicatorID"]][idx])
=======
#' @return the indicator ID
#' @export
#' @examples
#' indicator_id <- get_ind_id_from_domain_name(
#' metadata = list(
#'   indicator_profile_domain = fingertipsR::indicators(),
#'   indicator_ids_names = fingertipsR::indicators_unique(),
#'   area_type = fingertipsR::area_types()
#'   ),
#' domain_name = "B. Wider determinants of health",
#' )
#'
get_ind_id_from_domain_name <- function(metadata, domain_name,
                                        indicator_name = NULL) {
  checkmate::assert_list(metadata, any.missing = FALSE, len = 3,
                         null.ok = FALSE)
  checkmate::assert_vector(domain_name, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_vector(indicator_name, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)

  domain_name <- unlist(strsplit(domain_name, ",", fixed = TRUE))
  idx <- which(metadata$indicator_profile_domain$DomainName == domain_name)
  if (length(idx) == 0) {
    subs <- metadata$indicator_profile_domain[grepl(
      domain_name,
      metadata$indicator_profile_domain$DomainName
    ), ]
    if (nrow(subs) == 0) {
      R.utils::cat("\nCould not find specified domain name.\n
             Below is the list of all domain names in Fingertips.\n")
      print(metadata$indicator_profile_domain[, c("DomainID", "DomainName")])
      stop()
    } else {
      R.utils::cat("\nspecified domain name not found but detected following
                   similar domain names:\n")
      print(subs[, c("DomainID", "DomainName")])
    }
  } else {
    if (!is.null(indicator_name)) {
      indicator_name <- unlist(strsplit(indicator_name, ",", fixed = TRUE))
      subs <- metadata$indicator_profile_domain[idx, ]
      subs <- subs[which(subs$IndicatorName %in% indicator_name)]
      indicator_id <- subs$IndicatorID
    } else {
      indicator_id <- metadata$indicator_profile_domain$IndicatorID[idx]
>>>>>>> main
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
<<<<<<< HEAD
#' @return a `list` of 2 elements of type `character` and `numeric`. These are
#'    the `profile name` and their correspondent indexes.
#' @examples
#' \dontrun{
#' res <- get_profile_name(
#'   profile_id   = 19,
#'   profile_name = "Public Health Outcomes Framework",
#'   metadata = list(
#'     indicator_profile_domain = fingertipsR::indicators(),
#'     indicator_ids_names      = fingertipsR::indicators_unique(),
#'     area_type                = fingertipsR::area_types()
#'   )
#' )
#' }
#' @keywords internal
get_profile_name <- function(profile_id, profile_name, metadata) {
  checkmate::assert_list(metadata,
                         len = 3L, null.ok = FALSE,
                         any.missing = FALSE
  )
  checkmate::assert_vector(profile_name,
                           min.len = 1L, null.ok = TRUE,
                           any.missing = FALSE
  )
  checkmate::assert_vector(profile_id,
                           min.len = 1L, null.ok = TRUE,
                           any.missing = FALSE
  )
  if (all(!is.null(profile_id) & !is.null(profile_name))) {
    profile_name <- unlist(strsplit(profile_name, ",", fixed = TRUE))
    idx <- which(
      metadata[["indicator_profile_domain"]][["ProfileID"]] ==
        profile_id &
        metadata[["indicator_profile_domain"]][["ProfileName"]] ==
        profile_name
    )
  } else if (!is.null(profile_id) && is.null(profile_name)) {
    idx <- which(
      metadata[["indicator_profile_domain"]][["ProfileID"]] ==
        profile_id
    )
  } else if (!is.null(profile_name) && is.null(profile_id)) {
    profile_name <- unlist(strsplit(profile_name, ",", fixed = TRUE))
    idx <- which(
      metadata[["indicator_profile_domain"]][["ProfileName"]] ==
        profile_name
    )
  }

  list(
    profile_name = profile_name,
    profile_index = idx
  )
=======
#' @return a list with the profile name and their correspondent indexes
#' @export
#' @examples
#' res <- get_profile_name(
#' profile_id = 19,
#' profile_name = "Public Health Outcomes Framework",
#' metadata = list(
#'   indicator_profile_domain = fingertipsR::indicators(),
#'   indicator_ids_names = fingertipsR::indicators_unique(),
#'   area_type = fingertipsR::area_types()
#'   )
#' )
#'
get_profile_name <- function(profile_id, profile_name, metadata) {
  checkmate::assert_vector(profile_id, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_vector(profile_name, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_vector(metadata, any.missing = FALSE, null.ok = FALSE)

  if (all(!is.null(profile_id) & !is.null(profile_name))) {
    profile_name <- unlist(strsplit(profile_name, ",", fixed = TRUE))
    idx <- which(metadata$indicator_profile_domain$ProfileID == profile_id &
                   metadata$indicator_profile_domain$ProfileName ==
                   profile_name)
  } else if (!is.null(profile_id) && is.null(profile_name)) {
    idx <- which(metadata$indicator_profile_domain$ProfileID == profile_id)
  } else if (!is.null(profile_name) && is.null(profile_id)) {
    profile_name <- unlist(strsplit(profile_name, ",", fixed = TRUE))
    idx <- which(metadata$indicator_profile_domain$ProfileName == profile_name)
  }

  list(
    profile_name,
    idx
  )

>>>>>>> main
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
<<<<<<< HEAD
#' @return an object of type `numeric` that contains the indicator ID
#' @examples
#' \dontrun{
#' res <- get_ind_id_from_profile(
#'   metadata   = list(
#'     indicator_profile_domain = fingertipsR::indicators(),
#'     indicator_ids_names      = fingertipsR::indicators_unique(),
#'     area_type                = fingertipsR::area_types()
#'   ),
#'   profile_id = 19
#' )
#' }
#' @keywords internal
=======
#' @return the indicator ID
#' @export
#' @examples
#' res <- get_ind_id_from_profile(
#' metadata = list(
#'   indicator_profile_domain = fingertipsR::indicators(),
#'   indicator_ids_names = fingertipsR::indicators_unique(),
#'   area_type = fingertipsR::area_types()
#' ),
#' profile_id = 19
#' )
#'
>>>>>>> main
get_ind_id_from_profile <- function(metadata, domain_id = NULL,
                                    domain_name = NULL,
                                    indicator_name = NULL,
                                    profile_name = NULL,
                                    profile_id = NULL) {
<<<<<<< HEAD
  checkmate::assert_list(metadata,
                         len = 3L, null.ok = FALSE,
                         any.missing = FALSE
  )
  checkmate::assert_vector(domain_id,
                           min.len = 0L, null.ok = TRUE,
                           any.missing = FALSE
  )
  checkmate::assert_vector(domain_name,
                           min.len = 0L, null.ok = TRUE,
                           any.missing = FALSE
  )
  checkmate::assert_vector(indicator_name,
                           min.len = 0L, null.ok = TRUE,
                           any.missing = FALSE
  )
  checkmate::assert_vector(profile_id,
                           min.len = 0L, null.ok = TRUE,
                           any.missing = FALSE
  )
  tmp_res <- get_profile_name(profile_id, profile_name, metadata)
  profile_name <- tmp_res[["profile_name"]]
  idx <- tmp_res[["profile_index"]]

  if (length(idx) == 0L) {
    message("\nCould not find the specified profile ID or name.\n
             Below is the list of all profile IDs and names in Fingertips.")
    print(
      metadata[["indicator_profile_domain"]][, c("ProfileID", "ProfileName")]
    )
    stop()
  } else {
    subs <- metadata[["indicator_profile_domain"]][idx, ]
    if (!is.null(domain_id)) {
      subs <- subs %>% dplyr::filter(subs[["DomainID"]] == domain_id)
    }
    if (!is.null(domain_name)) {
      domain_name <- unlist(strsplit(domain_name, ",", fixed = TRUE))
      subs <- subs %>% dplyr::filter(subs[["DomainName"]] == domain_name)
    }
    if (!is.null(indicator_name)) {
      indicator_name <- unlist(strsplit(indicator_name, ",", fixed = TRUE))
      subs <- subs %>% dplyr::filter(subs[["IndicatorName"]] == indicator_name)
    }
    indicator_id <- subs[["IndicatorID"]]
=======
  checkmate::assert_list(metadata, any.missing = FALSE, len = 3,
                         null.ok = FALSE)
  checkmate::assert_vector(domain_id, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_vector(domain_name, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_vector(profile_id, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_vector(profile_name, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_vector(indicator_name, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)

  tmp_res <- get_profile_name(profile_id, profile_name, metadata)
  profile_name <- tmp_res[[1]]
  idx <- tmp_res[[2]]

  if (length(idx) == 0) {
    if (!is.null(profile_id) && is.null(profile_name)) {
      subs <- metadata$indicator_profile_domain[grepl(
        profile_id,
        metadata$indicator_profile_domain$ProfileID
      ), ]
    } else if (!is.null(profile_name) && is.null(profile_id)) {
      subs <- metadata$indicator_profile_domain[grepl(
        profile_name,
        metadata$indicator_profile_domain$ProfileName
      ), ]
    } else if (all(!is.null(profile_id) & !is.null(profile_name))) {
      subs <- metadata$indicator_profile_domain[(
        grepl(profile_id, metadata$indicator_profile_domain$ProfileID) |
          grepl(profile_name, metadata$indicator_profile_domain$ProfileName)), ]
    }

    if (nrow(subs) == 0) {
      R.utils::cat("\nCould not find specified profile ID or name.\n
             Below is the list of all profile IDs and names in Fingertips.\n")
      print(metadata$indicator_profile_domain[, c("ProfileID", "ProfileName")])
      stop()
    } else {
      R.utils::cat("\nspecified profile name or ID not found but detected
                   following similar profile IDs or names:\n")
      print(subs[, c("ProfileID", "ProfileName")])
    }
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
>>>>>>> main
  }
  indicator_id
}

#' Subset records when reading from Fingertips
#'
<<<<<<< HEAD
#' @param data the data read from Fingertips
#' @param records a vector or a comma-separated string of records
#' @param id_col_name the column name with the subject IDs
#'
#' @return an object of type `data.frame` with the Fingertips dataset that
#'    contains only the records of interest
#'
#' @examples
#' \dontrun{
#' res <- fingertips_subset_rows(
#'   data = readepi(
#'     profile_id   = 19,
#'     area_type_id = 202
#'   )$data,
#'   records        = c("E92000001", "E12000002", "E12000009"),
#'   id_col_name    = "AreaCode"
#' )
#' }
#' @keywords internal
#'
fingertips_subset_rows <- function(data, records, id_col_name) {
  checkmate::assert_data_frame(data,
                               null.ok = FALSE, min.rows = 1L,
                               min.cols = 1L
  )
  checkmate::assert_vector(records,
                           min.len = 0L, null.ok = TRUE,
                           any.missing = FALSE
  )
  checkmate::assert_character(id_col_name,
                              null.ok = TRUE, len = 1L,
                              any.missing = FALSE
  )
=======
#' @param records a vector or a comma-separated string of records
#' @param id_col_name the column name with the subject IDs
#' @param data the data read from Fingertips
#'
#' @return a data frame with the records of interest
#' @export
#' @examples
#' res <- fingertips_subset_rows(
#'   records = c("E92000001", "E12000002", "E12000009"),
#'   id_col_name = "AreaCode",
#'   data = readepi(
#'     profile_id = 19,
#'     area_type_id = 202
#'   )$data
#' )
#'
fingertips_subset_rows <- function(records, id_col_name, data) {
  checkmate::assert_data_frame(data, null.ok = FALSE)
  checkmate::assert_character(id_col_name, any.missing = FALSE, len = 1,
                              null.ok = TRUE)
  checkmate::assert_vector(records, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)

>>>>>>> main
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
<<<<<<< HEAD
#' @param data the data read from Fingertips
#' @param fields a vector or a comma-separated string of column names
#'
#' @return an object of type `data.frame` with the Fingertips dataset that
#'    contains only the fields of interest
#' @examples
#' \dontrun{
#' res <- fingertips_subset_columns(
#'   data = readepi(
#'     profile_id   = 19,
#'     area_type_id = 202
#'   )$data,
#'   fields         = c("IndicatorID", "AreaCode", "Age", "Value")
#' )
#' }
#' @keywords internal
#'
fingertips_subset_columns <- function(data, fields) {
  checkmate::assert_data_frame(data,
                               min.cols = 1L, min.rows = 1L,
                               null.ok = FALSE
  )
  checkmate::assert_vector(fields,
                           min.len = 0L, null.ok = TRUE,
                           any.missing = FALSE
  )
=======
#' @param fields a vector or a comma-separated string of column names
#' @param data the data read from Fingertips
#'
#' @return a data frame with the columns of interest
#' @export
#' @examples
#' res <- fingertips_subset_columns(
#'   fields = c("IndicatorID", "AreaCode", "Age", "Value"),
#'   data = readepi(
#'     profile_id = 19,
#'     area_type_id = 202
#'   )$data
#' )
#'
fingertips_subset_columns <- function(fields, data) {
  checkmate::assert_data_frame(data, null.ok = FALSE)
  checkmate::assert_vector(fields, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)

>>>>>>> main
  if (!is.null(fields)) {
    fields <- unlist(strsplit(fields, ",", fixed = TRUE))
    fields <- gsub(" ", "", fields, fixed = TRUE)
    idx <- which(fields %in% names(data))
<<<<<<< HEAD
    if (length(idx) == 0L) {
=======
    if (length(idx) == 0) {
>>>>>>> main
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
