{extends tplextends('arkeogis/public')}

{block name='webpage_head' append}
	{js file="/mod/cssjs/js/mootools.more.js"}
	{js file="/mod/cssjs/js/captainhook.js"}
	{js file="/mod/cssjs/js/messageclass.js"}
	{js file="/mod/cssjs/js/message.js"}
	{css file="/mod/cssjs/css/message.css"}
{/block}

{block name='arkeogis_content'}

	<script type="text/javascript">
			window.addEvent('domready', function() {
				 var RecaptchaOptions = {
							theme : 'clean'
				};
				Locale.use('{\mod\lang\Main::getCurrentLang()|replace:'_':'-'}');
			});
	</script>

	{if (empty($config) || empty($config.key))}
		<p class="alert alert-warn">{t d="contactform" m="You have to define your recapcha api key in the contact module interface, default link is /contact/admin."}
	{/if}

	<div style="margin: 40px 0 30px 0">
		Programme INTERREG - ArkeoGIS<br />
		Loup Bernard<br />
		5, allée du Général Rouvillois<br />
		CS 50008<br />
		67083 Strasbourg cedex<br /><br />

		{t d="contactform" m="Tél"} : +33 (0)3 68 85 62 03<br /><br />

		{t d="contactform" m="Mél"} : "Loup Bernard" loup.bernard(at)unistra.fr
	</div>
	{form mod="contactform" file="templates/form.json"}
		<fieldset>

			{if (isset($error) && sizeof($error) > 0)}
				<p class="alert alert-warn">
					{foreach $error as $err}
						{$err}<br />
					{/foreach}
				</p>
			{/if}

			<legend>{t d='contactform' m="Contact form"}</legend>
			<div class="control-group">
				<label class="control-label">{t d="contactform" m="Name"}</label>
				<div class="controls">
				{$formContact.name}
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">{t d="contactform" m="Email"}</label>
				<div class="controls">
					{$formContact.email}
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">{t d="contactform" m="Category"}</label>
				<div class="controls">
					<select name="category">
					{foreach $config.catmails as $cat=>$mails}
						<option value="{$cat}">{$cat}</option>
					{/foreach}
					</select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">{t d="contactform" m="Message"}</label>
				<div class="controls">
					{$formContact.message}
				</div>
			</div>
			<div style="margin-left:160px">
				{$recaptcha}
			</div>
			<script type="text/javascript" src="http://www.google.com/recaptcha/api/challenge?k={$config.key}"></script>
			<div class="form-actions">
					{$formContact.submit}
			</div>
		</fieldset>
	{/form}
{/block}
