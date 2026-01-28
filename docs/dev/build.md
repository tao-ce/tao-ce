---
title: Build artifacts
---

## Build container

In `devcontainer`, run the following commands:

```
# ensure all applications are up to date
task dev:up

# declare release identifier and registry
export CE_MINOR=4-rc CE_MAJOR=1 TAO_VERSION=2025.10 REMOTE_REGISTRY=internal

# run build and tag the image (~10mn)
task swift:build
task swift:tag
```

## Publish container image

add a GCP token to your environment
```
# you may want to run from a authenticated machine (not devcontainer)
gcloud auth print-access-token >.secrets/google_token
```

then in `devcontainer` push the image
```
task swift:login
task swift:push
```

## Create manifest

once imagex are ready for all archs, run the following commands to create a common manifest

```
task swift:login
task swift:manifest
```

This manifest will ensure to download correct architecture artifact when user is pulling image.