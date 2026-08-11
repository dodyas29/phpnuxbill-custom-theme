<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover, user-scalable=no">
<meta name="theme-color" content="#09090b">
<title>Verifikasi Perangkat &mdash; {$_c['CompanyName']}</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="{$app_url}/ui/ui_custom/customer/assets/css/style.css?v=3">
<script>var appUrl='{$app_url}';var CSRF='{$csrf_token}';</script>
</head>
<body>

<header class="ab">
    <div class="ab-l">
        <div class="ab-logo">
            {if isset($_c['login_page_logo']) && $_c['login_page_logo'] != ''}
                <img src="{$app_url}/{$UPLOAD_PATH}/{$_c['login_page_logo']}" class="ab-logo-img" onerror="this.style.display='none'">
            {/if}
            <span>{$_c['CompanyName']|truncate:14:""}</span>
        </div>
    </div>
    <div class="ab-r">
        <button class="ab-btn" id="dmBtn" onclick="toggleTheme()"><i class="bi bi-sun-fill"></i></button>
    </div>
</header>

<div class="cw">

    <a href="{$app_url}/?_route=plugin/postpaid_page" class="in-back stg"><i class="bi bi-chevron-left"></i> Kembali</a>

    <div class="pp-verify-choice stg" id="pvChoice">
        <div class="pv-card">
            <span class="pv-icon"><i class="bi bi-shield-check"></i></span>
            <h3 class="pv-title">Verifikasi Perangkat</h3>
            <p class="pv-desc">Sebelum berlangganan, pastikan modem sudah terpasang di lokasi Anda.</p>
            <button class="vbtn" onclick="pvStart(1)"><i class="bi bi-camera-fill"></i> Verifikasi</button>
            <button class="vbtn pv-btn-alt" onclick="showToast('Fitur permintaan instalasi segera hadir','success')"><i class="bi bi-tools"></i> Minta Instalasi</button>
        </div>
    </div>

    <div class="pp-verify-capture hidden stg" id="pvCapture">
        <div class="pv-card">
            <span class="pv-step-label">Langkah <b id="pvStepNum">1</b>/2</span>
            <h3 class="pv-title" id="pvStepTitle">Foto Perangkat Modem</h3>
            <div class="pv-preview" id="pvPreview" onclick="pvOpenCamera()">
                <i class="bi bi-camera pv-camera-icon"></i>
                <span class="pv-camera-text">Klik untuk mengambil foto</span>
            </div>
            <input type="file" id="pvInput" accept="image/*" onchange="pvPreviewImage(this)" style="display:none">
            <button class="vbtn" id="pvSubmit" onclick="pvSubmit()" disabled><i class="bi bi-check-lg"></i> Lanjutkan</button>
        </div>
    </div>

</div>

<div class="tc" id="toastContainer"></div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="{$app_url}/ui/ui_custom/customer/assets/js/script.js"></script>
<script>
{literal}
var pvPlanId={/literal}{$plan_id}{literal},pvStep=0,pvDevice=null,pvSelfie=null;
function pvStart(step){
    pvStep=step;
    var input=document.getElementById('pvInput');
    if(step===1){input.setAttribute('capture','environment');document.getElementById('pvStepTitle').textContent='Foto Perangkat Modem'}
    else{input.setAttribute('capture','user');document.getElementById('pvStepTitle').textContent='Selfi Wajah'}
    document.getElementById('pvStepNum').textContent=step;
    var prev=document.getElementById('pvPreview');
    prev.style.backgroundImage='';prev.innerHTML='<i class="bi bi-camera pv-camera-icon"></i><span class="pv-camera-text">Klik untuk mengambil foto</span>';
    document.getElementById('pvSubmit').disabled=true;
    document.getElementById('pvChoice').classList.add('hidden');
    document.getElementById('pvCapture').classList.remove('hidden');
    setTimeout(function(){document.getElementById('pvInput').click()},300);
}
function pvOpenCamera(){document.getElementById('pvInput').click()}
function pvPreviewImage(input){
    if(!input.files||!input.files[0])return;
    var reader=new FileReader();
    reader.onload=function(e){
        var prev=document.getElementById('pvPreview');
        prev.innerHTML='';prev.style.backgroundImage='url('+e.target.result+')';
        document.getElementById('pvSubmit').disabled=false;
        if(pvStep===1)pvDevice=e.target.result;else pvSelfie=e.target.result;
    };
    reader.readAsDataURL(input.files[0]);
}
function pvSubmit(){
    if(pvStep===1&&!pvDevice){showToast('Ambil foto perangkat dulu','error');return}
    if(pvStep===2&&!pvSelfie){showToast('Ambil foto selfi dulu','error');return}
    var img=pvStep===1?pvDevice:pvSelfie;
    var btn=document.getElementById('pvSubmit');showDots(btn);
    fetch(appUrl+'/ui/ui_custom/customer/api/postpaid_verify.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({plan_id:pvPlanId,image:img,type:pvStep===1?'device':'selfie'})})
    .then(function(r){return r.json()}).then(function(d){
        hideDots(btn);
        if(!d.success){showToast(d.error||'Gagal upload','error');return}
        if(pvStep===1){pvStart(2)}else{showToast('Verifikasi berhasil','success');setTimeout(function(){window.location.href=appUrl+'/?_route=plugin/postpaid_page&verify='+pvPlanId},600)}
    }).catch(function(){hideDots(btn);showToast('Gagal upload','error')});
}
{/literal}
</script>
</body>
</html>
