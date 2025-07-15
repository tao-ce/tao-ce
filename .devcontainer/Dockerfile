
ARG KUSTOMIZE_VERSION=v5.6.0
ARG KUBE_VERSION=v1.32.2
ARG SKAFFOLD_VERSION=latest
ARG ZARF_VERSION=v0.49.1
ARG K3D_VERSION=v5.8.3
ARG KIND_VERSION=v0.27.0
ARG MINIKUBE_VERSION=v1.35.0
ARG K9S_VERSION=v0.40.10
ARG ISTIO_VERSION=1.25.0
ARG HELM_VERSION=v3.17.1
ARG KREW_VERSION=v0.4.4
ARG DIVE_VERSION=latest
ARG TALOSCTL_VERSION=v1.9.5
ARG TILT_VERSION=0.34.0
ARG NERDCTL_VERSION=2.0.4
ARG BUILDCTL_VERSION=v0.20.2
ARG UBUNTU_VERSION=noble
ARG FEDORA_VERSION=42
ARG FEDORA_FLAVOR=devcontainer-fedora-base
ARG DEVCONTAINER_FLAVOR=fedora


FROM golang:alpine AS build
ARG TARGETPLATFORM

RUN CGO_ENABLED=0 go install -ldflags '-extldflags "-static"' github.com/google/go-jsonnet/cmd/jsonnet@latest
RUN CGO_ENABLED=0 go install -ldflags '-extldflags "-static"' github.com/mikefarah/yq/v4@latest

ARG KUSTOMIZE_VERSION
FROM registry.k8s.io/kustomize/kustomize:${KUSTOMIZE_VERSION} AS get-kustomize
ARG K9S_VERSION
FROM quay.io/derailed/k9s:${K9S_VERSION} AS get-k9s
ARG DIVE_VERSION
FROM ghcr.io/wagoodman/dive:${DIVE_VERSION} AS get-dive

FROM lscr.io/linuxserver/ungoogled-chromium:latest AS get-ungoogled-chromium

FROM alpine/curl AS get-istioctl
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ENV TARGET_ARCH=${TARGETARCH}
ARG ISTIO_VERSION

RUN cd /tmp \
    && curl -L https://istio.io/downloadIstio | sh - \
    && mv /tmp/istio-${ISTIO_VERSION}/bin/istioctl /usr/local/bin/istioctl

FROM alpine/curl AS get-helm
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG HELM_VERSION

RUN cd /tmp \
    && curl -fsSL \
        https://get.helm.sh/helm-${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz \
        | tar xz \
    && mv /tmp/${TARGETOS}-${TARGETARCH}/helm /usr/local/bin/helm



FROM alpine/curl AS get-krew
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG KREW_VERSION


RUN cd /tmp \
    && curl -fsSL \
        https://github.com/kubernetes-sigs/krew/releases/download/${KREW_VERSION}/krew-${TARGETOS}_${TARGETARCH}.tar.gz \
        | tar xz \
    && mv /tmp/krew-${TARGETOS}_${TARGETARCH} /usr/local/bin/krew


FROM alpine/curl AS get-tilt
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TILT_VERSION

RUN cd /tmp \
    && case ${TARGETARCH} in amd64) TARGET_ARCH=x86_64 ;; *) TARGET_ARCH=${TARGETARCH} ;; esac \
    && curl -fsSL \
        https://github.com/tilt-dev/tilt/releases/download/v${TILT_VERSION}/tilt.${TILT_VERSION}.${TARGETOS}.${TARGET_ARCH}.tar.gz \
        | tar xz \
    && mv /tmp/tilt /usr/local/bin/tilt
    
FROM alpine/curl AS get-nerdctl
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG NERDCTL_VERSION

RUN cd /tmp \
    && curl -fsSL \
        https://github.com/containerd/nerdctl/releases/download/v${NERDCTL_VERSION}/nerdctl-${NERDCTL_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz \
        | tar xz \
    && mv /tmp/nerdctl /usr/local/bin/nerdctl

    
FROM alpine/curl AS get-buildctl
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG BUILDCTL_VERSION

