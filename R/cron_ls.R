##' List the contents of a crontab
##' 
##' @param user The user's crontab to display
##' @export
cron_ls <- function(user="") {
  stopifnot( is.character(user) && length(user) == 1 )
  if (user == "") {
    output <- suppressWarnings(
      system("crontab -l", intern=TRUE, ignore.stderr=TRUE)
    )
  } else {
    output <- suppressWarnings(
      system(paste("crontab -u", user, "-l", intern=TRUE, ignore.stderr=TRUE))
    )
  }
  if (!length(output)) {
    message("No crontab available")
    return (invisible(NULL))
  } else {
    return (output)
  }
}
