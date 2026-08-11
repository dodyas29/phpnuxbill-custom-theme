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
            <div class="sh stg"><h2>{Lang::T('Top Up')}</h2></div>

            {if empty($plans_balance) && $_c['allow_balance_custom'] != 'yes'}
            <div class="pc-empty">Tidak ada paket top up tersedia</div>
            {/if}

            {if !empty($plans_balance)}
            <div class="pr-list stg">
                {foreach $plans_balance as $plan}
                <div class="bal-item">
                    <span class="bal-plan">{$plan['name_plan']}</span>
                    <span class="bal-price">{Lang::moneyFormat($plan['price'])}</span>
                    <a href="{Text::url('order/gateway/0/')}{$plan['id']}" class="bal-buy">{Lang::T('Buy')}</a>
                </div>
                {/foreach}
            </div>
            {/if}

            {if $_c['allow_balance_custom'] == 'yes'}
            <div class="sh stg" style="margin-top:20px"><h2>{Lang::T('Custom Amount')}</h2></div>
            <div class="pr-list stg">
                <form action="{Text::url('order/gateway/0/0')}" method="post" class="bal-custom">
                    <input type="hidden" name="custom" value="1">
                    <span style="font-size:.82rem;font-weight:600;color:var(--tx);flex-shrink:0">Rp</span>
                    <input type="number" name="amount" required min="1" placeholder="{Lang::T('Input Desired Amount')}">
                    <button type="submit" class="bal-buy">{Lang::T('Buy')}</button>
                </form>
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
