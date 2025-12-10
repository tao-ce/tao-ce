#!/usr/bin/bash
#

jsonnet -o $1 \
    -e 'function(s,p) std.mergePatch(s,p)' \
    --tla-code-file s=$1 \
    --tla-code-file p=$2
