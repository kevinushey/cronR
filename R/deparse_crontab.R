## deparse a parsed crontab
deparse_crontab <- function(parsed_crontab) {
  paste( collapse="\n", sapply(parsed_crontab, function(x) {
    paste( sep="", collapse="\n", c(
      "## cronR job",
      paste0("## id:   ", x$id),
      paste0("## tags: ", paste(x$tags, collapse=", ")),
      paste0("## call: ", x$call),
      x$job,
      ""
    ))
  }))
}