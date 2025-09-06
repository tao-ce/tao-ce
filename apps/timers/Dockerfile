# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM="/usr/local/libexec/nvm/nvm-exec npm"

### backend ####################################################################
FROM $BUILD_IMAGE AS build-backend
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="22"
WORKDIR /app

COPY --from=src-backend . .

RUN --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    ${BUILD_NPM} ci && ${BUILD_NPM} run build \
    && find /app -type d | grep '[/][.]git$' | xargs rm -rf \
    && find /app -type f | grep '[/][.]git.*$' | xargs rm -rf

### Export #####################################################################
FROM scratch AS export

COPY --link --from=build-backend \
    /app /backend

COPY meta /meta
