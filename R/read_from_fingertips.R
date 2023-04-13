
#' Read from Fingertips
#'
#' @param indicator_id a numeric vector of indicator IDs
#' @param indicator_name a vector of a comma-separated list of indicator names
#' @param area_type_id a vector of area type IDs
#' @param parent_area_type_id a vector of parent area type IDs
#' @param profile_id a vector of profile IDs
#' @param profile_name a vector or a comma-separated list of profile names
#' @param domain_id a vector of domain IDs
#' @param domain_name a vector or a comma-separated list of domain names
#' @param fields a vector or a comma-separated string of column names. If provided, only those columns will be imported.
#' @param records a vector or a comma-separated string of records. When specified, only these records will be imported.
#' @param id.position the column position of the variable that unique identifies the subjects. When the name of the column with the subject IDs is known, this can be provided using the `id.col.name` argument
#' @param id.column.name the column name with the subject IDs.
#'
#' @return a data frame
#' @export
#'
#' @examples data <- read_from_fingertips(indicator_id = 90362, area_type_id = 202)
read_from_fingertips = function(indicator_id=NULL, indicator_name=NULL,
                                area_type_id, parent_area_type_id=NULL,
                                profile_id=NULL, profile_name=NULL,
                                domain_id=NULL, domain_name=NULL,
                                fields=NULL, records=NULL,
                                id.position=NULL, id.column.name=NULL
                                ){
  checkmate::assert_vector(indicator_id, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_vector(indicator_name, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_vector(area_type_id, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_vector(parent_area_type_id, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_vector(profile_id, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_vector(profile_name, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_vector(domain_id, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_vector(domain_name, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_vector(records, any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_vector(fields,any.missing = FALSE, min.len = 0,
                           null.ok = TRUE, unique = TRUE)
  checkmate::assert_number(id.position, null.ok = TRUE, na.ok = FALSE, lower = 1)
  checkmate::assert_character(id.column.name, any.missing = FALSE, len = 1, null.ok = TRUE)


  # check if one of these is not provided
  if(is.null(profile_id) & is.null(indicator_id) & is.null(domain_id) &
     is.null(profile_name) & is.null(indicator_name) & is.null(domain_name)){
    stop("\nPlease use the get_fingertips_metadata() function to see the Fingertips metadata.")
  }

  # extract the metadata
  metadata = get_fingertips_metadata()

  # check if the area type ID is not provided
  if(is.null(area_type_id)){
    message("\narea_type_id not provided! Please choose an area type ID from the list below:\n")
    print(metadata$area_type)
    stop()
  }

  # get the indicator ID from the indicator name
  if(!is.null(indicator_name) & is.null(indicator_id)){
    indicator_id = get_indicatorID_from_indicatorName(metadata, indicator_name)
  }

  # get the indicator ID from the domain ID
  if(!is.null(domain_id) & is.null(indicator_id)){
    indicator_id = get_indicatorID_from_domainID(metadata, domain_id, indicator_name)
  }

  # get the indicator ID from the domain name
  if(!is.null(domain_name) & is.null(indicator_id) & is.null(domain_id)){
    indicator_id = get_indicatorID_from_domainName(metadata, domain_name, indicator_name)
  }
  # get the indicator ID from the profile ID or profile name
  if((!is.null(profile_id) | !is.null(profile_name)) & is.null(indicator_id)){
    indicator_id = get_indicatorID_from_profile(metadata, domain_id, domain_name,
                                                indicator_name, profile_name, profile_id)
  }

  # extract the data
  if(is.null(parent_area_type_id)){
    data = fingertipsR::fingertips_data(IndicatorID = indicator_id,
                                        AreaTypeID = area_type_id)
  }else{
    data = fingertipsR::fingertips_data(IndicatorID = indicator_id,
                                        AreaTypeID = area_type_id,
                                        ParentAreaTypeID = parent_area_type_id)
  }

  # subset columns
  if(!is.null(fields)){
    id.column.name = ifelse(!is.null(id.column.name), id.column.name,
                            names(data)[id.position])
    fields = unlist(strsplit(fields,","))
    fields = gsub(" ","",fields)
    idx = which(fields %in% names(data))
    if(length(idx)==0){
      stop("\nCould not find specified fields. The field names in the dataset are:\n", print(names(data)))
    }else if(length(idx) != length(fields)){
      warning("\nCould not find the following fields:\n", print(fields[-idx]))
    }else{
      data = data %>% dplyr::select(dplyr::all_of(fields[idx]))
    }
  }

  # subset rows
  if(!is.null(id.position) | !is.null(id.column.name)){
    # id.column.name = ifelse(!is.null(id.column.name), id.column.name,
    #                         names(data)[id.position])
    if(all(records %in% data[[id.column.name]])){
      data = data[which(data[[id.column.name]] %in% records),]
    }else{
      idx = which(records %in% data[[id.column.name]])
      warning("\n",length(records[-idx])," records were not found in the data.")
      data = data[which(data[[id.column.name]] %in% records[idx]),]
    }
  }

  list(data=data)
}
