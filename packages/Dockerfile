# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM="/usr/local/libexec/nvm/nvm-exec npm"
ARG BUILD_NPX="/usr/local/libexec/nvm/nvm-exec npx"
### fe #########################################################################
FROM ${BUILD_IMAGE} AS build-env
ARG BUILD_IMAGE
ARG BUILD_NPM
ARG BUILD_NPX

ENV NODE_VERSION="22"
ENV NODE_OPTIONS="--max-old-space-size=4096"
ENV NODE_ENV=dev

FROM build-env as build-live-design-system

WORKDIR /local-packages/packages/live-design-system

COPY --from=src-packages live-design-system .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    ${BUILD_NPM} ci

FROM build-env as build-read-aloud-client

WORKDIR /local-packages/packages/read-aloud-client

COPY --from=src-packages read-aloud-client .

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    ${BUILD_NPM} ci

FROM build-env as build-deliver-fe

WORKDIR /local-packages/apps/deliver/src/fe

COPY --from=src-apps deliver/src/fe .

COPY --from=build-live-design-system \
    /local-packages/packages/live-design-system \
    /local-packages/packages/live-design-system
COPY --from=build-read-aloud-client \
    /local-packages/packages/read-aloud-client \
    /local-packages/packages/read-aloud-client

RUN \
    --mount=type=bind,from=hack,target=/opt/hack \
    <<EORUN
    set -eux
    /opt/hack/utils/npm-patch/patch.sh ./package.json /opt/hack/utils/npm-patch/deliver.json
    /opt/hack/utils/npm-patch/patch.sh ./packages/test-runner/package.json /opt/hack/utils/npm-patch/deliver.runner.json
EORUN

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    ${BUILD_NPM} update \
        '@oat-sa-private/ui-core' \
        '@oat-sa-private/ui-identity' \
        '@oat-sa-private/ui-components' \
        '@oat-sa-private/ui-elements'

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    ${BUILD_NPX} lerna bootstrap

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    ${BUILD_NPM} install --install-links

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    ${BUILD_NPM} run build:item-runner \
    && ${BUILD_NPM} run build:test-runner \
    && ${BUILD_NPM} run build:app

FROM build-deliver-fe as build-tao-test-preview-ui-loader

WORKDIR /local-packages/packages/tao-test-preview-ui-loader

COPY --from=src-packages extension-tao-test-preview-ui-loader/views .

RUN \
    mkdir -p /packs \
    && cd /local-packages/packages/live-design-system/packages/core &&  ${BUILD_NPM} pack --pack-destination /packs/ \
    && cd /local-packages/packages/live-design-system/packages/identity &&  ${BUILD_NPM} pack --pack-destination /packs/ \
    && cd /local-packages/packages/read-aloud-client &&  ${BUILD_NPM} pack --pack-destination /packs/ \
    && cd /local-packages/apps/deliver/src/fe/packages/test-runner &&  ${BUILD_NPM} pack --pack-destination /packs/ \
    && cd /local-packages/apps/deliver/src/fe/packages/item-runner &&  ${BUILD_NPM} pack --pack-destination /packs/ \
    && echo \
    && mv /packs/oat-sa-private-tao-item-runner-qtinui-*.tgz /packs/oat-sa-private-tao-item-runner-qtinui.tgz \
    && mv /packs/oat-sa-private-tao-test-runner-qtinui-*.tgz /packs/oat-sa-private-tao-test-runner-qtinui.tgz \
    && mv /packs/oat-sa-private-read-aloud-client-*.tgz /packs/oat-sa-private-read-aloud-client.tgz \
    && mv /packs/oat-sa-private-ui-core-*.tgz /packs/oat-sa-private-ui-core.tgz \
    && mv /packs/oat-sa-private-ui-identity-*.tgz /packs/oat-sa-private-ui-identity.tgz \
    && echo

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    --mount=type=bind,from=hack,target=/opt/hack \
    <<EORUN
    /opt/hack/utils/npm-patch/patch.sh ./package.json /opt/hack/utils/npm-patch/tao-test-preview-ui-loader.json
    ${BUILD_NPM} update \
        '@oat-sa-private/tao-test-runner-qtinui' \
        '@oat-sa-private/tao-item-runner-qtinui' \
        '@oat-sa-private/ui-identity' \
        '@oat-sa-private/ui-core' \
        '@oat-sa-private/read-aloud-client'
    ${BUILD_NPM} install --install-links --package-lock-only
EORUN



FROM scratch AS export

COPY --link --from=build-live-design-system \
    /local-packages/packages/live-design-system \
    /local-packages/packages/live-design-system
COPY --link --from=build-read-aloud-client \
    /local-packages/packages/read-aloud-client \
    /local-packages/packages/read-aloud-client
COPY --link --from=build-deliver-fe \
    /local-packages/apps/deliver/src/fe \
    /local-packages/apps/deliver/src/fe
COPY --link --from=build-tao-test-preview-ui-loader \
    /local-packages/packages/tao-test-preview-ui-loader \
    /local-packages/packages/tao-test-preview-ui-loader

COPY --from=build-tao-test-preview-ui-loader /packs /packs