RUN cd /tmp \
    && curl -fsSL \
        https://github.com/moby/buildkit/releases/download/${BUILDCTL_VERSION}/buildkit-${BUILDCTL_VERSION}.${TARGETOS}-${TARGETARCH}.tar.gz \
        | tar xz \
    && mv /tmp/bin/* /usr/local/bin/


FROM mcr.microsoft.com/devcontainers/base:${UBUNTU_VERSION} AS devcontainer-ubuntu

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG UBUNTU_VERSION

ENV BIN_DEST=/usr/local/bin

ADD --chmod=0644 https://packages.mozilla.org/apt/repo-signing-key.gpg /etc/apt/keyrings/packages.mozilla.org.asc
COPY ./container/apt/mozilla.list /etc/apt/sources.list.d/mozilla.list
COPY ./container/apt/mozilla.preferences /etc/apt/preferences.d/mozilla

RUN sudo apt update \
    && sudo apt-get install \
        -y --no-install-recommends  \
            dnsutils \
            iputils-ping \
            netcat-traditional \
            ca-certificates \
            curl \
            pre-commit \
            skopeo \
            xdg-utils \
            libatk1.0-0 \
            libatk-bridge2.0-0 \
            libcups2 \
            libnss3 \
            libxcomposite1 \
            libxdamage1 \
            libxkbcommon0 \
            thunar \
            xz-utils \
            firefox-devedition/mozilla \
    && rm -rf /var/lib/apt/lists/*

FROM fedora:${FEDORA_VERSION} as devcontainer-fedora-base

FROM ${FEDORA_FLAVOR} AS devcontainer-fedora

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG FEDORA_VERSION
ARG FEDORA_FLAVOR

ARG USERNAME="vscode"
ENV USERNAME="${USERNAME}"

RUN dnf --setopt=install_weak_deps=false install -y \
        make \
        vim \
        patch \
        btop \
        iptables-legacy \
        netcat \
        git \
        firefox \
        curl \
        dnsutils \
        skopeo \
        pre-commit \
        xdg-utils \
        openssl \
        jq \
        yq \
        podman \
    && useradd -G wheel ${USERNAME} \
    && echo '%wheel  ALL=(ALL)       NOPASSWD: ALL' | tee -a /etc/sudoers \
    && dnf clean all

ENV SET_X=1


FROM devcontainer-fedora AS vm

FROM devcontainer-${DEVCONTAINER_FLAVOR} AS devcontainer

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG KUSTOMIZE_VERSION
ARG KUBE_VERSION
ARG SKAFFOLD_VERSION
ARG ZARF_VERSION
ARG K3D_VERSION
ARG KIND_VERSION
ARG MINIKUBE_VERSION
ARG K9S_VERSION
ARG TALOSCTL_VERSION

ENV BIN_DEST=/usr/local/bin

COPY --link --from=build /go/bin/jsonnet   ${BIN_DEST}/jsonnet
COPY --link --from=build /go/bin/yq        ${BIN_DEST}/yq

ADD --chmod=0755 \
    --link \
    https://dl.k8s.io/release/${KUBE_VERSION}/bin/${TARGETPLATFORM}/kubectl \
    ${BIN_DEST}/kubectl
# ADD --chmod=0755 \
#     --link \
#     https://storage.googleapis.com/skaffold/releases/${SKAFFOLD_VERSION}/skaffold-${TARGETOS}-${TARGETARCH} \
#     ${BIN_DEST}/skaffold
# ADD --chmod=0755 \
#     --link \
#     https://github.com/zarf-dev/zarf/releases/download/${ZARF_VERSION}/zarf_${ZARF_VERSION}_${TARGETOS}_${TARGETARCH} \
#     ${BIN_DEST}/zarf
# ADD --chmod=0755 \
#     --link \
#     https://github.com/k3d-io/k3d/releases/download/${K3D_VERSION}/k3d-${TARGETOS}-${TARGETARCH} \
#     ${BIN_DEST}/k3d
# ADD --chmod=0755 \
#     --link \
#     https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-${TARGETOS}-${TARGETARCH} \
#     ${BIN_DEST}/kind
# ADD --chmod=0755 \
#     --link \
#     https://github.com/kubernetes/minikube/releases/download/${MINIKUBE_VERSION}/minikube-${TARGETOS}-${TARGETARCH} \
#     ${BIN_DEST}/minikube

# ADD --chmod=0755 \
#     --link \
#     https://github.com/siderolabs/talos/releases/download/${TALOSCTL_VERSION}/talosctl-${TARGETOS}-${TARGETARCH} \
#     ${BIN_DEST}/talosctl

COPY \
    --link \
    --chmod=0755 \
    --from=get-helm \
    /usr/local/bin/helm \
    ${BIN_DEST}/helm

COPY \
    --link \
    --chmod=0755 \
    --from=get-krew \
    /usr/local/bin/krew \
    ${BIN_DEST}/krew

COPY \
    --link \
    --chmod=0755 \
    --from=get-istioctl \
    /usr/local/bin/istioctl \
    ${BIN_DEST}/istioctl

COPY \
    --link \
    --chmod=0755 \
    --from=get-kustomize \
    /app/kustomize \
    ${BIN_DEST}/kustomize 

COPY --chmod=0755 \
    --link \
    --from=get-tilt \
    /usr/local/bin/tilt \
    ${BIN_DEST}/tilt


COPY --chmod=4755 \
    --link \
    --from=get-nerdctl \
    /usr/local/bin/nerdctl \
    ${BIN_DEST}/nerdctl
        
COPY --chmod=4755 \
    --link \
    --from=get-buildctl \
    /usr/local/bin/* \
    ${BIN_DEST}/
        
COPY \
    --link \
    --chmod=0755 \
    --from=get-k9s \
    /bin/k9s \
    ${BIN_DEST}/k9s

# COPY \
#     --link \
#     --chmod=0755 \
#     --from=ghcr.io/blue-build/cli:latest-installer \
#     /out/bluebuild \
#     ${BIN_DEST}/bluebuild

# COPY --from=get-dive --chmod=0755 \
#     --link \
#     /usr/local/bin/dive \
#     ${BIN_DEST}/dive
USER vscode
ENV PATH="$PATH:$BIN_DEST:/home/vscode/.krew/bin"

RUN \
    krew index add \
        default https://github.com/kubernetes-sigs/krew-index.git \
    # && krew index add \
        # kubevpn https://github.com/kubenetworks/kubevpn.git \
    && krew update \
    && grep -v '^#' <<EOF | xargs -n1 krew install
ctx
ns
sniff
stern
get-all
graph
grep
history
ktop
# oomd
# kubevpn/kubevpn
EOF

COPY ./container/mozilla/policies.json /etc/firefox/policies/policies.json

ENTRYPOINT ["/usr/bin/sleep", "infinity"]

