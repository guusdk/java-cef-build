#!/bin/bash

# Build the jars and native libraries
./gradlew -DBIN_ARTIFACT="$1" --info jcefPackage
