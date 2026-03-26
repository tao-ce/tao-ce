# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM="/usr/local/libexec/nvm/nvm-exec npm"
ARG COMPOSER_REGISTRY="https://tao-ce.github.io/registry-composer/main"

### backend ####################################################################
FROM $BUILD_IMAGE AS build-backend
ARG BUILD_IMAGE
ARG COMPOSER_REGISTRY
ARG STATE_ROOT="/var/lib/tao-ce/deliver"

WORKDIR /app
COPY --exclude="**/composer.lock" --from=src-backend . .

RUN \
    --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
    <<EORUN
        set -eux
        grep -v 'APP_ENV' .env.prod >.env
        composer repository -g add tao-ce composer ${COMPOSER_REGISTRY}
        composer install -van --no-dev
        composer dump-env dev
        echo '<?php return [];' >.env.local.php
EORUN

RUN <<EORUN
    rm -rf .env .build/ var
    {
        find /app -type d | grep '[/][.]git[a-z]*$'
        find /app -type f | grep '[/][.]git.*$'
    } | xargs -r rm -rf
    mkdir -p ${STATE_ROOT}/data
    ln -s ${STATE_ROOT}/data var
EORUN

### frontend ###################################################################
FROM $BUILD_IMAGE AS build-frontend
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="22"

WORKDIR /app

RUN \
    --mount=type=secret,id=github_token \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    <<"EOR"
    set -eu
    $BUILD_NPM config set -g @tao-ce:registry=https://npm.pkg.github.com
    $BUILD_NPM config set -g //npm.pkg.github.com/:_authToken $(cat /run/secrets/github_token)
    $BUILD_NPM install @tao-ce/tao-deliver-app@12.28.0 --omit=dev
EOR

### Export #####################################################################
FROM scratch AS export

COPY --from=build-frontend \
    /app/node_modules/@tao-ce/tao-deliver-app/server.js /bootstrap/
COPY --from=build-frontend \
    /app/node_modules/@tao-ce/tao-deliver-app/dist /static
COPY --link --from=build-backend  \
    /app /backend

COPY ./router.php /backend/router.php

COPY meta /meta
