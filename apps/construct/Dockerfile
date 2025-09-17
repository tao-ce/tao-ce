# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM="/usr/local/libexec/nvm/nvm-exec npm"
ARG MATHJAX_VERSION="2.6.1"

### code #######################################################################
FROM $BUILD_IMAGE AS code
ARG BUILD_IMAGE
ARG MATHJAX_VERSION

WORKDIR /app
COPY --from=src-code ./composer.json /app/
COPY --from=src-code ./composer.lock /app/
COPY --from=src-code ./libs /libs
# COPY --from=src-code . .

        # echo '#!/bin/sh\nshift\n/usr/local/libexec/nvm/nvm-exec npm $@\n' >/usr/local/bin/npm \
        # && chmod a+x /usr/local/bin/npm \
RUN \
    --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
        . /usr/local/libexec/nvm/nvm.sh \
        && composer install \
            --no-interaction \
            --no-dev \
            --no-ansi --no-progress \
            --ignore-platform-reqs \
            --prefer-source \
            -vv \
        && curl -L "https://github.com/mathjax/MathJax/archive/$MATHJAX_VERSION.tar.gz" \
            | tar --strip-components=1 -xz \
                -C "/app/taoQtiItem/views/js/mathjax" \
        && find /app -type d | grep '[/][.]git$' | xargs rm -rf \
        && find /app -type f | grep '[/][.]git.*$' | xargs rm -rf

COPY --from=src-code ./index.php .


### backend ####################################################################
FROM code AS build-backend
ARG STATE_ROOT="/var/lib/tao-ce/construct"
RUN \
    cd /app \
    && rm -rf \
        ./tao/views/locales \
        ./config \
        ./data \
    && mkdir -p \
        ${STATE_ROOT}/config \
        ${STATE_ROOT}/locales \
        ${STATE_ROOT}/state/data \
    && ln -s \
        ${STATE_ROOT}/config \
        config \
    && ln -s \
        ${STATE_ROOT}/data \
        data \
    && ln -s \
        ${STATE_ROOT}/locales \
        tao/views/locales

### frontend ###################################################################
FROM scratch AS build-frontend

COPY --parents --from=code /app/**/views /

### Export #####################################################################
FROM scratch AS export

COPY \ 
    --link --from=build-backend  \
    /app /backend

COPY  \
    --link --from=build-frontend  \
    /app /static

COPY ./router.php /backend/router.php
COPY ./construct.sh /construct.sh
COPY meta /meta

