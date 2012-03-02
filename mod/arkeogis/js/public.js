window.addEvent('domready', function() {
if ($('slider-menu')) {
	var tt= $('slider-menu').getChildren('li').each( function(item, index) {
		var tar = item.getChildren('a').get('data-update')[0];
		item.addEvent('click', function(event) {
			event.stop();
			$(tar).getParents('div .row').each(function(el) {
				if(el.hasClass('selected')) {
					el.removeClass('selected');
					el.slide('out');
				}
			});
			$(tar).slide('in');
			$(tar).addClass('selected');
		});
		if ($(tar).hasClass('selected')) {
			$(tar).slide('in');

		} else {
			$(tar).slide('hide');

		}
	});
}
if ($('manual-menu')) {
	var mypage = new Page();
	var st= $('manual-menu').getChildren('li').each( function(item, index) {
		
		var tar = item.getChildren('a').get('href')[0];
		item.addEvent('click', function(event) {
			event.stop();
			$('content').fade('hide');
			mypage.render(tar,'content', 'fr_FR');
		});
		mypage.render('manuel_requetes','content', 'fr_FR');
		
	});
}
});
