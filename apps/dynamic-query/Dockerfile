# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM="/usr/local/libexec/nvm/nvm-exec npm"

### api ########################################################################
FROM $BUILD_IMAGE AS build-api
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="22"
WORKDIR /app

COPY --from=src-api package*.json ./

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    ${BUILD_NPM} ci \
    && find /app -type d | grep '[/][.]git$' | xargs rm -rf \
    && find /app -type f | grep '[/][.]git.*$' | xargs rm -rf

COPY --from=src-api . .

### Export #####################################################################
FROM scratch AS export

COPY --from=build-api \
    /app /api

COPY meta /meta
