
## Test built image locally

In `devcontainer`, after `monolith` image has been built, you may run 

```bash
podman run -d --name test-tao-ce localhost/tao-ce/monolith:tilt-dev
```

In another shell (still in `devcontainer`), you can attach to this container to follow up installation (we assume you have dependencies deployed already).

```bash
podman exec -it test-tao-ce /bin/sh
```

## Cleanup test container

in `devcontainer`, run

```bash
podman stop test-tao-ce
podman rm -v test-tao-ce
```

