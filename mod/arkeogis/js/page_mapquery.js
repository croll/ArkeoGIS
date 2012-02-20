window.addEvent('domready', function() {

    /* initialization of plusminus menus */

    new Request.JSON({
	'url': '/ajax/call/arkeogis/periodlist',
	'onSuccess': function(periodlist) {
	    var menu = new PlusMinusItem("Choix de la période", null, null);
	    for (var i=0; i<periodlist.length; i++)
		menu.addJsonItem(periodlist[i]);
	    menu.inject($('menu_period'));
	}
    }).get();

    new Request.JSON({
	'url': '/ajax/call/arkeogis/productionlist',
	'onSuccess': function(productionlist) {
	    var menu = new PlusMinusItem("Choix production", null, null);
	    for (var i=0; i<productionlist.length; i++)
		menu.addJsonItem(productionlist[i]);
	    menu.inject($('menu_production'));
	}
    }).get();

    new Request.JSON({
	'url': '/ajax/call/arkeogis/realestatelist',
	'onSuccess': function(realestatelist) {
	    var menu = new PlusMinusItem("Choix immobilier", null, null);
	    for (var i=0; i<realestatelist.length; i++)
		menu.addJsonItem(realestatelist[i]);
	    menu.inject($('menu_realestate'));
	}
    }).get();

    new Request.JSON({
	'url': '/ajax/call/arkeogis/furniturelist',
	'onSuccess': function(furniturelist) {
	    var menu = new PlusMinusItem("Choix mobilier", null, null);
	    for (var i=0; i<furniturelist.length; i++)
		menu.addJsonItem(furniturelist[i]);
	    menu.inject($('menu_furniture'));
	}
    }).get();


    /* initialization of menus centroide, connaissance, occupation */
    
    new MultiselectPopup({
	buttonelem: $('menu-centroide-button')
    },{
	list: $('menu-centroide-content')
    });

    new MultiselectPopup({
	buttonelem: $('menu-connaissance-button')
    },{
	list: $('menu-connaissance-content')
    });

    new MultiselectPopup({
	buttonelem: $('menu-occupation-button')
    },{
	list: $('menu-occupation-content')
    });
});

