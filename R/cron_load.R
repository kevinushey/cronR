#' @title Load a crontab from file
#' @description Load a crontab from file
#' @param file The file location of a crontab.
#' @param user The user for whom we will be loading a crontab.
#' @param ask Boolean; show prompt asking for validation
#' @export
cron_load <- function(file, user="", ask=TRUE) {
  stopifnot(is.character(file) && file.exists(file))
  if(ask){
    cat(sep="", "Are you sure you want to load the cron jobs available at '", file, "'? [y/n]: ")
    input <- tolower(scan(what=character(), n=1, quiet=TRUE))
    if (length(input) == 0 || input != "y") {
      message("No action taken.")
      return(invisible())
    }
  }
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
    n_other_jobs <- length(grep("^[# ]", invert=TRUE,
      unlist(strsplit(crontab$other, "\n", fixed=TRUE))
    ))
    message("Crontab with ", length(crontab$cronR), " cronR job",
      if (length(crontab$cronR) != 1) "s" else "", " and ",
      n_other_jobs, " other job",
      if (n_other_jobs != 1) "s" else "", " loaded.")
  }
  
  return (invisible(crontab))
}
