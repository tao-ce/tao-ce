<?php

/**
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; under version 2
 * of the License (non-upgradable).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * 31 Milk St # 960789 Boston, MA 02196 USA.
 *
 * Copyright (c) 2025 (original work) Open Assessment Technologies SA ;
 */


$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

if (file_exists($_SERVER['DOCUMENT_ROOT'] . $path)) {
    return false;
}
$_SERVER['SCRIPT_FILENAME'] = '/opt/tao-ce/proctoring/lti1p3-gateway/public/index.php';
require_once '/opt/tao-ce/proctoring/lti1p3-gateway/public/index.php';

