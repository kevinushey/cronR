##' Remove a cronjob
##' 
##' Use this command to remove a cron job added by \code{cron_add}.
##' 
##' @param id A set of ids, partially matched from the beginning, 
##'   we wish to remove. We only remove the id if it is uniquely 
##'   matched in the file.
##' @param dry_run Boolean; if \code{TRUE} we do not submit the cron job; 
##'   instead we return the parsed text that would be submitted as a cron job.
##' @param user The user whose crontab we will be modifying.
##' @export
cron_rm <- function(id, dry_run=FALSE, user="") {
  
  crontab <- parse_crontab(user=user)
  to_keep <- sapply(crontab, function(x) {
    !(x$id %in% id)
  })
  
  n_removed <- sum(!to_keep)
  message("Removed ", n_removed, " cron job", if (n_removed != 1) "s" else "", ".")
  
  new_crontab <- crontab[to_keep]
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