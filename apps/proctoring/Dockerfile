# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG GO_BUILD_IMAGE
ARG BUILD_NPM="/usr/local/libexec/nvm/nvm-exec npm"

### lti1p3-gateway ####################################################################
FROM $BUILD_IMAGE AS build-lti1p3-gateway
ARG BUILD_IMAGE
ARG STATE_ROOT="/var/lib/tao-ce/proctoring/lti1p3-gateway"

WORKDIR /app
COPY --exclude="**/composer.lock" --from=src-lti13-gateway . .

RUN \
        --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
        --mount=type=bind,from=src-packages,target=local-packages/packages \
        --mount=type=bind,from=src-apps,target=local-packages/apps \
        --mount=type=bind,from=hack,target=/opt/hack \
        /opt/hack/utils/composer-patch/patch.sh \
            && APP_ENV=dev composer install -van

RUN \
    cd /app \
    && rm -rf \
        var .build/ \
    && mkdir -p \
        ${STATE_ROOT}/data \
    && ln -s \
        ${STATE_ROOT}/data \
        var

### fe-base ####################################################################
FROM $BUILD_IMAGE AS build-fe-base
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="22"

WORKDIR /local-packages/packages/live-design-system

COPY --exclude="**/package-lock.json" --from=src-packages \
    live-design-system .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    ${BUILD_NPM} install \
    && ${BUILD_NPM} run build

WORKDIR /app

### fe-wait ####################################################################
FROM build-fe-base AS build-fe-wait
ARG BUILD_NPM

COPY --exclude="**/package-lock.json" --from=src-frontend-auth-wait . .

RUN \
    --mount=type=bind,from=hack,target=/opt/hack \
    /opt/hack/utils/npm-patch/patch.sh ./package.json /opt/hack/utils/npm-patch/deliver.json

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
        ${BUILD_NPM} install --install-links

### frontend-auth-wait-bootstrap #####################################################################
FROM build-fe-wait AS build-frontend-auth-wait-bootstrap
ARG BUILD_NPM

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
        ${BUILD_NPM} run build:bootstrap

### frontend-auth-wait-static #####################################################################
FROM build-fe-wait AS build-frontend-auth-wait-static
ARG BUILD_NPM

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
        ${BUILD_NPM} run build:static

### fe #########################################################################
FROM build-fe-base AS build-fe

COPY --exclude="**/package-lock.json" --from=src-frontend . .

RUN \
    --mount=type=bind,from=hack,target=/opt/hack \
    /opt/hack/utils/npm-patch/patch.sh ./package.json /opt/hack/utils/npm-patch/deliver.json

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
        ${BUILD_NPM} install --install-links

### frontend-bootstrap #####################################################################
FROM build-fe AS build-frontend-bootstrap
ARG BUILD_NPM
RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
        ${BUILD_NPM} run build:bootstrap

### frontend-static #####################################################################
FROM build-fe AS build-frontend-static
ARG BUILD_NPM

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
        ${BUILD_NPM} run build:static

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
COPY --from=src-apps proctoring/src/apps/go.* . 
WORKDIR /build/forwarder


ENV GOCACHE=/go-cache
ENV GOMODCACHE=/gomod-cache
ENV CGO_ENABLED=1
ARG SVC_NAME=forwarder

RUN \
    --mount=type=cache,target=/gomod-cache \
    --mount=type=cache,target=/go-cache \
        go mod download

RUN \    
        --mount=type=cache,target=/gomod-cache \
        --mount=type=cache,target=/go-cache \
        GOOS=linux go build \
                -ldflags '-linkmode=external -extldflags "-static"' \
                -o /service \
                service/forwarder.go

### Export #####################################################################
FROM scratch AS export

COPY --link --from=build-forwarder \
    /service /service

COPY --link --from=build-frontend-auth-wait-bootstrap \
    /app/server.js /frontend-auth-wait/bootstrap/
COPY --link --from=build-frontend-auth-wait-bootstrap \
    /app/sandbox /frontend-auth-wait/bootstrap/sandbox
COPY --link --from=build-frontend-auth-wait-static \
    /app/dist /frontend-auth-wait/static

COPY --link --from=build-frontend-static     \
    /app/dist /frontend/static
COPY --link --from=build-frontend-bootstrap  \
    /app/server.js /frontend/bootstrap/

COPY --link --from=build-lti1p3-gateway     \
    /app /lti1p3-gateway
COPY ./router.php /lti1p3-gateway/router.php
COPY ./router.php /lti1p3-gateway/public/router.php

COPY --link --from=build-realtime-service     \
    /app /realtime-service

COPY meta /meta
