# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM="/usr/local/libexec/nvm/nvm-exec npm"

### worker #####################################################################
FROM $BUILD_IMAGE AS build-worker
ARG BUILD_IMAGE
ARG BUILD_NPM

ENV NODE_VERSION="18"
WORKDIR /app

COPY --from=src-worker package*.json ./

RUN ${BUILD_NPM} install

COPY --from=src-worker . .

### Export #####################################################################

FROM scratch AS export

COPY --link --from=build-worker  \
    --exclude="**/.git*" \
    /app /worker