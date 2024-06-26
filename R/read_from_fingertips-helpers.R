#' get fingertips metadata
#'
#' @return a `list` of 3 objects of type `data.frame`. They contain information
#'    about the indicators in the Fingertips repository.
#'
#' @examples
#' \dontrun{
#'   metadata <- fingertips_get_metadata()
#' }
#' @keywords internal
#'
fingertips_get_metadata <- function() {
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
#' @return an object of type `numeric` that contains the indicator ID.
#'
#' @examples
#' \dontrun{
#' indicator_id <- fingertips_get_id_from_name(
#'   metadata       = list(
#'     indicator_profile_domain = fingertipsR::indicators(),
#'     indicator_ids_names      = fingertipsR::indicators_unique(),
#'     area_type                = fingertipsR::area_types()
#'   ),
#'   indicator_name = "Pupil absence"
#' )
#' }
#' @keywords internal
#'
fingertips_get_id_from_name <- function(metadata =
                                          list(indicator_profile_domain =
                                               fingertipsR::indicators(),
                                               indicator_ids_names      =
                                               fingertipsR::indicators_unique(),
                                               area_type                =
                                               fingertipsR::area_types()),
                                        indicator_name = "Pupil absence") {
  checkmate::assert_list(metadata,
                         len = 3L, null.ok = FALSE,
                         any.missing = FALSE)
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
    )
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
                                  sep = ", "), call. = FALSE)
    }
    indicator_id <-
      metadata[["indicator_ids_names"]][["IndicatorID"]][idx[!is.na(idx)]]
  }
  indicator_id
}

