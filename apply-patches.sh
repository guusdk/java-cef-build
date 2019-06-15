#!/bin/sh

for f in $(find ./patch -type f); do
  bash "$f" "$1"
done
