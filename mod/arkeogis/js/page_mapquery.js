var infoWindow = null;
var map;
var queryNum = 0;
var mapMarkers = [];

var select_savedqueries_inhib_selection_event=false;

window.addEvent('domready', function() {

    /* initialization of plusminus menus */
    arkeo_menu={};

    /* pour traduction
       ch_t('arkeogis', 'inventory');
       ch_t('arkeogis', 'research');
    */

    var submenus={ };
    var pmmenu = new PlusMinusMenu();
    for (var i=0; i<menus.db.length; i++) {
	if (!(menus.db[i]['da_type'] in submenus)) {
	    var folder_item = new PlusMinusItem(ch_t('arkeogis', menus.db[i]['da_type']), null, null, { });
	    folder_item.setSubMenu(new PlusMinusMenu());
	    submenus[menus.db[i]['da_type']] = folder_item;
	    pmmenu.addItem(folder_item);
	}
	//submenus[menus.db[i]['da_type']].addJsonItem(menus.db[i]);
	var item=new PlusMinusItem(menus.db[i].name, menus.db[i].id, null, {});
	var helpcontent = '';
	helpcontent+='<table>';
	helpcontent+='<tr>';
	helpcontent+='<td class="treecol"><b>' + ch_t('arkeogis', "Nom de l'Auteur") + '</b> :<br />' + menus.db[i]['full_name'] + '</td>';
	if (menus.db[i]['da_declared_modification'])
		helpcontent+='<td class="treecol"><b>' + ch_t('arkeogis', "Dernière mise à jour") + '</b> :<br />' + new Date(menus.db[i]['da_declared_modification'].substring(0,10)).toLocaleDateString() + '</td>';
	helpcontent+='<td class="treecol"><b>' + ch_t('arkeogis', "Numéro ISSN") + '</b> :<br />' + menus.db[i]['da_issn'] + '</td>';
	helpcontent+='</tr><tr>';
	helpcontent+='<td class="treecol"><b>' + ch_t('arkeogis', "Échelle") + '</b> :<br />' + ch_t('arkeogis', menus.db[i]['da_scale_resolution']) + '</td>';
	helpcontent+='<td class="treecol"><b>' + ch_t('arkeogis', "Nombre de sites") + '</b> :<br />' + menus.db[i]['da_sites'] + '</td>';
	helpcontent+='<td class="treecol"><b>' + ch_t('arkeogis', "Nombre de lignes") + '</b> :<br />' + menus.db[i]['da_lines'] + '</td>';
	helpcontent+='</tr>';
	helpcontent+='<tr><td class="onecol" colspan="3"><b>' + ch_t('arkeogis', "Limites chronologiques") + '</b> : ' + menus.db[i]['period_start'] + ' - ' + menus.db[i]['period_end'] + '</td></tr>';
	helpcontent+='<tr><td class="onecol" colspan="3"><b>' + ch_t('arkeogis', "Limites géographiques") + '</b> : ' + ch_t('arkeogis', menus.db[i]['geographical_limit']) + '</td></tr>';
	helpcontent+='<tr><td class="onecol" colspan="3"><b>' + ch_t('arkeogis', "Description") + '</b> : ' + menus.db[i]['description'] + '</td></tr>';
	helpcontent+='</table>';
	item.setHelp(new PlusMinusHelp(helpcontent, {}));
	submenus[menus.db[i]['da_type']].submenu.addItem(item);
    }

    arkeo_menu.db = new PlusMinusItem(ch_t('arkeogis', "Choix de la base"), null, pmmenu);
    arkeo_menu.db.inject($('menu_db'));


    arkeo_menu.period = new PlusMinusItem(ch_t('arkeogis', "Choix de la période"), null, null);
    for (var i=0; i<menus.period.length; i++)
	arkeo_menu.period.addJsonItem(menus.period[i]);
    arkeo_menu.period.inject($('menu_period'));

    arkeo_menu.area = new PlusMinusItem(ch_t('arkeogis', "Choix de l'aire de recherche"), null, new PlusMinusMenu([
	new PlusMinusItem(ch_t('arkeogis', 'Toute la carte'), 'all', null, { nominus: true }),
	new PlusMinusItem(ch_t('arkeogis', 'Réctangle de sélection'), 'rect', null, { nominus: true }),
	new PlusMinusItem(ch_t('arkeogis', 'Disque de sélection'), 'disc', null, { nominus: true }),
	new PlusMinusItem(ch_t('arkeogis', 'Coordonnées de sélection'), 'coord', null, { nominus: true })
    ]));
    arkeo_menu.area.inject($('menu_area'));

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

    arkeo_menu.landscape = new PlusMinusItem(ch_t('arkeogis', "Choix paysage"), null, null);
    for (var i=0; i<menus.landscape.length; i++)
	arkeo_menu.landscape.addJsonItem(menus.landscape[i]);
    arkeo_menu.landscape.inject($('menu_landscape'));


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

    arkeo_menu.txtsearch_options = new PlusMinusItem(ch_t('arkeogis', "Choisir"), null, new PlusMinusMenu([
	new PlusMinusItem(ch_t('arkeogis', "Nom du site"), 'site.name', null, { nominus: true }),
	new PlusMinusItem(ch_t('arkeogis', "Commune"), 'commune.name', null, { nominus: true }),
	new PlusMinusItem(ch_t('arkeogis', "Biblio"), 'biblio.name', null, { nominus: true }),
	new PlusMinusItem(ch_t('arkeogis', "Remarque"), 'site.remarque', null, { nominus: true })
    ]));
    arkeo_menu.txtsearch_options.inject($('menu_txtsearch_options'));


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
	result.area_include = arkeo_menu.area.getSelection('+');
	result.area_exclude = arkeo_menu.area.getSelection('-');
	result.production_include = arkeo_menu.production.getSelection('+');
	result.production_exclude = arkeo_menu.production.getSelection('-');
	result.realestate_include = arkeo_menu.realestate.getSelection('+');
	result.realestate_exclude = arkeo_menu.realestate.getSelection('-');
	result.furniture_include = arkeo_menu.furniture.getSelection('+');
	result.furniture_exclude = arkeo_menu.furniture.getSelection('-');
	result.landscape_include = arkeo_menu.landscape.getSelection('+');
	result.landscape_exclude = arkeo_menu.landscape.getSelection('-');


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
	result.landscape_exceptional = $('ex_landscape').checked ? 1 : 0;

	// get selection of caracterisation mode

	result.caracterisation_mode = $('caracterisation_mode').get('value');

        // get selection of txtsearch
        result.txtsearch = $('txtsearch').get('value');
        result.txtsearch_options = arkeo_menu.txtsearch_options.getSelection('+');

	// get saved query
	var option=$('select-savedqueries').getSelected();
	result.saved_query={
	    value: option.get('value')[0],
	    index: $('select-savedqueries').selectedIndex,
	    name: option.get('text')[0]
	};

	return result;
    }

    $('btn-show-the-map').addEvent('click', function() {
				queryNum += 1;
	var form=buildSelectionObject();
	if ((form.db_include.length > 0 || form.db_exclude > 0)
	    && (form.period_include.length > 0 || form.period_exclude.length > 0)
	    && (form.area_include.length > 0 || form.area_exclude.length > 0)
	    && (form.production_include.length > 0 || form.production_exclude.length > 0
		|| form.realestate_include.length > 0 || form.realestate_exclude.length > 0
		|| form.furniture_include.length > 0 || form.furniture_exclude.length > 0
		|| form.landscape_include.length > 0 || form.landscape_exclude.length > 0)) {
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
		    && confirm(ch_t('arkeogis', "Seulement %d sites seront affiché sur %d au total. Souhaitez-vous télécharger la liste au format csv ? Cliquer sur le bouton Cancel affichera les 1500 premiers sites.", res.mapmarkers.length, parseInt(res.total_count)))) {

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
							 content: '<div style="width:500px">'+marker.popup.title+marker.popup.content+'</div>'
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
	    && (form.area_include.length > 0 || form.area_exclude.length > 0)
	    && (form.production_include.length > 0 || form.production_exclude.length > 0
		|| form.realestate_include.length > 0 || form.realestate_exclude.length > 0
		|| form.furniture_include.length > 0 || form.furniture_exclude.length > 0
		|| form.landscape_include.length > 0 || form.landscape_exclude.length > 0)) {
	var form=buildSelectionObject();
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
		    && confirm(ch_t('arkeogis', "Seulement %d sites seront affiché sur %d au total. Souhaitez-vous plutôt télécharger la liste au format csv ?", res.sites.length, parseInt(res.total_count)))
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
		select_savedqueries_inhib_selection_event=true;
		arkeo_menu.db.setSelection(res.db_include, res.db_exclude);
		arkeo_menu.period.setSelection(res.period_include, res.period_exclude);
		arkeo_menu.area.setSelection(res.area_include, res.area_exclude);
		arkeo_menu.production.setSelection(res.production_include, res.production_exclude);
		arkeo_menu.realestate.setSelection(res.realestate_include, res.realestate_exclude);
		arkeo_menu.furniture.setSelection(res.furniture_include, res.furniture_exclude);
		arkeo_menu.landscape.setSelection(res.landscape_include ? res.landscape_include : [],
						  res.landscape_exclude ? res.landscape_exclude : []);

		arkeo_menu.centroid.setSelection(res.centroid_include, []);
		arkeo_menu.knowledge.setSelection(res.knowledge_include, []);
		arkeo_menu.occupation.setSelection(res.occupation_include, []);

		$('ex_realestate').checked = res.realestate_exceptional == 1;
		$('ex_furniture').checked = res.furniture_exceptional == 1;
		$('ex_production').checked = res.production_exceptional == 1;
		$('ex_landscape').checked = res.landscape_exceptional == 1;

		$('caracterisation_mode').selectedIndex =
		    res.caracterisation_mode ? res.caracterisation_mode == 'OR' ? 0 : 1 : 0;

                $('txtsearch').set('value', res.txtsearch);
                arkeo_menu.txtsearch_options.setSelection(res.txtsearch_options ? res.txtsearch_options : [], []);

		select_savedqueries_inhib_selection_event=false;
		//$('select-savedqueries').selectedIndex=idx;
	    }
	}).post({
	    'queryid': $('select-savedqueries').get('value')
	});
    });

    ['centroid', 'knowledge', 'occupation', 'db', 'period', 'area', 'production', 'realestate', 'furniture', 'landscape', 'txtsearch_options'].each(function(m) {
	arkeo_menu[m].addEventOnLeafs('selection', function() {
	    if (!select_savedqueries_inhib_selection_event)
		$('select-savedqueries').selectedIndex=0;
	})
    });
    [ 'ex_realestate', 'ex_furniture', 'ex_production', 'ex_landscape', 'caracterisation_mode', 'txtsearch' ].each(function(m) {
	$(m).addEvent('change', function() {
	    if (!select_savedqueries_inhib_selection_event)
		$('select-savedqueries').selectedIndex=0;
	})
    });


    $$('.btn-reinit')[0].addEvent('click', function() {
				queryNum = 0;
				clearMarkers();
	$('select-savedqueries').selectedIndex=0;

	arkeo_menu.db.setSelection([], []);
	arkeo_menu.period.setSelection([], []);
	arkeo_menu.area.setSelection([], []);
	arkeo_menu.production.setSelection([], []);
	arkeo_menu.realestate.setSelection([], []);
	arkeo_menu.furniture.setSelection([], []);
	arkeo_menu.landscape.setSelection([], []);

	arkeo_menu.centroid.setSelection([], []);
	arkeo_menu.knowledge.setSelection([], []);
	arkeo_menu.occupation.setSelection([], []);

	$('ex_realestate').checked = false;
	$('ex_furniture').checked = false;
	$('ex_production').checked = false;
	$('ex_landscape').checked = false;

	$('caracterisation_mode').selectedIndex = 0;

        $('txtsearch').set('value', '');
        arkeo_menu.txtsearch_options.setSelection([], []);

        querys_tabs.tabs.each(function(tab) {
            querys_tabs.removeTab(tab);
        });

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


    /* initialize tabbeds queries */
    querys_tabs = new UI.Tabs( { container : 'querys', scrolling : 'auto', contextMenu : true, sortable : true } );

});

