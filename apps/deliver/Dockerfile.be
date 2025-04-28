ARG BUILD_PHP=build/php
ARG BASE=base/php

FROM $BUILD_PHP AS build

WORKDIR /app/deliver
COPY src/be .

RUN     --mount=type=ssh \
        --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
        set -eux; \
        env ; \
        # export SSH_AUTH_SOCK=/run/secrets/ssh;\
        composer install -n --classmap-authoritative --no-dev --prefer-dist; \
        > .env ; \
        composer dump-env prod; \
        echo '<?php return [];' >.env.local.php; \
        rm -rf .env .build/;

FROM scratch AS export

COPY --from=build /app/deliver /

FROM export AS app-deliver

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

COPY --from=app-deliver --chown=www-data:www-data / /app/deliver
COPY --chown=www-data:www-data ./basic_test_1726747527.zip   /app/samples/
COPY --chown=www-data:www-data ./router.php /app/deliver/router.php
WORKDIR /app/deliver
CMD [ "php", "-S", "0.0.0.0:80", "-t", "/app/deliver/public", "/app/deliver/router.php" ]