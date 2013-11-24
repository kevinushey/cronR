parse_cron_jobs <- function(jobs) {
  lapply(jobs, function(job) {
    
    ## From wikipedia; 
    ## http://en.wikipedia.org/wiki/Cron#Predefined_scheduling_definitions
    
    # * * * * *  command to execute
    # ┬ ┬ ┬ ┬ ┬
    # │ │ │ │ │
    # │ │ │ │ │
    # │ │ │ │ └───── day of week (0 - 6) (0 to 6 are Sunday to Saturday, or use names)
    # │ │ │ └────────── month (1 - 12)
    # │ │ └─────────────── day of month (1 - 31)
    # │ └──────────────────── hour (0 - 23)
    # └───────────────────────── min (0 - 59)
    
    split_string <- "__CRON_JOB_SPLIT__"
    pattern <- "(.*?)[[:space:]]+(.*?)[[:space:]]+(.*?)[[:space:]]+(.*?)[[:space:]]+(.*?)[[:space:]]+(.*)"
    replacement <- paste( c("\\1", "\\2", "\\3", "\\4", "\\5", "\\6"), collapse=split_string)
    
    job_regex <- gsub(pattern, replacement, job, perl=TRUE)
    job_split <- unlist(strsplit(job_regex, split_string, fixed=TRUE))
    times <- list(
      min=parse_minutes(job_split[[1]]),
      hour=parse_hours(job_split[[2]]),
      day_of_month=parse_day_of_month(job_split[[3]]),
      month=parse_month(job_split[[4]]),
      day_of_week=parse_day_of_week(job_split[[5]]),
      command=job_split[[6]]
    )
    
  })
}
