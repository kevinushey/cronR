#' @title Clear all cron jobs
#' @description Clear all cron jobs
#' @param ask Boolean; ask before removal?
#' @param user The user whose crontab we are clearing.
#' @export
#' @examples
#' \dontshow{if(interactive())
#' \{
#' }
#' f   <- system.file(package = "cronR", "extdata", "helloworld.R")
#' cmd <- cron_rscript(f)
#' cron_add(command = cmd, frequency = 'minutely', id = 'test1', description = 'My process 1')
#' cron_add(command = cmd, frequency = 'daily', at="7AM", id = 'test2', description = 'My process 2')
#' cron_njobs()
#' 
#' cron_ls()
#' cron_clear(ask=TRUE)
#' cron_ls()
#' \dontshow{
#' \}
#' }
cron_clear <- function(ask=TRUE, user="") {
  
  if (user == "")
    current_user <- Sys.getenv("USER")
  else
    current_user <- user
  
  if (ask) {
    cat( sep="", "Are you sure you want to clear all cron jobs for '", 
      current_user, "'? [y/n]: ")
    input <- tolower(scan(what=character(), n=1, quiet=TRUE))
    if (input == "y") {
      ok <- system(sprintf("crontab -u %s -r", current_user))
      if(ok == 0){
        message("Crontab cleared.")  
      }
    } else {
      ok <- 0
      message("No action taken.")
    }
  } else {
    ok <- system(sprintf("crontab -u %s -r", current_user))
  }
  return (invisible(ok))
}
