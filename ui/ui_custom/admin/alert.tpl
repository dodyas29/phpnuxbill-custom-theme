<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <meta http-equiv="refresh" content="{$time}; url={$url}">
    <title>{ucwords(Lang::T($type))} - {$_c['CompanyName']}</title>
    <link rel="shortcut icon" href="{$app_url}/ui/ui/images/logo.png" type="image/x-icon">
    <style>
        {literal}
        *,::before,::after{box-sizing:border-box;margin:0;padding:0}
        body{
            font-family:system-ui,-apple-system,'Segoe UI',Roboto,sans-serif;
            background:linear-gradient(135deg,#6366f1,#8b5cf6,#0ea5e9);
            color:#fff;
            min-height:100vh;min-height:100dvh;
            display:flex;flex-direction:column;align-items:center;justify-content:center;
            padding:24px;text-align:center
        }
        svg{margin-bottom:16px}
        h1{font-size:1.3rem;font-weight:700;letter-spacing:-.3px;margin-bottom:20px}
        .msg{font-size:.9rem;font-weight:500;opacity:.85;margin-bottom:28px;max-width:300px;line-height:1.5}
        .dots{display:flex;gap:8px;margin-bottom:36px}
        .dots span{width:10px;height:10px;border-radius:50%;background:rgba(255,255,255,.5);animation:bounce .6s infinite alternate}
        .dots span:nth-child(2){animation-delay:.2s}.dots span:nth-child(3){animation-delay:.4s}
        @keyframes bounce{to{transform:translateY(-8px);opacity:1}}
        .btn{display:inline-block;padding:10px 28px;border-radius:9999px;background:rgba(255,255,255,.15);color:#fff;text-decoration:none;font-size:.82rem;font-weight:600;border:1px solid rgba(255,255,255,.2);transition:all .15s}
        .btn:hover{background:rgba(255,255,255,.25)}
        .footer{margin-top:40px;font-size:.7rem;opacity:.4}
        {/literal}
    </style>
</head>
<body>
    <svg viewBox="0 0 80 80" fill="none" xmlns="http://www.w3.org/2000/svg" width="80" height="80">
        <rect width="80" height="80" rx="20" fill="url(#ag)"/>
        <path d="M56 40h-6m6 0a12 12 0 00-12-12m12 12a20 20 0 00-20-20m20 20a28 28 0 00-28-28" stroke="#fff" stroke-width="3" stroke-linecap="round" opacity=".9"/>
        <circle cx="40" cy="40" r="5" fill="#fff"/>
        <defs><linearGradient id="ag" x1="0" y1="0" x2="80" y2="80"><stop stop-color="#fff"/><stop offset="1" stop-color="rgba(255,255,255,.4)"/></linearGradient></defs>
    </svg>
    <h1>{$_c['CompanyName']}</h1>
    <div class="msg">{$text}</div>
    <div class="dots"><span></span><span></span><span></span></div>
    <a href="{$url}" class="btn">{Lang::T('Click Here')} (<span id="c">{$time}</span>)</a>
    <div class="footer">{$_c['CompanyName']}</div>

    <script>
        var t={$time};
        var el=document.getElementById('c');
        setInterval(function(){t--;if(t>=0)el.textContent=t;else window.location.href='{$url}'},1000);
    </script>
</body>
</html>
