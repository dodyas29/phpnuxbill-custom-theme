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
            <div class="pr-card stg" style="text-align:center;padding:40px 20px">
                <i class="bi bi-x-circle-fill" style="font-size:2.5rem;color:var(--c6);display:block;margin-bottom:12px"></i>
                <p style="font-size:.85rem;color:var(--tx);line-height:1.5;margin-bottom:24px">{$notify}</p>
                <a href="{Text::url('accounts/profile')}" class="vbtn" style="max-width:200px;margin:0 auto"><i class="bi bi-arrow-left"></i> Kembali ke Profile</a>
            </div>
        </section>
    </div>

{include file="components/_navbar.tpl"}
{include file="components/_menu_sheet.tpl"}
    <div class="tc" id="toastContainer"></div>

{include file="components/_scripts_common.tpl"}

</body>
</html>
