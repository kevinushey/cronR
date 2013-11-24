\name{cron_add}
\alias{cron_add}
\alias{cronjob}
\title{Make a simple cron job}
\usage{
cron_add(command, frequency = "daily", at, days_of_month, days_of_week,
  months, id, dry_run = FALSE)

cronjob(command, frequency = "daily", at, days_of_month, days_of_week, months,
  id, dry_run = FALSE)
}
\arguments{
  \item{command}{A command to execute.}

  \item{frequency}{A character string equal to one of
  \code{"minutely"}, \code{"hourly"}, \code{"daily"},
  \code{"monthly"}, or \code{"yearly"}.}

  \item{at}{The actual time of day at which to execute the
  command.  When unspecified, we default to \code{"3AM"},
  when the command is to be run less frequently than
  \code{"hourly"}.}

  \item{days_of_month}{Optional; the day(s) of the month on
  which we execute the command.}

  \item{days_of_week}{Optional; the day(s) of the week on
  which we execute the command.}

  \item{months}{Optional; the month(s) of the year on which
  we execute the command.}

  \item{id}{An id, or name, to give to the cronjob task,
  for easier revision in the future.}

  \item{dry_run}{Boolean; if \code{TRUE} we do not submit
  the cron job; instead we return the parsed text that
  would be submitted as a cron job.}
}
\description{
  Generate a cron job, and pass it to crontab.
}
\details{
  The goal is to be able to translate simple English
  statements of intent to the actual \code{cron} statement
  that could execute that intent. For example,

  \emph{"I want to run a job daily at 7AM."}

  is simply

  \code{cron_add(<command>, "daily", at="7AM")}

  Another example, \emph{"I want to run a job on the 15th
  of every month."}

  is

  \code{cron_add(<command>, "monthly",
  days_of_month="15th")}
}

