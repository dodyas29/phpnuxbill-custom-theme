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
<script defer src="{$app_url}/ui/ui_custom/customer/assets/js/face-api/face-api.min.js"></script>
</head>
<body>

{include file="customer/components/_header.tpl"}

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
            <div class="pv-preview-wrap hidden" id="pvPreviewWrap">
                <video id="pvVideo" class="pv-video" autoplay muted playsinline></video>
                <canvas id="pvCanvas" class="pv-canvas"></canvas>
            </div>
            <span class="pv-face-status hidden" id="pvFaceStatus"><i class="bi bi-camera-video"></i> Arahkan wajah ke kamera...</span>
            <input type="file" id="pvInput" accept="image/*" onchange="pvPreviewImage(this)" style="display:none">
            <button class="vbtn" id="pvSubmit" onclick="pvSubmit()" disabled><i class="bi bi-check-lg"></i> Lanjutkan</button>
        </div>
    </div>

</div>

{include file="customer/components/_navbar.tpl"}
{include file="customer/components/_menu_sheet.tpl"}

<div class="tc" id="toastContainer"></div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="{$app_url}/ui/ui_custom/customer/assets/js/script.js"></script>
<script>
{literal}
var pvPlanId={/literal}{$plan_id}{literal},pvStep=0,pvDevice=null,pvSelfie=null,pvStream=null,pvLivenessInterval=null,modelsPath=appUrl+'/ui/ui_custom/customer/assets/js/face-api/models';

function pvStart(step){
    pvStep=step;pvStopStream();
    document.getElementById('pvStepNum').textContent=step;
    document.getElementById('pvSubmit').disabled=true;
    document.getElementById('pvChoice').classList.add('hidden');
    document.getElementById('pvCapture').classList.remove('hidden');

    if(step===1){
        document.getElementById('pvStepTitle').textContent='Foto Perangkat Modem';
        document.getElementById('pvPreview').classList.remove('hidden');
        document.getElementById('pvPreviewWrap').classList.add('hidden');
        document.getElementById('pvFaceStatus').classList.add('hidden');
        var prev=document.getElementById('pvPreview');
        prev.style.backgroundImage='';prev.innerHTML='<i class="bi bi-camera pv-camera-icon"></i><span class="pv-camera-text">Klik untuk mengambil foto</span>';
        var inp=document.getElementById('pvInput');
        inp.setAttribute('capture','environment');
        inp.value='';
        setTimeout(function(){inp.click()},300);
    }else{
        document.getElementById('pvStepTitle').textContent='Selfi Wajah';
        document.getElementById('pvPreview').classList.add('hidden');
        document.getElementById('pvPreviewWrap').classList.remove('hidden');
        document.getElementById('pvFaceStatus').classList.remove('hidden');
        document.getElementById('pvFaceStatus').innerHTML='<i class="bi bi-camera-video"></i> Mengaktifkan kamera...';
        pvInitCamera();
    }
}

function pvOpenCamera(){document.getElementById('pvInput').click()}
function pvPreviewImage(input){
    if(!input.files||!input.files[0])return;
    var reader=new FileReader();
    reader.onload=function(e){
        var prev=document.getElementById('pvPreview');
        prev.innerHTML='';prev.style.backgroundImage='url('+e.target.result+')';
        document.getElementById('pvSubmit').disabled=false;
        if(pvStep===1)pvDevice=e.target.result;
    };
    reader.readAsDataURL(input.files[0]);
}

