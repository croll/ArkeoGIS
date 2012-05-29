{extends tplextends('arkeogis/layout')}

{block name='webpage_head' append}
	{js file="/mod/cssjs/js/mootools.more.js"}
	{js file="/mod/cssjs/js/captainhook.js"}
	{js file="/mod/cssjs/js/messageclass.js"}
	{js file="/mod/cssjs/js/message.js"}
	{css file="/mod/cssjs/css/message.css"}
	{js file="/mod/contactform/js/form.js"}
	{js file="/mod/contactform/js/admin.js"}
{/block}

{block name='arkeogis_content'}

	<script>
		var config={$config|json_encode};
	</script>
	
	<h4 style="margin:20px 0 0 0">{t d="contactform" m="Configuration"}</h4>

	<fieldset>
		<div class="control-group" style="margin-top:10px">
			<label class="control-label">{t d="contactform" m="Recaptcha Public Key"}</label>
			<div class="controls">
				<input type="text" class="input-xlarge" id="apikey" value="{if isset($config.key)}{$config.key}{/if}" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">{t d="contactform" m="Recaptcha Private Key"}</label>
			<div class="controls">
				<input type="text" class="input-xlarge" id="privateKey" value="{if isset($config.privateKey)}{$config.privateKey}{/if}" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">{t d="contactform" m="Mail subject"}</label>
			<div class="controls">
				<input type="text" class="input-xlarge" id="mailSubject" value="{if isset($config.mailSubject)}{$config.mailSubject}{/if}" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">{t d="contactform" m="Mail address for sender"}</label>
			<div class="controls">
				<input type="text" class="input-xlarge" id="sender" value="{if isset($config.sender)}{$config.sender}{/if}" />
			</div>
		</div>
		<input type="button" onclick="CaptainHook.Contact.Admin.update()" value="{t d="contactform" m="Update"}" />
	</fieldset>

	<h4 style="margin:20px 0 10px 0">{t d="contactform" m="Categories"}</h4>
	<div id="categories">
		<input type="text" id="newcategory" value="" />
		<input type="button" onclick="CaptainHook.Contact.Admin.addCategory()" value="{t d="contactform" m="Add"}" />
		{if isset($config.categories) && is_array($config.categories) && $config.categories > 0}
			{foreach $config.categories as $name=>$mails}
				<fieldset style="margin: 20px 0 20px 0">
					<legend rel="{$name}">{$name} [<a href="javascript:void(0)" onclick="CaptainHook.Contact.Admin.deleteCategory(this)">x</a>]</legend>
					<div class="mailList">
						{foreach $mails as $mail}
							<div>
								<span>{$mail}</span>
								<input type="button" onclick="CaptainHook.Contact.Admin.deleteMail(this)" value="{t d="contactform" m="Del"}" />
							</div>
						{/foreach}
					</div>
					<input type="text" />
					<input type="button" onclick="CaptainHook.Contact.Admin.addMail(this)" value="{t d="contactform" m="Add"}" />
					<br />
					
				</fieldset>
			{/foreach}
		{/if}
	</div>

{/block}
