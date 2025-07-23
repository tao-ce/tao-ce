#!/bin/sh
#

RELEASE_ORGREPO=$1
RELEASE_ARTIFACT=$2
RELEASE_VERSION=$3


CACHE_ROOT=${CACHE_ROOT:-/run/cache/github/releases}

TARGET_VERSION=${RELEASE_VERSION:-latest}

[ "${RELEASE_VERSION}" == "latest" ] \
    && TARGET_VERSION="$(curl https://api.github.com/repos/${RELEASE_ORGREPO}/releases/latest | jq -r .tag_name)"

STRIP_V_VERSION=$(echo $TARGET_VERSION | sed -e s/^v//)
STRIP_SLASH_VERSION=$(echo $TARGET_VERSION | sed -e s@.*/@@)
TARGET_ARTIFACT=$(echo $RELEASE_ARTIFACT | sed \
    -e s#@@VERSION@@#$TARGET_VERSION# \
    -e s#@@STRIPVERSION@@#$STRIP_V_VERSION# \
    -e s#@@STRIPSLASHVERSION@@#$STRIP_SLASH_VERSION# \
)

CACHE_DIR=${CACHE_ROOT}/${RELEASE_ORGREPO}/${TARGETPLATFORM}/${TARGET_VERSION}
ARTIFACT_PATH=${CACHE_DIR}/${TARGET_ARTIFACT}

mkdir -p ${CACHE_DIR} /run/tmp/

echo https://github.com/${RELEASE_ORGREPO}/releases/download/${TARGET_VERSION}/${TARGET_ARTIFACT} >&2

[ -f "${ARTIFACT_PATH}" ] \
    && echo Artifact already exists in ${ARTIFACT_PATH} \
    || curl -v -fsSL \
            https://github.com/${RELEASE_ORGREPO}/releases/download/${TARGET_VERSION}/${TARGET_ARTIFACT} \
            -o ${ARTIFACT_PATH}

echo ${TARGET_VERSION} >/run/tmp/version
echo ${ARTIFACT_PATH} >/run/tmp/last-download
