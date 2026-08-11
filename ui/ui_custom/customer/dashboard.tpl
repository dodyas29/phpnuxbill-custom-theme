<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
{include file="components/_head_common.tpl"}
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<body>
{include file="components/_header.tpl"}

    <div class="cw">
        {if isset($notify)}<meta id="notify-data" data-msg="{$notify|escape}" data-type="{if $notify_t == 's'}success{else}error{/if}">{/if}

        <section>
            <div class="hero stg" id="heroCard">
                <div class="hero-top-row">
                    <div class="hero-user">
                        <i class="bi bi-wifi"></i>
                        <span>{$_user['fullname']|truncate:20:"":true}</span>
                    </div>
                    <div class="hero-status-badge" id="heroStatus">
                        <span class="skl skl-bright w-sm h-md pill" style="width:56px"></span>
                    </div>
                </div>
                <div class="hero-plan-line">
                    <span class="skl skl-bright w-sm" style="width:130px;height:15px" id="sklPlan"></span>
                    <span class="skl skl-bright w-xs h-md pill" style="width:60px" id="sklBw"></span>
                    <span class="skl skl-bright w-xs" style="width:80px;margin-left:auto;height:15px" id="sklPlanPrice"></span>
                </div>
                <div class="hero-divider"></div>
                <div class="hero-numbers">
                    <div class="hero-num"><div class="hero-num-label">{Lang::T('Last Payment')}</div><div class="hero-num-value"><span class="skl skl-bright" style="width:95px;height:13px" id="sklPayDate"></span></div></div>
                    <div class="hero-num"><div class="hero-num-label">{Lang::T('Expired')}</div><div class="hero-num-value"><span class="skl skl-bright" style="width:95px;height:13px" id="sklExpired"></span></div></div>
                    <div class="hero-num"><div class="hero-num-label">{Lang::T('Auto Renewal')}</div><div class="hero-num-value"><span class="skl skl-bright w-xs h-md pill" style="width:44px" id="sklAutoRenewal"></span></div></div>
                </div>
                <div class="hero-actions">
                    <span class="skl skl-bright w-full pill" style="flex:1;height:36px" id="sklBtn1"></span>
                    {if $_c['enable_balance'] == 'yes'}<span class="skl skl-bright w-full pill" style="flex:1;height:36px" id="sklBtn2"></span>{/if}
                </div>
            </div>
        </section>

        <section>
            <div class="sh stg"><h2>{Lang::T('Quick Actions')}</h2></div>
            <div class="qa stg">
                <a href="#"><i class="bi bi-ticket-detailed"></i><span>Tiket</span></a>
                <a href="#"><i class="bi bi-question-circle"></i><span>Tanya Jawab</span></a>
                <a href="#"><i class="bi bi-chat-dots"></i><span>Live Chat</span></a>
                <a href="#"><i class="bi bi-telephone"></i><span>Call Center</span></a>
            </div>
        </section>

        <section>
            <div class="sh stg"><h2>{Lang::T('Network Status')}</h2></div>
            <div class="ns-card stg" id="nsCard">
                <!-- SKELETON -->
                <div id="nsSkeleton">
                    <div class="ns-top"><span class="skl skl-bright h-xl" style="width:40px;height:40px;border-radius:10px"></span><div style="flex:1;display:flex;flex-direction:column;gap:4px"><span class="skl skl-bright w-sm h-sm" style="width:90px;height:14px"></span><span class="skl skl-bright w-xs h-xs" style="width:60px;height:10px"></span></div><span class="skl skl-bright w-xs h-xs pill" style="width:56px;height:26px"></span></div>
                    <div class="ns-info-row">
                        <div class="ns-info-half"><span class="skl skl-bright w-xs h-xs" style="width:70px;height:18px;margin-bottom:6px;display:block"></span><span class="skl skl-bright w-md h-md"></span><span class="skl skl-bright w-sm h-xs" style="margin-top:4px;display:block"></span></div>
                        <div class="ns-info-half" style="text-align:right"><span class="skl skl-bright w-xs h-xs" style="width:90px;height:18px;margin-bottom:6px;display:block;margin-left:auto"></span><span class="skl skl-bright w-md h-sm" style="font-size:.78rem;margin-left:auto"></span><span class="skl skl-bright w-lg h-xs" style="margin-top:4px;display:block;margin-left:auto"></span></div>
                    </div>
                    <div class="ns-chart-outer">
                        <div class="ns-chart-wrap">
                            <div class="ns-chart-slide">
                                <div class="ns-chart-top">
                                    <span class="skl skl-bright w-md h-xs" style="width:100px;height:12px"></span>
                                    <span class="skl skl-bright w-sm h-xs" style="width:80px;height:12px;margin-left:auto"></span>
                                </div>
                                <div class="ns-chart-canvas-wrap">
                                    <span class="skl skl-bright w-full" style="height:110px;border-radius:8px"></span>
                                </div>
                                <div class="ns-chart-avg">
                                    <span class="skl skl-bright w-xs h-xs" style="width:50px;height:8px"></span>
                                    <span class="skl skl-bright w-xs h-xs" style="width:80px;height:12px"></span>
                                    <span class="skl skl-bright w-xs h-xs" style="width:80px;height:12px"></span>
                                </div>
                            </div>
                        </div>
                        <div class="ns-chart-dots">
                            <span class="ns-chart-dot-ind active"></span>
                            <span class="ns-chart-dot-ind"></span>
                        </div>
                    </div>
                    <div class="ns-wifi-row"><div class="ns-wifi-item"><span class="skl skl-bright" style="width:22px;height:20px;border-radius:3px"></span><span class="skl skl-bright w-sm h-xs" style="width:120px"></span><span class="skl skl-bright w-xs h-xs" style="width:36px;height:20px;border-radius:6px;margin-left:auto"></span></div><div class="ns-wifi-item"><span class="skl skl-bright" style="width:22px;height:20px;border-radius:3px"></span><span class="skl skl-bright w-sm h-xs" style="width:100px"></span><span class="skl skl-bright w-xs h-xs" style="width:36px;height:20px;border-radius:6px;margin-left:auto"></span></div></div>
                    <span class="skl skl-bright w-full h-lg pill"></span>
                </div>
                <!-- REAL -->
                <div id="nsContent" style="display:none">
                    <div class="ns-top">
                        <div class="ns-device-icon"><i class="bi bi-broadcast"></i></div>
                        <div class="ns-device-info">
                            <div class="ns-model" id="nsModel">-</div>
                            <div class="ns-model-sub" id="nsModelSub">-</div>
                        </div>
                        <button class="ns-refresh" onclick="fetchDeviceData(true)" title="Refresh"><i class="bi bi-arrow-clockwise"></i></button>
                        <span class="ns-status-pill" id="nsStatusPill"><span class="ns-dot" id="nsStatusDot"></span> <span id="nsStatusText">-</span></span>
                    </div>
                    <div class="ns-info-row">
                        <div class="ns-info-half" id="nsRxCol">
                            <div class="ns-half-icon-label" id="nsRxLabel"><i class="bi bi-reception-4"></i> <span>RX Power</span></div>
                            <div class="ns-rx-gauge"><div class="ns-rx-gauge-fill" id="nsRxGauge"></div></div>
                            <div class="ns-half-value" id="nsRxPower">- dBm</div>
                        </div>
                        <div class="ns-info-half" id="nsDiscCol">
                            <div class="ns-half-icon-label"><i class="bi bi-clock-history"></i> <span>Last Disconnect</span></div>
                            <div class="ns-half-value" id="nsDiscDate" style="font-size:.78rem">-</div>
                            <div class="ns-half-sub" id="nsDiscDetail">-</div>
                        </div>
                    </div>
                    <div class="ns-chart-outer">
                        <div class="ns-chart-wrap" id="nsChartWrap">
                            <div class="ns-chart-slide">
                                <div class="ns-chart-top">
                                    <div class="ns-chart-title"><i class="bi bi-graph-up"></i> Statistik Kecepatan</div>
                                    <div class="ns-chart-legend">
                                        <span class="ns-chart-legend-item"><span class="ns-chart-dot" style="background:var(--c1)"></span> Download</span>
                                        <span class="ns-chart-legend-item"><span class="ns-chart-dot" style="background:var(--c2)"></span> Upload</span>
                                    </div>
                                </div>
                                <div class="ns-chart-canvas-wrap"><canvas id="nsSpeedChart"></canvas></div>
                                <div class="ns-chart-avg" id="nsSpeedAvg">
                                    <span class="ns-chart-avg-label">Rata-rata</span>
                                    <span class="ns-chart-legend-item"><span class="ns-chart-dot" style="background:var(--c1)"></span> <strong id="nsSpeedDl">42</strong> Mbps</span>
                                    <span class="ns-chart-legend-item"><span class="ns-chart-dot" style="background:var(--c2)"></span> <strong id="nsSpeedUl">19</strong> Mbps</span>
                                </div>
                            </div>
                            <div class="ns-chart-slide">
                                <div class="ns-chart-top">
                                    <div class="ns-chart-title"><i class="bi bi-pie-chart"></i> Penggunaan Data</div>
                                    <div class="ns-chart-legend">
                                        <span class="ns-chart-legend-item"><span class="ns-chart-dot" style="background:var(--c1)"></span> Download</span>
                                        <span class="ns-chart-legend-item"><span class="ns-chart-dot" style="background:var(--c2)"></span> Upload</span>
                                    </div>
                                </div>
                                <div class="ns-chart-canvas-wrap"><canvas id="nsUsageChart"></canvas></div>
                                <div class="ns-chart-avg" id="nsUsageAvg">
                                    <span class="ns-chart-avg-label">Rata-rata</span>
                                    <span class="ns-chart-legend-item"><span class="ns-chart-dot" style="background:var(--c1)"></span> <strong id="nsUsageDl">2.1</strong> GB/hari</span>
                                    <span class="ns-chart-legend-item"><span class="ns-chart-dot" style="background:var(--c2)"></span> <strong id="nsUsageUl">1.3</strong> GB/hari</span>
                                </div>
                            </div>
                        </div>
                        <div class="ns-chart-dots" id="nsChartDots">
                            <span class="ns-chart-dot-ind active"></span>
                            <span class="ns-chart-dot-ind"></span>
                        </div>
                    </div>
                    <div class="ns-wifi-row" id="nsWifiRow">
                        <div class="ns-wifi-item">
                            <div class="ns-wifi-bars" id="nsBars24"><span class="ns-wifi-bar"></span><span class="ns-wifi-bar"></span><span class="ns-wifi-bar"></span><span class="ns-wifi-bar"></span></div>
                            <div class="ns-wifi-meta"><span class="ns-wifi-ssid" id="nsSsid24">-</span><span class="ns-wifi-band-tag">2.4G</span><button class="ns-devices-btn" onclick="openDevicesModal('24g')"><i class="bi bi-phone"></i> <span id="nsDevices24">0</span> Terhubung</button></div>
                        </div>
                        <div class="ns-wifi-item">
                            <div class="ns-wifi-bars" id="nsBars5"><span class="ns-wifi-bar"></span><span class="ns-wifi-bar"></span><span class="ns-wifi-bar"></span><span class="ns-wifi-bar"></span></div>
                            <div class="ns-wifi-meta"><span class="ns-wifi-ssid" id="nsSsid5">-</span><span class="ns-wifi-band-tag">5G</span><button class="ns-devices-btn" onclick="openDevicesModal('5g')"><i class="bi bi-phone"></i> <span id="nsDevices5">0</span> Terhubung</button></div>
                        </div>
                    </div>
                    <button class="ns-btn-sesuaikan" onclick="openDeviceModal()"><i class="bi bi-sliders"></i> Sesuaikan</button>
                </div>
            </div>
        </section>

        <section>
            <div class="sh stg"><h2>{Lang::T('Recent Activity')}</h2></div>
            <div id="txList" style="padding:0 0 8px"><div class="pc-empty">{Lang::T('Loading')}...</div></div>
            <a href="{Text::url('order/history')}" class="btn-xs stg" style="display:block;text-align:center"><i class="bi bi-list-ul"></i> {Lang::T('View All')}</a>
        </section>
    </div>

