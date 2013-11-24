# cronR

`cronR` is a simple R package for managing your cron jobs.

Install me with:

    devtools::install_github("cronR", "kevinushey")

# Warning

Currently, `cronR` does not preserve or handle cron jobs not
generated through the package. This will be handled some time in
the future. To be safe, you should run `cron_save("cron.backup")`
before fiddling around.
