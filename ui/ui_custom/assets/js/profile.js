var pwModal=null;
function openPwModal(){
    var pw=document.getElementById('pwCurrent'),pn=document.getElementById('pwNew'),pc=document.getElementById('pwConfirm');
    if(pw)pw.value='';if(pn)pn.value='';if(pc)pc.value='';
    [pw,pn,pc].forEach(function(i){if(i&&i.parentElement)i.parentElement.classList.remove('filled')});
    if(!pwModal)pwModal=new bootstrap.Offcanvas(document.getElementById('pwModal'));
    pwModal.show();
}
function togglePw(id,btn){
    var el=document.getElementById(id),icon=btn.querySelector('i');
    if(el.type==='password'){el.type='text';icon.className='bi bi-eye'}
    else{el.type='password';icon.className='bi bi-eye-slash'}
}
function changePassword(e){
    e.preventDefault();
    var btn=document.getElementById('pwSubmit');
    showDots(btn);
    var txt=btn.getAttribute('data-text')||'Save New Password';
    var data={
        password:document.getElementById('pwCurrent').value,
        npass:document.getElementById('pwNew').value,
        cnpass:document.getElementById('pwConfirm').value
    };
    fetch(appUrl+'/ui/ui_custom/api/change_password.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(data)})
    .then(function(r){return r.json()}).then(function(d){
        if(d.success){
            var body=document.querySelector('#pwModal .offcanvas-body');
            body.innerHTML='<div style="text-align:center;padding:30px 0"><i class="bi bi-check-circle-fill" style="font-size:3rem;color:var(--c4);display:block;margin-bottom:12px"></i><p style="font-size:.9rem;color:var(--tx);margin-bottom:8px">Password berhasil diubah</p><p style="font-size:.7rem;color:var(--t3)">Mengalihkan ke login...</p></div>';
            setTimeout(function(){window.location.href=d.redirect},2000);
        }
        else{hideDots(btn);btn.innerHTML='<i class="bi bi-check-lg"></i> '+txt;showToast(d.message,'error')}
    }).catch(function(){hideDots(btn);btn.innerHTML='<i class="bi bi-check-lg"></i> '+txt;showToast('Gagal','error')});
}
