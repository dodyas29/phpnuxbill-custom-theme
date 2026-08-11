<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
{include file="components/_head_common.tpl"}
</head>
<body>
{include file="components/_header.tpl"}

    <div class="cw">
        <section>
            <div class="sh stg"><h2>{Lang::T('Order History')}</h2></div>

            <div id="ohList">
                <div class="oh-skel"><span class="skl skl-bright w-sm" style="height:13px"></span><span class="skl skl-bright w-xs" style="height:13px;margin-left:auto"></span><span class="skl skl-bright" style="width:14px;height:14px;border-radius:50%;margin:0 8px"></span><span class="skl skl-bright w-xs" style="height:10px"></span><span class="skl skl-bright" style="width:8px;height:12px;border-radius:1px;margin-left:4px"></span></div>
                <div class="oh-skel"><span class="skl skl-bright w-md" style="height:13px"></span><span class="skl skl-bright w-xs" style="height:13px;margin-left:auto"></span><span class="skl skl-bright" style="width:14px;height:14px;border-radius:50%;margin:0 8px"></span><span class="skl skl-bright w-xs" style="height:10px"></span><span class="skl skl-bright" style="width:8px;height:12px;border-radius:1px;margin-left:4px"></span></div>
                <div class="oh-skel"><span class="skl skl-bright w-lg" style="height:13px"></span><span class="skl skl-bright w-xs" style="height:13px;margin-left:auto"></span><span class="skl skl-bright" style="width:14px;height:14px;border-radius:50%;margin:0 8px"></span><span class="skl skl-bright w-xs" style="height:10px"></span><span class="skl skl-bright" style="width:8px;height:12px;border-radius:1px;margin-left:4px"></span></div>
                <div class="oh-skel"><span class="skl skl-bright w-sm" style="height:13px"></span><span class="skl skl-bright w-xs" style="height:13px;margin-left:auto"></span><span class="skl skl-bright" style="width:14px;height:14px;border-radius:50%;margin:0 8px"></span><span class="skl skl-bright w-xs" style="height:10px"></span><span class="skl skl-bright" style="width:8px;height:12px;border-radius:1px;margin-left:4px"></span></div>
                <div class="oh-skel"><span class="skl skl-bright w-md" style="height:13px"></span><span class="skl skl-bright w-xs" style="height:13px;margin-left:auto"></span><span class="skl skl-bright" style="width:14px;height:14px;border-radius:50%;margin:0 8px"></span><span class="skl skl-bright w-xs" style="height:10px"></span><span class="skl skl-bright" style="width:8px;height:12px;border-radius:1px;margin-left:4px"></span></div>
                <div class="oh-skel"><span class="skl skl-bright w-sm" style="height:13px"></span><span class="skl skl-bright w-xs" style="height:13px;margin-left:auto"></span><span class="skl skl-bright" style="width:14px;height:14px;border-radius:50%;margin:0 8px"></span><span class="skl skl-bright w-xs" style="height:10px"></span><span class="skl skl-bright" style="width:8px;height:12px;border-radius:1px;margin-left:4px"></span></div>
                <div class="oh-skel"><span class="skl skl-bright w-lg" style="height:13px"></span><span class="skl skl-bright w-xs" style="height:13px;margin-left:auto"></span><span class="skl skl-bright" style="width:14px;height:14px;border-radius:50%;margin:0 8px"></span><span class="skl skl-bright w-xs" style="height:10px"></span><span class="skl skl-bright" style="width:8px;height:12px;border-radius:1px;margin-left:4px"></span></div>
                <div class="oh-skel"><span class="skl skl-bright w-md" style="height:13px"></span><span class="skl skl-bright w-xs" style="height:13px;margin-left:auto"></span><span class="skl skl-bright" style="width:14px;height:14px;border-radius:50%;margin:0 8px"></span><span class="skl skl-bright w-xs" style="height:10px"></span><span class="skl skl-bright" style="width:8px;height:12px;border-radius:1px;margin-left:4px"></span></div>
                <div class="oh-skel"><span class="skl skl-bright w-sm" style="height:13px"></span><span class="skl skl-bright w-xs" style="height:13px;margin-left:auto"></span><span class="skl skl-bright" style="width:14px;height:14px;border-radius:50%;margin:0 8px"></span><span class="skl skl-bright w-xs" style="height:10px"></span><span class="skl skl-bright" style="width:8px;height:12px;border-radius:1px;margin-left:4px"></span></div>
                <div class="oh-skel"><span class="skl skl-bright w-lg" style="height:13px"></span><span class="skl skl-bright w-xs" style="height:13px;margin-left:auto"></span><span class="skl skl-bright" style="width:14px;height:14px;border-radius:50%;margin:0 8px"></span><span class="skl skl-bright w-xs" style="height:10px"></span><span class="skl skl-bright" style="width:8px;height:12px;border-radius:1px;margin-left:4px"></span></div>
            </div>

            <div id="ohPager"></div>
        </section>
    </div>

{include file="components/_navbar.tpl"}
{include file="components/_menu_sheet.tpl"}
    <div class="tc" id="toastContainer"></div>

{include file="components/_scripts_common.tpl"}

    <script>
        {literal}
        var ohPage=1,ohHasMore=true,ohLoading=false;
        function loadHistory(append){
            if(ohLoading)return;ohLoading=true;
            if(!append){document.getElementById('ohList').innerHTML='';ohPage=1}
            fetch(appUrl+'/ui/ui_custom/api/order_history.php?page='+ohPage,{credentials:'include'})
            .then(function(r){return r.json()}).then(function(d){
                ohLoading=false;ohHasMore=d.has_more;
                if(append&&ohPage===1){document.getElementById('ohList').innerHTML=''}
                if(!d.data||!d.data.length){
                    if(!append)document.getElementById('ohList').innerHTML='<div class="pc-empty">Tidak ada transaksi</div>';
                    document.getElementById('ohPager').innerHTML='';
                    return;
                }
                var h='';
                d.data.forEach(function(item){
                    var s=item.status===1?'⏳':item.status===2?'✅':'✗';
                    h+='<a href="'+appUrl+'/index.php?_route=order/view/'+item.id+'" class="oh-row stg"><span class="oh-plan">'+item.plan_name+'</span><span class="oh-price">'+item.price_formatted+'</span><span class="oh-status s'+item.status+'">'+s+'</span><span class="oh-date">'+new Date(item.created_date).toLocaleDateString('id-ID',{day:'2-digit',month:'short'})+'</span><i class="bi bi-chevron-right" style="color:var(--t3);font-size:.7rem;flex-shrink:0"></i></a>';
                });
                if(append){document.getElementById('ohList').insertAdjacentHTML('beforeend',h)}
                else document.getElementById('ohList').innerHTML=h;
                document.getElementById('ohPager').innerHTML=ohHasMore?'<button class=\"vbtn\" onclick=\"loadHistory(true)\" style=\"margin-top:16px;background:var(--bgc);color:var(--tx)\">Muat Lebih Banyak</button>':'';
                ohPage++;
            }).catch(function(){ohLoading=false;});
        }
        loadHistory(false);
        {/literal}
    </script>
</body>
</html>
