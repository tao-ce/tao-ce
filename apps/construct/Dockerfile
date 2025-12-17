# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM="/usr/local/libexec/nvm/nvm-exec npm"
ARG MATHJAX_VERSION="2.6.1"

# ### npm ########################################################################
# FROM ${BUILD_IMAGE} AS build-fe
# ARG BUILD_IMAGE
# ARG BUILD_NPM
# ARG BUILD_NPX

# ENV NODE_VERSION="22"
# ENV NODE_ENV=dev

# WORKDIR /local-packages/packages/live-design-system

# COPY --exclude="**/package-lock.json" --from=src-packages \
#     live-design-system .

# RUN \
#     --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
#     ${BUILD_NPM} install \
#     && ${BUILD_NPM} run build

# WORKDIR /local-packages/packages/read-aloud-client

# COPY --exclude="**/package-lock.json" --from=src-packages \
#     read-aloud-client .

# RUN \
#     --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
#     ${BUILD_NPM} install \
#     && ${BUILD_NPM} run build

# WORKDIR /local-packages/apps/deliver/src/fe

# COPY --exclude="**/package-lock.json" --from=src-apps \
#     deliver/src/fe .

# RUN \
#     --mount=type=bind,from=hack,target=/opt/hack \
#     --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
#     <<EORUN
#     set -eux
#     /opt/hack/utils/npm-patch/patch.sh ./package.json /opt/hack/utils/npm-patch/deliver.json
#     /opt/hack/utils/npm-patch/patch.sh ./packages/item-runner/package.json /opt/hack/utils/npm-patch/deliver.runner.json
#     /opt/hack/utils/npm-patch/patch.sh ./packages/test-runner/package.json /opt/hack/utils/npm-patch/deliver.runner.json 
# EORUN

# RUN \
#     --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
#     ${BUILD_NPM} install --install-links

# RUN \
#     --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
#     ${BUILD_NPM} run build:app

# WORKDIR /local-packages/packages/extension-tao-test-preview-ui-loader

# COPY --exclude="**/package-lock.json" --from=src-packages \
#     extension-tao-test-preview-ui-loader .

# RUN \
#     --mount=type=bind,from=hack,target=/opt/hack \
#     --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
#     <<EORUN
#     set -eux
#     cd views
#     /opt/hack/utils/npm-patch/patch.sh ./package.json /opt/hack/utils/npm-patch/preview-ui.json
# EORUN

# RUN \
#     --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
#     ${BUILD_NPM} install --install-links

### code #######################################################################
FROM $BUILD_IMAGE AS code
ARG BUILD_IMAGE
ARG MATHJAX_VERSION

WORKDIR /app
COPY --from=src-code ./composer.json /app/
# COPY --from=src-code ./composer.lock /app/

RUN \
    --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
    --mount=type=bind,from=src-packages,target=local-packages/packages \
    --mount=type=bind,from=src-apps,target=local-packages/apps \
    # --mount=type=bind,from=build-fe,src=/local-packages/packages/extension-tao-test-preview-ui-loader,target=local-packages/packages/extension-tao-test-preview-ui-loader \
    --mount=type=bind,from=hack,target=/opt/hack \
    <<EORUN
        set -eux
        # ls -lrt local-packages/packages/extension-tao-test-preview-ui-loader
        . /usr/local/libexec/nvm/nvm.sh
        /opt/hack/utils/composer-patch/patch.sh
        composer install -van \
            --no-dev \
            --no-ansi --no-progress \
            --ignore-platform-reqs
        curl -L "https://github.com/mathjax/MathJax/archive/$MATHJAX_VERSION.tar.gz" \
            | tar --strip-components=1 -xz \
                -C "/app/taoQtiItem/views/js/mathjax"
EORUN

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

