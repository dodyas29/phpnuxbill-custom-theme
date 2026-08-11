<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
{include file="components/_head_common.tpl"}
    <script src="https://cdn.jsdelivr.net/npm/qrcodejs@1.0.0/qrcode.min.js"></script>
</head>
<body>
{include file="components/_header.tpl"}

    <div class="cw">
        {if isset($notify)}<meta id="notify-data" data-msg="{$notify|escape}" data-type="{if $notify_t == 's'}success{else}error{/if}">{/if}

        <section>
            <div class="sk-load" id="skCard">
                <div class="sk-placeholder">
                    <div class="vcard" aria-hidden="true">
                        <div class="vcard-top">
                            <div class="vcard-brand">
                                <span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span>
                                <span class="skl skl-bright w-sm h-sm"></span>
                            </div>
                            <span class="skl skl-bright w-xs h-sm"></span>
                        </div>
                        <div class="vcard-body">
                            <div class="vcard-left">
                                <span class="skl skl-bright w-xs h-xs"></span>
                                <span class="skl skl-bright w-full h-md"></span>
                                <span class="skl skl-bright w-lg h-xs"></span>
                                <span class="skl skl-bright w-md h-xs"></span>
                            </div>
                            <span class="skl skl-bright" style="width:96px;height:96px;border-radius:12px"></span>
                        </div>
                    </div>
                </div>
                <div class="sk-content">
                    <div class="vcard stg">
                        <div class="vcard-top">
                            <div class="vcard-brand">
                                {if isset($_c['login_page_logo']) && $_c['login_page_logo'] != ''}
                                    <img src="{$app_url}/{$UPLOAD_PATH}/{$_c['login_page_logo']}" class="vcard-brand-img" onerror="this.style.display='none'">
                                {/if}
                                <span>{$_c['CompanyName']|truncate:16:"":true}</span>
                            </div>
                            <span class="vcard-price" id="vcardPrice">Rp 0</span>
                        </div>
                        <div class="vcard-body">
                            <div class="vcard-left">
                                <span class="vcard-code-label">Kode Voucher</span>
                                <span class="vcard-code" id="voucherCode">{if isset($_c['voucher_prefix'])}{$_c['voucher_prefix']|escape:'html'}00000000{else}00000000{/if}</span>
                                <span class="vcard-code-note">Simpan kode voucher sebelum masa aktif habis</span>
                                <span class="vcard-code-note">Scan QR menggunakan browser Chrome.</span>
                            </div>
                            <div class="vcard-qr" id="voucherQr" onclick="openQrModal()"></div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section>
            <div class="sh stg"><h2>Pilih Paket</h2></div>
            <div class="pay-select stg" onclick="openPkgModal()">
                <i class="bi bi-box" id="pkgSelectLogo" style="color:var(--t3);font-size:1.2rem"></i>
                <span class="pay-select-text" id="pkgSelectText" style="color:var(--t3)">Pilih Paket Voucher</span>
            </div>
        </section>

        <section>
            <div class="sh stg"><h2>Metode Pembayaran</h2></div>
            <div class="pay-select stg" onclick="openPayModal()">
                <i class="bi bi-credit-card" id="paySelectLogo" style="color:var(--t3);font-size:1.2rem"></i>
                <span class="pay-select-text" id="paySelectText" style="color:var(--t3)">Pilih metode pembayaran</span>
            </div>
        </section>

        <button class="vbtn stg" style="margin-top:24px" onclick="proceedPayment()"><i class="bi bi-arrow-right-circle"></i> Lanjutkan</button>
    </div>

    <div class="offcanvas offcanvas-bottom os" tabindex="-1" id="payModal" style="max-height:55vh">
        <div class="offcanvas-header flex-column"></div>
        <div class="offcanvas-body">
            <div id="payModalSkel">
                <div class="pay-modal-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-sm h-sm"></span><span class="skl skl-bright w-xs h-xs" style="margin-left:auto"></span></div>
                <div class="pay-modal-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-md h-sm"></span><span class="skl skl-bright w-xs h-xs" style="margin-left:auto"></span></div>
                <div class="pay-modal-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-sm h-sm"></span><span class="skl skl-bright w-xs h-xs" style="margin-left:auto"></span></div>
                <div class="pay-modal-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-lg h-sm"></span><span class="skl skl-bright w-xs h-xs" style="margin-left:auto"></span></div>
                <div class="pay-modal-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-sm h-sm"></span><span class="skl skl-bright w-xs h-xs" style="margin-left:auto"></span></div>
                <div class="pay-modal-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-md h-sm"></span><span class="skl skl-bright w-xs h-xs" style="margin-left:auto"></span></div>
            </div>
            <div id="payModalList"></div>
        </div>
    </div>

    <div class="offcanvas offcanvas-bottom os" tabindex="-1" id="pkgModal" style="max-height:55vh">
        <div class="offcanvas-header flex-column"></div>
        <div class="offcanvas-body">
            <div class="pkg-list stg" id="pkgList">
                <div class="pc-empty">Loading...</div>
            </div>
        </div>
    </div>

    <div class="offcanvas offcanvas-bottom os" tabindex="-1" id="qrModal">
        <div class="offcanvas-header flex-column"></div>
        <div class="offcanvas-body">
            <div class="qr-big" id="qrBig"></div>
        </div>
    </div>

