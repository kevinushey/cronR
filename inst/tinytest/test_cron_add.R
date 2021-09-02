myscript <- system.file("extdata", "helloworld.R", package = "cronR")

f   <- system.file(package = "cronR", "extdata", "helloworld.R")
cmd <- cron_rscript(f)
expect_inherits(cron_add(command = cmd, frequency = 'minutely', id = 'abc', description = 'My process 1'), "list")
expect_equal(cron_clear(), 0L)