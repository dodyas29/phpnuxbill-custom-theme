<!DOCTYPE html>
<html lang="en" data-bs-theme="light">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <meta name="theme-color" content="#7c3aed" id="themeColorMeta">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <title>{$_title} - {$_c['CompanyName']}</title>
    <link rel="shortcut icon" href="{if isset($favicon)}{$app_url}/{$favicon}{else}{$app_url}/ui/ui/images/logo.png{/if}" type="image/x-icon">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <script>var appUrl = '{$app_url}';</script>

    <link rel="stylesheet" href="{$app_url}/ui/ui_custom/assets/css/login.css">
    {if isset($xheader)}{$xheader}{/if}
</head>

<body>

    <div class="bg-shapes">
        <div class="bg-shape bg-shape-1"></div>
        <div class="bg-shape bg-shape-2"></div>
        <div class="bg-shape bg-shape-3"></div>
    </div>

    <button class="dm-toggle" id="dmToggle" aria-label="Toggle dark mode" title="Toggle dark mode">
        <i class="bi bi-moon-fill"></i>
    </button>

    <div class="login-wrap">
        <div class="logo-wrap">
            {if isset($_c['login_page_logo']) && $_c['login_page_logo'] != ''}
                <img src="{$app_url}/{$UPLOAD_PATH}/{$_c['login_page_logo']}" style="width:72px;height:72px;margin:0 auto 16px;display:block;object-fit:contain;border-radius:12px" onerror="this.style.display='none'">
            {/if}
            <h1>{$_c['CompanyName']}</h1>
            <p>{Lang::T('Login to Member Panel')}</p>
        </div>

        <div class="login-card">
            <form id="loginForm" action="{Text::url('login/post')}" method="post">
                <input type="hidden" name="csrf_token" value="{$csrf_token}">

                <div class="field">
                    <div class="field-wrap">
                        <span class="fl">
                            {if $_c['registration_username'] == 'phone'}{Lang::T('Phone Number')}
                            {elseif $_c['registration_username'] == 'email'}{Lang::T('Email')}
                            {else}{Lang::T('Username')}{/if}
                        </span>
                        <input type="text" name="username" required autocomplete="username" autofocus placeholder="{if $_c['registration_username'] == 'phone'}{Lang::T('Phone Number')}{elseif $_c['registration_username'] == 'email'}{Lang::T('Email')}{else}{Lang::T('Username')}{/if}">
                    </div>
                </div>

                <div class="field">
                    <div class="field-wrap">
                        <span class="fl">{Lang::T('Password')}</span>
                        <input type="password" id="password" name="password" required autocomplete="current-password" placeholder="{Lang::T('Password')}">
                        <button type="button" class="pw-toggle" id="togglePassword" aria-label="Toggle password">
                            <i class="bi bi-eye-slash"></i>
                        </button>
                    </div>
                </div>

                <button type="submit" class="btn-primary-custom" id="submitBtn">
                    <span class="spinner"></span>
                    <span class="btn-text">{Lang::T('Login')} <i class="bi bi-arrow-right"></i></span>
                </button>
            </form>

            <div class="links">
                {if $_c['disable_registration'] != 'noreg'}
                    <a href="{Text::url('register')}"><i class="bi bi-person-plus"></i> {Lang::T('Register')}</a>
                {/if}
                <a href="{Text::url('forgot')}"><i class="bi bi-question-circle"></i> {Lang::T('Forgot Password')}</a>
            </div>
        </div>

        <div class="login-footer">
            <a href="javascript:void(0)" onclick="showInfo('privacy')">{Lang::T('Privacy')}</a>
            &bull;
            <a href="javascript:void(0)" onclick="showInfo('tc')">{Lang::T('Terms')}</a>
        </div>
    </div>

    <!-- Bottom Sheet -->
    <div class="offcanvas offcanvas-bottom" tabindex="-1" id="infoSheet" aria-labelledby="infoSheetLabel">
        <div class="offcanvas-header"><h5 class="offcanvas-title" id="infoSheetLabel"></h5></div>
        <div class="offcanvas-body" id="infoSheetBody"></div>
    </div>

    <!-- Toast -->
    <div class="toast-container" id="toastContainer"></div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <meta id="js-data"
        data-privacy-title="{Lang::T('Privacy')|escape}"
        data-tc-title="{Lang::T('Terms and Conditions')|escape}"
        data-err-load="{Lang::T('Failed to load')|escape}"
        data-notify-msg="{if isset($notify)}{$notify|escape}{/if}"
        data-notify-type="{if isset($notify)}{if $notify_t == 's'}success{else}error{/if}{/if}">

    <script>
        {literal}
        var DATA={};
        (function(){var m=document.getElementById('js-data');if(m){DATA.privacy=m.getAttribute('data-privacy-title')||'Privacy';DATA.tc=m.getAttribute('data-tc-title')||'Terms';DATA.errLoad=m.getAttribute('data-err-load')||'Failed to load';DATA.notifyMsg=m.getAttribute('data-notify-msg')||'';DATA.notifyType=m.getAttribute('data-notify-type')||'';}})();

        document.addEventListener('DOMContentLoaded',function(){
            document.querySelectorAll('.field-wrap input').forEach(function(input){
                if(input.value) input.parentElement.classList.add('filled');
                input.addEventListener('input',function(){
                    if(this.value) this.parentElement.classList.add('filled');
                    else this.parentElement.classList.remove('filled');
                });
                input.addEventListener('animationstart', function(e){
                    if(e.animationName === 'onAutoFillStart') this.parentElement.classList.add('filled');
                });
            });
            // Password toggle
            var tp=document.getElementById('togglePassword');
            var pw=document.getElementById('password');
            var ic=tp.querySelector('i');
            tp.addEventListener('click',function(){if(pw.type==='password'){pw.type='text';ic.className='bi bi-eye'}else{pw.type='password';ic.className='bi bi-eye-slash'}});

            // Form submit
            var fm=document.getElementById('loginForm');
            var bt=document.getElementById('submitBtn');
            fm.addEventListener('submit',function(){bt.classList.add('loading');bt.disabled=true});

            // Dark mode
            var saved=localStorage.getItem('bs-theme');
            if(saved){document.documentElement.setAttribute('data-bs-theme',saved)}
            var dmBtn=document.getElementById('dmToggle');
            var dmIcon=dmBtn.querySelector('i');
            updateDMIcon();
            dmBtn.addEventListener('click',function(){
                var cur=document.documentElement.getAttribute('data-bs-theme');
                var next=cur==='dark'?'light':'dark';
                document.documentElement.setAttribute('data-bs-theme',next);
                localStorage.setItem('bs-theme',next);
                document.getElementById('themeColorMeta').setAttribute('content',next==='dark'?'#0b1120':'#7c3aed');
                updateDMIcon();
            });

            function updateDMIcon(){
                var isDark=document.documentElement.getAttribute('data-bs-theme')==='dark';
                dmIcon.className=isDark?'bi bi-sun-fill':'bi bi-moon-fill';
            }

            if(DATA.notifyMsg){showToast(DATA.notifyMsg,DATA.notifyType)}
        });

        function showInfo(t){
            var urls={privacy:appUrl+'/index.php?_route=pages/privacy&mode=text',tc:appUrl+'/index.php?_route=pages/terms&mode=text'};
            var titles={privacy:DATA.privacy,tc:DATA.tc};
            document.getElementById('infoSheetLabel').textContent=titles[t]||'';
            document.getElementById('infoSheetBody').innerHTML='<div class="text-center py-4"><div class="spinner-border" role="status"></div></div>';
            var sheet=new bootstrap.Offcanvas(document.getElementById('infoSheet'));sheet.show();
            fetch(urls[t]).then(function(r){return r.text()}).then(function(h){document.getElementById('infoSheetBody').innerHTML=h||'<p class="text-muted text-center">'+DATA.errLoad+'</p>'}).catch(function(){document.getElementById('infoSheetBody').innerHTML='<p class="text-muted text-center">'+DATA.errLoad+'</p>'});
        }

        function showToast(msg,type){
            var c=document.getElementById('toastContainer');
            var el=document.createElement('div');
            el.className='toast-item '+type;el.textContent=msg;c.appendChild(el);
            setTimeout(function(){el.style.opacity='0';el.style.transition='opacity .25s';setTimeout(function(){el.remove()},300)},4000);
        }
        {/literal}
    </script>

    {if isset($xfooter)}{$xfooter}{/if}
</body>
</html>
