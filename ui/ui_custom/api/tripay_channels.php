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

$channels = json_decode(file_get_contents($root_path . '/system/paymentgateway/channel_tripay.json'), true);
$enabled = isset($config['tripay_channel']) ? explode(',', $config['tripay_channel']) : [];

$icons = [
    'QRIS' => 'bi-qr-code-scan', 'QRISC' => 'bi-qr-code-scan', 'QRIS2' => 'bi-qr-code-scan',
    'MANDIRIVA' => 'bi-building', 'BCAVA' => 'bi-building', 'BNIVA' => 'bi-building',
    'BRIVA' => 'bi-building', 'PERMATAVA' => 'bi-building', 'MYBVA' => 'bi-building',
    'SMSVA' => 'bi-building', 'MUAMALATVA' => 'bi-building', 'BSIVA' => 'bi-building',
    'ALFAMART' => 'bi-shop', 'INDOMARET' => 'bi-shop', 'ALFAMIDI' => 'bi-shop',
    'DANA' => 'bi-wallet2', 'OVO' => 'bi-wallet2', 'SHOPEEPAY' => 'bi-wallet2',
    'SAMPOERNAVA' => 'bi-building',
];

$result = [];
foreach ($channels as $ch) {
    if (empty($enabled) || in_array($ch['id'], $enabled)) {
        $result[] = [
            'id' => $ch['id'],
            'name' => $ch['name'],
            'icon' => $icons[$ch['id']] ?? 'bi-credit-card',
        ];
    }
}

echo json_encode($result, JSON_PRETTY_PRINT);
