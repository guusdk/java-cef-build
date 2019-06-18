# Build the jars and native libraries
./gradlew -DBIN_ARTIFACT="$1" --info jcef

# Only build the pages if PAGES_DEPLOY is set to true
if [[ ! -z $PAGES_DEPLOY && $PAGES_DEPLOY == true ]]; then
  ./gradlew -DBIN_ARTIFACT="$1" --info installDocsDist
fi
