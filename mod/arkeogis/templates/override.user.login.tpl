{extends tplextends('webpage/webpage_main')}


{block name='webpage_head' append}
	{js file='/mod/cssjs/js/mootools.js'}
	{js file='/mod/cssjs/js/mootools.more.js'}
	{css file='/mod/cssjs/ext/twitter-bootstrap/css/bootstrap.css'}
	{if isset($url_redirect)}
		<meta http-equiv="Refresh" content="2; url={$url_redirect}/" />
	{/if}
{/block}

{block name='webpage_body'}
	<div style="width: 340px;margin: 100px auto">
  {if $displayForm}
		{form mod="user" file="templates/loginForm.json"}

		<div class="hero-unit">
			<img src="mod/arkeogis/img/logo.png" alt="ArkeoGIS" style="margin: -30px 0 20px -20px"/>
			<fieldset>
				{if isset($login_failed)}
					<div class="alert alert-error">{t d='user' m="Identification invalide"}</div>
				{/if}	
				<div>
					<div style="margin-top:5px">
						{$loginForm.login}
					</div>
					<div style="margin-top:5px">
						{$loginForm.password}
					</div>
				</div>
				<div style="margin-top:5px">
					<input type="submit" value="{t d='user' m="Connexion"}" class="btn btn-primary"?>
				</div>
			</fieldset>
		</div>
		<script>
		window.addEvent('domready', function(){
			document.id('loginForm').getElements('[type=text], [type=password]').each(function(el){
				new OverText(el, {
					poll: true
				});
			});
		});
		</script>
		{/form}
	{else}
		{if isset($login_ok)}
			<div class="alert alert-success">
			{l s='Identification réussie, redirection...'}
			</div>
		{elseif isset($logout)}
			<div class="alert alert-success">
			{l s='Déconnexion réussie, redirection...'}
			</div>
		{else}
			<div class="alert alert-warning">
			{l s='Vous êtes déjà identifié, redirection...'}
			</div>
		{/if}
	{/if}	
	</div>
{/block}
