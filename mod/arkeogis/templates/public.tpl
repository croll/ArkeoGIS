{extends tplextends('arkeogis/layout')}

{block name='webpage_head' append}
	{js file="/mod/cssjs/js/mootools.js"}
	{js file="/mod/cssjs/js/mootools.more.js"}
	{css file="/mod/cssjs/ext/BrowserUpdateWarning/css/BrowserUpdateWarning.css"}
	{js file="/mod/cssjs/ext/BrowserUpdateWarning/BrowserUpdateWarning.js"}
	{js file="/mod/cssjs/js/captainhook.js"}
	{js file="/mod/cssjs/js/chbootstrap.js"}
	{js file="/mod/cssjs/js/tabs.js"}
	{js file="/mod/arkeogis/js/public.js"}
	{css file="/mod/cssjs/ext/twitter-bootstrap/css/bootstrap.css"}
	{css file="/mod/cssjs/css/Modal.css"}
	{css file="/mod/cssjs/css/tabs.css"}
	{css file="/mod/arkeogis/css/arkeogis.css"}
	{css file="/mod/arkeogis/css/public.css"}
	{css file="/mod/arkeogis/css/bootstrap-arkeo.css"}
{/block}

{block name='webpage_body'}
<div id="arkeogis_container" {if !\mod\user\Main::userIsLoggedIn()} style="width: 950px;"{/if}>
	<div id="top_of_page" class="clearfix">
		<div id="arkeologo" onclick="top.document.location.href='/'">
		</div>
		{if \mod\user\Main::userIsLoggedIn()}
		<div id="user_infos">
			{\mod\user\Main::getUserFullName($smarty.session.login)}
		</div>
		{/if}
		<div class="clearfix"></div>
	</div>
	<div class="navbar" id="navbar">
		<div class="navbar-inner">
			<div class="container">
				<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            				<span class="icon-bar"></span>
            				<span class="icon-bar"></span>
            				<span class="icon-bar"></span>
          				</a>
				<div class="nav-collapse collapse">
					<ul class="nav nav-pills nav-stacked">
						<li><a href="/" altlink='/public'>{t d='arkeogis' m='Accueil'}</a></li>
						<li><a href="/page/{\mod\page\Main::getTranslated('partenaires', $lang)}">{t d='arkeogis' m='Partenaires'}</a></li>
						<li><a href="/page/{\mod\page\Main::getTranslated('historique', $lang)}">{t d='arkeogis' m='Historique'}</a></li>
						<li><a href="/page/{\mod\page\Main::getTranslated('documentation', $lang)}">{t d='arkeogis' m='Documents'}</a></li>
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
            						{if \mod\user\Main::userIsLoggedIn()}
							<li class="dropdown" id="li4" onclick="$('li4').toggleClass('open');">
              							<a href="#" class="dropdown-toggle" data-toggle="dropdown"><img src="/mod/arkeogis/img/settings.png" /><b class="caret"></b></a>
              							<ul id="tools" class="dropdown-menu">	
								<li><a href="/databases/">{t d='arkeogis' m='Index'}</a></li>
								<li><a href="/directory/">{t d='arkeogis' m='Directory'}</a></li>
              							{if \mod\user\Main::userhasRight('Manage personal database') || \mod\user\Main::userhasRight('Manage all databases')}
									<li><a href="/import/">{t d='arkeogis' m='Import'}</a></li>
								{/if}
								{if \mod\user\Main::userhasRight('Manage rights') }
									{block name='user_menu' }
										<li><a class="top-btn" href="/user/"><i class="icon-th-list glyph-white"></i>{t d='user' m='Manage users'}</a></li>
										<li><a class="top-btn" href="/useredit/0"><i class="icon-user glyph-white"></i>{t d='user' m='Add user'}</a></li>
									{/block}
									{/if}
									{if \mod\user\Main::userhasRight('Manage page') }
									{block name='page_menu' }
										<li><a class="top-btn" href="/page/list/"><i class="icon-th-list glyph-white"></i>  {t d='page' m='Manage pages'}</a></li>
										<li><a class="top-btn" href="/page/edit/0"><i class="icon-pencil glyph-white"></i>  {t d='page' m='Add page'}</a></li>
									{/block}	
								{/if}
              							</ul>
						{/if}
            						</li>
							<li class="dropdown" id="li3" onclick="$('li3').toggleClass('open');">
              							<a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="flag {$lang}"></i><b class="caret"></b></a>
              							<ul id="switchlang" class="dropdown-menu">
                							<li><a  onclick="ch_setlang('fr_FR');" href="#"><i class="flag fr_FR"></i>{t d='lang' m='French'}{if $lang == "fr_FR"}<i class="icon-ok"></i>{/if}</a></li>
                							<li><a  onclick="ch_setlang('de_DE');" href="#"><i class="flag de_DE"></i>{t d='lang' m='Deutsch'}{if $lang == "de_DE"}<i class="icon-ok"></i>{/if}</a></li>
              							</ul>
            						</li>
            						{if \mod\user\Main::userIsLoggedIn()}
            						           	<li style="margin-right: -20px"><a href="/logout">{t d='user' m='Logout'}</a></li>
						{else}
           							<li style="margin-right: -20px"><a href="/login">{t d='arkeogis' m='Login'}</a></li>
						{/if}
            						<li><a></a></li>
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
							<li style="margin:11px 12px 0px 0px;font-weight: bold;color : #999; text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.25);">ArkeoGIS {$smarty.now|date_format:"%Y"}</li>
							<li><a href="/page/mentions_legales">{t d='arkeogis' m='Mentions légales'}</a></li>
							<li><a href="/contact">{t d='arkeogis' m='Contact'}</a></li>
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
