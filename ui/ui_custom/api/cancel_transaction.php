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
$trxId = (int) ($input['trx_id'] ?? 0);
$user = User::_info();

$trx = ORM::for_table('tbl_payment_gateway')
    ->where('id', $trxId)
    ->where('username', $user['username'])
    ->find_one();

if (!$trx) {
    echo json_encode(['success' => false, 'error' => 'Transaction not found']);
    exit;
}

if ($trx['status'] != 1) {
    echo json_encode(['success' => false, 'error' => 'Transaction is not unpaid']);
    exit;
}

$trx->pg_paid_response = '{}';
$trx->status = 4;
$trx->save();

echo json_encode(['success' => true]);
