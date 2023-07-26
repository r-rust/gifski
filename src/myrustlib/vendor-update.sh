#!/bin/sh
rm -Rf vendor vendor.tar.xz
cargo vendor
rm -Rf vendor/windows_*_gnullvm/lib/* vendor/windows_*_msvc/lib/*
tar -cJ --no-xattrs -f vendor.tar.xz vendor
rm -Rf vendor

# Update ../inst/AUTHORS
Rscript vendor-authors.R
