# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM="/usr/local/libexec/nvm/nvm-exec npm"

### fe #########################################################################
FROM $BUILD_IMAGE AS build-ms-fe
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="24"
ENV NODE_ENV=dev

WORKDIR /local-packages/packages/live-design-system

COPY --exclude="**/package-lock.json" --from=src-packages \
    live-design-system .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    ${BUILD_NPM} install --install-links \
    && ${BUILD_NPM} run build

WORKDIR /app
COPY  --from=src-ms-fe . .

RUN \
    --mount=type=bind,from=hack,target=/opt/hack \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
        /opt/hack/utils/npm-patch/patch.sh ./package.json /opt/hack/utils/npm-patch/scoring.json \
        && cat ./package.json 

RUN \
    ${BUILD_NPM} update \
        '@oat-sa-private/ui-core' \
        '@oat-sa-private/ui-identity' \
        '@oat-sa-private/ui-components' \
        '@oat-sa-private/ui-elements'

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
        ${BUILD_NPM} install --install-links

# RUN jq  -r '.dependencies|keys|join("\n")' package.json \
#     |  grep -v oat-sa-private | xargs ${BUILD_NPM} update

# RUN jq  -r '.devDependencies|keys|join("\n")' package.json \
#     | xargs ${BUILD_NPM} update

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
        --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
        ${BUILD_NPM} run generate:locale \
        && ${BUILD_NPM} run build:static

### ms-be ####################################################################
FROM $BUILD_IMAGE AS ms-be
ARG BUILD_IMAGE
ARG STATE_ROOT="/var/lib/tao-ce/scoring/ms-be"

WORKDIR /app
COPY --exclude="**/composer.lock" --from=src-ms . .

RUN \
        --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
        --mount=type=bind,from=src-packages,target=local-packages/packages \
        --mount=type=bind,from=src-apps,target=local-packages/apps \
        --mount=type=bind,from=hack,target=/opt/hack \
        /opt/hack/utils/composer-patch/patch.sh \
            && composer install -van


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

WORKDIR /app
COPY --exclude="**/composer.lock" --from=src-ss . .

RUN \
        --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
        --mount=type=bind,from=src-packages,target=local-packages/packages \
        --mount=type=bind,from=src-apps,target=local-packages/apps \
        --mount=type=bind,from=hack,target=/opt/hack \
        /opt/hack/utils/composer-patch/patch.sh \
            && composer install -van

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
