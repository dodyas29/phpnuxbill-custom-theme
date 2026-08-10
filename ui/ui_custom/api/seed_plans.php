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

$bwData = [
    ['name' => '5 Mbps', 'rate_down' => '5', 'rate_up' => '2', 'rate_down_unit' => 'Mbps', 'rate_up_unit' => 'Mbps'],
    ['name' => '10 Mbps', 'rate_down' => '10', 'rate_up' => '5', 'rate_down_unit' => 'Mbps', 'rate_up_unit' => 'Mbps'],
    ['name' => '20 Mbps', 'rate_down' => '20', 'rate_up' => '10', 'rate_down_unit' => 'Mbps', 'rate_up_unit' => 'Mbps'],
];

$bwIds = [];
foreach ($bwData as $bw) {
    $existing = ORM::for_table('tbl_bandwidth')->where('name_bw', $bw['name'])->find_one();
    if ($existing) {
        $bwIds[$bw['name']] = $existing->id;
    } else {
        $d = ORM::for_table('tbl_bandwidth')->create();
        $d->name_bw = $bw['name'];
        $d->rate_down = $bw['rate_down'];
        $d->rate_up = $bw['rate_up'];
        $d->rate_down_unit = $bw['rate_down_unit'];
        $d->rate_up_unit = $bw['rate_up_unit'];
        $d->save();
        $bwIds[$bw['name']] = $d->id;
    }
}

$planData = [
    ['name' => 'Harian 5Mbps', 'price' => 5000, 'validity' => 1, 'validity_unit' => 'Days', 'bw' => '5 Mbps'],
    ['name' => 'Mingguan 10Mbps', 'price' => 25000, 'validity' => 7, 'validity_unit' => 'Days', 'bw' => '10 Mbps'],
    ['name' => 'Bulanan 20Mbps', 'price' => 100000, 'validity' => 30, 'validity_unit' => 'Days', 'bw' => '20 Mbps'],
];

$created = [];
$skipped = [];

foreach ($planData as $plan) {
    $existing = ORM::for_table('tbl_plans')->where('name_plan', $plan['name'])->find_one();
    if ($existing) {
        $skipped[] = $plan['name'];
    } else {
        $d = ORM::for_table('tbl_plans')->create();
        $d->name_plan = $plan['name'];
        $d->price = $plan['price'];
        $d->type = 'Hotspot';
        $d->validity = $plan['validity'];
        $d->validity_unit = $plan['validity_unit'];
        $d->enabled = '1';
        $d->id_bw = $bwIds[$plan['bw']] ?? 0;
        $d->is_radius = '0';
        $d->shared = '0';
        $d->save();
        $created[] = $plan['name'];
    }
}

echo json_encode([
    'bandwidths' => count($bwData),
    'plans_created' => $created,
    'plans_skipped' => $skipped,
], JSON_PRETTY_PRINT);
