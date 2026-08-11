<div class="offcanvas offcanvas-bottom os" tabindex="-1" id="menuSheet">
    <div class="offcanvas-header">
        <div style="display:flex;align-items:center;gap:14px;width:100%">
        {if strpos($_user['photo'], 'default') !== false}
        <img src="{$app_url}/{$UPLOAD_PATH}{$_user['photo']}" style="width:48px;height:48px;border-radius:50%;object-fit:cover;flex-shrink:0" alt="">
        {else}
        <img src="{$app_url}/{$UPLOAD_PATH}{$_user['photo']}.thumb.jpg" onerror="this.src='{$app_url}/{$UPLOAD_PATH}/user.default.jpg'" style="width:48px;height:48px;border-radius:50%;object-fit:cover;flex-shrink:0" alt="">
        {/if}
        <div style="flex:1;min-width:0">
            <h6 class="mb-0 fw-bold" style="font-size:.88rem;color:var(--tx)">{$_user['fullname']}</h6>
            <div style="display:flex;align-items:center;margin-top:2px">
                <small style="font-size:.7rem;color:var(--t2)">{$_user['phonenumber']}</small>
            </div>
        </div>
        </div>
    </div>
    <div class="offcanvas-body">
        <a href="{Text::url('accounts/change-password')}" class="ms-item"><i class="bi bi-key"></i> {Lang::T('Change Password')}<span class="ms-trail"><i class="bi bi-chevron-right"></i></span></a>
        <a href="{Text::url('mail')}" class="ms-item"><i class="bi bi-envelope"></i> {Lang::T('Inbox')}<span class="ms-trail"><span></span><i class="bi bi-chevron-right"></i></span></a>
        {if $_c['enable_balance'] == 'yes' && $_c['allow_balance_transfer'] == 'yes'}<a href="javascript:void(0)" onclick="showTransfer()" class="ms-item"><i class="bi bi-send"></i> {Lang::T('Transfer')}<span class="ms-trail"><i class="bi bi-chevron-right"></i></span></a>{/if}
        <div class="mi-div"></div>
        <div class="ms-toggle" id="menuThemeToggle" onclick="toggleTheme()">
            <span style="display:flex;align-items:center;gap:14px"><i class="bi bi-moon-stars" id="menuThemeIcon"></i> <span id="menuThemeLabel">{Lang::T('Light Mode')}</span></span>
            <span class="ms-switch"></span>
        </div>
        <a href="{Text::url('logout')}" class="ms-item danger"><i class="bi bi-box-arrow-right"></i> {Lang::T('Logout')}</a>
    </div>
</div>

{if $_c['enable_balance'] == 'yes' && $_c['allow_balance_transfer'] == 'yes'}
<div class="offcanvas offcanvas-bottom os" tabindex="-1" id="transferSheet">
     <div class="offcanvas-header flex-column"><h6>{Lang::T('Transfer Balance')}</h6></div>
    <div class="offcanvas-body">
        <form method="post" action="{Text::url('home')}">
            <input type="hidden" name="csrf_token" value="{$csrf_token}"><input type="hidden" name="send" value="balance">
            <div class="mb-3"><label class="form-label small fw-semibold">{Lang::T('Recipient Username')}</label><input type="text" name="username" class="form-control" required style="background:var(--bg);border:1.5px solid var(--bd);color:var(--tx);border-radius:8px;padding:10px 14px;font-size:.85rem"></div>
            <div class="mb-3"><label class="form-label small fw-semibold">{Lang::T('Amount')}</label><input type="number" name="balance" class="form-control" required min="1" style="background:var(--bg);border:1.5px solid var(--bd);color:var(--tx);border-radius:8px;padding:10px 14px;font-size:.85rem"></div>
            <button type="submit" class="hero-btn p" style="width:100%;justify-content:center;padding:14px;font-size:.82rem">{Lang::T('Send')}</button>
        </form>
    </div>
</div>
{/if}
