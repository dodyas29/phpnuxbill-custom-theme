<?php
session_start();
$root_path = realpath(__DIR__ . '/../../../../');
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
$planId = (int) ($input['plan_id'] ?? 0);
$channel = trim($input['channel'] ?? '');
$gateway = trim($config['payment_gateway'] ?? '');
$custom = !empty($input['custom']);
$amount = $custom ? ((int) ($input['amount'] ?? 0)) : 0;

if (!$gateway) {
    echo json_encode(['success' => false, 'error' => 'Payment gateway not configured']);
    exit;
}

if (!$channel) {
    echo json_encode(['success' => false, 'error' => 'Channel is required']);
    exit;
}

if ($custom && $amount <= 0) {
    echo json_encode(['success' => false, 'error' => 'Amount is required']);
    exit;
}

$user = User::_info();

if ($custom) {
    $planName = 'Custom Balance';
    $price = $amount;
    $routers = 'Custom Balance';
    $routersId = 0;
} else {
    if (!$planId) {
        echo json_encode(['success' => false, 'error' => 'Plan ID is required']);
        exit;
    }
    $plan = ORM::for_table('tbl_plans')
        ->where('id', $planId)
        ->where('enabled', '1')
        ->where('type', 'Balance')
        ->find_one();
    if (!$plan) {
        echo json_encode(['success' => false, 'error' => 'Plan not found']);
        exit;
    }
    $planName = $plan['name_plan'];
    $price = (float) $plan['price'];
    $routers = 'balance';
    $routersId = 0;
}

$total = $price;

$d = ORM::for_table('tbl_payment_gateway')->create();
$d->username = $user['username'];
$d->user_id = $user['id'];
$d->gateway = $gateway;
$d->plan_id = $planId;
$d->plan_name = $planName;
$d->routers_id = $routersId;
$d->routers = $routers;
$d->price = $total;
$d->payment_channel = $channel;
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
            'name' => $planName,
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
        echo json_encode(['success' => false, 'error' => $result['message'] ?? 'Unknown error']);
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
