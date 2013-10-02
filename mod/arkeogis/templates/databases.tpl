{extends tplextends('arkeogis/layout')}
{block name='webpage_head' append}
	{css file="/mod/cssjs/css/message.css"}
	{js file="/mod/cssjs/js/messageclass.js"}
	{js file="/mod/cssjs/js/message.js"}
	{js file="/mod/cssjs/js/Modal.js"}
        {js file="/mod/cssjs/ext/omnigrid/Source/omnigrid.js"}
	{css file="/mod/cssjs/ext/omnigrid/Themes/default/omnigrid.css"}
{/block}

{block name='arkeogis_content'}
<div class="directory-list">
	{block name='directory_list'}

               <div id='databases_list'></div>





	{/block}
</div>
{literal}<script>

	window.addEvent('domready', function() {
                datagrid = new omniGrid('databases_list', {
                         columnModel: [
                                 {
                                        header: ch_t('arkeogis', "ISSN Number"),
                                        dataIndex: "issn",
                                        dataType: "string",
                                        width: 90
                                 },
                                 {
                                        header: ch_t('arkeogis', "Database"),
                                        dataIndex: "name",
                                        dataType: "string",
                                        width: 150
                                 },
                                 {
                                        header: ch_t('arkeogis', "Author"),
                                        dataIndex: "author",
                                        dataType: "string",
                                        width: 120
                                 },
                                 {
                                        header: ch_t('arkeogis', "Type"),
                                        dataIndex: "type",
                                        dataType: "string",
                                        width: 80
                                 },
                                 {
                                        header: ch_t('arkeogis', "Last update"),
                                        dataIndex: "declared_modification",
                                        dataType: "string",
                                        width: 80
                                 },
                                 {
                                        header: ch_t('arkeogis', 'Lines'),
                                        dataIndex: "lines",
                                        dataType: "string",
                                        width: 40
                                 },
                                 {
                                        header: ch_t('arkeogis', 'Sites'),
                                        dataIndex: "sites",
                                        dataType: "string",
                                        width: 40
                                 },
                                 {
                                        header: ch_t('arkeogis', 'Start date'),
                                        dataIndex: "period_start",
                                        dataType: "string",
                                        width: 80
                                 },                                 
                                 {
                                        header: ch_t('arkeogis', 'End date'),
                                        dataIndex: "period_end",
                                        dataType: "string",
                                        width: 80
                                 },
                                 {
                                        header: ch_t('arkeogis', 'Scale'),
                                        dataIndex: "scale_resolution",
                                        dataType: "string",
                                        width: 50
                                 },
                                 {
                                        header: ch_t('arkeogis', 'Geographical limit'),
                                        dataIndex: "geo_limit",
                                        dataType: "string",
                                        width: 120 
                                 },
                                 {
                                        header: ch_t('arkeogis', 'description'),
                                        dataIndex: "description",
                                        dataType: "string",
                                        width: 150 
                                 },
                                 {
                                        header: ch_t('arkeogis', ''),
                                        dataIndex: "status",
                                        dataType: "string",
                                        width: 30 
                                 },
                                 {
                                        header: ch_t('arkeogis', ''),
                                        dataIndex: "edit",
                                        dataType: "string",
                                        width: 30 
                                 },
                                 {
                                        header: ch_t('arkeogis', ''),
                                        dataIndex: "delete",
                                        dataType: "string",
                                        width: 30 
                                 },
                         ],
                         width: 1199,
                         //height: 0,
                         perPageOptions: [10,25,50,1000000],
                         perPage: 10,
                         page: 1,
                         pagination: true,
                         url: '/ajax/call/arkeogis/databases',
               	         serverSort: true,
	                 showHeader: true,
	                 alternaterows: true,
	                 showHeader:true,
	                 sortHeader:true,
	                 resizeColumns:false,
	                 multipleSelection:false

                        // uncomment this if you want accordion behavior for every row
	                /*
	                accordion:true,
	                accordionRenderer:accordionFunction,
	                autoSectionToggle:false,
	                */
                });
	});

</script>{/literal}
{/block}
