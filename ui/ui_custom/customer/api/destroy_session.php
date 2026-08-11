<?php
session_start();
setcookie('uid', '', time() - 3600, '/');
session_destroy();
header('Content-Type: application/json; charset=utf-8');
echo json_encode(['success' => true]);
