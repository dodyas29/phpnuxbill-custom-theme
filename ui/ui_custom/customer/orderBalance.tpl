<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
{include file="components/_head_common.tpl"}
</head>
<body>
{include file="components/_header.tpl"}

    <div class="cw">
        {if isset($notify)}<meta id="notify-data" data-msg="{$notify|escape}" data-type="{if $notify_t == 's'}success{else}error{/if}">{/if}

        <section>
            <div class="sh stg"><h2>{Lang::T('Top Up')}</h2></div>

            {if empty($plans_balance) && $_c['allow_balance_custom'] != 'yes'}
            <div class="pc-empty">Tidak ada paket top up tersedia</div>
            {/if}

            {if !empty($plans_balance)}
            <div class="pr-list stg">
                {foreach $plans_balance as $plan}
                <div class="bal-item">
                    <span class="bal-plan">{$plan['name_plan']}</span>
                    <span class="bal-price">{Lang::moneyFormat($plan['price'])}</span>
                    <a href="javascript:void(0)" class="bal-buy" onclick="openBalanceModal({$plan['id']})">{Lang::T('Buy')}</a>
                </div>
                {/foreach}
            </div>
            {/if}

            {if $_c['allow_balance_custom'] == 'yes'}
            <div class="sh stg" style="margin-top:20px"><h2>{Lang::T('Custom Amount')}</h2></div>
            <div class="pr-list stg">
                <form class="bal-custom" onsubmit="return false">
                    <span style="font-size:.82rem;font-weight:600;color:var(--tx);flex-shrink:0">Rp</span>
                    <input type="number" id="balCustomAmount" min="1" placeholder="{Lang::T('Input Desired Amount')}">
                    <button type="button" class="bal-buy" onclick="openCustomBalanceModal()">{Lang::T('Buy')}</button>
                </form>
            </div>
            {/if}
        </section>
    </div>

{include file="components/_navbar.tpl"}
{include file="components/_menu_sheet.tpl"}

    <div class="offcanvas offcanvas-bottom os" tabindex="-1" id="balanceErrModal">
        <div class="offcanvas-header flex-column"></div>
        <div class="offcanvas-body" style="text-align:center">
            <i class="bi bi-x-circle-fill" style="font-size:2.5rem;color:var(--c6);display:block;margin-bottom:12px"></i>
            <p id="balanceErrMsg" style="font-size:.85rem;color:var(--t2);line-height:1.5;margin-bottom:20px"></p>
            <button class="vbtn" onclick="balanceErrModalBS.hide()" style="max-width:200px;margin:0 auto">Tutup</button>
        </div>
    </div>

    <div class="offcanvas offcanvas-bottom os" tabindex="-1" id="balanceModal" style="max-height:55vh">
        <div class="offcanvas-header flex-column"></div>
        <div class="offcanvas-body">
            <div id="balanceSkel">
                <div class="rch-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-sm h-sm"></span><i class="skl skl-bright" style="width:18px;height:18px;border-radius:50%;margin-left:auto"></i></div>
                <div class="rch-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-md h-sm"></span><i class="skl skl-bright" style="width:18px;height:18px;border-radius:50%;margin-left:auto"></i></div>
                <div class="rch-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-sm h-sm"></span><i class="skl skl-bright" style="width:18px;height:18px;border-radius:50%;margin-left:auto"></i></div>
                <div class="rch-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-lg h-sm"></span><i class="skl skl-bright" style="width:18px;height:18px;border-radius:50%;margin-left:auto"></i></div>
                <div class="rch-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-sm h-sm"></span><i class="skl skl-bright" style="width:18px;height:18px;border-radius:50%;margin-left:auto"></i></div>
            </div>
            <div id="balanceList"></div>
        </div>
    </div>

    <div class="tc" id="toastContainer"></div>

{include file="components/_scripts_common.tpl"}

    <script>
        {literal}
        var balanceModalBS=null,balanceErrModalBS=null,balancePlanId=null,balanceCustom=false;

        function getBalanceChannels(){
            fetch(appUrl+'/ui/ui_custom/api/tripay_channels.php',{credentials:'include'})
            .then(function(r){return r.json()}).then(function(d){
                var h='';d.forEach(function(ch){
                    var logo=ch.logo?'<img src=\"'+appUrl+'/ui/ui_custom/'+ch.logo+'\" onerror=\"this.style.display=\\\'none\\\';this.nextElementSibling.style.display=\\\'block\\\'\"><span style=\"display:none\">'+ch.init.substring(0,2)+'</span>':'<span>'+ch.init.substring(0,2)+'</span>';
                    h+='<div class=\"rch-item\" data-channel=\"'+ch.id+'\" onclick=\"selectBalanceChannel(this)\"><span class=\"rch-logo\" style=\"background:'+(ch.color||'#666')+'\">'+logo+'</span><span class=\"rch-name\">'+ch.name+'</span><i class=\"bi bi-chevron-right rch-arrow\"></i></div>';
                });
                document.getElementById('balanceSkel').style.display='none';
                document.getElementById('balanceList').innerHTML=h;
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

            fetch(appUrl+'/ui/ui_custom/api/balance_payment.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(body)})
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
        {/literal}
    </script>

</body>
</html>
