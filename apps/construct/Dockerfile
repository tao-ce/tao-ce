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

RUN \
    --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
    --mount=type=bind,from=src-packages,target=local-packages/packages \
    --mount=type=bind,from=src-apps,target=local-packages/apps \
    --mount=type=bind,from=build-packages,src=local-packages/packages/tao-test-preview-ui-loader,target=local-packages/packages/extension-tao-test-preview-ui-loader/views \
    --mount=type=bind,from=build-packages,src=local-packages,target=/local-packages \
    --mount=type=bind,from=build-packages,src=packs,target=/packs \
    --mount=type=bind,from=hack,target=/opt/hack \
    <<EORUN
        set -eux
        . /usr/local/libexec/nvm/nvm.sh
        /opt/hack/utils/composer-patch/patch.sh
        composer install -vn \
            --no-interaction \
            --no-dev \
            --no-ansi --no-progress \
            --ignore-platform-reqs
        curl -L "https://github.com/mathjax/MathJax/archive/$MATHJAX_VERSION.tar.gz" \
            | tar --strip-components=1 -xz \
                -C "/app/taoQtiItem/views/js/mathjax"
EORUN

COPY --from=src-code ./index.php .

RUN \
    <<EORUN
        find /app -type d | grep '[/][.]git[a-z]*$' | xargs rm -rf
        find /app -type f | grep '[/][.]git.*$' | xargs rm -rf
        rm -rf \
            /app/*/test/ \
            /app/*/views/js/{test,tests} \
            /app/*/views/cypress \
            /app/vendor/*/*/{test,tests,test_files}
EORUN


### backend ####################################################################
FROM code AS build-backend
ARG STATE_ROOT="/var/lib/tao-ce/construct"
RUN \
    cd /app \
    && rm -rf \
        ./*/views/js \
        ./*/views/css \
        ./*/views/cypress \
        ./*/views/node_modules \
        ./*/views/scss \
        ./*/views/build \
        ./tao/views/locales \
        ./config \
        ./data \
    && mkdir -p \
        ${STATE_ROOT}/config \
        ${STATE_ROOT}/locales \
        tao/views \
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

