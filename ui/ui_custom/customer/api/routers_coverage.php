<?php
session_start();
$root_path = realpath(__DIR__ . '/../../../../');
$_SERVER['HTTP_HOST'] = $_SERVER['HTTP_HOST'] ?? 'localhost:8000';
$_SERVER['SERVER_PORT'] = $_SERVER['SERVER_PORT'] ?? '8000';
$_SERVER['SCRIPT_NAME'] = $_SERVER['SCRIPT_NAME'] ?? '/index.php';
require_once $root_path . '/config.php';
require_once $root_path . '/system/vendor/autoload.php';
require_once $root_path . '/init.php';

header('Content-Type: application/json; charset=utf-8');

$routers = ORM::for_table('tbl_routers')
    ->where_not_equal('coordinates', '')
    ->find_many();

$result = [];
foreach ($routers as $r) {
    $result[] = [
        'id' => (int) $r['id'],
        'name' => $r['name'],
        'coordinates' => $r['coordinates'],
        'coverage' => (int) ($r['coverage'] ?? 0),
        'description' => $r['description'] ?? '',
        'enabled' => $r['enabled'] ?? '1',
    ];
}

echo json_encode($result, JSON_PRETTY_PRINT);
