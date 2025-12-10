#!/usr/bin/bash
#

set -e

. /usr/local/libexec/nvm/nvm.sh

composer update \
        -Wan \
        --prefer-install=source \
        --no-install \
        --no-scripts
