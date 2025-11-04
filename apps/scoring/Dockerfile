# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM="/usr/local/libexec/nvm/nvm-exec npm"

### ext ####################################################################
FROM $BUILD_IMAGE AS ext
ARG BUILD_IMAGE
ARG STATE_ROOT="/var/lib/tao-ce/scoring/ext"

WORKDIR /app
RUN set -eux; \
    { \
        echo 'upload_max_filesize=60M'; \
        echo 'post_max_filesize=60M'; \
        echo 'post_max_size=60M'; \
    } > tao-hbl-scoring-engine-be.ini \
    ;

RUN set -eux; \
    { \
        echo 'upload_max_filesize=60M'; \
        echo 'post_max_filesize=60M'; \
        echo 'post_max_size=60M'; \
    } > tao-scoring-service-be.ini \
    ;

RUN set -eux; \
    { \
        echo 'upload_max_filesize=60M'; \
        echo 'post_max_filesize=60M'; \
        echo 'post_max_size=60M'; \
    } > tao-manual-scoring-be.ini \
    ;

### ms-fe-bootstrap #####################################################################
FROM $BUILD_IMAGE AS ms-fe-bootstrap
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="18"
WORKDIR /app

COPY --from=src-ms-fe . .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    --mount=type=secret,id=NPM_TOKEN \
        ${BUILD_NPM} config set //registry.npmjs.org/:_authToken=$(cat /run/secrets/NPM_TOKEN) \
        && ${BUILD_NPM} ci \
        && ${BUILD_NPM} run generate:locale \
        && ${BUILD_NPM} run build:bootstrap \
        && find /app -type d | grep '[/][.]git$' | xargs rm -rf \
        && find /app -type f | grep '[/][.]git.*$' | xargs rm -rf

### ms-fe-static #####################################################################
FROM $BUILD_IMAGE AS ms-fe-static
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="18"
WORKDIR /app

COPY --from=src-ms-fe . .

RUN \
        --mount=type=ssh \
        --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
        --mount=type=secret,id=NPM_TOKEN \
        ${BUILD_NPM} config set //registry.npmjs.org/:_authToken=$(cat /run/secrets/NPM_TOKEN) \
        && ${BUILD_NPM} ci \
        && ${BUILD_NPM} run generate:locale \
        && ${BUILD_NPM} run build:static \
        && find /app -type d | grep '[/][.]git$' | xargs rm -rf \
        && find /app -type f | grep '[/][.]git.*$' | xargs rm -rf

### ms-be ####################################################################
FROM $BUILD_IMAGE AS ms-be
ARG BUILD_IMAGE
ARG STATE_ROOT="/var/lib/tao-ce/scoring/ms-be"

WORKDIR /app
COPY --from=src-ms . .

RUN \
        --mount=type=ssh \
        --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
        --mount=type=secret,id=NPM_TOKEN \
        set -eux; \
        /usr/bin/composer install -n --classmap-authoritative --prefer-dist --verbose; \
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
COPY --from=src-ss . .

RUN \
        --mount=type=ssh \
        --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
        --mount=type=secret,id=NPM_TOKEN \
        set -eux; \
        /usr/bin/composer install -n --classmap-authoritative --prefer-dist --verbose; \
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
COPY --link --from=ext \
    /app /ext
COPY --link --from=ms-fe-bootstrap \
    /app /ms-fe/bootstrap
COPY --link --from=ms-fe-static \
    /app/dist /ms-fe/static
COPY ./router.php /router.php


COPY meta /meta
