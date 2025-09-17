#!/bin/sh
#

# workaround for XDG_RUNTIME_DIR
ln -s \
    /tmp/user/$(id -u)/* \
    /run/user/$(id -u)/ \
        2>/dev/null || true