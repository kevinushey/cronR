library(cronR)
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

cron_save(file="test.cron", overwrite=TRUE)
cron_load(file="test.cron")

cron_rm("abc")
cron_ls()
cron_rm("123")
cron_ls()
cron_clear(FALSE)

cron_load(file="example.cron")
cron_ls()
cron_njobs()
cron_ls("abc")
cron_clear(FALSE)
