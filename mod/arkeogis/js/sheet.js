function display_sheet(data) {
    $('map_sheet').empty();
    var data2=[];
    for (var i=0; i<data.length; i++) {
	var row=data[i];
/*
	var realestate = row.realestate.substring(1,row.realestate.length-1);
	if (realestate.substring(0,1) == '"')
	    realestate=realestate.substring(1, realestate.length-1);
	if (realestate=='NULL') realestate='';

	var furniture = row.furniture.substring(1,row.furniture.length-1);
	if (furniture.substring(0,1) == '"')
	    furniture=furniture.substring(1, furniture.length-1);
	if (furniture=='NULL') furniture='';

	var production = row.production.substring(1,row.production.length-1);
	if (production.substring(0,1) == '"')
	    production=production.substring(1, production.length-1);
	if (production=='NULL') production='';

	var period_start=row.period_start.substring(1,row.period_start.length-1).split(',');
	var period_end=row.period_end.substring(1,row.period_end.length-1).split(',');

	var period='';

	for (var j=0; j<period_start.length; j++) {
	    if (period_start[j].substring(0,1) == '"')
		period_start[j]=period_start[j].substring(1, period_start[j].length-1);
	    if (period_end[j].substring(0,1) == '"')
		period_end[j]=period_end[j].substring(1, period_end[j].length-1);
	    period+='<div>'+period_start[j]+" => "+period_end[j]+"</div>";
	}
	data2.push([
	    row.si_name,
	    period,
	    realestate,
	    furniture,
	    production
	]);
	*/
	data2.push([
	    row.si_name,
	    row.period_start+' => '+row.period_end,
	    row.realestate,
	    row.furniture,
	    row.production
	    
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
	    ch_t('arkeogis', 'Nom du site'),
	    ch_t('arkeogis', 'Période'),
	    ch_t('arkeogis', 'Immobilier'),
	    ch_t('arkeogis', 'Mobilier'),
	    ch_t('arkeogis', 'Production'),
	],
	rows: data2
    });
    grid.enableSort();
    grid.inject($('map_sheet'));
    $('map_sheet').setStyles({
	display: ''
    });
}
