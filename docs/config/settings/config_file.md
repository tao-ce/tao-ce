# `tao.yaml` config file


*TAO Community Edition* can be configured globally using a YAML file stored in [`/etc/tao-ce/config/tao.yaml`](https://github.com/tao-ce/tao-ce/blob/main/etc/tao-ce/config/tao.yaml).

!!! tip inline end "About `tao.yaml` config file"
    
    The structure of this file is not definitive and can evolve in the future, to support more features.

    Also, `dependencies` field support a limited set of external dependencies. More backend end settings may be added in the future. 


``` yaml title="Example of configuration file"
spec:
  publicDomain: community.tao.internal # (1)
  defaultLocale: en-US # (2)
  dependencies: # (3)
    # [...]
```

1. Domain name
2. Default language
3. External dependencies


## Update `tao.yaml` file

!!! danger inline end "Be careful"

    Any change in this file may require to re-install *TAO Community Edition*.

    Reinstallation will completly remove data, including users, groups, tests and results.

You can edit this file and override it, either:

=== "Using `docker-compose.yml` configs"

    Change content from `docker-compose.yml` in `configs` > `tao_config` > `content`

    ``` yaml title="Exemple of change in tao_config"  hl_lines="4-8"
    configs:
      tao_config:
        content: |
          spec:
            publicDomain: tao.is-awesome.example.org
            defaultLocale: fr-FR
            dependencies:
              # [...]
    ```

=== "Mount `tao.yaml` file"
    
    You can mount your [own local file](https://github.com/tao-ce/tao-ce/blob/main/etc/tao-ce/config/tao.yaml) as a volume. In `services` > `tao` > `volumes`, add a line with:
    
    ``` yaml title="Mount tao.yml as volume" hl_lines="12"
    services:
        tao:
            image: quay.io/tao-ce/tao-ce:latest
            extra_hosts:
            - community.tao.internal:0.0.0.0
            ports:
            - 443:443
            # [...]
            volumes:
            - /sys/fs/cgroup:/sys/fs/cgroup:rw
            - tao-ce-lib:/var/lib/tao-ce:rw
            - ./path/to/my/tao.yaml:/etc/tao-ce/config/tao.yaml:ro
            # [...]
    ```