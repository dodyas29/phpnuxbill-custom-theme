<?php
session_start();
$root_path = realpath(__DIR__ . '/../../../../') . DIRECTORY_SEPARATOR;
$_SERVER['HTTP_HOST'] = $_SERVER['HTTP_HOST'] ?? 'localhost:8000';
$_SERVER['SERVER_PORT'] = $_SERVER['SERVER_PORT'] ?? '8000';
$_SERVER['SCRIPT_NAME'] = '/index.php';
require_once $root_path . 'config.php';
require_once $root_path . 'system/vendor/autoload.php';
require_once $root_path . 'init.php';

header('Content-Type: application/json; charset=utf-8');

if (!User::getID()) {
    http_response_code(401);
    echo json_encode(['error' => 'Unauthorized']);
    exit;
}

$user = User::_info();
$page = max(1, (int) ($_GET['page'] ?? 1));
$limit = 10;
$offset = ($page - 1) * $limit;

$query = ORM::for_table('tbl_payment_gateway')
    ->where('username', $user['username'])
    ->order_by_desc('id');

$total = $query->count();
$items = $query->offset($offset)->limit($limit)->find_many();

$result = [];
foreach ($items as $item) {
    $result[] = [
        'id' => (int) $item['id'],
        'plan_name' => $item['plan_name'],
        'price' => (int) $item['price'],
        'price_formatted' => Lang::moneyFormat($item['price']),
        'status' => (int) $item['status'],
        'created_date' => $item['created_date'],
        'gateway' => $item['gateway'],
        'routers' => $item['routers'],
        'payment_channel' => $item['payment_channel'],
    ];
}

echo json_encode([
    'data' => $result,
    'page' => $page,
    'total' => (int) $total,
    'pages' => (int) ceil($total / $limit),
    'has_more' => ($page * $limit) < $total,
    'has_prev' => $page > 1,
]);
