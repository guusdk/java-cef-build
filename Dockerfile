ARG LATEST_TAG=packer-1491942563
FROM travisci/ci-jvm:${LATEST_TAG} AS travis-debug
WORKDIR /tmp/travis-debug
