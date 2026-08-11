<?php
session_start();
$root_path = realpath(__DIR__ . '/../../../');
$_SERVER['HTTP_HOST'] = $_SERVER['HTTP_HOST'] ?? 'localhost:8000';
$_SERVER['SERVER_PORT'] = $_SERVER['SERVER_PORT'] ?? '8000';
$_SERVER['SCRIPT_NAME'] = '/index.php';
require_once $root_path . '/config.php';
require_once $root_path . '/system/vendor/autoload.php';
require_once $root_path . '/init.php';

header('Content-Type: application/json; charset=utf-8');

if ($_SERVER['REQUEST_METHOD'] !== 'POST' || !User::getID()) {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid request']);
    exit;
}

$input = json_decode(file_get_contents('php://input'), true);
$rechargeId = (int) ($input['recharge_id'] ?? 0);
$channel = trim($input['channel'] ?? '');

if (!$rechargeId || !$channel) {
    echo json_encode(['error' => 'Missing recharge_id or channel']);
    exit;
}

$user = User::_info();
$recharge = ORM::for_table('tbl_user_recharges')
    ->where('id', $rechargeId)
    ->where('username', $user['username'])
    ->find_one();

if (!$recharge) {
    echo json_encode(['error' => 'Recharge not found']);
    exit;
}

$router = ORM::for_table('tbl_routers')
    ->where('name', $recharge['routers'])
    ->find_one();

if (!$router) {
    echo json_encode(['error' => 'Router not found']);
    exit;
}

$gateway = trim($config['payment_gateway'] ?? '');
if (!$gateway) {
    echo json_encode(['error' => 'No payment gateway configured']);
    exit;
}

$_SESSION['gateway'] = $gateway;

$url = getUrl("order/buy/{$router['id']}/{$recharge['plan_id']}/$channel");

echo json_encode(['url' => $url]);
