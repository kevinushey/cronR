##' List the number of rCron cron jobs
##' 
##' @param user The user whose cron jobs we wish to examine.
##' @export
cron_njobs <- function(user="") {
  crontab <- try(parse_crontab(user=user), silent=TRUE)
  if (inherits(crontab, "try-error")) {
    no_crontab_error(user=user)
    return (0)
  }
  message("There are a total of ", length(crontab), " rCron cron jobs currently running.")
  return (invisible(length(crontab)))
}
