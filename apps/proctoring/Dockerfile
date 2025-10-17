# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG GO_BUILD_IMAGE
ARG BUILD_NPM="/usr/local/libexec/nvm/nvm-exec npm"

### lti1p3-gateway ####################################################################
FROM $BUILD_IMAGE AS build-lti1p3-gateway
ARG BUILD_IMAGE
ARG STATE_ROOT="/var/lib/tao-ce/proctoring/lti1p3-gateway"

WORKDIR /app
COPY --from=src-lti13-gateway . .

RUN     --mount=type=ssh \
        --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
        set -eux; \
        composer install  --classmap-authoritative --prefer-dist; \
        composer dump-env dev; \
        echo '<?php return [];' >.env.local.php; \
        rm -rf .build/ var/storage; \
        find /app -type d | grep '[/][.]git$' | xargs rm -rf ;\
        find /app -type f | grep '[/][.]git.*$' | xargs rm -rf ;

RUN \
    cd /app \
    && rm -rf \
        var \
    && mkdir -p \
        ${STATE_ROOT}/data \
    && ln -s \
        ${STATE_ROOT}/data \
        var


### frontend-auth-wait-bootstrap #####################################################################
FROM $BUILD_IMAGE AS build-frontend-auth-wait-bootstrap
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="22"
WORKDIR /app

COPY --from=src-frontend-auth-wait . .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    --mount=type=secret,id=NPM_TOKEN \
        ${BUILD_NPM} config set //registry.npmjs.org/:_authToken=$(cat /run/secrets/NPM_TOKEN) \
        && ${BUILD_NPM} ci \
        && ${BUILD_NPM} run build:bootstrap \
        && find /app -type d | grep '[/][.]git$' | xargs rm -rf \
        && find /app -type f | grep '[/][.]git.*$' | xargs rm -rf

### frontend-auth-wait-static #####################################################################
FROM $BUILD_IMAGE AS build-frontend-auth-wait-static
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="22"
WORKDIR /app

COPY --from=src-frontend-auth-wait . .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    --mount=type=secret,id=NPM_TOKEN \
        ${BUILD_NPM} config set //registry.npmjs.org/:_authToken=$(cat /run/secrets/NPM_TOKEN) \
        && ${BUILD_NPM} ci \
        && ${BUILD_NPM} run build:static \
        && find /app -type d | grep '[/][.]git$' | xargs rm -rf \
        && find /app -type f | grep '[/][.]git.*$' | xargs rm -rf

### frontend-bootstrap #####################################################################
FROM $BUILD_IMAGE AS build-frontend-bootstrap
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="22"
WORKDIR /app

COPY --from=src-frontend . .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    --mount=type=secret,id=NPM_TOKEN \
        ${BUILD_NPM} config set //registry.npmjs.org/:_authToken=$(cat /run/secrets/NPM_TOKEN) \
        && ${BUILD_NPM} ci \
        && ${BUILD_NPM} run build:bootstrap \
        && find /app -type d | grep '[/][.]git$' | xargs rm -rf \
        && find /app -type f | grep '[/][.]git.*$' | xargs rm -rf

### frontend-static #####################################################################
FROM $BUILD_IMAGE AS build-frontend-static
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="22"
WORKDIR /app

COPY --from=src-frontend . .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    --mount=type=secret,id=NPM_TOKEN \
        ${BUILD_NPM} config set //registry.npmjs.org/:_authToken=$(cat /run/secrets/NPM_TOKEN) \
        && ${BUILD_NPM} ci \
        && ${BUILD_NPM} run build:static \
        && find /app -type d | grep '[/][.]git$' | xargs rm -rf \
        && find /app -type f | grep '[/][.]git.*$' | xargs rm -rf

### realtime-service #####################################################################
FROM $BUILD_IMAGE AS build-realtime-service
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="22"
WORKDIR /app

COPY --from=src-realtime-service . .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    --mount=type=secret,id=NPM_TOKEN \
        ${BUILD_NPM} config set //registry.npmjs.org/:_authToken=$(cat /run/secrets/NPM_TOKEN) \
        && ${BUILD_NPM} ci \
        && ${BUILD_NPM} run build \
        && find /app -type d | grep '[/][.]git$' | xargs rm -rf \
        && find /app -type f | grep '[/][.]git.*$' | xargs rm -rf

### forwarder ##################################################################
FROM $GO_BUILD_IMAGE AS build-forwarder
ARG GO_BUILD_IMAGE
ARG BUILD_NPM


WORKDIR /build
COPY --from=src-forwarder . /build/forwarder
COPY --from=src-go-shared . go-shared/
COPY --from=src-protobuf . protobuf/
COPY --from=src-apps go.* . 
WORKDIR /build/forwarder


ENV GOCACHE=/go-cache
ENV GOMODCACHE=/gomod-cache
ENV CGO_ENABLED=0

RUN \
    --mount=type=ssh \
    --mount=type=cache,target=/gomod-cache \
    --mount=type=cache,target=/go-cache \
        go mod download

RUN \    
        --mount=type=ssh \
        --mount=type=cache,target=/gomod-cache \
        --mount=type=cache,target=/go-cache \
        GOOS=linux go build \
                -ldflags '-s -w' \
                -o /service \
                service/forwarder.go
### Export #####################################################################
FROM scratch AS export

COPY --link --from=build-forwarder \
    /service /forwarder

COPY --link --from=build-frontend-auth-wait-bootstrap \
    /app /frontend-auth-wait/bootstrap
COPY --link --from=build-frontend-auth-wait-static \
    /app/dist /frontend-auth-wait/static

COPY --link --from=build-frontend-static     \
    /app/dist /frontend/static
COPY --link --from=build-frontend-bootstrap  \
    /app /frontend/bootstrap

COPY --link --from=build-lti1p3-gateway     \
    /app /lti1p3-gateway
COPY ./router.php /lti1p3-gateway/router.php

COPY --link --from=build-realtime-service     \
    /app /realtime-service

COPY meta /meta
