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
