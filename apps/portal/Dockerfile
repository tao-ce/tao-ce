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
COPY --from=src-init index/tenant-tags.json mappings/dev/tenant-tags.json 
RUN \
    --mount=type=secret,id=github_token \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    <<"EOR"
    set -eu
    ${BUILD_NPM} config set -g @tao-ce:registry=https://npm.pkg.github.com
    ${BUILD_NPM} config set -g //npm.pkg.github.com/:_authToken $(cat /run/secrets/github_token)
    ${BUILD_NPM} ci --omit=dev
    find /app -type d | grep '[/][.]git$' | xargs rm -rf || true
    find /app -type f | grep '[/][.]git.*$' | xargs rm -rf || true
EOR

### fe #########################################################################
FROM $BUILD_IMAGE AS build-fe
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="22"

WORKDIR /app

COPY --from=src-frontend . .

RUN \
    --mount=type=secret,id=github_token \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    <<"EOR"
    set -eu
    ${BUILD_NPM} config set -g @tao-ce:registry=https://npm.pkg.github.com
    ${BUILD_NPM} config set -g //npm.pkg.github.com/:_authToken $(cat /run/secrets/github_token)
    ${BUILD_NPM} ci
EOR

### bootstrap ##################################################################
FROM build-fe AS build-bootstrap
ARG BUILD_IMAGE
ARG BUILD_NPM

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
        ${BUILD_NPM} run build:bootstrap

### Export #####################################################################
FROM scratch AS export

COPY --link --from=build-backend \
    /app /backend
COPY --link --from=build-bootstrap  \
    /app/server.js /bootstrap/
COPY --link --from=build-fe     \
    /app/dist /static

COPY meta /meta
