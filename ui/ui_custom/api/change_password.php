<?php
session_start();
$root_path = realpath(__DIR__ . '/../../../') . DIRECTORY_SEPARATOR;
$_SERVER['HTTP_HOST'] = $_SERVER['HTTP_HOST'] ?? 'localhost:8000';
$_SERVER['SERVER_PORT'] = $_SERVER['SERVER_PORT'] ?? '8000';
$_SERVER['SCRIPT_NAME'] = '/index.php';

require_once $root_path . 'config.php';

$autoload_root = $root_path;
spl_autoload_register(function($class) use ($autoload_root) {
    $class = str_replace(['_', '\\'], DIRECTORY_SEPARATOR, $class);
    $file = $autoload_root . 'system' . DIRECTORY_SEPARATOR . 'autoload' . DIRECTORY_SEPARATOR . $class . '.php';
    if (file_exists($file)) include $file;
});

require_once $root_path . 'system/orm.php';
ORM::configure("mysql:host=$db_host;dbname=$db_name");
ORM::configure('username', $db_user);
ORM::configure('password', $db_pass);
ORM::configure('return_result_sets', true);

function _uid() {
    if (!empty($_SESSION['uid'])) return $_SESSION['uid'];
    if (!empty($_COOKIE['uid'])) {
        $t = explode('.', $_COOKIE['uid']);
        global $db_pass;
        if (sha1($t[0] . '.' . $t[1] . '.' . $db_pass) == $t[2]) {
            if (time() - $t[1] < 86400 * 30) {
                $_SESSION['uid'] = $t[0];
                return $t[0];
            }
        }
    }
    return 0;
}

$protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
$host = $_SERVER['HTTP_HOST'] ?? 'localhost';
$base = rtrim(dirname('/index.php'), '/\\');
$APP_URL = $protocol . '://' . $host . $base;

header('Content-Type: application/json; charset=utf-8');

if ($_SERVER['REQUEST_METHOD'] !== 'POST' || !_uid()) {
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

$uid = _uid();
$user = ORM::for_table('tbl_customers')->find_one($uid);
if (!$user) {
    echo json_encode(['success' => false, 'message' => 'User not found']);
    exit;
}

if ($password != $user->password) {
    echo json_encode(['success' => false, 'message' => 'Incorrect current password']);
    exit;
}

$user->password = $npass;
$user->save();

// store user data for shutdown
$userData = ['id' => $user->id, 'username' => $user->username, 'fullname' => $user->fullname, 'email' => $user->email, 'phonenumber' => $user->phonenumber];

setcookie('uid', '', time() - 3600, '/');
session_destroy();

ignore_user_abort(true);
register_shutdown_function(function () use ($uid, $root_path) {
    $turs = ORM::for_table('tbl_user_recharges')->where('customer_id', $uid)->find_many();
    foreach ($turs as $tur) {
        if ($tur['status'] == 'on') {
            $p = ORM::for_table('tbl_plans')->where('id', $tur['plan_id'])->find_one();
            if ($p && !empty($p['device'])) {
                $dvc = $root_path . 'system' . DIRECTORY_SEPARATOR . 'devices' . DIRECTORY_SEPARATOR . $p['device'] . '.php';
                if (file_exists($dvc)) {
                    try {
                        require_once $dvc;
                        $u = ORM::for_table('tbl_customers')->find_one($uid);
                        (new $p['device'])->add_customer($u, $p);
                    } catch (\Throwable $e) {}
                }
            }
        }
    }
});

echo json_encode(['success' => true, 'message' => 'Password changed successfully', 'redirect' => $APP_URL . '/?_route=login']);
