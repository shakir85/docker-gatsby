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
        htop \
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

# kinda security stuff: run app as user, not root.
ENV APP_USER    appuser
ENV APP_GROUP   appuser
RUN mkdir -p /home/appuser/gatsby
RUN groupadd -g 1111 -r ${APP_GROUP} && \
    useradd -g 1111 -d /home/appuser/ -s /bin/bash ${APP_USER}


# create a new Gatsby website
WORKDIR /home/appuser/gatsby
RUN gatsby new static-website && \
    chown -R $APP_USER:$APP_GROUP /home/appuser/
    # \ && chmod -R 770 /home/appuser/
WORKDIR /home/appuser/static-website
USER $APP_USER
EXPOSE 8000

# gatsby develop --host 0.0.0.0 -p 8000
CMD [ "gatsby", "develop", "--host", "0.0.0.0", "-p 8000" ]
