
# Checklist

## Hardware

* at least 80GB of space disk available
* at least 4 CPUs (8 recommended)
* at least 8GB of RAM (16GB recommended)

## System

> [!WARNING]
> This has been tested recent Linux only (Fedora 42 with `x86_64` arch). MacOS and Windows support and requirements may differ.


* `docker` daemon is installed and running. user is member of `docker` group, and `docker compose` command is available.
* `sysctl` records has the following value
```
sysctl net.ipv4.ip_unprivileged_port_start=0  # 443 might be enough, but we are not going to prod
sysctl fs.inotify.max_user_instances=512      # or higher
sysctl fs.inotify.max_user_watches=524288     # or higher
```

## Credentials

* `ssh-agent` is running with your GitHub key added
* a NPM private token is required

# Gather Code
1. Add credentials (will be removed once released OSS)
  * Add NPM token in `.secrets/npm`
2. Clone repos
```bash
git clone -b develop git@github.com:tao-ce/tao-ce.git
cd tao-ce
git submodule update --init --recursive
```
3. Current code may need [some patches](/hack/sources), apply them:
```
patch -p1 < hack/sources/portal.patch
patch -p1 < hack/sources/em.patch
```

# Run
1. Run VS Code (or any IDE compatible with `devcontainers`)
  * ensure to have [`Dev Containers`](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension installed
  * open this repository workspace
  * enter in Dev Container: <kbd>Ctrl + Shift + P</kbd> > `Dev Container: Reopen in container`
2. Run Tilt console
  * run `tilt up`
  * type <kbd>SPACE</kbd> key to open browser
3. Wait for all containers to build
4. In Tilt console
  * in `tao-ce-em-auth-server` row, click `Refresh TenantService`
  * restart the following containers:
    - `tao-ce-em-lti-gateway`
    - `tao-ce-em-sidecar`
    - `tao-ce-envoy`
    - `tao-ce-tao-portal-be`
  * in `tao-ce-tao-portal-be` row, click `Reset Samples Data`

# Use
1. open `https://community.tao.internal/portal`
2. login with `admin` / `password` credentials
 
