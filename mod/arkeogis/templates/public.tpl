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
<div id="arkeogis_container" {if !\mod\user\Main::userIsLoggedIn()} style="width: 950px;"{/if}>
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
						<li><a href="/page/{\mod\page\Main::getTranslated('partenaires', $lang)}">{t d='arkeogis' m='Partenaires'}</a></li>
						<li><a href="/page/{\mod\page\Main::getTranslated('historique', $lang)}">{t d='arkeogis' m='Historique'}</a></li>
						<li><a href="/page/{\mod\page\Main::getTranslated('documentation', $lang)}">{t d='arkeogis' m='Documentation'}</a></li>
						<li><a href="/exemple/">{t d='arkeogis' m='Exemples'}</a></li>
						<li><a href="/page/{\mod\page\Main::getTranslated('logiciel', $lang)}">{t d='arkeogis' m='Logiciel'}</a></li>
						{if \mod\user\Main::userhasRight('View databases') }
							<li><a href="/">{t d='arkeogis' m='Carte'}</a></li>
						{/if}
						<li><a href="/manuel/">{t d='arkeogis' m='Manuel utilisateur'}</a></li>
							
						{if \mod\user\Main::userhasRight('Manage personal database') }
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
						{if \mod\user\Main::userhasRight('Manage rights') }
						<li class="dropdown" onclick="this.toggleClass('open');">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown">{t d='user' m="User"}<b class="caret"></b></a>
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

								{if isset($page_name) }
         							<li><a  onclick="ch_setlang('fr_FR', '/page/{\mod\page\Main::getTranslated($page_name, 'fr_FR')}');" href="#"><i class="flag fr_FR"></i>{t d='lang' m='French'}    {if $lang == "fr_FR"}<i class="icon-ok"></i>{/if}</a></li>
               							<li><a  onclick="ch_setlang('de_DE', '/page/{\mod\page\Main::getTranslated($page_name, 'de_DE')}');" href="#"><i class="flag de_DE"></i>{t d='lang' m='Deutsch'}    {if $lang == "de_DE"}<i class="icon-ok"></i>{/if}</a></li>
								{else}
								<li><a  onclick="ch_setlang('fr_FR', '{$smarty.server.REQUEST_URI}');" href="#"><i class="flag fr_FR"></i>{t d='lang' m='French'}    {if $lang == "fr_FR"}<i class="icon-ok"></i>{/if}</a></li>
               							<li><a  onclick="ch_setlang('de_DE', '{$smarty.server.REQUEST_URI}');" href="#"><i class="flag de_DE"></i>{t d='lang' m='Deutsch'}    {if $lang == "de_DE"}<i class="icon-ok"></i>{/if}</a></li>
	
								{/if}
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
						<ul class="nav pull-right">
							<li><a href="javascript:void(0)">ArkeoGIS 2012</a></li>
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
