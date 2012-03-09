function display_sheet(data) {
    $('map_sheet').empty();
    var data2=[];
    for (var i=0; i<data.length; i++) {
	var row=data[i];
	data2.push([
	    '<div>'+row.da_name+'</div>',
	    '<div>'+row.ci_name+'</div>',
	    '<div>'+row.si_name+'</div>',
	    '<div>'+row.period_start+'<br />'+row.period_end+'</div>',
	    '<div>'+row.realestate+'</div>',
	    '<div>'+row.furniture+'</div>',
	    '<div>'+row.production+'</div>'
	    
	]);
    }

    var grid = new HtmlTable({
	properties: {
	    border: 1,
	    cellspacing: 3,
	    class: 'table table-striped table-bordered table-condensed'
	},
	gridContainer : $('map_sheet'),
	headers: [
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
