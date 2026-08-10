<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{$_c['CompanyName']}</title>
    <meta http-equiv="refresh" content="{$time}; url={$url}">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        {literal}
        body{font-family:system-ui,sans-serif;background:linear-gradient(135deg,#6366f1,#8b5cf6,#0ea5e9);color:#fff;min-height:100vh;display:flex;align-items:center;justify-content:center;text-align:center;padding:24px;margin:0}
        i{font-size:3rem;display:block;margin-bottom:12px}
        p{font-size:.95rem;opacity:.9;margin-bottom:20px}
        a{color:#fff;text-decoration:none;border:1px solid rgba(255,255,255,.25);padding:10px 24px;border-radius:9999px;font-size:.8rem;font-weight:600}
        small{display:block;margin-top:32px;font-size:.7rem;opacity:.4}
        {/literal}
    </style>
</head>
<body>
    <div>
        {if $type == 'success'}<i class="bi bi-check-circle-fill"></i>
        {elseif $type == 'warning' || $type == 'w'}<i class="bi bi-exclamation-triangle-fill"></i>
        {else}<i class="bi bi-x-circle-fill"></i>
        {/if}
        <p>{$text}</p>
        <a href="{$url}">{Lang::T('Click Here')} <span id="c">{$time}</span></a>
        <small>{$_c['CompanyName']}</small>
    </div>
    <script>
        {literal}
        var t={/literal}{$time}{literal},el=document.getElementById('c');
        setInterval(function(){t--;if(t>=0)el.textContent=t;else location.href='{/literal}{$url}{literal}'},1000);
        {/literal}
    </script>
</body>
</html>
