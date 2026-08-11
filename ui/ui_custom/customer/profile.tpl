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

            <form action="{Text::url('accounts/edit-profile-post')}" method="post" enctype="multipart/form-data" id="profileForm">
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

                <div class="pr-list stg pr-top">
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
            </form>

            <div class="pr-list stg pr-bot">
                <div class="pr-row" onclick="togglePwForm()">
                    <span>{Lang::T('Change Password')}</span>
                    <span class="pr-val"><i class="bi bi-chevron-down pr-pw-icon" style="font-size:.7rem;margin-left:4px;transition:transform .2s"></i></span>
                </div>
                <form action="{Text::url('accounts/change-password-post')}" method="post" id="pwWrap" style="display:none;padding:0 16px 16px">
                    <input type="hidden" name="csrf_token" value="{$csrf_token}">
                    <div class="field-wrap" style="margin-bottom:12px">
                        <span class="fl">{Lang::T('Current Password')}</span>
                        <input type="password" name="password" required placeholder="{Lang::T('Current Password')}">
                        <button type="button" class="pw-toggle" onclick="togglePw('pwCurrent',this)"><i class="bi bi-eye-slash"></i></button>
                    </div>
                    <div class="field-wrap" style="margin-bottom:12px">
                        <span class="fl">{Lang::T('New Password')}</span>
                        <input type="password" name="newpassword" required placeholder="{Lang::T('New Password')}">
                        <button type="button" class="pw-toggle" onclick="togglePw('pwNew',this)"><i class="bi bi-eye-slash"></i></button>
                    </div>
                    <div class="field-wrap">
                        <span class="fl">{Lang::T('Confirm New Password')}</span>
                        <input type="password" name="cnewpassword" required placeholder="{Lang::T('Confirm New Password')}">
                        <button type="button" class="pw-toggle" onclick="togglePw('pwConfirm',this)"><i class="bi bi-eye-slash"></i></button>
                    </div>
                </form>
            </div>

            <button type="submit" class="vbtn stg" form="profileForm" style="margin-top:24px"><i class="bi bi-check-lg"></i> {Lang::T('Save Changes')}</button>
            <div style="text-align:center;margin-top:14px"><a href="{Text::url('home')}" style="color:var(--t3);text-decoration:none;font-size:.78rem;font-weight:500">{Lang::T('Cancel')}</a></div>
        </div>

{include file="components/_navbar.tpl"}
{include file="components/_menu_sheet.tpl"}
    <div class="tc" id="toastContainer"></div>

{include file="components/_scripts_common.tpl"}

    <script>
        {literal}
        function togglePwForm(){
            var pw=document.getElementById('pwWrap'),icon=document.querySelector('.pr-pw-icon');
            var open=pw.style.display==='block';
            pw.style.display=open?'none':'block';
            icon.style.transform=open?'rotate(0)':'rotate(180deg)';
        }
        function togglePw(id,btn){
            var el=document.getElementById(id),icon=btn.querySelector('i');
            if(el.type==='password'){el.type='text';icon.className='bi bi-eye'}
            else{el.type='password';icon.className='bi bi-eye-slash'}
        }
        document.querySelectorAll('.field-wrap input').forEach(function(input){
            if(input.value)input.parentElement.classList.add('filled');
            input.addEventListener('input',function(){if(this.value)this.parentElement.classList.add('filled');else this.parentElement.classList.remove('filled')});
            input.addEventListener('animationstart',function(e){if(e.animationName==='onAutoFillStart')this.parentElement.classList.add('filled')});
        });
        {/literal}
    </script>
</body>
</html>
