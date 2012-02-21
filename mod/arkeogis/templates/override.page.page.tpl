{extends tplextends('arkeogis/layout', 'onajax:page_content')}
{block name='page_menu' append}
	{if $smarty.server.REQUEST_URI != '/page/list/'}
	 <li><a href="/page/edit/{$page.pid}"><i class="icon-edit glyph-white"></i>  Edit</a></li>
	{/if}
{/block}
{block name='arkeogis_content'}
	<div class="page-header" id="page_title">
		<h1>{$page.name}</h1>
		<small>
			Created  {$page.created|date_format: '%d %b %Y'} by {$page.full_name} : last updated - {$page.updated|date_format: '%d %b %Y'}
		</small>
	</div>
	<div id="page_rawcontent">{$page.content}</div>
{/block}

