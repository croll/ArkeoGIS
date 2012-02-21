{extends tplextends('webpage/webpage_main')}

{block name='webpage_head' append}
	{js file="/mod/cssjs/js/mootools.js"}
	{js file="/mod/cssjs/js/mootools.more.js"}
	{css file="/mod/cssjs/ext/twitter-bootstrap/css/bootstrap.css"}
	{css file="/mod/cssjs/ext/twitter-bootstrap/css/bootstrap-responsive.css"}
	{css file="/mod/arkeogis/css/arkeogis.css"}
{/block}

{block name='webpage_body'}
	<div class="navbar navbar-fixed-top">
		<div class="navbar-inner">
			<div class="container">
				<div class="nav-collapse">
					<ul class="nav">
						<li><a href="/">Recherche cartographique</a></li>
						<li class="dropdown" onclick="this.toggleClass('open');">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown">Page<b class="caret"></b></a>
							<ul class="dropdown-menu">
								{block name='page_menu' }
									<li><a class="top-btn" href="/page/list/"><i class="icon-th-list glyph-white"></i>  List</a></li>
									<li><a class="top-btn" href="/page/edit/0"><i class="icon-pencil glyph-white"></i>  Add</a></li>
								{/block}
							</ul>
						</li>
						<li><a href="/import/file/example4.csv">Test import</a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>

	<div id="content">
		{block name='arkeogis_content'}
		{/block}
	</div>
{/block}
