<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <title>{ucwords(Lang::T($type))} - {$_c['CompanyName']}</title>
    <link rel="shortcut icon" href="{$app_url}/ui/ui/images/logo.png" type="image/x-icon">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="{$app_url}/ui/ui_custom/assets/css/style.css">
    <style>
        {literal}
        *,::before,::after{box-sizing:border-box;margin:0;padding:0}
        body{
            font-family:var(--ff);background:linear-gradient(135deg,#6366f1,#8b5cf6,#0ea5e9);
            min-height:100vh;min-height:100dvh;display:flex;align-items:center;justify-content:center;
            padding:24px;overflow:hidden
        }
        .aw{width:100%;max-width:360px;text-align:center;animation:up .4s ease-out}
        @keyframes up{from{opacity:0;transform:translateY(20px)}to{opacity:1;transform:translateY(0)}}
        .aw-icon{font-size:3rem;margin-bottom:12px;color:#fff}
        .aw-text{font-size:.95rem;font-weight:500;color:rgba(255,255,255,.9);line-height:1.6;margin-bottom:24px}
        .aw-bar{height:4px;background:rgba(255,255,255,.2);border-radius:2px;overflow:hidden;margin-bottom:20px}
        .aw-bar-fill{height:100%;border-radius:2px;width:0%;background:#fff;transition:width 1s linear}
        .aw-btn{display:inline-flex;align-items:center;gap:6px;padding:10px 24px;border-radius:var(--rp);font-size:.8rem;font-weight:600;text-decoration:none;color:#fff;border:1px solid rgba(255,255,255,.25);transition:all .15s;font-family:var(--ff)}
        .aw-btn:hover{background:rgba(255,255,255,.15)}
        .aw-footer{margin-top:32px;font-size:.66rem;color:rgba(255,255,255,.4)}
        {/literal}
    </style>
</head>
<body>
    <div class="aw">
        {if $type == 'success'}
            <i class="bi bi-check-circle-fill aw-icon"></i>
        {elseif $type == 'warning' || $type == 'w'}
            <i class="bi bi-exclamation-triangle-fill aw-icon"></i>
        {elseif $type == 'info'}
            <i class="bi bi-info-circle-fill aw-icon"></i>
        {else}
            <i class="bi bi-x-circle-fill aw-icon"></i>
        {/if}
        <div class="aw-text">{$text}</div>
        <div class="aw-bar"><div class="aw-bar-fill" id="awBar"></div></div>
        <a href="{$url}" class="aw-btn">{Lang::T('Click Here')} <span id="awCount">({$time})</span> <i class="bi bi-arrow-right"></i></a>
        <div class="aw-footer">{$_c['CompanyName']}</div>
    </div>

    <script>
        var t={$time};
        var bar=document.getElementById('awBar');
        function tick(){
            t--;
            document.getElementById('awCount').textContent='('+t+')';
            bar.style.width=Math.min(100,(({$time}-t)/{$time})*100)+'%';
            if(t>=0)setTimeout(tick,1000);
            else window.location.href='{$url}';
        }
        tick();
    </script>
</body>
</html>
