#!/bin/sh
#

cmd=$1
shift 1

case $cmd in
    list|describe)
        action=$1
        shift 1
        /bin/grpcurl \
            -import-path /src/proto/googleapis \
            -proto google/pubsub/v1/pubsub.proto \
            $GRPC_ARGS \
            $@ \
            $GRPC_ENDPOINT \
            $cmd \
            $action
        ;;
    *)
        /bin/grpcurl \
            -import-path /src/proto/googleapis \
            -proto google/pubsub/v1/pubsub.proto \
            $GRPC_ARGS \
            $@ \
            $GRPC_ENDPOINT \
            $cmd
        ;;
esac