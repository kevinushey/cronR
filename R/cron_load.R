##' Load a crontab from file
##' 
##' @param file The file location of a crontab.
##' @export
cron_load <- function(file, user="") {
  if (user == "") {
    system(paste("crontab", file))
  } else {
    system(paste("crontab -u", user, file))
  }
  crontab <- parse_crontab(user=user)
  message("Crontab with ", length(crontab), " cronR jobs loaded.")
  return (invisible(crontab))
}