{include file="components/_navbar.tpl"}
{include file="components/_menu_sheet.tpl"}
    <div class="tc" id="toastContainer"></div>

{include file="components/_scripts_common.tpl"}

    <meta id="voucher-config" data-prefix="{$_c['voucher_prefix']|escape:'html'}">

    <script>
        {literal}
        var selectedChannel='';
        var voucherGenerated='';
        var channels=[];
        var payModal=null;
        var pkgModal=null;
        var channelsLoaded=false;

        var selectedPackageId=null;

        function genVoucherCode(){
            var cfg=document.getElementById('voucher-config');
            var prefix=cfg?cfg.getAttribute('data-prefix')||'':'';
            var hex='';
            for(var i=0;i<8;i++)hex+='0123456789ABCDEF'.charAt(Math.floor(Math.random()*16));
            voucherGenerated=prefix+hex;
            document.getElementById('voucherCode').textContent=voucherGenerated;
            var qrEl=document.getElementById('voucherQr');
            qrEl.innerHTML='';
            new QRCode(qrEl,{text:voucherGenerated,width:78,height:78,colorDark:'#09090b',colorLight:'#ffffff',correctLevel:QRCode.CorrectLevel.M});
        }

        (function init(){
            document.getElementById('skCard').classList.add('loaded');

            fetch(appUrl+'/ui/ui_custom/api/plan.php',{credentials:'include'})
            .then(function(r){return r.json()})
            .then(function(d){
                if(typeof d.balance_formatted!=='undefined'){
                    var ab=document.getElementById('abBal');if(ab){ab.className='';ab.style.cssText='';ab.textContent=d.balance_formatted}
                }
            }).catch(function(){});

            loadPackages();
        })();

        function loadPackages(){
            fetch(appUrl+'/ui/ui_custom/api/packages.php',{credentials:'include'})
            .then(function(r){if(!r.ok)throw Error('HTTP '+r.status);return r.json()})
            .then(function(d){
                var list=document.getElementById('pkgList'),h='';
                var catIcons={harian:1,mingguan:7,bulanan:30};
                d.forEach(function(p,i){
                    var calNum=catIcons[p.category]||p.validity_days||1;
                    h+='<div class="pkg-item" data-id="'+p.id+'" data-price="'+p.price+'" data-name="'+p.name+'" onclick="selectPackage(this)"><div class="pkg-cal"><div class="pkg-cal-bar"></div><div class="pkg-cal-num">'+calNum+'</div></div><div class="pkg-info"><div class="pkg-name">'+p.name+'</div><div class="pkg-price">'+p.price_formatted+'</div></div><i class="bi bi-check-lg"></i></div>';
                });
                list.innerHTML=h;
            })
            .catch(function(){showToast('Gagal memuat paket','error')})
        }

        function openPkgModal(){
            if(!pkgModal)pkgModal=new bootstrap.Offcanvas(document.getElementById('pkgModal'));
            pkgModal.show();
        }

        function selectPackage(el){
            document.querySelectorAll('.pkg-item').forEach(function(e){e.classList.remove('selected')});
            el.classList.add('selected');
            selectedPackageId=el.getAttribute('data-id');
            var price=parseInt(el.getAttribute('data-price'))||0;
            var name=el.getAttribute('data-name');
            document.getElementById('vcardPrice').textContent='Rp '+price.toLocaleString('id-ID');
            document.getElementById('pkgSelectText').textContent=name+' - Rp '+price.toLocaleString('id-ID');
            document.getElementById('pkgSelectText').style.color='';
            document.getElementById('pkgSelectLogo').style.color='var(--c1)';
            genVoucherCode();
            if(pkgModal)pkgModal.hide();
        }

        function loadChannels(){
            fetch(appUrl+'/ui/ui_custom/api/tripay_channels.php',{credentials:'include'})
            .then(function(r){if(!r.ok)throw Error('HTTP '+r.status);return r.json()})
            .then(function(d){channels=d;renderPayModal();channelsLoaded=true})
            .catch(function(){showToast('Gagal memuat metode pembayaran','error')})
        }

        function openPayModal(){
            if(!payModal)payModal=new bootstrap.Offcanvas(document.getElementById('payModal'));
            payModal.show();
            if(!channelsLoaded)loadChannels();
        }

        function renderPayModal(){
            var c=document.getElementById('payModalList'),h='';
            channels.forEach(function(ch){
                var logo=ch.logo?'<img src="'+appUrl+'/ui/ui_custom/'+ch.logo+'" onerror="this.style.display=\'none\';this.nextElementSibling.style.display=\'block\'"><span style="display:none">'+ch.init.substring(0,2)+'</span>':'<span>'+ch.init.substring(0,2)+'</span>';
                h+='<div class="pay-modal-item" data-channel="'+ch.id+'" data-name="'+ch.name+'" data-logo="'+(ch.logo||'')+'" data-color="'+(ch.color||'')+'" data-init="'+ch.init+'" onclick="selectPayMethod(this)"><div class="pay-modal-logo" style="background:'+(ch.color||'#666')+'">'+logo+'</div><span>'+ch.name+'</span><i class="bi bi-circle"></i><i class="bi bi-check-circle-fill"></i></div>';
            });
            c.innerHTML=h;
            document.getElementById('payModalSkel').style.display='none';
        }

        function selectPayMethod(el){
            document.querySelectorAll('.pay-modal-item').forEach(function(e){e.classList.remove('selected')});
            el.classList.add('selected');
            selectedChannel=el.getAttribute('data-channel');
            var name=el.getAttribute('data-name');
            var logo=el.getAttribute('data-logo');
            var color=el.getAttribute('data-color');
            var init=el.getAttribute('data-init');
            document.getElementById('paySelectText').textContent=name;
            document.getElementById('paySelectText').style.color='';
            var pl=document.getElementById('paySelectLogo');
            if(logo){
                pl.outerHTML='<span class="pay-select-logo" id="paySelectLogo" style="background:'+(color||'var(--bgc)')+'"><img src="'+appUrl+'/ui/ui_custom/'+logo+'" onerror="this.style.display=\'none\';this.nextElementSibling.style.display=\'block\'"><span style="display:none">'+init.substring(0,2)+'</span></span>';
            } else {
                pl.outerHTML='<span class="pay-select-logo" id="paySelectLogo" style="background:'+(color||'var(--bgc)')+'"><span>'+init.substring(0,2)+'</span></span>';
            }
            if(payModal)payModal.hide();
        }

        var qrModal=null;
        function openQrModal(){
            if(!qrModal)qrModal=new bootstrap.Offcanvas(document.getElementById('qrModal'));
            var qrEl=document.getElementById('qrBig');
            qrEl.innerHTML='';
            new QRCode(qrEl,{text:voucherGenerated,width:216,height:216,colorDark:'#09090b',colorLight:'#ffffff',correctLevel:QRCode.CorrectLevel.H});
            qrModal.show();
        }

        function showDots(el){el._old=el.innerHTML;el.innerHTML='<div class="btn-dots" style="display:flex;gap:6px;justify-content:center"><span style="width:8px;height:8px;border-radius:50%;background:var(--c1);animation:dotJump .5s infinite alternate"></span><span style="width:8px;height:8px;border-radius:50%;background:var(--c1);animation:dotJump .5s infinite alternate;animation-delay:.15s"></span><span style="width:8px;height:8px;border-radius:50%;background:var(--c1);animation:dotJump .5s infinite alternate;animation-delay:.3s"></span></div>';el.disabled=true}
        function hideDots(el){el.innerHTML=el._old;el.disabled=false}

        function proceedPayment(){
            if(!selectedChannel){showToast('Pilih metode pembayaran','error');return}
            if(!selectedPackageId){showToast('Pilih paket','error');return}
            showDots(document.getElementById('realBtn'));
            fetch(appUrl+'/ui/ui_custom/api/voucher_payment.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({plan_id:selectedPackageId,channel:selectedChannel})})
            .then(function(r){return r.json()}).then(function(d){
                if(d.success&&d.url)window.location.href=d.url;
                else showToast(d.error||'Gagal','error');
            }).catch(function(){showToast('Gagal','error')});
        }
        {/literal}
    </script>
</body>
</html>
