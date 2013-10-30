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

		<div class="hero-unit" style='padding-left: 20px; padding-right: 20px'>
			<img src="mod/arkeogis/img/logo.png" alt="ArkeoGIS" style="margin: -30px 0 20px 15px"/>
                        <div class="login-toptxt" style="text-align: justify">
                             {t d='arkeogis' m='login_top_txt'}
                        </div>
			<fieldset style='padding-left: 40px;
			margin-top: 20px'>
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
			</fieldset>

                                <div style="width: 300px; margin-top: 20px">
                                        <div class='login-stats'
                                        style='float: left; width:
                                        200px; text-align: right;
                                        background-color: white'>
                                             {assign var="stats" value=\mod\arkeogis\ArkeoGIS::getStats()}
                                             {t d='arkeogis' m='Le %s sont consultables %d bases de données %d sites' p=[$stats.date, $stats.count_db, $stats.count_site]}
                                        </div>
                                        <div style="float: right;
                                        width: 95px; margin-top:10px;
                                        text-align: right">
					     <input type="submit" value="{t d='user' m="Connexion"}" class="btn btn-primary"?>
				        </div>

                                        <div style="clear: both;"></div>
                                </div>

                        <div class='login-bottomtxt'
                                style="margin-top: 10px; text-align: justify">
                                {t d='arkeogis' m='login_bottom_txt'}
                        </div>
                        <br />
                        <div class='login-bottomtxt2' style="margin-top: 10px text-align: justify">
                                {t d='arkeogis' m='login_bottom2_txt'}
                        </div>

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
			{t d='user' m="Login successful, redirecting..."}
			</div>
		{elseif isset($logout)}
			<div class="alert alert-success">
			{t d='user' m="Logout ok, redirecting..."}
			</div>
		{else}
			<div class="alert alert-warning">
			{t d='user' m="You are already identified, redirecting..."}
			</div>
		{/if}
	{/if}
	</div>
{/block}
