FROM i386/debian:stretch-slim

ENV BASE_PACKAGES git libgtk2.0-dev libxss1 libxt-dev
ENV BUILD_TOOLS openjdk-8-jdk python2.7 ninja-build clang-8 cmake

RUN apt-get install --no-install-recommends -y wget gnupg software-properties-common

# Clang package sources
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    add-apt-repository "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch-8 main" && \
    mkdir -p /usr/share/man/man1

# Install tools
RUN apt-get update && apt-get upgrade && \
    apt-get install --no-install-recommends --yes $BASE_PACKAGES && \
    apt-get install --no-install-recommends --yes $BUILD_TOOLS && \
    apt-get autoclean

# Add java bin to the path
ENV PATH "/usr/lib/jvm/java-1.8-openjdk/bin/:$PATH"

# Point to java
ENV JAVA_HOME '/usr/lib/jvm/java-1.8-openjdk'

# Point to Python
ENV PYTHON_EXECUTABLE '/usr/bin/python2.7'

CMD ["/bin/bash"]
