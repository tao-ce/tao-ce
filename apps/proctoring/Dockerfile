# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG GO_BUILD_IMAGE
ARG BUILD_NPM_REGISTRY
ARG BUILD_COMPOSER_REGISTRY
### lti1p3-gateway ####################################################################
FROM $BUILD_IMAGE AS build-lti1p3-gateway
ARG BUILD_IMAGE
ARG STATE_ROOT="/var/lib/tao-ce/proctoring/lti1p3-gateway"
ENV STATE_ROOT=$STATE_ROOT
ARG BUILD_COMPOSER_REGISTRY

WORKDIR /app
COPY --from=src-lti13-gateway ./composer.json ./composer.src.json
COPY --from=src-lti13-gateway ./symfony.lock ./symfony.src.lock

RUN <<EORUN
    . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
    cat ./composer.src.json \
        | dev_composer_prune_repositories \
        | dev_composer_stability \
        | jq 'del(.require["oat-sa/bundle-bigtable-document-manager"])' \
        | dev_composer_freeze_require_version oat-sa/bundle-cache-document-manager dev-main \
        | dev_composer_freeze_require_version oat-sa/bundle-correlation-ids dev-main \
        | dev_composer_freeze_require_version oat-sa/bundle-document-manager "dev-main as 0.7" \
        | dev_composer_freeze_require_version oat-sa/bundle-elasticsearch-document-manager dev-main \
        | dev_composer_freeze_require_version oat-sa/bundle-em-client dev-main \
        | dev_composer_freeze_require_version oat-sa/bundle-filesystem-document-manager dev-main \
        | dev_composer_freeze_require_version oat-sa/bundle-grader-messenger-bridge "*" \
        | dev_composer_freeze_require_version oat-sa/bundle-qti dev-main \
        | dev_composer_freeze_require_version oat-sa/bundle-scoring-engine dev-main \
        | dev_composer_freeze_require_version oat-sa/extension-tao-deliver-connect dev-main \
        | dev_composer_freeze_require_version oat-sa/extension-tao-deliver-pcis dev-main \
        | dev_composer_freeze_require_version oat-sa/extension-tao-test-preview-ui-loader dev-main \
        | dev_composer_freeze_require_version oat-sa/extension-tao-testqti-export dev-main \
        | dev_composer_freeze_require_version oat-sa/lib-correlation-ids-messenger dev-main \
        | dev_composer_freeze_require_version oat-sa/lib-tenant-management dev-main \
        | dev_composer_freeze_require_version oat-sa/lib-correlation-ids-http-client dev-main \
        | dev_composer_freeze_require_version oat-sa/lib-qti-item-json-compilation dev-main \
        | dev_composer_freeze_require_version oat-sa/lib-em-php-client dev-main \
        | dev_composer_freeze_require_version oat-sa/lib-em-php-lti-client dev-main \
        | dev_composer_freeze_require_version oat-sa/lib-em-php-lti-events dev-main \
        | dev_composer_freeze_require_version oat-sa/tao-timers-client dev-main \
        | tee composer.json
    cat ./symfony.src.lock \
        | jq 'del(.["google/cloud-bigtable"])' \
        | jq 'del(.["oat-sa/bundle-bigtable-document-manager"])' \
    | tee symfony.lock
    rm -f composer.src.json symfony.src.lock
EORUN

COPY --from=src-lti13-gateway --exclude=**/composer.lock --exclude=**/composer.json --exclude=**/symfony.lock . .

RUN \
    --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
    <<EORUN
        . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
        composer config -g secure-http false
        dev_composer_registry oat-sa $BUILD_COMPOSER_REGISTRY
        composer install -van --no-dev --no-scripts
        composer dump-env dev
        echo '<?php return [];' >.env.local.php
        rm -rf .env .build
        dev_git_cleanup /app
        state_data data var
EORUN


### frontend-auth-wait-frontend #####################################################################
FROM $BUILD_IMAGE AS build-frontend-auth-wait
ARG BUILD_IMAGE
ARG BUILD_NPM_REGISTRY

