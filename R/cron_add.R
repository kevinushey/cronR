##' Make a simple cron job
##' 
##' Generate a cron job, and pass it to crontab.
##' 
##' The goal is to be able to translate simple English statements of intent
##' to the actual \code{cron} statement that could execute that intent. For example,
##' 
##' \emph{"I want to run a job daily at 7AM."}
##' 
##' is simply
##' 
##' \code{cron_add(<command>, "daily", at="7AM")}
##' 
##' Another example, \emph{"I want to run a job on the 15th of every month."}
##' 
##' is
##' 
##' \code{cron_add(<command>, "monthly", days_of_month="15th")}
##' 
##' @param command A command to execute.
##' @param frequency A character string equal to one of 
##'   \code{"minutely"}, \code{"hourly"}, \code{"daily"},
##'   \code{"monthly"}, or \code{"yearly"}.
##' @param at The actual time of day at which to execute the command.
##'   When unspecified, we default to \code{"3AM"}, when the command is to
##'   be run less frequently than \code{"hourly"}.
##' @param days_of_month Optional; the day(s) of the month on which we execute the
##'   command.
##' @param days_of_week Optional; the day(s) of the week on which we execute the
##'   command.
##' @param months Optional; the month(s) of the year on which we execute
##'   the command.
##' @param id An id, or name, to give to the cronjob task, for easier
##'   revision in the future.
##' @param tags A set of tags, used for easy listing and retrieval
##'   of cron jobs.
##' @param dry_run Boolean; if \code{TRUE} we do not submit the cron job; 
##'   instead we return the parsed text that would be submitted as a cron job.
##' @importFrom digest digest
##' @export
cron_add <- function(command, frequency="daily", at, days_of_month, days_of_week, months,
  id, tags="", dry_run=FALSE, user="") {
  
  crontab <- tryCatch(parse_crontab(user=user),
    error=function(e) {
      return( character() )
    })
  
  ## make sure the id generated / used is unique
  call <- match.call()
  if (missing(id)) {
    id <- digest(call)
  }
  
  if (length(crontab)) {
    if (id %in% sapply(crontab, "[[", "id")) {
      stop("Can't add this job: id '", id, 
        "' already exists in your crontab!")
    }
  }
  
  call_str <- paste( collapse="", 
    gsub(" +$", "", capture.output(call) )
  )
  
  job <- list(
    min=NULL,
    hour=NULL,
    day_of_month=NULL,
    month=NULL,
    day_of_week=NULL,
    command=NULL
  )
  
  frequency <- tolower(frequency)
  switch( frequency,
    minutely={
      job[["min"]] <- "0-59"
      job[["hour"]] <- "*"
      job[["day_of_month"]] <- "*"
      job[["month"]] <- "*"
      job[["day_of_week"]] <- "*"
    },
    hourly={
      job[["min"]] <- 0
      job[["hour"]] <- "*"
      job[["day_of_month"]] <- "*"
      job[["month"]] <- "*"
      job[["day_of_week"]] <- "*"
    },
    daily={
      job[["min"]] <- 0
      job[["hour"]] <- 0
      job[["day_of_month"]] <- "*"
      job[["month"]] <- "*"
      job[["day_of_week"]] <- "*"
    },
    monthly={
      job[["min"]] <- 0
      job[["hour"]] <- 0
      job[["day_of_month"]] <- 1
      job[["month"]] <- "*"
      job[["day_of_week"]] <- 1
    },
    yearly={
      job[["min"]] <- 0
      job[["hour"]] <- 0
      job[["day_of_month"]] <- 1
      job[["month"]] <- 1
      job[["day_of_week"]] <- 1
    },
    stop("Unrecognized string passed to frequency: '", frequency, "'")
  )
  
  if (!missing(days_of_week)) {
    days_of_week <- ordinal_swap(days_of_week, adj=-1)
    job[["day_of_week"]] <- paste( unique( sort(sapply(days_of_week, parse_day_of_week)), collapse=",") )
  }
  
  if (!missing(days_of_month)) {
    days_of_month <- ordinal_swap(days_of_month)
    job[["day_of_month"]] <- paste( unique( sort(sapply(days_of_month, parse_day_of_month)), collapse=",") )
  }
  
  if (!missing(months)) {
    months <- ordinal_swap(months)
    job[["month"]] <- paste( unique( sort(sapply(months, parse_month)), collapse=",") )
  }
  
  if (!missing(at)) {
    at_list <- lapply(at, parse_time)
    job[["min"]] <- paste( sapply(at_list, "[[", "minutes"), collapse="," )
    job[["hour"]] <- paste( sapply(at_list, "[[", "hours"), collapse="," )
  }
  
  job[["command"]] <- command
  
  if (any(is.null(job)))
    stop("NULL commands in 'job!' Job is: ", paste(job, collapse=" ", sep=" "))
  
  header <- paste( sep="\n", collapse="\n",
    "## cronR job",
    paste0("## id:   ", id),
    paste0("## tags: ", paste(tags, collapse=", ")),
    paste0("## call: ", call_str)
  )
  
  job_str <- paste( sep="\n", collapse="\n",
    header,
    paste(job, collapse=" ", sep=" ")
  )
  
  message("Adding cronjob:\n",
    "---------------\n\n",
    job_str
  )
  
  if (!dry_run) {
    
    old_crontab <- suppressWarnings(
      system("crontab -l", intern=TRUE, ignore.stderr=TRUE)
    )
    
    old_crontab[ old_crontab == " " ] <- ""
    
    if (length(old_crontab)) {
      new_crontab <- paste( sep="\n",
        paste(old_crontab, collapse="\n"),
        paste0(job_str, "\n")
      )
    } else {
      new_crontab <- paste0(job_str, "\n")
    }
    
    tempfile <- tempfile()
    on.exit( unlink(tempfile) )
    cat(new_crontab, "\n", file=tempfile)
    system( paste("crontab", tempfile) )
  }
  
  return (invisible(job))
  
}

##' @rdname cron_add
cronjob <- cron_add