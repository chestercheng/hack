#!/bin/bash
#
# Copyright (C) 2011 Yung-Yu Chen <yyc@solvcon.net>.

#download $pkgloc $pkgurl 3f923154ed47128f13b08eacd207d9ee

tarext=tar.xz
version=${VERSION:-9.0.1}
baseurl=https://github.com/llvm/llvm-project/releases/download/llvmorg-$version

llvm_full=llvm-$version.src
llvm_loc=$YHDL/$llvm_full.$tarext
llvm_url=$baseurl/$llvm_full.$tarext
download $llvm_loc $llvm_url 31eb9ce73dd2a0f8dcab8319fb03f8fc

clang_full=clang-$version.src
clang_loc=$YHDL/$clang_full.$tarext
clang_url=$baseurl/$clang_full.$tarext
download $clang_loc $clang_url 13468e4a44940efef1b75e8641752f90

clext_full=clang-tools-extra-$version.src
clext_loc=$YHDL/$clext_full.$tarext
clext_url=$baseurl/$clext_full.$tarext
download $clext_loc $clext_url c76293870b564c6a7968622b475b7646

libcxx_full=libcxx-$version.src
libcxx_loc=$YHDL/$libcxx_full.$tarext
libcxx_url=$baseurl/$libcxx_full.$tarext
download $libcxx_loc $libcxx_url 689a42dbae917ed2a20b92deb4fd6de7

libcxxabi_full=libcxxabi-$version.src
libcxxabi_loc=$YHDL/$libcxxabi_full.$tarext
libcxxabi_url=$baseurl/$libcxxabi_full.$tarext
download $libcxxabi_loc $libcxxabi_url 1395b30a937e28779cd9707c6357b801

omp_full=openmp-$version.src
omp_loc=$YHDL/$omp_full.$tarext
omp_url=$baseurl/$omp_full.$tarext
download $omp_loc $omp_url 6eade16057edbdecb3c4eef9daa2bfcf

# unpack.
mkdir -p $YHROOT/src/$FLAVOR
cd $YHROOT/src/$FLAVOR

tar xf $llvm_loc
cd $llvm_full

cd tools
tar xf $clang_loc
mv $clang_full clang
cd ..

cd tools/clang/tools
tar xf $clext_loc
mv $clext_full extra
cd ../../..

cd projects
tar xf $libcxx_loc
mv $libcxx_full libcxx
cd ..

cd projects
tar xf $libcxxabi_loc
mv $libcxxabi_full libcxxabi
cd ..

cd projects
tar xf $omp_loc
mv $omp_full openmp
cd ..

if [ -z "$FLAVOR" ] ; then
  echo "no hacking environment is set"
  exit 0
else
  rm -rf build/hbuild_$FLAVOR
  mkdir -p build/hbuild_$FLAVOR
  cd build/hbuild_$FLAVOR
fi

# build.
cmakecmd=("cmake")
cmakecmd+=("-DCMAKE_BUILD_TYPE=MinSizeRel")
cmakecmd+=("-DCMAKE_INSTALL_PREFIX=${INSTALLDIR}")
cmakecmd+=("-DLLVM_ENABLE_LIBCXX=ON")
cmakecmd+=("-DLLVM_ENABLE_LIBCXXABI=ON")
#if [ $(uname) == Linux && "${CXX}" != "clang++" ]; then
#  cmakecmd+=("-DLIBCXX_CXX_ABI=libstdc++")
#fi

echo "configuration: ${cmakecmd[@]}"
{ time "${cmakecmd[@]}" ../.. ; } > cmake.log 2>&1
echo "configuration done"

echo "build:"
{ time make -j $NP ; } > make.log 2>&1
echo "built"

echo "install:"
{ time make -j $NP install ; } > install.log 2>&1
echo "installation done"

# vim: set et nobomb ff=unix fenc=utf8:
