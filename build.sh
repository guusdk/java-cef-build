#!/bin/bash +x

mkdir -p $JCEF_DIR/jcef_build
cd $JCEF_DIR/jcef_build

# Generate build script with cmake
if [[ "${TRAVIS_OS_NAME}" == 'osx' ]]; then
  cmake -G "Xcode" -DCMAKE_BUILD_TYPE=Release -DPROJECT_ARCH="x86_64" ../
else
  cmake -G "Ninja" -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=$CC -DCMAKE_CXX_COMPILER=$CXX ../
fi

# build the library
if [ "$TRAVIS_OS_NAME" == 'osx' ]; then
  # https://www.manpagez.com/man/1/xcodebuild/
  xcodebuild -project jcef.xcodeproj -configuration Release
else
  ninja
fi

cd ../tools

# Compile the java source on Linux
if [[ "${TRAVIS_OS_NAME}" == 'linux' ]]; then
  ./compile.sh $ARCH_DIST
fi

# Generate docs, copy libraries and jars to binary_distrib folder, etc
./make_distrib.sh $ARCH_DIST
