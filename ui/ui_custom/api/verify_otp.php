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

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['success' => false, 'message' => 'Invalid method']);
    exit;
}

$input = json_decode(file_get_contents('php://input'), true);
$code = trim($input['code'] ?? '');

if (empty($_SESSION['reg_otp'])) {
    echo json_encode(['success' => false, 'message' => 'No verification code requested']);
    exit;
}

if (time() - ($_SESSION['reg_otp']['sent_at'] ?? 0) > 300) {
    unset($_SESSION['reg_otp']);
    echo json_encode(['success' => false, 'message' => 'Verification code expired']);
    exit;
}

if ($code !== $_SESSION['reg_otp']['code']) {
    echo json_encode(['success' => false, 'message' => 'Invalid verification code']);
    exit;
}

$_SESSION['reg_otp']['verified'] = true;
$_SESSION['guest_wa_verified'] = true;
echo json_encode(['success' => true, 'message' => 'Verification successful']);
