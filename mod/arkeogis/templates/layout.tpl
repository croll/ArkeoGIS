{extends tplextends('webpage/webpage_main')}

{block name='webpage_head' append}
	{js file="/mod/cssjs/js/mootools.js"}
	{js file="/mod/cssjs/js/mootools.more.js"}
	{css file="/mod/cssjs/ext/BrowserUpdateWarning/css/BrowserUpdateWarning.css"}
	{js file="/mod/cssjs/ext/BrowserUpdateWarning/BrowserUpdateWarning.js"}
	{js file="/mod/cssjs/js/captainhook.js"}
	{js file="/mod/cssjs/js/Modal.js"}
	{js file="/mod/cssjs/js/chtable.js"}
	{js file="/mod/cssjs/js/chfilter.js"}
	{js file="/mod/cssjs/js/chmypaginate.js"}
	{js file="/mod/page/js/page.js"}
	{js file="/mod/arkeogis/js/IdleTracker.js"}
	{js file="/mod/arkeogis/js/public.js"}
	{css file="/mod/cssjs/ext/twitter-bootstrap/css/bootstrap.css"}
	{css file="/mod/arkeogis/css/bootstrap-arkeo.css"}
	{css file="/mod/cssjs/css/mypaginate.css"}
	{css file="/mod/page/css/page.css"}
	{css file="/mod/arkeogis/css/arkeogis.css"}
{/block}

{block name='webpage_head'}
	<meta charset="utf-8">
  <title>ArkeoGIS</title>
  <link rel="shortcut icon" href="/mod/arkeogis/img/favicon.ico" type="image/x-icon" />
  <!--[if lt IE 9]>
    <script src="/mod/cssjs/ext/html5shiv/html5.js"></script>
  <![endif]-->

	<script type="text/javascript">
		var _gaq = _gaq || [];
		_gaq.push(['_setAccount', 'UA-31243555-1']);
		_gaq.push(['_trackPageview']);
		(function() {
			var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
			ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
			var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
		} )();
	</script>
{/block}

