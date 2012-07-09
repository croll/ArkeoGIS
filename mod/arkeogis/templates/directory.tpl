{extends tplextends('arkeogis/layout')}
{block name='webpage_head' append}
	{css file="/mod/cssjs/css/message.css"}
	{js file="/mod/cssjs/js/messageclass.js"}
	{js file="/mod/cssjs/js/message.js"}
	{js file="/mod/cssjs/js/chmypaginate.js"}
	{js file="/mod/cssjs/js/chfilter.js"}
	{js file="/mod/cssjs/js/Modal.js"}
	
	{css file="/mod/cssjs/css/mypaginate.css"}
	{css file="/mod/cssjs/css/Modal.css"}
{/block}

{block name='arkeogis_content'}
<div class="directory-list">
	{block name='paginator'}
	{* Pagination *}
	<div id="pagination" class="pagination">
  		<ul>
    			<li  class="prev"><a id='paginator_prev' href="#">&larr; Previous</a></li>
    			<li class="active"><a id="paginator_nums" href="#"></a></li>
    			<li class="next"><a id="paginator_next" href="#">Next &rarr;</a></li>
  		</ul>
	</div>
	{/block}
	{block name='directory_list'}
	<table id="directory_list" class="table zebra-striped condensed-table bordered-table table-list" summary="Page List" border="0" cellspacing="0" cellpadding="0">
		<caption class="list">{t d='arkeogis' m='ArkeoGIS Directory list'}</caption>
		<thead>
			<tr>
			<th><div >{t d='arkeogis' m='Login'}</div></th>
			<th><div>{t d='arkeogis' m='Full Name'}</div></th>
			<th><div>{t d='arkeogis' m='Email'}</div></th>
			<th><div>{t d='arkeogis' m='Groups'}</div></th>
			<th><div>{t d='arkeogis' m='Databases'}</div></th>
			</tr>
		</thead>
		<tbody>
			{section name=p loop=$list}
			<tr>
				<td>{$list[p].login}</td>
				<td>{$list[p].full_name}</td>
				<td>{$list[p].email}</td>
				<td>{$list[p].groups}</td>
				<td class="dbnames">{$list[p].databases}</td>
			</tr>
			{/section}
		</tbody>
	</table>
	{/block}
</div>
<script>
	
	window.addEvent('domready', function() {
		$$('a.ajaxLink').addEvent('click', function(event){
				event.preventDefault();
		});
		var dpaginate= new CHMyPaginate({
			paginateElement: 'pagination',
			tableElement: 'directory_list',
			path:'/directory/',
			conf: true,
			sort: '{$sort}',
			sortable: ['login', 'full_name', 'email'],
			filters: [[['label', 'Login'],
                                   ['name', 'login'],
                                   ['type', 'text'],
                                   ['returnMethod', 'func'],
                                   ['returnFunc', 'directoryList']],
				  [['label', 'Full Name'],
                                   ['name', 'full_name'],
                                   ['type', 'text'],
                                   ['returnMethod', 'func'],
                                   ['returnFunc', 'directoryNameList']], 
				  [['label', 'Email'],
                                   ['name', 'email'],
                                   ['type', 'text'],
                                   ['returnMethod', 'func'],
                                   ['returnFunc', 'directoryEmail']],
				 ],
			filter: '{$filter}',		
			maxrow: {$maxrow},
			offset: {$offset},
			quant: {$quant}
		});
	});
		var mydir = new Directory();
		var dmod = new Modal.Base(document.body);

</script>
{/block}
