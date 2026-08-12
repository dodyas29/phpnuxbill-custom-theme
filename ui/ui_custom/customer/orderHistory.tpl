<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
{include file="customer/components/_head_common.tpl"}
</head>
<body>
{include file="customer/components/_header.tpl"}

    <div class="cw">
        <section>
            <div class="sh shm stg"><h2>{Lang::T('Order History')}</h2></div>

            <div id="ohList">
                <div class="oh-skel"><span class="skl skl-bright" style="width:40%;height:15px;flex:0 0 auto"></span><span class="skl skl-bright" style="width:60px;height:13px;margin-left:auto;flex-shrink:0"></span><span class="skl skl-bright" style="width:18px;height:14px;border-radius:50%;flex-shrink:0;margin:0 8px"></span><span class="skl skl-bright" style="width:36px;height:10px;flex-shrink:0"></span><span class="skl skl-bright" style="width:8px;height:12px;flex-shrink:0;margin-left:4px"></span></div>
                <div class="oh-skel"><span class="skl skl-bright" style="width:55%;height:15px;flex:0 0 auto"></span><span class="skl skl-bright" style="width:60px;height:13px;margin-left:auto;flex-shrink:0"></span><span class="skl skl-bright" style="width:18px;height:14px;border-radius:50%;flex-shrink:0;margin:0 8px"></span><span class="skl skl-bright" style="width:36px;height:10px;flex-shrink:0"></span><span class="skl skl-bright" style="width:8px;height:12px;flex-shrink:0;margin-left:4px"></span></div>
                <div class="oh-skel"><span class="skl skl-bright" style="width:30%;height:15px;flex:0 0 auto"></span><span class="skl skl-bright" style="width:60px;height:13px;margin-left:auto;flex-shrink:0"></span><span class="skl skl-bright" style="width:18px;height:14px;border-radius:50%;flex-shrink:0;margin:0 8px"></span><span class="skl skl-bright" style="width:36px;height:10px;flex-shrink:0"></span><span class="skl skl-bright" style="width:8px;height:12px;flex-shrink:0;margin-left:4px"></span></div>
                <div class="oh-skel"><span class="skl skl-bright" style="width:45%;height:15px;flex:0 0 auto"></span><span class="skl skl-bright" style="width:60px;height:13px;margin-left:auto;flex-shrink:0"></span><span class="skl skl-bright" style="width:18px;height:14px;border-radius:50%;flex-shrink:0;margin:0 8px"></span><span class="skl skl-bright" style="width:36px;height:10px;flex-shrink:0"></span><span class="skl skl-bright" style="width:8px;height:12px;flex-shrink:0;margin-left:4px"></span></div>
                <div class="oh-skel"><span class="skl skl-bright" style="width:35%;height:15px;flex:0 0 auto"></span><span class="skl skl-bright" style="width:60px;height:13px;margin-left:auto;flex-shrink:0"></span><span class="skl skl-bright" style="width:18px;height:14px;border-radius:50%;flex-shrink:0;margin:0 8px"></span><span class="skl skl-bright" style="width:36px;height:10px;flex-shrink:0"></span><span class="skl skl-bright" style="width:8px;height:12px;flex-shrink:0;margin-left:4px"></span></div>
                <div class="oh-skel"><span class="skl skl-bright" style="width:50%;height:15px;flex:0 0 auto"></span><span class="skl skl-bright" style="width:60px;height:13px;margin-left:auto;flex-shrink:0"></span><span class="skl skl-bright" style="width:18px;height:14px;border-radius:50%;flex-shrink:0;margin:0 8px"></span><span class="skl skl-bright" style="width:36px;height:10px;flex-shrink:0"></span><span class="skl skl-bright" style="width:8px;height:12px;flex-shrink:0;margin-left:4px"></span></div>
                <div class="oh-skel"><span class="skl skl-bright" style="width:60%;height:15px;flex:0 0 auto"></span><span class="skl skl-bright" style="width:60px;height:13px;margin-left:auto;flex-shrink:0"></span><span class="skl skl-bright" style="width:18px;height:14px;border-radius:50%;flex-shrink:0;margin:0 8px"></span><span class="skl skl-bright" style="width:36px;height:10px;flex-shrink:0"></span><span class="skl skl-bright" style="width:8px;height:12px;flex-shrink:0;margin-left:4px"></span></div>
                <div class="oh-skel"><span class="skl skl-bright" style="width:25%;height:15px;flex:0 0 auto"></span><span class="skl skl-bright" style="width:60px;height:13px;margin-left:auto;flex-shrink:0"></span><span class="skl skl-bright" style="width:18px;height:14px;border-radius:50%;flex-shrink:0;margin:0 8px"></span><span class="skl skl-bright" style="width:36px;height:10px;flex-shrink:0"></span><span class="skl skl-bright" style="width:8px;height:12px;flex-shrink:0;margin-left:4px"></span></div>
                <div class="oh-skel"><span class="skl skl-bright" style="width:42%;height:15px;flex:0 0 auto"></span><span class="skl skl-bright" style="width:60px;height:13px;margin-left:auto;flex-shrink:0"></span><span class="skl skl-bright" style="width:18px;height:14px;border-radius:50%;flex-shrink:0;margin:0 8px"></span><span class="skl skl-bright" style="width:36px;height:10px;flex-shrink:0"></span><span class="skl skl-bright" style="width:8px;height:12px;flex-shrink:0;margin-left:4px"></span></div>
                <div class="oh-skel"><span class="skl skl-bright" style="width:48%;height:15px;flex:0 0 auto"></span><span class="skl skl-bright" style="width:60px;height:13px;margin-left:auto;flex-shrink:0"></span><span class="skl skl-bright" style="width:18px;height:14px;border-radius:50%;flex-shrink:0;margin:0 8px"></span><span class="skl skl-bright" style="width:36px;height:10px;flex-shrink:0"></span><span class="skl skl-bright" style="width:8px;height:12px;flex-shrink:0;margin-left:4px"></span></div>
            </div>

            <div id="ohPager"></div>
        </section>
    </div>

