\name{cron_rm}
\alias{cron_rm}
\title{Remove a cronjob}
\usage{
cron_rm(id, dry_run = FALSE, user = "")
}
\arguments{
  \item{id}{A set of ids, partially matched from the
  beginning, we wish to remove. We only remove the id if it
  is uniquely matched in the file.}

  \item{dry_run}{Boolean; if \code{TRUE} we do not submit
  the cron job; instead we return the parsed text that
  would be submitted as a cron job.}
}
\description{
  Use this command to remove a cron job added by
  \code{cron_add}.
}

