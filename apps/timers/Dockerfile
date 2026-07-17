# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM_REGISTRY

### backend ####################################################################
FROM $BUILD_IMAGE AS build-backend-ci
ARG BUILD_IMAGE
ARG BUILD_NPM_REGISTRY

ENV NODE_VERSION="24"
WORKDIR /app

COPY --from=src-backend . .

RUN --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    <<EORUN
    . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
    dev_npm_registry $BUILD_NPM_REGISTRY
    npm ci
    npm run build
EORUN

FROM $BUILD_IMAGE AS build-backend
ARG BUILD_IMAGE
ARG BUILD_NPM_REGISTRY

ENV NODE_VERSION="24"
WORKDIR /app

COPY --from=src-backend . .

RUN --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    <<EORUN
    . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
    dev_npm_registry $BUILD_NPM_REGISTRY
    npm ci --omit=dev --no-audit --no-fund
    dev_git_cleanup /app
EORUN


### Export #####################################################################
FROM scratch AS export

COPY --link --from=build-backend \
    /app /backend
COPY --link --from=build-backend-ci \
    /app/dist /backend/dist

COPY meta /meta
