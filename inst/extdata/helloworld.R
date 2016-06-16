##
## Hello world Rscript
##
print(sprintf("Now: %s", Sys.time()))
print(sprintf("Running helloworld.R, working directory = %s", getwd()))
print("-------LIBPATHS-------")
print(.libPaths())
print("-------ENVIRONMENT VARIABLES-------")
print(Sys.getenv())
x <- 1
while(x < 10){
  print(x)
  x <- x + 1
  Sys.sleep(1)
}
warning(sprintf("this is a warning: make sure you save elements at a directory where you have access to, working directory = %s", getwd()))
filename <- file.path(Sys.getenv("HOME"), "helloworld.RData")
save(x, file = filename)
message(sprintf("Saved helloworld.RData at %s", filename))
stop("this is just an error generated for testing that also errors are diverted to the log")
