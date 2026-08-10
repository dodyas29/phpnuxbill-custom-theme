<?php
session_start();
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

// POST — Device actions (disconnect / block) or Save WiFi
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    if (!$input) {
        http_response_code(400);
        echo json_encode(['error' => 'Invalid request']);
        exit;
    }

    // Device actions: disconnect / block
    if (isset($input['action']) && isset($input['mac'])) {
        $action = $input['action'];
        $mac = $input['mac'];
        $band = $input['band'] ?? '';
        // TODO: GenieACS plugin — call GenieACS API here
        echo json_encode([
            'success' => true,
            'action' => $action,
            'mac' => $mac,
            'message' => $action === 'disconnect' ? 'Perangkat diputuskan' : 'Perangkat diblokir'
        ]);
        exit;
    }

    // WiFi settings
    if (empty($input['band']) || !isset($input['ssid'])) {
        http_response_code(400);
        echo json_encode(['error' => 'Invalid request']);
        exit;
    }
    $band = $input['band'];
    $ssid = substr($input['ssid'], 0, 64);
    $password = isset($input['password']) ? substr($input['password'], 0, 64) : '';

    $wifi = ORM::for_table('tbl_custom_wifi')
        ->where('user_id', $uid)
        ->where('band', $band)
        ->find_one();
    if (!$wifi) {
        $wifi = ORM::for_table('tbl_custom_wifi')->create();
        $wifi->user_id = $uid;
        $wifi->band = $band;
    }
    $wifi->ssid = $ssid;
    $wifi->password = $password;
    $wifi->save();

    echo json_encode(['success' => true, 'band' => $band, 'ssid' => $ssid]);
    exit;
}

// GET — Return network status data
// WiFi: read from DB first, fallback to dummy
$wifi24 = ORM::for_table('tbl_custom_wifi')
    ->where('user_id', $uid)->where('band', '24g')->find_one();
$wifi5  = ORM::for_table('tbl_custom_wifi')
    ->where('user_id', $uid)->where('band', '5g')->find_one();

$data_24g = $wifi24
    ? ['ssid' => $wifi24['ssid'], 'password' => $wifi24['password'], 'devices' => 5, 'connected_devices' => [
        ['hostname' => 'iPhone-Andre',     'ip' => '192.168.1.101', 'mac' => 'AA:BB:CC:11:22:33', 'connected_since' => '3 jam'],
        ['hostname' => 'Laptop-Kerja',     'ip' => '192.168.1.102', 'mac' => 'AA:BB:CC:11:22:44', 'connected_since' => '1 jam'],
        ['hostname' => 'Smart-TV-Ruang',   'ip' => '192.168.1.103', 'mac' => 'AA:BB:CC:11:22:55', 'connected_since' => '5 jam'],
        ['hostname' => 'Android-Ibu',      'ip' => '192.168.1.104', 'mac' => 'AA:BB:CC:11:22:66', 'connected_since' => '30 menit'],
        ['hostname' => 'iPad-Anak',         'ip' => '192.168.1.105', 'mac' => 'AA:BB:CC:11:22:77', 'connected_since' => '2 jam'],
    ]]
    : ['ssid' => 'WifiRumah24', 'password' => 'rahasia123', 'devices' => 5, 'connected_devices' => [
        ['hostname' => 'iPhone-Andre',    'ip' => '192.168.1.101', 'mac' => 'AA:BB:CC:11:22:33', 'connected_since' => '3 jam'],
        ['hostname' => 'Laptop-Kerja',    'ip' => '192.168.1.102', 'mac' => 'AA:BB:CC:11:22:44', 'connected_since' => '1 jam'],
        ['hostname' => 'Smart-TV-Ruang',  'ip' => '192.168.1.103', 'mac' => 'AA:BB:CC:11:22:55', 'connected_since' => '5 jam'],
        ['hostname' => 'Android-Ibu',     'ip' => '192.168.1.104', 'mac' => 'AA:BB:CC:11:22:66', 'connected_since' => '30 menit'],
        ['hostname' => 'iPad-Anak',       'ip' => '192.168.1.105', 'mac' => 'AA:BB:CC:11:22:77', 'connected_since' => '2 jam'],
    ]];

$data_5g  = $wifi5
    ? ['ssid' => $wifi5['ssid'], 'password' => $wifi5['password'], 'devices' => 2, 'connected_devices' => [
        ['hostname' => 'MacBook-Pro',    'ip' => '192.168.1.201', 'mac' => 'BB:CC:DD:11:22:33', 'connected_since' => '45 menit'],
        ['hostname' => 'Samsung-Galaxy', 'ip' => '192.168.1.202', 'mac' => 'BB:CC:DD:11:22:44', 'connected_since' => '15 menit'],
    ]]
    : ['ssid' => 'WifiRumah5G', 'password' => 'rahasia456', 'devices' => 2, 'connected_devices' => [
        ['hostname' => 'MacBook-Pro',    'ip' => '192.168.1.201', 'mac' => 'BB:CC:DD:11:22:33', 'connected_since' => '45 menit'],
        ['hostname' => 'Samsung-Galaxy', 'ip' => '192.168.1.202', 'mac' => 'BB:CC:DD:11:22:44', 'connected_since' => '15 menit'],
    ]];

echo json_encode([
    'modem' => [
        'model' => 'ONT HG8245H',
        'status' => 'online',
        'rx_power' => '-' . round(16 + mt_rand(0, 120) / 10, 1) . ' dBm',
    ],
    'bandwidth' => [
        'down' => (40 + rand(0, 15)) . ' Mbps',
        'up' => (18 + rand(0, 10)) . ' Mbps',
    ],
    'last_disconnect' => [
        'date' => '05-08-2026',
        'time' => '14:32 WIB',
        'reason' => 'User request',
        'duration' => '3 jam 12 menit',
    ],
    'wifi_24g' => $data_24g,
    'wifi_5g'  => $data_5g,
], JSON_PRETTY_PRINT);
