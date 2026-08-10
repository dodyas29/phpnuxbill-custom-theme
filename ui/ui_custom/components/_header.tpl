<header class="ab">
    <div class="ab-l">
        <div class="ab-logo">
            {if isset($_c['login_page_logo']) && $_c['login_page_logo'] != ''}
                <img src="{$app_url}/{$UPLOAD_PATH}/{$_c['login_page_logo']}" class="ab-logo-img" onerror="this.style.display='none'">
            {/if}
            <span>{$_c['CompanyName']|truncate:14:"":true}</span>
        </div>
    </div>
    <div class="ab-r">
        {if $_c['enable_balance'] == 'yes'}<span class="ab-chip"><i class="bi bi-wallet2"></i> <span class="skl skl-bright h-sm pill" style="width:65px" id="abBal"></span></span>{/if}
        <button class="ab-btn" id="notifBtn"><i class="bi bi-bell"></i><span class="ab-badge" id="inboxBadge" style="display:none"></span></button>
        <button class="ab-btn" id="dmBtn"><i class="bi bi-sun-fill"></i></button>
        {if strpos($_user['photo'], 'default') !== false}
        <img src="{$app_url}/{$UPLOAD_PATH}{$_user['photo']}" class="ab-av" id="avatarBtn" alt="{$_user['fullname']}">
        {else}
        <img src="{$app_url}/{$UPLOAD_PATH}{$_user['photo']}.thumb.jpg" onerror="this.src='{$app_url}/{$UPLOAD_PATH}/user.default.jpg'" class="ab-av" id="avatarBtn" alt="{$_user['fullname']}">
        {/if}
    </div>
</header>
