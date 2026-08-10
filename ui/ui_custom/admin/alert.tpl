<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <title>{ucwords(Lang::T($type))} - {$_c['CompanyName']}</title>
    <link rel="shortcut icon" href="{$app_url}/ui/ui/images/logo.png" type="image/x-icon">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        {literal}
        *{box-sizing:border-box;margin:0;padding:0}
        body{
            font-family:'Inter',system-ui,sans-serif;
            background:linear-gradient(135deg,#6366f1,#8b5cf6,#0ea5e9);
            min-height:100vh;min-height:100dvh;
            display:flex;align-items:center;justify-content:center;
            padding:24px
        }
        .c{width:100%;max-width:360px;text-align:center}
        .c-icon{font-size:3rem;color:#fff;margin-bottom:12px}
        .c-text{font-size:.95rem;font-weight:500;color:rgba(255,255,255,.9);line-height:1.6;margin-bottom:24px}
        .c-bar{height:4px;background:rgba(255,255,255,.2);border-radius:2px;overflow:hidden;margin-bottom:20px}
        .c-fill{height:100%;border-radius:2px;width:0;background:#fff;transition:width 1s linear}
        .c-btn{display:inline-flex;align-items:center;gap:6px;padding:10px 24px;border-radius:9999px;font-size:.8rem;font-weight:600;text-decoration:none;color:#fff;border:1px solid rgba(255,255,255,.25)}
        .c-foot{margin-top:32px;font-size:.66rem;color:rgba(255,255,255,.4)}
        {/literal}
    </style>
</head>
<body>
    <div class="c">
        <div class="c-icon">
            {if $type == 'success'}<i class="bi bi-check-circle-fill"></i>
            {elseif $type == 'warning' || $type == 'w'}<i class="bi bi-exclamation-triangle-fill"></i>
            {elseif $type == 'info'}<i class="bi bi-info-circle-fill"></i>
            {else}<i class="bi bi-x-circle-fill"></i>
            {/if}
        </div>
        <div class="c-text">{$text}</div>
        <div class="c-bar"><div class="c-fill" id="b"></div></div>
        <a href="{$url}" class="c-btn">{Lang::T('Click Here')} <span id="n">{$time}</span> <i class="bi bi-arrow-right"></i></a>
        <div class="c-foot">{$_c['CompanyName']}</div>
    </div>
    <script>
        var t={$time},b=document.getElementById('b'),n=document.getElementById('n');
        function i(){t--;if(t>=0){n.textContent=t;b.style.width=(({$time}-t)/{$time}*100)+'%';setTimeout(i,1000)}else location.href='{$url}'}
        i();
    </script>
</body>
</html>
