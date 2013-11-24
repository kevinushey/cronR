## parse the cron jobs as returned by crontab
parse_crontab <- function(user="") {
  if (user == "") {
    crontab <- suppressWarnings(
      system("crontab -l", intern=TRUE, ignore.stderr=TRUE)
    )
  } else {
    crontab <- suppressWarnings(
      system(paste("crontab -u", user, "-l", intern=TRUE, ignore.stderr=TRUE))
    )
  }
  if (!length(crontab)) {
    stop("No crontab available")
  } else {
    ## eliminate empty spaces
    crontab[ crontab == " " ] <- ""
    
    ## make sure last element is ""
    if (crontab[length(crontab)] != "")
      crontab <- c(crontab, "")
    
    ## find all the cronR jobs
    starts <- grep("## cronR job", crontab)
    ends <- sapply(starts, function(x) {
      ind <- which( crontab == "" )
      return (ind[ ind > x ][1])
    })
    
    stopifnot( length(starts) == length(ends) )
    
    parsed_jobs <- lapply( seq_along(starts), function(i) {
      start <- starts[i]
      end <- ends[i]
      cronR_job <- crontab[start:(end-1)]
      id <- gsub("#+ *id: *", "", grep("^#+ *id:", cronR_job, value=TRUE))
      tags <- unlist( strsplit( split=", ",
        gsub("#+ *tags: *", "", grep("^#+ *tags:", cronR_job, value=TRUE))
      ) )
      call <- gsub("#+ *call: *", "", grep("^#+ *call:", cronR_job, value=TRUE))
      job <- cronR_job[length(cronR_job)]
      return (list(
        id=id,
        tags=tags,
        call=call,
        job=job
      ))
    })
    
    return (parsed_jobs)
    
  }
  
}
