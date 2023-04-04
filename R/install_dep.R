#' Install the Microsoft ODBC driver for SQL server
#'
#' @param driver_version the version of the driver that is compatible with your SQL server
#' @param force_install a Boolean to specify whether to force the installation of the given MS driver version. default is FALSE
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' install_odbc_driver(driver_version = 17, force_install=FALSE)
#' }
install_odbc_driver <- function(driver_version = 17, force_install=FALSE) {
  checkmate::assertNumber(driver_version, null.ok = FALSE, lower = 13.1,
                          na.ok = FALSE)
  checkmate::assertLogical(force_install, any.missing = FALSE, len = 1,
                           null.ok = TRUE)
  driver.list <- odbc::odbcListDrivers()
  if (nrow(driver.list) == 0 | force_install==TRUE) {
    install_driver(driver_version, force_install)
  } else {
    idx = which(grepl(driver_version, driver.list$name)==TRUE)
    if(length(idx)>0 & force_install==TRUE){
      install_driver(driver_version, force_install)
    }else {
      message("\nMS SQL driver already exist.\n")
    }
  }
  print(driver.list)
}
