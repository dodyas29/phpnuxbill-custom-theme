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

$colors = [
    'BCAVA' => '#0066AE', 'BNIVA' => '#0095D7', 'BRIVA' => '#005098', 'MANDIRIVA' => '#00529B',
    'PERMATAVA' => '#FCB816', 'MYBVA' => '#F5CC07', 'BSIVA' => '#006A5B', 'SMSVA' => '#E3191E',
    'MUAMALATVA' => '#D82B27', 'SAMPOERNAVA' => '#A0522D',
    'ALFAMART' => '#E3191E', 'INDOMARET' => '#164A98', 'ALFAMIDI' => '#7BC143',
    'DANA' => '#108DE5', 'OVO' => '#4C2882', 'SHOPEEPAY' => '#EE4D2D',
    'QRIS' => '#B71C1C', 'QRISC' => '#B71C1C', 'QRIS2' => '#B71C1C',
];

$logoMap = [
    'BCAVA' => 'bca.png', 'BNIVA' => 'bni.png', 'BRIVA' => 'bri.png', 'MANDIRIVA' => 'mandiri.png',
    'PERMATAVA' => 'permata.png', 'MYBVA' => 'maybank.png', 'BSIVA' => 'bsi.png',
    'SMSVA' => 'sinarmas.png', 'MUAMALATVA' => 'muamalat.png',
    'DANA' => 'dana.png', 'OVO' => 'ovo.png', 'SHOPEEPAY' => 'shopeepay.png',
    'QRIS' => 'qris.png', 'QRISC' => 'qris.png', 'QRIS2' => 'qris.png',
];

$result = [];
foreach ($channels as $ch) {
    if (empty($enabled) || in_array($ch['id'], $enabled)) {
        $result[] = [
            'id' => $ch['id'],
            'name' => $ch['name'],
            'icon' => $icons[$ch['id']] ?? 'bi-credit-card',
            'color' => $colors[$ch['id']] ?? '#666',
            'logo' => isset($logoMap[$ch['id']]) ? 'assets/logo/' . $logoMap[$ch['id']] : '',
            'init' => preg_replace('/\s.*/', '', $ch['name']),
        ];
    }
}

echo json_encode($result, JSON_PRETTY_PRINT);
