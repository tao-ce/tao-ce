# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM_REGISTRY

### ms-fe-bootstrap #####################################################################
FROM $BUILD_IMAGE AS ms-fe
ARG BUILD_IMAGE
ARG BUILD_NPM_REGISTRY

ENV NODE_VERSION="24"
ENV NODE_ENV=dev
WORKDIR /app

COPY --from=src-ms-fe . .

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
        npm run generate:locale
        npm run build:bootstrap
        npm run build:static
        dev_git_cleanup /app
EORUN

### ms-be ####################################################################
FROM $BUILD_IMAGE AS ms-be
ARG BUILD_IMAGE
ARG BUILD_COMPOSER_REGISTRY
ARG STATE_ROOT="/var/lib/tao-ce/scoring/ms-be"
ENV STATE_ROOT=$STATE_ROOT

WORKDIR /app
COPY --from=src-ms ./composer.json ./composer.src.json
COPY --from=src-ms ./symfony.lock ./symfony.src.lock

RUN <<EORUN
    . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
    cat ./composer.src.json \
        | dev_composer_prune_repositories \
        | dev_composer_stability \
        | jq 'del(.require["oat-sa/bundle-bigtable-document-manager"])' \
        | jq 'del(.require["symfony/amazon-sqs-messenger"])' \
        | jq 'del(.require["league/flysystem-aws-s3-v3"])' \
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
        | dev_composer_require_version doctrine/doctrine-fixtures-bundle "^3.4" \
        | dev_composer_require_version symfony/debug-bundle "~6.4.0" \
        | tee composer.json
    cat ./symfony.src.lock \
        | jq 'del(.["google/cloud-bigtable"])' \
        | jq 'del(.["oat-sa/bundle-bigtable-document-manager"])' \
        | jq 'del(.["symfony/amazon-sqs-messenger"])' \
        | jq 'del(.["league/flysystem-aws-s3-v3"])' \
        | jq 'del(.["aws/aws-sdk-php"])' \
        | jq 'del(.["aws/aws-crt-php"])' \
        | jq 'del(.["async-aws/sqs"])' \
        | jq 'del(.["async-aws/core"])' \
    | tee symfony.lock
    rm -f composer.src.json symfony.src.lock
EORUN

COPY --from=src-ms --exclude=**/composer.lock --exclude=**/composer.json --exclude=**/symfony.lock . .

RUN \
    --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
    <<EORUN
        . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
        composer config -g secure-http false
        dev_composer_registry oat-sa $BUILD_COMPOSER_REGISTRY
        composer install -van --no-dev --no-scripts
        composer dump-env dev
        echo '<?php return [];' >.env.local.php
        rm -rf .build
        dev_git_cleanup /app
        state_data data var
EORUN

### ss-be ####################################################################
FROM $BUILD_IMAGE AS ss-be
ARG BUILD_IMAGE
ARG STATE_ROOT="/var/lib/tao-ce/scoring/ss"
ARG BUILD_COMPOSER_REGISTRY
ENV STATE_ROOT=$STATE_ROOT

WORKDIR /app
COPY --from=src-ss ./composer.json ./composer.src.json
COPY --from=src-ss ./symfony.lock ./symfony.src.lock

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
        | dev_composer_require_version doctrine/doctrine-fixtures-bundle "^3.4" \
        | tee composer.json
    cat ./symfony.src.lock \
        | jq 'del(.["google/cloud-bigtable"])' \
        | jq 'del(.["oat-sa/bundle-bigtable-document-manager"])' \
        | jq 'del(.["symfony/amazon-sqs-messenger"])' \
        | jq 'del(.["league/flysystem-aws-s3-v3"])' \
        | jq 'del(.["aws/aws-sdk-php"])' \
        | jq 'del(.["aws/aws-crt-php"])' \
        | jq 'del(.["async-aws/sqs"])' \
        | jq 'del(.["async-aws/core"])' \
    | tee symfony.lock
    rm -f composer.src.json symfony.src.lock
EORUN

COPY --from=src-ss --exclude=**/composer.lock --exclude=**/composer.json --exclude=**/symfony.lock . .

RUN \
    --mount=type=cache,id=composer-cache,target=/root/.composer/cache \
    <<EORUN
        . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
        composer config -g secure-http false
        dev_composer_registry oat-sa $BUILD_COMPOSER_REGISTRY
        composer install -van --no-dev --no-scripts
        composer dump-env dev
        rm -rf .build
        dev_git_cleanup /app
        state_data data var
EORUN


### Export #####################################################################
FROM scratch AS export

COPY --link --from=ms-be \
    /app /ms-be
COPY --link --from=ss-be \
    /app /ss
COPY --link --from=ms-fe \
    /app/server.cjs /ms-fe/bootstrap/
COPY --link --from=ms-fe \
    /app/dist /ms-fe/static

## COPY route files
COPY ./router.php /ms-be/router.php
COPY ./router.php /ms-be/public/router.php
COPY ./router.php /ss/router.php
COPY ./router.php /ss/public/router.php


COPY meta /meta
