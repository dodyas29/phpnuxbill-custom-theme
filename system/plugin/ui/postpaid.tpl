<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover, user-scalable=no">
<meta name="theme-color" content="#09090b">
<title>{$_title} &mdash; {$_c['CompanyName']}</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<link rel="stylesheet" href="{$app_url}/ui/ui_custom/customer/assets/css/style.css?v=3">
<script>var appUrl='{$app_url}';var CSRF='{$csrf_token}';var userLang='{$user_language}';</script>
<style>
{literal}
.pp-offer{display:flex;gap:12px;margin-bottom:16px;overflow:hidden}
.pp-card{cursor:pointer;flex:1;min-width:0;background:var(--bgs);border:2px solid var(--bd);border-radius:var(--r3);padding:20px 16px;transition:all .35s cubic-bezier(.4,0,.2,1);text-align:center;position:relative;overflow:hidden}
.pp-card::before{content:'';position:absolute;inset:0;opacity:0;transition:opacity .35s}
.pp-card.prepaid::before{background:linear-gradient(135deg,rgba(129,140,248,.08),rgba(167,139,250,.04))}
.pp-card.postpaid::before{background:linear-gradient(135deg,rgba(52,211,153,.08),rgba(56,189,248,.04))}
.pp-card.selected::before{opacity:1}
.pp-card.selected{border-color:var(--c1);transform:scale(1.02);box-shadow:0 4px 24px rgba(129,140,248,.15)}
.pp-card.postpaid.selected{border-color:var(--c4);box-shadow:0 4px 24px rgba(52,211,153,.12)}
.pp-card.removing{flex:0;opacity:0;padding:20px 0;margin:0;border-width:0;overflow:hidden}
.pp-card-icon{font-size:2rem;margin-bottom:8px;transition:all .35s}
.pp-card.prepaid .pp-card-icon{color:var(--c1)}
.pp-card.postpaid .pp-card-icon{color:var(--c4)}
.pp-card-title{font-size:.85rem;font-weight:700;color:var(--tx);margin-bottom:6px;line-height:1.3}
.pp-card-desc{font-size:.65rem;color:var(--t3);line-height:1.5;margin-bottom:10px}
.pp-card-tags{display:flex;gap:6px;justify-content:center;flex-wrap:wrap;margin-bottom:10px}
.pp-card-tags span{font-size:.56rem;font-weight:600;padding:3px 10px;border-radius:var(--rp);background:var(--bg);color:var(--t3)}
.pp-card-btn{font-size:.7rem;font-weight:600;color:var(--c1);border:1px solid var(--c1);padding:8px 20px;border-radius:var(--rp);display:inline-block;transition:all .15s}
.pp-card.postpaid .pp-card-btn{color:var(--c4);border-color:var(--c4)}
.pp-plans-wrap{overflow:hidden;transition:all .35s cubic-bezier(.4,0,.2,1);max-height:0;opacity:0}
.pp-plans-wrap.show{max-height:2000px;opacity:1}
.pp-plans-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:10px}
.pp-plans-title{font-size:.7rem;font-weight:700;color:var(--t3);text-transform:uppercase;letter-spacing:.8px}
.pp-plans-back{font-size:.66rem;font-weight:600;color:var(--t2);cursor:pointer;background:none;border:none;font-family:var(--ff);display:flex;align-items:center;gap:4px;padding:4px 0}
.pp-upgrade-info{font-size:.62rem;color:var(--t3);text-align:center;margin-bottom:12px;line-height:1.5;background:var(--bg);border-radius:var(--r2);padding:8px 12px}
.pp-upgrade-info strong{color:var(--c5)}
.pp-pkg{background:var(--bgs);border:1px solid var(--bd);border-radius:var(--r2);padding:14px 16px;margin-bottom:8px;display:flex;align-items:center;gap:12px;transition:all .15s}
.pp-pkg:active{background:var(--bgc)}
.pp-pkg.current{border-color:var(--c4);background:rgba(52,211,153,.04)}
.pp-pkg-info{flex:1;min-width:0}
.pp-pkg-name{font-size:.82rem;font-weight:600;color:var(--tx)}
.pp-pkg-meta{font-size:.64rem;color:var(--t3);margin-top:2px;display:flex;gap:10px;flex-wrap:wrap}
.pp-pkg-price{font-size:.85rem;font-weight:800;color:var(--c1);flex-shrink:0;text-align:right}
.pp-pkg-price small{display:block;font-size:.58rem;color:var(--t3);font-weight:400;margin-top:1px}
.pp-pkg .tx-act{flex-shrink:0;white-space:nowrap}
</style>
</head>
<body>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<header class="ab">
    <div class="ab-l">
        <div class="ab-logo"><img src="{$app_url}/ui/ui/images/logo.png" class="ab-logo-img" alt=""><span>{$_c['CompanyName']}</span></div>
    </div>
    <div class="ab-r">
        <button class="ab-btn" id="dmBtn" onclick="toggleTheme()"><i class="bi bi-sun-fill"></i></button>
        <img src="{$app_url}/ui/ui/images/default-avatar.png" class="ab-av" id="avatarBtn" alt="">
    </div>
