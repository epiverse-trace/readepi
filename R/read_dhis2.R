
base_url <- "https://play.im.dhis2.org/stable-2-42-0"
# base_url <- "https:/smc.moh.gm/staging"
url <- file.path(base_url, "api", "tracker", "enrollments")
# user_name <- "karim"
user_name <- "admin"
# password <- "Gambia@123"
password <- "district"
org_unit <- "DiszpKrYNg8"

login <- dhis2_login(
  base_url = base_url,
  user_name = user_name,
  password = password
)

