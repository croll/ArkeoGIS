function display_sheet(data) {
    $('map_sheet').empty();
    var data2=[];
    for (var i=0; i<data.length; i++) {
	var row=data[i];
	data2.push([
	    row.si_id,
	    row.da_name,
	    row.si_city_name,
	    row.si_name,
	    row.period_start+'<br />'+row.period_end,
	    row.realestate,
	    row.furniture,
	    row.production	    
	]);
    }

    var grid = new HtmlTable({
	properties: {
	    border: 1,
	    cellspacing: 3,
	    'class': 'table table-striped table-bordered table-condensed'
	},
	gridContainer : $('map_sheet'),
	headers: [
	    'si_id',
	    ch_t('arkeogis', 'Base source'),
	    ch_t('arkeogis', 'Commune'),
	    ch_t('arkeogis', 'Nom du site'),
	    ch_t('arkeogis', 'Période'),
	    ch_t('arkeogis', 'Immobilier'),
	    ch_t('arkeogis', 'Mobilier'),
	    ch_t('arkeogis', 'Production')
	],
	rows: data2
    });
    grid.enableSort();
    grid.inject($('map_sheet'));
    $('map_sheet').setStyles({
	display: ''
    });
}
