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

                <div class="pr-card stg">
                    <div class="pr-photo-wrap">
                        {if strpos($_user['photo'], 'default') !== false}
                        <img src="{$app_url}/{$UPLOAD_PATH}{$_user['photo']}" class="pr-photo" onerror="this.src='{$app_url}/{$UPLOAD_PATH}/user.default.jpg'">
                        {else}
                        <img src="{$app_url}/{$UPLOAD_PATH}{$_user['photo']}.thumb.jpg" class="pr-photo" onerror="this.src='{$app_url}/{$UPLOAD_PATH}/user.default.jpg'">
                        {/if}
                        <label class="pr-upload-label">
                            <i class="bi bi-camera"></i> Ubah Foto
                            <input type="file" name="photo" class="pr-upload" accept="image/*">
                        </label>
                    </div>
                </div>

                <div class="pr-card stg">

                    <div class="field-wrap">
                        <span class="fl">{Lang::T('Username')}</span>
                        <input type="text" value="{$_user['username']}" readonly>
                    </div>

                    <div class="field-wrap">
                        <span class="fl">{Lang::T('Full Name')}</span>
                        <input type="text" name="fullname" value="{$_user['fullname']}" required placeholder="{Lang::T('Full Name')}">
                    </div>

                    <div class="field-wrap">
                        <span class="fl">{Lang::T('Address')}</span>
                        <input type="text" name="address" value="{$_user['address']}" placeholder="{Lang::T('Address')}">
                    </div>

                    <div class="field-wrap">
                        <span class="fl">{Lang::T('Phone Number')}</span>
                        {if $_c['allow_phone_otp'] == 'yes'}
                        <input type="text" value="{$_user['phonenumber']}" readonly>
                        <a href="{Text::url('accounts/phone-update')}" class="pr-change-link"><i class="bi bi-pencil"></i></a>
                        {else}
                        <input type="text" name="phonenumber" value="{$_user['phonenumber']}" placeholder="{Lang::T('Phone Number')}">
                        {/if}
                    </div>

                    <div class="field-wrap">
                        <span class="fl">{Lang::T('Email')}</span>
                        {if $_c['allow_email_otp'] == 'yes'}
                        <input type="text" value="{$_user['email']}" readonly>
                        <a href="{Text::url('accounts/email-update')}" class="pr-change-link"><i class="bi bi-pencil"></i></a>
                        {else}
                        <input type="text" name="email" value="{$_user['email']}" placeholder="{Lang::T('Email')}">
                        {/if}
                    </div>

                    {if isset($customFields)}{$customFields}{/if}

                    <button type="submit" class="vbtn" style="margin-top:8px"><i class="bi bi-check-lg"></i> {Lang::T('Save Changes')}</button>
                    <a href="{Text::url('accounts/change-password')}" class="vbtn" style="margin-top:10px;background:var(--bgc);color:var(--tx)"><i class="bi bi-key"></i> {Lang::T('Change Password')}</a>
                    <a href="{Text::url('home')}" style="display:block;text-align:center;margin-top:16px;color:var(--t3);text-decoration:none;font-size:.78rem;font-weight:500">{Lang::T('Cancel')}</a>
                </div>
            </form>
        </section>
    </div>

{include file="components/_navbar.tpl"}
{include file="components/_menu_sheet.tpl"}
    <div class="tc" id="toastContainer"></div>

{include file="components/_scripts_common.tpl"}

    <script>
        {literal}
        document.querySelectorAll('.field-wrap input').forEach(function(input){
            if(input.value)input.parentElement.classList.add('filled');
            input.addEventListener('input',function(){if(this.value)this.parentElement.classList.add('filled');else this.parentElement.classList.remove('filled')});
            input.addEventListener('animationstart',function(e){if(e.animationName==='onAutoFillStart')this.parentElement.classList.add('filled')});
        });
        {/literal}
    </script>
</body>
</html>
