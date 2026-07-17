# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM_REGISTRY
ARG BUILD_COMPOSER_REGISTRY
### backend ####################################################################
FROM $BUILD_IMAGE AS build-backend
ARG BUILD_IMAGE
ARG STATE_ROOT="/var/lib/tao-ce/deliver"
ENV STATE_ROOT=$STATE_ROOT
ARG BUILD_COMPOSER_REGISTRY

WORKDIR /app

COPY --from=src-backend ./composer.json ./composer.src.json
COPY --from=src-backend ./symfony.lock ./symfony.src.lock

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
        | dev_composer_require_version oat-sa/lib-grader-messenger-bridge "dev-main as 5.4.0" \
        | tee composer.json
    cat ./symfony.src.lock \
        | jq 'del(.["google/cloud-bigtable"])' \
        | jq 'del(.["oat-sa/bundle-bigtable-document-manager"])' \
    | tee symfony.lock
    rm -f composer.src.json symfony.src.lock
EORUN

COPY --from=src-backend --exclude=**/composer.lock --exclude=**/composer.json --exclude=**/symfony.lock . .

RUN \
    --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
    <<EORUN
        . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
        sed -i \
            -e '/BigtableDocumentManagerBundle/d' \
            config/bundles.php \
            src/DocumentManager/Filter/DeliveryExecution/DeliveryExecutionCollectionFilterFactory.php
        grep -v APP_ENV .env.prod >.env
        composer config -g secure-http false
        dev_composer_registry oat-sa $BUILD_COMPOSER_REGISTRY
        composer install -van --no-dev --no-scripts
        composer dump-env dev
        echo '<?php return [];' >.env.local.php
        rm -rf .env .build
        dev_git_cleanup /app
        state_data data var
EORUN

### frontend ###################################################################
FROM $BUILD_IMAGE AS build-frontend
ARG BUILD_IMAGE
ARG BUILD_NPM_REGISTRY
ENV NODE_VERSION="24"
WORKDIR /app

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    <<EORUN
        . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
        echo .sss
        dev_npm_registry $BUILD_NPM_REGISTRY
        npm install --omit=dev @oat-sa-private/tao-deliver-app
EORUN

### Export #####################################################################
FROM scratch AS export

COPY --link --from=build-backend  \
    /app /backend
COPY --link --from=build-frontend \
    /app/node_modules/@oat-sa-private/tao-deliver-app/server.js /bootstrap/
COPY --link --from=build-frontend \
    /app/node_modules/@oat-sa-private/tao-deliver-app/dist /static

COPY ./router.php /backend/router.php

COPY meta /meta
