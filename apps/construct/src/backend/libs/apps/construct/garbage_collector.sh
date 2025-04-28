#!/bin/sh -e

cd /app/construct
mkdir -p /app/construct/data/generis/cache

for index in assets deliveries groups items test-takers tests;
    do flock -n /tmp/tao-ResourceIndexGarbageCollector.lock php index.php 'oat\taoAdvancedSearch\scripts\tools\ResourceIndexGarbageCollector' --index $index ;
done