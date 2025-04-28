ARG BUILD_PHP=build/php
ARG BASE=base/php

FROM $BUILD_PHP AS build

RUN set -eux; \
        { \
            echo 'opcache.preload=/var/www/html/config/preload.php'; \
            echo 'opcache.preload_user=www-data'; \
            echo 'opcache.memory_consumption=256'; \
            echo 'opcache.max_accelerated_files=20000'; \
            echo 'opcache.validate_timestamps=0'; \
            echo 'realpath_cache_size=4096K'; \
            echo 'realpath_cache_ttl=600'; \
        } >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
        ;

WORKDIR /app/devkit
COPY src .

RUN --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
        set -eux; \
        composer install -n --optimize-autoloader --no-dev --prefer-dist; \
        composer dump-autoload -n --optimize --no-dev --classmap-authoritative; \
        rm -rf .build/;

FROM scratch AS export

COPY --from=build /app/devkit /

FROM export AS app-devkit

FROM $BASE AS backend

COPY --from=app-devkit --chown=www-data:www-data / /app/devkit
COPY --chown=www-data:www-data ./router.php /app/devkit/router.php
WORKDIR /app/devkit
CMD [ "php", "-S", "0.0.0.0:80", "-t", "/app/devkit/public", "/app/devkit/router.php" ]