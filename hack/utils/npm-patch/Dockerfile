ARG BUILD_IMAGE
ARG BUILD_NPM="/usr/local/libexec/nvm/nvm-exec npm"

### base #######################################################################
FROM ${BUILD_IMAGE} AS build-base
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="22"
ENV NODE_ENV=dev
WORKDIR /app

COPY --from=src-frontend packages packages
COPY --from=src-packages live-design-system .local-packages/live-design-system
COPY --from=src-packages read-aloud-client  .local-packages/read-aloud-client

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    cd ./.local-packages/live-design-system && ${BUILD_NPM} install
RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    cd ./.local-packages/live-design-system/packages/core && ${BUILD_NPM} install
RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    cd ./.local-packages/live-design-system/packages/identity && ${BUILD_NPM} install && ${BUILD_NPM} run build
RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    cd ./.local-packages/live-design-system/packages/components && ${BUILD_NPM} install && ${BUILD_NPM} run build
RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    cd ./.local-packages/live-design-system/packages/elements && ${BUILD_NPM} install && ${BUILD_NPM} run build
RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    cd ./.local-packages/read-aloud-client && ${BUILD_NPM} install && ${BUILD_NPM} run build
RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    cd ./packages/apps-common && ${BUILD_NPM} install
RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    cd ./packages/item-runner && ${BUILD_NPM} install
RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    cd ./packages/test-runner && ${BUILD_NPM} install
RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    cd ./packages/deep-linking-app && ${BUILD_NPM} install
RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    cd ./packages/previewer-app && ${BUILD_NPM} install
RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    cd ./packages/deliver-app && ${BUILD_NPM} install

