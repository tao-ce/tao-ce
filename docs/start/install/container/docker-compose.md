---
icon: fontawesome/brands/docker
---

# Using Docker Compose

!!! abstract inline end "About this guide"

    This guide will explain how to deploy *TAO Community Edition* using [Docker Compose](https://docs.docker.com/compose/).

    We will assume you already have Docker Compose installed. If you need to install it, please follow [instructions from its documentation](https://docs.docker.com/compose/install).


## Requirements

* At least 4 CPU cores[^1]
* At least 8GB RAM
* At least 20GB free disk space[^2]


[^1]: `aarch64`/`arm64` or `x86_64`/`amd64` architectures are supported
[^2]: Additionally, ensure to always have at least 10% of free disk on your system.


## Installation

You can install *TAO Community Edition* with Docker Compose with one of the following methods:

### Get Compose file

Docker Compose need a template file, usually called `docker-compose.yml`. This file is available for *TAO Community Edition* as two formats:

* A standalone [`docker-compose.yml`](https://github.com/tao-ce/tao-ce/releases/latest/download/docker-compose.yml) file attached in a release on GitHub
* A composite [`docker-compose.yml`](https://github.com/tao-ce/tao-ce/blob/main/docker-compose.yml) file in [`tao-ce/tao-ce`](https://github.com/tao-ce/tao-ce) repository.


=== "From release assets"

    Download [`docker-compose.yml`](https://github.com/tao-ce/tao-ce/releases/latest/download/docker-compose.yml) file
    ``` bash
    curl -LO \
      https://github.com/tao-ce/tao-ce/releases/latest/download/docker-compose.yml
    ```

=== "From repository"

    Clone [`tao-ce/tao-ce`](https://github.com/tao-ce/tao-ce) repository
    ``` bash
    git clone https://github.com/tao-ce/tao-ce
    cd tao-ce
    ```

### Deploy *TAO Community Edition*

Run the following command
``` bash
docker compose up -d
```

## Check installation

## What's next?

- [x] As *TAO Community Edition* has been successfully installed on your system, you can now proceed with [Preparation](../../prepare.md) steps.
- [x] You can also explore [Configuration guide](../../../config/index.md) and check additional settings.

## Uninstallation

