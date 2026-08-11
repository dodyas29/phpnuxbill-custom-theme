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
    echo json_encode(['success' => false, 'error' => 'Invalid request']);
    exit;
}

$input = json_decode(file_get_contents('php://input'), true);
$rechargeId = (int) ($input['recharge_id'] ?? 0);
$channel = trim($input['channel'] ?? '');
$gateway = trim($config['payment_gateway'] ?? '');

if (!$rechargeId || !$channel || !$gateway) {
    echo json_encode(['success' => false, 'error' => 'Missing recharge_id, channel, or no gateway configured']);
    exit;
}

$user = User::_info();
$recharge = ORM::for_table('tbl_user_recharges')
    ->where('id', $rechargeId)
    ->where('username', $user['username'])
    ->find_one();

if (!$recharge) {
    echo json_encode(['success' => false, 'error' => 'Recharge not found']);
    exit;
}

$plan = ORM::for_table('tbl_plans')->where('id', $recharge['plan_id'])->find_one();
if (!$plan) {
    echo json_encode(['success' => false, 'error' => 'Plan not found']);
    exit;
}

$router = ORM::for_table('tbl_routers')
    ->where('name', $recharge['routers'])
    ->find_one();

if (!$router) {
    echo json_encode(['success' => false, 'error' => 'Router not found']);
    exit;
}

$price = (float) $plan['price'];
$addCost = 0;

$bills = User::getBills();
if (!empty($bills)) {
    foreach ($bills as $bill) {
        if ($bill['plan_id'] == $plan['id'] || $bill['routers_id'] == $router['id'] || $bill['router'] == $router['name']) {
            $addCost += (float) $bill['price'];
        }
    }
}

$tax = Package::tax($plan['price']);
$total = $price + $addCost + $tax;

$d = ORM::for_table('tbl_payment_gateway')->create();
$d->username = $user['username'];
$d->user_id = $user['id'];
$d->gateway = $gateway;
$d->plan_id = $plan['id'];
$d->plan_name = $plan['name_plan'];
$d->routers_id = $router['id'];
$d->routers = $router['name'];
$d->price = $total;
$d->created_date = date('Y-m-d H:i:s');
$d->status = 1;
$d->save();
$trxId = $d->id();

if ($gateway === 'tripay') {
    $apiKey = $config['tripay_api_key'] ?? '';
    $merchant = $config['tripay_merchant'] ?? '';
    $secretKey = $config['tripay_secret_key'] ?? '';

    if (empty($apiKey) || empty($merchant) || empty($secretKey)) {
        $d->status = 3;
        $d->save();
        echo json_encode(['success' => false, 'error' => 'Tripay payment gateway not configured']);
        exit;
    }

    $signature = hash_hmac('sha256', $merchant . $trxId . (int)$total, $secretKey);

    $payload = [
        'method' => $channel,
        'amount' => (int)$total,
        'merchant_ref' => (string)$trxId,
        'customer_name' => $user['fullname'],
        'customer_email' => empty($user['email']) ? $user['username'] . '@' . $_SERVER['HTTP_HOST'] : $user['email'],
        'customer_phone' => $user['phonenumber'] ?? '',
        'order_items' => [[
            'name' => $plan['name_plan'],
            'price' => (int)$total,
            'quantity' => 1,
        ]],
        'return_url' => APP_URL . '/?_route=order/view/' . $trxId . '/check',
        'signature' => $signature,
    ];

    $server = 'https://tripay.co.id/api-sandbox/';
    if (function_exists('tripay_get_server')) {
        $server = tripay_get_server();
    }
    if (in_array($_SERVER['HTTP_HOST'] ?? '', ['localhost', '127.0.0.1'])) {
        $server = 'https://tripay.co.id/api-sandbox/';
    }
    $result = json_decode(Http::postJsonData($server . 'transaction/create', $payload, [
        'Authorization: Bearer ' . $apiKey
    ]), true);

    if ($result['success'] != 1) {
        $d->status = 3;
        $d->pg_request = json_encode($result);
        $d->save();
        $errMsg = $result['message'] ?? 'Unknown error';
        echo json_encode(['success' => false, 'error' => $errMsg]);
        exit;
    }

    $viewPayment = $config['tripay_view_payment'] ?? '';
    $d->gateway_trx_id = $result['data']['reference'];
    if ($viewPayment === 'local') {
        $d->pg_url_payment = APP_URL . '/?_route=plugin/tripay_show_payment&id=' . $trxId;
    } else {
        $d->pg_url_payment = $result['data']['checkout_url'];
    }
    $d->pg_request = json_encode($result);
    $d->expired_date = date('Y-m-d H:i:s', $result['data']['expired_time']);
    $d->save();

    echo json_encode(['success' => true, 'url' => $d->pg_url_payment, 'trx_id' => (int)$trxId]);
} else {
    $d->status = 3;
    $d->save();
    echo json_encode(['success' => false, 'error' => "Gateway '$gateway' not supported"]);
}
