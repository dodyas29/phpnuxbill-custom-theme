<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover, user-scalable=no">
<meta name="theme-color" content="#09090b">
<title>{$_title} &mdash; {$_c['CompanyName']}</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="{$app_url}/ui/ui_custom/customer/assets/css/style.css?v=3">
<script>var appUrl='{$app_url}';var CSRF='{$csrf_token}';var userLang='{$user_language}';</script>
</head>
<body>

<header class="ab">
    <div class="ab-l">
        <div class="ab-logo"><img src="{$app_url}/ui/ui/images/logo.png" class="ab-logo-img" alt=""><span>{$_c['CompanyName']}</span></div>
    </div>
    <div class="ab-r">
        <button class="ab-btn" id="dmBtn" onclick="toggleTheme()"><i class="bi bi-sun-fill"></i></button>
        <button class="ab-btn" id="avatarBtn" onclick="location.href=appUrl+'/?_route=accounts/profile'"><i class="bi bi-person-circle"></i></button>
    </div>
</header>

<div class="cw">

    {if isset($notify)}<meta id="notify-data" data-msg="{$notify|escape}" data-type="{if $notify_t == 's'}success{else}error{/if}">{/if}

    <a href="{$app_url}/?_route=home" class="in-back stg"><i class="bi bi-chevron-left"></i> Kembali</a>

    {if $active && $activePlan}

        {if $only_up == 'yes'}
        <div class="pp-alert stg">
            <i class="bi bi-info-circle-fill"></i>
            <span>Upgrade pertengahan periode? Biaya dihitung <strong>prorated</strong>. Hanya membayar selisih biaya paket lama yang sudah terpakai + biaya paket baru untuk sisa hari.</span>
        </div>
        {/if}

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

            {assign var="found" value=false}
            {foreach $postpaidPlans as $plan}
                {if $only_up == 'yes' && $plan['price'] <= $activePlan['price']}
                    {* skip downgrade *}
                {elseif $plan['id'] == $active['plan_id']}
                    {* skip current plan *}
                {else}
                {assign var="found" value=true}
                <div class="pp-pkg stg">
                    <div class="pp-pkg-info">
                        <div class="pp-pkg-name">{$plan['name_plan']}</div>
                        <div class="pp-pkg-meta">
                            {if isset($postpaidBws[$plan['id']])}<span><i class="bi bi-speedometer2"></i> {$postpaidBws[$plan['id']]['name_bw']}</span>{/if}
                            <span><i class="bi bi-calendar-check"></i> Jatuh tempo tgl {$dayExp}</span>
                        </div>
                    </div>
                    <div class="pp-pkg-price">{Lang::moneyFormat($plan['price'])}<small>per bulan</small></div>
                    <a href="javascript:void(0)" class="tx-act pay" onclick="postpaidUpgrade({$plan['id']})">Upgrade</a>
                </div>
                {/if}
            {/foreach}
            {if !$found}
            <div class="pc-empty stg">No upgrade plans available</div>
            {/if}
        </section>

    {else}

        <section>
            <div class="sh stg"><h2>Choose Your Plan</h2></div>

            <div class="pp-toggle stg" id="ppToggle">
                <button class="pp-tpill prepaid selected" id="ppPillPrepaid" onclick="selectMode('prepaid')"><i class="bi bi-lightning-charge-fill"></i> Prepaid</button>
                <button class="pp-tpill postpaid" id="ppPillPostpaid" onclick="selectMode('postpaid')"><i class="bi bi-calendar-check-fill"></i> Postpaid</button>
            </div>

            <div class="pp-hero prepaid stg" id="ppHeroPrepaid">
                <span class="pp-hero-icon"><i class="bi bi-lightning-charge-fill"></i></span>
                <div class="pp-hero-title">Bayar Sekali, Pakai Sesuai Durasi</div>
                <div class="pp-hero-desc">Masa aktif tetap sesuai paket yang dipilih. Tanpa tagihan bulanan. Cocok untuk kebutuhan jangka pendek dan fleksibel.</div>
                <div class="pp-hero-tags"><span>7 Hari</span><span>30 Hari</span><span>Fleksibel</span></div>
                <button class="pp-hero-cta" onclick="document.getElementById('ppPrepaidList').classList.add('show')">Lihat Paket Prepaid</button>
            </div>

            <div class="pp-hero postpaid hidden stg" id="ppHeroPostpaid">
                <span class="pp-hero-icon"><i class="bi bi-calendar-check-fill"></i></span>
                <div class="pp-hero-title">Langganan Bulanan, Jatuh Tempo Tetap</div>
                <div class="pp-hero-desc">Internet tanpa putus, bayar setiap bulan. Jatuh tempo di tanggal yang sama setiap bulannya. Lebih hemat untuk jangka panjang.</div>
                <div class="pp-hero-tags"><span>Tgl {$dayExp}</span><span>Bulanan</span><span>Lebih Hemat</span></div>
                <button class="pp-hero-cta" onclick="document.getElementById('ppPostpaidList').classList.add('show')">Lihat Paket Postpaid</button>
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
                            {if isset($prepaidBws[$plan['id']])}<span><i class="bi bi-speedometer2"></i> {$prepaidBws[$plan['id']]['name_bw']}</span>{/if}
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
                            {if isset($postpaidBws[$plan['id']])}<span><i class="bi bi-speedometer2"></i> {$postpaidBws[$plan['id']]['name_bw']}</span>{/if}
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
</body>
</html>
