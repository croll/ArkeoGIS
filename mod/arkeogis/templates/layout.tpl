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
	{css file="/mod/cssjs/css/captainhook.css"}
	{css file="/mod/page/css/page.css"}
	{css file="/mod/arkeogis/css/arkeogis.css"}
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
						<ul class="nav">
							<li class="dropdown" onclick="this.toggleClass('open');">
								<a href="#" class="dropdown-toggle" data-toggle="dropdown">ArkeoGIS<b class="caret"></b></a>
								<ul class="dropdown-menu">
								
							<li><a href="/public">Accueil</a></li>
							<li><a href="/page/partenaires">Partenaires</a></li>
							<li><a href="/page/historique">Historique</a></li>
							<li><a href="/page/logiciel">Logiciel</a></li>
							<li><a href="/page/code_source">Code source</a></li>
							</ul></li>
		
							<li><a href="/">Recherche cartographique</a></li>
							
							<li><a href="/import/file/example4.csv">Test import</a></li>
						</ul>
						<ul class="nav pull-right">
							<li class="dropdown" onclick="this.toggleClass('open');">
								<a href="#" class="dropdown-toggle" data-toggle="dropdown">Page<b class="caret"></b></a>
								<ul class="dropdown-menu">
									{block name='page_menu' }
										<li><a class="top-btn" href="/page/list/"><i class="icon-th-list glyph-white"></i>  List</a></li>
										<li><a class="top-btn" href="/page/edit/0"><i class="icon-pencil glyph-white"></i>  Add</a></li>
									{/block}
								</ul>
							</li>
							<li class="dropdown" onclick="this.toggleClass('open');">
								<a href="#" class="dropdown-toggle" data-toggle="dropdown">User<b class="caret"></b></a>
								<ul class="dropdown-menu">
									{block name='user_menu' }
										<li><a class="top-btn" href="/user/"><i class="icon-th-list glyph-white"></i>  Manage users</a></li>
										<li><a class="top-btn" href="/user/edit/0"><i class="icon-user glyph-white"></i>  Add User</a></li>
									{/block}
								</ul>
							</li>
							<li class="dropdown" onclick="this.toggleClass('open');">
              							<a href="#" class="dropdown-toggle" data-toggle="dropdown">Lang<b class="caret"></b></a>
              							<ul class="dropdown-menu">
                							<li><a  onclick="switchLang('fr_FR');" href="#"><i class="flag fr_FR"></i>French</a></li>
                							<li><a  onclick="switchLang('de_DE');" href="#"><i class="flag de_DE"></i>Deutch</a></li>
 					
              							</ul>
            						</li>
            						<li><a href="/logout">Logout</a></li>
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
			ArkeoGIS 2012
		</div>

	</div>
{/block}