#' Get indicator ID from domain ID
#'
#' @param metadata a list with the fingertips metadata
#' @param domain_id the domain ID
#' @param indicator_name the indicator name
#'
#' @return an object of type `numeric` that contains the indicator ID.
#' @examples
#' \dontrun{
#' indicator_id <- fingertips_get_id_from_dm_id(
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
fingertips_get_id_from_dm_id <- function(metadata =
                                           list(indicator_profile_domain =
                                                fingertipsR::indicators(),
                                                indicator_ids_names      =
                                                fingertipsR::indicators_unique(), # nolint: line_length_linter
                                                area_type                =
                                                fingertipsR::area_types()),
                                         domain_id      = 1000041L,
                                         indicator_name = NULL) {
  checkmate::assert_list(metadata,
                         len = 3L, null.ok = FALSE,
                         any.missing = FALSE)
  # check if the provided domain_id is part of the Fingertips
  idx <- domain_id %in% metadata[["indicator_profile_domain"]][["DomainID"]]

  # return an error message if all domain ids provided by the user are not found
  if (!any(idx)) { # nolint: if_not_else_linter
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
#' @return an object of type `numeric` that contains the indicator ID.
#' @examples
#' \dontrun{
#' indicator_id <- fingertips_get_id_from_dm_name(
#'   metadata    = list(
#'     indicator_profile_domain = fingertipsR::indicators(),
#'     indicator_ids_names      = fingertipsR::indicators_unique(),
#'     area_type                = fingertipsR::area_types()
#'   ),
#'   domain_name = "B. Wider determinants of health",
#' )
#' }
#' @keywords internal
#'
fingertips_get_id_from_dm_name <- function(metadata =
                                             list(indicator_profile_domain =
                                                  fingertipsR::indicators(),
                                                  indicator_ids_names      =
                                                  fingertipsR::indicators_unique(), # nolint: line_length_linter
                                                  area_type                =
                                                  fingertipsR::area_types()),
                                           domain_name    = "B. Wider determinants of health", # nolint: line_length_linter
                                           indicator_name = NULL) {
  checkmate::assert_list(metadata,
                         len = 3L, null.ok = FALSE,
                         any.missing = FALSE)
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
    )
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
#' @keywords internal
#' @examples
#' \dontrun{
#'   res <- fingertips_get_profile_name(
#'     profile_id   = 19L,
#'     profile_name = "Public Health Outcomes Framework",
#'     metadata = list(
#'       indicator_profile_domain = fingertipsR::indicators(),
#'       indicator_ids_names      = fingertipsR::indicators_unique(),
#'       area_type                = fingertipsR::area_types()
#'     )
#'   )
#' }
#'
fingertips_get_profile_name <- function(metadata =
                                          list(indicator_profile_domain =
                                               fingertipsR::indicators(),
                                               indicator_ids_names      =
                                               fingertipsR::indicators_unique(),
                                               area_type                =
                                               fingertipsR::area_types()),
                                        profile_id   = 19L,
                                        profile_name = "Public Health Outcomes Framework") { # nolint: line_length_linter
  checkmate::assert_list(metadata,
                         len = 3L, null.ok = FALSE,
                         any.missing = FALSE)
  if (!is.null(profile_id) && !is.null(profile_name)) {
    profile_name <- unlist(strsplit(profile_name, ",", fixed = TRUE))
    idx <- which(
                 metadata[["indicator_profile_domain"]][["ProfileID"]] ==
                   profile_id &
                   metadata[["indicator_profile_domain"]][["ProfileName"]] ==
                     profile_name)
  } else if (!is.null(profile_id) && is.null(profile_name)) {
    idx <- which(
                 metadata[["indicator_profile_domain"]][["ProfileID"]] ==
                   profile_id)
  } else if (!is.null(profile_name) && is.null(profile_id)) {
    profile_name <- unlist(strsplit(profile_name, ",", fixed = TRUE))
    idx <- which(metadata[["indicator_profile_domain"]][["ProfileName"]] ==
                   profile_name)
  }

  list(
    profile_name  = profile_name,
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
#' @return an object of type `numeric` that contains the indicator ID.
#' @examples
#' \dontrun{
#' res <- fingertips_get_id_from_profile(
#'   metadata   = list(
#'     indicator_profile_domain = fingertipsR::indicators(),
#'     indicator_ids_names      = fingertipsR::indicators_unique(),
#'     area_type                = fingertipsR::area_types()
#'   ),
#'   profile_id = 19
#' )
#' }
#' @keywords internal
#'
fingertips_get_id_from_profile <- function(metadata =
                                             list(indicator_profile_domain =
                                                  fingertipsR::indicators(),
                                                  indicator_ids_names      =
                                                  fingertipsR::indicators_unique(), # nolint: line_lenght_linter
                                                  area_type                =
                                                  fingertipsR::area_types()),
                                           domain_id      = NULL,
                                           domain_name    = NULL,
                                           indicator_name = NULL,
                                           profile_name   = NULL,
                                           profile_id     = 19L) {
  checkmate::assert_list(metadata,
                         len = 3L, null.ok = FALSE,
                         any.missing = FALSE)
  checkmate::assert_vector(domain_name,
                           min.len = 0L, null.ok = TRUE,
                           any.missing = FALSE, unique = TRUE)
  checkmate::assert_vector(indicator_name,
                           min.len = 0L, null.ok = TRUE,
                           any.missing = FALSE)
  tmp_res      <- fingertips_get_profile_name(metadata, profile_id,
                                              profile_name)
  profile_name <- tmp_res[["profile_name"]]
  idx          <- tmp_res[["profile_index"]]

  if (length(idx) == 0L) {
    message("\nCould not find the specified profile ID or name.\n
             Below is the list of all profile IDs and names in Fingertips.")
    print(
      metadata[["indicator_profile_domain"]][, c("ProfileID", "ProfileName")]) # nolint
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
#'    contains only the records of interest.
#'
#' @examples
#' \dontrun{
#' res <- fingertips_subset_rows(
#'   data = readepi(
#'     profile_id   = 19,
#'     area_type_id = 6
#'   )$data,
#'   records        = c("E92000001", "E12000002", "E12000009"),
#'   id_col_name    = "AreaCode"
#' )
#' }
#' @keywords internal
#'
fingertips_subset_rows <- function(data,
                                   records,
                                   id_col_name = "AreaCode") {
  checkmate::assert_data_frame(data,
                               null.ok = FALSE, min.rows = 1L,
                               min.cols = 1L)
  if (!is.null(records)) {
    records <- unlist(strsplit(records, ",", fixed = TRUE))
    records <- gsub(" ", "", records, fixed = TRUE)
    if (all(records %in% data[[id_col_name]])) {
      data  <- data[which(data[[id_col_name]] %in% records), ]
    } else {
      idx  <- which(records %in% data[[id_col_name]])
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
#'    contains only the fields of interest.
#' @examples
#' \dontrun{
#' res <- fingertips_subset_columns(
#'   data = readepi(
#'     profile_id   = 19,
#'     area_type_id = 6
#'   )$data,
#'   fields         = c("IndicatorID", "AreaCode", "Age", "Value")
#' )
#' }
#' @keywords internal
#'
fingertips_subset_columns <- function(data   = readepi(profile_id   = 19L,
                                                       area_type_id = 202L)[["data"]], # nolint: line_length_linter
                                      fields = c("IndicatorID", "AreaCode",
                                                 "Age", "Value")) {
  checkmate::assert_data_frame(data,
                               min.cols = 1L, min.rows = 1L,
                               null.ok = FALSE)
  if (!is.null(fields)) {
    fields <- unlist(strsplit(fields, ",", fixed = TRUE))
    fields <- gsub(" ", "", fields, fixed = TRUE)
    idx    <- which(fields %in% names(data))
    if (length(idx) == 0L) {
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
