# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG GO_BUILD_IMAGE
ARG BUILD_NPM="/usr/local/libexec/nvm/nvm-exec npm"
ARG COMPOSER_REGISTRY="https://tao-ce.github.io/registry-composer/main"

### auth-server ################################################################
FROM $BUILD_IMAGE AS build-auth-server-ci
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="22"

WORKDIR /app

COPY --from=src-auth-server *.json /app/

RUN --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    ${BUILD_NPM} install

COPY --from=src-auth-server types /app/types
COPY --from=src-auth-server src /app/src

RUN --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    rm -rf /app/logs/* /app/src/dist/test /app/src/dist/configs/keys \
    && ${BUILD_NPM} run build

FROM $BUILD_IMAGE AS build-auth-server
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="22"

WORKDIR /app

COPY --from=src-auth-server *.json /app/


RUN --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    ${BUILD_NPM} install --omit=dev

COPY --from=build-auth-server-ci /app/dist /app/dist

RUN find /app -type d | grep '[/][.]git$' | xargs rm -rf \
    && find /app -type f | grep '[/][.]git.*$' | xargs rm -rf
    

### lti-gateway ################################################################
FROM $BUILD_IMAGE AS build-lti-gateway
ARG BUILD_IMAGE
ARG STATE_ROOT="/var/lib/tao-ce/environment-management/lti-gateway"
ARG COMPOSER_REGISTRY

WORKDIR /app

COPY --from=src-lti-gateway --exclude="**/composer.lock" . /app

RUN \
        --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
        --mount=type=bind,src=src/libs,target=/libs \
            composer repository -g add tao-ce composer ${COMPOSER_REGISTRY} \
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

COPY ./router.php /lti-gateway/router.php
COPY ./router.php /lti-gateway/public/router.php
COPY --link --from=build-sidecar \
    /server /app/config.yaml /sidecar/

COPY meta /meta
