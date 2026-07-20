# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM="/usr/local/libexec/nvm/nvm-exec npm"
ARG MATHJAX_VERSION="2.6.1"
ARG BUILD_COMPOSER_REGISTRY
ARG BUILD_NPM_REGISTRY

### code #######################################################################
FROM $BUILD_IMAGE AS code
ARG BUILD_IMAGE
ARG MATHJAX_VERSION
ARG BUILD_COMPOSER_REGISTRY
ARG BUILD_NPM_REGISTRY
ENV NODE_VERSION="24"

WORKDIR /app
COPY --from=src-code ./composer.json ./composer.src.json

RUN \
    <<EORUN
        . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
        cat ./composer.src.json \
            | dev_composer_stability \
            | dev_composer_prune_repositories \
            | dev_composer_freeze_require_version oat-sa/extension-tao-deliver-connect dev-main \
            | dev_composer_freeze_require_version oat-sa/extension-tao-deliver-pcis dev-main \
            | dev_composer_freeze_require_version oat-sa/extension-tao-test-preview-ui-loader dev-main \
            | dev_composer_freeze_require_version oat-sa/extension-tao-testqti-export dev-main \
            | tee composer.json
EORUN

RUN \
    --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
    <<EORUN
        . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
        . /usr/local/libexec/nvm/nvm.sh
        dev_npm_registry $BUILD_NPM_REGISTRY
        composer config -g secure-http false
        dev_composer_registry oat-sa $BUILD_COMPOSER_REGISTRY
        composer install \
            --no-interaction \
            --no-dev \
            --no-ansi --no-progress \
            --ignore-platform-reqs \
            --prefer-source \
            -vv
        curl -L "https://github.com/mathjax/MathJax/archive/$MATHJAX_VERSION.tar.gz" \
            | tar --strip-components=1 -xz \
                -C "/app/taoQtiItem/views/js/mathjax"
        dev_git_cleanup /app
EORUN

COPY --from=src-code ./index.php .


### backend ####################################################################
FROM code AS build-backend
ARG STATE_ROOT="/var/lib/tao-ce/construct"
ENV STATE_ROOT="${STATE_ROOT}"
RUN <<EORUN
    . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
    rm -rf \
        ./*/views/js \
        ./*/views/css \
        ./*/views/cypress \
        ./*/views/node_modules \
        ./*/views/scss \
        ./*/views/build \
        ./tao/views/locales \
        ./config \
        ./data
    state_data config config
    state_data locales tao/views/locales
    state_data data data
EORUN

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

