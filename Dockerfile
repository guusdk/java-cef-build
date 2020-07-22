FROM i386/debian:buster-slim

ENV BASE_PACKAGES git libgtk-3-dev libgtk2.0-dev libxss1 libxt-dev
ENV BUILD_TOOLS openjdk-11-jdk python3.7 lbzip2 rsync ninja-build clang-10 cmake

RUN apt-get -q update && \
    apt-get -q install --no-install-recommends --yes wget apt-transport-https gnupg software-properties-common

# clang package sources
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    add-apt-repository "deb http://apt.llvm.org/buster/ llvm-toolchain-buster-10 main" && \
    mkdir -p /usr/share/man/man1

# install tools
RUN apt-get -q update && apt-get -q upgrade --yes && \
    apt-get -q install --no-install-recommends --yes $BASE_PACKAGES && \
    apt-get -q install --no-install-recommends --yes $BUILD_TOOLS && \
    apt-get -q autoclean

# add java bin to the path
ENV PATH "/usr/lib/jvm/java-11-openjdk-i386/bin/:$PATH"

# point to java
ENV JAVA_HOME '/usr/lib/jvm/java-11-openjdk-i386'

# use python3.7 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1

# java use utf-8
ENV JAVA_TOOL_OPTIONS '-Dfile.encoding=UTF8'
