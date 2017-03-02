#' @title Create a command to execute an R script which can be scheduled with cron_add
#' @description Create a command to execute an R script which can be scheduled with cron_add where the stdin and stderr will be passed on to a log
#' @param rscript character string with the path to an R script with .r or .R extension
#' @param rscript_log where to put the log, defaults in the same directory and with the same filename as \code{rscript} but with  extension .log.
#' @param rscript_args a character string with extra arguments to be passed on to Rscript
#' @param cmd path to Rscript. Defaults to R_HOME/bin/Rscript
#' @param log_append logical, append to the log or overwrite
#' @return a character string with a command which can e.g. be put as a cronjob for running a simple R script at specific timepoints
#' @export
#' @examples
#' f <- system.file(package = "cronR", "extdata", "helloworld.R")
#' cron_rscript(f)
#' cron_rscript(f, rscript_args = "more arguments passed on to the call")
#' cron_rscript(f, rscript_args = c("more", "arguments", "passed", "on", "to", "the", "call"))
#' 
#' cron_rscript(f, log_append = FALSE)
#' cron_rscript(f, log_append = TRUE)
cron_rscript <- function(rscript,
                         rscript_log = sprintf("%s.log", tools::file_path_sans_ext(rscript)),
                         rscript_args = "",
                         cmd = file.path(Sys.getenv("R_HOME"), "bin", "Rscript"),
                         log_append = TRUE) {
  stopifnot(file.exists(rscript))
  if(length(rscript_args) > 0){
    rscript_args <- paste(rscript_args, collapse = " ")
  }
  if(basename(rscript) == rscript){
    rscript <- file.path(getwd(), rscript)
  }
  if(log_append){
    cmd <- sprintf('%s %s %s >> %s 2>&1', cmd, shQuote(rscript), rscript_args, shQuote(rscript_log))  
  }else{
    cmd <- sprintf('%s %s %s > %s 2>&1', cmd, shQuote(rscript), rscript_args, shQuote(rscript_log))  
  }
  cmd
}
