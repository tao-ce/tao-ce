<?php

declare(strict_types=1);

function assertTrue(bool $condition, string $message): void
{
    if ($condition) {
        return;
    }

    fwrite(STDERR, $message . PHP_EOL);
    exit(1);
}

$tempRoot = sys_get_temp_dir() . '/tao-ce-devkit-router-css-' . uniqid('', true);
$cssDirectory = $tempRoot . '/css';
$cssFile = $cssDirectory . '/main.css';
$port = random_int(20000, 40000);
$routerPath = realpath(__DIR__ . '/../router.php');

mkdir($cssDirectory, 0777, true);
file_put_contents($cssFile, 'body { color: #000; }');

$command = sprintf(
    'php -S 127.0.0.1:%d -t %s %s',
    $port,
    escapeshellarg($tempRoot),
    escapeshellarg($routerPath)
);

$descriptorSpec = [
    0 => ['pipe', 'r'],
    1 => ['file', '/tmp/tao-ce-devkit-router-css-test.log', 'a'],
    2 => ['file', '/tmp/tao-ce-devkit-router-css-test.log', 'a'],
];

$process = proc_open($command, $descriptorSpec, $pipes);

assertTrue(is_resource($process), 'Expected the PHP built-in server to start for the router CSS MIME test.');

usleep(500000);

$headers = get_headers(sprintf('http://127.0.0.1:%d/css/main.css', $port), true);

proc_terminate($process);
proc_close($process);

unlink($cssFile);
rmdir($cssDirectory);
rmdir($tempRoot);

assertTrue(is_array($headers), 'Expected to receive HTTP headers from the router CSS MIME test.');

$contentType = $headers['Content-Type'] ?? $headers['Content-type'] ?? null;

if (is_array($contentType)) {
    $contentType = end($contentType);
}

assertTrue(
    is_string($contentType) && str_starts_with($contentType, 'text/css'),
    sprintf('Expected text/css for CSS assets, got %s.', var_export($contentType, true))
);
