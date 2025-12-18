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
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
        ${BUILD_NPM} ci \
        && find /app -type d | grep '[/][.]git$' | xargs rm -rf \
        && find /app -type f | grep '[/][.]git.*$' | xargs rm -rf

### fe #########################################################################
FROM $BUILD_IMAGE AS build-fe
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="22"

WORKDIR /local-packages/packages/live-design-system

COPY --from=src-packages live-design-system .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    ${BUILD_NPM} ci

WORKDIR /app

COPY --from=src-frontend . .

RUN \
    --mount=type=bind,from=hack,target=/opt/hack \
    <<EORUN
    set -eux
    /opt/hack/utils/npm-patch/patch.sh ./package.json /opt/hack/utils/npm-patch/portal-fe.json
EORUN

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    ${BUILD_NPM} update \
        '@oat-sa-private/ui-core' \
        '@oat-sa-private/ui-identity' \
        '@oat-sa-private/ui-components' \
        '@oat-sa-private/ui-elements'

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
        ${BUILD_NPM} install --install-links

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
