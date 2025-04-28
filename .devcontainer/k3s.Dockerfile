FROM  rancher/k3s:v1.32.2-k3s1 AS k3s
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG BUILDCTL_VERSION=v0.20.2

ADD https://github.com/moby/buildkit/releases/download/${BUILDCTL_VERSION}/buildkit-${BUILDCTL_VERSION}.${TARGETOS}-${TARGETARCH}.tar.gz /tmp/buildkit.tar.gz

RUN tar xzvf /tmp/buildkit.tar.gz -C /  && rm -f /tmp/buildkit.tar.gz
