#!/bin/sh
#

sudo mkdir -p \
    /opt/tao-ce \
    /var/lib/tao-ce

sudo chown -R vscode: \
    /opt/tao-ce \
    /var/lib/tao-ce \
    $HOME/.local

sudo loginctl enable-linger $USER
