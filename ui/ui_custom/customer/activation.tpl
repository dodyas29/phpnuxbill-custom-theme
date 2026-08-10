<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
{include file="components/_head_common.tpl"}
    <script src="https://cdn.jsdelivr.net/npm/qrcodejs@1.0.0/qrcode.min.js"></script>
    <style>
        {literal}
        .sk-content{display:none}
        .sk-load.loaded .sk-placeholder{display:none}
        .sk-load.loaded .sk-content{display:block}

        .vcard{background:var(--bgs);border:1px solid var(--bd);border-radius:var(--r3);padding:22px 20px 18px;margin-bottom:4px;position:relative;overflow:hidden}
        .vcard::before{content:'';position:absolute;top:0;left:0;right:0;height:3px;background:linear-gradient(90deg,var(--c1),var(--c2),var(--c4))}
        .vcard-top{display:flex;align-items:center;justify-content:space-between;margin-bottom:18px}
        .vcard-brand{display:flex;align-items:center;gap:10px;min-width:0}
        .vcard-brand-img{width:36px;height:36px;border-radius:8px;object-fit:contain;border:1px solid var(--bd);flex-shrink:0}
        .vcard-brand span{font-size:.78rem;font-weight:700;color:var(--tx);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;letter-spacing:-.3px}
        .vcard-price{font-size:.88rem;font-weight:800;color:var(--c1);flex-shrink:0;letter-spacing:-.3px}
        .vcard-body{display:flex;gap:18px;margin-bottom:14px}
        .vcard-left{flex:1;min-width:0;display:flex;flex-direction:column;gap:6px}
        .vcard-code-label{font-size:.56rem;font-weight:700;color:var(--t3);text-transform:uppercase;letter-spacing:1px}
        .vcard-code{font-size:1.05rem;font-weight:700;font-family:'Courier New',monospace;color:var(--tx);letter-spacing:.5px;word-break:break-all}
        .vcard-code-note{font-size:.58rem;color:var(--t2);line-height:1.4}
        .vcard-qr{width:86px;height:86px;border-radius:10px;border:2px solid var(--bd);display:flex;align-items:center;justify-content:center;overflow:hidden;padding:4px;background:#fff;flex-shrink:0}
        .vcard-footer{border-top:1px solid var(--bd);padding-top:10px;font-size:.56rem;color:var(--t3);text-align:center;line-height:1.5}

        .pkg-wrap{background:var(--bgs);border:1px solid var(--bd);border-radius:var(--r2);padding:0;margin-bottom:4px}
        .pkg-wrap select{width:100%;background:none;border:none;color:var(--tx);font-size:.84rem;font-weight:600;font-family:var(--ff);padding:14px 40px 14px 16px;cursor:pointer;outline:none;-webkit-appearance:none;appearance:none;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%2371717a' d='M6 8L1 3h10z'/%3E%3C/svg%3E");background-repeat:no-repeat;background-position:right 16px center}

        .pay-select{width:100%;background:var(--bgs);border:1px solid var(--bd);border-radius:var(--r2);padding:12px 16px;display:flex;align-items:center;gap:10px;cursor:pointer;font-family:var(--ff);color:var(--tx);margin-bottom:4px}
        .pay-select::after{content:'';margin-left:auto;border:solid var(--t3);border-width:0 2px 2px 0;padding:3px;transform:rotate(45deg);flex-shrink:0}
        .pay-select-logo{width:32px;height:32px;border-radius:8px;display:flex;align-items:center;justify-content:center;overflow:hidden;flex-shrink:0;font-size:.65rem;font-weight:800;color:#fff}
        .pay-select-logo img{width:100%;height:100%;object-fit:contain}
        .pay-select-text{font-size:.82rem;font-weight:600}
        .pay-select-text.placeholder{color:var(--t3)}

        .pay-modal-item{display:flex;align-items:center;gap:14px;padding:14px 16px;cursor:pointer;border-radius:12px;font-size:.85rem;font-weight:500;color:var(--tx);transition:all .1s}
        .pay-modal-item:active{background:var(--bgc)}
        .pay-modal-item.selected{color:var(--c1)}
        .pay-modal-logo{width:36px;height:36px;border-radius:8px;display:flex;align-items:center;justify-content:center;overflow:hidden;flex-shrink:0;font-size:.7rem;font-weight:800;color:#fff}
        .pay-modal-logo img{width:100%;height:100%;object-fit:contain}
        .pay-modal-item .bi{color:var(--c1);font-size:1rem;margin-left:auto;display:none}
        .pay-modal-item.selected .bi{display:block}
        .pay-modal-item .bi-circle{margin-left:auto;font-size:.8rem;color:var(--bd2)}
        .pay-modal-item.selected .bi-circle{display:none}
        .pay-modal-skel{display:flex;align-items:center;gap:14px;padding:14px 16px}

        .vbtn{width:100%;display:flex;align-items:center;justify-content:center;gap:8px;padding:15px 24px;border-radius:var(--rp);font-size:.82rem;font-weight:700;cursor:pointer;transition:all .15s;background:linear-gradient(135deg,var(--c1),var(--c2));color:#fff;border:none;letter-spacing:.4px;font-family:var(--ff)}
        .vbtn:active{transform:scale(.97);filter:brightness(.9)}
        {/literal}
    </style>
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
                            </div>
                            <span class="skl skl-bright" style="width:86px;height:86px;border-radius:10px"></span>
                        </div>
                        <div class="vcard-footer">
                            <span class="skl skl-bright w-md h-xs"></span>
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
                            <span class="vcard-price">Rp 100.000</span>
                        </div>
                        <div class="vcard-body">
                            <div class="vcard-left">
                                <span class="vcard-code-label">Kode Voucher</span>
                                <span class="vcard-code" id="voucherCode">{if isset($_c['voucher_prefix'])}{$_c['voucher_prefix']|escape:'html'}XXXXXXXX{else}XXXXXXXX{/if}</span>
                                <span class="vcard-code-note">Simpan kode voucher sebelum masa aktif habis</span>
                            </div>
                            <div class="vcard-qr" id="voucherQr"></div>
                        </div>
                        <div class="vcard-footer">Scan QR menggunakan browser Chrome.</div>
                    </div>
                </div>
            </div>
        </section>

        <section>
            <div class="sh stg"><h2>Pilih Paket</h2></div>
            <div class="sk-load" id="skPkg">
                <div class="sk-placeholder">
                    <span class="skl skl-bright w-sm" style="height:48px;border-radius:var(--r2);display:block;width:auto"></span>
                </div>
                <div class="sk-content">
                    <div class="pkg-wrap stg">
                        <select id="packageSelect">
                            <option value="daily">Harian</option>
                            <option value="weekly">Mingguan</option>
                            <option value="monthly" selected>Bulanan</option>
                        </select>
                    </div>
                </div>
            </div>
        </section>

        <section>
            <div class="sh stg"><h2>Metode Pembayaran</h2></div>
            <div class="pay-select stg" onclick="openPayModal()">
                <span class="pay-select-logo" id="paySelectLogo" style="background:var(--bgc)">--</span>
                <span class="pay-select-text placeholder" id="paySelectText">Pilih metode pembayaran</span>
            </div>
        </section>

        <button class="vbtn stg" style="margin-top:24px" onclick="proceedPayment()"><i class="bi bi-arrow-right-circle"></i> Lanjutkan</button>
    </div>

    <div class="offcanvas offcanvas-bottom os" tabindex="-1" id="payModal" style="max-height:55vh">
        <div class="offcanvas-header flex-column"></div>
        <div class="offcanvas-body">
            <h6 class="fw-bold mb-3" style="font-size:.82rem;color:var(--tx)">Pilih Metode Pembayaran</h6>
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
        var channelsLoaded=false;

        (function init(){
            document.getElementById('skCard').classList.add('loaded');
            var cfg=document.getElementById('voucher-config');
            var prefix=cfg?cfg.getAttribute('data-prefix')||'':'';
            var hex='';
            for(var i=0;i<8;i++)hex+='0123456789ABCDEF'.charAt(Math.floor(Math.random()*16));
            voucherGenerated=prefix+hex;
            document.getElementById('voucherCode').textContent=voucherGenerated;
            new QRCode(document.getElementById('voucherQr'),{text:voucherGenerated,width:78,height:78,colorDark:'#09090b',colorLight:'#ffffff',correctLevel:QRCode.CorrectLevel.M});
        })();

        function loadChannels(){
            document.getElementById('skPkg').classList.add('loaded');
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
            document.getElementById('paySelectText').classList.remove('placeholder');
            var pl=document.getElementById('paySelectLogo');
            pl.style.background=color||'var(--bgc)';
            pl.innerHTML=logo?'<img src="'+appUrl+'/ui/ui_custom/'+logo+'" onerror="this.style.display=\'none\';this.nextElementSibling.style.display=\'block\'"><span style="display:none">'+init.substring(0,2)+'</span>':'<span>'+init.substring(0,2)+'</span>';
            if(payModal)payModal.hide();
        }

        function proceedPayment(){
            if(!selectedChannel){showToast('Pilih metode pembayaran','error');return}
            showToast('Mengarahkan ke pembayaran...','success');
        }
        {/literal}
    </script>
</body>
</html>
