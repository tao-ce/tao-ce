
ARG FEDORA_IMAGE=fedora
ARG FEDORA_VERSION=43
ARG IMAGE_NVM_VERSIONS="24"
ARG NODE_VERSION="24"
ARG DEVCONTAINER_USERNAME="vscode"

# do not change without keeping packages.php.lst up to date
ARG IMAGE_PHP_VERSION="8.4"

# External binaries images
FROM docker.io/envoyproxy/envoy:v1.36-latest AS ext-bin-envoy
FROM docker.io/caddy:2-alpine AS ext-bin-caddy
FROM ghcr.io/goss-org/goss:v0.4.10 AS ext-bin-goss
FROM ghcr.io/anchore/syft:v1.50.0 AS ext-bin-syft

FROM docker.io/golang:1.26-alpine AS build-go
ENV CGO_ENABLED=0
ARG GOCACHE=/go-cache
ENV GOCACHE=${GOCACHE}
ARG GOMODCACHE=/gomod-cache
ENV GOMODCACHE=${GOMODCACHE}

RUN apk add --no-cache gcc musl-dev

FROM build-go AS go-jsonnet-build
ARG TARGETPLATFORM
RUN \
    --mount=type=cache,id=go-cache,target=${GOCACHE} --mount=type=cache,id=gomod-cache,target=${GOMODCACHE} \
        go install -ldflags '-extldflags "-static"' \
        github.com/google/go-jsonnet/cmd/jsonnet@latest

FROM build-go AS go-jsonnetfmt-build
ARG TARGETPLATFORM
RUN \
    --mount=type=cache,id=go-cache,target=${GOCACHE} --mount=type=cache,id=gomod-cache,target=${GOMODCACHE} \
        go install -ldflags '-extldflags "-static"' \
        github.com/google/go-jsonnet/cmd/jsonnetfmt@latest

FROM build-go AS go-logdy-build
ARG TARGETPLATFORM
RUN \
    --mount=type=cache,id=go-cache,target=${GOCACHE} --mount=type=cache,id=gomod-cache,target=${GOMODCACHE} \
        go install -ldflags '-extldflags "-static"' \
        github.com/logdyhq/logdy-core@main

 ###############################################################################
FROM ${FEDORA_IMAGE}:${FEDORA_VERSION} AS base-fedora

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG FEDORA_VERSION
ARG FEDORA_IMAGE
ARG IMAGE_PHP_VERSION
ARG IMAGE_NVM_VERSIONS

ENV NVM_DIR=/usr/local/libexec/nvm

COPY build/packages.*.lst /run/context/

RUN \
    --mount=type=cache,target=/var/cache/dnf,id=dnf-cache \
    --mount=type=cache,target=/var/cache/libdnf5,id=libdnf5-cache \
    set -a \
    && mkdir -p /var/opt /var/lib /var/usrlocal /var/tmp \
    && . /etc/os-release \
    && dnf install -y python3-dnf-plugin-versionlock \
    && dnf install -y https://rpms.remirepo.net/${ID}/remi-release-${VERSION_ID}.rpm \
    && dnf config-manager setopt remi.enabled=1 \
    && dnf module reset -y php \
    && dnf module enable -y php:remi-${IMAGE_PHP_VERSION} \
    && cat \
            /run/context/packages.php.lst \
        | grep -v '^#' \
        | sed \
            -e "s/@@ARCH@@/$(uname -m)/g" \
        | xargs dnf install -y \
    && dnf  versionlock add php* \
    && mkdir -p ${NVM_DIR} && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | PROFILE="/etc/profile.d/" bash \
    && . ${NVM_DIR}/nvm.sh \
        && echo ${IMAGE_NVM_VERSIONS} | tr , "\n" | xargs -n1 | while read v ; do nvm install $v ; done  \
        && nvm install --lts \
        && nvm use --lts \
        && nvm alias default node \
    && mkdir -p /opt/xlsx2csv \
        && python3 -m venv /opt/xlsx2csv/venv \
        && /opt/xlsx2csv/venv/bin/pip install --no-cache-dir xlsx2csv

 ###############################################################################
FROM base-fedora AS build-base

COPY build/packages.*.lst /run/context/

RUN \
    --mount=type=cache,target=/var/cache/dnf,id=dnf-cache \
    --mount=type=cache,target=/var/cache/libdnf5,id=libdnf5-cache \
    cat \
            /run/context/packages.build.lst \
        | grep -v '^#' \
        | sed \
            -e "s/@@ARCH@@/$(uname -m)/g" \
        | xargs dnf install -y \
    && mkdir -p /etc/ssh && ssh-keyscan -H github.com >>/etc/ssh/ssh_known_hosts

 ###############################################################################
FROM base-fedora AS running

