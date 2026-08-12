<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
{include file="customer/components/_head_common.tpl"}
</head>
<body>
{include file="customer/components/_header.tpl"}

    <div class="cw">
        {if isset($notify)}<meta id="notify-data" data-msg="{$notify|escape}" data-type="{if $notify_t == 's'}success{else}error{/if}">{/if}

        <section>
            <div class="sh shm stg"><h2>{Lang::T('Top Up')}</h2></div>

            {if empty($plans_balance) && $_c['allow_balance_custom'] != 'yes'}
            <div class="pc-empty">Tidak ada paket top up tersedia</div>
            {/if}

            {if !empty($plans_balance)}
            <div class="pr-list stg">
                {foreach $plans_balance as $plan}
                <div class="bal-item">
                    <span class="bal-plan">{$plan['name_plan']}</span>
                    <span class="bal-price">{Lang::moneyFormat($plan['price'])}</span>
                    <a href="javascript:void(0)" class="bal-buy" onclick="openBalanceModal({$plan['id']})">{Lang::T('Buy')}</a>
                </div>
                {/foreach}
            </div>
            {/if}

            {if $_c['allow_balance_custom'] == 'yes'}
            <div class="sh stg" style="margin-top:20px"><h2>{Lang::T('Custom Amount')}</h2></div>
            <div class="pr-list stg">
                <form class="bal-custom" onsubmit="return false">
                    <span style="font-size:.82rem;font-weight:600;color:var(--tx);flex-shrink:0">Rp</span>
                    <input type="number" id="balCustomAmount" min="1" placeholder="{Lang::T('Input Desired Amount')}">
                    <button type="button" class="bal-buy" onclick="openCustomBalanceModal()">{Lang::T('Buy')}</button>
                </form>
            </div>
            {/if}
        </section>
    </div>

{include file="customer/components/_navbar.tpl"}
{include file="customer/components/_menu_sheet.tpl"}

    <div class="offcanvas offcanvas-bottom os" tabindex="-1" id="balanceErrModal">
        <div class="offcanvas-header flex-column"></div>
        <div class="offcanvas-body bem-body">
            <i class="bi bi-x-circle-fill bem-icon"></i>
            <p id="balanceErrMsg" class="bem-msg"></p>
            <button class="vbtn bem-btn" onclick="balanceErrModalBS.hide()">Tutup</button>
        </div>
    </div>

    <div class="offcanvas offcanvas-bottom os mod-h" tabindex="-1" id="balanceModal">
        <div class="offcanvas-header flex-column"></div>
        <div class="offcanvas-body">
            <div id="balanceSkel">
                <div class="rch-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-sm h-sm"></span><i class="skl skl-bright" style="width:18px;height:18px;border-radius:50%;margin-left:auto"></i></div>
                <div class="rch-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-md h-sm"></span><i class="skl skl-bright" style="width:18px;height:18px;border-radius:50%;margin-left:auto"></i></div>
                <div class="rch-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-sm h-sm"></span><i class="skl skl-bright" style="width:18px;height:18px;border-radius:50%;margin-left:auto"></i></div>
                <div class="rch-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-lg h-sm"></span><i class="skl skl-bright" style="width:18px;height:18px;border-radius:50%;margin-left:auto"></i></div>
                <div class="rch-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-sm h-sm"></span><i class="skl skl-bright" style="width:18px;height:18px;border-radius:50%;margin-left:auto"></i></div>
            </div>
            <div id="balanceList"></div>
        </div>
    </div>

    <div class="tc" id="toastContainer"></div>

{include file="customer/components/_scripts_common.tpl"}

</body>
</html>
