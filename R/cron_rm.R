##' Remove a cronjob
##' 
##' Use this command to remove a cron job added by \code{cron_add}.
##' 
##' @param id The id, partially matched from the beginning, 
##'   we wish to remove. We only remove the id if it is uniquely 
##'   matched in the file.
##' @param dry_run Boolean; if \code{TRUE} we do not submit the cron job; 
##'   instead we return the parsed text that would be submitted as a cron job.
##' @export
cron_rm <- function(id, dry_run=FALSE) {
  
  crontab <- suppressWarnings(
    system("crontab -l", intern=TRUE, ignore.stderr=TRUE)
  )
  
  crontab[ crontab == " " ] <- ""
  
  if (!length(crontab)) {
    stop("No crontab available.")
  }
  
  line <- grep( paste0("id.* ", id), crontab)
  if (length(line) > 1) {
    stop( deparse(substitute(id)), 
      " matched to multiple entries in your crontab; cannot proceed.\nids matched: ",
      paste(gsub(".* ", "", crontab[line]), collapse=", ")
    )
  }
  
  if (length(line) == 0) {
    stop("id was not matched anywhere in the crontab")
  }
  
  rm_start <- line
  rm_end <- which( crontab[line:length(crontab)] == "" )[1]
  message("Removing cronjob:\n",
    "-----------------\n\n",
    paste( crontab[rm_start:rm_end], collapse="\n" )
  )
  
  new_crontab <- crontab[-c(rm_start:rm_end)]
  
  if (!dry_run) {
    if (!(length(new_crontab))) {
      system( paste("crontab -r") )
    } else {
      tempfile <- tempfile()
      on.exit( unlink(tempfile) )
      cat( paste(new_crontab, collapse="\n"), "\n", file=tempfile)
      system( paste("crontab", tempfile) )
    }
  }
  
  return (invisible(crontab[rm_start:rm_end]))
  
}