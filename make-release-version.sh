#!/bin/bash

# $1 is the directory for jcef sources
pushd $1 2>&1 > /dev/null
git stash 2>&1 > /dev/null
git pull
popd 2>&1 > /dev/null
export CEF_VERSION=$(perl -n -e  '/set\s*\(CEF_VERSION\s+"(.+)"\s*\)/i && print "$1"' "$1/CMakeLists.txt")
pushd $1 2>&1 > /dev/null
git stash pop 2>&1 > /dev/null
popd 2>&1 > /dev/null

if [ -z $CEF_VERSION ]; then
  echo "Failed to retrieve cef version"
  exit 1
fi

echo "CEF_VERSION=$CEF_VERSION"

# git tag --annotate "$CEF_VERSION" --file <(cat << 'EOF'
#
# - Builds for linux and mac are working
# - Deploy for linux working as well
# EOF
# )

# git tag --delete "$CEF_VERSION"
# git push origin --delete "$CEF_VERSION"

# git push origin "$CEF_VERSION"
