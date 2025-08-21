## code to prepare `equivalence_table` dataset goes here
lookup_table <- data.frame(cbind(
  r = c("==", ">=", ">", "<=", "<", "%in%", "!=", "&&", "||", "&", "|"),
  dhis2 = c(":EQ:", ":GE:", ":GT:", ":LE:", ":LT:", ":IN:", ":NE:", "&", "|",
            "&", "|"),
  sql = c("=", ">=", ">", "<=", "<", "in", "<>", "and", "or", "and", "or")
))

usethis::use_data(lookup_table, overwrite = TRUE)


## code to prepare `request_parameters` dataset goes here
request_parameters <- data.frame(cbind(
  version = c("<=37", "[38-40]", ">=41"),
  e_endpoint = c("events", rep("tracker/events", 2)),
  e_orgunit = "orgUnit",
  e_teid = c(rep("trackedEntityInstance", 2), "trackedEntity"),
  e_oumode = c(rep("ouMode", 2), "orgUnitMode"),
  e_response = c("events", "instances", "events"),
  te_endpoint = c("trackedEntityInstances", rep("tracker/trackedEntities", 2)),
  te_orgunit = c("ou", "orgUnit", "orgUnits"),
  te_teid = "trackedEntity",
  te_oumode = c(rep("ouMode", 2), "orgUnitMode"),
  te_response = c("trackedEntityInstances", "instances", "trackedEntities"),
  paging = c(rep("skipPaging=true", 2), "paging=false")
))

usethis::use_data(request_parameters, overwrite = TRUE)
