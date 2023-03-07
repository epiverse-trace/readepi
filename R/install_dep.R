

#' Install the Microsoft ODBC driver for SQL server
#'
#' @param driver.version the version of the driver that is compatible with your system
#'
#' @return
#' @export
#'
#' @examples
install_odbc_driver = function(driver.version=17){
  checkmate::assertNumber(driver.version, null.ok = TRUE)
  if (grepl("Darwin", system(sprintf("uname -a"), intern = TRUE))){
    R.utils::cat("\ndetecting the Apple chip")
    apple.chip = system(sprintf("uname -m"), intern = TRUE)

    R.utils::cat("\ninstalling unixodbc")
    system(sprintf("brew install unixodbc"))

    R.utils::cat("\ninstalling SQL Server ODBC Drivers")
    system(sprintf("brew tap microsoft/mssql-release https://github.com/Microsoft/homebrew-mssql-release"))
    system(sprintf("brew update"))
    target.driver=paste0("msodbcsql",driver.version)
    system(sprintf("brew install %s mssql-tools",target.driver))

    R.utils::cat("\nmaking the necessary symlinks")
    odbcinst = ifelse(apple.chip=="arm64", "/opt/homebrew/etc/odbcinst.ini", "/etc/odbcinst.ini")
    odbc.alone = ifelse(apple.chip=="arm64", "/opt/homebrew/etc/odbc.ini", "/etc/odbc.ini")
    if(file.exists("/etc/odbcinst.ini")){
      system(sprintf("sudo unlink %s", "/etc/odbcinst.ini"))
    }
    if(file.exists("/etc/odbc.ini")){
      system(sprintf("sudo unlink %s", "/etc/odbc.ini"))
    }
    system(sprintf("sudo ln -s %s %s",
                   odbcinst, "/etc/odbcinst.ini"))
    system(sprintf("sudo ln -s %s %s",
                   odbc.alone, "/etc/odbc.ini"))

    R.utils::cat("\nconfiguring the home directory")
    system(sprintf("cp -f %s %s",
                   odbcinst,
                   "~/.odbcinst.ini"))
    system(sprintf("ODBCSYSINI=/"))
  }else if(grepl("Linux", system(sprintf("uname -a"), intern = TRUE))){
    R.utils::cat("\ninstalling unixodbc and MS ODBC driver")
    system(sprintf("./install_dependencies.sh"))
  }

  R.utils::cat("\ninstalling odbc R package")
  install.packages("odbc")
  driver.list = odbc::odbcListDrivers()
  if(nrow(driver.list)==0){
    message("\ninstallation was unsuccessfull!!!")
  }else{
    R.utils::cat("\nODBC driver was successfully installed...")
  }
}
