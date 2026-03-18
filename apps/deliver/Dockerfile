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


### Export #####################################################################
FROM scratch AS export

COPY --from=build-packages \
    /local-packages/apps/deliver/src/fe/packages/deliver-app/server.js /bootstrap/
COPY --from=build-packages \
    /local-packages/apps/deliver/src/fe/packages/deliver-app/dist /static
COPY --link --from=build-backend  \
    /app /backend

COPY ./router.php /backend/router.php

COPY meta /meta
