##' List the contents of a crontab
##' 
##' @param id Return cron jobs with a certain \code{id}.
##' @param tags Return cron jobs with a certain (set of) tags.
##' @param user The user's crontab to display
##' @export
cron_ls <- function(id, tags, user="") {
  
  crontab <- try(parse_crontab(user=user), silent=TRUE)
  if (inherits(crontab, "try-error")) {
    if (user == "")
      current_user <- Sys.getenv("USER")
    else
      current_user <- user
    message("No cron jobs available in crontab for user '", current_user, "'.")
    return (invisible(NULL))
  }
  
  if (missing(id) && missing(tags)) {
    output <- deparse_crontab(crontab)
    message(output)
    return (invisible(output))
  } else {
    if (missing(id)) id <- "__MISSING__"
    if (missing(tags)) tags <- "__MISSING__"
    keep <- crontab[ sapply(crontab, function(x) {
      (x$id %in% id) | (any(x$tags %in% tags))
    })]
    if (!length(keep)) {
      message("No cron jobs found.")
      return (invisible(NULL))
    }
    output <- deparse_crontab(keep)
    message(output)
    return (invisible(keep))
  }
}
