<?php
session_start();
$root_path = realpath(__DIR__ . '/../../../../');
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
$phone = preg_replace('/[^0-9]/', '', $input['phone'] ?? '');

if (strlen($phone) < 10 || strlen($phone) > 15) {
    echo json_encode(['success' => false, 'message' => 'Invalid phone number']);
    exit;
}

if (!empty($_SESSION['reg_otp']) && time() - ($_SESSION['reg_otp']['sent_at'] ?? 0) < 30) {
    echo json_encode(['success' => false, 'message' => 'Please wait 30 seconds before requesting again']);
    exit;
}

$code = str_pad(rand(0, 999999), 6, '0', STR_PAD_LEFT);

$_SESSION['reg_otp'] = [
    'code' => $code,
    'phone' => $phone,
    'sent_at' => time(),
    'attempts' => ($_SESSION['reg_otp']['send_count'] ?? 0) + 1,
];

$_SESSION['guest_wa'] = $phone;

$sent = Message::sendWhatsapp($phone, "Kode verifikasi Anda: *$code*\n\nJangan berikan kode ini kepada siapapun.");

echo json_encode(['success' => true, 'message' => 'OTP sent']);
