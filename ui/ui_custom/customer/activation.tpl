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
        .pkg-select:active{transform:scale(.98)}
        .pkg-select select{flex:1;background:none;border:none;color:var(--tx);font-size:.85rem;font-weight:600;font-family:var(--ff);cursor:pointer;outline:none;-webkit-appearance:none;-moz-appearance:none;appearance:none;padding-right:24px;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%2371717a' d='M6 8L1 3h10z'/%3E%3C/svg%3E");background-repeat:no-repeat;background-position:right center}
        .pkg-select i{font-size:1.1rem;color:var(--c1);flex-shrink:0}

        .pmethods{display:grid;grid-template-columns:repeat(3,1fr);gap:8px;margin-bottom:10px}
        .pmethod{background:var(--bgs);border:1.5px solid var(--bd);border-radius:var(--r2);padding:14px 8px;text-align:center;cursor:pointer;transition:all .15s;display:flex;flex-direction:column;align-items:center;gap:6px}
        .pmethod:active{transform:scale(.95)}
        .pmethod.selected{border-color:var(--c1);background:rgba(129,140,248,.08)}
        .pmethod i{font-size:1.3rem;color:var(--t3);transition:color .15s}
        .pmethod.selected i{color:var(--c1)}
        .pmethod span{font-size:.62rem;font-weight:600;color:var(--t2);line-height:1.2}

        .vbtn{width:100%;display:flex;align-items:center;justify-content:center;gap:8px;padding:14px 24px;border-radius:var(--rp);font-size:.82rem;font-weight:700;cursor:pointer;transition:all .15s;background:linear-gradient(135deg,var(--c1),var(--c2));color:#fff;border:none;letter-spacing:.4px}
        .vbtn:active{transform:scale(.97);filter:brightness(.9)}
        .vbtn i{font-size:1rem}
        {/literal}
    </style>
</head>
<body>
{include file="components/_header.tpl"}

    <div class="vw">
        {if isset($notify)}<meta id="notify-data" data-msg="{$notify|escape}" data-type="{if $notify_t == 's'}success{else}error{/if}">{/if}

        <section>
            <div class="sh stg"><h2>Beli Voucher</h2></div>

            <div class="vcard stg" id="voucherCard">
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
                        <span class="vcard-code" id="voucherCode">VCH-XXXX-XXXX</span>
                        <span class="vcard-code-note">Simpan kode voucher sebelum masa aktif habis</span>
                    </div>
                    <div class="vcard-qr" id="voucherQr"></div>
                </div>
                <div class="vcard-footer">Scan QR menggunakan browser Chrome.</div>
            </div>
        </section>

        <section>
            <div class="sh stg"><h2>Pilih Paket</h2></div>
            <div class="pkg-select stg">
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
            <div class="pmethods stg" id="paymentMethods"></div>
        </section>

        <button class="vbtn stg" id="lanjutkanBtn" onclick="proceedPayment()">
            <i class="bi bi-arrow-right-circle"></i> Lanjutkan
        </button>
    </div>

{include file="components/_navbar.tpl"}
{include file="components/_menu_sheet.tpl"}
    <div class="tc" id="toastContainer"></div>

{include file="components/_scripts_common.tpl"}

    <script>
        {literal}
        var selectedChannel = '';
        var voucherGenerated = '';

        (function(){
            var chars='ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
            var code='';
            for(var i=0;i<8;i++){code+=chars.charAt(Math.floor(Math.random()*chars.length))}
            voucherGenerated='VCH-'+code.substring(0,4)+'-'+code.substring(4,8);
            document.getElementById('voucherCode').textContent=voucherGenerated;
            new QRCode(document.getElementById('voucherQr'),{text:voucherGenerated,width:78,height:78,colorDark:'#fafafa',colorLight:'#09090b',correctLevel:QRCode.CorrectLevel.M});
        })();

        var channels=[];
        function loadChannels(){
            fetch(appUrl+'/ui/ui_custom/api/tripay_channels.php',{credentials:'include'})
            .then(function(r){if(!r.ok)throw Error('HTTP '+r.status);return r.json()})
            .then(function(d){channels=d;renderMethods()})
            .catch(function(e){showToast('Gagal memuat channel pembayaran','error')})
        }
        function renderMethods(){
            var c=document.getElementById('paymentMethods');
            var h='';
            channels.forEach(function(ch){
                h+='<div class="pmethod" data-channel="'+ch.id+'" onclick="selectMethod(this,\''+ch.id+'\')"><i class="bi '+ch.icon+'"></i><span>'+ch.name+'</span></div>';
            });
            c.innerHTML=h;
        }

        function selectMethod(el,id){
            document.querySelectorAll('.pmethod').forEach(function(e){e.classList.remove('selected')});
            el.classList.add('selected');
            selectedChannel=id;
        }

        function proceedPayment(){
            if(!selectedChannel){showToast('Pilih metode pembayaran terlebih dahulu','error');return}
            showToast('Mengarahkan ke pembayaran...','success');
            // TODO: integrate with Tripay payment gateway
            // window.location.href = appUrl+'/index.php?_route=order/package/tripay/'+selectedChannel;
        }

        loadChannels();
        {/literal}
    </script>
</body>
</html>
