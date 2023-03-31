#' Install the Microsoft ODBC driver for SQL server
#'
#' @param driver.version the version of the driver that is compatible with your SQL server
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' install_odbc_driver(driver.version=17)
#' }
install_odbc_driver = function(driver.version=17){
  checkmate::assertNumber(driver.version, null.ok = FALSE,lower = 13.1)
  driver.list = odbc::odbcListDrivers()
  if(nrow(driver.list)==0){
    if (grepl("Darwin", system(sprintf("uname -a"), intern = TRUE))){
      R.utils::cat("\ndetecting the Apple chip\n")
      apple.chip = system(sprintf("uname -m"), intern = TRUE)

      R.utils::cat("\ninstalling unixodbc\n")
      system(sprintf("brew install unixodbc"))

      R.utils::cat("\ninstalling SQL Server ODBC Drivers\n")
      system(sprintf("brew tap microsoft/mssql-release https://github.com/Microsoft/homebrew-mssql-release"))
      system(sprintf("brew update"))
      target.driver=paste0("msodbcsql",driver.version)
      system(sprintf("yes YES | brew install %s",target.driver))
      system(sprintf("yes YES | brew install mssql-tools"))

      R.utils::cat("\nconfiguring the home directory\n")
      odbcinst = ifelse(apple.chip=="arm64", "/opt/homebrew/etc/odbcinst.ini",
                        "/etc/odbcinst.ini")
      system(sprintf("cp -f %s %s",
                     odbcinst,
                     "~/.odbcinst.ini"))
      system(sprintf("ODBCSYSINI=/"))
    }else if(grepl("Linux", system(sprintf("uname -a"), intern = TRUE))){
      R.utils::cat("\ninstalling unixodbc and MS ODBC driver\n")
      system(sprintf("./install_dependencies.sh %s", driver.version))
    }
    R.utils::cat("\ninstalling odbc R package\n")
    install.packages("odbc")
    driver.list = odbc::odbcListDrivers()
    if(nrow(driver.list)==0){
      message("\ninstallation was unsuccessfull!!!")
    }else{
      message("\nODBC driver was successfully installed ...")
      stop()
    }
  }else{
    message("\nMS SQL driver already exist.\n")
    # print(driver.list)
  }
  print(driver.list)

}
