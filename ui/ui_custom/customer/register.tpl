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
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css">
    <script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"></script>
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
            --ff:system-ui,-apple-system,'Segoe UI',Roboto,sans-serif;
        }
        [data-bs-theme=dark]{
            --cp:#a78bfa;--cp2:15,23,42;--cd:#67e8f9;--cg:#34d399;--cr:#f87171;
            --bg:#0b1120;--bg2:#1a2332;--sf:#111827;--ct:#1a2332;
            --tx:#e2e8f0;--t2:#94a3b8;--t3:#64748b;--bd:#1e293b;
            --shs:0 1px 3px rgba(0,0,0,.4);--shm:0 6px 24px rgba(0,0,0,.5);--shl:0 12px 40px rgba(0,0,0,.6);
            --shg:0 8px 32px rgba(167,139,250,.15);
        }

        body{
            font-family:var(--ff);background:var(--bg);color:var(--tx);
            min-height:100vh;min-height:100dvh;display:flex;align-items:center;justify-content:center;
            padding:16px;overflow-x:hidden;position:relative;
            -webkit-tap-highlight-color:transparent
        }

        .bg-shapes{position:fixed;inset:0;overflow:hidden;pointer-events:none;z-index:0}
        .bg-shape{position:absolute;border-radius:50%;opacity:.15}
        .bg-shape-1{width:260px;height:260px;background:var(--cp);top:-80px;left:-60px;animation:s1 18s ease-in-out infinite}
        .bg-shape-2{width:200px;height:200px;background:var(--cd);bottom:-40px;right:-40px;animation:s2 22s ease-in-out infinite}
        .bg-shape-3{width:120px;height:120px;background:var(--cp);top:40%;right:10%;animation:s3 14s ease-in-out infinite}
        @keyframes s1{0%,100%{transform:translate(0,0)scale(1)}50%{transform:translate(40px,30px)scale(1.1)}}
        @keyframes s2{0%,100%{transform:translate(0,0)scale(1)}50%{transform:translate(-30px,-40px)scale(1.15)}}
        @keyframes s3{0%,100%{transform:translate(0,0)scale(1)}50%{transform:translate(-20px,60px)scale(1.08)}}

        .wrap{position:relative;z-index:1;width:100%;max-width:420px;animation:fi .6s ease-out}
        @keyframes fi{from{opacity:0;transform:translateY(30px)}to{opacity:1;transform:translateY(0)}}

        .dm-toggle{position:fixed;top:20px;right:20px;z-index:10;background:var(--sf);border:1px solid var(--bd);border-radius:50%;width:44px;height:44px;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:1.2rem;color:var(--t2);transition:all .2s;box-shadow:var(--shs)}
        .dm-toggle:hover{color:var(--cp);box-shadow:var(--shm)}

        .logo-wrap{text-align:center;margin-bottom:28px;animation:fi .6s ease-out .1s both}
        .logo-wrap h1{font-size:1.3rem;font-weight:700;color:var(--tx);margin:0;letter-spacing:-.3px}
        .logo-wrap p{font-size:.78rem;color:var(--t2);margin:4px 0 0;font-weight:400}

        .card{
            background:color-mix(in srgb,var(--sf) 85%,transparent);
            backdrop-filter:blur(24px);-webkit-backdrop-filter:blur(24px);
            border-radius:var(--rx);padding:24px 20px;box-shadow:var(--shm);
            border:1px solid var(--bd);animation:fi .6s ease-out .15s both
        }

        .step-progress{display:flex;align-items:center;justify-content:center;gap:0;margin-bottom:20px}
        .step-dot{width:28px;height:28px;border-radius:50%;background:var(--bg2);display:flex;align-items:center;justify-content:center;font-size:.65rem;font-weight:700;color:var(--t3);transition:all .3s;flex-shrink:0}
        .step-dot.done{background:var(--cg);color:#fff}
        .step-dot.active{background:var(--cp);color:#fff;box-shadow:0 0 0 3px rgba(124,58,237,.2)}
        .step-line{flex:1;height:2px;background:var(--bd);max-width:32px;transition:all .3s}
        .step-line.done{background:var(--cg)}

        .step-panel{display:none;animation:slideIn .3s ease-out}
        .step-panel.active{display:block}
        @keyframes slideIn{from{opacity:0;transform:translateX(12px)}to{opacity:1;transform:translateX(0)}}

        .stitle{font-size:.7rem;font-weight:700;color:var(--t3);text-transform:uppercase;letter-spacing:1px;margin-bottom:12px}

        #coverageMap{width:100%;height:280px;border-radius:var(--rm);border:1px solid var(--bd);margin-bottom:12px;z-index:0}
        .leaflet-control-zoom a{background:var(--sf)!important;color:var(--tx)!important;border-color:var(--bd)!important}

        .coord{background:var(--bg);border:1px solid var(--bd);border-radius:var(--rm);padding:10px 14px;display:flex;align-items:center;gap:8px;font-size:.76rem;color:var(--tx);margin-bottom:12px}
        .coord i{font-size:.9rem;flex-shrink:0}
        .coord-status{font-size:.64rem;margin-top:2px}
        .coord-status.in{color:var(--cg)}.coord-status.out{color:var(--c5)}

        .field-wrap{position:relative;background:var(--bg);border:2px solid var(--bd);border-radius:var(--rm);transition:all .2s;margin-bottom:14px}
        .field-wrap:focus-within{border-color:var(--cp);box-shadow:0 0 0 3px rgba(124,58,237,.12)}
        .field-wrap input{width:100%;border:none;background:transparent;padding:22px 14px 10px 14px;font-size:.95rem;color:var(--tx);outline:none;font-family:var(--ff);box-shadow:none;-webkit-appearance:none;-moz-appearance:none;border-radius:0.8rem}
        .field-wrap input:-webkit-autofill,.field-wrap input:-webkit-autofill:hover,.field-wrap input:-webkit-autofill:focus{-webkit-box-shadow:0 0 0 60px var(--bg) inset!important;-webkit-text-fill-color:var(--tx)!important;background-color:var(--bg)!important;transition:background-color 9999s ease-in-out 0s;animation:onAutoFillStart .01s}
        .field-wrap input::placeholder{color:transparent}
        .fl{position:absolute;left:14px;top:50%;transform:translateY(-50%);font-size:.95rem;color:var(--t3);pointer-events:none;transition:all .2s ease;font-family:var(--ff);font-weight:400}
        .field-wrap:focus-within .fl,.field-wrap input:not(:placeholder-shown) ~ .fl,.field-wrap.filled .fl{top:7px;font-size:.62rem;color:var(--cp);font-weight:600;letter-spacing:.5px;text-transform:uppercase;transform:translateY(0)}
        .field-wrap .pw-toggle{position:absolute;right:0;top:50%;transform:translateY(-50%);background:none;border:none;color:var(--t3);cursor:pointer;padding:12px 14px;font-size:1.1rem;z-index:1}
        .field-hint{font-size:.62rem;color:var(--t3);margin-top:-10px;margin-bottom:14px;padding-left:4px}
        .field-hint.ok{color:var(--cg)}.field-hint.err{color:var(--cr)}

        .otp-inputs{display:flex;gap:8px;justify-content:center;margin-bottom:14px}
        .otp-inputs input{width:42px;height:48px;text-align:center;font-size:1.2rem;font-weight:700;background:var(--bg);border:2px solid var(--bd);border-radius:var(--rs);color:var(--tx);outline:none;font-family:'Courier New',monospace;transition:all .15s}
        .otp-inputs input:focus{border-color:var(--cp);box-shadow:0 0 0 3px rgba(124,58,237,.12)}
        .otp-inputs input.filled{border-color:var(--cg)}

        .btn{display:flex;align-items:center;justify-content:center;gap:8px;background:var(--cp);color:#fff;border:none;border-radius:var(--rp);padding:14px 28px;font-weight:600;font-size:.95rem;width:100%;min-height:50px;letter-spacing:.3px;transition:all .2s ease;cursor:pointer;box-shadow:var(--shg);font-family:var(--ff)}
        .btn:hover{filter:brightness(1.1);transform:translateY(-1px);box-shadow:0 12px 40px rgba(124,58,237,.3)}
        .btn:active{transform:translateY(0);filter:brightness(.95)}
        .btn:disabled{opacity:.4;cursor:not-allowed;transform:none}

        .btn-ghost{display:flex;align-items:center;justify-content:center;gap:8px;background:transparent;color:var(--t2);border:1px solid var(--bd);border-radius:var(--rp);padding:12px 24px;font-weight:600;font-size:.85rem;width:100%;min-height:46px;transition:all .2s ease;cursor:pointer;font-family:var(--ff);margin-bottom:10px}
        .btn-ghost:hover{border-color:var(--cp);color:var(--cp)}

        .suggest-list{display:flex;flex-wrap:wrap;gap:6px;margin-bottom:14px}
        .suggest-chip{padding:6px 12px;border-radius:var(--rp);background:var(--bg2);border:1px solid var(--bd);font-size:.72rem;font-weight:600;color:var(--tx);cursor:pointer;transition:all .1s;font-family:var(--ff)}
        .suggest-chip:hover{border-color:var(--cp);color:var(--cp)}

        .links{display:flex;justify-content:center;align-items:center;gap:4px;margin-top:18px;font-size:.78rem;color:var(--t3)}
        .links a{color:var(--cp);text-decoration:none;font-weight:600;padding:8px 12px;border-radius:var(--rs);transition:all .15s}
        .links a:hover{background:rgba(124,58,237,.08)}

        .toast-container{position:fixed;bottom:24px;left:50%;transform:translateX(-50%);z-index:9999;display:flex;flex-direction:column;gap:8px;align-items:center}
        .toast-item{padding:12px 24px;border-radius:var(--rp);box-shadow:var(--shl);font-size:.85rem;font-weight:600;color:#fff;animation:slideUp .3s ease-out;text-align:center;max-width:90vw}
        .toast-item.success{background:var(--cg)}.toast-item.error{background:var(--cr)}
        @keyframes slideUp{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)}}
        @keyframes onAutoFillStart{from{}to{}}
        @keyframes shake{0%,100%{transform:translateX(0)}25%{transform:translateX(-6px)}75%{transform:translateX(6px)}}
        .shake{animation:shake .4s ease}
        @media(prefers-reduced-motion:reduce){*,::before,::after{animation-duration:.01ms!important;transition-duration:.01ms!important}}
        {/literal}
    </style>
    {if isset($xheader)}{$xheader}{/if}
</head>
<body>
    <div class="bg-shapes">
        <div class="bg-shape bg-shape-1"></div>
        <div class="bg-shape bg-shape-2"></div>
        <div class="bg-shape bg-shape-3"></div>
    </div>

    <button class="dm-toggle" id="dmToggle" aria-label="Toggle dark mode"><i class="bi bi-moon-fill"></i></button>

    <div class="wrap">
        <div class="logo-wrap">
            {if isset($_c['login_page_logo']) && $_c['login_page_logo'] != ''}
                <img src="{$app_url}/{$UPLOAD_PATH}/{$_c['login_page_logo']}" style="width:72px;height:72px;margin:0 auto 16px;display:block;object-fit:contain;border-radius:12px" onerror="this.style.display='none'">
            {/if}
            <h1>{$_c['CompanyName']}</h1>
            <p>{Lang::T('Register')}</p>
        </div>

        <div class="card">
            <div class="step-progress" id="stepper">
                <span class="step-dot active" data-step="1">1</span><span class="step-line" data-between="1-2"></span>
                <span class="step-dot" data-step="2">2</span><span class="step-line" data-between="2-3"></span>
                <span class="step-dot" data-step="3">3</span>
            </div>

            <div class="step-panel active" id="step1">
                <div class="stitle">Coverage Check</div>
                <div id="coverageMap"></div>
                <div class="coord" style="display:none">
                    <i class="bi bi-geo-alt-fill" style="color:var(--c6)" id="coordIcon"></i>
                    <div style="flex:1;min-width:0">
                        <div id="coordText">Click map to select location</div>
                        <div class="coord-status" id="coordStatus"></div>
                    </div>
                </div>
                <button class="btn" id="step1Next" disabled>Selanjutnya <i class="bi bi-arrow-right"></i></button>
            </div>

            <div class="step-panel" id="step2">
                <div class="stitle">WhatsApp Verification</div>
                <div id="step2a">
                    <div class="field-wrap">
                        <span class="fl">WhatsApp Number</span>
                        <input type="tel" id="waPhone" placeholder="WhatsApp Number" inputmode="numeric">
                    </div>
                    <button class="btn" id="sendOtpBtn" disabled>Kirim Kode Verifikasi <i class="bi bi-whatsapp"></i></button>
                </div>
                <div id="step2b" style="display:none">
                    <div class="coord" style="margin-bottom:14px">
                        <i class="bi bi-whatsapp" style="color:#25D366;font-size:1.1rem"></i>
                        <div style="flex:1;font-size:.76rem;color:var(--tx)">Kode dikirim ke <strong id="waDisplay">-</strong></div>
                    </div>
                    <div class="otp-inputs" id="otpInputs">
                        <input type="text" maxlength="1" inputmode="numeric" pattern="[0-9]">
                        <input type="text" maxlength="1" inputmode="numeric" pattern="[0-9]">
                        <input type="text" maxlength="1" inputmode="numeric" pattern="[0-9]">
                        <input type="text" maxlength="1" inputmode="numeric" pattern="[0-9]">
                        <input type="text" maxlength="1" inputmode="numeric" pattern="[0-9]">
                        <input type="text" maxlength="1" inputmode="numeric" pattern="[0-9]">
                    </div>
                    <div class="field-hint" id="otpMsg"></div>
                    <button class="btn" id="step2Next" disabled>Verifikasi & Lanjut <i class="bi bi-arrow-right"></i></button>
                </div>
            </div>

            <div class="step-panel" id="step3">
                <div class="stitle">Account Details</div>
                <form id="regForm" action="{Text::url('register/post')}" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="csrf_token" value="{$csrf_token}">
                    <input type="hidden" name="phonenumber" id="phonenumber">
                    <div class="field-wrap">
                        <span class="fl">{Lang::T('Full Name')}</span>
                        <input type="text" name="fullname" id="fullname" required placeholder="{Lang::T('Full Name')}">
                    </div>
                    <div class="field-wrap">
                        <span class="fl">{Lang::T('Username')}</span>
                        <input type="text" name="username" id="username" required placeholder="{Lang::T('Username')}">
                    </div>
                    <div class="field-hint" id="usernameHint">Auto-generated from your name</div>
                    <div class="suggest-list" id="suggestList"></div>
                    <div class="field-wrap">
                        <span class="fl">{Lang::T('Password')}</span>
                        <input type="password" name="password" id="password" required placeholder="{Lang::T('Password')}">
                        <button type="button" class="pw-toggle" onclick="togglePw('password',this)"><i class="bi bi-eye-slash"></i></button>
                    </div>
                    <div class="field-wrap" style="margin-bottom:18px">
                        <span class="fl">{Lang::T('Confirm Password')}</span>
                        <input type="password" name="cpassword" id="cpassword" required placeholder="{Lang::T('Confirm Password')}">
                        <button type="button" class="pw-toggle" onclick="togglePw('cpassword',this)"><i class="bi bi-eye-slash"></i></button>
                    </div>
                    <button type="submit" class="btn"><i class="bi bi-person-check"></i> Selesai & Daftar</button>
                </form>
            </div>
        </div>

        <div class="links">
            <span>Sudah punya akun?</span>
            <a href="{Text::url('login')}">{Lang::T('Login')}</a>
        </div>
    </div>

    <div class="toast-container" id="toastContainer"></div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        {literal}
        var DATA={};
        (function(){var m=document.getElementById('js-data');if(m){DATA.privacy=m.getAttribute('data-privacy-title')||'Privacy';DATA.tc=m.getAttribute('data-tc-title')||'Terms';DATA.errLoad=m.getAttribute('data-err-load')||'Failed to load';DATA.notifyMsg=m.getAttribute('data-notify-msg')||'';DATA.notifyType=m.getAttribute('data-notify-type')||'';}})();

        document.addEventListener('DOMContentLoaded',function(){
            var saved=localStorage.getItem('bs-theme');
            if(saved)document.documentElement.setAttribute('data-bs-theme',saved);
            var dmBtn=document.getElementById('dmToggle'),dmIcon=dmBtn.querySelector('i');
            function updIcon(){var isDark=document.documentElement.getAttribute('data-bs-theme')==='dark';dmIcon.className=isDark?'bi bi-sun-fill':'bi bi-moon-fill'}
            updIcon();
            dmBtn.addEventListener('click',function(){
                var cur=document.documentElement.getAttribute('data-bs-theme'),next=cur==='dark'?'light':'dark';
                document.documentElement.setAttribute('data-bs-theme',next);localStorage.setItem('bs-theme',next);
                document.getElementById('themeColorMeta').setAttribute('content',next==='dark'?'#0b1120':'#7c3aed');updIcon();
            });
            if(DATA.notifyMsg)showToast(DATA.notifyMsg,DATA.notifyType);

            document.querySelectorAll('.field-wrap input').forEach(function(input){
                if(input.value)input.parentElement.classList.add('filled');
                input.addEventListener('input',function(){if(this.value)this.parentElement.classList.add('filled');else this.parentElement.classList.remove('filled')});
                input.addEventListener('animationstart',function(e){if(e.animationName==='onAutoFillStart')this.parentElement.classList.add('filled')});
            });
        });

        function showToast(msg,type){var c=document.getElementById('toastContainer'),el=document.createElement('div');el.className='toast-item '+type;el.textContent=msg;c.appendChild(el);setTimeout(function(){el.style.opacity='0';el.style.transition='opacity .25s';setTimeout(function(){el.remove()},300)},4000)}

        var currentStep=1,userCoords=null,covInCoverage=false,otpVerified=false;

        function goStep(n){
            document.querySelectorAll('.step-panel').forEach(function(p){p.classList.remove('active')});
            document.getElementById('step'+n).classList.add('active');currentStep=n;
            var dots=document.querySelectorAll('.step-dot');
            dots.forEach(function(d,i){var s=parseInt(d.getAttribute('data-step'));d.classList.remove('active','done');if(s<n)d.classList.add('done');if(s===n)d.classList.add('active')});
            document.querySelectorAll('.step-line').forEach(function(l){var p=l.getAttribute('data-between').split('-');if(parseInt(p[1])<=n)l.classList.add('done');else l.classList.remove('done')});
        }

        var map=L.map('coverageMap',{zoomControl:true}).setView([-6.2,106.8],12);
        L.tileLayer('https://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',{subdomains:['mt0','mt1','mt2','mt3'],attribution:'&copy; Google'}).addTo(map);
        var marker,routerCircles=[];

        fetch(appUrl+'/ui/ui_custom/api/routers_coverage.php').then(function(r){return r.json()}).then(function(d){
            d.forEach(function(r){if(!r.coordinates)return;var c=r.coordinates.split(',').map(Number);if(isNaN(c[0])||isNaN(c[1]))return;
                var circle=L.circle([c[0],c[1]],{radius:Math.max((r.coverage||0)*1,100),color:'rgba(129,140,248,.3)',fillColor:'rgba(129,140,248,.08)',fillOpacity:1,weight:1.5});
                circle.addTo(map);routerCircles.push(circle);});
            if(routerCircles.length){var g=L.featureGroup(routerCircles);try{map.fitBounds(g.getBounds().pad(.2))}catch(e){}}
        }).catch(function(){});

        map.on('click',function(e){setMarker(e.latlng)});
        map.on('locationfound',function(e){map.setView(e.latlng,14);setMarker(e.latlng)});
        map.locate({setView:false,enableHighAccuracy:true});
        setTimeout(function(){if(!marker)map.locate({setView:true,enableHighAccuracy:true})},1000);

        function setMarker(ll){if(marker)map.removeLayer(marker);marker=L.marker(ll,{draggable:true}).addTo(map);marker.on('dragend',function(){updateCoord(marker.getLatLng())});updateCoord(ll)}

        function updateCoord(ll){
            userCoords=ll.lat.toFixed(6)+','+ll.lng.toFixed(6);
            covInCoverage=false;
            for(var i=0;i<routerCircles.length;i++){if(routerCircles[i].getLatLng().distanceTo(ll)<=routerCircles[i].getRadius()){covInCoverage=true;break}}
            var icon=document.getElementById('coordIcon'),status=document.getElementById('coordStatus');
            if(covInCoverage){icon.style.color=getComputedStyle(document.body).getPropertyValue('--cg');icon.className='bi bi-check-circle-fill';status.textContent='Within coverage area';status.className='coord-status in'}
            else{icon.style.color=getComputedStyle(document.body).getPropertyValue('--c5');icon.className='bi bi-exclamation-triangle-fill';status.textContent='Outside coverage';status.className='coord-status out'}
            document.getElementById('step1Next').disabled=false;
            fetch(appUrl+'/ui/ui_custom/api/save_guest_coords.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({coordinates:userCoords})});
        }

        document.getElementById('step1Next').addEventListener('click',function(){if(!covInCoverage&&!confirm('Lokasi di luar coverage. Tetap lanjut?'))return;goStep(2)});

        var otpInputs=document.querySelectorAll('#otpInputs input');
        document.getElementById('waPhone').addEventListener('input',function(){document.getElementById('sendOtpBtn').disabled=this.value.replace(/\D/g,'').length<10});

        function sendOTP(){
            var phone=document.getElementById('waPhone').value.replace(/\D/g,'');if(phone.length<10){showToast('Nomor WhatsApp tidak valid','error');return}
            var btn=document.getElementById('sendOtpBtn');btn.disabled=true;btn.innerHTML='Mengirim...';
            fetch(appUrl+'/ui/ui_custom/api/send_otp.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({phone:phone})})
            .then(function(r){return r.json()}).then(function(d){
                if(d.success){btn.style.display='none';document.getElementById('step2a').style.display='none';document.getElementById('step2b').style.display='block';document.getElementById('waDisplay').textContent=phone;otpInputs[0].focus()}
                else{btn.disabled=false;btn.innerHTML='Kirim Kode Verifikasi <i class="bi bi-whatsapp"></i>';showToast(d.message||'Gagal mengirim','error')}
            }).catch(function(){btn.disabled=false;btn.innerHTML='Kirim Kode Verifikasi <i class="bi bi-whatsapp"></i>';showToast('Gagal mengirim kode','error')});
        }

        otpInputs.forEach(function(input,idx){
            input.addEventListener('input',function(){if(this.value){if(idx<5)otpInputs[idx+1].focus()}else if(idx>0)otpInputs[idx-1].focus();checkOtp()});
            input.addEventListener('keydown',function(e){if(e.key==='Backspace'&&!this.value&&idx>0)otpInputs[idx-1].focus()});
            input.addEventListener('paste',function(e){e.preventDefault();var p=(e.clipboardData||window.clipboardData).getData('text').replace(/\D/g,'').substring(0,6);for(var i=0;i<6;i++){if(p[i]){otpInputs[i].value=p[i];otpInputs[i].classList.add('filled')}}checkOtp()});
        });

        function checkOtp(){var code='';otpInputs.forEach(function(i){code+=i.value});if(code.length<6)return;
            var msg=document.getElementById('otpMsg'),next=document.getElementById('step2Next');
            fetch(appUrl+'/ui/ui_custom/api/verify_otp.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({code:code})})
            .then(function(r){return r.json()}).then(function(d){
                if(d.success){otpVerified=true;otpInputs.forEach(function(i){i.classList.add('filled');i.disabled=true});msg.textContent='Verified';msg.className='field-hint ok';next.disabled=false}
                else{msg.textContent=d.message||'Invalid code';msg.className='field-hint err';document.getElementById('otpInputs').classList.add('shake');setTimeout(function(){document.getElementById('otpInputs').classList.remove('shake')},400);otpInputs.forEach(function(i){i.value='';i.classList.remove('filled');i.disabled=false});otpInputs[0].focus()}
            }).catch(function(){msg.textContent='Verification failed';msg.className='field-hint err'});
        }

        document.getElementById('step2Next').addEventListener('click',function(){goStep(3)});

        var checkTimer;
        document.getElementById('fullname').addEventListener('input',function(){var name=this.value.trim();if(!name)return;var parts=name.split(/\s+/);var user=parts.map(function(p){return p.charAt(0).toUpperCase()+p.slice(1).toLowerCase()}).join('');document.getElementById('username').value=user;checkUsername(user)});
        document.getElementById('username').addEventListener('input',function(){clearTimeout(checkTimer);var u=this.value.trim();if(u.length>=3)checkTimer=setTimeout(function(){checkUsername(u)},500)});

        function checkUsername(u){if(u.length<3)return;
            fetch(appUrl+'/ui/ui_custom/api/check_username.php?username='+encodeURIComponent(u)).then(function(r){return r.json()}).then(function(d){
                var hint=document.getElementById('usernameHint'),list=document.getElementById('suggestList');
                if(d.available){hint.innerHTML='<i class="bi bi-check-circle-fill"></i> Username tersedia';hint.className='field-hint ok';list.innerHTML=''}
                else{hint.textContent='Username sudah digunakan';hint.className='field-hint err';
                    if(d.suggestions.length){var s='';d.suggestions.forEach(function(x){s+='<span class="suggest-chip" onclick="selectSuggestion(\''+x+'\')">'+x+'</span>'});list.innerHTML=s}}
            }).catch(function(){});
        }

        function selectSuggestion(u){document.getElementById('username').value=u;checkUsername(u);document.querySelectorAll('.suggest-chip').forEach(function(c){c.classList.remove('selected')});event.target.classList.add('selected')}

        function togglePw(id,btn){var el=document.getElementById(id),icon=btn.querySelector('i');if(el.type==='password'){el.type='text';icon.className='bi bi-eye'}else{el.type='password';icon.className='bi bi-eye-slash'}}

        var regPhone='';
        document.getElementById('regForm').addEventListener('submit',function(e){
            var pw=document.getElementById('password').value,cpw=document.getElementById('cpassword').value;
            if(pw!==cpw){showToast('Password tidak cocok','error');e.preventDefault();return}
            if(!otpVerified){showToast('Verifikasi WhatsApp dulu','error');e.preventDefault();return}
            if(!userCoords){showToast('Pilih lokasi di map dulu','error');e.preventDefault();return}
            var btn=this.querySelector('button[type=submit]');
            var phone=document.getElementById('waPhone').value.replace(/\D/g,'');
            document.getElementById('phonenumber').value=phone;
            if(!regPhone){e.preventDefault();btn.disabled=true;btn.innerHTML='Menyimpan...';
                fetch(appUrl+'/ui/ui_custom/api/hold_registration_data.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({phone:phone,coordinates:userCoords})})
                .then(function(){regPhone=true;btn.disabled=false;btn.innerHTML='<i class="bi bi-person-check"></i> Selesai & Daftar';document.getElementById('regForm').submit()});
            }
        });
        {/literal}
    </script>
    {if isset($xfooter)}{$xfooter}{/if}
</body>
</html>
