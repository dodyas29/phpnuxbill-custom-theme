<?php
$root_path = realpath(__DIR__ . '/../../../../') . DIRECTORY_SEPARATOR;
$_SERVER['HTTP_HOST'] = 'localhost';
$_SERVER['SERVER_PORT'] = '8000';
$_SERVER['SCRIPT_NAME'] = '/index.php';
require $root_path . 'config.php';
require $root_path . 'system/vendor/autoload.php';
require $root_path . 'init.php';

$configs = [
    'enable_balance' => 'yes',
    'allow_balance_custom' => 'yes',
    'allow_balance_transfer' => 'yes',
    'minimum_transfer' => '1000',
];

foreach ($configs as $key => $val) {
    $d = ORM::for_table('tbl_appconfig')->where('setting', $key)->find_one();
    if ($d) {
        $d->value = $val;
        $d->save();
        echo "CONFIG: $key = $val (updated)\n";
    } else {
        $d = ORM::for_table('tbl_appconfig')->create();
        $d->setting = $key;
        $d->value = $val;
        $d->save();
        echo "CONFIG: $key = $val (created)\n";
    }
}

$plans = [
    ['name' => 'Top Up 10K', 'price' => 10000],
    ['name' => 'Top Up 20K', 'price' => 20000],
    ['name' => 'Top Up 50K', 'price' => 50000],
    ['name' => 'Top Up 100K', 'price' => 100000],
];

foreach ($plans as $plan) {
    $e = ORM::for_table('tbl_plans')->where('name_plan', $plan['name'])->find_one();
    if ($e) { echo "SKIP: {$plan['name']}\n"; continue; }
    $d = ORM::for_table('tbl_plans')->create();
    $d->name_plan = $plan['name'];
    $d->price = $plan['price'];
    $d->type = 'Balance';
    $d->prepaid = 'yes';
    $d->enabled = '1';
    $d->validity = '1';
    $d->validity_unit = 'Months';
    $d->save();
    echo "PLAN: {$plan['name']} (id: {$d->id})\n";
}

echo "DONE\n";
