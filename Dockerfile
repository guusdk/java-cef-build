FROM i386/debian:stretch-slim

ENV BASE_PACKAGES git libgtk2.0-dev libxss1 libxt-dev
ENV BUILD_TOOLS openjdk-8-jdk python2.7 lbzip2 rsync ninja-build clang-8 cmake

RUN apt-get update && \
    apt-get install --no-install-recommends -y wget gnupg software-properties-common

# clang package sources
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    add-apt-repository "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch-8 main" && \
    mkdir -p /usr/share/man/man1

# install tools
RUN apt-get update && apt-get upgrade && \
    apt-get install --no-install-recommends --yes $BASE_PACKAGES && \
    apt-get install --no-install-recommends --yes $BUILD_TOOLS && \
    apt-get autoclean

# add java bin to the path
ENV PATH "/usr/lib/jvm/java-1.8-openjdk/bin/:$PATH"

# point to java
ENV JAVA_HOME '/usr/lib/jvm/java-1.8-openjdk'

# use python2.7 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1

# java use utf-8
ENV JAVA_TOOL_OPTIONS '-Dfile.encoding=UTF8'