{include file="components/_navbar.tpl"}
{include file="components/_menu_sheet.tpl"}

    <!-- NETWORK DEVICE MODAL -->
    <div class="offcanvas offcanvas-bottom os" tabindex="-1" id="nsDeviceModal">
        <div class="offcanvas-header flex-column"></div>
        <div class="ns-tabs" id="nsTabs">
            <button class="ns-tab active" onclick="switchTab('wifi24')">WiFi 2.4G</button>
            <button class="ns-tab" onclick="switchTab('wifi5')">WiFi 5G</button>
            <button class="ns-tab" onclick="switchTab('reboot')">Reboot</button>
        </div>
        <div class="ns-panel active" id="nsPanel24">
            <div class="ns-field"><label>Nama WiFi</label><input type="text" id="nsSsid24Input" value=""></div>
            <div class="ns-field"><label>Kata Sandi</label><div class="ns-input-wrap"><input type="password" id="nsPass24Input" value=""><button class="ns-pw-toggle" onclick="toggleNsPw('nsPass24Input',this)"><i class="bi bi-eye-slash"></i></button></div></div>
            <button class="ns-submit primary" onclick="saveWifi('24g')"><i class="bi bi-check-lg"></i> Simpan Perubahan</button>
        </div>
        <div class="ns-panel" id="nsPanel5">
            <div class="ns-field"><label>Nama WiFi 5G</label><input type="text" id="nsSsid5Input" value=""></div>
            <div class="ns-field"><label>Kata Sandi</label><div class="ns-input-wrap"><input type="password" id="nsPass5Input" value=""><button class="ns-pw-toggle" onclick="toggleNsPw('nsPass5Input',this)"><i class="bi bi-eye-slash"></i></button></div></div>
            <button class="ns-submit primary" onclick="saveWifi('5g')"><i class="bi bi-check-lg"></i> Simpan Perubahan</button>
        </div>
        <div class="ns-panel" id="nsPanelReboot">
            <div class="ns-reboot-warn"><i class="bi bi-exclamation-triangle"></i> Reboot Perangkat<br><small>Perangkat akan dimulai ulang. Koneksi terputus selama 1-2 menit.</small></div>
            <div class="ns-confirm"><input type="checkbox" id="nsRebootConfirm" onchange="document.getElementById('nsRebootBtn').disabled=!this.checked"><label for="nsRebootConfirm">Saya mengerti, koneksi akan terputus</label></div>
            <button class="ns-submit danger" id="nsRebootBtn" disabled onclick="rebootDevice()"><i class="bi bi-arrow-repeat"></i> REBOOT</button>
        </div>
    </div>

    <!-- CONNECTED DEVICES MODAL -->
    <div class="offcanvas offcanvas-bottom os" tabindex="-1" id="nsDevicesModal">
        <div class="offcanvas-header flex-column"></div>
        <div class="offcanvas-body">
            <h6 class="fw-bold mb-3" id="nsDevicesTitle" style="font-size:.85rem;color:var(--tx)">Perangkat Terhubung</h6>
            <div id="nsDevicesList"></div>
        </div>
    </div>

    </div>

    <div class="offcanvas offcanvas-bottom os" tabindex="-1" id="rechargeErrModal">
        <div class="offcanvas-header flex-column"></div>
        <div class="offcanvas-body" style="text-align:center">
            <i class="bi bi-x-circle-fill" style="font-size:2.5rem;color:var(--c6);display:block;margin-bottom:12px"></i>
            <p id="rechargeErrMsg" style="font-size:.85rem;color:var(--t2);line-height:1.5;margin-bottom:20px"></p>
            <button class="vbtn" onclick="errModal.hide()" style="max-width:200px;margin:0 auto">Tutup</button>
        </div>
    </div>
    </div>

    <div class="offcanvas offcanvas-bottom os bal-mh" tabindex="-1" id="rechargeModal">
        <div class="offcanvas-header flex-column"></div>
        <div class="offcanvas-body">
            <div id="rechargeSkel">
                <div class="rch-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-sm h-sm"></span><i class="skl skl-bright" style="width:18px;height:18px;border-radius:50%;margin-left:auto"></i></div>
                <div class="rch-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-md h-sm"></span><i class="skl skl-bright" style="width:18px;height:18px;border-radius:50%;margin-left:auto"></i></div>
                <div class="rch-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-sm h-sm"></span><i class="skl skl-bright" style="width:18px;height:18px;border-radius:50%;margin-left:auto"></i></div>
                <div class="rch-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-lg h-sm"></span><i class="skl skl-bright" style="width:18px;height:18px;border-radius:50%;margin-left:auto"></i></div>
                <div class="rch-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-sm h-sm"></span><i class="skl skl-bright" style="width:18px;height:18px;border-radius:50%;margin-left:auto"></i></div>
            </div>
            <div id="rechargeList"></div>
        </div>
    </div>

    <div class="tc" id="toastContainer"></div>

    {if isset($hostname) && $hchap == 'true' && $_c['hs_auth_method'] == 'hchap'}
        <script src="/ui/ui/scripts/md5.js"></script>
        <script>var hh="http://{$hostname}/login",hu="{$_user['username']}",hp="{$_user['password']}",hd="{$apkurl}",hda="2";var hk=hexMD5('{$key1}'+hp+'{$key2}'),ha=hh+'?username='+hu+'&dst='+hd+'&password='+hk;document.write('<meta http-equiv="refresh" target="_blank" content="'+hda+'; url='+ha+'">');</script>
    {/if}

