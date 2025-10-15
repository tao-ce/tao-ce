<?php

$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

if (file_exists($_SERVER['DOCUMENT_ROOT'] . $path)) {
    return false;
}

if (str_starts_with($path, '/tao/getFileFlysystem.php/')) {
    $_SERVER['SCRIPT_FILENAME'] = __DIR__ . '/tao/getFileFlysystem.php';
    require_once __DIR__ . '/tao/getFileFlysystem.php';
    return;
}

$_SERVER['SCRIPT_FILENAME'] = __DIR__ . '/index.php';

require_once __DIR__ . '/index.php';