LABEL org.opencontainers.image.name="TAO Community Edition"
LABEL name="TAO Community Edition"
LABEL org.opencontainers.image.vendor="Open Assessment Technologies S.A."
LABEL vendor="Open Assessment Technologies S.A."
LABEL org.opencontainers.image.licenses="AGPL-3.0"
LABEL licenses="AGPL-3.0"
LABEL org.opencontainers.image.url="https://github.com/tao-ce/tao-ce"
LABEL org.opencontainers.image.authors="opensource-support@taotesting.com"
LABEL maintainer="opensource-support@taotesting.com"

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG DEVCONTAINER_USERNAME
ARG NODE_VERSION

ENV BIN_DEST=/usr/local/bin

ARG TAO_CE_OPT=/opt/tao-ce
ARG TAO_CE_ETC=/etc/tao-ce
ARG TAO_CE_LIBEXEC=/usr/local/libexec/tao-ce
ARG TAO_CE_VARLIB=/var/lib/tao-ce
ARG TAO_CE_MNT=/mnt/tao-ce

ENV TAO_CE_OPT=${TAO_CE_OPT}
ENV TAO_CE_ETC=${TAO_CE_ETC}
ENV TAO_CE_LIBEXEC=${TAO_CE_LIBEXEC}
ENV TAO_CE_VARLIB=${TAO_CE_VARLIB}
ENV TAO_CE_MNT=${TAO_CE_MNT}
ENV NODE_VERSION=${NODE_VERSION}

VOLUME [ "${TAO_CE_VARLIB}" ]
VOLUME [ "${TAO_CE_MNT}" ]

COPY ./libexec      ${TAO_CE_LIBEXEC}
COPY ./etc/         /etc/

COPY build/packages.*.lst /run/context/

RUN \
    --mount=type=cache,target=/var/cache/dnf,id=dnf-cache \
    --mount=type=cache,target=/var/cache/libdnf5,id=libdnf5-cache \
    env > /etc/environment \
    && authselect opt-out \
    && sed -i -e 's/^hosts:.*/hosts: files dns/' /etc/nsswitch.conf \ 
    && cat \
            /run/context/packages.run.lst \
        | grep -v '^#' \
        | sed \
            -e "s/@@ARCH@@/$(uname -m)/g" \
        | xargs dnf install -y --setopt=install_weak_deps=false \
    && cd ${TAO_CE_LIBEXEC}/pubsub \
    && python3 -m venv .venv \
    && . .venv/bin/activate \
    && pip install -r requirements.txt \
    && systemctl mask \
        systemd-rfkill.service \
        console-getty.service \
        systemd-udevd.service \
        systemd-initctl.service \
        rc-local.service \
        systemd-bsod.service \
        pcscd.service \
        rescue.service \
        emergency.service \
        getty.target

COPY --link --from=ext-bin-envoy /usr/local/bin/envoy ${BIN_DEST}/envoy
COPY --link --from=ext-bin-caddy /usr/bin/caddy ${BIN_DEST}/caddy
COPY --link --from=ext-bin-goss /usr/bin/goss ${BIN_DEST}/goss
COPY --link --from=go-jsonnet-build /go/bin/jsonnet ${BIN_DEST}/jsonnet

# required for systemd
ENV container=docker
STOPSIGNAL SIGRTMIN+3
CMD [ "/sbin/init" ]

EXPOSE 443
HEALTHCHECK \
    --interval=10s \
    --timeout=10s \
    --start-period=10s \
    --retries=3 \
    CMD curl -f http://localhost:28080 || exit 1

 ###############################################################################
FROM running AS devcontainer

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG DEVCONTAINER_USERNAME

ENV BIN_DEST=/usr/local/bin
ENV DEVCONTAINER_USERNAME="${DEVCONTAINER_USERNAME}"

COPY build/packages.*.lst /run/context/

RUN \
    --mount=type=cache,target=/var/cache/dnf,id=dnf-cache \
    --mount=type=cache,target=/var/cache/libdnf5,id=libdnf5-cache \
    cat \
            /run/context/packages.dev.lst \
        | grep -v '^#' \
        | sed \
            -e "s/@@ARCH@@/$(uname -m)/g" \
        | xargs dnf install -y --setopt=install_weak_deps=false

COPY --link --from=go-jsonnetfmt-build /go/bin/jsonnetfmt ${BIN_DEST}/jsonnetfmt
COPY --link --from=go-logdy-build /go/bin/logdy-core ${BIN_DEST}/logdy

RUN \
    useradd -G wheel ${DEVCONTAINER_USERNAME} \
    && echo '%wheel  ALL=(ALL)       NOPASSWD: ALL' | tee -a /etc/sudoers \
    && setcap cap_setuid+ep /usr/bin/newuidmap \
    && setcap cap_setgid+ep /usr/bin/newgidmap

COPY \
    --from=src-devcontainer \
    etc/ /etc/

VOLUME [ "/workspace" ]
