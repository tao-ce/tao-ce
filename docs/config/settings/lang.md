# Default Language


*TAO Community Edition* uses `en-US` as default language. You may probably want to use another language, especially for services your test-takers will directly use.

Changing default language will require to:

* update `tao.yaml` file
* re-install *TAO Community Edition*


## How-to

### Update `tao.yaml` and `/etc/hosts` file

In [config file documentation](../settings/config_file.md), we describe the role of this file, and how to update it.

You can update `tao.yaml` file with one of the following methods to change default language:

=== "Using `TAO_CE_DEFAULT_LOCALE` env. variable"
    
    If you are using [`docker-compose.yml`](https://github.com/tao-ce/tao-ce/blob/main/docker-compose.yml) file from [`tao-ce/tao-ce`](https://github.com/tao-ce/tao-ce) repository, you can declare `TAO_CE_DEFAULT_LOCALE` environment variable while starting containers.

    ``` bash
    export TAO_CE_DEFAULT_LOCALE="fr-FR"
    ```


=== "Custom `tao.yaml` file"

    You need to update `tao.yaml` file to change `defaultLocale`:

    ``` yaml hl_lines="3"
    spec:
      publicDomain: tao.is-awesome.example.org
      defaultLocale: fr-FR
    ...
    ```

### Re-install *TAO Community Edition*

!!! danger inline "Data will be deleted"

    Reinstallation will required to remove all volumes, databases and files.

    In particular, all users, tests or results will be deleted.

Changing domain will impact several internal configurations, and it is required to re-install *TAO Community Edition*.
