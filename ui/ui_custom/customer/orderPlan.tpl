<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
{include file="customer/components/_head_common.tpl"}
</head>
<body>
{include file="customer/components/_header.tpl"}

    <div class="cw">
        {if isset($notify)}<meta id="notify-data" data-msg="{$notify|escape}" data-type="{if $notify_t == 's'}success{else}error{/if}">{/if}

        {if Lang::arrayCount($radius_pppoe)>0 || Lang::arrayCount($radius_hotspot)>0}
        <section>
            <div class="sh stg"><h2>{if $_c['radius_plan']}{$_c['radius_plan']}{else}Radius Plans{/if}</h2></div>
            <div class="pl-list stg">
                {foreach $radius_pppoe as $plan}
                    <div class="pl-card">
                        <div class="pl-card-name">{$plan['name_plan']}</div>
                        <div class="pl-card-meta">
                            <span><i class="bi bi-router"></i> {$plan['type']}</span>
                            {if $_c['show_bandwidth_plan'] == 'yes'}<span><i class="bi bi-speedometer2"></i> <b api-get-text="{Text::url('autoload_user/bw_name/')}{$plan['id_bw']}"></b></span>{/if}
                            <span><i class="bi bi-clock"></i> {$plan['validity']} {$plan['validity_unit']}</span>
                        </div>
                        <div class="pl-card-row">
                            <div class="pl-card-price">
                                {if !empty($plan['price_old'])}<span class="pl-card-old">{Lang::moneyFormat($plan['price_old'])}</span>{/if}
                                {Lang::moneyFormat($plan['price'])}
                            </div>
                            <a href="javascript:void(0)" class="tx-act pay" onclick="openPackageModal({$plan['id']},'radius')">{Lang::T('Buy')}</a>
                        </div>
                    </div>
                {/foreach}
                {foreach $radius_hotspot as $plan}
                    <div class="pl-card">
                        <div class="pl-card-name">{$plan['name_plan']}</div>
                        <div class="pl-card-meta">
                            <span><i class="bi bi-router"></i> {$plan['type']}</span>
                            {if $_c['show_bandwidth_plan'] == 'yes'}<span><i class="bi bi-speedometer2"></i> <b api-get-text="{Text::url('autoload_user/bw_name/')}{$plan['id_bw']}"></b></span>{/if}
                            <span><i class="bi bi-clock"></i> {$plan['validity']} {$plan['validity_unit']}</span>
                        </div>
                        <div class="pl-card-row">
                            <div class="pl-card-price">
                                {if !empty($plan['price_old'])}<span class="pl-card-old">{Lang::moneyFormat($plan['price_old'])}</span>{/if}
                                {Lang::moneyFormat($plan['price'])}
                            </div>
                            <a href="javascript:void(0)" class="tx-act pay" onclick="openPackageModal({$plan['id']},'radius')">{Lang::T('Buy')}</a>
                        </div>
                    </div>
                {/foreach}
            </div>
        </section>
        {/if}

        {foreach $routers as $router}
            {assign var="hasPlans" value=false}
            {foreach $plans_hotspot as $p}{if $router['id'] eq $p['routers']}{assign var="hasPlans" value=true}{/if}{/foreach}
            {foreach $plans_pppoe as $p}{if $router['id'] eq $p['routers']}{assign var="hasPlans" value=true}{/if}{/foreach}
            {if isset($plans_vpn)}{foreach $plans_vpn as $p}{if $router['id'] eq $p['routers']}{assign var="hasPlans" value=true}{/if}{/foreach}{/if}

            {if $hasPlans}
            <section>
                <div class="sh stg"><h2>{$router['name']}</h2></div>
                <div class="pl-list stg">
                    {foreach $plans_hotspot as $plan}
                        {if $router['name'] eq $plan['routers']}
                            <div class="pl-card">
                                <div class="pl-card-name">{$plan['name_plan']}</div>
                                <div class="pl-card-meta">
                                    <span><i class="bi bi-router"></i> {if $_c['hotspot_plan']}{$_c['hotspot_plan']}{else}Hotspot{/if}</span>
                                    {if $_c['show_bandwidth_plan'] == 'yes'}<span><i class="bi bi-speedometer2"></i> <b api-get-text="{Text::url('autoload_user/bw_name/')}{$plan['id_bw']}"></b></span>{/if}
                                    <span><i class="bi bi-clock"></i> {$plan['validity']} {$plan['validity_unit']}</span>
                                </div>
                                <div class="pl-card-row">
                                    <div class="pl-card-price">
                                        {if !empty($plan['price_old'])}<span class="pl-card-old">{Lang::moneyFormat($plan['price_old'])}</span>{/if}
                                        {Lang::moneyFormat($plan['price'])}
                                    </div>
                                    <a href="javascript:void(0)" class="tx-act pay" onclick="openPackageModal({$plan['id']},'{$plan['routers']}')">{Lang::T('Buy')}</a>
                                </div>
                            </div>
                        {/if}
                    {/foreach}
                    {foreach $plans_pppoe as $plan}
                        {if $router['name'] eq $plan['routers']}
                            <div class="pl-card">
                                <div class="pl-card-name">{$plan['name_plan']}</div>
                                <div class="pl-card-meta">
                                    <span><i class="bi bi-router"></i> {if $_c['pppoe_plan']}{$_c['pppoe_plan']}{else}PPPoE{/if}</span>
                                    {if $_c['show_bandwidth_plan'] == 'yes'}<span><i class="bi bi-speedometer2"></i> <b api-get-text="{Text::url('autoload_user/bw_name/')}{$plan['id_bw']}"></b></span>{/if}
                                    <span><i class="bi bi-clock"></i> {$plan['validity']} {$plan['validity_unit']}</span>
                                </div>
                                <div class="pl-card-row">
                                    <div class="pl-card-price">
                                        {if !empty($plan['price_old'])}<span class="pl-card-old">{Lang::moneyFormat($plan['price_old'])}</span>{/if}
                                        {Lang::moneyFormat($plan['price'])}
                                    </div>
                                    <a href="javascript:void(0)" class="tx-act pay" onclick="openPackageModal({$plan['id']},'{$plan['routers']}')">{Lang::T('Buy')}</a>
                                </div>
                            </div>
                        {/if}
                    {/foreach}
                    {if isset($plans_vpn)}
                        {foreach $plans_vpn as $plan}
                            {if $router['name'] eq $plan['routers']}
                                <div class="pl-card">
                                    <div class="pl-card-name">{$plan['name_plan']}</div>
                                    <div class="pl-card-meta">
                                        <span><i class="bi bi-router"></i> {if $_c['vpn_plan']}{$_c['vpn_plan']}{else}VPN{/if}</span>
                                        {if $_c['show_bandwidth_plan'] == 'yes'}<span><i class="bi bi-speedometer2"></i> <b api-get-text="{Text::url('autoload_user/bw_name/')}{$plan['id_bw']}"></b></span>{/if}
                                        <span><i class="bi bi-clock"></i> {$plan['validity']} {$plan['validity_unit']}</span>
                                    </div>
                                    <div class="pl-card-row">
                                        <div class="pl-card-price">
                                            {if !empty($plan['price_old'])}<span class="pl-card-old">{Lang::moneyFormat($plan['price_old'])}</span>{/if}
                                            {Lang::moneyFormat($plan['price'])}
                                        </div>
                                        <a href="javascript:void(0)" class="tx-act pay" onclick="openPackageModal({$plan['id']},'{$plan['routers']}')">{Lang::T('Buy')}</a>
                                    </div>
                                </div>
                            {/if}
                        {/foreach}
                    {/if}
                </div>
            </section>
            {/if}
        {/foreach}

        {if Lang::arrayCount($radius_pppoe)==0 && Lang::arrayCount($radius_hotspot)==0 && Lang::arrayCount($plans_pppoe)==0 && Lang::arrayCount($plans_hotspot)==0 && empty($plans_vpn)}
            <div class="pc-empty stg">
                <i class="bi bi-inbox" style="font-size:2rem;color:var(--t3);display:block;margin-bottom:8px"></i>
                {Lang::T('No package available')}
            </div>
        {/if}
    </div>

