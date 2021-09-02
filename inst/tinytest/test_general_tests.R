expect_silent(cron_ls())
expect_silent(cron_njobs())

expect_inherits(
  cron_add("testing!", id="abc", tags=c("test1", "test2"),
           description="This is a really long description that will hopefully be wrapped appropriately."), 
  "list")
expect_silent(cron_ls())
expect_silent(cron_njobs())
expect_inherits(
  cron_add("testing2!", id="123", tags=c("test2", "test3")),
  "list")

expect_silent(cron_njobs())
expect_silent(cron_ls())
expect_silent(cron_ls(tag="test1"))
expect_silent(cron_ls(tag="test0"))

f <- system.file("extdata", "test.cron", package = "cronR")
expect_silent({
  cron_save(file=f, overwrite=TRUE)
})
expect_inherits(cron_load(file=f), "list")

expect_inherits(cron_rm("abc"), "list")
expect_silent(cron_ls())
expect_inherits(cron_rm("123"), "list")
expect_silent(cron_ls())
expect_equal(cron_clear(ask = TRUE), 0L)

f <- system.file("extdata", "example.cron", package = "cronR")
expect_inherits(cron_load(file=f), "list")
expect_silent(cron_ls())
expect_silent(cron_njobs())
expect_silent(cron_ls("abc"))

expect_equal(cron_clear(ask = TRUE), 0L)