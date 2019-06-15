#!/bin/bash

curd=$(pwd)
pushd $1
git apply "$curd/patch/docs.patch"
popd
