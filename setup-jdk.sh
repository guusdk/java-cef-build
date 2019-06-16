#!/bin/bash

if [ "${TRAVIS_OS_NAME}" == 'linux' ]; then
  if ! command -v jdk_switcher; then
    git clone https://github.com/michaelklishin/jdk_switcher.git
    source jdk_switcher/jdk_switcher.sh
  fi
  jdk_switcher use openjdk8
else
  export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"
fi

echo "JAVA_HOME=$JAVA_HOME"
java -version
javac -version
