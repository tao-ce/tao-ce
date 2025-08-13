# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG GO_BUILD_IMAGE
ARG BUILD_NPM="/usr/local/libexec/nvm/nvm-exec npm"

### auth-server ################################################################
FROM $BUILD_IMAGE AS build-auth-server
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="18"

WORKDIR /app

COPY --from=src-auth-server *.json /app/

RUN --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    ${BUILD_NPM} install && ${BUILD_NPM} install typescript -g && rm -rf /app/logs/*

COPY --from=src-auth-server types /app/types
COPY --from=src-auth-server src /app/src

RUN --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    rm -rf /app/src/dist/test /app/src/dist/configs/keys \
    && ${BUILD_NPM} run build

### lti-gateway ################################################################
FROM $BUILD_IMAGE AS build-lti-gateway
ARG BUILD_IMAGE

WORKDIR /app

COPY --from=src-lti-gateway . /app
COPY src/libs /libs

RUN set -eux; \
    composer install -n --optimize-autoloader --no-dev --prefer-dist; \
    composer dump-autoload -n --optimize --no-dev --classmap-authoritative; \
    rm -rf .build/;


### sidecar ####################################################################
FROM $GO_BUILD_IMAGE AS build-sidecar
ARG GO_BUILD_IMAGE

ENV GOCACHE=/go-cache
ENV GOMODCACHE=/gomod-cache

WORKDIR /app
COPY src/libs/lib-em-go-proto /libs/lib-em-go-proto
COPY --from=src-sidecar go.mod go.sum /app

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

COPY --from=build-auth-server \
    --exclude="**/.git*" \
    /app/dist /auth-server
COPY --from=build-auth-server \
    --exclude="**/.git*" \
    /app/node_modules /auth-server/node_modules
COPY --from=build-lti-gateway \
    --exclude="**/.git*" \
    /app /lti-gateway
COPY --from=build-lti-gateway \
    --exclude="**/.git*" \
    /libs /libs
COPY --from=build-sidecar \
    --exclude="**/.git*" \
    /server /app/config.yaml /sidecar/

