<?php

$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

if (preg_match('@^/css/@',$path)) {
    die(file_get_contents($_SERVER['DOCUMENT_ROOT'] . $path));
}

if (file_exists($_SERVER['DOCUMENT_ROOT'] . $path)) {
    return false;
}

$_SERVER['SCRIPT_FILENAME'] = __DIR__ . '/public/index.php';
require_once __DIR__ . '/public/index.php';