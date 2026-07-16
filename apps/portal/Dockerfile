# syntax=docker/dockerfile:1-labs

ARG BUILD_IMAGE
ARG BUILD_NPM_REGISTRY="http://0.0.0.0:4873/"

### backend ####################################################################
FROM $BUILD_IMAGE AS build-backend
ARG BUILD_IMAGE
ARG BUILD_NPM_REGISTRY

ENV NODE_VERSION="24"
WORKDIR /app



COPY --from=src-backend --exclude=**/package-lock.json . .
COPY --from=src-init index/tenant-tags.json mappings/dev/tenant-tags.json 

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    <<EORUN
        . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
        dev_npm_registry $BUILD_NPM_REGISTRY
        npm install --no-package-lock
        dev_git_cleanup /app #TODO
EORUN

### frontend ##################################################################
FROM $BUILD_IMAGE AS build-frontend
ARG BUILD_IMAGE
ARG BUILD_NPM_REGISTRY

ENV NODE_VERSION="24"
WORKDIR /app

COPY --from=src-frontend ./package.json ./package.src.json

RUN <<EORUN
    . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
    cat package.src.json \
        | jq 'del(.overrides["@oat-sa-private/ui-core"])' \
        >package.json
EORUN

COPY --from=src-frontend  --exclude=**/package.json . .

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
        npm install
        dev_git_cleanup /app #TODO
EORUN

### bootstrap ##################################################################
FROM build-frontend AS build-bootstrap

WORKDIR /app

RUN \
    --mount=type=cache,id=npm-cache,target=/root/.npm,sharing=locked \
    <<EORUN
        . /usr/local/libexec/tao-ce/hack/utils/dev.inc.sh
        npm run build:bootstrap
        dev_git_cleanup /app #TODO
EORUN

### Export #####################################################################
FROM scratch AS export

COPY --link --from=build-backend \
    /app /backend
COPY --link --from=build-bootstrap  \
    /app/server.js /bootstrap/
COPY --link --from=build-frontend     \
    /app/dist /static

COPY meta /meta
