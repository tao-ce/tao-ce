# Custom Domain name

!!! inline end "About this guide"

    This guide will explain how to configure *TAO Community Edition* to use a custom domain name.

    We will assume you already have a domain name available (private or public), and you know how to redirect traffic pointing to this domain.

    This guide will not cover how to [register a domain name](https://en.wikipedia.org/wiki/Domain_Name_System#Domain_name_registration), neither how you can configure your [DNS zones](https://en.wikipedia.org/wiki/DNS_zone) or [DNS settings](https://en.wikipedia.org/wiki/Domain_Name_System#Client_lookup).

*TAO Community Edition* publishes itself as [`https://community.tao.internal`](https://community.tao.internal); which is right when you just want a quick tour of its features, however, you may want to customize TAO domain name to an address more relevant for your organization.


To support a custom domain name, we will have to:

* update `tao.yaml` file
* update `/etc/hosts` in container
* re-install *TAO Community Edition*

## How-to

### Update `tao.yaml` and `/etc/hosts` file

In [config file documentation](../settings/config_file.md), we describe the role of this file, and how to update it.

You can update `tao.yaml` file with one of the following methods to support custom domain:

=== "Using `TAO_CE_PUBLIC_DOMAIN` env. variable"
    
    If you are using [`docker-compose.yml`](https://github.com/tao-ce/tao-ce/blob/main/docker-compose.yml) file from [`tao-ce/tao-ce`](https://github.com/tao-ce/tao-ce) repository, the easiest way to configure your domain is by declaring `TAO_CE_PUBLIC_DOMAIN` environment variable while starting containers.


    ``` bash
    export TAO_CE_PUBLIC_DOMAIN="tao.is-awesome.example.org"
    ```

    Environment variable will override default value `community.tao.internal` while reading `docker-compose.yaml`,  and also update `/etc/hosts` file in container.

=== "Custom `tao.yaml` file"

    You need to update `tao.yaml` file to change `publicDomain`:

    ``` yaml hl_lines="2"
    spec:
      publicDomain: tao.is-awesome.example.org
    ...
    ```

    Also, if you use [`docker-compose.yml`](https://github.com/tao-ce/tao-ce/blob/main/docker-compose.yml) file, you need to ensure `tao` service has correct `extra_hosts`:

    ``` yaml hl_lines="4-5"
    services:
        tao:
            # [...]
            extra_hosts:
            - tao.is-awesome.example.org:0.0.0.0
            ports:
            - 443:443
            # [...]
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