function pvSubmit(){
    if(pvStep===1&&!pvDevice){showToast('Ambil foto perangkat dulu','error');return}
    if(pvStep===2&&!pvSelfie){showToast('Selfi belum diverifikasi','error');return}
    var img=pvStep===1?pvDevice:pvSelfie;
    var btn=document.getElementById('pvSubmit');showDots(btn);
    fetch(appUrl+'/ui/ui_custom/customer/api/postpaid_verify.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({plan_id:pvPlanId,image:img,type:pvStep===1?'device':'selfie'})})
    .then(function(r){return r.json()}).then(function(d){
        hideDots(btn);
        if(!d.success){showToast(d.error||'Gagal upload','error');return}
        if(pvStep===1){pvStart(2)}else{showToast('Verifikasi berhasil','success');setTimeout(function(){window.location.href=appUrl+'/?_route=plugin/postpaid_page&verify='+pvPlanId},600)}
    }).catch(function(){hideDots(btn);showToast('Gagal upload','error')});
}

async function pvInitCamera(){
    try{
        pvStream=await navigator.mediaDevices.getUserMedia({video:{facingMode:'user',width:320,height:240}});
        var video=document.getElementById('pvVideo');
        video.srcObject=pvStream;
        video.onloadedmetadata=function(){pvLoadModels()};
    }catch(e){
        document.getElementById('pvFaceStatus').innerHTML='<i class="bi bi-exclamation-triangle pv-fail"></i> Tidak bisa mengakses kamera. Izinkan akses kamera.';
    }
}

async function pvLoadModels(){
    try{
        await faceapi.nets.tinyFaceDetector.loadFromUri(modelsPath);
        await faceapi.nets.faceLandmark68Net.loadFromUri(modelsPath);
        document.getElementById('pvFaceStatus').innerHTML='<i class="bi bi-person-bounding-box"></i> Arahkan wajah ke kamera...';
        pvRunLiveness();
    }catch(e){
        document.getElementById('pvFaceStatus').innerHTML='<i class="bi bi-exclamation-triangle pv-fail"></i> Gagal memuat model deteksi wajah.';
    }
}

function pvRunLiveness(){
    var video=document.getElementById('pvVideo');
    var canvas=document.getElementById('pvCanvas');
    var displaySize={width:320,height:240};
    faceapi.matchDimensions(canvas,displaySize);
    var blinkCount=0,blinkState=false;
    pvLivenessInterval=setInterval(async function(){
        try{
            var detections=await faceapi.detectAllFaces(video,new faceapi.TinyFaceDetectorOptions({inputSize:224,scoreThreshold:.5})).withFaceLandmarks();
            var ctx=canvas.getContext('2d');
            ctx.clearRect(0,0,canvas.width,canvas.height);
            if(detections.length>0){
                var landmarks=detections[0].landmarks;
                var pts=landmarks.positions;
                ctx.fillStyle=getComputedStyle(document.documentElement).getPropertyValue('--c1').trim();
                for(var i=0;i<pts.length;i++){ctx.beginPath();ctx.arc(pts[i].x,pts[i].y,1.5,0,2*Math.PI);ctx.fill()}
                var leftEye=landmarks.getLeftEye();
                var rightEye=landmarks.getRightEye();
                var ear=(pvEyeAspectRatio(leftEye)+pvEyeAspectRatio(rightEye))/2;
                if(ear<.23&&!blinkState){blinkState=true;blinkCount++}
                else if(ear>=.23&&blinkState)blinkState=false;
                if(blinkCount>=1){
                    clearInterval(pvLivenessInterval);
                    pvStopStream();
                    document.getElementById('pvFaceStatus').innerHTML='<i class="bi bi-check-circle-fill pv-pass"></i> Wajah terverifikasi! Mengambil foto...';
                    var capCanvas=document.createElement('canvas');
                    capCanvas.width=video.videoWidth;capCanvas.height=video.videoHeight;
                    capCanvas.getContext('2d').drawImage(video,0,0);
                    pvSelfie=capCanvas.toDataURL('image/jpeg',.85);
                    document.getElementById('pvSubmit').disabled=false;
                    document.getElementById('pvSubmit').click();
                }else{
                    document.getElementById('pvFaceStatus').innerHTML='<i class="bi bi-person-bounding-box"></i> Kedipkan mata... ('+blinkCount+'/1)';
                }
            }else{
                document.getElementById('pvFaceStatus').innerHTML='<i class="bi bi-person-bounding-box"></i> Arahkan wajah ke kamera...';
            }
        }catch(e){}
    },200);
}

function pvEyeAspectRatio(eye){
    var a=Math.hypot(eye[1].x-eye[5].x,eye[1].y-eye[5].y);
    var b=Math.hypot(eye[2].x-eye[4].x,eye[2].y-eye[4].y);
    var c=Math.hypot(eye[0].x-eye[3].x,eye[0].y-eye[3].y);
    return(a+b)/(2*c);
}

function pvStopStream(){
    if(pvLivenessInterval){clearInterval(pvLivenessInterval);pvLivenessInterval=null}
    if(pvStream){pvStream.getTracks().forEach(function(t){t.stop()});pvStream=null}
}
{/literal}
</script>
</body>
</html>
