#!/bin/sh -e

cd /app/construct
flock -n /tmp/tao-JobRunner.lock php index.php 'oat\taoTaskQueue\scripts\tools\StuckTaskRestart' --queue indexation_queue --whitelist 'oat\tao\model\search\tasks\UpdateResourceInIndex,oat\tao\model\search\tasks\UpdateClassInIndex,oat\tao\model\search\tasks\DeleteIndexProperty,oat\tao\model\search\tasks\RenameIndexProperties,oat\tao\model\search\tasks\UpdateDataAccessControlInIndex,oat\tao\model\search\tasks\AddSearchIndexFromArray,oat\taoAdvancedSearch\model\Resource\Task\ResourceMigrationTask,oat\taoAdvancedSearch\model\Metadata\Task\MetadataMigrationTask' --age 300
