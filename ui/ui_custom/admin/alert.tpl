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
    <link rel="stylesheet" href="{$app_url}/ui/ui_custom/assets/css/style.css">
    <style>
        *,::before,::after{box-sizing:border-box;margin:0;padding:0}
        body{
            font-family:var(--ff);background:var(--bg);color:var(--tx);
            min-height:100vh;min-height:100dvh;display:flex;align-items:center;justify-content:center;
            padding:24px;overflow:hidden
        }
        .aw{width:100%;max-width:360px;text-align:center;animation:up .4s ease-out}
        @keyframes up{from{opacity:0;transform:translateY(20px)}to{opacity:1;transform:translateY(0)}}
        .aw-icon{font-size:3rem;margin-bottom:12px}
        .aw-icon.success{color:var(--c4)}
        .aw-icon.error{color:var(--c6)}
        .aw-icon.warning{color:var(--c5)}
        .aw-icon.info{color:var(--c3)}
        .aw-text{font-size:.95rem;font-weight:500;color:var(--tx);line-height:1.6;margin-bottom:24px}
        .aw-bar{height:4px;background:var(--bgc);border-radius:2px;overflow:hidden;margin-bottom:20px}
        .aw-bar-fill{height:100%;border-radius:2px;background:var(--c1);animation:shrink {$time}s linear forwards}
        @keyframes shrink{from{width:100%}to{width:0%}}
        .aw-btn{display:inline-flex;align-items:center;gap:6px;padding:10px 24px;border-radius:var(--rp);font-size:.8rem;font-weight:600;text-decoration:none;color:var(--tx);border:1px solid var(--bd);transition:all .15s;font-family:var(--ff)}
        .aw-btn:hover{background:var(--bgc);border-color:var(--c1);color:var(--c1)}
        .aw-footer{margin-top:32px;font-size:.66rem;color:var(--t3)}
    </style>
</head>
<body>
    <div class="aw">
        {if $type == 'success'}
            <i class="bi bi-check-circle-fill aw-icon success"></i>
        {elseif $type == 'warning' || $type == 'w'}
            <i class="bi bi-exclamation-triangle-fill aw-icon warning"></i>
        {elseif $type == 'info'}
            <i class="bi bi-info-circle-fill aw-icon info"></i>
        {else}
            <i class="bi bi-x-circle-fill aw-icon error"></i>
        {/if}
        <div class="aw-text">{$text}</div>
        <div class="aw-bar"><div class="aw-bar-fill"></div></div>
        <a href="{$url}" class="aw-btn">{Lang::T('Click Here')} <span id="awCount">({$time})</span> <i class="bi bi-arrow-right"></i></a>
        <div class="aw-footer">{$_c['CompanyName']}</div>
    </div>

    <script>
        var t={$time};
        function tick(){t--;if(t>=0){document.getElementById('awCount').textContent='('+t+')';setTimeout(tick,1000)}else{window.location.href='{$url}'}}
        tick();
    </script>
</body>
</html>