{block name='webpage_body'}
       {$lang=\mod\lang\Main::getCurrentLang()}
	<div id="arkeogis_container" {if !\mod\user\Main::userIsLoggedIn()} style="width: 950px;"{/if}>

        <!-- hack idle -->
        <input type='hidden' id='userlogged' value='{\mod\user\Main::userIsLoggedIn()}'/>
        <div id='idlemsg' style='display: none; position: fixed; left:
        0; top: 0; right: 0; bottom: 0; width: 100%; height: 100%;
        z-index: 999999; background: white; text-align: center;
        vertical-align: middle;'>
          <div style='position: absolute; top: 50%; bottom: 50%;
        width: 100%; text-align: center; font-size: 24px'>
	    <img src="/mod/arkeogis/img/logo.png" alt="ArkeoGIS"/>
            <br /><br /><br />
            <div>{t d='arkeogis' m="Vous semblez inactif, vous allez être déconnecté"}</div>
            <br /><br />
            <div id='idlecount'></div></div>
          </div>

		<div id="top_of_page">
			<div id="arkeologo" onclick="top.document.location.href='/'">
			</div>
			<div id="arkeospinner">
				<img id="arkeospinnerimg" src="/mod/arkeogis/img/spinner.gif">
			</div>
			<div id="user_infos">
				{t d='arkeogis' m='Le'} {$smarty.now|date_format:"%d/%m/%Y "} {\mod\user\Main::getUserFullName($smarty.session.login)} {t d='arkeogis' m='peut consulter'}<br />
				{$infos.nbBases} {t d='arkeogis' m='bases de données'}<br />
				{$infos.nbSites} {t d='arkeogis' m='sites'}
			</div>
			<div class="clearfix"></div>
		</div>
		<div class="clearfix"></div>

		<div class="navbar" id="navbar">
			<div class="navbar-inner">
				<div class="container">
					<a class="btn btn-navbar" data-toggle="collapse"
            					<span class="icon-bar"></span>
            					<span class="icon-bar"></span>
            					<span class="icon-bar"></span>
          					</a>
					<div class="nav-collapse collapse" style="height: 0px">
						<ul class="nav">
							<li><a href="/public">{t d='arkeogis' m='Accueil'}</a></li>
							<li><a href="/">{t d='arkeogis' m='Carte'}</a></li>
							<li><a href="/manuel/" target="_blank">{t d='arkeogis' m='Manuel utilisateur'}</a></li>
						</ul>
						<ul class="nav pull-right">
							<li class="dropdown" id="li4" onclick="$('li4').toggleClass('open');">
              							<a href="#" class="dropdown-toggle" data-toggle="dropdown"><img src="/mod/arkeogis/img/settings.png" /><b class="caret"></b></a>
              							<ul id="tools" class="dropdown-menu">
								<li><a href="/databases/"><i class="icon-list glyph-white"></i>  {t d='arkeogis' m='Index'}</a></li>
								<li><a href="/directory/"><i class="icon-book glyph-white"></i> {t d='arkeogis' m='Directory'}</a></li>
              							{if \mod\user\Main::userhasRight('Manage personal database') || \mod\user\Main::userhasRight('Manage all databases')}
									<li><a href="/import/"><i class="icon-upload glyph-white"></i>  {t d='arkeogis' m='Import'}</a></li>
								{/if}
								{if \mod\user\Main::userhasRight('Manage rights') }
									{block name='user_menu' }
										<li><a class="top-btn" href="/user/"><i class="icon-th-list glyph-white"></i>  {t d='user' m='Manage users'}</a></li>
										<li><a class="top-btn" href="/useredit/0"><i class="icon-user glyph-white"></i>  {t d='user' m='Add user'}</a></li>
									{/block}
									{/if}
									{if \mod\user\Main::userhasRight('Manage page') }
									{block name='page_menu' }
										<li><a class="top-btn" href="/page/list/"><i class="icon-th-list glyph-white"></i>  {t d='page' m='Manage pages'}</a></li>
										<li><a class="top-btn" href="/page/edit/0"><i class="icon-pencil glyph-white"></i>  {t d='page' m='Add page'}</a></li>
									{/block}
								{/if}
              							</ul>
            						</li>
							<li class="dropdown" id="li3" onclick="$('li3').toggleClass('open');">
              							<a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="flag {$lang}"></i><b class="caret"></b></a>
              							<ul id="switchlang" class="dropdown-menu">
                							<li><a  onclick="ch_setlang('fr_FR');" href="#"><i class="flag fr_FR"></i>{t d='lang' m='French'}{if $lang == "fr_FR"}<i class="icon-ok"></i>{/if}</a></li>
                							<li><a  onclick="ch_setlang('de_DE');" href="#"><i class="flag de_DE"></i>{t d='lang' m='Deutsch'}{if $lang == "de_DE"}<i class="icon-ok"></i>{/if}</a></li>
              							</ul>
            						</li>
            						<li style="margin-right: -20px"><a href="/logout">{t d='user' m='Logout'}</a></li>
            						<li><a></a></li>
						</ul>
					</div>
				</div>
			</div>
		</div>

		<div id="content">
			{block name='arkeogis_content'}
			{/block}
		</div>

		<div id="footer">
			<div class="navbar">
				<div class="container">
					<div class="nav-collapse">
						<ul class="nav pull-right">
							<li style="margin:11px 12px 0px 0px;font-weight: bold;color : #999; text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.25);">ArkeoGIS {$smarty.now|date_format:"%Y"}</li>
							<li><a href="/page/mentions_legales">{t d='arkeogis' m='Mentions légales'}</a></li>
							<li><a href="/contact">{t d='arkeogis' m='Contact'}</a></li>
						</ul>
					</div>
				</div>
			</div>
		</div>

	</div>
{/block}
