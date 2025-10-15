# Reinstall

If you need to reinstall all applications, you can rebuild `devcontainer`. You may want also to prune all data from `/opt/tao-ce` in the container.

Then you can restart `tao-ce.setup.service` to regenerate configuration, then restart `tao-ce.*.service`.

## Re-import default users

This will drop all current users.

In `devcontainer`, remove `/var/lib/tao-ce/portal/users_loaded.json`, then restart `tao-ce.portal.init.service`.

