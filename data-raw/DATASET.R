## code to prepare `equivalence_table` dataset goes here
lookup_table <- data.frame(cbind(
  r = c("==", ">=", ">", "<=", "<", "%in%", "!=", "&&", "||", "&", "|"),
  dhis2 = c(":EQ:", ":GE:", ":GT:", ":LE:", ":LT:", ":IN:", ":NE:", "&", "|",
            "&", "|"),
  sql = c("=", ">=", ">", "<=", "<", "in", "<>", "and", "or", "and", "or")
))

usethis::use_data(lookup_table, overwrite = TRUE)
