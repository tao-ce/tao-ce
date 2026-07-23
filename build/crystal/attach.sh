#!/bin/sh
#

# workaround for XDG_RUNTIME_DIR
#ln -s \
#    /tmp/user/$(id -u)/* \
#    /run/user/$(id -u)/ \
#        2>/dev/null || true

mkdir -p \
    ~/.config/containers/

cat <<EOF >~/.config/containers/containers.conf
[containers]
volumes = [
	"/proc:/proc",
]
default_sysctls = []

[engine]
cgroup_manager = "systemd"

EOF