</header>

<div class="cw">

    {if isset($notify)}<meta id="notify-data" data-msg="{$notify|escape}" data-type="{if $notify_t == 's'}success{else}error{/if}">{/if}

    {if $active && $activePlan}
        <!-- MODE: UPGRADE -->
        <section>
            <div class="sh stg"><h2>Current Package</h2></div>
            <div class="pp-pkg current stg">
                <div class="pp-pkg-info">
                    <div class="pp-pkg-name">{$activePlan['name_plan']}</div>
                    <div class="pp-pkg-meta">
                        {if $activeBw}<span><i class="bi bi-speedometer2"></i> {$activeBw['name_bw']}</span>{/if}
                        <span><i class="bi bi-calendar-check"></i> Expired: {$active['expiration']|date_format:'%d %B %Y'}</span>
                        <span><i class="bi bi-arrow-repeat"></i> Jatuh tempo tgl {$dayExp}</span>
                    </div>
                </div>
                <div class="pp-pkg-price">{Lang::moneyFormat($activePlan['price'])}<small>per bulan</small></div>
            </div>

            <div class="sh stg"><h2>Upgrade To</h2></div>
            {if $only_up == 'yes'}
            <div class="pp-upgrade-info stg">
                Upgrade pertengahan periode? Biaya dihitung <strong>prorated</strong>.
                Hanya membayar selisih biaya paket lama yang sudah terpakai + biaya paket baru untuk sisa hari.
            </div>
            {/if}

            {assign var="found" value=false}
            {foreach $postpaidPlans as $plan}
                {if $only_up == 'yes' && $plan['price'] <= $activePlan['price']}{continue}{/if}
                {if $plan['id'] == $active['plan_id']}{continue}{/if}
                {assign var="found" value=true}
                <div class="pp-pkg stg">
                    <div class="pp-pkg-info">
                        <div class="pp-pkg-name">{$plan['name_plan']}</div>
                        <div class="pp-pkg-meta">
                            {assign var="bw" value=$postpaidBws[$plan['id']]}
                            {if $bw}<span><i class="bi bi-speedometer2"></i> {$bw['name_bw']}</span>{/if}
                            <span><i class="bi bi-calendar-check"></i> Jatuh tempo tgl {$dayExp}</span>
                        </div>
                    </div>
                    <div class="pp-pkg-price">{Lang::moneyFormat($plan['price'])}<small>per bulan</small></div>
                    <a href="javascript:void(0)" class="tx-act pay" onclick="openPostpaidModal({$plan['id']})">Upgrade</a>
                </div>
            {/foreach}
            {if !$found}
            <div class="pc-empty stg">No upgrade plans available</div>
            {/if}
        </section>

    {else}
        <!-- MODE: OFFER -->
        <section>
            <div class="sh stg"><h2>Choose Your Plan</h2></div>

            <div class="pp-offer stg" id="ppOffer">
                <div class="pp-card prepaid selected" id="ppCardPrepaid" onclick="selectMode('prepaid')">
                    <div class="pp-card-icon"><i class="bi bi-lightning-charge-fill"></i></div>
                    <div class="pp-card-title">Bayar Sekali, Pakai Sesuai Durasi</div>
                    <div class="pp-card-desc">Beli paket internet dengan masa aktif tetap. Tanpa khawatir tagihan bulanan. Cocok untuk kebutuhan jangka pendek.</div>
                    <div class="pp-card-tags"><span>7 Hari</span><span>30 Hari</span><span>Fleksibel</span></div>
                    <div class="pp-card-btn">Lihat Paket Prepaid</div>
                </div>
                <div class="pp-card postpaid" id="ppCardPostpaid" onclick="selectMode('postpaid')">
                    <div class="pp-card-icon"><i class="bi bi-calendar-check-fill"></i></div>
                    <div class="pp-card-title">Langganan Bulanan, Jatuh Tempo Tetap</div>
                    <div class="pp-card-desc">Nikmati internet tanpa putus. Bayar setiap bulan dengan tanggal jatuh tempo yang sama. Lebih hemat untuk pemakaian jangka panjang.</div>
                    <div class="pp-card-tags"><span>Tgl {$dayExp}</span><span>Bulanan</span><span>Lebih Hemat</span></div>
                    <div class="pp-card-btn">Lihat Paket Postpaid</div>
                </div>
            </div>

            <div class="pp-plans-wrap" id="ppPrepaidList">
                <div class="pp-plans-header">
                    <span class="pp-plans-title"><i class="bi bi-lightning-charge-fill"></i> Prepaid Packages</span>
                    <button class="pp-plans-back" onclick="selectMode(null)"><i class="bi bi-arrow-left"></i> Back</button>
                </div>
                {if !empty($prepaidPlans)}
                {foreach $prepaidPlans as $plan}
                <div class="pp-pkg">
                    <div class="pp-pkg-info">
                        <div class="pp-pkg-name">{$plan['name_plan']}</div>
                        <div class="pp-pkg-meta">
                            {assign var="bw" value=$prepaidBws[$plan['id']]}
                            {if $bw}<span><i class="bi bi-speedometer2"></i> {$bw['name_bw']}</span>{/if}
                            <span><i class="bi bi-clock"></i> {$plan['validity']} {$plan['validity_unit']}</span>
                        </div>
                    </div>
                    <div class="pp-pkg-price">{Lang::moneyFormat($plan['price'])}</div>
                    <a href="javascript:void(0)" class="tx-act pay" onclick="openPackageModal({$plan['id']},'Router Utama')">Buy</a>
                </div>
                {/foreach}
                {else}
                <div class="pc-empty">No prepaid packages available</div>
                {/if}
            </div>

            <div class="pp-plans-wrap" id="ppPostpaidList">
                <div class="pp-plans-header">
                    <span class="pp-plans-title"><i class="bi bi-calendar-check-fill"></i> Postpaid Packages</span>
                    <button class="pp-plans-back" onclick="selectMode(null)"><i class="bi bi-arrow-left"></i> Back</button>
                </div>
                <div class="pp-upgrade-info">
                    Jatuh tempo setiap <strong>tanggal {$dayExp}</strong>. Bayar per bulan, internet tanpa putus.
                </div>
                {if !empty($postpaidPlans)}
                {foreach $postpaidPlans as $plan}
                <div class="pp-pkg">
                    <div class="pp-pkg-info">
                        <div class="pp-pkg-name">{$plan['name_plan']}</div>
                        <div class="pp-pkg-meta">
                            {assign var="bw" value=$postpaidBws[$plan['id']]}
                            {if $bw}<span><i class="bi bi-speedometer2"></i> {$bw['name_bw']}</span>{/if}
                            <span><i class="bi bi-calendar-check"></i> Jatuh tempo tgl {$dayExp}</span>
                        </div>
                    </div>
                    <div class="pp-pkg-price">{Lang::moneyFormat($plan['price'])}<small>per bulan</small></div>
                    <a href="javascript:void(0)" class="tx-act pay" onclick="openPostpaidModal({$plan['id']})">Pilih</a>
                </div>
                {/foreach}
                {else}
                <div class="pc-empty">No postpaid packages available</div>
                {/if}
            </div>
        </section>
    {/if}
