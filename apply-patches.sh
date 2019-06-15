#!/bin/bash

# Applies our changes to the source code of the java-cef repo.
# Useful for debugging
# You can generate the patch using the command (Assuming this build repo is located in the same folder as src):
# `cd src && git diff --no-color > ../java-cef-build/patch/docs.patch`

cdir=$(pwd)
pushd $1
git apply --verbose "$cdir/patch/docs.patch"
popd
