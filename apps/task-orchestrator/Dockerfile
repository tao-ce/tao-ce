# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM_REGISTRY

### backend ####################################################################
FROM $BUILD_IMAGE AS build-backend
ARG BUILD_IMAGE
ARG BUILD_NPM_REGISTRY

ENV NODE_VERSION="24"
WORKDIR /app

COPY --from=src-backend ./package*.json .

RUN --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    <<EORUN
        . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
        dev_npm_registry $BUILD_NPM_REGISTRY
        npm ci --omit=dev
        npm install jsonwebtoken@9.0.0
        # rm -rf node_modules/@opentelemetry
EORUN

COPY --from=src-backend . .

RUN <<EORUN
    . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
    # echo 'export const shutdownOtel = () => {};export const injectTraceContext = (a) => {};' >src/instrumentation/otel.js  #https://github.com/oat-sa/tao-content-service/pull/203
    dev_git_cleanup /app
EORUN

### Export #####################################################################
FROM scratch AS export

COPY --link --from=build-backend \
    /app /backend

COPY meta /meta
