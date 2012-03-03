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
						<li><a href="/page/logiciel">{t d='arkeogis' m='Logiciel'}</a></li>
						<li><a href="/page/code_source">Code source</a></li>
							
					</ul>
					<ul class="nav pull-right">
						{if \mod\user\Main::userhasRight('Manage rights') }
						<li class="dropdown" onclick="this.toggleClass('open');">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown">ArkeoGIS<b class="caret"></b></a>
							<ul class="dropdown-menu">
								{block name='arkeo_menu' }
									<li><a class="top-btn" href="/"><i class="icon-th-list glyph-white"></i>  {t d='arkeogis' m='Recherche cartographique'}</a></li>
									<li><a class="top-btn" href="/import/"><i class="icon-pencil glyph-white"></i>  {t d='arkeogis' m='Import'}</a></li>
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
         							<li><a  onclick="switchLang('fr_FR');" href="#"><i class="flag fr_FR"></i>{t d='lang' m='French'}    {if $lang == "fr_FR"}<i class="icon-ok"></i>{/if}</a></li>
               							<li><a  onclick="switchLang('de_DE');" href="#"><i class="flag de_DE"></i>{t d='lang' m='Deutsch'}    {if $lang == "de_DE"}<i class="icon-ok"></i>{/if}</a></li>
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
	<div id="public">
		<ul id="public_tabs" class="tabs">
			<li class="tab active"><a href="#">{t d='arkeogis' m='Présentation'}</a></li>	
			<li class="tab"><a href="#">{t d='arkeogis' m='Exemples'}</a></li>	
			<li class="tab"><a href="#">{t d='arkeogis' m='Manuel utilisateur'}</a></li>	
		</ul>
		<div id="presentation" class="content active">
				{if \mod\user\Main::userHasRight('Manage page') }
					<a href="/page/edit/{$present.pid}"class="float"><i class="icon-edit"></i></a>
				{/if}
				<div>{$present.content}</div>
		</div>
		<div id="exemples" class="content">
			<div class="navbar"><div class="navbar-inner"><div class="container">
				<ul id="slider-menu" class="nav nav-pills nav-stacked">
					<li ><a data-update="request" class="success" href="page/requetes">{t d='arkeogis' m='Requêtes'}<i></i></a></li>
					<li ><a  data-update="maps" class="primary" href="page/cartes">{t d='arkeogis' m='Cartes'}</a></li>
					<li ><a  data-update="fiche" class="primary" href="page/fiche_site">{t d='arkeogis' m='Fiche site'}</a></li>
				</ul>
			</div></div></div>
			<div id="slider-component" >
				<div id="request" class="row selected">
					<h2>{t d='arkeogis' m='Requêtes'}</h2>
					<img src="/mod/arkeogis/img/slide/requete.jpg" />
				</div>
				<div id="maps" class="row">
					<h2>{t d='arkeogis' m='Maps'}</h2>
					<img src="/mod/arkeogis/img/slide/maps.jpg" />
				</div>
				<div id="fiche" class="row">
					<h2>{t d='arkeogis' m='Fiche'}</h2>
					<img src="/mod/arkeogis/img/slide/fiche.jpg" />
				</div>
			</div>
		</div>
		<div id="manual" class="content">
			<div class="navbar"><div class="navbar-inner"><div class="container">
			<ul id="manual-menu" class="nav nav-pills nav-stacked">
				<li><a class="primary selected" href="manuel_requetes">{t d='arkeogis' m='Requêtes'}</a></li>
				<li><a class="primary" href="manuel_cartes">{t d='arkeogis' m='Cartes'}</a></li>
				<li><a class="primary" href="manuel_fiches">{t d='arkeogis' m='Fiches'}</a></li>
				<li><a class="primary" href="manuel_import">{t d='arkeogis' m='Import'}</a></li>
			</ul>
			</div></div></div>
			<div id="content"></div>
		</div>
	</div>
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
var mytab = new TabPane('public');
{literal}
function switchLang(newlang)  {
	var myswitch = new Request.JSON({
		'url': '/ajax/call/lang/setCurrentLang',
		'onSuccess': function(resJSON, resText) {
				console.log('toto');	
		}
	}).get({'lang': {/literal}newlang{literal}});
	console.log(newlang);
}
{/literal}
</script>
{/block}
