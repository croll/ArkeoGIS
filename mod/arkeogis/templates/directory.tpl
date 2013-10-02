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

               <div id='directory_list'></div>





	{/block}
</div>
{literal}<script>

	window.addEvent('domready', function() {
                datagrid = new omniGrid('directory_list', {
                         columnModel: [
                                 {
                                        header: ch_t('arkeogis', "Username"),
                                        dataIndex: "login",
                                        dataType: "string",
                                        width: 150
                                 },
                                 {
                                        header: ch_t('arkeogis', "Full Name"),
                                        dataIndex: "full_name",
                                        dataType: "string",
                                        width: 166
                                 },
                                 {
                                        header: ch_t('arkeogis', "Structure"),
                                        dataIndex: "structure",
                                        dataType: "string",
                                        width: 150
                                 },
                                 {
                                        header: ch_t('arkeogis', "Email"),
                                        dataIndex: "email",
                                        dataType: "string",
                                        width: 230
                                 },
                                 {
                                        header: ch_t('arkeogis', "Groups"),
                                        dataIndex: "groups",
                                        dataType: "string",
                                        width: 120
                                 },
                                 {
                                        header: ch_t('arkeogis', 'Databases'),
                                        dataIndex: "databases",
                                        dataType: "string",
                                        width: 375
                                 }
                         ],
                         width: 1199,
                         //height: 0,
                         perPageOptions: [10,25,50,1000000],
                         perPage: 10,
                         page: 1,
                         pagination: true,
                         url: '/ajax/call/arkeogis/directory',
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
