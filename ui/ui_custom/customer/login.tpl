<!DOCTYPE html>
<html lang="en" data-bs-theme="light">

<head>
    <script>
    {literal}
    if(document.cookie.indexOf('uid=')!==-1) window.location.replace(appUrl+'/?_route=home');
    {/literal}
    </script>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <meta name="theme-color" content="#7c3aed" id="themeColorMeta">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <title>{$_title} - {$_c['CompanyName']}</title>
    <link rel="shortcut icon" href="{if isset($favicon)}{$app_url}/{$favicon|replace:'\\':'/'}{else}{$app_url}/ui/ui/images/logo.png{/if}" type="image/x-icon">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <script>var appUrl = '{$app_url}';</script>

    <style>
        {literal}
        *,::before,::after{box-sizing:border-box;margin:0;padding:0}

        :root,[data-bs-theme=light]{
            --cp:#7c3aed;--cp2:255,255,255;--cd:#06b6d4;--cg:#10b981;--cr:#ef4444;
            --bg:#f1f5f9;--bg2:#e2e8f0;--sf:#ffffff;--ct:#ffffff;
            --tx:#0f172a;--t2:#475569;--t3:#94a3b8;--bd:#e2e8f0;
            --rs:10px;--rm:14px;--rl:18px;--rx:24px;--rp:9999px;
            --shs:0 1px 3px rgba(0,0,0,.06);--shm:0 6px 24px rgba(0,0,0,.08);--shl:0 12px 40px rgba(0,0,0,.12);
            --shg:0 8px 32px rgba(124,58,237,.2);
            --sb:env(safe-area-inset-bottom,0px);--ff:system-ui,-apple-system,'Segoe UI',Roboto,sans-serif;
            --gl:rgba(255,255,255,.15);--gd:rgba(15,23,42,.06)
        }

        [data-bs-theme=dark]{
            --cp:#a78bfa;--cp2:15,23,42;--cd:#67e8f9;--cg:#34d399;--cr:#f87171;
            --bg:#0b1120;--bg2:#1a2332;--sf:#111827;--ct:#1a2332;
            --tx:#e2e8f0;--t2:#94a3b8;--t3:#64748b;--bd:#1e293b;
            --shs:0 1px 3px rgba(0,0,0,.4);--shm:0 6px 24px rgba(0,0,0,.5);--shl:0 12px 40px rgba(0,0,0,.6);
            --shg:0 8px 32px rgba(167,139,250,.15);
            --gl:rgba(255,255,255,.04);--gd:rgba(255,255,255,.03)
        }

        body{
            font-family:var(--ff);background:var(--bg);color:var(--tx);
            min-height:100vh;min-height:100dvh;display:flex;align-items:center;justify-content:center;
            padding:16px;overflow-x:hidden;position:relative;
            -webkit-tap-highlight-color:transparent
        }

        /* Background animated shapes */
        .bg-shapes{position:fixed;inset:0;overflow:hidden;pointer-events:none;z-index:0}
        .bg-shape{position:absolute;border-radius:50%;opacity:.15}
        .bg-shape-1{
            width:260px;height:260px;background:var(--cp);
            top:-80px;left:-60px;animation:s1 18s ease-in-out infinite
        }
        .bg-shape-2{
            width:200px;height:200px;background:var(--cd);
            bottom:-40px;right:-40px;animation:s2 22s ease-in-out infinite
        }
        .bg-shape-3{
            width:120px;height:120px;background:var(--cp);
            top:40%;right:10%;animation:s3 14s ease-in-out infinite
        }
        @keyframes s1{0%,100%{transform:translate(0,0) scale(1)}50%{transform:translate(40px,30px) scale(1.1)}}
        @keyframes s2{0%,100%{transform:translate(0,0) scale(1)}50%{transform:translate(-30px,-40px) scale(1.15)}}
        @keyframes s3{0%,100%{transform:translate(0,0) scale(1)}50%{transform:translate(-20px,60px) scale(1.08)}}

        .login-wrap{position:relative;z-index:1;width:100%;max-width:420px;animation:fi .6s ease-out}
        @keyframes fi{from{opacity:0;transform:translateY(30px)}to{opacity:1;transform:translateY(0)}}

        /* Dark mode toggle */
        .dm-toggle{position:fixed;top:20px;right:20px;z-index:10;background:var(--sf);border:1px solid var(--bd);
            border-radius:50%;width:44px;height:44px;display:flex;align-items:center;justify-content:center;
            cursor:pointer;font-size:1.2rem;color:var(--t2);transition:all .2s;box-shadow:var(--shs)}
        .dm-toggle:hover{color:var(--cp);box-shadow:var(--shm)}

        /* Logo */
        .logo-wrap{text-align:center;margin-bottom:32px;animation:fi .6s ease-out .1s both}
        .logo-wrap svg{width:72px;height:72px;margin-bottom:16px}
        .logo-wrap h1{font-size:1.4rem;font-weight:700;color:var(--tx);margin:0;letter-spacing:-.3px}
        .logo-wrap p{font-size:.82rem;color:var(--t2);margin:4px 0 0;font-weight:400}

        /* Glass card */
        .login-card{
            background:color-mix(in srgb,var(--sf) 85%,transparent);
            backdrop-filter:blur(24px);-webkit-backdrop-filter:blur(24px);
            border-radius:var(--rx);padding:28px 24px;box-shadow:var(--shm);
            border:1px solid var(--bd);animation:fi .6s ease-out .15s both
        }

        /* Form */
        .field{margin-bottom:20px;position:relative}
        .field-label{display:block;font-size:.78rem;font-weight:600;color:var(--t2);margin-bottom:6px;text-transform:uppercase;letter-spacing:.5px}
        .field-wrap{position:relative;display:flex;align-items:center;background:var(--bg);border:2px solid var(--bd);border-radius:var(--rm);overflow:hidden;transition:all .2s}
        .field-wrap:focus-within{border-color:var(--cp);box-shadow:0 0 0 3px rgba(124,58,237,.12)}
        .field-wrap .fi{display:flex;align-items:center;justify-content:center;width:44px;min-width:44px;color:var(--t3);font-size:1.1rem;transition:color .2s}
        .field-wrap:focus-within .fi{color:var(--cp)}
        .field-wrap input{flex:1;border:none;background:transparent;padding:14px 12px 14px 0;font-size:.95rem;color:var(--tx);outline:none;font-family:var(--ff)}
        .field-wrap input::placeholder{color:var(--t3)}
        .pw-toggle{background:none;border:none;color:var(--t3);cursor:pointer;padding:12px 14px;font-size:1.1rem;transition:color .2s;min-width:44px;display:flex;align-items:center;justify-content:center}
        .pw-toggle:hover{color:var(--t2)}

        /* Button */
        .btn-primary-custom{
            display:flex;align-items:center;justify-content:center;gap:8px;
            background:var(--cp);color:#fff;border:none;border-radius:var(--rp);
            padding:14px 28px;font-weight:600;font-size:1rem;width:100%;min-height:50px;
            letter-spacing:.3px;transition:all .2s ease;cursor:pointer;
            box-shadow:var(--shg);position:relative;overflow:hidden
        }
        .btn-primary-custom:hover{filter:brightness(1.1);transform:translateY(-1px);box-shadow:0 12px 40px rgba(124,58,237,.3)}
        .btn-primary-custom:active{transform:translateY(0);filter:brightness(.95)}
        .btn-primary-custom:disabled{opacity:.6;cursor:not-allowed;transform:none}
        .btn-primary-custom .spinner{display:none;width:20px;height:20px;border:2.5px solid rgba(255,255,255,.3);border-top-color:#fff;border-radius:50%;animation:spin .7s linear infinite}
        .btn-primary-custom.loading .spinner{display:block}
        .btn-primary-custom.loading .btn-text{opacity:.7}
        @keyframes spin{to{transform:rotate(360deg)}}

        /* Links */
        .links{display:flex;justify-content:center;gap:20px;margin-top:18px;flex-wrap:wrap}
        .links a{color:var(--cp);text-decoration:none;font-size:.85rem;font-weight:500;padding:8px 12px;border-radius:var(--rs);transition:all .15s;min-height:44px;display:flex;align-items:center;gap:4px}
        .links a:hover{background:rgba(124,58,237,.08);color:var(--cp)}

        /* Footer */
        .login-footer{text-align:center;margin-top:24px;font-size:.72rem;color:var(--t3);animation:fi .6s ease-out .2s both}
        .login-footer a{color:var(--t3);text-decoration:none;font-weight:500;padding:4px 8px;transition:color .15s}
        .login-footer a:hover{color:var(--cp)}

        /* Bottom sheet */
        .offcanvas-bottom{height:auto!important;max-height:85vh;border-radius:var(--rx) var(--rx) 0 0;border:none}
        .offcanvas-bottom .offcanvas-header{padding:16px 20px 0;border:none;flex-direction:column}
        .offcanvas-bottom .offcanvas-header::before{content:'';display:block;width:40px;height:5px;background:var(--bd);border-radius:3px;margin-bottom:12px}
        .offcanvas-bottom .offcanvas-body{padding:8px 20px 28px}

        /* Toast */
        .toast-container{position:fixed;bottom:24px;left:50%;transform:translateX(-50%);z-index:9999;padding-bottom:var(--sb);display:flex;flex-direction:column;gap:8px;align-items:center}
        .toast-item{padding:12px 24px;border-radius:var(--rp);box-shadow:var(--shl);font-size:.85rem;font-weight:600;color:#fff;animation:slideUp .3s ease-out;text-align:center;max-width:90vw;word-break:break-word}
        .toast-item.success{background:var(--cg)}
        .toast-item.error{background:var(--cr)}
        @keyframes slideUp{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)}}

        @media(prefers-reduced-motion:reduce){*,::before,::after{animation-duration:.01ms!important;transition-duration:.01ms!important}}

        .login-loader{position:fixed;inset:0;background:var(--cp);display:flex;flex-direction:column;align-items:center;justify-content:center;z-index:9999;transition:opacity .4s}
        .login-loader.hide{opacity:0;pointer-events:none}
        .login-loader .dots{display:flex;gap:8px;margin-top:20px}
        .login-loader .dots span{width:10px;height:10px;border-radius:50%;background:rgba(255,255,255,.5);animation:bounce .6s infinite alternate}
        .login-loader .dots span:nth-child(2){animation-delay:.2s}
        .login-loader .dots span:nth-child(3){animation-delay:.4s}
        @keyframes bounce{to{transform:translateY(-8px);opacity:1}}

        {/literal}
    </style>
    {if isset($xheader)}{$xheader}{/if}
