window.addEvent('domready', function() {
if ($('slider-menu')) {
	var tt= $('slider-menu').getChildren('li').each( function(item, index) {
		var tar = item.getChildren('a').get('data-update')[0];
		item.addEvent('click', function(event) {
			event.stop();
			console.log(tar);
			$(tar).getParents('div .row').each(function(el) {
				if(el.hasClass('active')) {
					el.removeClass('active');
					el.slide('out');
				}
			});
			$(tar).slide('in');
			$(tar).addClass('active');
		});
		if ($(tar).hasClass('active')) {
			$(tar).slide('in');

		} else {
			$(tar).slide('hide');

		}
	});
}
if ($('manual-menu')) {
	var mypage = new Page();
	mypage.render('presentation','presentation', 'fr_FR');
	$('presentation').fade('hide');
	var st= $('manual-menu').getChildren('li').each( function(item, index) {
		
		var tar = item.getChildren('a').get('href')[0];
		item.addEvent('click', function(event) {
			event.stop();
			console.log(tar);
			$('content').fade('hide');
			mypage.render(tar,'content', 'fr_FR');
		});
		
	});

}
});
