# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE

### backend ####################################################################
FROM $BUILD_IMAGE AS build-backend
ARG BUILD_IMAGE

WORKDIR /app
COPY  --from=src-backend . .

RUN --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
        set -eux; \
        composer install -n --optimize-autoloader --no-dev --prefer-dist; \
        composer dump-autoload -n --optimize --no-dev --classmap-authoritative; \
        rm -rf .build/;

### Export #####################################################################
FROM scratch AS export

COPY --link --from=build-backend \
        --exclude="**/.git*" \
        /app /backend
COPY ./router.php /backend/router.php
