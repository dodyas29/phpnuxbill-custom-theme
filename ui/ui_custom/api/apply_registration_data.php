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
    echo json_encode(['success' => false, 'message' => 'Not logged in']);
    exit;
}

$uid = $_SESSION['uid'];
$result = [];

if (!empty($_SESSION['guest_coords'])) {
    $d = ORM::for_table('tbl_customers')->find_one($uid);
    if ($d) {
        $d->coordinates = $_SESSION['guest_coords'];
        $result['coordinates'] = true;
    }
    unset($_SESSION['guest_coords']);
}

if (!empty($_SESSION['guest_wa'])) {
    $d = ORM::for_table('tbl_customers')->find_one($uid);
    if ($d) {
        $d->phonenumber = $_SESSION['guest_wa'];
        $result['phone'] = true;
    }
    unset($_SESSION['guest_wa'], $_SESSION['guest_wa_verified'], $_SESSION['reg_otp']);
}

if (!empty($d)) $d->save();

echo json_encode(['success' => true, 'applied' => $result]);
