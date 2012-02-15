var PlusMinusMenu = new Class({
    Implements: Events,

    html_element: null,
    parent_item: null,
    content: [],

    initialize: function(content) {
	var me=this;
	this.content = content;
	content.each(function(elem) {
	    elem.parent_menu=me;
	    elem.addEvent('selection', function(e) {
		var counts={plus: 0, minus: 0, mixed: 0, empty: 0};
		me.content.each(function(el) {
		    if (el.selected == '') counts.empty++;
		    else if (el.selected == '.') counts.mixed++;
		    else if (el.selected == '+') counts.plus++;
		    else if (el.selected == '-') counts.minus++;
		});
		counts.total=counts.plus + counts.minus + counts.mixed + counts.empty;
		if (counts.plus == counts.total) me.parent_item.setSelected('+', false);
		else if (counts.minus == counts.total) me.parent_item.setSelected('-', false);
		else if (counts.empty == counts.total) me.parent_item.setSelected('', false);
		else me.parent_item.setSelected('.', false);
	    });
	});
    },

    inject: function(to_html_elem) {
	var me=this;
	me.html_element=new Element('div', {
	    class: 'pmmenu-popup',
	});
	me.html_element.inject(to_html_elem);
	
	var title=new Element('div', {
	    class: 'pmmenu-title',
	    text: me.parent_item.model.text,
	});
	title.inject(me.html_element);
	var title_sub=new Element('div', {
	    class: 'pmmenu-title-sub',
	});
	title_sub.inject(title);
	
	var tools=new Element('div', {
	    class: 'pmmenu-tools',
	    text: "Sélection",
	});
	tools.inject(me.html_element);
	var tools_all=new Element('button', {
	    class: 'select-all',
	    text: 'TOUS',
	});
	tools_all.addEvent('click', function(e) {
	    me.parent_item.setSelected('+', true);
	});
	tools_all.inject(tools);
	var tools_none=new Element('button', {
	    class: 'select-none',
	    text: 'AUCUN',
	});
	tools_none.addEvent('click', function(e) {
	    me.parent_item.setSelected('', true);
	});
	tools_none.inject(tools);

	me.content.each(function(item) {
	    item.inject(me.html_element);
	});
    },

    close: function() {
	this.close_submenus();
	if (this.html_element) {
	    this.html_element.destroy();
	    this.html_element=null;
	}
    },

    close_submenus: function() {
	var me=this;
	me.content.each(function(item) {
	    item.close_submenu();
	});
    },
    
    isOpened: function() {
	return this.html_element ? true : false;
    }

});

var PlusMinusItem = new Class({
    Implements: Events,

    html_element: null,
    model: {
	text: '',
	value: '',
    },
    submenu: null,
    parent_menu: null,
    selected: '',

    initialize: function(text, value, submenu) {
	this.model.text=text;
	this.model.value=value;
	this.submenu=submenu;
	if (submenu) submenu.parent_item=this;
    },

    close_submenu: function() {
	if (!this.submenu) return;
	this.submenu.close();
    },

    inject: function(to_html_elem) {
	var me=this;
	me.html_element=new Element('div', {
	    class: 'pmmenu-item',
	    text: me.model.text,
	});
	me.html_element.inject(to_html_elem);
	var sub=new Element('div', {
	    class: 'pmmenu-sub',
	});
	sub.inject(me.html_element);
	var sel=new Element('div', {
	    class: 'pmmenu-sel',
	});
	sel.inject(me.html_element);
	if (me.submenu) {
	    sub.addClass('pmmenu-havesubmenu');
	    if (!me.parent_menu) {
		me.html_element.addEvent('click', function() {
		    if (me.submenu.isOpened()) {
			me.submenu.close();
		    } else {
 			var back=new Element('div', {
			    styles: {
				position: 'absolute',
				left: 0,
				right: 0,
				top: 0,
				bottom: 0,
				'z-index': 1999,
			    }
			});
			back.inject($$('body')[0]);
			back.addEvent('click', function(e) {
			    me.submenu.close();
			    back.destroy();
			});
			
			me.submenu.inject(to_html_elem);
			me.submenu.html_element.set('styles', {
			    left: 0
			});
		    }
		});
	    } else {
		me.html_element.addEvent('mouseenter', function() {
		    me.parent_menu.close_submenus();
		    me.submenu.inject(to_html_elem);
		});
	    }
	}
	
	if (me.parent_menu && !me.submenu) {
	    me.html_element.addEvent('click', function() {
		if (me.selected == '+') {
		    me.setSelected('-', false);
		} else if (me.selected == '-') {
		    me.setSelected('', false);
		} else {
		    me.setSelected('+', false);
		}
	    });
	}
	me.drawSelection();
    },
    
    drawSelection: function() {
	var me=this;
	if (!me.html_element) return;
	var sel=me.html_element.getElement('.pmmenu-sel');

	if (me.selected == '+') {
	    sel.removeClass('pmmenu-mixed');
	    sel.removeClass('pmmenu-minus');
	    sel.addClass('pmmenu-plus');
	} else if (me.selected == '-') {
	    sel.removeClass('pmmenu-mixed');
	    sel.removeClass('pmmenu-plus');
	    sel.addClass('pmmenu-minus');
	} else if (me.selected == '.') {
	    sel.removeClass('pmmenu-plus');
	    sel.removeClass('pmmenu-minus');
	    sel.addClass('pmmenu-mixed');
	} else {
	    sel.removeClass('pmmenu-mixed');
	    sel.removeClass('pmmenu-minus');
	    sel.removeClass('pmmenu-plus');
	}
    },

    setSelected: function(selected, recurse) {
	var me=this;
	if (recurse && me.submenu) {
	    me.submenu.content.each(function(el) {
		el.setSelected(selected, true);
	    });
	} else if (this.selected != selected) {
	    this.selected=selected;
	    this.fireEvent('selection', {
		'selected': me.selected,
	    });
	    me.drawSelection();
	}
    },
});




