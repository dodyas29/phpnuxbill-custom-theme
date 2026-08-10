<nav class="bn">
    <a href="{Text::url('home')}" class="active"><i class="bi bi-house-door-fill"></i><span>{Lang::T('Home')}</span></a>
    <a href="{Text::url('order/package')}"><i class="bi bi-cart3"></i><span>{Lang::T('Buy')}</span></a>
    {if $_c['disable_voucher'] != 'yes'}<a href="{Text::url('voucher/activation')}"><i class="bi bi-ticket-perforated"></i><span>{Lang::T('Voucher')}</span></a>{/if}
    <a href="{Text::url('order/history')}"><i class="bi bi-clock-history"></i><span>{Lang::T('History')}</span></a>
    <a href="{Text::url('accounts/profile')}"><i class="bi bi-person"></i><span>{Lang::T('Profile')}</span></a>
</nav>
