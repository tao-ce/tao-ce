#!/usr/bin/env bash

# Check user environment variable
if [[ -z "${PUBSUB_PROJECT_ID}" ]]; then
  echo "Missing PUBSUB_PROJECT_ID environment variable" >&2
  exit 1
fi

# required by JAVA
ulimit -c unlimited

# Start emulator
gcloud beta emulators pubsub start \
  --project=${PUBSUB_PROJECT_ID} \
  --data-dir=/opt/data \
  --host-port=0.0.0.0:${PUBSUB_PORT}
