# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM="/usr/local/libexec/nvm/nvm-exec npm"
### backend ####################################################################
FROM $BUILD_IMAGE AS build-backend
ARG BUILD_IMAGE

WORKDIR /app
COPY --from=src-backend . .

RUN     --mount=type=ssh \
        --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
        set -eux; \
        mv .env.prod .env; \
        composer install -n --classmap-authoritative --no-dev --prefer-dist; \
        > .env ; \
        composer dump-env prod; \
        echo '<?php return [];' >.env.local.php; \
        rm -rf .env .build/;

### bootstrap ##################################################################
FROM $BUILD_IMAGE AS build-bootstrap
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="18"
WORKDIR /app

COPY --from=src-frontend ./packages/deliver-app .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
        ${BUILD_NPM} run build:bootstrap

### static #####################################################################
FROM $BUILD_IMAGE AS build-static
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="18"
WORKDIR /app

COPY --from=src-frontend . .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    --mount=type=secret,id=NPM_TOKEN \
        ${BUILD_NPM} config set //registry.npmjs.org/:_authToken=$(cat /run/secrets/NPM_TOKEN) \
        && ${BUILD_NPM} ci \
        && ${BUILD_NPM} run build:app


### sandbox ####################################################################

FROM $BUILD_IMAGE AS build-sandbox
ARG BUILD_IMAGE
ARG BUILD_NPM

WORKDIR /app

ENV NODE_VERSION="18"
ENV API_URL=/data
ARG PORT=3000

COPY --from=src-sandbox . .

RUN \
    --mount=type=secret,id=NPM_TOKEN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
        ${BUILD_NPM} config set //registry.npmjs.org/:_authToken=$(cat /run/secrets/NPM_TOKEN) \
        && ${BUILD_NPM} ci \
        && ${BUILD_NPM} run build

### Export #####################################################################
FROM scratch AS export

COPY --link --from=build-backend  \
    --exclude="**/.git*" \
    /app /backend
COPY --link --from=build-bootstrap  \
    --exclude="**/.git*" \
    /app /bootstrap
COPY --link --from=build-static     \
    --exclude="**/.git*" \
    /app/packages/deliver-app/dist /static
COPY --link --from=build-sandbox    \
    --exclude="**/.git*" \
    /app /sandbox

COPY ./router.php /backend/router.php


