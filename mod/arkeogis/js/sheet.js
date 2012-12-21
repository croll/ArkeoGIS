function sort_unique(arr) {
    arr = arr.sort();
    var ret = [arr[0]];
    for (var i = 1; i < arr.length; i++) { // start loop at 1 as element 0 can never be a duplicate
        if (arr[i-1] !== arr[i]) {
            ret.push(arr[i]);
        }
    }
    return ret;
}

function uniqcarac(carac) {
    var caracs=sort_unique(carac.split('<br />'));
    return caracs.join('<br />');
}

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
	    uniqcarac(row.realestate),
	    uniqcarac(row.furniture),
	    uniqcarac(row.production),
	    uniqcarac(row.landscape)
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
	    ch_t('arkeogis', 'Production'),
	    ch_t('arkeogis', 'Paysage')
	],
	rows: data2
    });
    grid.enableSort();
    grid.inject($('map_sheet'));
    $('map_sheet').setStyles({
	display: ''
    });
}
