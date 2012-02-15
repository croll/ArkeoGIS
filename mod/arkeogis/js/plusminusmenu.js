var PlusMinusMenu = new Class({
    Implements: Events,
    initialize: function(html_element, menumodel) {
	this.menumodel=menumodel;
	this.mainhtml_element=html_element;
	var html=this.mkmenu(this.menumodel, null, 0, 0);
	html.inject(html_element);
    },

    mkmenu: function(menumodel, parent, html_left, html_top) {
	var me=this;
	var popup=new Element('div', {
	    class: 'pmmenu-popup',
	});
	
	if (parent) {
	    var title=new Element('div', {
		class: 'pmmenu-title',
		text: parent.text,
	    });
	    title.inject(popup);
	    var title_sub=new Element('div', {
		class: 'pmmenu-title-sub',
	    });
	    title_sub.inject(title);

	    var tools=new Element('div', {
		class: 'pmmenu-tools',
		text: "Sélection",
	    });
	    tools.inject(popup);
	    var tools_all=new Element('button', {
		text: 'TOUS',
	    });
	    tools_all.inject(tools);
	    var tools_none=new Element('button', {
		text: 'AUCUN',
	    });
	    tools_none.inject(tools);
	}

	// convert object to array...
	var a_menumodel = [];
	for (var menumodel_i=0; menumodel[menumodel_i]; menumodel_i++)
	    a_menumodel[menumodel_i]=menumodel[menumodel_i];

	a_menumodel.each(function(model_elem) {
	    menumodel.html_openedsubmenu=null;
	    menumodel.model_openedsubmenu=null;

	    var e=new Element('div', {
		class: 'pmmenu-elem',
		text: model_elem.text,
	    });
	    model_elem.html_elem=e;
	    var sub=new Element('div', {
		class: 'pmmenu-sub',
	    });
	    sub.inject(e);
	    var sel=new Element('div', {
		class: 'pmmenu-sel',
	    });
	    sel.inject(e);
	    if (model_elem.submenu) {
		sub.addClass('pmmenu-havesubmenu');
		if (!parent) {
		    e.addEvent('click', function() {
			if (!menumodel.html_openedsubmenu) {
			    menumodel.model_openedsubmenu=model_elem.submenu;
			    menumodel.html_openedsubmenu=me.mkmenu(model_elem.submenu, model_elem, html_left, html_top);
			    menumodel.html_openedsubmenu.addClass('pmmenu-float');
			    menumodel.html_openedsubmenu.inject(me.mainhtml_element, false);
			} else {
			    me.closeSubMenu(menumodel);
			}
		    });
		} else {
		    e.addEvent('mouseenter', function() {
			me.closeSubMenu(menumodel);
			menumodel.model_openedsubmenu=model_elem.submenu;
			menumodel.html_openedsubmenu=me.mkmenu(model_elem.submenu, model_elem, html_left+250, html_top);
			menumodel.html_openedsubmenu.addClass('pmmenu-float');
			menumodel.html_openedsubmenu.set('styles', {
			    left: (html_left+250)+'px',
			    top: html_top+'px',
			});
			menumodel.html_openedsubmenu.inject(me.mainhtml_element);
		    });
		}
	    }

	    if (parent && !model_elem.submenu) {
		e.addEvent('click', function() {
		    if (model_elem.selected == '+') {
			model_elem.selected='-';
		    } else if (model_elem.selected == '-') {
			model_elem.selected='';
		    } else {
			model_elem.selected='+';
		    }
		    me.drawSelection(me.menumodel, model_elem.selected);
		});
	    }
	    
	    e.inject(popup);
	});
	return popup;
    },

    closeSubMenu: function(model) {
	var me=this;
	if (!model.model_openedsubmenu) return;
	me.closeSubMenu(model.model_openedsubmenu);
	for (var menumodel_i=0; model[menumodel_i]; menumodel_i++) {
	    var model_elem=model[menumodel_i];
	    if (model_elem.html_elem) {
		model_elem.html_elem.destroy();
		model_elem.html_elem=null;
	    }
	}
	model.model_openedsubmenu=null;
	model.html_openedsubmenu.destroy();
	model.html_openedsubmenu=null;
    },

    drawSelections: function(model) {
	var me=this;

	// convert object to array...
	var a_menumodel = [];
	for (var menumodel_i=0; menumodel[menumodel_i]; menumodel_i++)
	    a_menumodel[menumodel_i]=menumodel[menumodel_i];

	var result='';
	a_menumodel.each(function(model_elem) {
	    if (model_elem.submenu) {
		var selected = me.drawSelection(model_elem.submenu);
		if (result == '') result=selected;
		else if (result == '+' && selected != '+') result='.';
		else if (result == '-' && selected != '-') result='.';
		me.drawSelection(model_elem, selected);
	    } else {
		if (model_elem.selected == '+')
		    result=(result == '+' || result == '') ? '+' : '.';
		else if (model_elem.selected == '-')
		    result=(result == '-' || result == '') ? '-' : '.';
		me.drawSelection(model_elem, model_elem.selected);
	    }
	});
	return result;
    },

    drawSelection: function(model_elem, selected) {
	if (!model_elem.html_elem) return;
	var sel=model_elem.html_elem.getElement('.pmmenu-sel');

	if (selected == '+') {
	    sel.removeClass('pmmenu-plus');
	    sel.addClass('pmmenu-minus');
	} else if (selected == '-') {
	    sel.removeClass('pmmenu-minus');
	    sel.removeClass('pmmenu-plus');
	} else {
	    sel.removeClass('pmmenu-minus');
	    sel.addClass('pmmenu-plus');
	}
    },
});
