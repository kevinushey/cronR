\name{cron_ls}
\alias{cron_ls}
\title{List the contents of a crontab}
\usage{
cron_ls(id, tags, user = "")
}
\arguments{
  \item{id}{Return cron jobs with a certain \code{id}.}

  \item{tags}{Return cron jobs with a certain (set of)
  tags.}

  \item{user}{The user's crontab to display}
}
\description{
  We only list the contents that are handeld by
  \code{cronR}.
}

