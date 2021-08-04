FROM ubuntu:20.04

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install base dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y -q --no-install-recommends \
        apt-transport-https \
        build-essential \
        ca-certificates \
        curl \
        git \
        libssl-dev \
        wget \
    && rm -rf /var/lib/apt/lists/*

# or ~/.nvm , it depends...
ENV NVM_DIR /usr/local/nvm 
ENV NODE_VERSION 14.17.4

# Install nvm with node and npm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.20.0/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/v$NODE_VERSION/bin:$PATH

# Below put all Gatsy installation.
# Fixed port (e.g. EXPOSE 8000)and hostname mapping 
# as well as any other required installations.
# ------------
# Docker entry command should be like:
#   CMD cd $WEBSITE_DIR && gatsby develop -H 192.164.1.64 -p 8000
# ------------
# Test on host machine using: curl --insecure http://192.168.1.64:8000
#