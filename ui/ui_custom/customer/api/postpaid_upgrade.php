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

if (!$planId) {
    echo json_encode(['success' => false, 'error' => 'Missing plan_id']);
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

$active = ORM::for_table('tbl_user_recharges')
    ->where('username', $user['username'])
    ->where('type', 'PPPOE')
    ->where('status', 'on')
    ->find_one();

$total = (float) $plan['price'];
$breakdown = null;
$isUpgrade = false;

if ($active) {
    $oldPlan = ORM::for_table('tbl_plans')->find_one($active['plan_id']);
    if ($oldPlan && $oldPlan['validity_unit'] == 'Period') {
        $isUpgrade = true;
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

        $oldDaily = $oldPlan['price'] / $daysInPeriod;
        $newDaily = $plan['price'] / $daysInPeriod;
        $oldPortion = round($oldDaily * $daysUsed);
        $newPortion = round($newDaily * $daysRemaining);
        $total = $oldPortion + $newPortion;

        $breakdown = [
            'is_upgrade' => true,
            'old_plan' => $oldPlan['name_plan'],
            'new_plan' => $plan['name_plan'],
            'old_price' => (int) $oldPlan['price'],
            'new_price' => (int) $plan['price'],
            'days_in_period' => $daysInPeriod,
            'days_used' => $daysUsed,
            'days_remaining' => $daysRemaining,
            'daily_old' => round($oldDaily),
            'daily_new' => round($newDaily),
            'old_portion' => $oldPortion,
            'new_portion' => $newPortion,
            'total' => $total,
        ];
    }
}

echo json_encode(['success' => true, 'total' => $total, 'breakdown' => $breakdown], JSON_PRETTY_PRINT);
