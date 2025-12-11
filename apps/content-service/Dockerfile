# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM="/usr/local/libexec/nvm/nvm-exec npm"

### backend ####################################################################
FROM $BUILD_IMAGE AS build-backend
ARG BUILD_IMAGE
ARG BUILD_NPM
ARG STATE_ROOT="/var/lib/tao-ce/content-service"

ENV NODE_VERSION="22"
WORKDIR /app

COPY --from=src-backend . .

RUN --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    ${BUILD_NPM} ci \
    && find /app -type d | grep '[/][.]git$' | xargs rm -rf \
    && find /app -type f | grep '[/][.]git.*$' | xargs rm -rf

RUN \
    cd /app \
    && rm -rf \
        var \
    && mkdir -p \
        ${STATE_ROOT}/data \
    && ln -s \
        ${STATE_ROOT}/data \
        var

### Export #####################################################################
FROM scratch AS export

COPY --link --from=build-backend \
    /app /backend

COPY meta /meta
