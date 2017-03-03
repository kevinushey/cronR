parse_cron_jobs <- function(jobs) {
  lapply(jobs, function(job) {
    
    
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
