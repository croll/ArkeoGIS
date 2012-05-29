//  -*- mode:js; tab-width:2; c-basic-offset:2; -*-
var Example = new Class({
	Implements: [Options,Events],
	options: {
		updateElement: 'slider-menu',
		paginate: 'true',
		onComplete: null
	},
	initialize: function(options) {
		this.setOptions(options);
		if ($(options.updateElement)) {
			this.setUp(options);
		}
	},
	setUp: function(options) {
		var tt= $(options.updateElement).getChildren('li').each( function(item, index) {
			if (item.hasClass('active')) {
				var tar = item.getChildren('a').get('href')[0];
			}
			this.setPage(options, item);	
		}.bind(this));
	},
	setPage: function(options,item) {
		var tar = item.getChildren('a').get('data-update')[0];
		item.addEvent('click', function(event) {
			event.stop();
			myex.setActive(options, item, tar);	
		});
		if ($(tar).hasClass('selected')) {
			$(tar).slide('in');

		} else {
			$(tar).slide('hide');

		}
	},
	setActive: function(options, item, tar) {
		item.getParents('ul.tabs li.tab').removeClass('active');
		item.addClass('active');
		$(tar).getParents('div .row').each(function(el) {
			if(el.hasClass('selected')) {
				el.removeClass('selected');
				el.slide('out');
			}
		});
		$(tar).slide('in');
		$(tar).addClass('selected');
	},
	display: function(options, item, tar) {

	}
});
var Manual = new Class({
	Implements: [Options,Events],
	options: {
		updateElement: 'manual-menu',
		paginate: 'true',
		onComplete: $empty
	},
	initialize: function(options) {
		this.setOptions(options);
		if ($(options.updateElement)) {
			this.setUp(options);
		}
	},
	setUp: function(options) {
		var mypage = new Page();
		var st= $(options.updateElement).getChildren('li').each( function(item, index) {
			if (item.hasClass('active')) {
				var tar = item.getChildren('a').get('href')[0];
				this.display(options, mypage, tar);	
			}
			this.setPage(options,item, mypage);
		}.bind(this));
	},
	setPage: function(options, item, mypage){
		var tar = item.getChildren('a').get('href')[0];
		item.addEvent('click', function(event) {
			event.stop();
			myman.setActive(options,item);
			myman.display(options,mypage,tar);
		});
	},
	setActive: function(options, item) {
		item.getParents('ul.tabs li.tab').removeClass('active');
		item.addClass('active');
	},
	display: function(options, mypage, tar) {
		$('content').fade('hide');
		mypage.render(tar,'content', 'fr_FR');
	}
});
var Directory = new Class({
	Implements: [Options,Events],
	options: {
		dbElements: '.dbnames',
		paginate: 'true',
		onComplete: null
	},
	initialize: function(options) {
		this.setOptions(options);
		$$('.dbnames').each(function(item, index) {
			var list = item.get('html').split(',');
			item.set('html', '');
			var res= new Element('div');
			list.each(function(el) {
				if (el != '') {
					var db= new Element('a',{href: '#', 'class': 'dblinks', html: el});
					db.addEvent('click', function() {
						event.preventDefault(); 
						mydir.getDesc(el);
					});
					res.adopt(db);
				}
			});
			item.adopt(res);
		});
	},
	getDesc: function(dbname) {
		console.log(dbname);
		new Request.JSON({
			'url': '/ajax/call/arkeogis/getDbDesc',
			'onSuccess': function(resJSON) {
				mydir.displayDesc(dbname,resJSON);
			}
		}).get({'dbname': dbname});


	},
	displayDesc: function(dbname, desc) {
		dmod.setTitle(dbname).setBody(desc).show();
	}
});
