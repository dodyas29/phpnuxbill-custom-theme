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
    echo json_encode(['success' => false, 'message' => 'Invalid request']);
    exit;
}

$input = json_decode(file_get_contents('php://input'), true);
$password = trim($input['password'] ?? '');
$npass = trim($input['npass'] ?? '');
$cnpass = trim($input['cnpass'] ?? '');

if (empty($password) || empty($npass) || empty($cnpass)) {
    echo json_encode(['success' => false, 'message' => 'All fields are required']);
    exit;
}

if (strlen($npass) < 2 || strlen($npass) > 35) {
    echo json_encode(['success' => false, 'message' => 'New Password must be 2 to 35 characters']);
    exit;
}

if ($npass !== $cnpass) {
    echo json_encode(['success' => false, 'message' => 'Both passwords should be the same']);
    exit;
}

$user = User::_info();
if ($password !== $user['password']) {
    echo json_encode(['success' => false, 'message' => 'Incorrect current password']);
    exit;
}

$user->password = $npass;
$user->save();

$turs = ORM::for_table('tbl_user_recharges')->where('customer_id', $user['id'])->find_many();
foreach ($turs as $tur) {
    if ($tur['status'] == 'on') {
        $p = ORM::for_table('tbl_plans')->where('id', $tur['plan_id'])->find_one();
        if ($p) {
            $dvc = Package::getDevice($p);
            if ($_app_stage != 'demo') {
                if (file_exists($dvc)) {
                    require_once $dvc;
                    (new $p['device'])->add_customer($user, $p);
                }
            }
        }
    }
}

User::removeCookie();
session_destroy();

echo json_encode(['success' => true, 'message' => 'Password changed successfully', 'redirect' => APP_URL . '/?_route=login']);
