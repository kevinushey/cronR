##' Clear all cron jobs
##' 
##' @param ask Boolean; ask before removal?
##' @param user The user whose crontab we are clearing.
##' @export
cron_clear <- function(ask=TRUE, user="") {
  
  if (user == "")
    current_user <- Sys.getenv("USER")
  
  if (ask && user == "") {
    cat( sep="", "Are you sure you want to clear all cron jobs for '", 
      current_user, "'? [y/n]: ")
    input <- tolower(scan(what=character(), n=1, quiet=TRUE))
    if (input == "y") {
      system("crontab -r")
      message("Crontab cleared.")
    } else {
      message("No action taken.")
    }
  } else {
    system("crontab -r")
  }
  
}
