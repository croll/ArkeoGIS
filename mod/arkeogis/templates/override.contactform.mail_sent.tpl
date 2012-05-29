{extends tplextends('arkeogis/layout')}

{block name='arkeogis_content'}
	<div style="width: 340px;margin: 200px auto">
	{if $mailsent}
		<div class="alert alert-success">
		{t d="contactform" m="Mail sent"}
		</div>
	{else}
		<div class="alert alert-danger">
		{t d="contactform" m="Error sending mail"}
		</div>
	{/if}
	</div>
{/block}
