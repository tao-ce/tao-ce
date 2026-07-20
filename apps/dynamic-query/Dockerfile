# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM_REGISTRY

### api ########################################################################
FROM $BUILD_IMAGE AS build-api
ARG BUILD_IMAGE
ARG BUILD_NPM_REGISTRY

ENV NODE_VERSION="24"
ENV NODE_ENV=production

WORKDIR /app

COPY --from=src-api package*.json ./

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
<<EORUN
    . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
    dev_npm_registry $BUILD_NPM_REGISTRY
    npm ci --omit=dev
    # rm -rf node_modules/@opentelemetry
    dev_git_cleanup /app
EORUN

COPY --from=src-api . .
RUN \
<<EORUN
    . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
    # echo 'export const shutdownOtel = () => {};' >src/instrumentation/otel.js  #https://github.com/oat-sa/tao-content-service/pull/203
    dev_git_cleanup /app
EORUN

### Export #####################################################################
FROM scratch AS export

COPY --from=build-api \
    /app /api

COPY meta /meta
