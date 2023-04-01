#' Install the Microsoft ODBC driver for SQL server
#'
#' @param driver_version the version of the driver that is compatible with your SQL server
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' install_odbc_driver(driver.version = 17)
#' }
install_odbc_driver <- function(driver_version = 17) {
  checkmate::assertNumber(driver_version, null.ok = FALSE, lower = 13.1,
                          na.ok = FALSE)
  driver.list <- odbc::odbcListDrivers()
  if (nrow(driver.list) == 0) {
    if (grepl("Darwin", system(sprintf("uname -a"), intern = TRUE))) {
      R.utils::cat("\ndetecting the Apple chip\n")
      apple.chip <- system(sprintf("uname -m"), intern = TRUE)

      R.utils::cat("\ninstalling unixodbc\n")
      system(sprintf("brew install unixodbc"))

      R.utils::cat("\ninstalling SQL Server ODBC Drivers\n")
      system(sprintf("brew tap microsoft/mssql-release https://github.com/Microsoft/homebrew-mssql-release"))
      system(sprintf("brew update"))
      if(driver_version!=13.1){
        target.driver <- paste0("msodbcsql", driver_version)
        system(sprintf("yes 2>/dev/null | brew install %s && exit", target.driver))
        system(sprintf("yes 2>/dev/null | brew install mssql-tools && exit"))
      }else{
        target.driver <- paste0("msodbcsql@", driver_version,".9.2")
        target.mstool <- paste0("msodbcsql@", driver_version,"14.0.6.0")
        system(sprintf("yes 2>/dev/null | brew install %s && exit", target.driver))
        system(sprintf("yes 2>/dev/null | brew install %s && exit",target.mstool))
      }
      # system(sprintf("yes YES | brew install %s && exit", target.driver))
      # system(sprintf("yes YES | brew install mssql-tools && exit"))
      # system(sprintf("yes 2>/dev/null | brew install %s && exit", target.driver))
      # system(sprintf("yes 2>/dev/null | brew install mssql-tools && exit"))

      R.utils::cat("\nconfiguring the home directory\n")
      odbcinst <- ifelse(apple.chip == "arm64", "/opt/homebrew/etc/odbcinst.ini",
        "/etc/odbcinst.ini"
      )
      system(sprintf(
        "cp -f %s %s",
        odbcinst,
        "~/.odbcinst.ini"
      ))
      system(sprintf("ODBCSYSINI=/"))
    } else if (grepl("Linux", system(sprintf("uname -a"), intern = TRUE))) {
      R.utils::cat("\ninstalling unixodbc and MS ODBC driver\n")
      supportd.releases = c("16.04", "18.04", "20.04", "22.04")
      current.release = system(sprintf("lsb_release -rs"), intern = TRUE)
      if(!(current.release %in% supportd.releases)){
        stop("Ubuntu ",current.release," is not currently supported.")
      }
      system(sprintf("curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -"))
      system(sprintf("curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list > /etc/apt/sources.list.d/mssql-release.list"))
      system(sprintf("sudo apt-get update"))
      if(driver_version!=13.1){
        target.driver <- paste0("msodbcsql", driver_version)
        target.mstool <- paste0("mssql-tools", driver_version)
      }else{
        target.driver <- paste0("msodbcsql@", driver_version,".9.2")
        target.mstool <- paste0("msodbcsql@", driver_version,"14.0.6.0")
      }
      # system("sudo -kS ls", input = rstudioapi::askForPassword("sudo password"))
      system(sprintf("sudo ACCEPT_EULA=Y apt-get install -y %s",target.driver),
             input = rstudioapi::askForPassword("sudo password"))
      system(sprintf("sudo ACCEPT_EULA=Y apt-get install -y %s",target.mstool),
             input = rstudioapi::askForPassword("sudo password"))
      system(sprintf("echo 'export PATH=\"$PATH:/opt/%s/bin\"' >> ~/.bashrc",target.mstool))
      system(sprintf("source ~/.bashrc"))
      system(sprintf("sudo apt-get install -y unixodbc-dev"),
             input = rstudioapi::askForPassword("sudo password"))
      # system(sprintf("./install_dependencies.sh %s", driver_version))
    }
    R.utils::cat("\ninstalling odbc R package\n")
    if (!require("odbc", quietly = TRUE))
      install.packages("odbc")
    driver.list <- odbc::odbcListDrivers()
    if (nrow(driver.list) == 0) {
      message("\ninstallation was unsuccessfull!!!")
    } else {
      message("\nODBC driver was successfully installed ...")
      stop()
    }
  } else {
    message("\nMS SQL driver already exist.\n")
  }
  print(driver.list)
}
