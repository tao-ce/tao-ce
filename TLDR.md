
# Gather Code
1. Add credentials (will be removed once released OSS)
  * Add NPM token in `.secrets/npm`
  * Ensure to have `ssh-agent` running with your GitHub key added
2. Clone repos
```bash
git clone git@github.com:tao-ce/tao-ce.git`
cd tao-ce
git submodule update
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
  * in `tao-ce-tao-portal-be` row, click `Reset Credentials`

# Use
1. open `https://community.tao.internal/portal`
2. login with `admin` / `password` credentials
 