{include file="customer/components/_navbar.tpl"}
{include file="customer/components/_menu_sheet.tpl"}
    <div class="tc" id="toastContainer"></div>

{include file="customer/components/_scripts_common.tpl"}

    <script>
        {literal}
        var ohPage=1,ohHasMore=true,ohLoading=false;
        function loadMore(){
            if(ohLoading||!ohHasMore)return;ohLoading=true;
            var btn=document.getElementById('ohMoreBtn');if(btn)btn.style.display='none';
            var skel='<div class="oh-skel"><span class="skl skl-bright" style="width:40%;height:15px;flex:0 0 auto"></span><span class="skl skl-bright" style="width:60px;height:13px;margin-left:auto;flex-shrink:0"></span><span class="skl skl-bright" style="width:18px;height:14px;border-radius:50%;flex-shrink:0;margin:0 8px"></span><span class="skl skl-bright" style="width:36px;height:10px;flex-shrink:0"></span><span class="skl skl-bright" style="width:8px;height:12px;flex-shrink:0;margin-left:4px"></span></div>';
            document.getElementById('ohList').insertAdjacentHTML('beforeend',skel+skel+skel);
            fetch(appUrl+'/ui/ui_custom/customer/api/order_history.php?page='+ohPage,{credentials:'include'})
            .then(function(r){return r.json()}).then(function(d){
                ohLoading=false;ohHasMore=d.has_more;
                var list=document.getElementById('ohList');
                list.querySelectorAll('.oh-skel').forEach(function(e){e.remove()});
                if(!d.data||!d.data.length)return;
                var h='';d.data.forEach(function(item){
                    var s=item.status===1?'⏳':item.status===2?'✅':'✗';
                    h+='<a href="'+appUrl+'/index.php?_route=order/view/'+item.id+'" class="oh-row stg"><span class="oh-plan">'+item.plan_name+'</span><span class="oh-price">'+item.price_formatted+'</span><span class="oh-status s'+item.status+'">'+s+'</span><span class="oh-date">'+new Date(item.created_date).toLocaleDateString('id-ID',{day:'2-digit',month:'short'})+'</span><i class="bi bi-chevron-right" style="color:var(--t3);font-size:.7rem;flex-shrink:0"></i></a>';
                });
                list.insertAdjacentHTML('beforeend',h);
                document.getElementById('ohPager').innerHTML=ohHasMore?'<button class="vbtn" id="ohMoreBtn" onclick="loadMore()" style="margin-top:16px;background:var(--bgc);color:var(--tx)">Muat Lebih Banyak</button>':'';
                ohPage++;
            }).catch(function(){ohLoading=false;});
        }
        loadMore();
        {/literal}
    </script>
</body>
</html>
