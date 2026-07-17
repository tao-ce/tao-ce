# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM_REGISTRY

### worker #####################################################################
FROM $BUILD_IMAGE AS build-worker
ARG BUILD_IMAGE
ARG BUILD_NPM_REGISTRY

ENV NODE_VERSION="24"
WORKDIR /app

COPY --from=src-worker package*.json ./

RUN <<EORUN
    . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
    dev_npm_registry $BUILD_NPM_REGISTRY
    npm install --omit=dev
EORUN

COPY --from=src-worker . .

RUN <<EORUN
    . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
    dev_git_cleanup /app
EORUN


### Export #####################################################################

FROM scratch AS export

COPY --link --from=build-worker  \
    /app /worker
COPY --from=src-assets ./compact-test.xml /worker/config/compact-test.xml
COPY meta /meta
