#!/usr/bin/bash
#

set -e

COMPOSER_PATCH_DIR=$(dirname $0)

COMPOSER_APP_PATH=${COMPOSER_APP_PATH:-.}
COMPOSER_FILE=${COMPOSER_FILE:-composer.json}
REPOS_MAP_FILE_PATH=${REPOS_MAP_FILE_PATH:-${COMPOSER_PATCH_DIR}/map.json}
PACKAGES_PATH=${PACKAGES_PATH:-local-packages}

jsonnet \
    -Sm ./ \
    --tla-code-file src_composer=${COMPOSER_APP_PATH}/${COMPOSER_FILE} \
    --tla-code-file repos_map=${REPOS_MAP_FILE_PATH} \
    -A packages_path=${PACKAGES_PATH} \
    ${COMPOSER_PATCH_DIR}/patch.jsonnet
