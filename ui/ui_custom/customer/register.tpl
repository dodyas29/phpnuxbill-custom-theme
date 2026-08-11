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
    <link rel="stylesheet" href="{$app_url}/ui/ui_custom/assets/css/register.css">
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
                    <button class="btn" id="sendOtpBtn" disabled onclick="sendOTP()">Kirim Kode Verifikasi <i class="bi bi-whatsapp"></i></button>
                    <div style="text-align:center;margin-top:20px"><a href="javascript:void(0)" onclick="goBack(1)" style="color:var(--t2);text-decoration:none;font-size:.78rem;font-weight:500"><i class="bi bi-arrow-left"></i> Kembali</a></div>
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
                    <div style="text-align:center;margin-top:20px"><a href="javascript:void(0)" onclick="resetOTP()" style="color:var(--t2);text-decoration:none;font-size:.78rem;font-weight:500"><i class="bi bi-arrow-left"></i> Kembali</a></div>
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
                    <div style="text-align:center;margin-top:20px"><a href="javascript:void(0)" onclick="goBack(2)" style="color:var(--t2);text-decoration:none;font-size:.78rem;font-weight:500"><i class="bi bi-arrow-left"></i> Kembali</a></div>
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

        function showDots(el){el._old=el.innerHTML;el.innerHTML='<div class="btn-dots"><span></span><span></span><span></span></div>';el.disabled=true}
        function hideDots(el){el.innerHTML=el._old;el.disabled=false}

        function goBack(n){
            document.querySelectorAll('.step-panel').forEach(function(p){p.classList.remove('active')});
            document.getElementById('step'+n).classList.add('active');currentStep=n;
            var dots=document.querySelectorAll('.step-dot');
            dots.forEach(function(d,i){var s=parseInt(d.getAttribute('data-step'));d.classList.remove('active','done');if(s<n)d.classList.add('done');if(s===n)d.classList.add('active')});
            document.querySelectorAll('.step-line').forEach(function(l){var p=l.getAttribute('data-between').split('-');if(parseInt(p[1])<=n)l.classList.add('done');else l.classList.remove('done')});
        }

        function goStep(n){
            var btn=document.querySelector('#step'+currentStep+' .btn');
            if(btn&&!btn.disabled){showDots(btn);setTimeout(function(){hideDots(btn);
            document.querySelectorAll('.step-panel').forEach(function(p){p.classList.remove('active')});
            document.getElementById('step'+n).classList.add('active');currentStep=n;
            var dots=document.querySelectorAll('.step-dot');
            dots.forEach(function(d,i){var s=parseInt(d.getAttribute('data-step'));d.classList.remove('active','done');if(s<n)d.classList.add('done');if(s===n)d.classList.add('active')});
            document.querySelectorAll('.step-line').forEach(function(l){var p=l.getAttribute('data-between').split('-');if(parseInt(p[1])<=n)l.classList.add('done');else l.classList.remove('done')});
            },300)}
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
            var phone=document.getElementById('waPhone').value.replace(/\D/g,'');
            if(phone.length<10){showToast('Nomor WhatsApp tidak valid','error');return}
            var btn=document.getElementById('sendOtpBtn');
            showDots(btn);
            setTimeout(function(){
                hideDots(btn);btn.style.display='none';document.getElementById('step2a').style.display='none';
                document.getElementById('step2b').style.display='block';
                document.getElementById('waDisplay').textContent=phone;otpInputs[0].focus();
            },800);
        }

        otpInputs.forEach(function(input,idx){
            input.addEventListener('input',function(){if(this.value){if(idx<5)otpInputs[idx+1].focus()}else if(idx>0)otpInputs[idx-1].focus();checkOtp()});
            input.addEventListener('keydown',function(e){if(e.key==='Backspace'&&!this.value&&idx>0)otpInputs[idx-1].focus()});
            input.addEventListener('paste',function(e){e.preventDefault();var p=(e.clipboardData||window.clipboardData).getData('text').replace(/\D/g,'').substring(0,6);for(var i=0;i<6;i++){if(p[i]){otpInputs[i].value=p[i];otpInputs[i].classList.add('filled')}}checkOtp()});
        });

        function resetOTP(){
            document.getElementById('step2a').style.display='block';
            document.getElementById('step2b').style.display='none';
            document.getElementById('sendOtpBtn').style.display='';
            document.getElementById('sendOtpBtn').disabled=false;
            otpInputs.forEach(function(i){i.value='';i.classList.remove('filled');i.disabled=false});
        }

        function checkOtp(){var code='';otpInputs.forEach(function(i){code+=i.value});if(code.length<6)return;
            var msg=document.getElementById('otpMsg'),next=document.getElementById('step2Next');
            otpVerified=true;otpInputs.forEach(function(i){i.classList.add('filled');i.disabled=true});
            msg.textContent='Verified';msg.className='field-hint ok';next.disabled=false;
        }

        document.getElementById('step2Next').addEventListener('click',function(){
            var b=this;showDots(b);
            setTimeout(function(){hideDots(b);goStep(3)},300);
        });

        var checkTimer;
        document.getElementById('fullname').addEventListener('input',function(){var name=this.value.trim();if(!name)return;var parts=name.split(/\s+/);var user=parts.map(function(p){return p.charAt(0).toUpperCase()+p.slice(1).toLowerCase()}).join('');document.getElementById('username').value=user;checkUsername(user)});
        document.getElementById('username').addEventListener('input',function(){clearTimeout(checkTimer);var u=this.value.trim();if(u.length>=3)checkTimer=setTimeout(function(){checkUsername(u)},500)});

        function checkUsername(u){if(u.length<3)return;
            fetch(appUrl+'/ui/ui_custom/api/check_username.php?username='+encodeURIComponent(u)).then(function(r){return r.json()}).then(function(d){
                var hint=document.getElementById('usernameHint');
                if(d.available){hint.innerHTML='<i class="bi bi-check-circle-fill"></i> Username tersedia';hint.className='field-hint ok'}
                else{hint.innerHTML='<span style=\"color:var(--t3)\">Username sudah digunakan.</span> '+(d.suggestions.length?'Saran: <a href=\"javascript:void(0)\" class=\"suggest-link\" onclick=\"selectSuggestion(\''+d.suggestions[0]+'\')\">'+d.suggestions[0]+'</a>':'');
                    hint.className='field-hint'}
            }).catch(function(){});
        }

        function selectSuggestion(u){document.getElementById('username').value=u;checkUsername(u);}

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
            if(!regPhone){e.preventDefault();showDots(btn);
                fetch(appUrl+'/ui/ui_custom/api/hold_registration_data.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({phone:phone,coordinates:userCoords})})
                .then(function(){hideDots(btn);regPhone=true;btn.disabled=false;btn.innerHTML='<i class="bi bi-person-check"></i> Selesai & Daftar';document.getElementById('regForm').submit()});
            }
        });
        {/literal}
    </script>
    {if isset($xfooter)}{$xfooter}{/if}
</body>
</html>
