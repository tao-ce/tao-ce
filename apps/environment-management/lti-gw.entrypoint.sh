#!/bin/sh
#

php -S 0.0.0.0:${LISTEN_PORT:-80} -t ./public ./router.php 