window.addEvent('domready', function() {
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

});

