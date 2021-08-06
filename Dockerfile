FROM ubuntu:20.04

# no idea why replacing shells, but this tricks nvm install & it works.
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# disable interactive debconf (run non-interactive & headless)
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y -q --no-install-recommends \
        apt-transport-https \
        build-essential \
        ca-certificates \
        curl \
        git \
        libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# nvm dir path & version env vars
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 14.17.4

# install nvm
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash

# install node and npm
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to $PATH
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# instal Gatsby cli tool
RUN npm install -g gatsby-cli && \
    gatsby telemetry --disable

# create new Gatsby website
RUN mkdir /gatsby
WORKDIR /gatsby

RUN gatsby new static-website 
WORKDIR /gatsby/static-website

EXPOSE 8000

#CMD gatsby develop -H 192.168.1.64 -p 8000
CMD [ "gatsby", "develop", "--host", "0.0.0.0", "-p 8000" ]
