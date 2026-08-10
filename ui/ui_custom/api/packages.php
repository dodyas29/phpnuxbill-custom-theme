<?php
session_start();
$root_path = realpath(__DIR__ . '/../../../');
$_SERVER['HTTP_HOST'] = $_SERVER['HTTP_HOST'] ?? 'localhost:8000';
$_SERVER['SERVER_PORT'] = $_SERVER['SERVER_PORT'] ?? '8000';
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

$plans = ORM::for_table('tbl_plans')
    ->where_raw("type = 'Hotspot'")
    ->order_by_asc('price')
    ->find_many();

$result = [];
foreach ($plans as $plan) {
    $validityDays = 0;
    $category = '';

    if ($plan['validity_unit'] == 'Days') {
        $validityDays = (int) $plan['validity'];
    } elseif ($plan['validity_unit'] == 'Months') {
        $validityDays = (int) $plan['validity'] * 30;
    } elseif ($plan['validity_unit'] == 'Hrs') {
        $validityDays = 1;
    } elseif ($plan['validity_unit'] == 'Mins') {
        $validityDays = 1;
    }

    if ($validityDays <= 1) {
        $category = 'harian';
       
    } elseif ($validityDays <= 7) {
        $category = 'mingguan';
    } else {
        $category = 'bulanan';
    }

    $bw = null;
    if (!empty($plan['id_bw'])) {
        $bw = ORM::for_table('tbl_bandwidth')->find_one($plan['id_bw']);
    }

    $result[] = [
        'id' => (int) $plan['id'],
        'name' => $plan['name_plan'],
        'price' => (int) $plan['price'],
        'price_formatted' => 'Rp ' . number_format($plan['price'], 0, ',', '.'),
        'type' => $plan['type'],
        'validity_days' => $validityDays,
        'category' => $category,
        'speed_down' => $bw ? $bw['rate_down'] . ' ' . $bw['rate_down_unit'] : '',
        'speed_up' => $bw ? $bw['rate_up'] . ' ' . $bw['rate_up_unit'] : '',
        'bw_name' => $bw ? $bw['name_bw'] : '',
    ];
}

echo json_encode($result, JSON_PRETTY_PRINT);
