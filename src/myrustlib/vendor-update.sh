#!/bin/sh
rm -Rf vendor vendor.tar.xz
cargo vendor
rm -Rf vendor/windows_x86_64_gnullvm/lib/* vendor/windows_*_msvc/lib/* vendor/windows_i686*/lib/* vendor/winapi-i686-pc-windows-gnu/lib/*
XZ_OPT=-9 tar -cJ --no-xattrs -f vendor.tar.xz vendor
rm -Rf vendor
