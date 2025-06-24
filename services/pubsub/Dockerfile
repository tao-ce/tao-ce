FROM alpine/curl AS build-deltio-src

RUN mkdir /src && cd /tmp \
    && curl -fsSL \
        \https://github.com/jeffijoe/deltio/archive/refs/tags/v0.6.0.tar.gz \
        | tar xz \
    && mv /tmp/deltio-*/proto /src/

FROM fullstorydev/grpcurl AS grpcurl

FROM alpine/curl AS export

RUN apk add jq

COPY --from=build-deltio-src /src/proto /src/proto
COPY --from=grpcurl /bin/grpcurl /bin/grpcurl
COPY --chmod=0755 ./grpc-wrapper.sh /bin/grpcurl-wrapper
COPY --chmod=0755 ./pubsub.sh /bin/pubsub-cli

ENV GRPC_ARGS=""
ENV GRPC_ENDPOINT="0.0.0.0:8432"
ENV PUBSUB_PROJECT_ID="emulator-project"

ENTRYPOINT [ "/bin/pubsub-cli" ]

# ENTRYPOINT [ "/bin/grpcurl", "-import-path", "/src/proto/googleapis", "-proto", "google/pubsub/v1/pubsub.proto" ]

# docker run --network=neo-tao-ce-net -v /home/geo/repos/ce/tao-ce/apps/deliver/src/foo/src:/src  -it fullstorydev/grpcurl  -plaintext -import-path /src/github.com/jeffijoe/deltio/proto/googleapis -proto google/pubsub/v1/pubsub.proto -d '{"name": "projects/emulator/topocs/ooooooofoo"}'  172.18.0.6:8432 google.pubsub.v1.Publisher.CreateTopic