ENV NODE_VERSION="24"
WORKDIR /app

COPY --from=src-frontend-auth-wait . .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    <<EORUN
        . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
        dev_npm_registry $BUILD_NPM_REGISTRY
        npm install -fS --package-lock-only \
            @oat-sa-private/ui-components@latest \
            @oat-sa-private/ui-core@latest \
            @oat-sa-private/ui-elements@latest \
            @oat-sa-private/ui-identity@latest
        npm ci
        dev_git_cleanup /app
EORUN
### frontend-auth-wait-bootstrap #####################################################################
FROM build-frontend-auth-wait AS build-frontend-auth-wait-bootstrap

ENV NODE_VERSION="24"
WORKDIR /app

COPY --from=src-frontend-auth-wait . .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    <<EORUN
        . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
        npm run build:bootstrap
        dev_git_cleanup /app
EORUN
### frontend-auth-wait-static #####################################################################
FROM build-frontend-auth-wait AS build-frontend-auth-wait-static

ENV NODE_VERSION="24"
WORKDIR /app

COPY --from=src-frontend-auth-wait . .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    <<EORUN
        . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
        npm run build:static
        dev_git_cleanup /app
EORUN

### frontend #####################################################################
FROM $BUILD_IMAGE AS build-frontend
ARG BUILD_IMAGE
ARG BUILD_NPM_REGISTRY

ENV NODE_VERSION="24"
WORKDIR /app

COPY --from=src-frontend . .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    <<EORUN
        . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
        dev_npm_registry $BUILD_NPM_REGISTRY
        npm install -fS --package-lock-only \
            @oat-sa-private/ui-components@latest \
            @oat-sa-private/ui-core@latest \
            @oat-sa-private/ui-elements@latest \
            @oat-sa-private/ui-identity@latest
        npm ci
        dev_git_cleanup /app
EORUN

### frontend-bootstrap #####################################################################
FROM build-frontend AS build-frontend-bootstrap

ENV NODE_VERSION="24"
WORKDIR /app

COPY --from=src-frontend . .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    <<EORUN
        . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
        npm run build:bootstrap
        dev_git_cleanup /app
EORUN

### frontend-static #####################################################################
FROM build-frontend AS build-frontend-static

ENV NODE_VERSION="24"
WORKDIR /app

COPY --from=src-frontend . .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    <<EORUN
        . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
        npm run build:static
        dev_git_cleanup /app
EORUN

### realtime-service #####################################################################
FROM $BUILD_IMAGE AS build-realtime-service
ARG BUILD_IMAGE
ARG BUILD_NPM_REGISTRY

ENV NODE_VERSION="24"
WORKDIR /app

COPY --from=src-realtime-service package*json .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    <<EORUN
        . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
        dev_npm_registry $BUILD_NPM_REGISTRY
        npm install --omit=dev
        npm install rxjs@7.8.0
        dev_git_cleanup /app
EORUN

FROM build-realtime-service AS build-realtime-service-dist
ARG BUILD_IMAGE
ARG BUILD_NPM_REGISTRY

ENV NODE_VERSION="24"
WORKDIR /app


RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    <<EORUN
        . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
        dev_npm_registry $BUILD_NPM_REGISTRY
        npm install
EORUN

COPY --from=src-realtime-service . .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    <<EORUN
        . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
        npm run build
        dev_git_cleanup /app
EORUN

### forwarder ##################################################################
FROM $GO_BUILD_IMAGE AS build-forwarder
ARG GO_BUILD_IMAGE

WORKDIR /build
COPY --from=src-forwarder . /build/forwarder
COPY --from=src-go-shared . go-shared/
COPY --from=src-protobuf . protobuf/
COPY --from=src-apps go.* . 
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
        --mount=type=ssh \
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
COPY --link --from=build-realtime-service-dist     \
    /app/dist /realtime-service/dist

COPY meta /meta
