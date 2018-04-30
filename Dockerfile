# First stage is the build environment
FROM sgrio/java-oracle:jdk_8 as builder
MAINTAINER Jian Li <gunine@sk.com>

# Set the environment variables
ENV HOME /root
ENV BUILD_NUMBER docker
ENV JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8

# Install dependencies
RUN \
  apt-get update && \
  apt-get install -y zip unzip bzip2 git

# Install Python
RUN \
  apt-get update && \
  apt-get install -y python2.7 python2.7-dev python-pip && \
  rm -rf /var/lib/apt/lists/*
RUN pip install -U "virtualenv==1.11.4"

RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /bin/repo
RUN chmod a+x /bin/repo

# Copy in the source
RUN mkdir -p /src/
WORKDIR /src
RUN repo init -u https://github.com/sonaproject/onos-sona-repo.git
RUN repo sync
RUN echo "export ONOS_ROOT=/src" > ~/.bash_profile
RUN . ~/.bash_profile
