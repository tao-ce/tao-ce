FROM node:lts-alpine AS app-env

# Install Python and Java and pre-cache emulator dependencies.
RUN apk add --no-cache python3 py3-pip openjdk11-jre bash && \
    npm install -g firebase-tools && \
    firebase setup:emulators:database && \
    firebase setup:emulators:firestore && \
    firebase setup:emulators:pubsub && \
    firebase setup:emulators:storage && \
    firebase setup:emulators:ui && \
    rm -rf /var/cache/apk/*

VOLUME [ "/data" ]

COPY ./firebase.json /config/firebase.json
COPY --chmod=0755 ./entrypoint.sh /entrypoint.sh

ENV PROJECT_ID=demo-base

ENTRYPOINT [ "/entrypoint.sh" ]
# ENTRYPOINT [ "firebase", "emulators:start", "--only", "firestore", "--project", "$PROJECT_ID", "-c", "/config/firebase.json" ]

# ENTRYPOINT [ "firebase", "serve", "-p", "5000", "-o", "0.0.0.0" ]