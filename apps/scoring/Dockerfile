# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM="/usr/local/libexec/nvm/nvm-exec npm"
ARG COMPOSER_REGISTRY="https://tao-ce.github.io/registry-composer/main"

### fe #########################################################################
FROM $BUILD_IMAGE AS build-ms-fe
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="22"
ENV NODE_ENV=dev

WORKDIR /app
COPY  --from=src-ms-fe . .

RUN \
    --mount=type=secret,id=github_token \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    <<"EOR"
    set -eu
    $BUILD_NPM config set -g @tao-ce:registry=https://npm.pkg.github.com
    $BUILD_NPM config set -g //npm.pkg.github.com/:_authToken $(cat /run/secrets/github_token)
    ${BUILD_NPM} ci
EOR

### ms-fe-bootstrap #####################################################################
FROM build-ms-fe AS ms-fe-bootstrap
ARG BUILD_NPM

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
        ${BUILD_NPM} run generate:locale \
        && ${BUILD_NPM} run build:bootstrap

### ms-fe-static #####################################################################
FROM build-ms-fe AS ms-fe-static
ARG BUILD_NPM

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
        ${BUILD_NPM} run generate:locale \
        && ${BUILD_NPM} run build:static

### ms-be ####################################################################
FROM $BUILD_IMAGE AS ms-be
ARG BUILD_IMAGE
ARG STATE_ROOT="/var/lib/tao-ce/scoring/ms-be"
ARG COMPOSER_REGISTRY

WORKDIR /app
COPY --exclude="**/composer.lock" --from=src-ms . .

RUN \
        --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
            composer repository -g add tao-ce composer ${COMPOSER_REGISTRY} \
            && composer install -van --no-dev --no-scripts


RUN \
        set -eux; \
        /usr/bin/composer dump-env dev; \
        echo '<?php return [];' >.env.local.php; \
        rm -rf .build/ var/storage; \
        find /app -type d | grep '[/][.]git$' | xargs rm -rf ;\
        find /app -type f | grep '[/][.]git.*$' | xargs rm -rf ;

RUN \
    cd /app \
    && rm -rf \
        var \
    && mkdir -p \
        ${STATE_ROOT}/data \
    && ln -s \
        ${STATE_ROOT}/data \
        var

### ss-be ####################################################################
FROM $BUILD_IMAGE AS ss-be
ARG BUILD_IMAGE
ARG STATE_ROOT="/var/lib/tao-ce/scoring/ss"
ARG COMPOSER_REGISTRY

WORKDIR /app
COPY --exclude="**/composer.lock" --from=src-ss . .

RUN \
        --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
            composer repository -g add tao-ce composer ${COMPOSER_REGISTRY} \
            && composer install -van --no-dev --no-scripts

RUN \
        set -eux; \
        /usr/bin/composer dump-env dev; \
        rm -rf .build/ var/storage; \
        find /app -type d | grep '[/][.]git$' | xargs rm -rf ;\
        find /app -type f | grep '[/][.]git.*$' | xargs rm -rf ;

RUN \
    cd /app \
    && rm -rf \
        var \
    && mkdir -p \
        ${STATE_ROOT}/data \
    && ln -s \
        ${STATE_ROOT}/data \
        var

### Export #####################################################################
FROM scratch AS export

COPY --link --from=ms-be \
    /app /ms-be
COPY --link --from=ss-be \
    /app /ss
COPY --link --from=ms-fe-bootstrap \
    /app/server.cjs /ms-fe/bootstrap/
COPY --link --from=ms-fe-static \
    /app/dist /ms-fe/static

## COPY route files
COPY ./router.php /ms-be/router.php
COPY ./router.php /ms-be/public/router.php
COPY ./router.php /ss/router.php
COPY ./router.php /ss/public/router.php


COPY meta /meta
