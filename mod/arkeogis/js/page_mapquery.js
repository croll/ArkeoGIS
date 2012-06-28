var infoWindow = null;
var map;
var queryNum = 0;
var mapMarkers = [];
var modalWin;

window.addEvent('domready', function() {

    /* initialization of plusminus menus */
    arkeo_menu={};

    arkeo_menu.db = new PlusMinusItem(ch_t('arkeogis', "Choix de la base"), null, null);
    for (var i=0; i<menus.db.length; i++)
	arkeo_menu.db.addJsonItem(menus.db[i]);
    arkeo_menu.db.inject($('menu_db'));

    arkeo_menu.period = new PlusMinusItem(ch_t('arkeogis', "Choix de la période"), null, null);
    for (var i=0; i<menus.period.length; i++)
	arkeo_menu.period.addJsonItem(menus.period[i]);
    arkeo_menu.period.inject($('menu_period'));

    arkeo_menu.production = new PlusMinusItem(ch_t('arkeogis', "Choix production"), null, null);
    for (var i=0; i<menus.production.length; i++)
	arkeo_menu.production.addJsonItem(menus.production[i]);
    arkeo_menu.production.inject($('menu_production'));

    arkeo_menu.realestate = new PlusMinusItem(ch_t('arkeogis', "Choix immobilier"), null, null);
    for (var i=0; i<menus.realestate.length; i++)
	arkeo_menu.realestate.addJsonItem(menus.realestate[i]);
    arkeo_menu.realestate.inject($('menu_realestate'));

    arkeo_menu.furniture = new PlusMinusItem(ch_t('arkeogis', "Choix mobilier"), null, null);
    for (var i=0; i<menus.furniture.length; i++)
	arkeo_menu.furniture.addJsonItem(menus.furniture[i]);
    arkeo_menu.furniture.inject($('menu_furniture'));


    /* initialization of menus centroid, knowledge, occupation */

    arkeo_menu.centroid = new PlusMinusItem(ch_t('arkeogis', "CENTROID"), null, new PlusMinusMenu([
	new PlusMinusItem(ch_t('arkeogis', "OUI"), 1, null, { nominus: true }),
	new PlusMinusItem(ch_t('arkeogis', "NON"), 0, null, { nominus: true })
    ]));
    arkeo_menu.centroid.inject($('menu-centroid'));

    arkeo_menu.knowledge = new PlusMinusItem(ch_t('arkeogis', "CONNAISSANCE"), null, new PlusMinusMenu([
	new PlusMinusItem(ch_t('arkeogis', "Non renseigné"), 'unknown', null, { nominus: true }),
	new PlusMinusItem(ch_t('arkeogis', "Littérature, prospecté"), 'literature', null, { nominus: true }),
	new PlusMinusItem(ch_t('arkeogis', "Sondé"), 'surveyed', null, { nominus: true }),
	new PlusMinusItem(ch_t('arkeogis', "Fouillé"), 'excavated', null, { nominus: true })
    ]));
    arkeo_menu.knowledge.inject($('menu-knowledge'));

    arkeo_menu.occupation = new PlusMinusItem(ch_t('arkeogis', "OCCUPATION"), null, new PlusMinusMenu([
	new PlusMinusItem(ch_t('arkeogis', "Non renseigné"), 'unknown', null, { nominus: true }),
	new PlusMinusItem(ch_t('arkeogis', "Unique"), 'uniq', null, { nominus: true }),
	new PlusMinusItem(ch_t('arkeogis', "Continue (plusieurs périodes contiguës)"), 'continuous', null, { nominus: true }),
	new PlusMinusItem(ch_t('arkeogis', "Multiple (plusieurs périodes indépendantes)"), 'multiple', null, { nominus: true })
    ]));
    arkeo_menu.occupation.inject($('menu-occupation'));

    

    /* initialization of buttons "afficher la carte" and "afficher le tableur" */

    $('onglet').addEvent('click', function() {
	show_menu(!menu_showing);
    });

    function buildSelectionObject() {
	var result={};

	// get selections of plusminus menus

	result.db_include = arkeo_menu.db.getSelection('+');
	result.db_exclude = arkeo_menu.db.getSelection('-');
	result.period_include = arkeo_menu.period.getSelection('+');
	result.period_exclude = arkeo_menu.period.getSelection('-');
	result.production_include = arkeo_menu.production.getSelection('+');
	result.production_exclude = arkeo_menu.production.getSelection('-');
	result.realestate_include = arkeo_menu.realestate.getSelection('+');
	result.realestate_exclude = arkeo_menu.realestate.getSelection('-');
	result.furniture_include = arkeo_menu.furniture.getSelection('+');
	result.furniture_exclude = arkeo_menu.furniture.getSelection('-');


	// get selections of multiselect menus

	result.centroid_include = arkeo_menu.centroid.getSelection('+');
	result.knowledge_include = arkeo_menu.knowledge.getSelection('+');
	result.occupation_include = arkeo_menu.occupation.getSelection('+');
	result.centroid_exclude = arkeo_menu.centroid.getSelection('-');
	result.knowledge_exclude = arkeo_menu.knowledge.getSelection('-');
	result.occupation_exclude = arkeo_menu.occupation.getSelection('-');

	// get selections of exceptionals checkbox

	result.realestate_exceptional = $('ex_realestate').checked ? 1 : 0;
	result.furniture_exceptional = $('ex_furniture').checked ? 1 : 0;
	result.production_exceptional = $('ex_production').checked ? 1: 0;

	return result;
    }

    $('btn-show-the-map').addEvent('click', function() {
				queryNum += 1;
	var form=buildSelectionObject();
	if ((form.db_include.length > 0 || form.db_exclude > 0)
	    && (form.period_include.length > 0 || form.period_exclude.length > 0)
	    && (form.production_include.length > 0 || form.production_exclude.length > 0
		|| form.realestate_include.length > 0 || form.realestate_exclude.length > 0
		|| form.furniture_include.length > 0 || form.furniture_exclude.length > 0)) {
	var form=buildSelectionObject();
	} else {
	    CaptainHook.Message.show(ch_t('arkeogis', "Vous devez choisir au moins une base, une période et une caractérisation"));
			return;
	}
	
	showSpinner();
	new Request.JSON({
	    'url': '/ajax/call/arkeogis/showthemap',
	    'onSuccess': function(res) {
			hideSpinner();
		display_query(form);
		if (res.mapmarkers.length < res.total_count
		    && confirm(ch_t('arkeogis', "Seulement %d sites seront affiché sur %d au total. Souhaitez-vous télécharger la liste au format csv ? Cliquer sur le bouton Cancel affichera les 1000 premiers sites.", res.mapmarkers.length, res.total_count))) {

		    // download the sites as csv file
		    window.location.href='/export_sheet/'+encodeURIComponent(JSON.encode(form));
		    return;
		} else if (res.mapmarkers.length == 0) {
			CaptainHook.Message.show(ch_t('arkeogis', 'Aucun résultat'));
		}
		$('map_sheet').setStyles({
		    'display': 'none'
		});
		show_menu(false);
				res.mapmarkers.each(function(marker) {
					if (infoWindow)
						infoWindow.close();
					var m = new google.maps.Marker({
						position: new google.maps.LatLng(marker.geometry.coordinates[1], marker.geometry.coordinates[0]),
						icon: new google.maps.MarkerImage(marker.icon.iconUrl),
						map: map
					});
					if (typeOf(mapMarkers[queryNum]) != 'array') 
						mapMarkers[queryNum] = [];
					mapMarkers[queryNum].push(m);

					google.maps.event.addListener(m, 'mouseover', function() {
						if (infoWindow)
							infoWindow.close();
						infoWindow = new google.maps.InfoWindow({
							 content: marker.popup.title+marker.popup.content
						});
						infoWindow.open(map, m);
					});
					google.maps.event.addListener(m, 'click', function() {
						if (infoWindow)
							infoWindow.close();
							show_sheet(marker.id);
					});
					google.maps.event.addListener(m, 'mouseout', function() {
						infoWindow.close();
					});
				});
	    }
	}).post({search: form, queryNum: queryNum});
    });

    $('btn-show-the-table').addEvent('click', function() {
				queryNum += 1;
	var form=buildSelectionObject();
	if ((form.db_include.length > 0 || form.db_exclude > 0)
	    && (form.period_include.length > 0 || form.period_exclude.length > 0)
	    && (form.production_include.length > 0 || form.production_exclude.length > 0
		|| form.realestate_include.length > 0 || form.realestate_exclude.length > 0
		|| form.furniture_include.length > 0 || form.furniture_exclude.length > 0)) {
	} else {
	    CaptainHook.Message.show(ch_t('arkeogis', "Vous devez choisir au moins une base, une période et une caractérisation"));
			return;
	}
	showSpinner();
	new Request.JSON({
	    'url': '/ajax/call/arkeogis/showthesheet',
	    'onSuccess': function(res) {
			hideSpinner();
		if ((res.sites.length < res.total_count)
		    && confirm(ch_t('arkeogis', "Seulement %d sites seront affiché sur %d au total. Souhaitez-vous plutôt télécharger la liste au format csv ?", res.sites.length, res.total_count))
		   ) {

		    // download as csv
		    window.location.href='/export_sheet/'+encodeURIComponent(JSON.encode(form));
		} else if (res.sites.length == 0) {
			CaptainHook.Message.show(ch_t('arkeogis', 'Aucun résultat'));
		} else {
		    show_menu(false);
		    display_sheet(res.sites);
		    $$('#map_sheet tr').addEvent('click', function(e, tr) {
			var id=this.firstChild.get('html');
			show_sheet(id);
		    });
		}
		display_query(form);
	    }
	}).post(form);
    });


    
    /* initialization of buttons about query saving */
    populateSavedQueriesMenu();

    $('select-savedqueries').addEvent('change', function(e) {
	new Request.JSON({
	    'url': '/ajax/call/arkeogis/loadQuery',
	    'onSuccess': function(res) {
		res=JSON.decode(res);
		var idx=$('select-savedqueries').selectedIndex;
		if (idx == 0) return;
		arkeo_menu.db.setSelection(res.db_include, res.db_exclude);
		arkeo_menu.period.setSelection(res.period_include, res.period_exclude);
		arkeo_menu.production.setSelection(res.production_include, res.production_exclude);
		arkeo_menu.realestate.setSelection(res.realestate_include, res.realestate_exclude);
		arkeo_menu.furniture.setSelection(res.furniture_include, res.furniture_exclude);

		arkeo_menu.centroid.setSelection(res.centroid_include, []);
		arkeo_menu.knowledge.setSelection(res.knowledge_include, []);
		arkeo_menu.occupation.setSelection(res.occupation_include, []);

		$('ex_realestate').checked = res.realestate_exceptional == 1;
		$('ex_furniture').checked = res.furniture_exceptional == 1;
		$('ex_production').checked = res.production_exceptional == 1;

		$('select-savedqueries').selectedIndex=idx;
	    }
	}).post({
	    'queryid': $('select-savedqueries').get('value')
	});
    });


    $$('.btn-querydelete').addEvent('click', function() {
	var option=$('select-savedqueries').getSelected();
	if (option.get('value') == '0') {
	    CaptainHook.Message.show(ch_t('arkeogis', "Vous devez selectionner une requête avant"));
			return;
	}
	if (!confirm(ch_t('arkeogis', "Souhaitez-vous vraiment effacer la requête '%s' ?", option.get('text')))) return;
	new Request.JSON({
	    'url': '/ajax/call/arkeogis/deleteQuery',
	    'onSuccess': function(res) {
		populateSavedQueriesMenu();
		if (res == 'ok')
		    CaptainHook.Message.show(ch_t('arkeogis', "Requête '%s' effacée", option.get('text')));
		else alert('problem');
		return;
	    }
	}).post({
	    'queryid': option.get('value')
	});
    });


    ['centroid', 'knowledge', 'occupation', 'db', 'period', 'production', 'realestate', 'furniture'].each(function(m) {
	arkeo_menu[m].addEvent('selection', function() {
	    $('select-savedqueries').selectedIndex=0;
	})
    });
    [ 'ex_realestate', 'ex_furniture', 'ex_production' ].each(function(m) {
	$(m).addEvent('change', function() {
	    $('select-savedqueries').selectedIndex=0;
	})
    });


    $$('.btn-reinit')[0].addEvent('click', function() {
				queryNum = 0;
				clearMarkers();
	$('select-savedqueries').selectedIndex=0;

	arkeo_menu.db.setSelection([], []);
	arkeo_menu.period.setSelection([], []);
	arkeo_menu.production.setSelection([], []);
	arkeo_menu.realestate.setSelection([], []);
	arkeo_menu.furniture.setSelection([], []);
	
	arkeo_menu.centroid.setSelection([], []);
	arkeo_menu.knowledge.setSelection([], []);
	arkeo_menu.occupation.setSelection([], []);
	
	$('ex_realestate').checked = false;
	$('ex_furniture').checked = false;
	$('ex_production').checked = false;

	$('querys').set('html', '');
    });


    /* initialization of google map */
    map = new google.maps.Map($('map_canvas'), {
			center: new google.maps.LatLng(48.58476, 7.750576),
	zoom: 7, 
	disableDefaultUI: true,
	mapTypeId: google.maps.MapTypeId.TERRAIN,
	mapTypeControl: true,
	mapTypeControlOptions: {
	    style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR,
	    position: google.maps.ControlPosition.TOP_RIGHT
	},
	zoomControl: true,
	zoomControlOptions: {
	    style: google.maps.ZoomControlStyle.BIG,
	    position: google.maps.ControlPosition.RIGHT_TOP
	},
	panControl: true,
	panControlOptions: {
	    style: google.maps.ZoomControlStyle.BIG,
	    position: google.maps.ControlPosition.RIGHT_TOP
	},
	scaleControl: true,
	scaleControlOptions: {
	    position: google.maps.ControlPosition.BOTTOM_LEFT
	}
    });

});

