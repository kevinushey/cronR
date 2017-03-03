context("cronR-examples")

test_that("cronR examples can be scheduled as expected", {
  skip_on_cran()

  myscript <- system.file("extdata", "helloworld.R", package = "cronR")
  
  f <- system.file(package = "cronR", "extdata", "helloworld.R")
  cmd <- cron_rscript(f)
  expect_error(cron_add(command = cmd, frequency = 'minutely', id = 'test1', description = 'My process 1'), NA)
  expect_warning(cron_clear(ask = FALSE), NA)
})