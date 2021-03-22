# Build against gifski libs compiled with the Rtools
VERSION <- commandArgs(TRUE)
if(!file.exists(sprintf("../windows/gifski-%s/include/gifski.h", VERSION))){
  if(getRversion() < "3.3.0") setInternet2()
  download.file(sprintf("https://github.com/rwinlib/gifski/archive/v%s.zip", VERSION), "lib.zip", quiet = TRUE)
  dir.create("../windows", showWarnings = FALSE)
  unzip("lib.zip", exdir = "../windows")
  unlink("lib.zip")
}
