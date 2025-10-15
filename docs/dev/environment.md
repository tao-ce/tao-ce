> [!NOTICE]
> This document is deprecated, new version to be published

# Overview

## Service deployment

```mermaid
flowchart TB
subgraph docker-compose
    direction LR
    subgraph devcontainer
        direction TB
    subgraph systemd
        subgraph tao-ce
        construct
        deliver
        portal
        em
        setup
        static
        taoo[...]
        end
    end
        tilt[/tilt/]
    end
    subgraph dependencies
        pgsql
        redis
        elasticsearch
        pubsub-emulator
        firestore-emulator
        depso[...]
    end
    tilt --> tao-ce
end
vscode -- provision --> docker-compose
vscode -- attach --> devcontainer
```

## Build & deployment toolchain

```mermaid
flowchart TB
subgraph dev["devcontainer"]
    subgraph podman
    buildah[/buildah/] --> imagestore[(imagestore)]
    end
    imagestore -- local output--> tao-ce[(/opt/tao-ce)]
    tilt -- run --> buildah
    tilt -- (re)start --> taosvc[tao-ce.*.service] -- run from --> tao-ce
    tilt --> init
    static --> tao-ce
    taosvc -- use --> conf
    setup -- generate --> conf[(configuration)]
    conf --> static
    init[devcontainer
    init process] -- initialize service --> static[tao-ce.static.service]
    init -- initialize service --> setup[tao-ce.setup.service]
end
```


# Components

## Dependencies

Those services are deployed from [`docker-compose.stack.yml`](/docker-compose.stack.yml) with pre-configuration of volumes to keep persistent data.

## Dev container

### podman

Podman is used to build images in isolated context, and can be used also to locally test images.

`buildah` is used as building frontend.

### tilt

Tilt is main entrypoint to build locally all the applications and run them in a Devcontainer.

### systemd

All applications are deployed through `systemd` units.