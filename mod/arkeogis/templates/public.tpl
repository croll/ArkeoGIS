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
						<li><a href="/">Accueil</a></li>
						<li><a href="/page/partenaires">Partenaires</a></li>
						<li><a href="/page/historique">Historique</a></li>
						<li><a href="/page/logiciel">Logiciel</a></li>
						<li><a href="/page/code_source">Code source</a></li>
							
					</ul>
					<ul class="nav pull-right">
						{if \mod\user\Main::userhasRight('Manage rights') }
						<li class="dropdown" onclick="this.toggleClass('open');">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown">ArkeoGIS<b class="caret"></b></a>
							<ul class="dropdown-menu">
								{block name='arkeo_menu' }
									<li><a class="top-btn" href="/"><i class="icon-th-list glyph-white"></i>  Recherche cartographique</a></li>
									<li><a class="top-btn" href="/import/"><i class="icon-pencil glyph-white"></i>  Import</a></li>
								{/block}
							</ul>
						</li>
						{/if}
						{if \mod\user\Main::userhasRight('Manage page') }
						<li class="dropdown" onclick="this.toggleClass('open');">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown">Page<b class="caret"></b></a>
							<ul class="dropdown-menu">
								{block name='page_menu' }
									<li><a class="top-btn" href="/page/list/"><i class="icon-th-list glyph-white"></i>  List</a></li>
									<li><a class="top-btn" href="/page/edit/0"><i class="icon-pencil glyph-white"></i>  Add</a></li>
								{/block}
							</ul>
						</li>
						{/if}
						{if \mod\user\Main::userhasRight('Manage rights') }
						<li class="dropdown" onclick="this.toggleClass('open');">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown">User<b class="caret"></b></a>
							<ul class="dropdown-menu">
								{block name='user_menu' }
									<li><a class="top-btn" href="/user/"><i class="icon-th-list glyph-white"></i>  Manage users</a></li>
									<li><a class="top-btn" href="/user/edit/0"><i class="icon-user glyph-white"></i>  Add User</a></li>
								{/block}
							</ul>
						</li>
						{/if}
						<li class="dropdown" onclick="this.toggleClass('open');">
       							<a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="flag {$lang}"></i><b class="caret"></b></a>
       							<ul id="switchlang" class="dropdown-menu">
         							<li><a  onclick="switchLang('fr_FR');" href="#"><i class="flag fr_FR"></i>French    {if $lang == "fr_FR"}<i class="icon-ok"></i>{/if}</a></li>
               							<li><a  onclick="switchLang('de_DE');" href="#"><i class="flag de_DE"></i>Deutsch    {if $lang == "de_DE"}<i class="icon-ok"></i>{/if}</a></li>
       							</ul>
       						</li>
						{if \mod\user\Main::userIsLoggedIn()}
           						<li><a href="/logout">Logout</a></li>
						{else}
           						<li><a href="/login">Login</a></li>
						{/if}
       		        		</ul>
				</div>
			</div>
		</div>
	</div>
	<div id="public">
		<ul id="public_tabs" class="tabs">
			<li class="tab active"><a href="#">Présentation</a></li>	
			<li class="tab"><a href="#">Exemples</a></li>	
			<li class="tab"><a href="#">Manuel utilisateur</a></li>	
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
					<li ><a data-update="request" class="success" href="page/requetes">Requêtes<i></i></a></li>
					<li ><a  data-update="maps" class="primary" href="page/cartes">Cartes</a></li>
					<li ><a  data-update="fiche" class="primary" href="page/fiche_site">Fiche site</a></li>
				</ul>
			</div></div></div>
			<div id="slider-component" >
				<div id="request" class="row selected">
					<h2>Requêtes</h2>
					<img src="/mod/arkeogis/img/slide/requete.jpg" />
				</div>
				<div id="maps" class="row">
					<h2>maps</h2>
					<img src="/mod/arkeogis/img/slide/maps.jpg" />
				</div>
				<div id="fiche" class="row">
					<h2>fiche</h2>
					<img src="/mod/arkeogis/img/slide/fiche.jpg" />
				</div>
			</div>
		</div>
		<div id="manual" class="content">
			<div class="navbar"><div class="navbar-inner"><div class="container">
			<ul id="manual-menu" class="nav nav-pills nav-stacked">
				<li><a class="primary selected" href="manuel_requetes">Requêtes</a></li>
				<li><a class="primary" href="manuel_cartes">Cartes</a></li>
				<li><a class="primary" href="manuel_fiches">Fiches</a></li>
				<li><a class="primary" href="manuel_import">Import</a></li>
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
							<li><a href="/page/credits">Crédits</a></li>
							<li><a href="/page/contact">Contact</a></li>
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
