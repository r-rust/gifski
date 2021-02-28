# Build against gifski libs compiled with the Rtools
if(!file.exists("../windows/gifski-0.8.7/include/gifski.h")){
  if(getRversion() < "3.3.0") setInternet2()
  download.file("https://github.com/rwinlib/gifski/archive/v0.8.7.zip", "lib.zip", quiet = TRUE)
  dir.create("../windows", showWarnings = FALSE)
  unzip("lib.zip", exdir = "../windows")
  unlink("lib.zip")
}
