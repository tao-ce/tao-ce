ARG TILT_VERSION=latest
ARG MANIFEST_TOOL_VERSION=latest
ARG SYFT_VERSION=latest

ARG FEDORA_VERSION=42
ARG IMAGE_NVM_VERSIONS="18,20,22"
ARG DEVCONTAINER_USERNAME="vscode"

# do not change without keeping packages.php.lst up to date
ARG IMAGE_PHP_VERSION="8.2"

# External binaries images
FROM docker.io/envoyproxy/envoy:v1.30-latest AS ext-bin-envoy
FROM docker.io/caddy:2-alpine AS ext-bin-caddy

################################################################################
FROM docker.io/golang:alpine AS build
ARG TARGETPLATFORM

RUN CGO_ENABLED=0 go install -ldflags '-extldflags "-static"' github.com/google/go-jsonnet/cmd/jsonnet@latest
RUN CGO_ENABLED=0 go install -ldflags '-extldflags "-static"' github.com/mikefarah/yq/v4@latest

################################################################################
FROM alpine/curl AS download
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

RUN apk add jq
COPY hack/utils/download-release.sh /usr/local/bin/

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

COPY build/packages.*.lst /run/context/

RUN \
    --mount=type=cache,target=/var/cache/dnf,id=dnf-cache \
    --mount=type=cache,target=/var/cache/libdnf5,id=libdnf5-cache \
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
        && echo ${IMAGE_NVM_VERSIONS} | tr , "\n" | xargs -n1 | while read v ; do nvm install $v ; done  \
        && nvm install --lts \
        && nvm use --lts \
        && nvm alias default node

################################################################################
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


################################################################################
FROM docker.io/golang:1.24-alpine AS build-go
ENV CGO_ENABLED=0

RUN apk add --no-cache gcc musl-dev

################################################################################
FROM base-fedora AS running

LABEL org.opencontainers.image.name "TAO Community Edition"
LABEL name "TAO Community Edition"
LABEL org.opencontainers.image.vendor "Open Assessment Technologies S.A."
LABEL vendor "Open Assessment Technologies S.A."
LABEL org.opencontainers.image.license "TBD"
LABEL license "TBD"
LABEL org.opencontainers.image.url "https://github.com/tao-ce/tao-ce"

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG DEVCONTAINER_USERNAME

ENV BIN_DEST=/usr/local/bin

ARG TAO_CE_OPT=/opt/tao-ce
ARG TAO_CE_ETC=/etc/tao-ce
ARG TAO_CE_LIBEXEC=/usr/local/libexec/tao-ce
ARG TAO_CE_VARLIB=/var/lib/tao-ce

ENV TAO_CE_OPT=${TAO_CE_OPT}
ENV TAO_CE_ETC=${TAO_CE_ETC}
ENV TAO_CE_LIBEXEC=${TAO_CE_LIBEXEC}
ENV TAO_CE_VARLIB=${TAO_CE_VARLIB}

VOLUME [ "${TAO_CE_VARLIB}" ]

COPY --from=ext-bin-envoy /usr/local/bin/envoy /usr/local/bin/envoy
COPY --from=ext-bin-caddy /usr/bin/caddy /usr/local/bin/caddy
COPY --link --from=build /go/bin/jsonnet   ${BIN_DEST}/jsonnet
COPY --link --from=build /go/bin/yq        ${BIN_DEST}/yq

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
    && pip install -r requirements.txt

# required for systemd
ENV container=docker
VOLUME [ "/sys/fs/cgroup", "/run", "/run/lock", "/tmp", "/workspace" ]
STOPSIGNAL SIGRTMIN+3
CMD [ "/sbin/init" ]

EXPOSE 443

################################################################################
FROM running AS monolith

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG DEVCONTAINER_USERNAME


ARG TAO_CE_OPT=/opt/tao-ce
ARG TAO_CE_ETC=/etc/tao-ce
ARG TAO_CE_LIBEXEC=/usr/local/libexec/tao-ce
ARG TAO_CE_VARLIB=/var/lib/tao-ce

ENV TAO_CE_OPT=${TAO_CE_OPT}
ENV TAO_CE_ETC=${TAO_CE_ETC}
ENV TAO_CE_LIBEXEC=${TAO_CE_LIBEXEC}
ENV TAO_CE_VARLIB=${TAO_CE_VARLIB}

COPY --link --from=tao-ce / ${TAO_CE_OPT}

RUN systemctl enable \
    ${TAO_CE_LIBEXEC}/systemd/tao-ce.target \
    ${TAO_CE_LIBEXEC}/systemd/*.service \
    ${TAO_CE_OPT}/*/meta/systemd/*.service

################################################################################
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

#workaround (stable buildah is missing --link, installing testing)
RUN dnf update -y --enablerepo=updates-testing buildah

RUN \
    useradd -G wheel ${DEVCONTAINER_USERNAME} \
    && echo '%wheel  ALL=(ALL)       NOPASSWD: ALL' | tee -a /etc/sudoers \
    && setcap cap_setuid+ep /usr/bin/newuidmap \
    && setcap cap_setgid+ep /usr/bin/newgidmap

COPY \
    --from=src-devcontainer \
    etc/ /etc/

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

COPY --chmod=4755 \
    --chown=0:0 \
    --link \
    --from=get-manifest-tool \
    /usr/local/bin/manifest-tool \
    ${BIN_DEST}/
