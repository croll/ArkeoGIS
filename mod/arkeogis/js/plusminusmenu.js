var PlusMinusMenu =new Class({
    Implements: Events,
    initialize: function(html_element, menumodel) {
	this.menumodel=menumodel;
	this.mainhtml_element=html_element;
	var html=this.mkmenu(this.menumodel, true, 0);
	html.inject(html_element);
    },

    mkmenu: function(menumodel, root, html_leftoffset) {
	var me=this;
	var popup=new Element('div', {
	    class: 'pmmenu-popup',
	});
	
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
		if (root) {
		    e.addEvent('click', function() {
			if (!menumodel.html_openedsubmenu) {
			    menumodel.model_openedsubmenu=model_elem.submenu;
			    menumodel.html_openedsubmenu=me.mkmenu(model_elem.submenu, false, html_leftoffset);
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
			menumodel.html_openedsubmenu=me.mkmenu(model_elem.submenu, false, html_leftoffset+250);
			menumodel.html_openedsubmenu.addClass('pmmenu-float');
			menumodel.html_openedsubmenu.set('styles', {
			    left: (html_leftoffset+250)+'px',
			});
			menumodel.html_openedsubmenu.inject(me.mainhtml_element);
		    });
		}
	    }

	    if (!root && !model_elem.submenu) {
		e.addEvent('click', function() {
		    if (model_elem.selected == '+') {
			model_elem.selected='-';
			sel.removeClass('pmmenu-plus');
			sel.addClass('pmmenu-minus');
		    } else if (model_elem.selected == '-') {
			model_elem.selected='';
			sel.removeClass('pmmenu-minus');
			sel.removeClass('pmmenu-plus');
		    } else {
			model_elem.selected='+';
			sel.removeClass('pmmenu-minus');
			sel.addClass('pmmenu-plus');
		    }
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
	model.model_openedsubmenu=null;
	model.html_openedsubmenu.destroy();
	model.html_openedsubmenu=null;
    },

});
