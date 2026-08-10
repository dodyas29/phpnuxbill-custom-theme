<?php
$root_path = realpath(__DIR__ . '/../../../');
$_SERVER['HTTP_HOST'] = $_SERVER['HTTP_HOST'] ?? 'localhost:8080';
$_SERVER['SERVER_PORT'] = $_SERVER['SERVER_PORT'] ?? '8080';
$_SERVER['SCRIPT_NAME'] = $_SERVER['SCRIPT_NAME'] ?? '/index.php';
require_once $root_path . '/config.php';
require_once $root_path . '/system/vendor/autoload.php';
require_once $root_path . '/init.php';

header('Content-Type: application/json; charset=utf-8');

if (!User::getID()) {
    http_response_code(401);
    echo json_encode(['error' => 'Unauthorized']);
    exit;
}

$user = User::_info();
$uid = $_SESSION['uid'];

$plans = [];
$balance = (float) ($user['balance'] ?? 0);

$recharges = ORM::for_table('tbl_user_recharges')
    ->where('customer_id', $uid)
    ->order_by_desc('id')
    ->find_many();

foreach ($recharges as $r) {
    $plan = ORM::for_table('tbl_plans')->find_one($r['plan_id']);
    $bw = null;
    if ($plan && !empty($plan['id_bw'])) {
        $bw = ORM::for_table('tbl_bandwidth')->find_one($plan['id_bw']);
    }

    $exp = strtotime($r['expiration']);
    $now = time();
    $days_left = (int) max(0, ceil(($exp - $now) / 86400));
    $recharged = strtotime($r['recharged_on']);
    $total_days = (int) max(1, ceil(($exp - $recharged) / 86400));

    $plans[] = [
        'id' => (int) $r['id'],
        'name' => $r['namebp'],
        'type' => $r['type'],
        'router' => $r['routers'],
        'status' => $r['status'],
        'expiration' => $r['expiration'],
        'expiration_formatted' => Lang::dateFormat($r['expiration']),
        'days_left' => $days_left,
        'total_days' => $total_days,
        'progress_pct' => $total_days > 0 ? max(0, min(100, (int) round(($total_days - $days_left) / $total_days * 100))) : 0,
        'speed_down' => $bw ? $bw['rate_down'] . ' ' . $bw['rate_down_unit'] : '-',
        'speed_up'   => $bw ? $bw['rate_up']   . ' ' . $bw['rate_up_unit']   : '-',
        'bw_name'    => $bw ? $bw['name_bw'] : '-',
        'price'      => $plan ? $plan['price'] : '0',
        'plan_id'    => (int) $r['plan_id'],
    ];
}

// Last payment
$payment = ORM::for_table('tbl_payment_gateway')
    ->where('username', $user['username'])
    ->order_by_desc('id')
    ->find_one();
$payment_data = null;
if ($payment) {
    $payment_data = [
        'status'    => $payment['status'] == 2 ? 'paid' : 'pending',
        'date'      => Lang::dateFormat($payment['paid_date'] ?? $payment['created_date'] ?? ''),
        'amount'    => $payment['price'],
        'plan_name' => $payment['plan_name'],
    ];
}

// Recent transactions (last 5)
$trx = ORM::for_table('tbl_payment_gateway')
    ->where('username', $user['username'])
    ->order_by_desc('id')
    ->limit(5)
    ->find_many();
$transactions = [];
foreach ($trx as $t) {
    $transactions[] = [
        'id' => (int) $t['id'],
        'date' => Lang::dateFormat($t['paid_date'] ?? $t['created_date'] ?? ''),
        'plan_name' => $t['plan_name'] ?: $t['gateway'],
        'amount' => $t['price'],
        'status' => $t['status'] == 2 ? 'paid' : ($t['status'] == 1 ? 'pending' : 'cancelled'),
        'method' => $t['payment_method'] ?: '-',
    ];
}

echo json_encode([
    'active_plans' => $plans,
    'balance'      => $balance,
    'balance_formatted' => Lang::moneyFormat($user['balance']),
    'last_payment' => $payment_data,
    'transactions' => $transactions,
], JSON_PRETTY_PRINT);
