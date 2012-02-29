window.addEvent('domready', function() {

    /* initialization of plusminus menus */
    arkeo_menu={};

    arkeo_menu.db = new PlusMinusItem("Choix de la base", null, null);
    for (var i=0; i<menus.db.length; i++)
	arkeo_menu.db.addJsonItem(menus.db[i]);
    arkeo_menu.db.inject($('menu_db'));

    arkeo_menu.period = new PlusMinusItem("Choix de la période", null, null);
    for (var i=0; i<menus.period.length; i++)
	arkeo_menu.period.addJsonItem(menus.period[i]);
    arkeo_menu.period.inject($('menu_period'));

    arkeo_menu.production = new PlusMinusItem("Choix production", null, null);
    for (var i=0; i<menus.production.length; i++)
	arkeo_menu.production.addJsonItem(menus.production[i]);
    arkeo_menu.production.inject($('menu_production'));

    arkeo_menu.realestate = new PlusMinusItem("Choix immobilier", null, null);
    for (var i=0; i<menus.realestate.length; i++)
	arkeo_menu.realestate.addJsonItem(menus.realestate[i]);
    arkeo_menu.realestate.inject($('menu_realestate'));

    arkeo_menu.furniture = new PlusMinusItem("Choix mobilier", null, null);
    for (var i=0; i<menus.furniture.length; i++)
	arkeo_menu.furniture.addJsonItem(menus.furniture[i]);
    arkeo_menu.furniture.inject($('menu_furniture'));


    /* initialization of menus centroid, knowledge, occupation */
    
    new MultiselectPopup({
	buttonelem: $('menu-centroid-button')
    },{
	list: $('menu-centroid-content')
    });

    new MultiselectPopup({
	buttonelem: $('menu-knowledge-button')
    },{
	list: $('menu-knowledge-content')
    });

    new MultiselectPopup({
	buttonelem: $('menu-occupation-button')
    },{
	list: $('menu-occupation-content')
    });



    /* initialization of buttons "afficher la carte" and "afficher le tableur" */

    function buildSelectionObject() {
	var result={};

	// get selections of plusminus menus

	result.db_include = arkeo_menu.db.getSelection('+');
	result.period_include = arkeo_menu.period.getSelection('+');
	result.production_include = arkeo_menu.production.getSelection('+');
	result.realestate_include = arkeo_menu.realestate.getSelection('+');
	result.furniture_include = arkeo_menu.furniture.getSelection('+');
	result.db_exclude = arkeo_menu.db.getSelection('-');
	result.period_exclude = arkeo_menu.period.getSelection('-');
	result.production_exclude = arkeo_menu.production.getSelection('-');
	result.realestate_exclude = arkeo_menu.realestate.getSelection('-');
	result.furniture_exclude = arkeo_menu.furniture.getSelection('-');


	// get selections of multiselect menus

	result.centroid=[];
	var elems=$('menu-centroid-content').getElements('.selected');
	elems.each(function(el) {
	    result.centroid.push(el.getProperty('multivalue'));
	});

	result.knowledge=[];
	var elems=$('menu-knowledge-content').getElements('.selected');
	elems.each(function(el) {
	    result.knowledge.push(el.getProperty('multivalue'));
	});

	result.occupation=[];
	var elems=$('menu-occupation-content').getElements('.selected');
	elems.each(function(el) {
	    result.occupation.push(el.getProperty('multivalue'));
	});


	return result;
    }

    $('btn-show-the-map').addEvent('click', function() {
	var form=buildSelectionObject();
	new Request.JSON({
	    'url': '/ajax/call/arkeogis/showthemap',
	    'onSuccess': function(res) {
		alert(res);
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
		$('select-savedqueries').selectedIndex=0;
		arkeo_menu.db.setSelection(res.db_include, res.db_exclude);
		arkeo_menu.period.setSelection(res.period_include, res.period_exclude);
		arkeo_menu.production.setSelection(res.production_include, res.production_exclude);
		arkeo_menu.realestate.setSelection(res.realestate_include, res.realestate_exclude);
		arkeo_menu.furniture.setSelection(res.furniture_include, res.furniture_exclude);
	    }
	}).post({
	    'queryid': $('select-savedqueries').get('value')
	});
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

function display_query(query) {
    var html = $('query-display').clone();
    html.setStyles({
	display: ''
    });

    html.getElement('.query_num').set('text', 1);
    ['db', 'period', 'production', 'realestate', 'furniture'].each(function(m) {
	var result=[];
	if (arkeo_menu[m].submenu.buildPath(query[m+'_include'], query[m+'_exclude'], result)) {
	    var queryfilter_html=$('query-filter').clone();
	    queryfilter_html.setStyles({
		display: ''
	    });
	    queryfilter_html.getElement('div.filtername span').set('text', m);

	    div=new Element('div', {
		class: 'filtercontent'
	    });
	    buildFilterLines(result, 0, div);
	    div.inject(queryfilter_html);
	    queryfilter_html.inject(html.getElement('.query-filters'));
	}
    });

    html.getElement('.btn-save-query').addEvent('click', function() {
	new Request.JSON({
	    'url': '/ajax/call/arkeogis/saveQuery',
	    'onSuccess': function(res) {
		populateSavedQueriesMenu();
		alert("Query saved !");
	    }
	}).post({
	    'name': html.getElement('.input-save-query').get('value'),
	    'query': JSON.encode(query)
	});
    });


    html.inject($('querys'));
}

function populateSavedQueriesMenu() {
    new Request.JSON({
	'url': '/ajax/call/arkeogis/listQueries',
	'onSuccess': function(res) {
	    var sel=$('select-savedqueries');
	    sel.options = Array.slice(sel.options, 0,1);
	    res.each(function(line) {
		Array.push(sel.options, (new Element('option', {
		    'value': line.id,
		    'text': line.name
		})));
	    });
	}
    }).get();
}
