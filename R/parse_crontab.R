## parse the cron jobs as returned by crontab
parse_crontab <- function(crontab, user="") {
  
  if (missing(crontab)) {
    if (user == "") {
      crontab <- suppressWarnings(
        system("crontab -l", intern=TRUE, ignore.stderr=TRUE)
      )
    } else {
      crontab <- suppressWarnings(
        system(paste("crontab -u", user, "-l", intern=TRUE, ignore.stderr=TRUE))
      )
    }
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
      desc_start <- grep("^#+ *desc:", cronR_job)
      desc <- paste( collapse=" ",
        gsub("## +|## desc: ", "", cronR_job[desc_start:(length(cronR_job)-1)])
      )
      job <- cronR_job[length(cronR_job)]
      return (list(
        id=id,
        tags=tags,
        desc=desc,
        job=job
      ))
    })
    
    ## add in those jobs not managed by cronR
    covered_lines <- unlist( mapply( function(x, y) seq(x, y), starts, ends ) )
    uncovered_lines <- 1:length(crontab)
    uncovered_lines <- uncovered_lines[ !(uncovered_lines %in% covered_lines) ]
    if (length(uncovered_lines)) {
      other_lines <- paste(crontab[uncovered_lines], collapse="\n")
    } else {
      other_lines <- NULL
    }
    
    jobs <- list(
      cronR=parsed_jobs,
      other=other_lines
    )
    
    return (jobs)
    
  }
  
}
