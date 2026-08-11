<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
{include file="components/_head_common.tpl"}
</head>
<body>
{include file="components/_header.tpl"}

    <div class="cw">
        {if isset($notify)}<meta id="notify-data" data-msg="{$notify|escape}" data-type="{if $notify_t == 's'}success{else}error{/if}">{/if}

        <section>
            <div class="sh stg"><h2>Detail Transaksi</h2></div>

            <div class="tx-card stg">
                <div class="tx-card-head">
                    <div class="tx-status status-{$trx['status']}">
                        {if $trx['status'] == 1}<i class="bi bi-clock-fill"></i> UNPAID
                        {elseif $trx['status'] == 2}<i class="bi bi-check-circle-fill"></i> PAID
                        {elseif $trx['status'] == 3}<i class="bi bi-x-circle-fill"></i> FAILED
                        {elseif $trx['status'] == 4}<i class="bi bi-x-circle-fill"></i> CANCELED
                        {/if}
                    </div>
                    <span class="tx-id">TRX #{$trx['id']}</span>
                </div>

                <div class="tx-card-body">
                    <div class="tx-row">
                        <span class="tx-label">Paket</span>
                        <span class="tx-value">{$trx['plan_name']}</span>
                    </div>
                    {if $trx['pg_url_payment'] != 'balance'}
                    <div class="tx-row">
                        <span class="tx-label">Harga</span>
                        <span class="tx-value tx-price">{Lang::moneyFormat($trx['price'])}</span>
                    </div>
                    {/if}
                    {if isset($router) && $router['name'] != 'balance' && $router['name'] != 'radius'}
                    <div class="tx-row">
                        <span class="tx-label">Router</span>
                        <span class="tx-value">{$router['name']}</span>
                    </div>
                    {/if}
                    <div class="tx-row">
                        <span class="tx-label">Metode</span>
                        <span class="tx-value">{if $trx['pg_url_payment'] == 'balance'}Balance{elseif !empty($trx['payment_channel'])}{$trx['payment_channel']}{else}{ucwords($trx['gateway'])}{/if}</span>
                    </div>
                    {if !empty($trx['payment_channel'])}
                    <div class="tx-row">
                        <span class="tx-label">Channel</span>
                        <span class="tx-value">{$trx['payment_channel']}</span>
                    </div>
                    {/if}
                    <div class="tx-row">
                        <span class="tx-label">Dibuat</span>
                        <span class="tx-value">{Lang::dateAndTimeFormat($trx['created_date'], ' ')}</span>
                    </div>
                    {if !empty($trx['expired_date'])}
                    <div class="tx-row">
                        <span class="tx-label">Kedaluwarsa</span>
                        <span class="tx-value">{Lang::dateAndTimeFormat($trx['expired_date'], ' ')}</span>
                    </div>
                    {/if}
                    {if $trx['status'] == 2 && !empty($trx['paid_date'])}
                    <div class="tx-row">
                        <span class="tx-label">Dibayar</span>
                        <span class="tx-value">{Lang::dateAndTimeFormat($trx['paid_date'], ' ')}</span>
                    </div>
                    {/if}
                    {if isset($invoice) && !empty($invoice['invoice'])}
                    <div class="tx-row">
                        <span class="tx-label">Invoice</span>
                        <span class="tx-value">{$invoice['invoice']}</span>
                    </div>
                    {/if}
                    {if !empty($trx['payment_method'])}
                    <div class="tx-row">
                        <span class="tx-label">Metode Bayar</span>
                        <span class="tx-value">{$trx['payment_method']}</span>
                    </div>
                    {/if}
                </div>
            </div>

            {if $trx['status'] == 1}
            <div class="tx-actions stg">
                {if !empty($trx['pg_url_payment']) && $trx['pg_url_payment'] != 'balance'}
                <a href="{$trx['pg_url_payment']}" class="vbtn"><i class="bi bi-credit-card"></i> Bayar Sekarang</a>
                {/if}
                <a href="{Text::url('order/view/')}{$trx['id']}/check" class="vbtn" style="margin-top:10px;background:var(--bgc);color:var(--tx)"><i class="bi bi-arrow-repeat"></i> Cek Pembayaran</a>
                <a href="{Text::url('order/view/')}{$trx['id']}/cancel" class="vbtn" style="margin-top:10px;background:transparent;color:var(--c6);border:1px solid var(--c6)" onclick="return confirm('{Lang::T('Cancel transaction')}?')"><i class="bi bi-x-circle"></i> Batalkan</a>
            </div>
            {/if}
        </section>
    </div>

{include file="components/_navbar.tpl"}
{include file="components/_menu_sheet.tpl"}
    <div class="tc" id="toastContainer"></div>

{include file="components/_scripts_common.tpl"}

</body>
</html>
