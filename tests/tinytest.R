if(requireNamespace("tinytest", quietly=TRUE)){
  home <- identical(Sys.getenv("HONEYIMHOME"), "TRUE") || identical(Sys.info()[["nodename"]], "live")
  tinytest::test_package("cronR", at_home = home)
}
