
ARG TILT_VERSION=latest
ARG MANIFEST_TOOL_VERSION=latest
ARG SYFT_VERSION=latest

ARG FEDORA_VERSION=42
ARG DEVCONTAINER_FLAVOR=fedora
ARG IMAGE_NVM_VERSIONS="18 20 22"
ARG DEVCONTAINER_USERNAME="vscode"

# do not change without keeping packages.php.lst up to date
ARG IMAGE_PHP_VERSION="8.2"

################################################################################
FROM golang:alpine AS build
ARG TARGETPLATFORM

RUN CGO_ENABLED=0 go install -ldflags '-extldflags "-static"' github.com/google/go-jsonnet/cmd/jsonnet@latest
RUN CGO_ENABLED=0 go install -ldflags '-extldflags "-static"' github.com/mikefarah/yq/v4@latest

FROM alpine/curl AS download
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

RUN apk add jq
COPY utils/download-release.sh /usr/local/bin/

################################################################################
FROM download AS get-manifest-tool
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG MANIFEST_TOOL_VERSION

RUN \
    --mount=type=cache,target=/run/cache/github/releases,id=github-releases,sharing=shared \
    /usr/local/bin/download-release.sh \
        estesp/manifest-tool \
        binaries-manifest-tool-@@STRIPVERSION@@.tar.gz \
        ${MANIFEST_TOOL_VERSION} ;\
    cd /tmp \
        && tar xzf $(cat /run/tmp/last-download) \
        && mv /tmp/manifest-tool-linux-${TARGETARCH} /usr/local/bin/manifest-tool


################################################################################
FROM download AS get-bldr
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG BLDR_VERSION="latest"

RUN \
    --mount=type=cache,target=/run/cache/github/releases,id=github-releases,sharing=shared \
    /usr/local/bin/download-release.sh \
        siderolabs/bldr \
        bldr-linux-${TARGETARCH} \
        ${BLDR_VERSION} ;\
    cd /tmp \
        && cp -a $(cat /run/tmp/last-download) /usr/local/bin/bldr

################################################################################
FROM download AS get-tilt
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TILT_VERSION="latest"

RUN \
    --mount=type=cache,target=/run/cache/github/releases,id=github-releases,sharing=shared \
    case ${TARGETARCH} in amd64) TARGET_ARCH=x86_64 ;; *) TARGET_ARCH=${TARGETARCH} ;; esac \
    && /usr/local/bin/download-release.sh \
        tilt-dev/tilt \
        tilt.@@STRIPVERSION@@.${TARGETOS}.${TARGET_ARCH}.tar.gz \
        ${TILT_VERSION} \
        ; \
    cd /tmp \
        && tar xzf $(cat /run/tmp/last-download) \
        && mv /tmp/tilt /usr/local/bin/tilt
    
################################################################################
FROM download AS get-syft
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG SYFT_VERSION

RUN \
    --mount=type=cache,target=/run/cache/github/releases,id=github-releases,sharing=shared \
    /usr/local/bin/download-release.sh \
        anchore/syft \
        syft_@@STRIPVERSION@@_${TARGETOS}_${TARGETARCH}.tar.gz \
        ${SYFT_VERSION} \
        ; \
    cd /tmp \
        && tar xzf $(cat /run/tmp/last-download) \
        && mv /tmp/syft /usr/local/bin/syft

    
    
################################################################################
FROM fedora:${FEDORA_VERSION} AS base-fedora

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG FEDORA_VERSION
ARG FEDORA_FLAVOR
ARG IMAGE_PHP_VERSION
ARG IMAGE_NVM_VERSIONS

ENV NVM_DIR=/usr/local/libexec/nvm

RUN \
    --mount=type=cache,target=/var/cache/dnf,id=dnf-cache \
    --mount=type=cache,target=/var/cache/libdnf5,id=libdnf5-cache \
    --mount=type=bind,target=/run/context,source=. \
    set -a \
    && . /etc/os-release \
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
    && mkdir -p ${NVM_DIR} && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | PROFILE="/etc/profile.d/" bash \
    && . ${NVM_DIR}/nvm.sh \
        && echo ${IMAGE_NVM_VERSIONS} | xargs -n1 | while read v ; do nvm install $v ; done  \
        && nvm install --lts \
        && nvm use --lts \
        && nvm alias default node

FROM base-fedora AS build-fedora

RUN \
    --mount=type=cache,target=/var/cache/dnf,id=dnf-cache \
    --mount=type=cache,target=/var/cache/libdnf5,id=libdnf5-cache \
    --mount=type=bind,target=/run/context,source=. \
    cat \
            /run/context/packages.build.lst \
        | grep -v '^#' \
        | sed \
            -e "s/@@ARCH@@/$(uname -m)/g" \
        | xargs dnf install -y \
    && mkdir -p /etc/ssh && ssh-keyscan -H github.com >>/etc/ssh/ssh_known_hosts

################################################################################
FROM build-fedora AS devcontainer

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG DEVCONTAINER_USERNAME

ENV BIN_DEST=/usr/local/bin
ENV DEVCONTAINER_USERNAME="${DEVCONTAINER_USERNAME}"

COPY --link --from=build /go/bin/jsonnet   ${BIN_DEST}/jsonnet
COPY --link --from=build /go/bin/yq        ${BIN_DEST}/yq

RUN \
    --mount=type=cache,target=/var/cache/dnf,id=dnf-cache \
    --mount=type=cache,target=/var/cache/libdnf5,id=libdnf5-cache \
    --mount=type=bind,target=/run/context,source=. \
    cat \
            /run/context/packages.dev.lst \
        | grep -v '^#' \
        | sed \
            -e "s/@@ARCH@@/$(uname -m)/g" \
        | xargs dnf install -y --setopt=install_weak_deps=false


RUN \
    useradd -G wheel ${DEVCONTAINER_USERNAME} \
    && echo '%wheel  ALL=(ALL)       NOPASSWD: ALL' | tee -a /etc/sudoers

COPY --chmod=4755 \
    --chown=0:0 \
    --link \
    --from=get-syft \
    /usr/local/bin/syft \
    ${BIN_DEST}/syft

COPY --chmod=0755 \
    --link \
    --from=get-tilt \
    /usr/local/bin/tilt \
    ${BIN_DEST}/tilt

COPY --chmod=0755 \
    --link \
    --from=get-bldr \
    /usr/local/bin/bldr \
    ${BIN_DEST}/

COPY --chmod=4755 \
    --chown=0:0 \
    --link \
    --from=get-manifest-tool \
    /usr/local/bin/manifest-tool \
    ${BIN_DEST}/

# COPY ./root/ /

# RUN systemctl enable buildkit.socket buildkit.service

# required for systemd
ENV container=docker
VOLUME [ "/sys/fs/cgroup", "/run", "/run/lock", "/tmp", "/workspace" ]
STOPSIGNAL SIGRTMIN+3
CMD [ "/sbin/init" ]
