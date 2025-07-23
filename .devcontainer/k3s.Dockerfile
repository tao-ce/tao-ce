ARG K3S_VERSION=v1.33.1-k3s1
ARG BUILDCTL_VERSION=v0.20.2

FROM  rancher/k3s:${K3S_VERSION} AS k3s
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

ARG BUILDCTL_VERSION
ADD https://github.com/moby/buildkit/releases/download/${BUILDCTL_VERSION}/buildkit-${BUILDCTL_VERSION}.${TARGETOS}-${TARGETARCH}.tar.gz /tmp/buildkit.tar.gz

RUN tar xzvf /tmp/buildkit.tar.gz -C /  && rm -f /tmp/buildkit.tar.gz
