#!/bin/bash

# $1 is the directory for jcef sources
export CEF_VERSION=$(perl -n -e  '/set\s*\(CEF_VERSION\s+"(.+)"\s*\)/i && print "vJcef-$1"' "$1/CMakeLists.txt")

if [ -z $CEF_VERSION ]; then
  echo "Failed to retrieve cef version"
  exit 1
fi

git tag --annotate "$CEF_VERSION" --file <(cat << 'EOF'
- Builds for linux and mac are working
- Deploy for linux working as well
EOF
)

# git tag --delete "$CEF_VERSION"
# git push origin --delete "$CEF_VERSION"

# git push origin "$CEF_VERSION"
