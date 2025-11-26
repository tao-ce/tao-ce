ARG BUILD_IMAGE
###############################################################################
FROM $BUILD_IMAGE AS build-live-design-system
ARG BUILD_IMAGE

ENV NODE_VERSION="22"
WORKDIR /app

COPY live-design-system /app

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
        . /usr/local/libexec/nvm/nvm.sh \
        && npm install \
        && npm run build

###############################################################################
FROM scratch AS export

COPY --from=build-live-design-system /app /live-design-system