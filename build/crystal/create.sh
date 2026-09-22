#!/bin/sh
#

sudo mkdir -p \
    .cache/build/satis \
    /opt/tao-ce \
    /var/lib/tao-ce

sudo chown -R vscode: \
    .cache \
    /opt/tao-ce \
    /var/lib/tao-ce \
    $HOME/.local

sudo loginctl enable-linger $USER
