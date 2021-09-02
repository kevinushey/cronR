
tinytest::expect_silent({
  cron_ls()
  cron_njobs()
  cron_add("testing!", id="abc", tags=c("test1", "test2"),
           description="This is a really long description that will hopefully be wrapped appropriately.")
  cron_ls()
  cron_njobs()
  cron_add("testing2!", id="123", tags=c("test2", "test3"))
  
  cron_njobs()
  cron_ls()
  cron_ls(tag="test1")
  cron_ls(tag="test0")
  
  f <- system.file("extdata", "test.cron", package = "cronR")
  cron_save(file=f, overwrite=TRUE)
  cron_load(file=f)
  
  cron_rm("abc")
  cron_ls()
  cron_rm("123")
  cron_ls()
  cron_clear(ask = TRUE)
  
  f <- system.file("extdata", "example.cron", package = "cronR")
  cron_load(file=f)
  cron_ls()
  cron_njobs()
  cron_ls("abc")
  cron_clear(ask = TRUE) 
})
