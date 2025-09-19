
# Checklist

## Hardware

* at least 20GB of space disk available
* at least 4 CPUs 
* at least 8GB of RAM

## System

> [!WARNING]
> This has been tested recent Linux only (Fedora 42 with `x86_64` or `arm64` arch). MacOS and Windows support and requirements may differ.


* `docker` daemon is installed and running. user is member of `docker` group, and `docker compose` command is available.
* `sysctl` records has the following value
```
sysctl net.ipv4.ip_unprivileged_port_start=0  # 443 might be enough, but we are not going to prod
```
* ensure port `443` is currently free on your machine

## Credentials

* `ssh-agent` is running with your GitHub key added
* a NPM private token is required

# Gather Code

1. Clone repos
```bash
git clone -b develop git@github.com:tao-ce/tao-ce.git
cd tao-ce
git submodule update --init --recursive
```
2. Add credentials (will be removed once released OSS)
  * Add NPM token in `.secrets/npm`
3. Current code may need [some patches](/hack/sources), apply them:
```
find hack/sources -type f | grep patch$ | while read p ; do patch -p1 <$p ; done 
```

# Run
1. Run VS Code (or any IDE compatible with [`devcontainers`](https://containers.dev/))
    * ensure to have [`Dev Containers`](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension installed
    * open this repository workspace
    * enter in Dev Container: <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd> > `Dev Container: Reopen in container`
2. From Devcontainer terminal (<kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>`</kbd>), run the following commands
```bash
# initialize development enviornment services
task dev:init
# build all services from sources, and deploy them locally (similar to `docker compose up`)
task dev:up
```
3. You can follow up deployement with loggy on `http://localhost:18995` ; devcontainer should automatically forward it.
4. Once every service is built, its code is synced in `/opt/tao-ce` and the related `systemd` services are started. 

# Use
1. you may have to update your `/etc/hosts` file with `0.0.0.0 community.tao.internal`
2. open `https://community.tao.internal/portal`
3. login with `admin` / `password` credentials
 
# Further documentation
* [Troubleshooting guide](dev/troubleshooting.md)