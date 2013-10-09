{extends tplextends('arkeogis/layout')}
{block name='webpage_head' append}
    {js file="/mod/arkeogis/ext/MooDatePicker/js/MooDatePicker.js"}
    {css file="/mod/arkeogis/ext/MooDatePicker/css/MooDatePicker.css"} 
    {css file="/mod/cssjs/ext/meioautocomplete/meioautocomplete.css"}
    {css file="/mod/cssjs/css/Modal.css"}
    {css file="/mod/cssjs/css/message.css"}
    {js file="/mod/cssjs/js/messageclass.js"}
    {js file="/mod/cssjs/js/message.js"}
    {js file="/mod/cssjs/js/Modal.js"}
    {js file="/mod/cssjs/ext/omnigrid/Source/omnigrid.js"}
    {css file="/mod/cssjs/ext/omnigrid/Themes/default/omnigrid.css"}
    {js file="/mod/cssjs/ext/meioautocomplete/meioautocomplete.js"}
{/block}

{block name='arkeogis_content'}

<h2 style="margin-bottom: 10px">{t d='arkeogis' m="Index of databases"}</h2>
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
                                        width: 130
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
                                        dataIndex: "declared_modification_str",
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
                                        width: 80
                                 },
                                 {
                                        header: ch_t('arkeogis', 'Geographical limit'),
                                        dataIndex: "geographical_limit",
                                        dataType: "string",
                                        width: 120 
                                 },
                                 {
                                        header: ch_t('arkeogis', 'description'),
                                        dataIndex: "description",
                                        dataType: "string",
                                        width: 220 
                                 },
                                 {                                 
                                        header: '&nbsp;',
                                        dataIndex: "published_str",
                                        dataType: "string",
                                        width: 24 
                                 }
                         ],
                         width: 1199,
                         //height: 0,
                         perPageOptions: [15,25,50,ch_t('arkeogis', 'all')],
                         perPage: 10,
                         page: 1,
                         pagination: true,
                         paginationPosition: 'top',
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
                        datagrid.addEvent('click', function(evt) {
                            show_sheet(evt.target.getDataByRow(evt.row).id, 'database');
                        });

                var rp;
                var n;

                rp=$$('select.rp')[0];
                n=new Element("span", {
                      TEXT: ch_t('arkeogis', "Number of lines per page :")+' ',
                      class: 'blah',
                      styles: { 'position': 'relative',
                         'top': '-3px',
                      }
                });
                rp.grab(n, 'before');

                rp=$$('input.cpage')[0];
                n=new Element("div", {
                      class: 'blah',
                      styles: { 'display': 'inline' },
                      TEXT: ch_t('arkeogis', "Page :")+' '
                });
                rp.grab(n, 'before');

                rp=$$('span.pPageStat')[0];
                n=new Element("span", {
                      TEXT: ' '+ch_t('arkeogis', "Databases"),
                      styles: { 'position': 'relative',
                         'top': '2px',
                      },
                      class: 'blah'
                });
                rp.grab(n, 'after');

	});

              function showEditDatabase(id) {
                    new Request.JSON({
                         'url': '/ajax/call/arkeogis/showEditDatabase',
                         onSuccess: function(res) {
                            if ($('databaseEditForm')) {
                                $('databaseEditForm').reset();
                                $('databaseEditForm').destroy();
                            }
                            modalWin.setTitle(res.title).setBody(res.content).setFooter(res.footer);
                            var myMooDatePicker = new MooDatePicker(document.getElement('input[name=declared_modification]'), {
                                onPick: function(date){
                                     this.element.set('value', date.format('%e/%m/%Y'));
                                 }
                            });
                            var myAutocomplete = new Meio.Autocomplete($('author'), '/ajax/call/user/getUserListSimple', {
                                    onNoItemToList: function(elements){
                                        elements.field.node.highlight('#ff5858');
                                    }
                            });
                         },
                         onFailure: function() {
                            modalWin.setTitle("Erreur").setBody("Aucun contenu, réessayez plus tard.").show();
                         }
                    }).post({id: id});
             }

              function editDatabase(id) {
                  var values = $('databaseEditForm').toQueryString().parseQueryString();
                  values.id = id;
                  new Request.JSON({
                         'url': '/ajax/call/arkeogis/editDatabase',
                         onSuccess: function(res) {
                          if (res == true) {
                                datagrid.refresh();
                                modalWin.hide();
                                CaptainHook.Message.show(ch_t('arkeogis', 'Database informations updated.'));
                            } else {
                                CaptainHook.Message.show(ch_t('arkeogis', 'Error updating database informations.'));
                            }
                         },
                         onFailure: function() {
                            modalWin.setTitle("Erreur").setBody("Aucun contenu, réessayez plus tard.").show();
                         }
                    }).post(values);
             } 

              function deleteDatabase(id) {
                    new Request.JSON({
                         'url': '/ajax/call/arkeogis/deleteDatabase',
                         onSuccess: function(res) {
                            if (res == true) {
                                datagrid.refresh();
                                modalWin.hide();
                                CaptainHook.Message.show(ch_t('arkeogis', 'Database deleted.'));
                            } else {
                                CaptainHook.Message.show(ch_t('arkeogis', 'Error deleting database.'));
                            }
                         },
                         onFailure: function() {
                            modalWin.setTitle("Erreur").setBody("Aucun contenu, réessayez plus tard.").show();
                         }
                    }).post({id: id});
             }

             function downloadLastImport(id) {
                window.location.href='/get_imported_file/'+id;
             }

             function exportDatabase(id) {
                window.location.href='/export_database/'+id;
             }


</script>{/literal}
{/block}
