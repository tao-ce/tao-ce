#ifndef MACROS_H
#define MACROS_H
#include "constants.h"
#define WITH_CACHE_COMPOSER     --mount=type=cache,id=composer-cache,target=CACHE_DIR_COMPOSER
#define WITH_CACHE_GO           --mount=type=cache,target=CACHE_DIR_GO
#define WITH_CACHE_NPM          --mount=type=cache,id=npm-cache,target=CACHE_DIR_NPM,sharing=locked
#define STATE_DATA(_id,_dir) \
    rm -rf _dir; \
    mkdir -p $STATE_ROOT/_id; \
    ln -s $STATE_ROOT/_id _dir
#define STATE_FILE(_id,_file) \
    rm -rf _file; \
    mkdir -p $(dirname $STATE_ROOT/_id); \
    ln -s $STATE_ROOT/_id _file
#endif
