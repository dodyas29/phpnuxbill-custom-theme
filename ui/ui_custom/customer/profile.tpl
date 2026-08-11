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
            <div class="sh stg"><h2>{Lang::T('My Account')}</h2></div>

            <form action="{Text::url('accounts/edit-profile-post')}" method="post" enctype="multipart/form-data">
                <input type="hidden" name="csrf_token" value="{$csrf_token}">
                <input type="hidden" name="id" value="{$_user['id']}">

                <div class="pr-head stg">
                    {if strpos($_user['photo'], 'default') !== false}
                    <img src="{$app_url}/{$UPLOAD_PATH}{$_user['photo']}" class="pr-avatar" onerror="this.src='{$app_url}/{$UPLOAD_PATH}/user.default.jpg'">
                    {else}
                    <img src="{$app_url}/{$UPLOAD_PATH}{$_user['photo']}.thumb.jpg" class="pr-avatar" onerror="this.src='{$app_url}/{$UPLOAD_PATH}/user.default.jpg'">
                    {/if}
                    <div class="pr-head-info">
                        <div class="pr-head-name">{$_user['fullname']}</div>
                        <div class="pr-head-sub">{$_user['email']}</div>
                    </div>
                    <label class="pr-upload-label">
                        <i class="bi bi-camera"></i>
                        <input type="file" name="photo" class="pr-upload" accept="image/*">
                    </label>
                </div>

                <div class="pr-list stg">
                    <label class="pr-row">
                        <span>{Lang::T('Full Name')}</span>
                        <input type="text" name="fullname" value="{$_user['fullname']}" required>
                    </label>
                    <label class="pr-row">
                        <span>{Lang::T('Address')}</span>
                        <input type="text" name="address" value="{$_user['address']}">
                    </label>
                    {if $_c['allow_phone_otp'] != 'yes'}
                    <label class="pr-row">
                        <span>{Lang::T('Phone Number')}</span>
                        <input type="text" name="phonenumber" value="{$_user['phonenumber']}">
                    </label>
                    {else}
                    <div class="pr-row">
                        <span>{Lang::T('Phone Number')}</span>
                        <a href="{Text::url('accounts/phone-update')}" class="pr-val">{$_user['phonenumber']} <i class="bi bi-chevron-right" style="font-size:.7rem;margin-left:4px"></i></a>
                    </div>
                    {/if}
                    {if $_c['allow_email_otp'] != 'yes'}
                    <label class="pr-row">
                        <span>{Lang::T('Email')}</span>
                        <input type="text" name="email" value="{$_user['email']}">
                    </label>
                    {else}
                    <div class="pr-row">
                        <span>{Lang::T('Email')}</span>
                        <a href="{Text::url('accounts/email-update')}" class="pr-val">{$_user['email']} <i class="bi bi-chevron-right" style="font-size:.7rem;margin-left:4px"></i></a>
                    </div>
                    {/if}
                    {if isset($customFields)}{$customFields}{/if}
                </div>

                <button type="submit" class="vbtn stg" style="margin-top:24px"><i class="bi bi-check-lg"></i> {Lang::T('Save Changes')}</button>
                <a href="{Text::url('home')}" style="display:block;text-align:center;margin-top:14px;color:var(--t3);text-decoration:none;font-size:.78rem;font-weight:500">{Lang::T('Cancel')}</a>
            </form>

            <div class="pr-list stg" style="margin-top:10px">
                <div class="pr-row" onclick="togglePwForm()">
                    <span>{Lang::T('Change Password')}</span>
                    <span class="pr-val"><i class="bi bi-chevron-down pr-pw-icon" style="font-size:.7rem;margin-left:4px;transition:transform .2s"></i></span>
                </div>
                <form action="{Text::url('accounts/change-password-post')}" method="post" id="pwForm" style="display:none;padding:0 16px 16px">
                    <input type="hidden" name="csrf_token" value="{$csrf_token}">
                    <div class="field-wrap" style="margin-bottom:12px">
                        <span class="fl">{Lang::T('Current Password')}</span>
                        <input type="password" name="password" required placeholder="{Lang::T('Current Password')}">
                    </div>
                    <div class="field-wrap" style="margin-bottom:12px">
                        <span class="fl">{Lang::T('New Password')}</span>
                        <input type="password" name="newpassword" required placeholder="{Lang::T('New Password')}">
                    </div>
                    <div class="field-wrap" style="margin-bottom:14px">
                        <span class="fl">{Lang::T('Confirm New Password')}</span>
                        <input type="password" name="cnewpassword" required placeholder="{Lang::T('Confirm New Password')}">
                    </div>
                    <button type="submit" class="vbtn"><i class="bi bi-check-lg"></i> {Lang::T('Save New Password')}</button>
                </form>
            </div>
        </section>
    </div>

{include file="components/_navbar.tpl"}
{include file="components/_menu_sheet.tpl"}
    <div class="tc" id="toastContainer"></div>

{include file="components/_scripts_common.tpl"}

    <script>
        {literal}
        function togglePwForm(){
            var pw=document.getElementById('pwForm'),icon=document.querySelector('.pr-pw-icon');
            var open=pw.style.display==='block';
            pw.style.display=open?'none':'block';
            icon.style.transform=open?'rotate(0)':'rotate(180deg)';
        }
        {/literal}
    </script>
</body>
</html>