/* functions */

function buildFilterLines(menu, colnum, div) {
    menu.each(function(model) {	
	var table = new Element('table');
	table.inject(div);

	var tr = new Element('tr');
	tr.inject(table);

	var td1 = new Element('td', {
	    'class': 'td1',
	    'text': model.text
	});
	td1.set('html', td1.get('html').replace(/\n/g, '<br />'));
	td1.inject(tr);
	
	if (model.selection) {
	    td1.addClass(model.selection == '+' ? 'filter-plus' : 'filter-minus');
	} else if (model.submenu) {
	    var td2 = new Element('td', {
		'class': 'td2'
	    });
	    td2.inject(tr);
	    buildFilterLines(model.submenu, colnum+1, td2);
	}
    });
}

var arkeo_query_displayed=0;
function display_query(query) {
    var html = $('query-display').clone();
    html.setStyles({
	display: ''
    });

    html.getElement('.query_num').set('text', ++arkeo_query_displayed);
    ['centroid', 'knowledge', 'occupation', 'db', 'period', 'production', 'realestate', 'furniture'].each(function(m) {
	var result=[];
	if (arkeo_menu[m].submenu.buildPath(query[m+'_include'], query[m+'_exclude'], result)) {
	    var queryfilter_html=$('query-filter').clone();
	    queryfilter_html.setStyles({
		display: ''
	    });
	    var title=m;
	    if (m == 'production') title=ch_t('arkeogis', "Production");
	    else if (m == 'realestate') title=ch_t('arkeogis', "Immobilier");
	    else if (m == 'furniture') title=ch_t('arkeogis', "Mobilier");
	    else if (m == 'centroid') title=ch_t('arkeogis', "Centroid");
	    else if (m == 'knowledge') title=ch_t('arkeogis', "Connaissance");
	    else if (m == 'occupation') title=ch_t('arkeogis', "Occupation");
	    else if (m == 'db') title=ch_t('arkeogis', "Base de donnée");
	    else if (m == 'period') title=ch_t('arkeogis', "Période");

	    if (m == 'production' || m == 'realestate' || m == 'furniture')
		if (query[m+'_exceptional'] == 1) title+=' '+ch_t('arkeogis', '(exceptionals only)');
	    queryfilter_html.getElement('div.filtername span').set('text', title);

	    div=new Element('div', {
		'class': 'filtercontent'
	    });
	    buildFilterLines(result, 0, div);
	    div.inject(queryfilter_html);
	    queryfilter_html.inject(html.getElement('.query-filters'));
	}
    });

    html.getElement('.btn-save-query').addEvent('click', function() {
	if (!html.getElement('.input-save-query').get('value').trim())
	    return alert(ch_t('arkeogis', "donner un nom à votre requete"));
	new Request.JSON({
	    'url': '/ajax/call/arkeogis/saveQuery',
	    'onSuccess': function(res) {
		populateSavedQueriesMenu();
		if (res == 'ok')
		    CaptainHook.Message.show(ch_t('arkeogis', "Requête enregistrée"));
		else if (res == 'duplicate')
		    alert(ch_t('arkeogis', "Une requête '%s' existe déjà sous ce nom",
			       html.getElement('.input-save-query').get('value')));
		else alert('problem');
	    }
	}).post({
	    'name': html.getElement('.input-save-query').get('value'),
	    'query': JSON.encode(query)
	});
    });

    html.getElement('.btn-print').addEvent('click', function() {
	var win=window.open('/print_sheet#'+encodeURI(JSON.encode(query)), 'sheet print');
    });

    html.getElement('.btn-export').addEvent('click', function() {
	window.location.href='/export_sheet/'+encodeURIComponent(JSON.encode(query));
    });

    html.inject($('querys'));
}

