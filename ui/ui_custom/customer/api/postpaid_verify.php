<?php
session_start();
$root_path = realpath(__DIR__ . '/../../../../');
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

$user = User::_info();
$input = json_decode(file_get_contents('php://input'), true);
$image = trim($input['image'] ?? '');
$type = trim($input['type'] ?? '');
$planId = (int) ($input['plan_id'] ?? 0);

if (!$image || !$type || !$planId) {
    echo json_encode(['success' => false, 'error' => 'Missing image, type, or plan_id']);
    exit;
}

$uploadDir = $root_path . '/system/uploads/verify/';
if (!is_dir($uploadDir)) mkdir($uploadDir, 0755, true);

$ext = 'jpg';
if (strpos($image, 'data:image/png') === 0) $ext = 'png';
elseif (strpos($image, 'data:image/jpeg') === 0) $ext = 'jpg';
elseif (strpos($image, 'data:image/webp') === 0) $ext = 'webp';

$imageData = base64_decode(preg_replace('#^data:image/\w+;base64,#i', '', $image));
if (!$imageData) {
    echo json_encode(['success' => false, 'error' => 'Invalid image data']);
    exit;
}

$filename = $user['username'] . '_' . $type . '_' . date('YmdHis') . '.' . $ext;
$filepath = $uploadDir . $filename;

if (file_put_contents($filepath, $imageData)) {
    echo json_encode(['success' => true, 'filename' => $filename]);
} else {
    echo json_encode(['success' => false, 'error' => 'Failed to save image']);
}
