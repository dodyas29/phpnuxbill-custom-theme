<?php
session_start();
$root_path = realpath(__DIR__ . '/../../');
$_SERVER['HTTP_HOST'] = $_SERVER['HTTP_HOST'] ?? 'localhost:8000';
$_SERVER['SERVER_PORT'] = $_SERVER['SERVER_PORT'] ?? '8000';
$_SERVER['SCRIPT_NAME'] = $_SERVER['SCRIPT_NAME'] ?? '/index.php';
require_once $root_path . '/config.php';
require_once $root_path . '/system/vendor/autoload.php';
require_once $root_path . '/init.php';
require_once $root_path . '/system/boot.php';

if (!User::getID()) {
    r2(getUrl('login'));
}

$user = User::_info();
$ui->assign('_title', 'Beli Voucher');
$ui->assign('_user', $user);

if (isset($_SESSION['notify'])) {
    $ui->assign('notify', $_SESSION['notify']);
    $ui->assign('notify_t', $_SESSION['ntype']);
    unset($_SESSION['notify'], $_SESSION['ntype']);
}

$ui->display('customer/voucher-buy.tpl');
