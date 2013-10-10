var PlusMinusMenu = new Class({
    Implements: [ Events, Options ],

    html_element: null,
    parent_item: null,
    content: [],
    options: {
        multiselect: true
    },

    initialize: function(content, options) {
	this.setOptions(options);
	var me=this;

	if (content) content.each(function(item) {
	    me.addItem(item);
	});
    },

    addItem: function(item) {
	var me=this;
	this.content.push(item);
	item.parent_menu=this;
	item.addEvent('selection', function(e) {
	    var counts={plus: 0, minus: 0, mixed: 0, empty: 0};
	    me.content.each(function(el) {
		if (!el.options.enabled) { }
		else if (el.selected == '') counts.empty++;
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
    },

    addEventOnLeafs: function(a, b) {
        this.content.each(function(el) {
            el.addEventOnLeafs(a,b);
        });
    },

    inject: function(to_html_elem) {
	var me=this;
	me.html_element=new Element('div', {
	    'class': 'pmmenu-popup'
	});
	me.html_element.inject($$('body')[0]);

	me.html_element.setStyles({
	    left: (me.parent_item.parent_menu ? me.html_element.getStyle('left').toInt() : 0)
		+ to_html_elem.getPosition().x
		+ 'px',
	    top: to_html_elem.getPosition().y+'px'
	});

	var title=new Element('div', {
	    'class': 'pmmenu-title',
	    text: me.parent_item.model.text
	});
	var closebutton=new Element('div', {
	    'class': 'pmmenu-close',
	});
	closebutton.addEvent('click', function(e) {
	    me.close();
	});
	closebutton.inject(title);
	title.inject(me.html_element);
	var title_sub=new Element('div', {
	    'class': 'pmmenu-title-sub'
	});
	title_sub.inject(title);

	var tools=new Element('div', {
	    'class': 'pmmenu-tools',
	    text: ch_t('arkeogis', "Selection")
	});
	tools.inject(me.html_element);
	var tools_all=new Element('button', {
	    'class': 'select-all',
	    text: ch_t('arkeogis', 'ALL')
	});
	tools_all.addEvent('click', function(e) {
	    me.parent_item.setSelected('+', true);
	});
	tools_all.inject(tools);
	var tools_none=new Element('button', {
	    'class': 'select-none',
	    text: ch_t('arkeogis', 'NONE')
	});
	tools_none.addEvent('click', function(e) {
	    me.parent_item.setSelected('', true);
	});
	tools_none.inject(tools);

	me.content.each(function(item) {
	    item.inject(me.html_element);
	});


	tools.addEvent('mouseenter', function() {
	    me.close_submenus();
	});

   },

    close: function() {
	this.close_submenus();
	if (this.html_element) {
	    this.html_element.destroy();
	    this.html_element=null;
	}
	if (this.parent_item.back) {
	    this.parent_item.back.destroy();
	    this.parent_item.back=null;
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
    },

    buildPath: function(selection_plus, selection_minus, result) {
	var found=false;
	this.content.each(function(item) {
	    if (item.submenu) {
		var subresult=[];
		if (item.submenu.buildPath(selection_plus, selection_minus, subresult)) {
		    var model=Object.clone(item.model);
		    model.submenu=subresult;
		    result.push(model);
		    found=true;
		}
	    } else if (selection_plus.contains(item.model.value)) {
		var model=Object.clone(item.model);
		model.selection='+';
		result.push(model);
		found=true;
	    } else if (selection_minus.contains(item.model.value)) {
		var model=Object.clone(item.model);
		model.selection='-';
		result.push(model);
		found=true;
	    }
	});
	return found;
    }

});

var PlusMinusItem = new Class({
    Implements: [Events, Options],

    html_element: null,
    model: {
	text: '',
	value: ''
    },
    submenu: null,
    help: null,
    parent_menu: null,
    back: null,
    selected: '',
    options: {
	nominus: false,
	enabled: true
    },

    initialize: function(text, value, submenu, options) {
	this.setOptions(options);
	this.model.text=text;
	this.model.value=value;
	this.setSubMenu(submenu);
    },

    setSubMenu: function(submenu) {
	this.submenu=submenu;
	if (submenu) submenu.parent_item=this;
    },

    setHelp: function(help) {
	this.help=help;
	if (help) help.parent_item=this;
    },

    close_submenu: function() {
	if (this.submenu)
	    this.submenu.close();
	if (this.help)
	    this.help.close();
    },

    addEventOnLeafs: function(a, b) {
        if (this.submenu) {
            this.submenu.addEventOnLeafs(a, b);
        } else {
            this.addEvent(a,b);
        }
    },

    inject: function(to_html_elem) {
	var me=this;
	me.html_element=new Element('div', {
	    'class': 'pmmenu-item',
	    text: me.model.text
	});
	me.html_element.addClass(me.options.enabled ? 'pmmenu-enabled' : 'pmmenu-disabled');
	me.html_element.set('html', me.html_element.get('html').replace(/\n/g, '<br />'));
	me.html_element.inject(to_html_elem);
	var sub=new Element('div', {
	    'class': 'pmmenu-sub'
	});
	sub.inject(me.html_element);
	var sel=new Element('div', {
	    'class': 'pmmenu-sel'
	});
	sel.inject(me.html_element);
	if (me.submenu) {
	    sub.addClass('pmmenu-havesubmenu');
	    if (!me.parent_menu) {
		me.html_element.addClass('pmmenu-root');
		me.html_element.addEvent('click', function() {
		    if (me.submenu.isOpened()) {
			me.submenu.close();
		    } else {
 			me.back=new Element('div', {
			    styles: {
				position: 'absolute',
				left: 0,
				right: 0,
				top: 0,
				bottom: 0,
				'z-index': 1999
			    }
			});
			me.back.inject($$('body')[0], 'top');
			me.back.addEvent('click', function(e) {
			    me.submenu.close();
			    if (me.back) {
				me.back.destroy();
				me.back=null;
			    }
			});

			me.submenu.inject(to_html_elem);
		    }
		});
	    }
	}

	if (me.help) {
	    sub.addClass('pmmenu-havehelp');
	}


	me.html_element.addEvent('mouseenter', function() {
	    if (me.parent_menu) me.parent_menu.close_submenus();
	    if (me.submenu && me.parent_menu) me.submenu.inject(to_html_elem);
	    if (me.help) me.help.inject(to_html_elem);
	});

	if (me.parent_menu) {
	    me.html_element.addEvent('click', function() {
		if (me.selected == '+') {
		    me.setSelected(me.options.nominus ? '' : '-', me.submenu ? true : false);
		} else if (me.selected == '-') {
		    me.setSelected('', me.submenu ? true : false);
		} else {
		    me.setSelected('+', me.submenu ? true : false);
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
	    sel.addClass('pmmenu-sel-plus');
	    sel.removeClass('pmmenu-sel-minus');
	    sel.removeClass('pmmenu-sel-mixed');
	    me.html_element.addClass('pmmenu-item-plus');
	    me.html_element.removeClass('pmmenu-item-minus');
	    me.html_element.removeClass('pmmenu-item-mixed');
	} else if (me.selected == '-') {
	    sel.removeClass('pmmenu-sel-plus');
	    sel.addClass('pmmenu-sel-minus');
	    sel.removeClass('pmmenu-sel-mixed');
	    me.html_element.removeClass('pmmenu-item-plus');
	    me.html_element.addClass('pmmenu-item-minus');
	    me.html_element.removeClass('pmmenu-item-mixed');
	} else if (me.selected == '.') {
	    sel.removeClass('pmmenu-sel-plus');
	    sel.removeClass('pmmenu-sel-minus');
	    sel.addClass('pmmenu-sel-mixed');
	    me.html_element.removeClass('pmmenu-item-plus');
	    me.html_element.removeClass('pmmenu-item-minus');
	    me.html_element.addClass('pmmenu-item-mixed');
	} else {
	    sel.removeClass('pmmenu-sel-plus');
	    sel.removeClass('pmmenu-sel-minus');
	    sel.removeClass('pmmenu-sel-mixed');
	    me.html_element.removeClass('pmmenu-item-plus');
	    me.html_element.removeClass('pmmenu-item-minus');
	    me.html_element.removeClass('pmmenu-item-mixed');
	}
    },

    setSelected: function(selected, recurse) {
	var me=this;
	if (!me.options.enabled) return;
	if (recurse && me.submenu) {
	    me.submenu.content.each(function(el) {
		el.setSelected(selected, true);
	    });
	} else if (this.selected != selected) {
            if (me.parent_menu && !me.parent_menu.options.multiselect) {
                me.parent_menu.content.each(function(elem) {
                    if (elem != me) elem.setSelected('', recurse);
                });
            }
	    this.selected=selected;
	    this.fireEvent('selection', {
                'source': me,
		'selected': me.selected,
                'value': me.model.value
	    });
	    me.drawSelection();
	}
    },

    getSelection: function(c) {
	var result=[];
	if (this.submenu) {
	    this.submenu.content.each(function(item) {
		result=result.concat(item.getSelection(c));
	    });
	}
	if (this.selected == c)
	    result.push(this.model.value);
	return result;
    },

    searchValue: function(value) {
	if (this.model.value == value) return this;
	if (!this.submenu) return null;
	for (var i=0; i<this.submenu.content.length; i++) {
	    var found=this.submenu.content[i].searchValue(value);
	    if (found) return found;
	}
	return null;
    },

    setSelection: function(selection_plus, selection_minus) {
	if (this.submenu) {
	    this.submenu.content.each(function(item) {
		item.setSelection(selection_plus, selection_minus);
	    });
	} else if (selection_plus.contains(this.model.value)) {
	    this.setSelected('+', false);
	} else if (selection_minus.contains(this.model.value)) {
	    this.setSelected('-', false);
	} else {
	    this.setSelected('', false);
	}
    },

    /** special arkeogis use **/
    addJsonItem: function(jsitem) {
	var pitem=this.searchValue(jsitem.parentid);
	if (pitem) {
	    if (!pitem.submenu) pitem.setSubMenu(new PlusMinusMenu(null));
	    pitem.submenu.addItem(new PlusMinusItem(jsitem.name, jsitem.id, null, {
		enabled : typeof(jsitem.enabled) == 'undefined' ? true : jsitem.enabled
	    }));
	} else {
	    alert("id not found: "+jsitem.id);
	}
    }
});

var PlusMinusHelp = new Class({
    Implements: [Events, Options],

    html_element: null,
    htmlcontent: '',
    parent_item: null,
    options: {
    },

    initialize: function(htmlcontent, options) {
	this.setOptions(options);
	this.htmlcontent = htmlcontent;
    },

    addEventOnLeafs: function(a, b) {
    },

    inject: function(to_html_elem) {
	var me=this;
	me.html_element=new Element('div', {
	    'class': 'pmmenu-help',
	});
	me.html_element.inject($$('body')[0]);

	me.html_element.setStyles({
	    left: (me.parent_item.parent_menu ? me.html_element.getStyle('left').toInt() : 0)
		+ to_html_elem.getPosition().x
		+ 'px',
	    top: to_html_elem.getPosition().y+'px'
	});

	var title=new Element('div', {
	    'class': 'pmmenu-title',
	    text: me.parent_item.model.text
	});
	var closebutton=new Element('div', {
	    'class': 'pmmenu-close',
	});
	closebutton.addEvent('click', function(e) {
	    me.close();
	});
	closebutton.inject(title);
	title.inject(me.html_element);
	var title_sub=new Element('div', {
	    'class': 'pmmenu-title-sub'
	});
	title_sub.inject(title);

	var content=new Element('div', {
	    'class': 'pmmenu-help-content',
	    'html': me.htmlcontent
	});
	content.inject(me.html_element);
    },

    close: function() {
	if (this.html_element) {
	    this.html_element.destroy();
	    this.html_element=null;
	}
    }

});
