# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM="/usr/local/libexec/nvm/nvm-exec npm"
### backend ####################################################################
FROM $BUILD_IMAGE AS build-backend
ARG BUILD_IMAGE
ARG STATE_ROOT="/var/lib/tao-ce/deliver"

WORKDIR /app
COPY --from=src-backend . .
COPY --from=composer-vendor oat-sa oat-sa 

RUN jq ' \
    (.repositories[] | select(.url | test("oat-sa/(lib-em-php-|bundle-em-client)"))) |= \
    { \
        "type": "path", \
        "url": ("/app/oat-sa/" + (.url | capture("oat-sa/(?<name>lib-em-php-[^./]+|bundle-em-client)").name)) \
    } \
    | \
    .require |= with_entries(if .key | test("oat-sa/(lib-em-php-|bundle-em-client)") then .value = "*" else . end) \
    | \
    .["minimum-stability"] = "dev" | .["prefer-stable"] = true \
    ' composer.json > composer.tmp && mv composer.tmp composer.json

RUN     --mount=type=ssh \
        --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
        set -eux; \
        mv .env.prod .env; \
        rm composer.lock; \
        composer install -n --ignore-platform-reqs --classmap-authoritative --prefer-dist; \
        > .env ; \
        composer dump-env dev; \
        echo '<?php return [];' >.env.local.php; \
        rm -rf .env .build/ var/storage; \
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

### bootstrap ##################################################################
FROM $BUILD_IMAGE AS build-bootstrap
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="22"
WORKDIR /app

COPY --from=src-frontend ./packages/deliver-app .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
        ${BUILD_NPM} run build:bootstrap \
        && find /app -type d | grep '[/][.]git$' | xargs rm -rf \
        && find /app -type f | grep '[/][.]git.*$' | xargs rm -rf

### static #####################################################################
FROM $BUILD_IMAGE AS build-static
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="22"
WORKDIR /app

COPY --from=src-frontend . .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    --mount=type=secret,id=NPM_TOKEN \
        ${BUILD_NPM} config set //registry.npmjs.org/:_authToken=$(cat /run/secrets/NPM_TOKEN) \
        && ${BUILD_NPM} ci \
        && ${BUILD_NPM} run build:app \
        && find /app -type d | grep '[/][.]git$' | xargs rm -rf \
        && find /app -type f | grep '[/][.]git.*$' | xargs rm -rf



### sandbox ####################################################################

FROM $BUILD_IMAGE AS build-sandbox
ARG BUILD_IMAGE
ARG BUILD_NPM

WORKDIR /app

ENV NODE_VERSION="22"
ENV API_URL=/data
ARG PORT=3000

COPY --from=src-sandbox . .

RUN \
    --mount=type=secret,id=NPM_TOKEN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
        ${BUILD_NPM} config set //registry.npmjs.org/:_authToken=$(cat /run/secrets/NPM_TOKEN) \
        && ${BUILD_NPM} ci \
        && ${BUILD_NPM} run build \
        && find /app -type d | grep '[/][.]git$' | xargs rm -rf \
        && find /app -type f | grep '[/][.]git.*$' | xargs rm -rf


### Export #####################################################################
FROM scratch AS export

COPY --link --from=build-backend  \
    /app /backend
COPY --link --from=build-bootstrap  \
    /app/server.js /bootstrap/
COPY --link --from=build-static     \
    /app/packages/deliver-app/dist /static
COPY --link --from=build-sandbox    \
    /app /sandbox

COPY ./router.php /backend/router.php

COPY meta /meta
