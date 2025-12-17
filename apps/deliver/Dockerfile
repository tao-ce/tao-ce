# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM="/usr/local/libexec/nvm/nvm-exec npm"
### backend ####################################################################
FROM $BUILD_IMAGE AS build-backend
ARG BUILD_IMAGE
ARG STATE_ROOT="/var/lib/tao-ce/deliver"

WORKDIR /app
COPY --exclude="**/composer.lock" --from=src-backend . .

RUN \
        --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
        --mount=type=bind,from=src-packages,target=local-packages/packages \
        --mount=type=bind,from=src-apps,target=local-packages/apps \
        --mount=type=bind,from=hack,target=/opt/hack \
    <<EORUN
        set -eux
        grep -v 'APP_ENV' .env.prod >.env

        /opt/hack/utils/composer-patch/patch.sh
        composer install -van
        composer dump-env dev
        echo '<?php return [];' >.env.local.php
EORUN

RUN <<EORUN
    rm -rf .env .build/ var
    {
        find /app -type d | grep '[/][.]git$'
        find /app -type f | grep '[/][.]git.*$'
    } | xargs -r rm -rf
    mkdir -p ${STATE_ROOT}/data
    ln -s ${STATE_ROOT}/data var
EORUN


### fe #########################################################################
FROM ${BUILD_IMAGE} AS build-fe
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="22"
ENV NODE_OPTIONS="--max-old-space-size=4096"
ENV NODE_ENV=dev

WORKDIR /local-packages/packages/live-design-system

COPY --from=src-packages live-design-system .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    ${BUILD_NPM} ci

WORKDIR /local-packages/packages/read-aloud-client

COPY --from=src-packages read-aloud-client .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    ${BUILD_NPM} ci

WORKDIR /local-packages/apps/deliver/src/fe

COPY --from=src-apps deliver/src/fe .

RUN \
    --mount=type=bind,from=hack,target=/opt/hack \
    <<EORUN
    set -eux
    /opt/hack/utils/npm-patch/patch.sh ./package.json /opt/hack/utils/npm-patch/deliver.json
    /opt/hack/utils/npm-patch/patch.sh ./packages/test-runner/package.json /opt/hack/utils/npm-patch/deliver.runner.json
EORUN

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    ${BUILD_NPM} update \
        '@oat-sa-private/ui-core' \
        '@oat-sa-private/ui-identity' \
        '@oat-sa-private/ui-components' \
        '@oat-sa-private/ui-elements' \
        '@oat-sa-private/read-aloud-client'

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    ${BUILD_NPM} install --install-links

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    ${BUILD_NPM} run build:app

### sandbox ####################################################################

# FROM build-fe AS build-sandbox
# ARG BUILD_IMAGE
# ARG BUILD_NPM

# WORKDIR /app

# ENV NODE_VERSION="22"
# ENV API_URL=/data
# ARG PORT=3000

# COPY --exclude="**/package-lock.json" --from=src-sandbox ./package.json .

# RUN \
#     --mount=type=bind,from=hack,target=/opt/hack \
#     --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
#     <<EORUN
#     set -eux
#     /opt/hack/utils/npm-patch/patch.sh ./package.json /opt/hack/utils/npm-patch/deliver.sandbox.json
# EORUN

# RUN \
#     --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
#         ${BUILD_NPM} install --install-links


# COPY --exclude="**/package*.json" --from=src-sandbox . .

# RUN ${BUILD_NPM} run build

# FROM ${BUILD_IMAGE} AS sandbox
# ARG BUILD_IMAGE
# ARG BUILD_NPM

# ENV NODE_VERSION="22"
# WORKDIR /app
# COPY --from=build-sandbox /app/package*json .
# COPY --from=build-sandbox /app/dist /app/dist
# COPY --from=build-sandbox /app/src/server /app/src/server
# COPY --from=build-sandbox /app/locale /app/locale
# RUN \
#     --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
#         ${BUILD_NPM} install --omit=dev

### Export #####################################################################
FROM scratch AS export

COPY --link --from=build-fe \
    /local-packages/apps/deliver/src/fe/packages/deliver-app/server.js /bootstrap/
COPY --link --from=build-fe \
    /local-packages/apps/deliver/src/fe/packages/deliver-app/dist /static
# COPY --link --from=sandbox    \
#     /app /sandbox
COPY --link --from=build-backend  \
    /app /backend

COPY ./router.php /backend/router.php

COPY meta /meta
