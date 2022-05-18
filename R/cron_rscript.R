#' @title Create a command to execute an R script which can be scheduled with cron_add
#' @description Create a command to execute an R script which can be scheduled with cron_add where the stdout and stderr will be passed on to a log
#' @param rscript character string with the path to an R script with .r or .R extension
#' @param rscript_log where to put the log, defaults in the same directory and with the same filename as \code{rscript} but with  extension .log.
#' @param rscript_args a character string with extra arguments to be passed on to Rscript
#' @param cmd path to Rscript. Defaults to R_HOME/bin/Rscript
#' @param log_append logical, append to the log or overwrite
#' @param log_timestamp logical, indicating to append a timestamp to the script log filename in the default argument of \code{rscript_log}. 
#' This will only work if the path to the log folder does not contain spaces.
#' @param workdir If provided, Rscript will be run from this working directory.
#' @param type a character string specifying the type of command to generate:
#'   \describe{
#'     \item{default}{The command will send stdout and stderr to the log file but will never output these streams.}
#'     \item{output_always}{The command will send stdout and stderr to the log file in addition to emitting them as an output.}
#'     \item{output_on_error}{The command will send stdout and stderr to the log file, and it will emit them as an output when the R script has a non-zero exit status.}
#'   }
#' @param ... further arguments, specific to argument \code{type}, currently not used
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
#' cron_rscript(f, log_append = FALSE, log_timestamp = TRUE)
#' 
#' ## run from home directory
#' cron_rscript(f, workdir = normalizePath("~"))
#' 
#' ## other non-default options for type
#' cron_rscript(f, type = "output_on_error")
#' cron_rscript(f, type = "output_always")
cron_rscript <- function(rscript,
                         rscript_log = sprintf("%s%s.log", tools::file_path_sans_ext(rscript), ifelse(log_timestamp, "-`date+\\%Y-\\%m-\\%d_\\%H:\\%M:\\%S`", "")),
                         rscript_args = "",
                         cmd = file.path(Sys.getenv("R_HOME"), "bin", "Rscript"),
                         log_append = TRUE,
                         log_timestamp = FALSE,
                         workdir = NULL,
                         type = c("default", "output_on_error", "output_always"), ...) {
  stopifnot(file.exists(rscript))
  type = match.arg(type)
  # If rscript_args are provided, paste them together and collapse on " " and then append a " ". If
  # no rscript_args are provided, return an empty character string.
  if(!rscript_args == ""){
    rscript_args <- paste(rscript_args, collapse = " ")
    rscript_args <- paste(rscript_args, " ", sep = "")
  }
  # Check to see if rscript includes absolute path to the file, if it does not, then prepend the
  # working directory to the base file name.
  if(basename(rscript) == rscript){
    rscript <- file.path(getwd(), rscript)
  }
  # Generate command based on specified type and log_append options
  if(type == "default"){
    if(log_append){
      cmd <- sprintf('%s %s %s >> %s 2>&1', cmd, shQuote(rscript), rscript_args, shQuote(rscript_log)) 
    }else{
      cmd <- sprintf('%s %s %s > %s 2>&1', cmd, shQuote(rscript), rscript_args, shQuote(rscript_log))
    }
  }
  if(type == "output_always"){
    if(log_append){
      cmd <-
        sprintf(
          'temp_log=$(mktemp) && %s %s %s> $temp_log 2>&1 ; cat $temp_log && cat $temp_log >> %s && rm $temp_log',
          cmd,
          shQuote(rscript),
          rscript_args,
          shQuote(rscript_log)
        )
    }else{
      cmd <-
        sprintf(
          'temp_log=$(mktemp) && %s %s %s> $temp_log 2>&1 ; cat $temp_log && cat $temp_log > %s && rm $temp_log',
          cmd,
          shQuote(rscript),
          rscript_args,
          shQuote(rscript_log)
        )
    }
  }
  if(type == "output_on_error"){
    if(log_append){
      cmd <-
        sprintf(
          'temp_log=$(mktemp) && %s %s %s> $temp_log 2>&1 || cat $temp_log && cat $temp_log >> %s && rm $temp_log',
          cmd,
          shQuote(rscript),
          rscript_args,
          shQuote(rscript_log)
        )
    }else{
      cmd <-
        sprintf(
          'temp_log=$(mktemp) && %s %s %s> $temp_log 2>&1 || cat $temp_log && cat $temp_log > %s && rm $temp_log',
          cmd,
          shQuote(rscript),
          rscript_args,
          shQuote(rscript_log)
        )
    }
  }
  # if workdir is set, then prepend the command to change the directory to the specified working
  # directory
  if(!is.null(workdir)){
    cmd <- sprintf("%s %s %s %s",  "cd", shQuote(workdir), "&&", cmd)
  }
  cmd
}
