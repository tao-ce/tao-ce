

# Operations

> [!TIP]
> Operations descriped in this section will assume you are deploying TAO Community Edition containers using `docker compose`.
>
> If you are using a different toolchain (e.g. `podman compose` or Docker Desktop), please update commands accordingly.

## Install

### Install TAO CE from command-line

The following command will deploy TAO Community Edition, start all services, and leave.

```
docker compose up -d
```

## Uninstall

### Uninstall TAO CE from command-line

> [!CAUTION]
> This operation will whipe all TAO CE data (including users, tests and results).

If you are sure to remove TAO Community Edition, you may run the following command:

```
docker compose down -v
```

(`-v` flag will ensure all data from volumes are removed. If this flag is skipped, TAO Community Edition may fail to re-install, as some volumes contains semaphores which could prevent complete installation to run).

## Reinstall

### Reinstall TAO CE from command-line

> [!CAUTION]
> This operation will whipe all TAO CE data (including users, tests and results).

If you are sure to reinstall TAO Community Edition, you may run the following command:

```
docker compose down -v
docker compose up -d
```

## Console

### Open shell from command-line

If you want to access a shell inside TAO Community Edition container, you can run the following command:

```
docker compose exec -it tao /usr/bin/bash
```

Type `exit` to return to host shell.

## Logs

### Stream logs from command-line

You may run the following command to access its logs:

```
docker compose exec -it tao journalctl -f
```

Press <kbd>Ctrl</kbd>+<kbd>C</kbd> to quit log stream.

# Known issues

## Installation issues

This section gather common issue during installation or just after it finishes.

### Username cannot login (login/password incorrect)

We consider user has double-checked login and password.

In rare cases, installation may face race-condition which would attempt users provisioning while the stack is not properly ready. This would mean the `tao-ce.portal.init.service` initialization service would consider the work done ; while it fails.

You may try one of the following solutions:

#### Solution A: Re-run initialization script

> [!CAUTION]
> This solution will delete users and groups in TAO Community Edition, and restore defaults data.

In such case, you may have to re-run this initialization script.

1. Enter container shell (cf. [this guide](#console))
2. Run the following commands in `tao` container

```bash
rm -f $TAO_CE_VARLIB/portal/users_loaded.json
systemctl restart tao-ce.portal.init.service
```

#### Solution B: Re-install TAO Community Edition

Follow [re-install](#reinstall) procedure to clean all data and re-install TAO Community Edition.

# Support

## Get more help

In the situation:
* you face an issue which is not described in this guide
* you have technical questions regarding TAO Community Edition

Feel free to contact support on our [forum](https://forum.opensource.taotesting.com).

