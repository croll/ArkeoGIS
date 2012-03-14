{extends tplextends('arkeogis/layout')}

{block name='webpage_head' append}
	{js file="/mod/cssjs/js/mootools.js"}
	{js file="/mod/cssjs/js/mootools.more.js"}
	{js file="/mod/cssjs/js/captainhook.js"}
	{js file="/mod/cssjs/js/tabs.js"}
	{js file="/mod/arkeogis/js/public.js"}
	{css file="/mod/cssjs/ext/twitter-bootstrap/css/bootstrap.css"}
	{css file="/mod/cssjs/ext/twitter-bootstrap/css/bootstrap-responsive.css"}
	{css file="/mod/cssjs/css/Modal.css"}
	{css file="/mod/cssjs/css/tabs.css"}
	{css file="/mod/arkeogis/css/arkeogis.css"}
	{css file="/mod/arkeogis/css/public.css"}
{/block}

{block name='webpage_body'}
<div id="arkeogis_container">
	<div id="top_of_page">
		<div id="arkeologo">
		</div>
	</div>
	<div class="navbar">
		<div class="navbar-inner">
			<div class="container">
				<div class="nav-collapse">
					<ul class="nav nav-pills nav-stacked">
						<li><a href="/">{t d='arkeogis' m='Accueil'}</a></li>
						<li><a href="/page/partenaires">{t d='arkeogis' m='Partenaires'}</a></li>
						<li><a href="/page/historique">{t d='arkeogis' m='Historique'}</a></li>
						<li><a href="/page/documentation">{t d='arkeogis' m='Documentation'}</a></li>
						<li><a href="/page/exemples">{t d='arkeogis' m='Exemples'}</a></li>
						<li><a href="/page/logiciel">{t d='arkeogis' m='Logiciel'}</a></li>
						{if \mod\user\Main::userhasRight('View databases') }
							<li><a href="/">{t d='arkeogis' m='Cartographie'}</a></li>
						{/if}
						<li><a href="/page/manuel_utilisateur">{t d='arkeogis' m='Manuel utilisateur'}</a></li>
							
						{if \mod\user\Main::userhasRight('Manage personal database') }
						<li><a href="/import/">{t d='arkeogis' m='Import'}</a></li>
						{/if}
							
					</ul>
					<ul class="nav pull-right">
						{if \mod\user\Main::userhasRight('Manage personal database') }
						<li class="dropdown" onclick="this.toggleClass('open');">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown">ArkeoGIS<b class="caret"></b></a>
							<ul class="dropdown-menu">
								{block name='arkeo_menu' }
									<li><a class="top-btn" href="/"><i class="icon-th-list glyph-white"></i>  {t d='arkeogis' m='Recherche cartographique'}</a></li>
									<li><a class="top-btn" href="/import/"><i class="icon-pencil glyph-white"></i>  {t d='arkeogis' m='Import'}</a></li>
									<li><a href="/directory">{t d='arkeogis' m='Directory'}</a></li>
								{/block}
							</ul>
						</li>
						{/if}
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
						{if \mod\user\Main::userhasRight('Manage rights') }
						<li class="dropdown" onclick="this.toggleClass('open');">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown">{t d='user' m="User"}<b class="caret"></b></a>
							<ul class="dropdown-menu">
								{block name='user_menu' }
									<li><a class="top-btn" href="/user/"><i class="icon-th-list glyph-white"></i>  {t d='user' m='Manage users'}</a></li>
									<li><a class="top-btn" href="/user/edit/0"><i class="icon-user glyph-white"></i>  {t d='user' m='Add user'}</a></li>
								{/block}
							</ul>
						</li>
						{/if}
						<li class="dropdown" onclick="this.toggleClass('open');">
       							<a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="flag {$lang}"></i><b class="caret"></b></a>
       							<ul id="switchlang" class="dropdown-menu">
         							<li><a  onclick="ch_setlang('fr_FR', '/public');" href="#"><i class="flag fr_FR"></i>{t d='lang' m='French'}    {if $lang == "fr_FR"}<i class="icon-ok"></i>{/if}</a></li>
               							<li><a  onclick="ch_setlang('de_DE', '/public');" href="#"><i class="flag de_DE"></i>{t d='lang' m='Deutsch'}    {if $lang == "de_DE"}<i class="icon-ok"></i>{/if}</a></li>
       							</ul>
       						</li>
						{if \mod\user\Main::userIsLoggedIn()}
           						<li><a href="/logout">{t d='arkeogis' m='Logout'}</a></li>
						{else}
           						<li><a href="/login">{t d='arkeogis' m='Login'}</a></li>
						{/if}
       		        		</ul>
				</div>
			</div>
		</div>
	</div>
	{block name='arkeogis_content'}
		<div id="presentation" class="content active">
				{if \mod\user\Main::userHasRight('Manage page') }
					<a href="/page/edit/{$present.pid}"class="float"><i class="icon-edit"></i></a>
				{/if}
				<div>{$present.content}</div>
		</div>
		
	{/block}
	<div id="footer">
		<div class="navbar">
			<div class="navbar">
				<div class="container">
					<div class="nav-collapse">
						<ul class="nav">
							<li>ArkeoGIS 2012</li>
							<li class="divider">&nbsp</li>
							<li>Adress</li>
							<li class="divider">&nbsp</li>
							<li>Email</li>
							<li class="divider">&nbsp</li>
						</ul>
						<ul class="nav pull-right">
							<li><a href="/page/credits">{t d='arkeogis' m='Crédits'}</a></li>
							<li><a href="/page/contact">{t d='arkeogis' m='Contact'}</a></li>
						</ul>
					</div>
				</div>
			</div>
		</div>		
	</div>
</div>
<script>
var mypage= new Page();
var pmod = new Modal.Base(document.body);
</script>
{/block}
