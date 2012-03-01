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
							<li><a href="/">Recherche cartographique</a></li>
							
							<li><a href="/import/">Test import</a></li>
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
