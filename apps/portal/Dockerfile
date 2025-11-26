# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM="/usr/local/libexec/nvm/nvm-exec npm"

### backend ####################################################################
FROM $BUILD_IMAGE AS build-backend
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="22"
WORKDIR /app

COPY --from=src-backend . .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
        ${BUILD_NPM} ci \
        && find /app -type d | grep '[/][.]git$' | xargs rm -rf \
        && find /app -type f | grep '[/][.]git.*$' | xargs rm -rf


### bootstrap ##################################################################
FROM $BUILD_IMAGE AS build-bootstrap
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="22"
WORKDIR /app

COPY --from=src-frontend . .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
        ${BUILD_NPM} run build:bootstrap \
        && find /app -type d | grep '[/][.]git$' | xargs rm -rf \
        && find /app -type f | grep '[/][.]git.*$' | xargs rm -rf

### static #####################################################################
FROM $BUILD_IMAGE AS build-static
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="22"
WORKDIR /app

COPY --from=vendor . vendor
COPY --from=src-frontend . .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
        . /usr/local/libexec/nvm/nvm.sh \
        && npm install 

### Export #####################################################################
FROM scratch AS export

COPY --link --from=build-backend \
    /app /backend
COPY --link --from=build-bootstrap  \
    /app/package*json /bootstrap/
COPY --link --from=build-bootstrap  \
    /app/server.js /bootstrap/
COPY --link --from=build-static     \
    /app/dist /static

COPY meta /meta