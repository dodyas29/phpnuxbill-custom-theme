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
    fetch(appUrl+'/ui/ui_custom/customer/api/apply_registration_data.php',{credentials:'include'}).catch(function(){});
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

fetch(appUrl+'/ui/ui_custom/customer/api/plan.php',{credentials:'include'}).then(function(r){return r.json()}).then(function(d){if(typeof d.balance_formatted!=='undefined'){var ab=document.getElementById('abBal');if(ab){ab.className='';ab.style.cssText='';ab.textContent=d.balance_formatted}}}).catch(function(){});

function showDots(el){el._old=el.innerHTML;el.innerHTML='<div class=\"btn-dots\" style=\"display:flex;gap:6px;justify-content:center\"><span></span><span></span><span></span></div>';el.disabled=true}
function hideDots(el){el.innerHTML=el._old;el.disabled=false}

document.querySelectorAll('.field-wrap input').forEach(function(input){
    if(input.value)input.parentElement.classList.add('filled');
    input.addEventListener('input',function(){if(this.value)this.parentElement.classList.add('filled');else this.parentElement.classList.remove('filled')});
    input.addEventListener('animationstart',function(e){if(e.animationName==='onAutoFillStart')this.parentElement.classList.add('filled')});
});

var balanceModalBS=null,balanceErrModalBS=null,balancePlanId=null,balanceCustom=false;
function getBalanceChannels(cb){
    fetch(appUrl+'/ui/ui_custom/customer/api/tripay_channels.php',{credentials:'include'})
    .then(function(r){return r.json()}).then(function(d){
        var h='';d.forEach(function(ch){
            var logo=ch.logo?'<img src=\"'+appUrl+'/ui/ui_custom/customer/'+ch.logo+'\" onerror=\"this.style.display=\\\'none\\\';this.nextElementSibling.style.display=\\\'block\\\'\"><span style=\"display:none\">'+ch.init.substring(0,2)+'</span>':'<span>'+ch.init.substring(0,2)+'</span>';
            h+='<div class=\"rch-item\" data-channel=\"'+ch.id+'\" onclick=\"selectBalanceChannel(this)\"><span class=\"rch-logo\" style=\"background:'+(ch.color||'#666')+'\">'+logo+'</span><span class=\"rch-name\">'+ch.name+'</span><i class=\"bi bi-chevron-right rch-arrow\"></i></div>';
        });
        document.getElementById('balanceSkel').style.display='none';
        document.getElementById('balanceList').innerHTML=h;
        if(cb)cb();
    });
}
function openBalanceModal(pid){
    if(!balanceModalBS)balanceModalBS=new bootstrap.Offcanvas(document.getElementById('balanceModal'));
    balancePlanId=pid;balanceCustom=false;
    document.getElementById('balanceSkel').style.display='block';
    document.getElementById('balanceList').innerHTML='';
    balanceModalBS.show();
    getBalanceChannels();
}
function openCustomBalanceModal(){
    var inp=document.getElementById('balCustomAmount');
    var amt=parseInt(inp.value)||0;
    if(amt<=0){showToast('Masukkan jumlah top up','error');return}
    if(!balanceModalBS)balanceModalBS=new bootstrap.Offcanvas(document.getElementById('balanceModal'));
    balancePlanId=0;balanceCustom=true;
    document.getElementById('balanceSkel').style.display='block';
    document.getElementById('balanceList').innerHTML='';
    balanceModalBS.show();
    getBalanceChannels();
}
function selectBalanceChannel(el){
    var channel=el.getAttribute('data-channel');
    el.classList.add('loading');
    el.querySelector('.rch-arrow').outerHTML='<span class=\"btn-dots\" style=\"display:flex;gap:4px\"><span style=\"width:6px;height:6px;border-radius:50%;background:var(--c1);animation:dotJump .5s infinite alternate\"></span><span style=\"width:6px;height:6px;border-radius:50%;background:var(--c1);animation:dotJump .5s infinite alternate;animation-delay:.15s\"></span><span style=\"width:6px;height:6px;border-radius:50%;background:var(--c1);animation:dotJump .5s infinite alternate;animation-delay:.3s\"></span></span>';
    var body={channel:channel};
    if(balanceCustom){
        var amt=parseInt(document.getElementById('balCustomAmount').value)||0;
        body.plan_id=0;body.custom=true;body.amount=amt;
    }else{
        body.plan_id=balancePlanId;
    }
    fetch(appUrl+'/ui/ui_custom/customer/api/balance_payment.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(body)})
    .then(function(r){return r.json()}).then(function(d){
        if(d.success&&d.url){window.location.href=d.url}
        else{el.classList.remove('loading');el.querySelector('.btn-dots').outerHTML='<i class=\"bi bi-chevron-right rch-arrow\"></i>';showBalanceError(d.error||'Gagal membuat transaksi')}
    }).catch(function(){el.classList.remove('loading');el.querySelector('.btn-dots').outerHTML='<i class=\"bi bi-chevron-right rch-arrow\"></i>';showBalanceError('Gagal membuat transaksi')});
}
function showBalanceError(msg){
    if(balanceModalBS)balanceModalBS.hide();
    if(!balanceErrModalBS)balanceErrModalBS=new bootstrap.Offcanvas(document.getElementById('balanceErrModal'));
    document.getElementById('balanceErrMsg').textContent=msg;
    balanceErrModalBS.show();
}

var packageModalBS=null,packageErrModalBS=null,packagePlanId=null,packageRouter='';
function getPackageChannels(){
    fetch(appUrl+'/ui/ui_custom/customer/api/tripay_channels.php',{credentials:'include'})
    .then(function(r){return r.json()}).then(function(d){
        var h='';d.forEach(function(ch){
            var logo=ch.logo?'<img src=\"'+appUrl+'/ui/ui_custom/customer/'+ch.logo+'\" onerror=\"this.style.display=\\\'none\\\';this.nextElementSibling.style.display=\\\'block\\\'\"><span style=\"display:none\">'+ch.init.substring(0,2)+'</span>':'<span>'+ch.init.substring(0,2)+'</span>';
            h+='<div class=\"rch-item\" data-channel=\"'+ch.id+'\" onclick=\"selectPackageChannel(this)\"><span class=\"rch-logo\" style=\"background:'+(ch.color||'#666')+'\">'+logo+'</span><span class=\"rch-name\">'+ch.name+'</span><i class=\"bi bi-chevron-right rch-arrow\"></i></div>';
        });
        document.getElementById('packageSkel').style.display='none';
        document.getElementById('packageList').innerHTML=h;
    });
}
function openPackageModal(planId,routerName){
    if(!packageModalBS)packageModalBS=new bootstrap.Offcanvas(document.getElementById('packageModal'));
    packagePlanId=planId;packageRouter=routerName||'';
    document.getElementById('packageSkel').style.display='block';
    document.getElementById('packageList').innerHTML='';
    packageModalBS.show();
    getPackageChannels();
}
function selectPackageChannel(el){
    var channel=el.getAttribute('data-channel');
    el.classList.add('loading');
    el.querySelector('.rch-arrow').outerHTML='<span class=\"btn-dots\" style=\"display:flex;gap:4px\"><span style=\"width:6px;height:6px;border-radius:50%;background:var(--c1);animation:dotJump .5s infinite alternate\"></span><span style=\"width:6px;height:6px;border-radius:50%;background:var(--c1);animation:dotJump .5s infinite alternate;animation-delay:.15s\"></span><span style=\"width:6px;height:6px;border-radius:50%;background:var(--c1);animation:dotJump .5s infinite alternate;animation-delay:.3s\"></span></span>';
    fetch(appUrl+'/ui/ui_custom/customer/api/package_payment.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({plan_id:packagePlanId,channel:channel,router_name:packageRouter})})
    .then(function(r){return r.json()}).then(function(d){
        if(d.success&&d.url){window.location.href=d.url}
        else{el.classList.remove('loading');el.querySelector('.btn-dots').outerHTML='<i class=\"bi bi-chevron-right rch-arrow\"></i>';showPackageError(d.error||'Gagal membuat transaksi')}
    }).catch(function(){el.classList.remove('loading');el.querySelector('.btn-dots').outerHTML='<i class=\"bi bi-chevron-right rch-arrow\"></i>';showPackageError('Gagal membuat transaksi')});
}
function showPackageError(msg){
    if(packageModalBS)packageModalBS.hide();
    if(!packageErrModalBS)packageErrModalBS=new bootstrap.Offcanvas(document.getElementById('packageErrModal'));
    document.getElementById('packageErrMsg').textContent=msg;
    packageErrModalBS.show();
}

document.querySelectorAll('[api-get-text]').forEach(function(el){
    fetch(el.getAttribute('api-get-text'),{credentials:'include'}).then(function(r){return r.text()}).then(function(t){el.textContent=t}).catch(function(){el.textContent='-'});
});

function selectMode(mode){
    var c1=document.getElementById('ppCardPrepaid'),c2=document.getElementById('ppCardPostpaid');
    var l1=document.getElementById('ppPrepaidList'),l2=document.getElementById('ppPostpaidList');
    if(!mode){
        if(c1.classList.contains('removing')||c2.classList.contains('removing')){c1.classList.remove('removing');c2.classList.remove('removing');c1.classList.add('selected')}
        l1.classList.remove('show');l2.classList.remove('show');
        document.getElementById('ppOffer').style.display='flex';
        return;
    }
    document.getElementById('ppOffer').style.display='flex';
    if(mode==='prepaid'){
        c2.classList.add('removing');c2.classList.remove('selected');c1.classList.add('selected');
        setTimeout(function(){l1.classList.add('show');l2.classList.remove('show')},350);
    }else{
        c1.classList.add('removing');c1.classList.remove('selected');c2.classList.add('selected');
        setTimeout(function(){l2.classList.add('show');l1.classList.remove('show')},350);
    }
}

function postpaidUpgrade(pid){
    fetch(appUrl+'/ui/ui_custom/customer/api/postpaid_upgrade.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({plan_id:pid})})
    .then(function(r){return r.json()}).then(function(d){
        if(!d.success){showToast(d.error||'Gagal menghitung','error');return}
        var msg='Upgrade paket?';
        if(d.breakdown){
            msg='Upgrade dari '+d.breakdown.old_plan+' ke '+d.breakdown.new_plan+'?\n\nRincian:\n'+d.breakdown.days_used+'hr x Rp '+d.breakdown.daily_old.toLocaleString()+' = Rp '+d.breakdown.old_portion.toLocaleString()+'\n'+d.breakdown.days_remaining+'hr x Rp '+d.breakdown.daily_new.toLocaleString()+' = Rp '+d.breakdown.new_portion.toLocaleString()+'\n\nTotal Invoice: Rp '+d.breakdown.total.toLocaleString();
        }
        if(!confirm(msg))return;
        var btn=document.querySelector('.tx-act.pay');
        if(btn)showDots(btn);
        fetch(appUrl+'/?_route=plugin/postpaid_upgrade_exec&plan_id='+pid,{credentials:'include'})
        .then(function(){window.location.href=appUrl+'/?_route=plugin/postpaid_page'})
        .catch(function(){showToast('Gagal upgrade','error');if(btn)hideDots(btn)});
    }).catch(function(){showToast('Gagal menghitung','error')});
}

var upgradeModalBS=null,upgradeErrModalBS=null,upgradePlanId=null;
function getUpgradeChannels(){
    fetch(appUrl+'/ui/ui_custom/customer/api/tripay_channels.php',{credentials:'include'})
    .then(function(r){return r.json()}).then(function(d){
        var h='';d.forEach(function(ch){
            var logo=ch.logo?'<img src=\"'+appUrl+'/ui/ui_custom/customer/'+ch.logo+'\" onerror=\"this.style.display=\\\'none\\\';this.nextElementSibling.style.display=\\\'block\\\'\"><span style=\"display:none\">'+ch.init.substring(0,2)+'</span>':'<span>'+ch.init.substring(0,2)+'</span>';
            h+='<div class=\"rch-item\" data-channel=\"'+ch.id+'\" onclick=\"selectUpgradeChannel(this)\"><span class=\"rch-logo\" style=\"background:'+(ch.color||'#666')+'\">'+logo+'</span><span class=\"rch-name\">'+ch.name+'</span><i class=\"bi bi-chevron-right rch-arrow\"></i></div>';
        });
        document.getElementById('upgradeSkel').style.display='none';
        document.getElementById('upgradeList').innerHTML=h;
    });
}
function openPostpaidModal(pid){
    if(!upgradeModalBS)upgradeModalBS=new bootstrap.Offcanvas(document.getElementById('upgradeModal'));
    upgradePlanId=pid;
    document.getElementById('upgradeSkel').style.display='block';
    document.getElementById('upgradeList').innerHTML='';
    upgradeModalBS.show();
    getUpgradeChannels();
}
function selectUpgradeChannel(el){
    var channel=el.getAttribute('data-channel');
    el.classList.add('loading');
    el.querySelector('.rch-arrow').outerHTML='<span class=\"btn-dots\" style=\"display:flex;gap:4px\"><span style=\"width:6px;height:6px;border-radius:50%;background:var(--c1);animation:dotJump .5s infinite alternate\"></span><span style=\"width:6px;height:6px;border-radius:50%;background:var(--c1);animation:dotJump .5s infinite alternate;animation-delay:.15s\"></span><span style=\"width:6px;height:6px;border-radius:50%;background:var(--c1);animation:dotJump .5s infinite alternate;animation-delay:.3s\"></span></span>';
    fetch(appUrl+'/ui/ui_custom/customer/api/postpaid_upgrade.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({plan_id:upgradePlanId,channel:channel})})
    .then(function(r){return r.json()}).then(function(d){
        if(d.success&&d.url){window.location.href=d.url}
        else{el.classList.remove('loading');el.querySelector('.btn-dots').outerHTML='<i class=\"bi bi-chevron-right rch-arrow\"></i>';showUpgradeError(d.error||'Gagal membuat transaksi')}
    }).catch(function(){el.classList.remove('loading');el.querySelector('.btn-dots').outerHTML='<i class=\"bi bi-chevron-right rch-arrow\"></i>';showUpgradeError('Gagal membuat transaksi')});
}
function showUpgradeError(msg){
    if(upgradeModalBS)upgradeModalBS.hide();
    if(!upgradeErrModalBS)upgradeErrModalBS=new bootstrap.Offcanvas(document.getElementById('upgradeErrModal'));
    document.getElementById('upgradeErrMsg').textContent=msg;
    upgradeErrModalBS.show();
}
