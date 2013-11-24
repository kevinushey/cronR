parse_element <- function(x, min_range, max_range) {
  
  x_orig <- x
  
  ## first, substitute * with the min/max range
  x <- gsub("*", paste(min_range, max_range, sep="-"), x, fixed=TRUE)
  
  ## trick: turn all types of input into (a-b/c) format
  ## eg. 5 becomes 5-5/1
  
  ## if we don't have a -, add it + initial val
  if (!grepl("-", x)) {
    x <- paste0( gsub("/.*", "", x), "-", x)
  }
  
  if (!grepl("/", x)) {
    ## implicitly add a /1 so later code can handle
    x <- paste0(x, "/1")
  }
  
  x_split <- as.integer(unlist( strsplit(x, "[-/]") ))
  if (any(is.na(x_split))) {
    stop("Parsing failed for element '", x_orig, "'")
  }
  start <- x_split[[1]]
  end <- x_split[[2]]
  by <- x_split[[3]]
  return (seq(start, end, by))
  
}

parse_timeslot <- function(x, min_range=0, max_range=59) {
  sort( unlist( lapply( unlist( strsplit(x, ",", fixed=TRUE) ), function(xx) {
    parse_element(xx, min_range=min_range, max_range=max_range)
  } ) ) )
}

parse_minutes <- function(x) {
  parse_timeslot(x, min_range=0, max_range=59)
}

parse_hours <- function(x) {
  parse_timeslot(x, min_range=0, max_range=23)
}

parse_day_of_month <- function(x) {
  parse_timeslot(x, min_range=1, max_range=31)
}

parse_month <- function(x) {
  
  x <- paste( collapse=",", sapply( unlist( strsplit(x, ",", fixed=TRUE) ), function(x) {
    x <- gsub("jan.*", 1, x, ignore.case=TRUE, perl=TRUE)
    x <- gsub("feb.*", 2, x, ignore.case=TRUE, perl=TRUE)
    x <- gsub("mar.*", 3, x, ignore.case=TRUE, perl=TRUE)
    x <- gsub("apr.*", 4, x, ignore.case=TRUE, perl=TRUE)
    x <- gsub("may.*", 5, x, ignore.case=TRUE, perl=TRUE)
    x <- gsub("jun.*", 6, x, ignore.case=TRUE, perl=TRUE)
    x <- gsub("jul.*", 7, x, ignore.case=TRUE, perl=TRUE)
    x <- gsub("aug.*", 8, x, ignore.case=TRUE, perl=TRUE)
    x <- gsub("sep.*", 9, x, ignore.case=TRUE, perl=TRUE)
    x <- gsub("oct.*", 10, x, ignore.case=TRUE, perl=TRUE)
    x <- gsub("nov.*", 11, x, ignore.case=TRUE, perl=TRUE)
    x <- gsub("dec.*", 12, x, ignore.case=TRUE, perl=TRUE)
    return(x)
  }))
  
  parse_timeslot(x, min_range=1, max_range=12)
}

parse_day_of_week <- function(x) {
  
  ## pre-process -- substitute days with numbers
  x <- paste( collapse=",", sapply( unlist( strsplit(x, ",", fixed=TRUE) ), function(x) {
    x <- gsub("sun.*", 0, x, ignore.case=TRUE, perl=TRUE)
    x <- gsub("mon.*", 1, x, ignore.case=TRUE, perl=TRUE)
    x <- gsub("tues.*", 2, x, ignore.case=TRUE, perl=TRUE)
    x <- gsub("weds.*", 3, x, ignore.case=TRUE, perl=TRUE)
    x <- gsub("thurs.*", 4, x, ignore.case=TRUE, perl=TRUE)
    x <- gsub("fri.*", 5, x, ignore.case=TRUE, perl=TRUE)
    x <- gsub("sat.*", 6, x, ignore.case=TRUE, perl=TRUE)
    return(x)
  }))
  
  parse_timeslot(x, min_range=0, max_range=6)
}

parse_time <- function(x) {
  if (grepl(":", x)) {
    hours <- as.integer(gsub(":.*", "", x))
    minutes <- as.integer(gsub("[[:alpha:]]", "", gsub(".*:", "", x)))
  } else {
    hours <- as.integer(gsub("[[:alpha:]]", "", x))
    minutes <- 0
  }
  if (grepl("pm", x, ignore.case=TRUE) && hours < 12) {
    hours <- hours + 12
  }
  if (grepl("am", x, ignore.case=TRUE) && hours == 12) {
    hours <- 0
  }
  return (list(
    hours=hours %% 24,
    minutes=minutes
  ))
}
