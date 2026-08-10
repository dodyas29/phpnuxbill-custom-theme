<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
{include file="components/_head_common.tpl"}
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css">
    <script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"></script>
    <style>
        {literal}
        .cw{max-width:480px;margin:0 auto;padding:20px 16px 40px}

        .step-progress{display:flex;align-items:center;justify-content:center;gap:0;margin-bottom:28px}
        .step-dot{width:32px;height:32px;border-radius:50%;background:var(--bgc);display:flex;align-items:center;justify-content:center;font-size:.7rem;font-weight:700;color:var(--t3);transition:all .3s;flex-shrink:0}
        .step-dot.done{background:var(--c4);color:#fff}
        .step-dot.active{background:var(--c1);color:#fff;box-shadow:0 0 0 4px rgba(129,140,248,.25)}
        .step-line{flex:1;height:2px;background:var(--bd);max-width:40px;transition:all .3s}
        .step-line.done{background:var(--c4)}

        .step-panel{display:none;animation:slideIn .3s ease-out}
        .step-panel.active{display:block}
        @keyframes slideIn{from{opacity:0;transform:translateX(16px)}to{opacity:1;transform:translateX(0)}}

        #coverageMap{width:100%;height:320px;border-radius:var(--r2);border:1px solid var(--bd);margin-bottom:14px;z-index:0}
        .leaflet-control-zoom a{background:var(--bgs)!important;color:var(--tx)!important;border-color:var(--bd)!important}
        .coord-display{background:var(--bgs);border:1px solid var(--bd);border-radius:var(--r2);padding:12px 16px;display:flex;align-items:center;gap:10px;font-size:.78rem;color:var(--tx);margin-bottom:14px}
        .coord-display i{font-size:1rem;flex-shrink:0}
        .coord-status{font-size:.68rem;margin-top:2px;font-weight:600}
        .coord-status.in{color:var(--c4)}
        .coord-status.out{color:var(--c5)}

        .field-wrap{position:relative;background:var(--bg);border:2px solid var(--bd);border-radius:var(--rm);transition:all .2s;margin-bottom:16px}
        .field-wrap:focus-within{border-color:var(--cp);box-shadow:0 0 0 3px rgba(124,58,237,.12)}
        .field-wrap input{width:100%;border:none;background:transparent;padding:22px 14px 10px 14px;font-size:.95rem;color:var(--tx);outline:none;font-family:var(--ff);box-shadow:none;-webkit-appearance:none;-moz-appearance:none;border-radius:0.8rem}
        .field-wrap input:-webkit-autofill,.field-wrap input:-webkit-autofill:hover,.field-wrap input:-webkit-autofill:focus{-webkit-box-shadow:0 0 0 60px var(--bg) inset!important;-webkit-text-fill-color:var(--tx)!important;background-color:var(--bg)!important;transition:background-color 9999s ease-in-out 0s;animation:onAutoFillStart .01s}
        .field-wrap input::placeholder{color:transparent}
        .fl{position:absolute;left:14px;top:50%;transform:translateY(-50%);font-size:.95rem;color:var(--t3);pointer-events:none;transition:all .2s ease;font-family:var(--ff);font-weight:400}
        .field-wrap:focus-within .fl,.field-wrap input:not(:placeholder-shown) ~ .fl,.field-wrap.filled .fl{top:7px;font-size:.62rem;color:var(--cp);font-weight:600;letter-spacing:.5px;text-transform:uppercase;transform:translateY(0)}
        .field-wrap .pw-toggle{position:absolute;right:0;top:50%;transform:translateY(-50%);background:none;border:none;color:var(--t3);cursor:pointer;padding:12px 14px;font-size:1.1rem;z-index:1}
        .field-hint{font-size:.62rem;color:var(--t3);margin-top:-12px;margin-bottom:16px;padding-left:4px;min-height:16px}
        .field-hint.ok{color:var(--c4)}
        .field-hint.err{color:var(--c6)}

        .otp-inputs{display:flex;gap:10px;justify-content:center;margin-bottom:16px}
        .otp-inputs input{width:44px;height:52px;text-align:center;font-size:1.3rem;font-weight:700;background:var(--bg);border:2px solid var(--bd);border-radius:var(--r1);color:var(--tx);outline:none;font-family:'Courier New',monospace;transition:all .15s}
        .otp-inputs input:focus{border-color:var(--cp);box-shadow:0 0 0 3px rgba(124,58,237,.12)}
        .otp-inputs input.filled{border-color:var(--c4)}

        .vbtn{width:100%;display:flex;align-items:center;justify-content:center;gap:8px;padding:15px 24px;border-radius:var(--rp);font-size:.82rem;font-weight:700;cursor:pointer;transition:all .15s;background:linear-gradient(135deg,var(--c1),var(--c2));color:#fff;border:none;letter-spacing:.4px;font-family:var(--ff)}
        .vbtn:active{transform:scale(.97);filter:brightness(.9)}
        .vbtn:disabled{opacity:.4;cursor:not-allowed}

        .suggest-list{display:flex;flex-wrap:wrap;gap:8px;margin-bottom:16px}
        .suggest-chip{padding:6px 14px;border-radius:var(--rp);background:var(--bgc);border:1px solid var(--bd);font-size:.72rem;font-weight:600;color:var(--tx);cursor:pointer;transition:all .1s;font-family:var(--ff)}
        .suggest-chip:hover{border-color:var(--c1);color:var(--c1)}
        .suggest-chip.selected{background:var(--c1);color:#fff;border-color:var(--c1)}

        @keyframes onAutoFillStart{from{}to{}}
        @keyframes shake{0%,100%{transform:translateX(0)}25%{transform:translateX(-6px)}75%{transform:translateX(6px)}}
        .shake{animation:shake .4s ease}
        {/literal}
    </style>
</head>
<body>
{include file="components/_header.tpl"}

    <div class="cw">
        <section>
            <div class="sh stg"><h2>Create Account</h2></div>
            <div class="step-progress" id="stepper">
                <span class="step-dot active" data-step="1">1</span><span class="step-line" data-between="1-2"></span>
                <span class="step-dot" data-step="2">2</span><span class="step-line" data-between="2-3"></span>
                <span class="step-dot" data-step="3">3</span>
            </div>
        </section>

        <section class="step-panel active" id="step1">
            <div class="sh stg"><h2>Coverage Check</h2></div>
            <div id="coverageMap" class="stg"></div>
            <div class="coord-display stg" id="coordDisplay" style="display:none">
                <i class="bi bi-geo-alt-fill" style="color:var(--c6)" id="coordIcon"></i>
                <div style="flex:1;min-width:0">
                    <div id="coordText">Click map to select location</div>
                    <div class="coord-status" id="coordStatus"></div>
                </div>
            </div>
            <button class="vbtn stg" id="step1Next" disabled>Selanjutnya <i class="bi bi-arrow-right"></i></button>
        </section>

        <section class="step-panel" id="step2">
            <div class="sh stg"><h2>WhatsApp Verification</h2></div>
            <div id="step2a">
                <div class="field-wrap stg">
                    <span class="fl">WhatsApp Number</span>
                    <input type="tel" id="waPhone" placeholder="WhatsApp Number" inputmode="numeric">
                </div>
                <button class="vbtn stg" id="sendOtpBtn" disabled>Kirim Kode Verifikasi <i class="bi bi-whatsapp"></i></button>
            </div>
            <div id="step2b" style="display:none">
                <div class="coord-display stg" style="margin-bottom:16px">
                    <i class="bi bi-whatsapp" style="color:#25D366;font-size:1.2rem"></i>
                    <div style="flex:1;font-size:.78rem;color:var(--tx)">Kode dikirim ke <strong id="waDisplay">-</strong></div>
                </div>
                <div class="otp-inputs stg" id="otpInputs">
                    <input type="text" maxlength="1" inputmode="numeric" pattern="[0-9]">
                    <input type="text" maxlength="1" inputmode="numeric" pattern="[0-9]">
                    <input type="text" maxlength="1" inputmode="numeric" pattern="[0-9]">
                    <input type="text" maxlength="1" inputmode="numeric" pattern="[0-9]">
                    <input type="text" maxlength="1" inputmode="numeric" pattern="[0-9]">
                    <input type="text" maxlength="1" inputmode="numeric" pattern="[0-9]">
                </div>
                <div class="field-hint stg" id="otpMsg"></div>
                <button class="vbtn stg" id="step2Next" disabled>Verifikasi & Lanjut <i class="bi bi-arrow-right"></i></button>
            </div>
        </section>

        <section class="step-panel" id="step3">
            <div class="sh stg"><h2>Account Details</h2></div>
            <form id="regForm" action="{Text::url('register/post')}" method="post" enctype="multipart/form-data">
                <input type="hidden" name="csrf_token" value="{$csrf_token}">
                <div class="field-wrap stg">
                    <span class="fl">{Lang::T('Full Name')}</span>
                    <input type="text" name="fullname" id="fullname" required placeholder="{Lang::T('Full Name')}">
                </div>
                <div class="field-wrap stg">
                    <span class="fl">{Lang::T('Username')}</span>
                    <input type="text" name="username" id="username" required placeholder="{Lang::T('Username')}">
                </div>
                <div class="field-hint stg" id="usernameHint">Auto-generated from your name</div>
                <div class="suggest-list stg" id="suggestList"></div>
                <div class="field-wrap stg">
                    <span class="fl">{Lang::T('Password')}</span>
                    <input type="password" name="password" id="password" required placeholder="{Lang::T('Password')}">
                    <button type="button" class="pw-toggle" onclick="togglePw('password',this)"><i class="bi bi-eye-slash"></i></button>
                </div>
                <div class="field-wrap stg" style="margin-bottom:20px">
                    <span class="fl">{Lang::T('Confirm Password')}</span>
                    <input type="password" name="cpassword" id="cpassword" required placeholder="{Lang::T('Confirm Password')}">
                    <button type="button" class="pw-toggle" onclick="togglePw('cpassword',this)"><i class="bi bi-eye-slash"></i></button>
                </div>
                <input type="hidden" name="phonenumber" id="phonenumber">
                <button type="submit" class="vbtn stg"><i class="bi bi-person-check"></i> Selesai & Daftar</button>
            </form>
            <p class="stg" style="text-align:center;font-size:.78rem;color:var(--t2);margin-top:20px">Sudah punya akun? <a href="{Text::url('login')}" style="color:var(--c1);text-decoration:none;font-weight:600">Login</a></p>
        </section>
    </div>

{include file="components/_navbar.tpl"}
{include file="components/_menu_sheet.tpl"}
    <div class="tc" id="toastContainer"></div>
{include file="components/_scripts_common.tpl"}

    <script>
        {literal}
        var currentStep=1,userCoords=null,covInCoverage=false,otpVerified=false;

        function goStep(n){
            document.querySelectorAll('.step-panel').forEach(function(p){p.classList.remove('active')});
            document.getElementById('step'+n).classList.add('active');
            currentStep=n;
            var dots=document.querySelectorAll('.step-dot');
            dots.forEach(function(d,i){
                var s=parseInt(d.getAttribute('data-step'));
                d.classList.remove('active','done');
                if(s<n)d.classList.add('done');if(s===n)d.classList.add('active');
            });
            document.querySelectorAll('.step-line').forEach(function(l){var p=l.getAttribute('data-between').split('-');if(parseInt(p[1])<=n)l.classList.add('done');else l.classList.remove('done')});
        }

        var map=L.map('coverageMap',{zoomControl:true}).setView([-6.2,106.8],12);
        L.tileLayer('https://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',{subdomains:['mt0','mt1','mt2','mt3'],attribution:'&copy; Google'}).addTo(map);
        var marker,routerCircles=[];

        fetch(appUrl+'/ui/ui_custom/api/routers_coverage.php').then(function(r){return r.json()}).then(function(d){
            var bounds=[];
            d.forEach(function(r){
                if(!r.coordinates)return;
                var c=r.coordinates.split(',').map(Number);
                if(isNaN(c[0])||isNaN(c[1]))return;
                var circle=L.circle([c[0],c[1]],{radius:Math.max((r.coverage||0)*1,100),color:'rgba(129,140,248,.3)',fillColor:'rgba(129,140,248,.08)',fillOpacity:1,weight:1.5});
                circle.addTo(map);routerCircles.push(circle);bounds.push([c[0],c[1]]);
            });
            if(bounds.length){var g=L.featureGroup(routerCircles);try{map.fitBounds(g.getBounds().pad(.2))}catch(e){}}
        }).catch(function(){});

        map.on('click',function(e){setMarker(e.latlng)});
        map.on('locationfound',function(e){map.setView(e.latlng,14);setMarker(e.latlng)});
        map.locate({setView:false,enableHighAccuracy:true});
        setTimeout(function(){if(!marker)map.locate({setView:true,enableHighAccuracy:true})},1000);

        function setMarker(ll){
            if(marker)map.removeLayer(marker);
            marker=L.marker(ll,{draggable:true}).addTo(map);
            marker.on('dragend',function(){updateCoord(marker.getLatLng())});
            updateCoord(ll);
        }

        function updateCoord(ll){
            userCoords=ll.lat.toFixed(6)+','+ll.lng.toFixed(6);
            document.getElementById('coordText').textContent='Lat: '+ll.lat.toFixed(6)+'  Lng: '+ll.lng.toFixed(6);
            document.getElementById('coordDisplay').style.display='flex';
            covInCoverage=false;
            for(var i=0;i<routerCircles.length;i++){if(routerCircles[i].getLatLng().distanceTo(ll)<=routerCircles[i].getRadius()){covInCoverage=true;break}}
            var icon=document.getElementById('coordIcon'),status=document.getElementById('coordStatus');
            if(covInCoverage){icon.style.color='var(--c4)';icon.className='bi bi-check-circle-fill';status.textContent='Within coverage area';status.className='coord-status in'}
            else{icon.style.color='var(--c5)';icon.className='bi bi-exclamation-triangle-fill';status.textContent='Outside coverage';status.className='coord-status out'}
            document.getElementById('step1Next').disabled=false;
            fetch(appUrl+'/ui/ui_custom/api/save_guest_coords.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({coordinates:userCoords})});
        }

        document.getElementById('step1Next').addEventListener('click',function(){
            if(!covInCoverage&&!confirm('Lokasi di luar coverage. Tetap lanjut?'))return;
            goStep(2);
        });

        var otpInputs=document.querySelectorAll('#otpInputs input');
        document.getElementById('waPhone').addEventListener('input',function(){document.getElementById('sendOtpBtn').disabled=this.value.replace(/\D/g,'').length<10});

        function sendOTP(){
            var phone=document.getElementById('waPhone').value.replace(/\D/g,'');
            if(phone.length<10){showToast('Nomor WhatsApp tidak valid','error');return}
            var btn=document.getElementById('sendOtpBtn');
            btn.disabled=true;btn.innerHTML='<span style="width:16px;height:16px;border:2px solid rgba(255,255,255,.3);border-top-color:#fff;border-radius:50%;animation:spin .7s linear infinite;display:inline-block"></span> Mengirim...';
            fetch(appUrl+'/ui/ui_custom/api/send_otp.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({phone:phone})})
            .then(function(r){return r.json()}).then(function(d){
                if(d.success){
                    btn.style.display='none';document.getElementById('step2a').style.display='none';
                    document.getElementById('step2b').style.display='block';document.getElementById('waDisplay').textContent=phone;
                    otpInputs[0].focus();
                }else{btn.disabled=false;btn.innerHTML='Kirim Kode Verifikasi <i class="bi bi-whatsapp"></i>';showToast(d.message||'Gagal mengirim','error')}
            }).catch(function(){btn.disabled=false;btn.innerHTML='Kirim Kode Verifikasi <i class="bi bi-whatsapp"></i>';showToast('Gagal mengirim kode','error')});
        }

        otpInputs.forEach(function(input,idx){
            input.addEventListener('input',function(){if(this.value){if(idx<5)otpInputs[idx+1].focus()}else if(idx>0)otpInputs[idx-1].focus();checkOtp()});
            input.addEventListener('keydown',function(e){if(e.key==='Backspace'&&!this.value&&idx>0)otpInputs[idx-1].focus()});
            input.addEventListener('paste',function(e){e.preventDefault();var p=(e.clipboardData||window.clipboardData).getData('text').replace(/\D/g,'').substring(0,6);for(var i=0;i<6;i++){if(p[i]){otpInputs[i].value=p[i];otpInputs[i].classList.add('filled')}}checkOtp()});
        });

        function checkOtp(){
            var code='';otpInputs.forEach(function(i){code+=i.value});if(code.length<6)return;
            var msg=document.getElementById('otpMsg'),next=document.getElementById('step2Next');
            fetch(appUrl+'/ui/ui_custom/api/verify_otp.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({code:code})})
            .then(function(r){return r.json()}).then(function(d){
                if(d.success){otpVerified=true;otpInputs.forEach(function(i){i.classList.add('filled');i.disabled=true});msg.textContent='Verified';msg.className='field-hint ok';next.disabled=false}
                else{msg.textContent=d.message||'Invalid code';msg.className='field-hint err';document.getElementById('otpInputs').classList.add('shake');setTimeout(function(){document.getElementById('otpInputs').classList.remove('shake')},400);otpInputs.forEach(function(i){i.value='';i.classList.remove('filled');i.disabled=false});otpInputs[0].focus()}
            }).catch(function(){msg.textContent='Verification failed';msg.className='field-hint err'});
        }

        document.getElementById('step2Next').addEventListener('click',function(){goStep(3)});

        var checkTimer;
        document.getElementById('fullname').addEventListener('input',function(){
            var name=this.value.trim();if(!name)return;
            var parts=name.split(/\s+/);
            var user=parts.map(function(p){return p.charAt(0).toUpperCase()+p.slice(1).toLowerCase()}).join('');
            document.getElementById('username').value=user;checkUsername(user);
        });
        document.getElementById('username').addEventListener('input',function(){
            clearTimeout(checkTimer);var u=this.value.trim();
            if(u.length>=3)checkTimer=setTimeout(function(){checkUsername(u)},500);
        });

        function checkUsername(u){
            if(u.length<3)return;
            fetch(appUrl+'/ui/ui_custom/api/check_username.php?username='+encodeURIComponent(u))
            .then(function(r){return r.json()}).then(function(d){
                var hint=document.getElementById('usernameHint'),list=document.getElementById('suggestList');
                if(d.available){hint.innerHTML='<i class="bi bi-check-circle-fill"></i> Username tersedia';hint.className='field-hint ok';list.innerHTML=''}
                else{
                    hint.textContent='Username sudah digunakan';hint.className='field-hint err';
                    if(d.suggestions.length){var s='';d.suggestions.forEach(function(x){s+='<span class="suggest-chip" onclick="selectSuggestion(\''+x+'\')">'+x+'</span>'});list.innerHTML=s}
                }
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
            if(!regPhone){
                e.preventDefault();btn.disabled=true;btn.innerHTML='<span style=\"width:16px;height:16px;border:2px solid rgba(255,255,255,.3);border-top-color:#fff;border-radius:50%;animation:spin .7s linear infinite;display:inline-block\"></span> Menyimpan...';
                fetch(appUrl+'/ui/ui_custom/api/hold_registration_data.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({phone:phone,coordinates:userCoords})})
                .then(function(){regPhone=true;btn.disabled=false;btn.innerHTML='<i class=\"bi bi-person-check\"></i> Selesai & Daftar';document.getElementById('regForm').submit()});
                return;
            }
        });

        document.querySelectorAll('.field-wrap input').forEach(function(input){
            if(input.value)input.parentElement.classList.add('filled');
            input.addEventListener('input',function(){if(this.value)this.parentElement.classList.add('filled');else this.parentElement.classList.remove('filled')});
            input.addEventListener('animationstart',function(e){if(e.animationName==='onAutoFillStart')this.parentElement.classList.add('filled')});
        });
        {/literal}
    </script>
</body>
</html>
