<?php

// echo "foo";
$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

// echo $path; 

// error_log(var_dump($_SERVER)); 

if (file_exists($_SERVER['DOCUMENT_ROOT'] . $path)) {
    return false;
}
$_SERVER['SCRIPT_FILENAME'] = '/app/construct/index.php';

require_once '/app/construct/index.php';