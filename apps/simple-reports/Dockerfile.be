ARG BUILD_PHP=build/php
ARG BASE=base/php

FROM $BUILD_PHP AS build

WORKDIR /app/simple-reports
COPY src .

RUN     --mount=type=ssh \
        --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
        set -eux; \
        cp .env.prod .env; \
        env ; \
        composer install -n --classmap-authoritative --no-dev --prefer-dist; \
        composer dump-env prod; \
        rm -rf .env .build/;

FROM scratch AS export

COPY --from=build /app/simple-reports /

FROM export AS app-simple-reports

FROM $BASE AS backend

RUN set -eux; \
        { \
            echo 'opcache.memory_consumption=256'; \
            echo 'opcache.jit_buffer_size=256M'; \
            echo 'opcache.interned_strings_buffer=16'; \
            echo 'opcache.max_accelerated_files=20000'; \
            echo 'opcache.revalidate_freq=0'; \
            echo 'opcache.fast_shutdown=1'; \
            echo 'opcache.enable_cli=1'; \
            echo 'opcache.load_comments=1'; \
            echo 'realpath_cache_size=4096K'; \
            echo 'realpath_cache_ttl=600'; \
        } >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
        ; \
        mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini; \
        { \
            echo 'grpc.grpc_verbosity=error'; \
            echo 'grpc.log_filename=/dev/fd/2'; \
        } >> /usr/local/etc/php/php.ini \
        ; \
        rm /usr/local/etc/php-fpm.d/www*;

RUN set -eux; \
  { \
    echo 'upload_max_filesize=60M'; \
    echo 'post_max_filesize=60M'; \
    echo 'post_max_size=60M'; \
  } >> /usr/local/etc/php/conf.d/upload.ini \
;
COPY --from=app-simple-reports --chown=www-data:www-data / /app/simple-reports/
COPY --chown=www-data:www-data ./router.php /app/simple-reports/router.php
WORKDIR /app/simple-reports
RUN rm -f .env*
RUN echo "<?php return ['APP_ENV' => 'prod'];" > .env.local.php
CMD [ "php", "-S", "0.0.0.0:80", "-t", "/app/simple-reports/public", "/app/simple-reports/router.php" ]