# This is to ensure we are using the latest jdk-8
if [[ "${TRAVIS_OS_NAME}" == 'linux' ]]; then
  if ! command -v jdk_switcher; then
    git clone https://github.com/michaelklishin/jdk_switcher.git
    source jdk_switcher/jdk_switcher.sh
  fi
  # On Linux, we can use jdk_switcher
  jdk_switcher use openjdk11
else
  # And on Macosx, we can use the java_home command
  export JAVA_HOME="$(/usr/libexec/java_home -v 11)"
fi

# Print the versions of the java tools to ensure
# they are all pointing to the same jdk version
(set -x
echo "JAVA_HOME=$JAVA_HOME"
java -version
javac -version
javadoc -J-version
jar -J-version
)
