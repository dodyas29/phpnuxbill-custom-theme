<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
{include file="components/_head_common.tpl"}
    <script src="https://cdn.jsdelivr.net/npm/qrcodejs@1.0.0/qrcode.min.js"></script>
    <style>
        {literal}
        .vw{max-width:480px;margin:0 auto;padding:20px 16px 40px}

        .vcard{background:var(--bgs);border:1px solid var(--bd);border-radius:var(--r3);padding:24px 20px 20px;margin-bottom:10px;position:relative;overflow:hidden}
        .vcard::before{content:'';position:absolute;top:0;left:0;right:0;height:3px;background:linear-gradient(90deg,var(--c1),var(--c2),var(--c4))}

        .vcard-top{display:flex;align-items:center;justify-content:space-between;margin-bottom:20px}
        .vcard-brand{display:flex;align-items:center;gap:10px;min-width:0}
        .vcard-brand-img{width:36px;height:36px;border-radius:8px;object-fit:contain;border:1px solid var(--bd);flex-shrink:0}
        .vcard-brand span{font-size:.78rem;font-weight:700;color:var(--tx);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;letter-spacing:-.3px}
        .vcard-price{font-size:.88rem;font-weight:800;color:var(--c1);flex-shrink:0;letter-spacing:-.3px}

        .vcard-body{display:flex;gap:20px;margin-bottom:16px}
        .vcard-left{flex:1;min-width:0;display:flex;flex-direction:column;gap:6px}
        .vcard-code-label{font-size:.56rem;font-weight:700;color:var(--t3);text-transform:uppercase;letter-spacing:1px}
        .vcard-code{font-size:1.05rem;font-weight:700;font-family:'Courier New',monospace;color:var(--tx);letter-spacing:1px;word-break:break-all}
        .vcard-code-note{font-size:.6rem;color:var(--t2);line-height:1.4}

        .vcard-qr{width:90px;height:90px;border-radius:10px;border:2px solid var(--bd);display:flex;align-items:center;justify-content:center;overflow:hidden;padding:4px;background:var(--bg);flex-shrink:0}

        .vcard-footer{border-top:1px solid var(--bd);padding-top:12px;font-size:.58rem;color:var(--t3);text-align:center;line-height:1.5}

        .pkg-select{background:var(--bgs);border:1px solid var(--bd);border-radius:var(--r2);padding:14px 16px;margin-bottom:10px;display:flex;align-items:center;gap:10px;cursor:pointer;transition:all .15s}
        .pkg-select select{flex:1;background:none;border:none;color:var(--tx);font-size:.85rem;font-weight:600;font-family:var(--ff);cursor:pointer;outline:none;-webkit-appearance:none;appearance:none;padding-right:24px;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%2371717a' d='M6 8L1 3h10z'/%3E%3C/svg%3E");background-repeat:no-repeat;background-position:right center}
        .pkg-select i{font-size:1.1rem;color:var(--c1);flex-shrink:0}

        .vbtn{width:100%;display:flex;align-items:center;justify-content:center;gap:8px;padding:14px 24px;border-radius:var(--rp);font-size:.82rem;font-weight:700;cursor:pointer;transition:all .15s;background:linear-gradient(135deg,var(--c1),var(--c2));color:#fff;border:none;letter-spacing:.4px}
        .vbtn:active{transform:scale(.97);filter:brightness(.9)}
        .vbtn i{font-size:1rem}

        .dd-wrap{position:relative;margin-bottom:10px}
        .dd-btn{width:100%;background:var(--bgs);border:1px solid var(--bd);border-radius:var(--r2);padding:12px 16px;display:flex;align-items:center;gap:10px;cursor:pointer;text-align:left;color:var(--tx);font-family:var(--ff)}
        .dd-btn::after{content:'';margin-left:auto;border:solid var(--t3);border-width:0 2px 2px 0;padding:3px;transform:rotate(45deg);flex-shrink:0}
        .dd-btn-logo{width:28px;height:28px;border-radius:6px;display:flex;align-items:center;justify-content:center;overflow:hidden;flex-shrink:0}
        .dd-btn-logo img{width:100%;height:100%;object-fit:contain}
        .dd-btn-text{font-size:.82rem;font-weight:600}
        .dd-menu{display:none;position:absolute;top:100%;left:0;right:0;z-index:50;margin-top:4px;background:var(--bgs);border:1px solid var(--bd);border-radius:var(--r2);max-height:260px;overflow-y:auto;box-shadow:var(--sh2)}
        .dd-menu.show{display:block}
        .dd-item{display:flex;align-items:center;gap:12px;padding:11px 16px;cursor:pointer;transition:all .1s;font-size:.82rem;color:var(--tx)}
        .dd-item:hover{background:var(--bgc)}
        .dd-item.selected{color:var(--c1)}
        .dd-item-logo{width:28px;height:28px;border-radius:6px;display:flex;align-items:center;justify-content:center;overflow:hidden;flex-shrink:0}
        .dd-item-logo img{width:100%;height:100%;object-fit:contain}
        .dd-item-check{color:var(--c1);font-size:.9rem;margin-left:auto;display:none}
        .dd-item.selected .dd-item-check{display:block}

        .sk-wrap .sk-hidden{display:none}
        .sk-wrap.done .sk-hidden{display:block}
        .sk-wrap.done .placeholder{display:none}
        {/literal}
    </style>
</head>
<body>
{include file="components/_header.tpl"}

    <div class="vw">
        {if isset($notify)}<meta id="notify-data" data-msg="{$notify|escape}" data-type="{if $notify_t == 's'}success{else}error{/if}">{/if}

        <section>
            <div class="vcard stg">
                <!-- SKELETON -->
                <div class="sk-wrap" id="skCard">
                    <div class="vcard-top placeholder-glow">
                        <div class="vcard-brand">
                            <span class="placeholder rounded" style="width:36px;height:36px"></span>
                            <span class="placeholder col-4 placeholder-sm"></span>
                        </div>
                        <span class="placeholder col-2 placeholder-sm"></span>
                    </div>
                    <div class="vcard-body">
                        <div class="vcard-left placeholder-glow">
                            <span class="placeholder col-4 placeholder-xs"></span>
                            <span class="placeholder col-9 placeholder-lg"></span>
                            <span class="placeholder col-8 placeholder-xs"></span>
                        </div>
                        <span class="placeholder rounded" style="width:90px;height:90px"></span>
                    </div>
                    <div class="vcard-footer placeholder-glow">
                        <span class="placeholder col-8 placeholder-xs"></span>
                    </div>
                </div>
                <!-- REAL -->
                <div class="sk-hidden" id="realCard">
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
        </section>

        <section>
            <div class="sh stg"><h2>Pilih Paket</h2></div>
            <!-- SKELETON -->
            <div class="sk-wrap" id="skPkg">
                <div class="placeholder-glow"><span class="placeholder col-5" style="height:48px;border-radius:var(--r2);display:block"></span></div>
            </div>
            <!-- REAL -->
            <div class="pkg-select stg sk-hidden" id="realPkg">
                <i class="bi bi-box"></i>
                <select id="packageSelect">
                    <option value="daily">Harian</option>
                    <option value="weekly">Mingguan</option>
                    <option value="monthly" selected>Bulanan</option>
                </select>
            </div>
        </section>

        <section>
            <div class="sh stg"><h2>Metode Pembayaran</h2></div>
            <!-- SKELETON -->
            <div class="sk-wrap" id="skPay">
                <div class="placeholder-glow"><span class="placeholder col-7" style="height:48px;border-radius:var(--r2);display:block"></span></div>
            </div>
            <!-- REAL -->
            <div class="sk-hidden stg" id="realPay">
                <div class="dd-wrap" id="ddWrap">
                    <button class="dd-btn" id="ddBtn" onclick="toggleDD()">
                        <span class="dd-btn-logo" id="ddBtnLogo" style="background:var(--bd2)"><span style="color:var(--t2);font-size:.7rem;font-weight:700">--</span></span>
                        <span class="dd-btn-text" id="ddBtnText">Pilih metode pembayaran</span>
                    </button>
                    <div class="dd-menu" id="ddMenu"></div>
                </div>
            </div>
        </section>

        <!-- SKELETON BUTTON -->
        <div class="sk-wrap stg" id="skBtn">
            <div class="placeholder-glow"><span class="placeholder col-12 placeholder-lg" style="border-radius:var(--rp)"></span></div>
        </div>
        <!-- REAL BUTTON -->
        <button class="vbtn stg sk-hidden" id="realBtn" onclick="proceedPayment()">
            <i class="bi bi-arrow-right-circle"></i> Lanjutkan
        </button>
    </div>

{include file="components/_navbar.tpl"}
{include file="components/_menu_sheet.tpl"}
    <div class="tc" id="toastContainer"></div>

{include file="components/_scripts_common.tpl"}

    <meta id="voucher-config" data-prefix="{$_c['voucher_prefix']|escape:'html'}">

    <script>
        {literal}
        var selectedChannel = '';
        var voucherGenerated = '';
        var channels=[];

        function showReal(){document.querySelectorAll('.sk-wrap').forEach(function(e){e.classList.add('done')})}

        (function(){
            document.getElementById('skCard').classList.add('done');
            var cfg=document.getElementById('voucher-config');
            var prefix=cfg?cfg.getAttribute('data-prefix')||'':'';
            var hexLen=8;
            var hex='';
            for(var i=0;i<hexLen;i++){hex+='0123456789ABCDEF'.charAt(Math.floor(Math.random()*16))}
            voucherGenerated=prefix+hex;
            document.getElementById('voucherCode').textContent=voucherGenerated;
            new QRCode(document.getElementById('voucherQr'),{text:voucherGenerated,width:78,height:78,colorDark:'#fafafa',colorLight:'#09090b',correctLevel:QRCode.CorrectLevel.M});
            document.getElementById('skPkg').classList.add('done');
        })();

        function loadChannels(){
            fetch(appUrl+'/ui/ui_custom/api/tripay_channels.php',{credentials:'include'})
            .then(function(r){if(!r.ok)throw Error('HTTP '+r.status);return r.json()})
            .then(function(d){channels=d;renderDD();document.getElementById('skPay').classList.add('done');document.getElementById('skBtn').classList.add('done')})
            .catch(function(e){showToast('Gagal memuat channel pembayaran','error')})
        }

        function renderDD(){
            var menu=document.getElementById('ddMenu'),h='';
            channels.forEach(function(ch){
                var logoHtml=ch.logo?'<img src="'+appUrl+'/ui/ui_custom/'+ch.logo+'" onerror="this.parentElement.textContent=\''+ch.init.substring(0,2)+'\';this.parentElement.style.background=\''+(ch.color||'#666')+'\'">':'<span style="color:#fff;font-size:.65rem;font-weight:700">'+ch.init.substring(0,2)+'</span>';
                h+='<div class="dd-item" data-channel="'+ch.id+'" data-name="'+ch.name+'" data-logo="'+ch.logo+'" data-color="'+(ch.color||'')+'" data-init="'+ch.init+'" onclick="selectDD(this)"><div class="dd-item-logo" style="background:'+(ch.color||'#666')+'">'+logoHtml+'</div><span>'+ch.name+'</span><i class="bi bi-check-circle-fill dd-item-check"></i></div>';
            });
            menu.innerHTML=h;
        }

        function toggleDD(){
            document.getElementById('ddMenu').classList.toggle('show');
        }

        function selectDD(el){
            document.querySelectorAll('.dd-item').forEach(function(e){e.classList.remove('selected')});
            el.classList.add('selected');
            selectedChannel=el.getAttribute('data-channel');
            var name=el.getAttribute('data-name');
            var logo=el.getAttribute('data-logo');
            var color=el.getAttribute('data-color');
            var init=el.getAttribute('data-init');
            document.getElementById('ddBtnText').textContent=name;
            var btnLogo=document.getElementById('ddBtnLogo');
            btnLogo.style.background=color||'var(--bd2)';
            btnLogo.innerHTML=logo?'<img src="'+appUrl+'/ui/ui_custom/'+logo+'">':'<span style="color:#fff;font-size:.65rem;font-weight:700">'+init.substring(0,2)+'</span>';
            document.getElementById('ddMenu').classList.remove('show');
        }

        function proceedPayment(){
            if(!selectedChannel){showToast('Pilih metode pembayaran terlebih dahulu','error');return}
            showToast('Mengarahkan ke pembayaran...','success');
        }

        document.addEventListener('click',function(e){if(!document.getElementById('ddWrap').contains(e.target)){document.getElementById('ddMenu').classList.remove('show')}});

        loadChannels();
        {/literal}
    </script>
</body>
</html>
