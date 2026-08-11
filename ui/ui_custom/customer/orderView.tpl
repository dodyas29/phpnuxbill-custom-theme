<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
{include file="customer/components/_head_common.tpl"}
</head>
<body>
{include file="customer/components/_header.tpl"}

    <div class="cw">
        <a href="javascript:history.back()" style="display:inline-flex;align-items:center;gap:4px;color:var(--t3);text-decoration:none;font-size:.76rem;font-weight:500;margin-bottom:12px"><i class="bi bi-arrow-left"></i> Kembali</a>
        {if isset($notify)}<meta id="notify-data" data-msg="{$notify|escape}" data-type="{if $notify_t == 's'}success{else}error{/if}">{/if}

        <section>
            <div class="tx-card stg">
                <div class="receipt">
                    <div class="receipt-company">{$_c['CompanyName']}</div>
                    <div class="receipt-id">TRX #{$trx['id']}</div>

                    <div class="receipt-divider"></div>

                    <div class="receipt-line">
                        <span class="receipt-plan">{$trx['plan_name']}</span>
                        {if $trx['pg_url_payment'] != 'balance'}
                        <span class="receipt-price">{Lang::moneyFormat($trx['price'])}</span>
                        {/if}
                    </div>

                    <div class="receipt-divider"></div>

                    <div class="receipt-row">
                        <span class="receipt-label">Status</span>
                        <span class="receipt-value">
                            <span class="receipt-status s{$trx['status']}">
                                {if $trx['status'] == 1}<i class="bi bi-clock-fill"></i> UNPAID
                                {elseif $trx['status'] == 2}<i class="bi bi-check-circle-fill"></i> PAID
                                {elseif $trx['status'] == 3}<i class="bi bi-x-circle-fill"></i> FAILED
                                {elseif $trx['status'] == 4}<i class="bi bi-x-circle-fill"></i> CANCELED
                                {/if}
                            </span>
                        </span>
                    </div>
                    <div class="receipt-row">
                        <span class="receipt-label">Dibuat</span>
                        <span class="receipt-value">{Lang::dateAndTimeFormat($trx['created_date'], ' ')}</span>
                    </div>
                    {if !empty($trx['expired_date'])}
                    <div class="receipt-row">
                        <span class="receipt-label">Kedaluwarsa</span>
                        <span class="receipt-value">{Lang::dateAndTimeFormat($trx['expired_date'], ' ')}</span>
                    </div>
                    {/if}
                    {if $trx['status'] == 2 && !empty($trx['paid_date'])}
                    <div class="receipt-row">
                        <span class="receipt-label">Dibayar</span>
                        <span class="receipt-value">{Lang::dateAndTimeFormat($trx['paid_date'], ' ')}</span>
                    </div>
                    {/if}
                    <div class="receipt-row">
                        <span class="receipt-label">Metode</span>
                        <span class="receipt-value">{if $trx['pg_url_payment'] == 'balance'}Balance{elseif !empty($trx['payment_channel'])}{$trx['payment_channel']}{else}{ucwords($trx['gateway'])}{/if}</span>
                    </div>
                    {if isset($router) && $router['name'] != 'balance' && $router['name'] != 'radius'}
                    <div class="receipt-row">
                        <span class="receipt-label">Router</span>
                        <span class="receipt-value">{$router['name']}</span>
                    </div>
                    {/if}
                    {if isset($invoice) && !empty($invoice['invoice'])}
                    <div class="receipt-row">
                        <span class="receipt-label">Invoice</span>
                        <span class="receipt-value">{$invoice['invoice']}</span>
                    </div>
                    {/if}

                    <div class="receipt-divider"></div>
                    <div class="receipt-footer">Terima Kasih</div>
                </div>
            </div>

            {if $trx['status'] == 1}
            <div class="tx-actions stg">
                {if !empty($trx['pg_url_payment']) && $trx['pg_url_payment'] != 'balance'}
                <a href="{$trx['pg_url_payment']}" class="tx-act pay"><i class="bi bi-credit-card"></i> Bayar</a>
                {/if}
                <a href="{Text::url('order/view/')}{$trx['id']}/check" class="tx-act check"><i class="bi bi-arrow-repeat"></i> Cek</a>
                <a href="javascript:void(0)" class="tx-act cancel" onclick="cancelTrx({$trx['id']})"><i class="bi bi-x-circle"></i> Batal</a>
            </div>
            {/if}
        </section>
    </div>

{include file="customer/components/_navbar.tpl"}
{include file="customer/components/_menu_sheet.tpl"}
    <div class="tc" id="toastContainer"></div>

{include file="customer/components/_scripts_common.tpl"}

    <script>
        {literal}
        function cancelTrx(id){
            if(!confirm('Batalkan transaksi?'))return;
            var btn=event.target.closest('.vbtn');if(btn)btn.disabled=true;
            fetch(appUrl+'/ui/ui_custom/customer/api/cancel_transaction.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({trx_id:id})})
            .then(function(r){return r.json()}).then(function(d){
                if(d.success)window.location.href=appUrl+'/?_route=home';
                else showToast(d.error||'Gagal','error');
            }).catch(function(){if(btn)btn.disabled=false});
        }
        {/literal}
    </script>
</body>
</html>
