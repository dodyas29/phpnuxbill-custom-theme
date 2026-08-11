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
