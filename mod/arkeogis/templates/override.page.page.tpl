{extends tplextends('arkeogis/public', 'onajax:page_content')}
{block name='page_menu' append}
	{if $smarty.server.REQUEST_URI != '/page/list/'}
	 <li><a href="/page/edit/{$page.pid}"><i class="icon-edit glyph-white"></i>  Edit</a></li>
	{/if}
{/block}
{block name='arkeogis_content'}
	<div class="page-header" id="page_title">
		{if \mod\user\Main::userHasRight('Manage page')}<a class="float" href="/page/edit/{$page.pid}"><i class="icon-edit"></i></a>{/if}
		<h1>{$page.name}</h1>
	</div>
	<div id="page_rawcontent" class="clearfix">{$page.content}</div>
{/block}

