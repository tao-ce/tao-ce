# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM="/usr/local/libexec/nvm/nvm-exec npm"

### worker #####################################################################
FROM $BUILD_IMAGE AS build-worker
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="22"
WORKDIR /app

COPY --from=src-worker package*.json ./

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    ${BUILD_NPM} install

COPY --from=src-worker . .

RUN \
    find /app -type d | grep '[/][.]git$' | xargs rm -rf \
    && find /app -type f | grep '[/][.]git.*$' | xargs rm -rf


### Export #####################################################################

FROM scratch AS export

COPY --link --from=build-worker  \
    /app /worker
COPY meta /meta
