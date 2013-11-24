no_crontab_error <- function(user) {
  if (user == "")
    current_user <- Sys.getenv("USER")
  else
    current_user <- user
  message("No cron jobs available for user '", current_user, "'.")
}
