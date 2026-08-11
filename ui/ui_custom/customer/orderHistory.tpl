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
                <div class="oh-skel"><span class="skl skl-bright w-sm h-sm"></span><span class="skl skl-bright w-xs h-sm" style="margin-left:auto"></span><span class="skl skl-bright" style="width:14px;height:14px;border-radius:50%;margin:0 8px"></span><span class="skl skl-bright w-xs h-xs"></span><i class="skl skl-bright" style="width:10px;height:10px;border-radius:2px;margin-left:4px"></i></div>
                <div class="oh-skel"><span class="skl skl-bright w-md h-sm"></span><span class="skl skl-bright w-xs h-sm" style="margin-left:auto"></span><span class="skl skl-bright" style="width:14px;height:14px;border-radius:50%;margin:0 8px"></span><span class="skl skl-bright w-xs h-xs"></span><i class="skl skl-bright" style="width:10px;height:10px;border-radius:2px;margin-left:4px"></i></div>
                <div class="oh-skel"><span class="skl skl-bright w-lg h-sm"></span><span class="skl skl-bright w-xs h-sm" style="margin-left:auto"></span><span class="skl skl-bright" style="width:14px;height:14px;border-radius:50%;margin:0 8px"></span><span class="skl skl-bright w-xs h-xs"></span><i class="skl skl-bright" style="width:10px;height:10px;border-radius:2px;margin-left:4px"></i></div>
                <div class="oh-skel"><span class="skl skl-bright w-sm h-sm"></span><span class="skl skl-bright w-xs h-sm" style="margin-left:auto"></span><span class="skl skl-bright" style="width:14px;height:14px;border-radius:50%;margin:0 8px"></span><span class="skl skl-bright w-xs h-xs"></span><i class="skl skl-bright" style="width:10px;height:10px;border-radius:2px;margin-left:4px"></i></div>
                <div class="oh-skel"><span class="skl skl-bright w-md h-sm"></span><span class="skl skl-bright w-xs h-sm" style="margin-left:auto"></span><span class="skl skl-bright" style="width:14px;height:14px;border-radius:50%;margin:0 8px"></span><span class="skl skl-bright w-xs h-xs"></span><i class="skl skl-bright" style="width:10px;height:10px;border-radius:2px;margin-left:4px"></i></div>
                <div class="oh-skel"><span class="skl skl-bright w-sm h-sm"></span><span class="skl skl-bright w-xs h-sm" style="margin-left:auto"></span><span class="skl skl-bright" style="width:14px;height:14px;border-radius:50%;margin:0 8px"></span><span class="skl skl-bright w-xs h-xs"></span><i class="skl skl-bright" style="width:10px;height:10px;border-radius:2px;margin-left:4px"></i></div>
            </div>

            <div class="oh-pager" id="ohPager" style="display:none"></div>
        </section>
    </div>

{include file="components/_navbar.tpl"}
{include file="components/_menu_sheet.tpl"}
    <div class="tc" id="toastContainer"></div>

{include file="components/_scripts_common.tpl"}

    <script>
        {literal}
        var ohPage=1,ohPages=1;
        function loadHistory(page){
            fetch(appUrl+'/ui/ui_custom/api/order_history.php?page='+page,{credentials:'include'})
            .then(function(r){return r.json()}).then(function(d){
                var list=document.getElementById('ohList'),h='';
                if(!d.data||!d.data.length){list.innerHTML='<div class="pc-empty">Tidak ada transaksi</div>';return}
                var months={};
                d.data.forEach(function(item){
                    var m=item.created_date.substring(0,7);
                    if(!months[m]){months[m]=[];h+='<div class="oh-month">'+new Date(item.created_date).toLocaleDateString('id-ID',{month:'long',year:'numeric'})+'</div>'}
                    var s=item.status===1?'⏳':item.status===2?'✅':'✗';
                    h+='<a href="'+appUrl+'/index.php?_route=order/view/'+item.id+'" class="oh-row stg"><span class="oh-plan">'+item.plan_name+'</span><span class="oh-price">'+item.price_formatted+'</span><span class="oh-status s'+item.status+'">'+s+'</span><span class="oh-date">'+new Date(item.created_date).toLocaleDateString('id-ID',{day:'2-digit',month:'short'})+'</span><i class="bi bi-chevron-right" style="color:var(--t3);font-size:.7rem;flex-shrink:0"></i></a>';
                });
                list.innerHTML=h;
                ohPage=d.page;ohPages=d.pages;
                var pager=document.getElementById('ohPager'),ph='';
                if(d.has_prev)ph+='<a href="javascript:void(0)" onclick="loadHistory('+(d.page-1)+')" class="vbtn" style="background:var(--bgc);color:var(--tx)">← Sebelumnya</a>';
                if(d.has_more)ph+='<a href="javascript:void(0)" onclick="loadHistory('+(d.page+1)+')" class="vbtn" style="background:var(--bgc);color:var(--tx)">Selanjutnya →</a>';
                pager.innerHTML=ph;pager.style.display=ph?'flex':'none';
            }).catch(function(){document.getElementById('ohList').innerHTML='<div class="pc-empty">Gagal memuat</div>'});
        }
        loadHistory(1);
        {/literal}
    </script>
</body>
</html>
