path <- "/opt"
if(!is.na(file.info(path)$isdir) && file.access(path, mode = 2)){
  expect_warning(
    cronR:::verify_rscript_path(path),
    "You do not have write access to the specified Rscript repository path, /opt."
  )
}

expect_warning(
  cronR:::verify_rscript_path("/DirClearlyDoesNotExist"),
  "The specified Rscript repository path /DirClearlyDoesNotExist does not exist, make sure this is an existing directory without spaces."
)