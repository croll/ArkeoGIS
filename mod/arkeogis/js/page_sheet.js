window.addEvent('domready', function() {
    new Request.JSON({
	'url': '/ajax/call/arkeogis/showthesheet',
	'onSuccess': function(res) {
	    display_sheet(res);
	    window.print();
	}
    }).post(decodeURI(new URI().get('fragment')));
});