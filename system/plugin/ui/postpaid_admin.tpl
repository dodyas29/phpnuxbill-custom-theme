{include file="sections/header.tpl"}

<div class="row">
    <div class="col-md-6">
        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title"><i class="ion-arrow-swap"></i> Postpaid Upgrade Settings</h3>
            </div>
            <div class="box-body">
                <form method="post" action="{$_url}plugin/postpaid_admin">
                    <input type="hidden" name="save" value="yes">
                    <div class="form-group">
                        <label>
                            <input type="checkbox" name="postpaid_upgrade_enable" value="yes" {if $enable=='yes'}checked{/if}>
                            Enable Postpaid Upgrade Page
                        </label>
                    </div>
                    <div class="form-group">
                        <label>
                            <input type="checkbox" name="postpaid_upgrade_only_up" value="yes" {if $only_up=='yes'}checked{/if}>
                            Only allow upgrade (hide downgrade plans)
                        </label>
                        <p class="help-block">If enabled, customers can only see plans with higher price than their current plan.</p>
                    </div>
                    <button type="submit" class="btn btn-primary"><i class="fa fa-save"></i> Save</button>
                </form>
            </div>
        </div>
    </div>
    <div class="col-md-6">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">Info</h3>
            </div>
            <div class="box-body">
                <p>This plugin adds a <b>Package</b> page for customers that supports:</p>
                <ul>
                    <li>Postpaid plan listing &amp; prorated upgrade billing</li>
                    <li>Prepaid/Postpaid offer cards for new users</li>
                    <li>Prorated calculation when upgrading mid-period</li>
                </ul>
                <p class="text-warning">Make sure to update the customer navbar link from <code>?_route=order/package</code> to <code>?_route=plugin/postpaid_page</code></p>
            </div>
        </div>
    </div>
</div>

{include file="sections/footer.tpl"}