</div>

<nav class="bn">
    <a href="{$app_url}/?_route=home"><i class="bi bi-house-door-fill"></i><span>Home</span></a>
    <a href="{$app_url}/?_route=plugin/postpaid_page" class="active"><i class="bi bi-arrow-repeat"></i><span>Package</span></a>
    <a href="{$app_url}/?_route=voucher/activation"><i class="bi bi-ticket-perforated"></i><span>Voucher</span></a>
    <a href="{$app_url}/?_route=order/history"><i class="bi bi-clock-history"></i><span>History</span></a>
    <a href="{$app_url}/?_route=accounts/profile"><i class="bi bi-person"></i><span>Profile</span></a>
</nav>

<div class="offcanvas offcanvas-bottom os mod-h" tabindex="-1" id="upgradeModal">
    <div class="offcanvas-header flex-column"></div>
    <div class="offcanvas-body">
        <div id="upgradeSkel">
            <div class="rch-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-sm h-sm"></span><i class="skl skl-bright" style="width:18px;height:18px;border-radius:50%;margin-left:auto"></i></div>
            <div class="rch-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-md h-sm"></span><i class="skl skl-bright" style="width:18px;height:18px;border-radius:50%;margin-left:auto"></i></div>
            <div class="rch-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-sm h-sm"></span><i class="skl skl-bright" style="width:18px;height:18px;border-radius:50%;margin-left:auto"></i></div>
            <div class="rch-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-lg h-sm"></span><i class="skl skl-bright" style="width:18px;height:18px;border-radius:50%;margin-left:auto"></i></div>
            <div class="rch-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-sm h-sm"></span><i class="skl skl-bright" style="width:18px;height:18px;border-radius:50%;margin-left:auto"></i></div>
        </div>
        <div id="upgradeList"></div>
    </div>
