<?php

function tripay_show_payment(){
    global $ui;
    //get trx_id
    $id = _get('id');
    if(empty($id)){
        r2(U . "order/package/", 'e', 'Tidak ada ID Transaksi');
    }
    _auth();
    $user = User::_info();
    $ui->assign('_user', $user);
    $trx = ORM::for_table('tbl_payment_gateway')->find_one($id);
    if(empty($id)){
        r2(U . "order/package/", 'e', 'Transaksi tidak ditemukan');
    }
    $json = json_decode($trx['pg_request'], true);
    $ui->assign('instruction', $json['data']['instructions']);
    if(isset($json['data']['qr_string'])){
        $ui->assign('qr_string', $json['data']['qr_string']);
        $ui->assign('qr_url', $json['data']['qr_url']);
    }
    $ui->assign('checkout_url', $json['data']['checkout_url']);
    $ui->assign('payment_name', $json['data']['payment_name']);
    $ui->assign('trxid', $id);
    $ui->assign('_title', 'Tripay Payment Gateway');
    $ui->display('tripay_view_payment.tpl');
}