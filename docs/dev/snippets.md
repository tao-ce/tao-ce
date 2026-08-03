This page is a small collections of commands and configuration to facilitate your work with *TAO Community Edition* development or administration.

!!! abstract "About this page"
    
    Commands listed here can be executed from different environments:
    
    `host`
    :    Your local host machine (where your keyboard and screen are attached).

    `devcontainer`
    :   the `devcontainer` environment your IDE is attached to (weither it is running local or remote).
    
    `remote`
    :   the remote host machine, if you are using [Remote development environment](./remote.md).

    Always ensure to run commands in environment mentionned in snippet title.

## Development environment

### Redirect port

In some cases, you may not want or not be able to reserve port 443 while starting a development environment (e.g., [`proxy` container](https://github.com/tao-ce/tao-ce/blob/f29c3483cb1963307878caa822c0bda2fc241929/docker-compose.dev.yml#L37-L46) will fail silently if port is already booked).

You may still rely on Visual Studio Code to [forward port](https://code.visualstudio.com/docs/remote/ssh#_forwarding-a-port-creating-ssh-tunnel), but an unprivileged random port will be assigned.

Once you identified this port (e.g. 42785), you can use [`socat`](https://en.wikipedia.org/wiki/Netcat) (or similar) locally to redirect incoming trafic to your local machine on port 443 to the assigned port:

``` bash title="in host"
sudo socat "TCP-LISTEN:443,fork,reuseaddr" "TCP:localhost:42785"
```

## Clean up

### Reclaim disk space from containers cache

`devcontainer` can be particulary greedy on disk space usage, as it keep all image layers in cache for build performance.

You may have sometime to clean `podman` cache to reclaim disk space:

``` bash title="in devcontainer"
podman system prune --all
```


