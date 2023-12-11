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
  if (ask) {
    if (user == "")
      cat( sep="", "Are you sure you want to clear all your cron jobs? [y/n]: ")
    else
      cat( sep="", "Are you sure you want to clear all cron jobs for '",
        user, "'? [y/n]: ")
    input <- tolower(scan(what=character(), n=1, quiet=TRUE))
    if (length(input) == 0 || input != "y") {
      ok <- 0
      message("No action taken.")
      return (invisible(ok))
    }
  }
  if (user == "")
    ok <- system("crontab -r")
  else
    ok <- system(sprintf("crontab -u %s -r", user))
  if (ok == 0)
    message("Crontab cleared.")
  return (invisible(ok))
}