</div>

<div class="offcanvas offcanvas-bottom os" tabindex="-1" id="upgradeErrModal">
    <div class="offcanvas-header flex-column"></div>
    <div class="offcanvas-body bem-body">
        <i class="bi bi-x-circle-fill bem-icon"></i>
        <p id="upgradeErrMsg" class="bem-msg"></p>
        <button class="vbtn bem-btn" onclick="upgradeErrModalBS.hide()">Tutup</button>
    </div>
</div>

<div class="tc" id="toastContainer"></div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="{$app_url}/ui/ui_custom/customer/assets/js/script.js"></script>
<script>
{literal}
function selectMode(mode) {
    var c1 = document.getElementById('ppCardPrepaid'), c2 = document.getElementById('ppCardPostpaid');
    var l1 = document.getElementById('ppPrepaidList'), l2 = document.getElementById('ppPostpaidList');

    if (!mode) {
        if (c1.classList.contains('removing') || c2.classList.contains('removing')) {
            c1.classList.remove('removing'); c2.classList.remove('removing');
            c1.classList.add('selected');
        }
        l1.classList.remove('show'); l2.classList.remove('show');
        document.getElementById('ppOffer').style.display = 'flex';
        return;
    }

    document.getElementById('ppOffer').style.display = 'flex';

    if (mode === 'prepaid') {
        c2.classList.add('removing'); c2.classList.remove('selected');
        c1.classList.add('selected');
        setTimeout(function(){ l1.classList.add('show'); l2.classList.remove('show'); }, 350);
    } else {
        c1.classList.add('removing'); c1.classList.remove('selected');
        c2.classList.add('selected');
        setTimeout(function(){ l2.classList.add('show'); l1.classList.remove('show'); }, 350);
    }
}

