ARG FEDORA_VERSION=42
# ARG FEDORA_FLAVOR=quay.io/fedora-ostree-desktops/cosmic-atomic
ARG FEDORA_FLAVOR=quay.io/fedora-ostree-desktops/kinoite
# ARG FEDORA_FLAVOR=quay.io/fedora-ostree-desktops/silverblue
ARG K3S_VERSION=v1.33.1+k3s1
ARG K8S_VERSION=v1.33.1
ARG OS_VARIANT="TAO Community Edition - Cozy"
ARG OS_VARIANT_ID="com.taotesting.cozy"

FROM golang:alpine AS go-build
ARG TARGETPLATFORM

RUN CGO_ENABLED=0 go install -ldflags '-extldflags "-static"' github.com/google/go-jsonnet/cmd/jsonnet@latest
# RUN CGO_ENABLED=0 go install -ldflags '-extldflags "-static"' github.com/mikefarah/yq/v4@latest

FROM scratch AS get-k3s-amd64
ARG K3S_VERSION
ADD --chmod=0755 \
    https://github.com/k3s-io/k3s/releases/download/${K3S_VERSION}/k3s \
    /k3s

FROM scratch AS get-k3s-arm64
ARG K3S_VERSION
ADD --chmod=0755 \
    https://github.com/k3s-io/k3s/releases/download/${K3S_VERSION}/k3s-arm64 \
    /k3s

FROM scratch AS get-kubectl
ARG K8S_VERSION
ARG TARGETPLATFORM
ADD --chmod=0755 \
    https://dl.k8s.io/release/${K8S_VERSION}/bin/${TARGETPLATFORM}/kubectl \
    /kubectl

FROM ${FEDORA_FLAVOR}:${FEDORA_VERSION} AS base

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG FEDORA_VERSION
ARG FEDORA_FLAVOR
ARG OS_VARIANT
ARG OS_VARIANT_ID

RUN dnf -y swap fedora-release generic-release --allowerasing \
    && echo 'VARIANT="${OS_VARIANT}"' >>/usr/lib/os-release \
    && echo 'VARIANT_ID="${OS_VARIANT_ID}"' >>/usr/lib/os-release

FROM scratch AS root

COPY --from=base \
    /usr/share/sddm/themes/breeze \
    /usr/share/sddm/themes/tao-ce

COPY root/ /

COPY \
    .cache/manifests/* \
        /var/lib/rancher/k3s/server/manifests/

COPY \
    .cache/assets \
        /var/lib/tao-ce/assets

COPY \
    .cache/tasks \
        /var/lib/tao-ce/tasks

COPY \
    .cache/tls/cockpit/* \
        /etc/cockpit/ws-certs.d/

COPY \
    .cache/tls/ca* \
        /var/lib/tao-ce/tls/

FROM base AS vm

LABEL org.opencontainers.image.authors="opensource-support@taotesting.com"

ARG TAO_DOMAIN="community.tao.internal"
ARG TIMEZONE="UTC"
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

COPY    --from=get-kubectl \
        --chmod=0755 \
            /kubectl \
            /usr/local/bin/kubectl

COPY    --from=get-k3s-${TARGETARCH} \
        --chmod=0755 \
            /k3s \
            /usr/local/bin/k3s

COPY    --from=go-build \
        --chmod=0755 \
            /go/bin/jsonnet \
            /usr/local/bin/jsonnet

# COPY    --from=go-build \
#         --chmod=0755 \
#             /go/bin/yq \
#             /usr/local/bin/yq

RUN \
    --mount=type=bind,from=root,target=/run/stages/root,source=/,rw \
    grep -RlF community.tao.internal /run/stages/root/ | xargs -n1 sed -ri "s@community.tao.internal@${TAO_DOMAIN}@g" \
    && cp -r --preserve=mode,timestamps /run/stages/root/* /

RUN \
    --mount=type=cache,id=dnf-cache,target=/var/cache/dnf \
    --mount=type=cache,id=libdnf-cache,target=/var/cache/libdnf5 \
    --mount=type=bind,target=/run/context/packages.lst,source=config/packages.lst \
    cat /run/context/packages.lst \
        | grep -v '^#' \
        | grep -v '^[ ]*$' \
        | xargs \
            dnf \
                --setopt=install_weak_deps=false \
                install -y

RUN \
    --mount=type=bind,target=/run/context/images.lst,source=config/images.lst \
    cat /run/context/images.lst \
        | grep -v '^#' \
        | grep -v '^[ ]*$' \
        | xargs -n1 \
            podman pull

RUN trust anchor /var/lib/tao-ce/tls/ca.crt \
    && ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && systemctl enable \
        k3s.service \
        k3s-cleanup.service \
        sshd.service \
    && dnf clean all
