# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM_REGISTRY="http://npm-registry:4873/"

### backend ####################################################################
FROM $BUILD_IMAGE AS build-backend
ARG BUILD_IMAGE
ARG BUILD_NPM_REGISTRY
ARG STATE_ROOT="/var/lib/tao-ce/content-service"
ENV STATE_ROOT=$STATE_ROOT

ENV NODE_VERSION="24"
WORKDIR /app

COPY --from=src-backend . .

RUN --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    <<EORUN
        . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
        dev_npm_registry $BUILD_NPM_REGISTRY
        npm ci
        dev_git_cleanup /app
        state_data data var
EORUN

### Export #####################################################################
FROM scratch AS export

COPY --link --from=build-backend \
    /app /backend

COPY meta /meta
