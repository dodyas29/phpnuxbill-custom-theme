<?php
register_hook('register_user', 'save_registration_coords');
function save_registration_coords($user) {
    if (!empty($_SESSION['guest_coords'])) {
        $d = ORM::for_table('tbl_customers')->find_one($user['id']);
        if ($d) {
            $d->coordinates = $_SESSION['guest_coords'];
            $d->save();
        }
        unset($_SESSION['guest_coords']);
    }
    if (!empty($_SESSION['guest_wa'])) {
        $d = ORM::for_table('tbl_customers')->find_one($user['id']);
        if ($d && empty($d->phonenumber)) {
            $d->phonenumber = $_SESSION['guest_wa'];
            $d->save();
        }
        unset($_SESSION['guest_wa'], $_SESSION['guest_wa_verified'], $_SESSION['reg_otp']);
    }
}
