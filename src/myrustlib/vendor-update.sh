#!/bin/sh
rm -Rf vendor vendor.tar.xz
cargo vendor
rm -Rf vendor/windows_*_gnullvm/lib/* vendor/windows_*_msvc/lib/* vendor/windows_i686*/lib/*
XZ_OPT=-9 tar -cJ --no-xattrs -f vendor.tar.xz vendor
rm -Rf vendor
