#!/bin/bash

# $1 is the jcef repo
if [ -z $1 ]; then
  echo "USAGE: $0 <jcef_repo_path>"
  exit 1
fi

mkdir -p $1/jcef_build
cd $1/jcef_build

# Generate build script with cmake
if [[ "${TRAVIS_OS_NAME}" == 'osx' ]]; then
  cmake -G "Ninja" -DCMAKE_BUILD_TYPE=Release -DPROJECT_ARCH="x86_64" ../
else
  cmake -G "Ninja" -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ ../
fi

# build the library
ninja

cd ../tools

# Compile the java source on Linux
if [[ "${TRAVIS_OS_NAME}" == 'linux' ]]; then ./compile.sh $ARCH_DIST; fi

# Generate docs, copy libraries and jars to binary_distrib folder, etc
./make_distrib.sh $ARCH_DIST
