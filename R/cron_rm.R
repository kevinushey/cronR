#' @title Remove a cronjob
#' 
#' @description Use this command to remove a cron job added by \code{cron_add}.
#' 
#' @param id A set of ids, partially matched from the beginning, 
#'   we wish to remove. We only remove the id if it is uniquely 
#'   matched in the file.
#' @param dry_run Boolean; if \code{TRUE} we do not submit the cron job; 
#'   instead we return the parsed text that would be submitted as a cron job.
#' @param user The user whose crontab we will be modifying.
#' @export
#' @examples 
#' \dontrun{
#' f <- system.file(package = "cronR", "extdata", "helloworld.R")
#' cmd <- cron_rscript(f)
#' cron_add(command = cmd, frequency = 'minutely', id = 'test1', description = 'My process 1')
#' cron_njobs()
#' cron_ls()
#' cron_rm(id = "test1")
#' cron_njobs()
#' cron_ls()
#' }
cron_rm <- function(id, dry_run=FALSE, user="") {
  
  crontab <- parse_crontab(user=user)
  if (!is.null(crontab$cronR)) {
    to_keep <- sapply(crontab$cronR, function(x) {
      !(x$id %in% id)
    })
  }
  
  n_removed <- sum(!to_keep)
  if (n_removed == 0) {
    message("No cron job with id matched to '", id, "' found.")
    return (invisible(NULL))
  } else {
    message("Removed ", n_removed, " cron job", if (n_removed != 1) "s" else "", ".")
  }
  
  new_crontab <- list(
    cronR=crontab$cronR[to_keep],
    other=crontab$other
  )
  deparsed <- deparse_crontab(new_crontab)
  
  if (!dry_run) {
    if (!(length(new_crontab))) {
      system( paste("crontab -r") )
    } else {
      tempfile <- tempfile()
      on.exit( unlink(tempfile) )
      cat(deparsed, file=tempfile)
      system( paste("crontab", tempfile) )
    }
  }
  
  return (invisible(new_crontab))
  
}