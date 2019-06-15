#!/bin/bash

cdir=$(pwd)
pushd -q $1
git apply --verbose "$cdir/patch/docs.patch"
popd -q
