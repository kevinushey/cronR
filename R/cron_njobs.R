#' @title List the number of rCron cron jobs
#' @description List the number of rCron cron jobs
#' @param user The user whose cron jobs we wish to examine.
#' @export
#' @examples 
#' cron_njobs()
cron_njobs <- function(user="") {
  crontab <- try(parse_crontab(user=user), silent=TRUE)
  if (inherits(crontab, "try-error")) {
    no_crontab_error(user=user)
    return (invisible(0))
  }
  if (!is.null(crontab$other)) {
    n_other_jobs <- length(grep("^[# ]", invert=TRUE,
      unlist(strsplit(crontab$other, "\n", fixed=TRUE))
    ))
  } else {
    n_other_jobs <- 0
  }
  
  message("There are a total of ", length(crontab$cronR), " cronR cron jobs ",
    "and ", n_other_jobs, " other cron jobs currently running.")
  return (invisible(length(crontab$other) + n_other_jobs))
}
