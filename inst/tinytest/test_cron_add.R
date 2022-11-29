myscript <- system.file("extdata", "helloworld.R", package = "cronR")

f   <- system.file(package = "cronR", "extdata", "helloworld.R")
cmd <- cron_rscript(f)
expect_inherits(cron_add(command = cmd, frequency = 'minutely', id = 'abc', description = 'My process 1'), "list")
expect_equal(cron_clear(), 0L)

if(FALSE){
  expect_inherits(cron_add(command = cmd, frequency = 'minutely', id = 'abc', description = 'My process 1', user = "jwijffels"), "list")
  expect_inherits(cron_add(command = cmd, frequency = 'minutely', id = 'cba', description = 'My process 2', user = "jwijffels"), "list")
  expect_inherits(cron_rm(id = "abc", user = "jwijffels"), "list")
  expect_equal(cron_clear(user = "jwijffels"), 0L)  
}
