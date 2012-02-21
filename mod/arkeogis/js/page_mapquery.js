window.addEvent('domready', function() {

    /* initialization of plusminus menus */

    new Request.JSON({
	'url': '/ajax/call/arkeogis/dblist',
	'onSuccess': function(dblist) {
	    arkeo_menu_db = new PlusMinusItem("Choix de la base", null, null);
	    for (var i=0; i<dblist.length; i++)
		arkeo_menu_db.addJsonItem(dblist[i]);
	    arkeo_menu_db.inject($('menu_db'));
	}
    }).get();

    new Request.JSON({
	'url': '/ajax/call/arkeogis/periodlist',
	'onSuccess': function(periodlist) {
	    arkeo_menu_period = new PlusMinusItem("Choix de la période", null, null);
	    for (var i=0; i<periodlist.length; i++)
		arkeo_menu_period.addJsonItem(periodlist[i]);
	    arkeo_menu_period.inject($('menu_period'));
	}
    }).get();

    new Request.JSON({
	'url': '/ajax/call/arkeogis/productionlist',
	'onSuccess': function(productionlist) {
	    arkeo_menu_production = new PlusMinusItem("Choix production", null, null);
	    for (var i=0; i<productionlist.length; i++)
		arkeo_menu_production.addJsonItem(productionlist[i]);
	    arkeo_menu_production.inject($('menu_production'));
	}
    }).get();

    new Request.JSON({
	'url': '/ajax/call/arkeogis/realestatelist',
	'onSuccess': function(realestatelist) {
	    arkeo_menu_realestate = new PlusMinusItem("Choix immobilier", null, null);
	    for (var i=0; i<realestatelist.length; i++)
		arkeo_menu_realestate.addJsonItem(realestatelist[i]);
	    arkeo_menu_realestate.inject($('menu_realestate'));
	}
    }).get();

    new Request.JSON({
	'url': '/ajax/call/arkeogis/furniturelist',
	'onSuccess': function(furniturelist) {
	    arkeo_menu_furniture = new PlusMinusItem("Choix mobilier", null, null);
	    for (var i=0; i<furniturelist.length; i++)
		arkeo_menu_furniture.addJsonItem(furniturelist[i]);
	    arkeo_menu_furniture.inject($('menu_furniture'));
	}
    }).get();


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

	result.period_include = arkeo_menu_period.getSelection('+');
	result.production_include = arkeo_menu_production.getSelection('+');
	result.realestate_include = arkeo_menu_realestate.getSelection('+');
	result.furniture_include = arkeo_menu_furniture.getSelection('+');
	result.period_exclude = arkeo_menu_period.getSelection('-');
	result.production_exclude = arkeo_menu_production.getSelection('-');
	result.realestate_exclude = arkeo_menu_realestate.getSelection('-');
	result.furniture_exclude = arkeo_menu_furniture.getSelection('-');


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
	    }
	}).post(form);
    });
});

