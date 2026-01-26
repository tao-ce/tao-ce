# Custom Domain name

!!! inline end "About this guide"

    This guide will explain how to configure *TAO Community Edition* to use a custom domain name.

    We will assume you already have a domain name available (private or public), and you know how to redirect traffic pointing to this domain.

    This guide will not cover how to [register a domain name](https://en.wikipedia.org/wiki/Domain_Name_System#Domain_name_registration), neither how you can configure your [DNS zones](https://en.wikipedia.org/wiki/DNS_zone) or [DNS settings](https://en.wikipedia.org/wiki/Domain_Name_System#Client_lookup).

*TAO Community Edition* publishes itself as [`https://community.tao.internal`](https://community.tao.internal); which is right when you just want a quick tour of its features, however, you may want to customize TAO domain name to an address more relevant for your organization.


## How-to

### Update `tao.yaml` file

Using container deployment, you may have notice [`docker-compose.yml`](https://github.com/tao-ce/tao-ce/blob/main/docker-compose.yml) declare a [`tao_config`](https://github.com/tao-ce/tao-ce/blob/f29c3483cb1963307878caa822c0bda2fc241929/docker-compose.yml#L31-L66) YAML content, which is mounted as `/etc/tao-ce/tao.yaml` in `tao-ce` container.


=== "Using `TAO_CE_PUBLIC_DOMAIN` env. variable"
    
    If you are [`docker-compose.yml`](https://github.com/tao-ce/tao-ce/blob/main/docker-compose.yml) file from [`tao-ce/tao-ce`](https://github.com/tao-ce/tao-ce) repository, the easiest way to configure your domain is by declaring `TAO_CE_PUBLIC_DOMAIN` environment variable while starting containers.


    ``` bash
    export TAO_CE_PUBLIC_DOMAIN="tao.is-awesome.example.org"
    ```

    Environment variable will override default value `community.tao.internal` while reading `docker-compose.yaml`.

=== "Custom `tao.yaml` file"

    This `tao.yaml` file gathers settings which are used to generate application configuration.

    You can edit this file and override it, either:

    * change content from `docker-compose.yml` in `configs` > `tao_config` 
    ``` yaml
    spec:
      publicDomain: tao.is-awesome.example.org
    ...
    ```
    * or mount your [own local file](https://github.com/tao-ce/tao-ce/blob/main/etc/tao-ce/config/tao.yaml) as a volume. In `services` > `tao` > `volumes`, add a line with:
    ``` yaml
    - ./path/to/my/tao.yaml:/etc/tao-ce/tao.yaml:ro
    ```

### Re-install *TAO Community Edition*

!!! danger inline "Data will be deleted"

    Reinstallation will required to remove all volumes, databases and files.

    In particular, all users, tests or results will be deleted.

Changing domain will impact several internal configurations, and it is required to re-install *TAO Community Edition*.


``` bash
# Remove all containers and volumes
docker compose down -v

# Restart all containers
docker compose up -d
```

## Propagate new domain name

As described in [Preparation guide](../../start/prepare.md) following installation, you will have to update how your browser (and other hosts) resolve your new domain.

Aside [modifying `/etc/hosts` file](../../start/prepare.md#name-resolution), domain name can be propagate through DNS servers, so you can publish your service on [your Local Area Network](./public-lan.md), or even [on Internet](./public-wan.md).

