# https://developers.home-assistant.io/docs/add-ons/configuration#add-on-dockerfile
ARG BUILD_FROM
FROM $BUILD_FROM

# Execute during the build of the image
ARG TEMPIO_VERSION BUILD_ARCH
RUN \
    curl -sSLf -o /usr/bin/tempio \
    "https://github.com/home-assistant/tempio/releases/download/${TEMPIO_VERSION}/tempio_${BUILD_ARCH}"

# Copy root filesystem
COPY rootfs /



FROM node:14-slim
RUN apt-get update && apt-get -y install libcap2-bin \
  && rm -rf /var/lib/apt/lists/* \
  && setcap cap_net_bind_service=+ep '/usr/local/bin/node'
RUN mkdir -p /home/node/meshcentral/node_modules && chown -R node:node /home/node/meshcentral
USER node
WORKDIR /home/node/meshcentral
COPY package*.json ./
RUN npm install meshcentral@1.0.98

ENTRYPOINT node ./node_modules/meshcentral/meshcentral.js

