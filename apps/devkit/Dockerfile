# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE

### backend ####################################################################
FROM $BUILD_IMAGE AS build-backend
ARG BUILD_IMAGE
ARG STATE_ROOT="/var/lib/tao-ce/devkit"

WORKDIR /app
COPY  --from=src-backend . .

RUN --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
        set -eux; \
        composer install -n --optimize-autoloader --no-dev --prefer-dist; \
        composer dump-autoload -n --optimize --no-dev --classmap-authoritative; \
        rm -rf .build/ config/packages/lti1p3.yaml config/keys; \
        find /app -type d | grep '[/][.]git$' | xargs rm -rf ;\
        find /app -type f | grep '[/][.]git.*$' | xargs rm -rf ;

RUN \
    cd /app \
    && rm -rf \
        ./config/keys \
        ./config/packages/lti1p3.yaml \
    && mkdir -p \
        ${STATE_ROOT}/config/keys \
    && touch \
        ${STATE_ROOT}/config/lti1p3.yaml \
    && ln -s \
        ${STATE_ROOT}/config/keys \
        config/keys \
    && ln -s \
        ${STATE_ROOT}/config/lti1p3.yaml \
        config/packages/lti1p3.yaml


### Export #####################################################################
FROM scratch AS export

COPY --link --from=build-backend \
        /app /backend
COPY ./router.php /backend/router.php

COPY meta /meta