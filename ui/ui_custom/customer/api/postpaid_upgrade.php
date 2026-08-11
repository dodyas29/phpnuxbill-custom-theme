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

if (!$planId || !$channel || !$gateway) {
    echo json_encode(['success' => false, 'error' => 'Missing plan_id, channel, or no gateway configured']);
    exit;
}

$user = User::_info();

$plan = ORM::for_table('tbl_plans')
    ->where('id', $planId)
    ->where('enabled', '1')
    ->find_one();
if (!$plan) {
    echo json_encode(['success' => false, 'error' => 'Plan not found']);
    exit;
}

$routerName = $plan['routers'] ?: 'Router Utama';
$routersId = 0;
$router = ORM::for_table('tbl_routers')->where('name', $routerName)->find_one();
if ($router) $routersId = $router['id'];

$oldPlanId = 0;
$oldDaily = 0;
$newDaily = 0;
$oldPortion = 0;
$newPortion = 0;
$daysUsed = 0;
$daysRemaining = 0;
$total = (float) $plan['price'];
$isUpgrade = false;

$active = ORM::for_table('tbl_user_recharges')
    ->where('username', $user['username'])
    ->where('type', 'PPPOE')
    ->where('status', 'on')
    ->find_one();

if ($active) {
    $oldPlan = ORM::for_table('tbl_plans')->find_one($active['plan_id']);
    if ($oldPlan && $oldPlan['validity_unit'] == 'Period') {
        $isUpgrade = true;
        $oldPlanId = $oldPlan['id'];
        $dayExp = (int) ($oldPlan['expired_date'] ?: 20);

        $today = new DateTime(date('Y-m-d'));
        $d = (int) $today->format('d');

        if ($d <= $dayExp) {
            $prevMonth = clone $today;
            $prevMonth->modify('-1 month');
            $periodStart = new DateTime($prevMonth->format('Y-m-') . str_pad($dayExp, 2, '0', STR_PAD_LEFT));
            $periodEnd = new DateTime($today->format('Y-m-') . str_pad($dayExp, 2, '0', STR_PAD_LEFT));
        } else {
            $periodStart = new DateTime($today->format('Y-m-') . str_pad($dayExp, 2, '0', STR_PAD_LEFT));
            $nextMonth = clone $today;
            $nextMonth->modify('+1 month');
            $periodEnd = new DateTime($nextMonth->format('Y-m-') . str_pad($dayExp, 2, '0', STR_PAD_LEFT));
        }

        $daysInPeriod = (int) $periodStart->diff($periodEnd)->days;
        if ($daysInPeriod <= 0) $daysInPeriod = 30;

        $daysUsed = (int) $periodStart->diff($today)->days;
        $daysRemaining = (int) $today->diff($periodEnd)->days;

        $oldPrice = (float) $oldPlan['price'];
        $newPrice = (float) $plan['price'];

        $oldDaily = $oldPrice / $daysInPeriod;
        $newDaily = $newPrice / $daysInPeriod;

        $oldPortion = round($oldDaily * $daysUsed);
        $newPortion = round($newDaily * $daysRemaining);
        $total = $oldPortion + $newPortion;
    }
}

$d = ORM::for_table('tbl_payment_gateway')->create();
$d->username = $user['username'];
$d->user_id = $user['id'];
$d->gateway = $gateway;
$d->plan_id = $plan['id'];
$d->plan_name = $plan['name_plan'];
$d->routers_id = $routersId;
$d->routers = $routerName;
$d->price = $total;
$d->payment_channel = $channel;
$d->created_date = date('Y-m-d H:i:s');
$d->status = 1;
$d->pg_request = json_encode([
    'upgrade' => $isUpgrade,
    'old_plan_id' => $oldPlanId,
    'old_daily' => round($oldDaily),
    'new_daily' => round($newDaily),
    'old_portion' => $oldPortion,
    'new_portion' => $newPortion,
    'days_used' => $daysUsed,
    'days_remaining' => $daysRemaining,
    'total' => $total,
]);
$d->save();
$trxId = $d->id();

if ($gateway === 'tripay') {
    $apiKey = $config['tripay_api_key'] ?? '';
    $merchant = $config['tripay_merchant'] ?? '';
    $secretKey = $config['tripay_secret_key'] ?? '';

    if (empty($apiKey) || empty($merchant) || empty($secretKey)) {
        $d->status = 3;
        $d->save();
        echo json_encode(['success' => false, 'error' => 'Tripay not configured']);
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
    if (function_exists('tripay_get_server')) $server = tripay_get_server();
    if (in_array($_SERVER['HTTP_HOST'] ?? '', ['localhost', '127.0.0.1'])) $server = 'https://tripay.co.id/api-sandbox/';

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
    $d->pg_url_payment = ($viewPayment === 'local')
        ? APP_URL . '/?_route=plugin/tripay_show_payment&id=' . $trxId
        : $result['data']['checkout_url'];
    $d->pg_request = json_encode(array_merge(json_decode($d->pg_request, true) ?: [], [
        'tripay_response' => $result['data'] ?? null
    ]));
    $d->expired_date = date('Y-m-d H:i:s', $result['data']['expired_time']);
    $d->save();

    echo json_encode(['success' => true, 'url' => $d->pg_url_payment, 'trx_id' => (int)$trxId]);
} else {
    $d->status = 3;
    $d->save();
    echo json_encode(['success' => false, 'error' => "Gateway '$gateway' not supported"]);
}