function populateSavedQueriesMenu() {
    new Request.JSON({
	'url': '/ajax/call/arkeogis/listQueries',
	'onSuccess': function(res) {
	    var sel=$('select-savedqueries');
	    var id=sel.getSelected().get('value');
	    sel.set('html', '');
	    Array.push(sel.options, (new Element('option', {
		'value': '0',
		'text': ch_t('arkeogis', "Requêtes archivées")
	    })));
	    var index=1;
	    res.each(function(line) {
		Array.push(sel.options, (new Element('option', {
		    'value': line.id,
		    'text': line.name
		})));
		if (line.id == id) sel.selectedIndex=index;
		index++;
	    });
	}
    }).get();
}

var menu_showing=true;
function show_menu(show) {
    menu_showing=show;
		if (menu_showing) {
		    $$('div[id=onglet] i', document.body)[0].removeClass('icon-chevron-right').addClass('icon-chevron-left');
		    $('onglet').setStyle('left', '');
		    $('map_menu').setStyle('display', '');
		} else {
		    $$('div[id=onglet] i', document.body)[0].removeClass('icon-chevron-left').addClass('icon-chevron-right');
		    $('onglet').setStyle('left', 0);
		    $('map_menu').setStyle('display', 'none');
		}
}

function show_sheet(siteId) {
	modalWin = new Modal.Base(document.body, {
		header: "Fiche site",
		body: "Chargement..."
	});
	new Request.JSON({
		'url': '/ajax/call/arkeogis/showsitesheet',
			onRequest: function() {
			},
		onSuccess: function(res) {
			modalWin.setTitle(res.title).setBody(res.content).show();
		},
		onFailure: function() {
			modalWin.setTitle("Erreur").setBody("Aucun contenu, réessayez plus tard.").show();
		}
	}).post({id: siteId});
}

function clearMarkers() {
	if (mapMarkers.length > 0) {
		mapMarkers.each(function(mGroup) {
			mGroup.each(function(m) {
				m.setMap(null);
			});
		});
		mapMarkers = [];
	}
}

function showSpinner() {
	$('arkeospinner').setStyle('display', 'block');
}

function hideSpinner() {
	$('arkeospinner').setStyle('display', 'none');
}