{include file="components/_scripts_common.tpl"}

    <script>
        {literal}
        function fetchData(){
            var start=Date.now();
            fetch(appUrl+'/ui/ui_custom/api/plan.php',{credentials:'include'})
            .then(function(r){if(!r.ok)throw Error('HTTP '+r.status);return r.json()})
            .then(function(d){
                var delay=Math.max(0,600-(Date.now()-start));
                setTimeout(function(){renderHero(d);renderTx(d)},delay)
            })
            .catch(function(e){
                showToast(L.error+' ('+e.message+')','error');
                document.getElementById('sklPlan').className='hero-plan';document.getElementById('sklPlan').textContent=L.noPlan;
                document.getElementById('txList').innerHTML='<div class="pc-empty">'+L.noTrx+'</div>'
            })
        }

        function renderHero(d){
            var p=d.active_plans&&d.active_plans.length?d.active_plans[0]:null;

            // Mark all skeletons as done (stop shimmer)
            document.querySelectorAll('#heroCard .skl').forEach(function(el){el.classList.add('skl-done')});

            // Plan name
            var sP=document.getElementById('sklPlan'),sBw=document.getElementById('sklBw');
            if(sP){sP.className='hero-plan';sP.style.cssText='';sP.textContent=p?p.name:L.noPlan}
            if(sBw&&p){sBw.className='hero-bw-badge';sBw.style.cssText='';sBw.textContent=p.bw_name&&p.bw_name!=='-'?p.bw_name:''}

            // Plan price
            var sPr=document.getElementById('sklPlanPrice');
            if(sPr){sPr.className='hero-plan-price';sPr.style.cssText='';sPr.textContent='Rp '+Number(p?p.price:0).toLocaleString('id-ID')}

            // Status badge
            var hs=document.getElementById('heroStatus');
            if(hs&&p)hs.innerHTML='<span class="status-dot '+(p.status==='on'?'on':'off')+'"></span><span>'+(p.status==='on'?L.active:L.expired)+'</span>';

            // Expired + Last Payment
            var se=document.getElementById('sklExpired'),sp=document.getElementById('sklPayDate');
            if(se){se.className='';se.style.cssText='';se.textContent=p?p.expiration_formatted||p.expiration:'-'}
            if(sp){sp.className='';sp.style.cssText='';sp.textContent=d.last_payment?d.last_payment.date:'-'}

            // Auto renewal
            var sa=document.getElementById('sklAutoRenewal');
            if(sa){sa.className='hero-ar-badge '+(p&&p.status==='on'?'ar-on':'ar-off');sa.style.cssText='';sa.textContent=(p&&p.status==='on')?'ON':'OFF'}

            // Buttons
            var b1=document.getElementById('sklBtn1');
            if(b1){var h1=appUrl+'/index.php?_route=order/package',l1='<i class="bi bi-cart3"></i> '+L.buy;
                if(p){
                    if(p.status==='on'){
                        h1='javascript:void(0)';l1='<i class=\"bi bi-arrow-repeat\"></i> '+L.recharge;
                        b1.outerHTML='<a href=\"'+h1+'\" class=\"hero-btn p\" onclick=\"openRechargeModal('+p.id+')\">'+l1+'</a>'
                    }else{
                        h1=appUrl+'/index.php?_route=home&extend='+p.id;l1='<i class=\"bi bi-arrow-repeat\"></i> '+L.extend;
                        b1.outerHTML='<a href=\"'+h1+'\" class=\"hero-btn p\">'+l1+'</a>'
                    }
                }else{b1.outerHTML='<a href=\"'+h1+'\" class=\"hero-btn p\">'+l1+'</a>'}}

            var b2=document.getElementById('sklBtn2');
            if(b2)b2.outerHTML='<a href="'+appUrl+'/index.php?_route=order/balance" class="hero-btn s"><i class="bi bi-plus-circle"></i> {/literal}{Lang::T('Top Up')|escape}{literal}</a>'

            if(typeof d.balance_formatted!=='undefined'){var ab=document.getElementById('abBal');if(ab){ab.className='';ab.style.cssText='';ab.textContent=d.balance_formatted}}
        }

        function renderTx(d){
            var c=document.getElementById('txList');if(!c)return;
            if(!d.transactions||!d.transactions.length){c.innerHTML='<div class="pc-empty">'+L.noTrx+'</div>';return}
            var h='';for(var i=0;i<Math.min(d.transactions.length,5);i++){var t=d.transactions[i],paid=t.status==='paid',cls=paid?'success':(t.status==='pending'?'pending':'failed'),ico=paid?'bi-check-circle-fill':(t.status==='pending'?'bi-clock-fill':'bi-x-circle-fill'),dt='';
                try{dt=t.date}catch(e){dt=t.date}
                h+='<div class="tx-item"><div class="tx-icon-wrap '+cls+'"><i class="bi '+ico+'"></i></div><div class="tx-mid"><div class="tx-name">'+es(t.plan_name)+'</div><div class="tx-sub">'+dt+' &middot; '+es(t.method)+'</div></div><div class="tx-end"><div class="tx-amount">Rp '+Number(t.amount).toLocaleString('id-ID')+'</div></div></div>'
            }c.innerHTML=h
        }

        /* ====== NETWORK DEVICE ====== */
        var _deviceData=null;
        function fetchDeviceData(refresh){
            var btn=document.querySelector('.ns-refresh');if(btn)btn.classList.add('spinning');
            var start=Date.now();
            if(refresh){document.getElementById('nsContent').style.display='none';document.getElementById('nsSkeleton').style.display='block'}
            fetch(appUrl+'/ui/ui_custom/api/device.php',{credentials:'include'})
            .then(function(r){if(!r.ok)throw Error('HTTP '+r.status);return r.json()})
            .then(function(d){_deviceData=d;
                var delay=refresh?Math.max(0,400-(Date.now()-start)):Math.max(0,600-(Date.now()-start));
                setTimeout(function(){renderDevice(d,refresh);if(refresh)showToast('Data jaringan diperbarui','success')},delay);
                if(btn)btn.classList.remove('spinning')
            })
            .catch(function(e){showToast('Device: '+e.message,'error');if(btn)btn.classList.remove('spinning')})
        }
        function renderDevice(d,isRefresh){
            document.getElementById('nsSkeleton').style.display='none';
            var c=document.getElementById('nsContent');if(c)c.style.display='block';
            document.getElementById('nsModel').textContent=d.modem.model||'Modem ONT';
            document.getElementById('nsModelSub').textContent='Home Gateway';
            var st=d.modem.status==='online',pill=document.getElementById('nsStatusPill'),dot=document.getElementById('nsStatusDot'),txt=document.getElementById('nsStatusText');
            if(pill)pill.className='ns-status-pill'+(st?'':' off');
            if(dot)dot.style.background=st?'var(--c4)':'var(--c6)';if(txt)txt.textContent=st?'ONLINE':'OFFLINE';
            // RX Power + Gauge
            var rx=d.modem.rx_power,rxVal=document.getElementById('nsRxPower'),rxCol=document.getElementById('nsRxCol'),rxGauge=document.getElementById('nsRxGauge');
            if(rxVal)rxVal.textContent=rx||'- dBm';
            var v2=parseFloat(rx)||-30,pct=0,qClass='';
            if(v2>-20){pct=100;qClass='ns-rx-green'}
            else if(v2>-22){pct=75;qClass='ns-rx-yellow'}
            else if(v2>-25){pct=50;qClass='ns-rx-yellow'}
            else if(v2>-30){pct=25;qClass='ns-rx-red'}
            else{pct=10;qClass='ns-rx-red'}
            if(rxCol)rxCol.className='ns-info-half '+qClass;
            if(rxGauge){rxGauge.style.width=pct+'%';rxGauge.style.background=qClass==='ns-rx-green'?'var(--c4)':qClass==='ns-rx-yellow'?'var(--c5)':'var(--c6)'}
            // Last Disconnect — red only on error reason
            var discCol=document.getElementById('nsDiscCol');
            if(d.last_disconnect){
                document.getElementById('nsDiscDate').textContent=(d.last_disconnect.time||'').replace(' WIB','')+' '+(d.last_disconnect.date||'');
                document.getElementById('nsDiscDetail').textContent=(d.last_disconnect.reason||'')+' · '+(d.last_disconnect.duration||'');
                var re=/error|fail|timeout|down|loss/i;
                if(discCol)discCol.className='ns-info-half '+(re.test(d.last_disconnect.reason||'')?'ns-disc-error':'');
            }
            // WiFi
            document.getElementById('nsSsid24').textContent=d.wifi_24g.ssid||'-';
            document.getElementById('nsDevices24').textContent=d.wifi_24g.devices||0;
            document.getElementById('nsSsid5').textContent=d.wifi_5g.ssid||'-';
            document.getElementById('nsDevices5').textContent=d.wifi_5g.devices||0;
            var isOn=d.modem.status==='online';
            renderBars('nsBars24',isOn);
            renderBars('nsBars5',isOn);
            document.getElementById('nsSsid24Input').value=d.wifi_24g.ssid||'';
            document.getElementById('nsPass24Input').value=d.wifi_24g.password||'';
            document.getElementById('nsSsid5Input').value=d.wifi_5g.ssid||'';
            document.getElementById('nsPass5Input').value=d.wifi_5g.password||'';
            // Chart
            renderSpeedChart(d.bandwidth);
            renderUsageChart();
        }
        function openDeviceModal(){new bootstrap.Offcanvas(document.getElementById('nsDeviceModal')).show()}
        function switchTab(name){
            document.querySelectorAll('.ns-tab,.ns-panel').forEach(function(el){el.classList.remove('active')});
            var tabMap={wifi24:0,wifi5:1,reboot:2};
            document.querySelectorAll('.ns-tab')[tabMap[name]].classList.add('active');
            document.getElementById('nsPanel'+(name==='wifi24'?'24':name==='wifi5'?'5':'Reboot')).classList.add('active');
        }
        function toggleNsPw(id,btn){
            var el=document.getElementById(id),icon=btn.querySelector('i');if(!el)return;
            if(el.type==='password'){el.type='text';icon.className='bi bi-eye'}else{el.type='password';icon.className='bi bi-eye-slash'}
        }
        function saveWifi(band){
            var ssid = document.getElementById('nsSsid'+(band==='24g'?'24':'5')+'Input').value;
            var pass = document.getElementById('nsPass'+(band==='24g'?'24':'5')+'Input').value;
            fetch(appUrl+'/ui/ui_custom/api/device.php',{
                method:'POST',credentials:'include',
                headers:{'Content-Type':'application/json'},
                body:JSON.stringify({band:band,ssid:ssid,password:pass})
            })
            .then(function(r){return r.json()})
            .then(function(d){
                if(d.success){showToast('WiFi '+band+' disimpan','success');fetchDeviceData(true)}
                else showToast('Gagal menyimpan','error')
            })
            .catch(function(){showToast('Gagal menyimpan','error')})
        }
        function rebootDevice(){showToast('Perangkat sedang direboot (dummy)','success');document.getElementById('nsRebootConfirm').checked=false;document.getElementById('nsRebootBtn').disabled=true}

        function openDevicesModal(band){
            if(!_deviceData)return;
            var title=document.getElementById('nsDevicesTitle'),list=document.getElementById('nsDevicesList');
            var data=band==='24g'?_deviceData.wifi_24g:_deviceData.wifi_5g;
            var devices=data.connected_devices||[];
            var label=band==='24g'?'2.4 GHz':'5 GHz';
            if(title)title.textContent='Perangkat Terhubung — '+label+' ('+devices.length+')';
            if(list){
                if(!devices.length){list.innerHTML='<div class="pc-empty">Tidak ada perangkat</div>'}
                else{
                    list.innerHTML=devices.map(function(d){
                        var icon=/phone|iphone|android|samsung|xiaomi|oppo|pixel/i.test(d.hostname)?'bi-phone':
                                  /laptop|notebook|macbook/i.test(d.hostname)?'bi-laptop':
                                  /tv|smart.?tv/i.test(d.hostname)?'bi-tv':
                                  /tablet|ipad/i.test(d.hostname)?'bi-tablet':'bi-device-hdd';
                        return '<div class="ns-device-host"><div class="ns-device-host-icon"><i class="bi '+icon+'"></i></div><div class="ns-device-host-info"><div class="ns-device-host-name">'+es(d.hostname)+'</div><div class="ns-device-host-meta"><span>'+es(d.ip)+'</span><span>'+es(d.mac)+'</span><span>'+es(d.connected_since)+'</span></div></div><div class="ns-device-actions"><button class="ns-action-btn warn" onclick="deviceAction(\'disconnect\',\''+band+'\',\''+d.mac+'\')">Putuskan</button><button class="ns-action-btn danger" onclick="deviceAction(\'block\',\''+band+'\',\''+d.mac+'\')">Blok</button></div></div>';
                    }).join('');
                }
            }
            if(!_devicesModal)_devicesModal=new bootstrap.Offcanvas(document.getElementById('nsDevicesModal'));
            _devicesModal.show();
        }

        function deviceAction(action,band,mac){
            fetch(appUrl+'/ui/ui_custom/api/device.php',{
                method:'POST',credentials:'include',
                headers:{'Content-Type':'application/json'},
                body:JSON.stringify({action:action,band:band,mac:mac})
            })
            .then(function(r){return r.json()})
            .then(function(d){
                if(d.success){showToast(d.message,'success');if(_devicesModal)_devicesModal.hide();fetchDeviceData(true)}
                else showToast('Gagal','error')
            })
            .catch(function(){showToast('Gagal','error')})
        }

        function es(s){var d=document.createElement('div');d.textContent=s||'';return d.innerHTML}
        function renderBars(id,online){var c=document.getElementById(id);if(!c)return;var bars=c.querySelectorAll('.ns-wifi-bar'),cls=online?'on':'off';for(var i=0;i<bars.length;i++)bars[i].className='ns-wifi-bar '+cls}

        var _speedChart=null,_usageChart=null,_devicesModal=null;

        function renderSpeedChart(bw){
            var now=new Date(),labels=[],dl=[],ul=[];
            var cd=parseFloat((bw.down||'40').match(/[\d.]+/))||40;
            var cu=parseFloat((bw.up||'20').match(/[\d.]+/))||20;
            var walkDl=cd, walkUl=cu;
            for(var i=29;i>=0;i--){var d=new Date(now);d.setDate(d.getDate()-i);labels.push(d.toLocaleDateString('id-ID',{day:'numeric',month:'short'}));walkDl=+(walkDl+(Math.random()-.5)*8).toFixed(1);walkUl=+(walkUl+(Math.random()-.5)*5).toFixed(1);if(walkDl<5)walkDl=5;if(walkUl<2)walkUl=2;dl.push(walkDl);ul.push(walkUl)}
            var avgDl=(dl.reduce(function(a,b){return a+ +b},0)/dl.length).toFixed(1);
            var avgUl=(ul.reduce(function(a,b){return a+ +b},0)/ul.length).toFixed(1);
            var eDl=document.getElementById('nsSpeedDl'),eUl=document.getElementById('nsSpeedUl');
            if(eDl)eDl.textContent=avgDl;if(eUl)eUl.textContent=avgUl;
            var ctx=document.getElementById('nsSpeedChart');if(!ctx)return;
            if(_speedChart)_speedChart.destroy();
            var gdl=ctx.getContext('2d').createLinearGradient(0,0,0,110),gul=ctx.getContext('2d').createLinearGradient(0,0,0,110);
            gdl.addColorStop(0,'rgba(129,140,248,.18)');gdl.addColorStop(1,'rgba(129,140,248,0)');
            gul.addColorStop(0,'rgba(167,139,250,.14)');gul.addColorStop(1,'rgba(167,139,250,0)');
            var yMax=Math.ceil(Math.max(Math.max.apply(null,dl),Math.max.apply(null,ul),cd,cu)/10)*10+10;
            _speedChart=new Chart(ctx,{type:'line',data:{labels:labels,datasets:[
                {label:'Download',data:dl,borderColor:'#818cf8',backgroundColor:gdl,fill:true,tension:.4,borderWidth:1.5,pointRadius:0,pointHoverRadius:4,pointHoverBackgroundColor:'#818cf8',order:1},
                {label:'Upload',data:ul,borderColor:'#a78bfa',backgroundColor:gul,fill:true,tension:.4,borderWidth:1.5,pointRadius:0,pointHoverRadius:4,pointHoverBackgroundColor:'#a78bfa',order:2}
            ]},options:{responsive:true,maintainAspectRatio:false,interaction:{mode:'index',intersect:false},plugins:{legend:{display:false},tooltip:{backgroundColor:'#18181b',titleColor:'#a1a1aa',bodyColor:'#fafafa',borderColor:'#27272a',borderWidth:1,padding:10,titleFont:{size:10},bodyFont:{size:11},displayColors:true,boxPadding:3,callbacks:{label:function(c){return c.dataset.label+': '+c.raw+' Mbps'}}}},scales:{x:{display:true,border:{display:false},grid:{display:false},ticks:{color:'#71717a',font:{size:8},maxTicksLimit:6,align:'center'}},y:{min:0,max:yMax,border:{display:false},grid:{color:'rgba(39,39,42,.4)'},ticks:{color:'#71717a',font:{size:8},maxTicksLimit:4,callback:function(v){return v+' Mbps'}}}}}});
        }

        function renderUsageChart(){
            var now=new Date(),labels=[],dl=[],ul=[];
            var walkDl=2.5, walkUl=1.5;
            for(var i=29;i>=0;i--){var d=new Date(now);d.setDate(d.getDate()-i);labels.push(d.toLocaleDateString('id-ID',{day:'numeric',month:'short'}));walkDl=+(walkDl+(Math.random()-.5)*0.8).toFixed(1);walkUl=+(walkUl+(Math.random()-.5)*0.5).toFixed(1);if(walkDl<0.1)walkDl=0.1;if(walkUl<0.1)walkUl=0.1;if(walkDl>5)walkDl=5;if(walkUl>3)walkUl=3;dl.push(walkDl);ul.push(walkUl)}
            var avgDl=(dl.reduce(function(a,b){return a+ +b},0)/dl.length).toFixed(1);
            var avgUl=(ul.reduce(function(a,b){return a+ +b},0)/ul.length).toFixed(1);
            var eDl=document.getElementById('nsUsageDl'),eUl=document.getElementById('nsUsageUl');
            if(eDl)eDl.textContent=avgDl;if(eUl)eUl.textContent=avgUl;
            var ctx=document.getElementById('nsUsageChart');if(!ctx)return;
            if(_usageChart)_usageChart.destroy();
            _usageChart=new Chart(ctx,{type:'bar',data:{labels:labels,datasets:[
                {label:'Download',data:dl,backgroundColor:'#818cf8',borderRadius:4,borderSkipped:false,order:1},
                {label:'Upload',data:ul,backgroundColor:'#a78bfa',borderRadius:4,borderSkipped:false,order:2}
            ]},options:{responsive:true,maintainAspectRatio:false,interaction:{mode:'index',intersect:false},plugins:{legend:{display:false},tooltip:{backgroundColor:'#18181b',titleColor:'#a1a1aa',bodyColor:'#fafafa',borderColor:'#27272a',borderWidth:1,padding:10,titleFont:{size:10},bodyFont:{size:11},displayColors:true,boxPadding:3,callbacks:{label:function(c){return c.dataset.label+': '+c.raw+' GB'}}}},scales:{x:{display:true,border:{display:false},grid:{display:false},ticks:{color:'#71717a',font:{size:8},maxTicksLimit:6,align:'center'}},y:{display:false,border:{display:false},grid:{display:false},ticks:{display:false}}}}});
        }
        function showTransfer(){var b=bootstrap.Offcanvas.getInstance(document.getElementById('menuSheet'));if(b)b.hide();setTimeout(function(){new bootstrap.Offcanvas(document.getElementById('transferSheet')).show()},300)}

        var rechargeModal=null,rechargeId=null;
        function openRechargeModal(rid){
            rechargeId=rid;
            if(!rechargeModal)rechargeModal=new bootstrap.Offcanvas(document.getElementById('rechargeModal'));
            document.getElementById('rechargeSkel').style.display='block';
            document.getElementById('rechargeList').innerHTML='';
            rechargeModal.show();
            fetch(appUrl+'/ui/ui_custom/api/tripay_channels.php',{credentials:'include'})
            .then(function(r){return r.json()}).then(function(d){
                var h='';d.forEach(function(ch){
                    var logo=ch.logo?'<img src=\"'+appUrl+'/ui/ui_custom/'+ch.logo+'\" onerror=\"this.style.display=\\\'none\\\';this.nextElementSibling.style.display=\\\'block\\\'\"><span style=\"display:none\">'+ch.init.substring(0,2)+'</span>':'<span>'+ch.init.substring(0,2)+'</span>';
                    h+='<div class=\"rch-item\" data-channel=\"'+ch.id+'\" onclick=\"selectRechargeChannel(this)\"><span class=\"rch-logo\" style=\"background:'+(ch.color||'#666')+'\">'+logo+'</span><span class=\"rch-name\">'+ch.name+'</span><i class=\"bi bi-chevron-right rch-arrow\"></i></div>';
                });
                document.getElementById('rechargeSkel').style.display='none';
                document.getElementById('rechargeList').innerHTML=h;
            });
        }
        function selectRechargeChannel(el){
            if(!rechargeId)return;
            var channel=el.getAttribute('data-channel');
            el.classList.add('loading');
            el.querySelector('.rch-arrow').outerHTML='<span class=\"btn-dots\" style=\"display:flex;gap:4px\"><span style=\"width:6px;height:6px;border-radius:50%;background:var(--c1);animation:dotJump .5s infinite alternate\"></span><span style=\"width:6px;height:6px;border-radius:50%;background:var(--c1);animation:dotJump .5s infinite alternate;animation-delay:.15s\"></span><span style=\"width:6px;height:6px;border-radius:50%;background:var(--c1);animation:dotJump .5s infinite alternate;animation-delay:.3s\"></span></span>';
            fetch(appUrl+'/ui/ui_custom/api/recharge_redirect.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({recharge_id:rechargeId,channel:channel})})
            .then(function(r){return r.json()}).then(function(d){
                if(d.success&&d.url){window.location.href=d.url}
                else{el.classList.remove('loading');el.querySelector('.btn-dots').outerHTML='<i class=\"bi bi-chevron-right rch-arrow\"></i>';showRechargeError(d.error||'Gagal membuat transaksi')}
            }).catch(function(){el.classList.remove('loading');el.querySelector('.btn-dots').outerHTML='<i class=\"bi bi-chevron-right rch-arrow\"></i>';showRechargeError('Gagal membuat transaksi')});
        }

        var errModal=null;
        function showRechargeError(msg){
            if(rechargeModal)rechargeModal.hide();
            if(!errModal)errModal=new bootstrap.Offcanvas(document.getElementById('rechargeErrModal'));
            document.getElementById('rechargeErrMsg').textContent=msg;
            errModal.show();
        }

        document.addEventListener('DOMContentLoaded',function(){
            fetchData();fetchDeviceData();
        });
        {/literal}
    </script>
</body>
</html>
