<?php

register_menu('Postpaid Upgrade', true, 'postpaid_admin', 'SETTINGS', '', '', '');

function postpaid_admin()
{
    global $ui, $config;
    _admin();
    $admin = Admin::_info();

    if (_post('save') == 'yes') {
        $enable = _post('postpaid_upgrade_enable') ? 'yes' : 'no';
        $onlyUp = _post('postpaid_upgrade_only_up') ? 'yes' : 'no';
        $d = ORM::for_table('tbl_appconfig')->where('setting', 'postpaid_upgrade_enable')->find_one();
        if ($d) {
            $d->value = $enable;
            $d->save();
        } else {
            $d = ORM::for_table('tbl_appconfig')->create();
            $d->setting = 'postpaid_upgrade_enable';
            $d->value = $enable;
            $d->save();
        }
        $d = ORM::for_table('tbl_appconfig')->where('setting', 'postpaid_upgrade_only_up')->find_one();
        if ($d) {
            $d->value = $onlyUp;
            $d->save();
        } else {
            $d = ORM::for_table('tbl_appconfig')->create();
            $d->setting = 'postpaid_upgrade_only_up';
            $d->value = $onlyUp;
            $d->save();
        }
        r2(getUrl('plugin/postpaid_admin'), 's', 'Settings saved');
    }

    $enable = $config['postpaid_upgrade_enable'] ?? 'yes';
    $onlyUp = $config['postpaid_upgrade_only_up'] ?? 'yes';

    $ui->assign('_title', 'Postpaid Upgrade Plugin');
    $ui->assign('_system_menu', 'plugin/postpaid_admin');
    $ui->assign('_admin', $admin);
    $ui->assign('enable', $enable);
    $ui->assign('only_up', $onlyUp);
    $ui->display('postpaid_admin.tpl');
}

function postpaid_page()
{
    global $ui, $config;
    _auth();
    $user = User::_info();

    $active = ORM::for_table('tbl_user_recharges')
        ->where('username', $user['username'])
        ->where('type', 'PPPOE')
        ->where('status', 'on')
        ->find_one();

    $activePlan = null;
    $activeBw = null;
    if ($active) {
        $activePlan = ORM::for_table('tbl_plans')->find_one($active['plan_id']);
        if ($activePlan && $activePlan['id_bw']) {
            $activeBw = ORM::for_table('tbl_bandwidth')->find_one($activePlan['id_bw']);
        }
    }

    $onlyUp = $config['postpaid_upgrade_only_up'] ?? 'yes';

    $postpaidPlans = ORM::for_table('tbl_plans')
        ->where('type', 'PPPOE')
        ->where('prepaid', 'no')
        ->where('enabled', 1)
        ->find_many();

    $prepaidPlans = ORM::for_table('tbl_plans')
        ->where('type', 'Hotspot')
        ->where('prepaid', 'yes')
        ->where('enabled', 1)
        ->find_many();

    $postpaidBws = [];
    $prepaidBws = [];
    foreach ($postpaidPlans as $p) {
        if ($p['id_bw']) {
            $bw = ORM::for_table('tbl_bandwidth')->find_one($p['id_bw']);
            if ($bw) $postpaidBws[$p['id']] = $bw;
        }
    }
    foreach ($prepaidPlans as $p) {
        if ($p['id_bw']) {
            $bw = ORM::for_table('tbl_bandwidth')->find_one($p['id_bw']);
            if ($bw) $prepaidBws[$p['id']] = $bw;
        }
    }

    $dayExp = 20;
    if ($active && $activePlan && $activePlan['validity_unit'] == 'Period') {
        $dayExp = (int) ($activePlan['expired_date'] ?: 20);
    }

    $ui->assign('_title', 'Package');
    $ui->assign('_system_menu', 'package');
    $ui->assign('user', $user);
    $ui->assign('active', $active);
    $ui->assign('activePlan', $activePlan);
    $ui->assign('activeBw', $activeBw);
    $ui->assign('only_up', $onlyUp);
    $ui->assign('dayExp', $dayExp);
    $ui->assign('postpaidPlans', $postpaidPlans);
    $ui->assign('prepaidPlans', $prepaidPlans);
    $ui->assign('postpaidBws', $postpaidBws);
    $ui->assign('prepaidBws', $prepaidBws);
    $ui->display('postpaid.tpl');
}

function postpaid_upgrade_exec()
{
    _auth();
    $user = User::_info();
    $planId = (int) _req('plan_id');

    if (!$planId) {
        r2(U . 'plugin/postpaid_page', 'e', 'Invalid plan');
    }

    $plan = ORM::for_table('tbl_plans')
        ->where('id', $planId)
        ->where('enabled', 1)
        ->find_one();
    if (!$plan) {
        r2(U . 'plugin/postpaid_page', 'e', 'Plan not found');
    }

    $active = ORM::for_table('tbl_user_recharges')
        ->where('username', $user['username'])
        ->where('type', 'PPPOE')
        ->where('status', 'on')
        ->find_one();

    $total = (int) $plan['price'];
    if ($active) {
        $oldPlan = ORM::for_table('tbl_plans')->find_one($active['plan_id']);
        if ($oldPlan && $oldPlan['validity_unit'] == 'Period') {
            $total = _postpaid_calc_prorated($oldPlan, $plan);
        }
    }

    Package::rechargeUser($user['id'], $plan['routers'] ?: 'Router Utama', $planId, 'postpaid', 'Upgrade');

    $inv = ORM::for_table('tbl_customers_fields')
        ->where('customer_id', $user['id'])
        ->where('field_name', 'Invoice')
        ->find_one();
    if ($inv) {
        $inv->field_value = $total;
        $inv->save();
    } else {
        $inv = ORM::for_table('tbl_customers_fields')->create();
        $inv->customer_id = $user['id'];
        $inv->field_name = 'Invoice';
        $inv->field_value = $total;
        $inv->save();
    }

    r2(U . 'plugin/postpaid_page', 's', 'Paket berhasil diupgrade. Invoice: Rp ' . number_format($total, 0, ',', '.'));
}

function _postpaid_calc_prorated($oldPlan, $newPlan)
{
    $dayExp = (int) ($oldPlan['expired_date'] ?: 20);
    $today = new DateTime(date('Y-m-d'));
    $d = (int) $today->format('d');

    if ($d <= $dayExp) {
        $prevMonth = clone $today;
        $prevMonth->modify('-1 month');
        $periodStart = new DateTime($prevMonth->format('Y-m-') . str_pad($dayExp, 2, '0', STR_PAD_LEFT));
        $periodEnd = new DateTime($today->format('Y-m-') . str_pad($dayExp, 2, '0', STR_PAD_LEFT));
    } else {
        $periodStart = new DateTime($today->format('Y-m-') . str_pad($dayExp, 2, '0', STR_PAD_LEFT));
        $nextMonth = clone $today;
        $nextMonth->modify('+1 month');
        $periodEnd = new DateTime($nextMonth->format('Y-m-') . str_pad($dayExp, 2, '0', STR_PAD_LEFT));
    }

    $daysInPeriod = (int) $periodStart->diff($periodEnd)->days;
    if ($daysInPeriod <= 0) $daysInPeriod = 30;

    $daysUsed = (int) $periodStart->diff($today)->days;
    $daysRemaining = (int) $today->diff($periodEnd)->days;

    $oldDaily = $oldPlan['price'] / $daysInPeriod;
    $newDaily = $newPlan['price'] / $daysInPeriod;

    return (int) round($oldDaily * $daysUsed + $newDaily * $daysRemaining);
}
