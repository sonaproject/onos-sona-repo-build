# Use Oracle JDK-8 as the default build environment
FROM sgrio/java-oracle:jdk_8 as builder
MAINTAINER Jian Li <gunine@sk.com>

# Set the environment variables
ENV HOME /root
ENV BUILD_NUMBER docker
ENV JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8
ENV BAZEL_VERSION 0.15.2

# Set the jar class PATH
RUN update-alternatives --install "/usr/bin/jar" "jar" "${JAVA_HOME}/bin/jar" 1 && \
	update-alternatives --set jar "${JAVA_HOME}/bin/jar"

# Install dependencies
RUN \
  apt-get update && \
  apt-get install -y zip unzip bzip2 git git-review build-essential cpio && \
	curl -L -o bazel.sh https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh && \
  chmod +x bazel.sh && \
  ./bazel.sh --user && \
  ln -s /root/bin/bazel /bin/bazel

# Install Python
RUN \
  apt-get update && \
  apt-get install -y python2.7 python2.7-dev python-pip && \
  rm -rf /var/lib/apt/lists/*
RUN pip install -U "virtualenv==1.11.4"

RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /bin/repo
RUN chmod a+x /bin/repo