/* functions */

function getMenuById(menu, id) {
    for (var i=0; i<menu.length; i++) {
        if (menu[i].id == id) return menu[i];
    }
    return null;
}

function buildFilterLines(section, menu, colnum, div) {
    menu.each(function(model) {
	var table = new Element('table');
	table.inject(div);

	var tr = new Element('tr');
	tr.inject(table);

        var text=model.text;

        // name of db author
        if (section == 'db' && model.value) {
            var m=getMenuById(menus.db, model.value);
            if (m) text+=ch_t('arkeogis', "(by %s)", m.full_name);
        }

	var td1 = new Element('td', {
	    'class': 'td1',
	    'text': text
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
	    buildFilterLines(section, model.submenu, colnum+1, td2);
	}
    });
}

var arkeo_query_displayed=0;
function display_query(query) {
    var tabname='unnamed';
    var html = $('query-display').clone();
    html.setStyles({
	display: ''
    });

    tabname=ch_t('arkeogis', 'Query #%d', ++arkeo_query_displayed);
    ['centroid', 'knowledge', 'occupation', 'db', 'period', 'area', 'production', 'realestate', 'furniture', 'landscape', 'txtsearch_options'].each(function(m) {
	var result=[];
        var m_include = query[m+'_include'] ? query[m+'_include'] : [];
        var m_exclude = query[m+'_exclude'] ? query[m+'_exclude'] : [];
	if (arkeo_menu[m].submenu.buildPath(m_include, m_exclude, result)) {
	    var queryfilter_html=$('query-filter').clone();
	    queryfilter_html.setStyles({
		display: ''
	    });
	    var title=m;
	    if (m == 'production') title=ch_t('arkeogis', "Production");
	    else if (m == 'realestate') title=ch_t('arkeogis', "Immobilier");
	    else if (m == 'furniture') title=ch_t('arkeogis', "Mobilier");
	    else if (m == 'landscape') title=ch_t('arkeogis', "Paysage");
	    else if (m == 'centroid') title=ch_t('arkeogis', "Centroid");
	    else if (m == 'knowledge') title=ch_t('arkeogis', "Connaissance");
	    else if (m == 'occupation') title=ch_t('arkeogis', "Occupation");
	    else if (m == 'db') title=ch_t('arkeogis', "Base de donnée");
	    else if (m == 'period') title=ch_t('arkeogis', "Période");
	    else if (m == 'area') title=ch_t('arkeogis', "Aire de recherche");
	    else if (m == 'txtsearch_options') title=ch_t('arkeogis', "Recherche dans");

	    if (m == 'production' || m == 'realestate' || m == 'furniture' || m == 'landscape')
		if (query[m+'_exceptional'] == 1) title+=' '+ch_t('arkeogis', '(exceptionals only)');
	    queryfilter_html.getElement('div.filtername span').set('text', title);

	    div=new Element('div', {
		'class': 'filtercontent'
	    });
	    buildFilterLines(m, result, 0, div);
	    div.inject(queryfilter_html);
	    queryfilter_html.inject(html.getElement('.query-filters'));
	}
    });

    if (query.saved_query.value > 0) {
        tabname+=' ('+query.saved_query.name+')';
	html.getElement('.input-save-query').set('value', query.saved_query.name);
	html.getElement('.input-save-query').set('disabled', true);
	html.getElement('.btn-delete-query').setStyle('display', '');
    } else {
	html.getElement('.btn-save-query').setStyle('display', '');
    }

    html.getElement('.btn-delete-query').addEvent('click', function() {
	var option=$('select-savedqueries').getSelected();
	if (!confirm(ch_t('arkeogis', "Souhaitez-vous vraiment effacer la requête '%s' ?", query.saved_query.name))) return;
	new Request.JSON({
	    'url': '/ajax/call/arkeogis/deleteQuery',
	    'onSuccess': function(res) {
		populateSavedQueriesMenu();
		if (res == 'ok') {
		    CaptainHook.Message.show(ch_t('arkeogis', "Requête '%s' effacée", query.saved_query.name));
		    html.getElement('.input-save-query').set('disabled', false);
		    html.getElement('.btn-delete-query').setStyle('display', 'none');
		    html.getElement('.btn-save-query').setStyle('display', '');
		}
		else alert('problem');
		return;
	    }
	}).post({
	    'queryid': query.saved_query.value
	});
    });

    html.getElement('.btn-save-query').addEvent('click', function() {
	if (!html.getElement('.input-save-query').get('value').trim())
	    return alert(ch_t('arkeogis', "Donnez un nom à votre requête."));
	new Request.JSON({
	    'url': '/ajax/call/arkeogis/saveQuery',
	    'onSuccess': function(res) {
		populateSavedQueriesMenu();
		if (res == 'ok') {
		    CaptainHook.Message.show(ch_t('arkeogis', "Requête enregistrée"));
		    html.getElement('.input-save-query').set('disabled', true);
		    html.getElement('.btn-delete-query').setStyle('display', '');
		    html.getElement('.btn-save-query').setStyle('display', 'none');
		}
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


    querys_tabs.addTab({id: 't_'+arkeo_query_displayed, label: tabname, content: html, closable: true, sortable: true});

    //html.inject($('querys'));
}

function populateSavedQueriesMenu() {
    new Request.JSON({
	'url': '/ajax/call/arkeogis/listQueries',
	'onSuccess': function(res) {
	    var sel=$('select-savedqueries');
	    var id=sel.getSelected().get('value');
	    sel.set('html', '');
			sel.adopt(new Element('option', {
		'value': '0',
		'text': ch_t('arkeogis', "Requêtes archivées")
	    }));
	    /*Array.push(sel.options, (new Element('option', {
		'value': '0',
		'text': ch_t('arkeogis', "Requêtes archivées")
	    })));*/
	    var index=1;
	    res.each(function(line) {
			sel.adopt(new Element('option', {
		    'value': line.id,
		    'text': line.name
		}));
		/*Array.push(sel.options, (new Element('option', {
		    'value': line.id,
		    'text': line.name
		})));*/
		if (typeOf(line) != undefined && line.id == id) {
			sel.selectedIndex=index;
		}
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
