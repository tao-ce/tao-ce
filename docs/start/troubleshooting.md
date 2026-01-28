---
icon: material/puzzle-outline
---

# Troubleshooting guide


## Console

A console can be useful to browse code and services.

=== "Docker Compose"

    ```
    docker compose exec -it tao /usr/bin/bash
    ```

    Type `exit` to return to host shell.

## Logs

*TAO Community Edition* uses `journald` from `systemd` to manage logs. Check [`journalctl`](http://www.freedesktop.org/software/systemd/man/journalctl.html) manual for more documentation.


=== "Docker Compose"

    ```
    docker compose exec -it tao journalctl -f
    ```

    Press <kbd>Ctrl</kbd>+<kbd>C</kbd> to quit log stream.

## Known issues

### Installation issues

This section gather common issue during installation or just after it finishes.

??? question "Username cannot login (login/password incorrect)"

    We consider administrator has double-checked login and password.

    In rare cases, installation may face race-condition which would attempt users provisioning while the stack is not properly ready. This would mean the `tao-ce.portal.init.service` initialization service would consider the work done ; while it fails.

    You may try one of the following solutions:

    === "Re-run initialization script"

        !!! danger inline end
            This solution will delete users and groups in TAO Community Edition, and restore defaults data.

        In such case, you may have to re-run this initialization script.

        1. Enter container shell (cf. [this guide](#console))
        2. Run the following commands in `tao` container

        ```bash
        # Delete semaphore to unblock users creation
        rm -f $TAO_CE_VARLIB/portal/users_loaded.json
        # Restart init service to recreate users
        systemctl restart tao-ce.portal.init.service
        ```

    === "Re-install TAO Community Edition"

        !!! danger inline end
            This solution will delete all data, including users, groups, tests and results.


        === "Using Docker Compose"

            Follow [re-install](./install/container/docker-compose.md#reinstallation) procedure to clean all data and re-install TAO Community Edition.

