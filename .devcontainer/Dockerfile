
ARG KUSTOMIZE_VERSION=v5.6.0
ARG KUBE_VERSION=v1.33.1
ARG K9S_VERSION=latest
ARG ISTIO_VERSION=latest
ARG HELM_VERSION=v3.17.1
ARG KREW_VERSION=latest
ARG TILT_VERSION=latest
ARG NERDCTL_VERSION=latest
ARG MANIFEST_TOOL_VERSION=latest
ARG BUILDCTL_VERSION=latest
ARG SYFT_VERSION=latest

# ARG KUSTOMIZE_VERSION=v5.6.0
# ARG KUBE_VERSION=v1.33.1
# ARG K9S_VERSION=v0.50.8
# ARG ISTIO_VERSION=1.25.0
# ARG HELM_VERSION=v3.17.1
# ARG KREW_VERSION=v0.4.4
# ARG TILT_VERSION=v0.34.0
# ARG NERDCTL_VERSION=v2.0.4
# ARG BUILDCTL_VERSION=v0.20.2
ARG UBUNTU_VERSION=noble
ARG FEDORA_VERSION=42
ARG DEVCONTAINER_FLAVOR=fedora

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


FROM download AS get-kustomize
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG KUSTOMIZE_VERSION

RUN \
    --mount=type=cache,target=/run/cache/github/releases,id=github-releases,sharing=shared \
    /usr/local/bin/download-release.sh \
        kubernetes-sigs/kustomize \
        kustomize_@@STRIPSLASHVERSION@@_${TARGETOS}_${TARGETARCH}.tar.gz \
        kustomize/${KUSTOMIZE_VERSION} ;\
    cd /tmp \
        && tar xzf $(cat /run/tmp/last-download) \
        && mv /tmp/kustomize /usr/local/bin/kustomize

################################################################################
FROM download AS get-k9s
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG K9S_VERSION

RUN \
    --mount=type=cache,target=/run/cache/github/releases,id=github-releases,sharing=shared \
    /usr/local/bin/download-release.sh \
        derailed/k9s \
        k9s_${TARGETOS}_${TARGETARCH}.tar.gz \
        ${K9S_VERSION} ;\
    cd /tmp \
        && tar xzf $(cat /run/tmp/last-download) \
        && mv /tmp/k9s /usr/local/bin/k9s

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
FROM download AS get-istioctl
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG ISTIO_VERSION

RUN \
    --mount=type=cache,target=/run/cache/github/releases,id=github-releases,sharing=shared \
    /usr/local/bin/download-release.sh \
        istio/istio \
        istio-@@STRIPVERSION@@-${TARGETOS}-${TARGETARCH}.tar.gz \
        ${ISTIO_VERSION} ;\
    cd /tmp \
        && tar xzf $(cat /run/tmp/last-download) \
        && mv /tmp/istio-$(cat /run/tmp/version)/bin/istioctl /usr/local/bin/istioctl

# RUN cd /tmp \
#     && curl -L https://istio.io/downloadIstio | sh - \
#     && mv /tmp/istio-${ISTIO_VERSION}/bin/istioctl /usr/local/bin/istioctl

################################################################################
# FROM download AS get-helm
# ARG TARGETPLATFORM
# ARG TARGETOS
# ARG TARGETARCH
# ARG HELM_VERSION


# RUN cd /tmp \
#     && curl -fsSL \
#         https://get.helm.sh/helm-${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz \
#         | tar xz \
#     && mv /tmp/${TARGETOS}-${TARGETARCH}/helm /usr/local/bin/helm

################################################################################
FROM download AS get-krew
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG KREW_VERSION

RUN \
    --mount=type=cache,target=/run/cache/github/releases,id=github-releases,sharing=shared \
    /usr/local/bin/download-release.sh kubernetes-sigs/krew krew-${TARGETOS}_${TARGETARCH}.tar.gz ${KREW_VERSION} ;\
    cd /tmp \
        && tar xzf $(cat /run/tmp/last-download) \
        && mv /tmp/krew-${TARGETOS}_${TARGETARCH} /usr/local/bin/krew

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
FROM download AS get-nerdctl
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG NERDCTL_VERSION

