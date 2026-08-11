<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
{include file="components/_head_common.tpl"}
</head>
<body>
{include file="components/_header.tpl"}

    <div class="cw">
        <section>
            <div class="sh stg"><h2>{Lang::T('Order History')}</h2></div>

            {if empty($d)}
            <div class="pc-empty">{Lang::T('No transactions')}</div>
            {else}
            {assign var="lastMonth" value=""}
            {foreach $d as $ds}
                {assign var="curMonth" value=$ds['created_date']|date_format:"%B %Y"}
                {if $curMonth != $lastMonth}
                <div class="oh-month">{$curMonth}</div>
                {assign var="lastMonth" value=$curMonth}
                {/if}
                <a href="{Text::url('order/view/')}{$ds['id']}" class="oh-row stg">
                    <span class="oh-plan">{$ds['plan_name']}</span>
                    <span class="oh-price">{Lang::moneyFormat($ds['price'])}</span>
                    <span class="oh-status s{$ds['status']}">
                        {if $ds['status'] == 1}⏳
                        {elseif $ds['status'] == 2}✅
                        {elseif $ds['status'] == 3}✗
                        {elseif $ds['status'] == 4}✗
                        {/if}
                    </span>
                    <span class="oh-date">{$ds['created_date']|date_format:"%d %b"}</span>
                    <i class="bi bi-chevron-right" style="color:var(--t3);font-size:.7rem;flex-shrink:0"></i>
                </a>
            {/foreach}

            {if $paginator['last'] > 1}
            <div class="oh-pager">
                {if $paginator['prev'] > 0}
                <a href="{$paginator['url']}{$paginator['prev']}" class="vbtn" style="background:var(--bgc);color:var(--tx)">← Sebelumnya</a>
                {/if}
                {if $paginator['next'] > 0}
                <a href="{$paginator['url']}{$paginator['next']}" class="vbtn" style="background:var(--bgc);color:var(--tx)">Selanjutnya →</a>
                {/if}
            </div>
            {/if}
            {/if}
        </section>
    </div>

{include file="components/_navbar.tpl"}
{include file="components/_menu_sheet.tpl"}
    <div class="tc" id="toastContainer"></div>

{include file="components/_scripts_common.tpl"}

</body>
</html>
