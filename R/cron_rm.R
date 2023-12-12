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
#' @param ask Boolean; show prompt asking for validation
#' @export
#' @examples 
#' \dontshow{if(interactive())
#' \{
#' }
#' f   <- system.file(package = "cronR", "extdata", "helloworld.R")
#' cmd <- cron_rscript(f)
#' cron_add(command = cmd, frequency = 'minutely', id = 'test1', description = 'My process 1')
#' cron_njobs()
#' cron_ls()
#' cron_rm(id = "test1")
#' cron_njobs()
#' cron_ls()
#' 
#' \dontshow{
#' \}
#' }
cron_rm <- function(id, dry_run=FALSE, user="", ask=TRUE) {
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
  } 
  
  new_crontab <- list(
    cronR=crontab$cronR[to_keep],
    other=crontab$other
  )
  deparsed <- deparse_crontab(new_crontab)
  
  if(ask){
    cat(sep="", "Are you sure you want to remove the specified cron job with id '", id, "'? [y/n]: ")
    input <- tolower(scan(what=character(), n=1, quiet=TRUE))
    if (length(input) == 0 || input != "y") {
      message("No action taken.")
      return(invisible())
    } 
  }
  
  if (!dry_run) {
    if (!(length(new_crontab))) {
      if(missing(user)){
        system( paste("crontab -r") )
      }else{
        system( paste("crontab -r -u", user) )
      }
    } else {
      tempfile <- tempfile()
      on.exit( unlink(tempfile) )
      cat(deparsed, file=tempfile)
      if(missing(user)){
        system( paste("crontab", tempfile) )
      }else{
        system( paste("crontab -u", user, tempfile) )
      }
    }
    message("Removed ", n_removed, " cron job", if (n_removed != 1) "s" else "", ".")
  }
  
  return (invisible(new_crontab))
  
}