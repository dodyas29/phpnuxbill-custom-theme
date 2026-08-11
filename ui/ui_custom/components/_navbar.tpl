<nav class="bn">
    <a href="{Text::url('home')}" {if $_system_menu == 'home' || $_system_menu == 'default'}class="active"{/if}><i class="bi bi-house-door-fill"></i><span>{Lang::T('Home')}</span></a>
    <a href="{Text::url('order/package')}" {if $_system_menu == 'order' && $_routes[1] == 'package'}class="active"{/if}><i class="bi bi-cart3"></i><span>{Lang::T('Buy')}</span></a>
    {if $_c['disable_voucher'] != 'yes'}<a href="{Text::url('voucher/activation')}" {if $_system_menu == 'voucher'}class="active"{/if}><i class="bi bi-ticket-perforated"></i><span>{Lang::T('Voucher')}</span></a>{/if}
    <a href="{Text::url('order/history')}" {if $_system_menu == 'order' && $_routes[1] != 'package'}class="active"{/if}><i class="bi bi-clock-history"></i><span>{Lang::T('History')}</span></a>
    <a href="{Text::url('accounts/profile')}" {if $_system_menu == 'accounts'}class="active"{/if}><i class="bi bi-person"></i><span>{Lang::T('Profile')}</span></a>
</nav>
