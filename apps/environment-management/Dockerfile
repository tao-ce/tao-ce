# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG GO_BUILD_IMAGE
ARG BUILD_NPM="/usr/local/libexec/nvm/nvm-exec npm"

### auth-server ################################################################
FROM $BUILD_IMAGE AS build-auth-server
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="22"

WORKDIR /app

COPY --from=src-auth-server *.json /app/

RUN --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    ${BUILD_NPM} install && ${BUILD_NPM} install typescript -g && rm -rf /app/logs/*

COPY --from=src-auth-server types /app/types
COPY --from=src-auth-server src /app/src

RUN --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    rm -rf /app/src/dist/test /app/src/dist/configs/keys \
    && ${BUILD_NPM} run build \
    && find /app -type d | grep '[/][.]git$' | xargs rm -rf \
    && find /app -type f | grep '[/][.]git.*$' | xargs rm -rf
    

### lti-gateway ################################################################
FROM $BUILD_IMAGE AS build-lti-gateway
ARG BUILD_IMAGE
ARG STATE_ROOT="/var/lib/tao-ce/environment-management/lti-gateway"

WORKDIR /app

COPY --from=src-lti-gateway . /app

RUN \
        --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
        --mount=type=bind,from=src-packages,target=local-packages/packages \
        --mount=type=bind,from=src-apps,target=local-packages/apps \
        --mount=type=bind,from=hack,target=/opt/hack \
        /opt/hack/utils/composer-patch/patch.sh \
            && composer update \
                -vn \
                --root-reqs \
                --prefer-install=source \
                --no-install \
                --no-scripts \
            && composer install -vno --no-dev

RUN set -eux; \
    composer dump-autoload -n --optimize --no-dev --classmap-authoritative; \
    rm -rf .build/; \
    find /app -type d | grep '[/][.]git$' | xargs rm -rf ; \
    find /app -type f | grep '[/][.]git.*$' | xargs rm -rf

RUN \
    cd /app \
    && rm -rf \
        var \
    && mkdir -p \
        ${STATE_ROOT}/data \
    && ln -s \
        ${STATE_ROOT}/data \
        var
### sidecar ####################################################################
FROM $GO_BUILD_IMAGE AS build-sidecar
ARG GO_BUILD_IMAGE

ENV GOCACHE=/go-cache
ENV GOMODCACHE=/gomod-cache

WORKDIR /app
COPY src/libs/lib-em-go-proto /libs/lib-em-go-proto
COPY --from=src-sidecar go.mod go.sum /app/

RUN \
    --mount=type=cache,target=/gomod-cache \
    --mount=type=cache,target=/go-cache \
        go mod download

COPY --from=src-sidecar . /app

RUN \
    --mount=type=cache,target=/gomod-cache \
    --mount=type=cache,target=/go-cache \
        go build \
            -ldflags '-extldflags "-static"' \
            -o /server \
            cmd/sidecar_api/main.go

### Export #####################################################################
FROM scratch AS export

COPY --link --from=build-auth-server \
    /app/dist /auth-server
COPY --link --from=build-auth-server \
    /app/node_modules /auth-server/node_modules
COPY --link --from=build-lti-gateway \
    /app /lti-gateway
# COPY --link --from=build-lti-gateway \
#     /libs /libs
COPY ./router.php /lti-gateway/router.php
COPY ./router.php /lti-gateway/public/router.php
COPY --link --from=build-sidecar \
    /server /app/config.yaml /sidecar/

COPY meta /meta
