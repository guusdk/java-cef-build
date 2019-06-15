#!/bin/bash

cdir=$(pwd)
pushd $1
git apply --verbose "$cdir/patch/docs.patch"
popd
