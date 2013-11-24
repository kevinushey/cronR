##' Load a crontab from file
##' 
##' @param file The file location of a crontab.
##' @param user The user for whom we will be loading a crontab.
##' @export
cron_load <- function(file, user="") {
  if (user == "") {
    system(paste("crontab", file))
  } else {
    system(paste("crontab -u", user, file))
  }
  crontab <- parse_crontab(user=user)
  if (is.null(crontab$other)) {
    message("Crontab with ", length(crontab$cronR), " cronR job",
      if (length(crontab$cronR) != 1) "s" else "", 
      "loaded.")
  } else {
    n_other_jobs <- length(grep("^[# ]", inver=TRUE,
      unlist(strsplit(crontab$other, "\n", fixed=TRUE))
    ))
    message("Crontab with ", length(crontab$cronR), " cronR job",
      if (length(crontab$cronR) != 1) "s" else "", " and ",
      n_other_jobs, " other job",
      if (n_other_jobs != 1) "s" else "", " loaded.")
  }
  
  return (invisible(crontab))
}
