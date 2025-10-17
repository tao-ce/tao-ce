podman run --rm \
  -v /workspace/apps/construct/src:/src \
  -v ${SSH_AUTH_SOCK}:${SSH_AUTH_SOCK} \
  -e SSH_AUTH_SOCK \
  --secret id=NPM_TOKEN=/workspace/.secrets/npm \
  -it \
  localhost/tao-ce/builds/base:dev-latest \
  /bin/sh