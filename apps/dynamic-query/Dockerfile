# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM_REGISTRY="http://npm-registry:4873/"

### api ########################################################################
FROM $BUILD_IMAGE AS build-api
ARG BUILD_IMAGE
ARG BUILD_NPM_REGISTRY

ENV NODE_VERSION="24"
WORKDIR /app

COPY --from=src-api package*.json ./

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
<<EORUN
    . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
    dev_npm_registry $BUILD_NPM_REGISTRY
    npm ci
    dev_git_cleanup /app
EORUN

COPY --from=src-api . .

### Export #####################################################################
FROM scratch AS export

COPY --from=build-api \
    /app /api

COPY meta /meta
