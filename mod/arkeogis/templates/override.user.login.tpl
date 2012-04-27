{extends tplextends('webpage/webpage_main')}

{block name='webpage_head' append}
	{css file='/mod/cssjs/ext/twitter-bootstrap/css/bootstrap.css'}
	{if isset($url_redirect)}
		<meta http-equiv="Refresh" content="2; url={$url_redirect}/" />
	{/if}
{/block}

{block name='webpage_body'}
	<div style="width: 340px;margin: 200px auto">
  {if isset($loginform)}
		{if isset($login_failed)}
			<div class="alert alert-warning">
				{l s='Identification invalide'}
			</div>
		{/if}	
		<div class="hero-unit">
			<legend><h2>ArkeoGIS</h2></legend>
			<div style="width:320px;margin: 0 auto">
				{$loginform}
			<div>
		</di>
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
