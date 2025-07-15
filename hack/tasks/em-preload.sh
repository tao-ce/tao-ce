#!/bin/sh
#

kubectl exec \
    -c server \
    deploy/tao-ce-em-auth-server -- \
        node /app/scripts/tenant-data-preloader/preload-tenant-data-json.js