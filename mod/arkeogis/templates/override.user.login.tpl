{extends tplextends('webpage/webpage_main')}

{block name='webpage_head' append}
	{css file='/mod/user/css/login.css'}
	{if isset($url_redirect)}
		<meta http-equiv="Refresh" content="2; url={$url_redirect}/" />
	{/if}
{/block}

{block name='webpage_body'}
  {if isset($loginform)}
		<fieldset>
			<legend>Identification</legend>
			<div><img src="/mod/arkeogis/img/logo.png" /></div>
			{if isset($login_failed)}
				<div id="message">{l s='Identification invalide'}</div>
			{/if}	
			{$loginform}
		</fieldset>
	{else}
		{if isset($login_ok)}
			{l s='Identification réussie, redirection...'}
		{elseif isset($logout)}
			{l s='Déconnexion réussie, redirection...'}
		{else}
			{l s='Vous êtes déjà identifié, redirection...'}
		{/if}
	{/if}	
{/block}
