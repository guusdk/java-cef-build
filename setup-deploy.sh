# Build the jars and native libraries
./gradlew -DBIN_ARTIFACT="$1" --info --no-daemon jcef

# Only build the pages if this is linux64
if [[ $ARCH_DIST == 'linux64' ]]; then
  ./gradlew -DBIN_ARTIFACT="$1" --info --no-daemon installDocsDist
fi
