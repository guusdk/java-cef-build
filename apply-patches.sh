#!/bin/sh

for f in $(find ./patch -type f); do
  ./"$f" "$1"
done