{include file="customer/components/_navbar.tpl"}
{include file="customer/components/_menu_sheet.tpl"}

    <div class="offcanvas offcanvas-bottom os" tabindex="-1" id="packageErrModal">
        <div class="offcanvas-header flex-column"></div>
        <div class="offcanvas-body bem-body">
            <i class="bi bi-x-circle-fill bem-icon"></i>
            <p id="packageErrMsg" class="bem-msg"></p>
            <button class="vbtn bem-btn" onclick="packageErrModalBS.hide()">{Lang::T('Close')}</button>
        </div>
    </div>

    <div class="offcanvas offcanvas-bottom os mod-h" tabindex="-1" id="packageModal">
        <div class="offcanvas-header flex-column"></div>
        <div class="offcanvas-body">
            <div id="packageSkel">
                <div class="rch-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-sm h-sm"></span><i class="skl skl-bright" style="width:18px;height:18px;border-radius:50%;margin-left:auto"></i></div>
                <div class="rch-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-md h-sm"></span><i class="skl skl-bright" style="width:18px;height:18px;border-radius:50%;margin-left:auto"></i></div>
                <div class="rch-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-sm h-sm"></span><i class="skl skl-bright" style="width:18px;height:18px;border-radius:50%;margin-left:auto"></i></div>
                <div class="rch-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-lg h-sm"></span><i class="skl skl-bright" style="width:18px;height:18px;border-radius:50%;margin-left:auto"></i></div>
                <div class="rch-skel"><span class="skl skl-bright" style="width:36px;height:36px;border-radius:8px"></span><span class="skl skl-bright w-sm h-sm"></span><i class="skl skl-bright" style="width:18px;height:18px;border-radius:50%;margin-left:auto"></i></div>
            </div>
            <div id="packageList"></div>
        </div>
    </div>

    <div class="tc" id="toastContainer"></div>

{include file="customer/components/_scripts_common.tpl"}

</body>
</html>
