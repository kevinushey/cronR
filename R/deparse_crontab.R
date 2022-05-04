## deparse a parsed crontab
deparse_crontab <- function(parsed_crontab) {
  cronR <- paste( collapse="\n", sapply(parsed_crontab$cronR, function(x) {
    description <- unlist( strsplit( wrap(x$desc, 76 - 6), "\n", fixed=TRUE ) )
    if (length(description) > 1) {
      description[2:length(description)] <- 
        paste0("##   ", description[2:length(description)])
    }
    description <- paste(description, collapse="\n")
    paste( sep="", collapse="\n", c(
      "## cronR job",
      paste0("## id:   ", x$id),
      paste0("## tags: ", paste(x$tags, collapse=", ")),
      paste0("## desc: ", description),
      x$job,
      ""
    ))
  }))
  other <- parsed_crontab$other
  if(cronR == ""){
    return (paste(other, "", sep="\n", collapse="\n"))
  }else{
    return (paste(other, cronR, "", sep="\n", collapse="\n"))  
  }
}