RUN \
    --mount=type=cache,target=/run/cache/github/releases,id=github-releases,sharing=shared \
    /usr/local/bin/download-release.sh \
        containerd/nerdctl \
        nerdctl-@@STRIPVERSION@@-${TARGETOS}-${TARGETARCH}.tar.gz \
        ${NERDCTL_VERSION} \
        ; \
    cd /tmp \
        && tar xzf $(cat /run/tmp/last-download) \
        && mv /tmp/nerdctl /usr/local/bin/nerdctl

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
FROM download AS get-buildctl
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG BUILDCTL_VERSION

RUN \
    --mount=type=cache,target=/run/cache/github/releases,id=github-releases,sharing=shared \
    /usr/local/bin/download-release.sh \
        moby/buildkit \
        buildkit-@@VERSION@@.${TARGETOS}-${TARGETARCH}.tar.gz \
        ${BUILDCTL_VERSION} \
        ;\
    cd /tmp \
        && tar xzf $(cat /run/tmp/last-download) \
        && mv /tmp/bin/* /usr/local/bin/

################################################################################
FROM fedora:${FEDORA_VERSION} AS base-fedora

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG FEDORA_VERSION
ARG FEDORA_FLAVOR

ARG USERNAME="vscode"
ENV USERNAME="${USERNAME}"

COPY root/ /

RUN \
    --mount=type=cache,target=/var/cache/dnf,id=dnf-cache \
    --mount=type=cache,target=/var/cache/libdnf5,id=libdnf5-cache \
    --mount=type=bind,target=/run/context,source=. \
    grep -v '^#' /run/context/packages.lst \
        | xargs dnf --setopt=install_weak_deps=false install -y \
    && useradd -G wheel ${USERNAME} \
    && echo '%wheel  ALL=(ALL)       NOPASSWD: ALL' | tee -a /etc/sudoers
    # && dnf clean all


ENV SET_X=1

################################################################################
FROM base-fedora AS devcontainer

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG KUSTOMIZE_VERSION
ARG KUBE_VERSION
ARG K9S_VERSION

ENV BIN_DEST=/usr/local/bin

COPY --link --from=build /go/bin/jsonnet   ${BIN_DEST}/jsonnet
COPY --link --from=build /go/bin/yq        ${BIN_DEST}/yq

ADD --chmod=0755 \
    --link \
    https://dl.k8s.io/release/${KUBE_VERSION}/bin/${TARGETPLATFORM}/kubectl \
    ${BIN_DEST}/kubectl

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
    /usr/local/bin/kustomize \
    ${BIN_DEST}/kustomize 


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
    --from=get-nerdctl \
    /usr/local/bin/nerdctl \
    ${BIN_DEST}/nerdctl
        
COPY --chmod=4755 \
    --chown=0:0 \
    --link \
    --from=get-buildctl \
    /usr/local/bin/buildctl \
    ${BIN_DEST}/

COPY --chmod=4755 \
    --chown=0:0 \
    --link \
    --from=get-manifest-tool \
    /usr/local/bin/manifest-tool \
    ${BIN_DEST}/
    
COPY \
    --link \
    --chmod=0755 \
    --from=get-k9s \
    /usr/local/bin/* \
    ${BIN_DEST}/k9s

USER vscode
ENV PATH="$PATH:$BIN_DEST:/home/vscode/.krew/bin"

RUN \
    krew index add \
        default https://github.com/kubernetes-sigs/krew-index.git \
    && krew update \
    && grep -v '^#' <<EOF | xargs -n1 krew install || true
ctx
ns
sniff
stern
get-all
graph
grep
history
ktop
EOF

WORKDIR /workspace

ENTRYPOINT ["/bin/bash"]
CMD ["/usr/local/libexec/devcontainer/entrypoint"]

