<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
{include file="customer/components/_head_common.tpl"}
</head>
<body>
{include file="customer/components/_header.tpl"}

    <div class="cw">
        {if isset($notify)}<meta id="notify-data" data-msg="{$notify|escape}" data-type="{if $notify_t == 's'}success{else}error{/if}">{/if}

        {if $tipe == 'view'}

            <section>
                <a href="{Text::url('mail')}" class="in-back stg"><i class="bi bi-chevron-left"></i>{Lang::T('Back')}</a>

                <div class="in-msg-card stg">
                    <div class="in-msg-subj">{$mail.subject|escape}</div>
                    <div class="in-msg-meta">{Lang::T('From')}: {$mail.from|escape} &middot; {Lang::dateTimeFormat($mail.date_created)}</div>
                    <div class="in-msg-body">
                        {if Text::is_html($mail.body)}
                            {$mail.body}
                        {else}
                            {$mail.body|nl2br}
                        {/if}
                    </div>
                </div>

                <div class="in-nav stg">
                    {if $prev}
                        <a href="{Text::url('mail/view/')}{$prev}"><i class="bi bi-chevron-left"></i> {Lang::T('Previous')}</a>
                    {else}
                        <span class="in-nav-disabled"><i class="bi bi-chevron-left"></i> {Lang::T('Previous')}</span>
                    {/if}
                    <a href="https://api.whatsapp.com/send?text={if Text::is_html($mail.body)}{urlencode($mail.body|strip_tags)}{else}{urlencode($mail.body)}{/if}"><i class="bi bi-share"></i> {Lang::T('Share')}</a>
                    {if $next}
                        <a href="{Text::url('mail/view/')}{$next}">{Lang::T('Next')} <i class="bi bi-chevron-right"></i></a>
                    {else}
                        <span class="in-nav-disabled">{Lang::T('Next')} <i class="bi bi-chevron-right"></i></span>
                    {/if}
                </div>

                <a href="{Text::url('mail/delete/')}{$mail.id}" class="in-del stg" onclick="return confirm('{Lang::T('Delete')|escape}{'?'|escape}')"><i class="bi bi-trash"></i> {Lang::T('Delete')}</a>
            </section>

        {else}

            <section>
                <div class="sh shm stg"><h2>{Lang::T('Inbox')}</h2></div>

                <form method="post" action="{Text::url('mail')}" class="in-search stg">
                    <i class="bi bi-search"></i>
                    <input type="text" name="q" placeholder="{Lang::T('Search')}..." value="{$q|escape}">
                    {if $q}
                        <a href="{Text::url('mail')}" class="in-search-clr"><i class="bi bi-x-circle-fill"></i></a>
                    {/if}
                </form>

                {if empty($mails)}
                    <div class="pc-empty stg">
                        <i class="bi bi-envelope-open" style="font-size:2rem;color:var(--t3);display:block;margin-bottom:8px"></i>
                        {Lang::T('No email found.')}
                    </div>
                {else}
                    <div class="in-list stg">
                        {foreach $mails as $mail}
                            <a href="{Text::url('mail/view/')}{$mail.id}" class="in-row{if $mail.date_read == null} unread{/if}">
                                <span class="in-dot{if $mail.date_read == null} unread{/if}"></span>
                                <div class="in-mid">
                                    <div class="in-from">{$mail.from|escape}</div>
                                    <div class="in-subj">{$mail.subject|escape}</div>
                                </div>
                                <span class="in-time">{Lang::dateTimeFormat($mail.date_created)}</span>
                            </a>
                        {/foreach}
                    </div>

                    <div class="in-pager stg">
                        {if $p > 0}
                            <a href="{Text::url('mail')}&p={$p-1}&q={$q|urlencode}" class="tx-act check"><i class="bi bi-chevron-left"></i> {Lang::T('Previous')}</a>
                        {/if}
                        <a href="{Text::url('mail')}&p={$p+1}&q={$q|urlencode}" class="tx-act check">{Lang::T('Next')} <i class="bi bi-chevron-right"></i></a>
                    </div>
                {/if}
            </section>

        {/if}
    </div>

{include file="customer/components/_navbar.tpl"}
{include file="customer/components/_menu_sheet.tpl"}
    <div class="tc" id="toastContainer"></div>

{include file="customer/components/_scripts_common.tpl"}

</body>
</html>
