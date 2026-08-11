var L={},CSRF='';
(function(){var m=document.getElementById('js-data');if(!m)return;
    ['light','dark','active','expired','noPlan','noTrx','days','recharge','extend','stop','buy','paid','pending','retry','error'].forEach(function(k){L[k]=m.getAttribute('data-t-'+k)||''});
    CSRF=m.getAttribute('data-csrf')||'';
})();

function loadTheme(){
    var s=localStorage.getItem('theme');
    if(!s&&matchMedia&&matchMedia('(prefers-color-scheme:light)').matches)s='light';
    if(!s)s='dark';document.documentElement.setAttribute('data-theme',s);updateThemeUI()
}
function toggleTheme(){
    var h=document.documentElement,c=h.getAttribute('data-theme'),n=c==='dark'?'light':'dark';
    h.setAttribute('data-theme',n);localStorage.setItem('theme',n);
    document.getElementById('themeColorMeta').setAttribute('content',n==='dark'?'#09090b':'#fafafa');updateThemeUI()
}
function updateThemeUI(){
    var d=document.documentElement.getAttribute('data-theme')==='dark';
    var dm=document.getElementById('dmBtn'),mi=document.getElementById('menuThemeIcon'),ml=document.getElementById('menuThemeLabel');
    if(dm)dm.querySelector('i').className=d?'bi bi-sun-fill':'bi bi-moon-fill';
    if(mi)mi.className=d?'bi bi-sun-fill':'bi bi-moon-stars';
    if(ml)ml.textContent=d?L.light:L.dark;
    var mt=document.getElementById('menuThemeToggle');
    if(mt)mt.classList.toggle('on',!d);
}

function showToast(m,t){var c=document.getElementById('toastContainer');var e=document.createElement('div');e.className='ti '+t;e.textContent=m;c.appendChild(e);setTimeout(function(){e.style.opacity='0';e.style.transition='opacity .3s';setTimeout(function(){e.remove()},300)},4000)}
function setCookie(n,v,d){var e='';if(d){var dt=new Date();dt.setTime(dt.getTime()+(d*24*60*60*1000));e='; expires='+dt.toUTCString()}document.cookie=n+'='+(v||'')+e+'; path=/'}

document.addEventListener('DOMContentLoaded',function(){
    loadTheme();
    var av=document.getElementById('avatarBtn'), nb=document.getElementById('notifBtn'), dm=document.getElementById('dmBtn');
    if(av)av.addEventListener('click',function(){new bootstrap.Offcanvas(document.getElementById('menuSheet')).show()});
    if(nb)nb.addEventListener('click',function(){window.location.href=appUrl+'/index.php?_route=mail'});
    if(dm)dm.addEventListener('click',toggleTheme);
    fetch(appUrl+'/index.php?_route=autoload_user/inbox_unread').then(function(r){return r.text()}).then(function(t){var n=parseInt(t)||0,b=document.getElementById('inboxBadge');if(n>0)b.style.display='flex';else b.style.display='none'}).catch(function(){});
    fetch(appUrl+'/ui/ui_custom/api/apply_registration_data.php',{credentials:'include'}).catch(function(){});
    var nd=document.getElementById('notify-data');if(nd){var m=nd.getAttribute('data-msg'),ty=nd.getAttribute('data-type');if(m)showToast(m,ty)}
    var slider=document.getElementById('nsChartWrap'),dots=document.querySelectorAll('#nsChartDots .ns-chart-dot-ind');
    if(slider&&dots.length){
        slider.addEventListener('scroll',function(){
            var idx=Math.round(slider.scrollLeft/slider.offsetWidth);
            dots.forEach(function(d,i){d.classList.toggle('active',i===idx)});
        });
    }
});

if(typeof userLang!=='undefined')setCookie('user_language',userLang,365);

fetch(appUrl+'/ui/ui_custom/api/plan.php',{credentials:'include'}).then(function(r){return r.json()}).then(function(d){if(typeof d.balance_formatted!=='undefined'){var ab=document.getElementById('abBal');if(ab){ab.className='';ab.style.cssText='';ab.textContent=d.balance_formatted}}}).catch(function(){});

var pwModal=null;
function openPwModal(){
    var pw=document.getElementById('pwCurrent'),pn=document.getElementById('pwNew'),pc=document.getElementById('pwConfirm');
    if(pw)pw.value='';if(pn)pn.value='';if(pc)pc.value='';
    [pw,pn,pc].forEach(function(i){if(i&&i.parentElement)i.parentElement.classList.remove('filled')});
    if(!pwModal)pwModal=new bootstrap.Offcanvas(document.getElementById('pwModal'));
    pwModal.show();
}
function togglePw(id,btn){
    var el=document.getElementById(id),icon=btn.querySelector('i');
    if(el.type==='password'){el.type='text';icon.className='bi bi-eye'}
    else{el.type='password';icon.className='bi bi-eye-slash'}
}
function showDots(el){el._old=el.innerHTML;el.innerHTML='<div class=\"btn-dots\" style=\"display:flex;gap:6px;justify-content:center\"><span></span><span></span><span></span></div>';el.disabled=true}
function hideDots(el){el.innerHTML=el._old;el.disabled=false}

function changePassword(e){
    e.preventDefault();
    var btn=document.getElementById('pwSubmit');
    showDots(btn);
    var txt=btn.getAttribute('data-text')||'Save New Password';
    var data={
        password:document.getElementById('pwCurrent').value,
        npass:document.getElementById('pwNew').value,
        cnpass:document.getElementById('pwConfirm').value
    };
    fetch(appUrl+'/ui/ui_custom/api/change_password.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(data)})
    .then(function(r){return r.json()}).then(function(d){
        if(d.success){
            var body=document.querySelector('#pwModal .offcanvas-body');
            body.innerHTML='<div style=\"text-align:center;padding:30px 0\"><i class=\"bi bi-check-circle-fill\" style=\"font-size:3rem;color:var(--c4);display:block;margin-bottom:12px\"></i><p style=\"font-size:.9rem;color:var(--tx);margin-bottom:8px\">Password berhasil diubah</p><p style=\"font-size:.7rem;color:var(--t3)\">Mengalihkan ke login...</p></div>';
            setTimeout(function(){window.location.href=d.redirect},2000);
        }
        else{hideDots(btn);btn.innerHTML='<i class=\"bi bi-check-lg\"></i> '+txt;showToast(d.message,'error')}
    }).catch(function(){hideDots(btn);btn.innerHTML='<i class=\"bi bi-check-lg\"></i> '+txt;showToast('Gagal','error')});
}

document.querySelectorAll('.field-wrap input').forEach(function(input){
    if(input.value)input.parentElement.classList.add('filled');
    input.addEventListener('input',function(){if(this.value)this.parentElement.classList.add('filled');else this.parentElement.classList.remove('filled')});
    input.addEventListener('animationstart',function(e){if(e.animationName==='onAutoFillStart')this.parentElement.classList.add('filled')});
});
