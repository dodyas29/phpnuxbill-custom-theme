{include file="user-ui/header.tpl"}
<!-- user-pages -->

<div class="row">
    <div class="col-md-2"></div>
    <div class="col-md-8">
        <div class="panel mb20 panel-primary panel-hovered">
            <div class="panel-heading">{$payment_name}</div>
            <div class="panel-body">
                {if $qr_string}
                    <div class="panel mb20 panel-primary panel-hovered">
                        <div class="panel-heading">QRIS</div>
                        <div class="panel-body">
                            <center><img src="qrcode/?data={$qr_string}"></center>
                        </div>
                    </div>
                {/if}
                {foreach $instruction $i}
                    <div class="panel mb20 panel-primary panel-hovered">
                        <div class="panel-heading">{$i['title']}</div>
                        <div class="panel-body">
                            <ol>
                                {foreach $i['steps'] $a}
                                    <li>{$a}</li>
                                {/foreach}
                            </ol>
                        </div>
                    </div>
                {/foreach}
            </div>
            <div class="panel-footer">
                <div class="row">
                    <div class="col-md-6">
                        <a href="{$_url}order/view/{$trxid}/check" class="btn btn-success btn-block">sudah bayar? Cek
                            Pembayaran</a>
                    </div>
                    <div class="col-md-6">
                        <a href="{$checkout_url}" class="btn btn-info btn-block">Lihat Halaman Pembayaran</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

{include file="user-ui/footer.tpl"}