var upgradeModalBS = null, upgradeErrModalBS = null, upgradePlanId = null;

function getUpgradeChannels() {
    fetch(appUrl+'/ui/ui_custom/customer/api/tripay_channels.php', {credentials:'include'})
    .then(function(r){ return r.json(); }).then(function(d) {
        var h = '';
        d.forEach(function(ch) {
            var logo = ch.logo
                ? '<img src="'+appUrl+'/ui/ui_custom/customer/'+ch.logo+'" onerror="this.style.display=\'none\';this.nextElementSibling.style.display=\'block\'"><span style="display:none">'+ch.init.substring(0,2)+'</span>'
                : '<span>'+ch.init.substring(0,2)+'</span>';
            h += '<div class="rch-item" data-channel="'+ch.id+'" onclick="selectUpgradeChannel(this)"><span class="rch-logo" style="background:'+(ch.color||'#666')+'">'+logo+'</span><span class="rch-name">'+ch.name+'</span><i class="bi bi-chevron-right rch-arrow"></i></div>';
        });
        document.getElementById('upgradeSkel').style.display = 'none';
        document.getElementById('upgradeList').innerHTML = h;
    });
}

function openPostpaidModal(pid) {
    if (!upgradeModalBS) upgradeModalBS = new bootstrap.Offcanvas(document.getElementById('upgradeModal'));
    upgradePlanId = pid;
    document.getElementById('upgradeSkel').style.display = 'block';
    document.getElementById('upgradeList').innerHTML = '';
    upgradeModalBS.show();
    getUpgradeChannels();
}

function selectUpgradeChannel(el) {
    var channel = el.getAttribute('data-channel');
    el.classList.add('loading');
    el.querySelector('.rch-arrow').outerHTML = '<span class="btn-dots" style="display:flex;gap:4px"><span style="width:6px;height:6px;border-radius:50%;background:var(--c1);animation:dotJump .5s infinite alternate"></span><span style="width:6px;height:6px;border-radius:50%;background:var(--c1);animation:dotJump .5s infinite alternate;animation-delay:.15s"></span><span style="width:6px;height:6px;border-radius:50%;background:var(--c1);animation:dotJump .5s infinite alternate;animation-delay:.3s"></span></span>';

    fetch(appUrl+'/ui/ui_custom/customer/api/postpaid_upgrade.php', {
        method: 'POST', headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({plan_id: upgradePlanId, channel: channel})
    })
    .then(function(r){ return r.json(); }).then(function(d) {
        if (d.success && d.url) { window.location.href = d.url; }
        else { el.classList.remove('loading'); el.querySelector('.btn-dots').outerHTML = '<i class="bi bi-chevron-right rch-arrow"></i>'; showUpgradeError(d.error || 'Gagal membuat transaksi'); }
    }).catch(function() { el.classList.remove('loading'); el.querySelector('.btn-dots').outerHTML = '<i class="bi bi-chevron-right rch-arrow"></i>'; showUpgradeError('Gagal membuat transaksi'); });
}

function showUpgradeError(msg) {
    if (upgradeModalBS) upgradeModalBS.hide();
    if (!upgradeErrModalBS) upgradeErrModalBS = new bootstrap.Offcanvas(document.getElementById('upgradeErrModal'));
    document.getElementById('upgradeErrMsg').textContent = msg;
    upgradeErrModalBS.show();
}
{/literal}
</script>
</body>
</html>
