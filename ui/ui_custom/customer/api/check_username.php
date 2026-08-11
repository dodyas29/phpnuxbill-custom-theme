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

$username = trim($_GET['username'] ?? '');
if (empty($username) || strlen($username) < 3) {
    echo json_encode(['available' => false, 'suggestions' => []]);
    exit;
}

$existing = ORM::for_table('tbl_customers')
    ->where_raw("username = '$username'")
    ->find_one();

if (!$existing) {
    echo json_encode(['available' => true, 'suggestions' => []]);
    exit;
}

$suggestions = [];
for ($i = 1; $i <= 5; $i++) {
    $sug = $username . $i;
    $e = ORM::for_table('tbl_customers')->where_raw("username = '$sug'")->find_one();
    if (!$e) {
        $suggestions[] = $sug;
    }
    if (count($suggestions) >= 3) break;
}

echo json_encode(['available' => false, 'suggestions' => $suggestions]);
