#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

# download cmake.
pkgname=cmake
pkgverprefix=3.19
pkgver=${VERSION:-3.19.4}
pkgfull=$pkgname-$pkgver
pkgloc=$YHDL/$pkgfull.tar.gz
pkgurl=https://cmake.org/files/v$pkgverprefix/$pkgfull.tar.gz
download $pkgloc $pkgurl 2a71f16c61bac5402004066d193fc14e

# unpack.
mkdir -p $YHROOT/src/$FLAVOR
cd $YHROOT/src/$FLAVOR
tar xf $pkgloc
cd $pkgfull

# build.
{ time ./configure \
  --prefix=$INSTALLDIR \
; } > configure.log 2>&1
{ time make -j $NP ; } > make.log 2>&1
{ time make install ; } > install.log 2>&1

# vim: set et nobomb ff=unix fenc=utf8:
