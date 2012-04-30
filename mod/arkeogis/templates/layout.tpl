{extends tplextends('webpage/webpage_main')}

{block name='webpage_head' append}
	{js file="/mod/cssjs/js/mootools.js"}
	{js file="/mod/cssjs/js/mootools.more.js"}
	{js file="/mod/cssjs/js/captainhook.js"}
	{js file="/mod/cssjs/js/Modal.js"}
	{js file="/mod/cssjs/js/chtable.js"}
	{js file="/mod/cssjs/js/chfilter.js"}
	{js file="/mod/cssjs/js/chmypaginate.js"}
	{js file="/mod/page/js/page.js"}
	{js file="/mod/arkeogis/js/public.js"}
	{css file="/mod/cssjs/ext/twitter-bootstrap/css/bootstrap.css"}
	{css file="/mod/cssjs/ext/twitter-bootstrap/css/bootstrap-responsive.css"}
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
	<div id="arkeogis_container" {if !\mod\user\Main::userIsLoggedIn()} style="width: 950px;"{/if}>

		<div id="top_of_page">
			<div id="arkeologo">
			</div>
			<div id="arkeospinner">
				<img id="arkeospinnerimg" src="/mod/arkeogis/img/spinner.gif">
			</div>
			<div class="clearfix"></div>
		</div>

		<div class="navbar">
			<div class="navbar-inner">
				<div class="container">
					<div class="nav-collapse">
						<ul class="nav">
								
							<li><a href="/public">{t d='arkeogis' m='Accueil'}</a></li>

							{if \mod\user\Main::userhasRight('View databases') }
							<li><a href="/">{t d='arkeogis' m='Carte'}</a></li>
							{/if}
							<li><a href="/manuel/" target="_blank">{t d='arkeogis' m='Manuel utilisateur'}</a></li>
								
							{if \mod\user\Main::userhasRight('Manage personal database') || \mod\user\Main::userhasRight('Manage all databases')}
							<li><a href="/import/">{t d='arkeogis' m='Import'}</a></li>
							{/if}
						</ul>
						<ul class="nav pull-right">
							{if \mod\user\Main::userhasRight('Manage page') }
							<li class="dropdown" onclick="this.toggleClass('open');">
								<a href="#" class="dropdown-toggle" data-toggle="dropdown">{t d='page' m='Page'}<b class="caret"></b></a>
								<ul class="dropdown-menu">
									{block name='page_menu' }
										<li><a class="top-btn" href="/page/list/"><i class="icon-th-list glyph-white"></i>  {t d='page' m='List'}</a></li>
										<li><a class="top-btn" href="/page/edit/0"><i class="icon-pencil glyph-white"></i>  {t d='page' m='Add'}</a></li>
									{/block}
								</ul>
							</li>
							{/if}
							<li><a href="/directory/">{t d='arkeogis' m='Directory'}</a></li>
							{if \mod\user\Main::userhasRight('Manage rights') }
							<li class="dropdown" onclick="this.toggleClass('open');">
								<a href="#" class="dropdown-toggle" data-toggle="dropdown">{t d='user' m='User'}<b class="caret"></b></a>
								<ul class="dropdown-menu">
									{block name='user_menu' }
										<li><a class="top-btn" href="/user/"><i class="icon-th-list glyph-white"></i>  {t d='user' m='Manage users'}</a></li>
										<li><a class="top-btn" href="/useredit/0"><i class="icon-user glyph-white"></i>  {t d='user' m='Add user'}</a></li>
									{/block}
								</ul>
							</li>
							{/if}
							<li class="dropdown" onclick="this.toggleClass('open');">
              							<a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="flag {$lang}"></i><b class="caret"></b></a>
              							<ul id="switchlang" class="dropdown-menu">
                							<li><a  onclick="ch_setlang('fr_FR');" href="#"><i class="flag fr_FR"></i>{t d='lang' m='French'}    {if $lang == "fr_FR"}<i class="icon-ok"></i>{/if}</a></li>
                							<li><a  onclick="ch_setlang('de_DE');" href="#"><i class="flag de_DE"></i>{t d='lang' m='Deutsch'}    {if $lang == "de_DE"}<i class="icon-ok"></i>{/if}</a></li>
              							</ul>
            						</li>
							{if \mod\user\Main::userIsLoggedIn() }
            						<li><a href="/logout">{t d='user' m='Logout'}</a></li>
            						<li><a>{\mod\user\Main::getUserFullName($smarty.session.login)}</a></li>
							{else}
							<li><a href="/login">{t d='user' m='Login'}</a></li>
          						{/if}
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
							<li><a href="javascript:void(0)">ArkeoGIS 2012</a></li>
							<li><a href="/page/contact">{t d='arkeogis' m='Contact'}</a></li>
						</ul>
					</div>
				</div>
			</div>
		</div>

	</div>
{/block}