</head>

<body>

    <div class="login-loader" id="loginLoader">
        <svg viewBox="0 0 80 80" fill="none" xmlns="http://www.w3.org/2000/svg" width="72" height="72">
            <rect width="80" height="80" rx="20" fill="url(#llGrad)"/>
            <path d="M56 40h-6m6 0a12 12 0 00-12-12m12 12a20 20 0 00-20-20m20 20a28 28 0 00-28-28" stroke="#fff" stroke-width="3" stroke-linecap="round" opacity=".9"/>
            <circle cx="40" cy="40" r="5" fill="#fff"/>
            <defs><linearGradient id="llGrad" x1="0" y1="0" x2="80" y2="80"><stop stop-color="#fff"/><stop offset="1" stop-color="rgba(255,255,255,.5)"/></linearGradient></defs>
        </svg>
        <h1 style="color:#fff;font-size:1.3rem;font-weight:700;margin-top:16px;letter-spacing:-.3px">{$_c['CompanyName']}</h1>
        <div class="dots"><span></span><span></span><span></span></div>
    </div>

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
            <svg viewBox="0 0 80 80" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect width="80" height="80" rx="20" fill="url(#logoGrad)"/>
                <path d="M56 40h-6m6 0a12 12 0 00-12-12m12 12a20 20 0 00-20-20m20 20a28 28 0 00-28-28" stroke="#fff" stroke-width="3" stroke-linecap="round" opacity=".9"/>
                <circle cx="40" cy="40" r="5" fill="#fff"/>
                <defs><linearGradient id="logoGrad" x1="0" y1="0" x2="80" y2="80"><stop stop-color="var(--cp)"/><stop offset="1" stop-color="var(--cd)"/></linearGradient></defs>
            </svg>
            <h1>{$_c['CompanyName']}</h1>
            <p>{Lang::T('Login to Member Panel')}</p>
        </div>

        <div class="login-card">
            <form id="loginForm" action="{Text::url('login/post')}" method="post">
                <input type="hidden" name="csrf_token" value="{$csrf_token}">

                <div class="field">
                    <span class="field-label">
                        {if $_c['registration_username'] == 'phone'}{Lang::T('Phone Number')}
                        {elseif $_c['registration_username'] == 'email'}{Lang::T('Email')}
                        {else}{Lang::T('Username')}{/if}
                    </span>
                    <div class="field-wrap">
                        <span class="fi">
                            {if $_c['registration_username'] == 'phone'}<i class="bi bi-phone"></i>
                            {elseif $_c['registration_username'] == 'email'}<i class="bi bi-envelope"></i>
                            {else}<i class="bi bi-person"></i>{/if}
                        </span>
                        <input type="text" name="username" required autocomplete="username" autofocus
                            placeholder="{if $_c['registration_username'] == 'phone'}{if $_c['country_code_phone'] != ''}{$_c['country_code_phone']} {/if}{Lang::T('Phone Number')}{elseif $_c['registration_username'] == 'email'}{Lang::T('Email')}{else}{Lang::T('Username')}{/if}">
                    </div>
                </div>

                <div class="field">
                    <span class="field-label">{Lang::T('Password')}</span>
                    <div class="field-wrap">
                        <span class="fi"><i class="bi bi-lock"></i></span>
                        <input type="password" id="password" name="password" required autocomplete="current-password" placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;">
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
            setTimeout(function(){
                var loader=document.getElementById('loginLoader');
                if(loader)loader.classList.add('hide');
            },700);
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
