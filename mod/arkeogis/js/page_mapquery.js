window.addEvent('domready', function() {
    /*
    var menutest = new PlusMinusItem("Choix de la période", '1', new PlusMinusMenu([
	new PlusMinusItem("Indéterminé", '1.1', null),
	new PlusMinusItem("Méolithique", '1.2', null),
	new PlusMinusItem("Age du Bronze", '1.3', new PlusMinusMenu([
	    new PlusMinusItem("Test1", '1.3.1', null),
	    new PlusMinusItem("Test2", '1.3.2', null),
	])),
	new PlusMinusItem("Age du Fer", '1.4', new PlusMinusMenu([
	    new PlusMinusItem("Fer indéterminé", '1.4.1', null),
	    new PlusMinusItem("Hallstatt", '1.4.2', null),
	    new PlusMinusItem("Hallstatt C", '1.4.3', null),
	])),
	new PlusMinusItem("Age du Plastique", '1.5', new PlusMinusMenu([
	    new PlusMinusItem("Plastique Mou", '1.5.1', null),
	    new PlusMinusItem("Plastique Dur", '1.5.2', null),
	    new PlusMinusItem("Le plastique c'est fantastique", '1.5.3', new PlusMinusMenu([
		new PlusMinusItem("Et le caoutchouc super mou", '1.5.3.1', null),
	    ])),
	])),
    ]));

    menutest.inject($('menutest'));
    */

/*
    var periodlist=[
	{
	    name: "Indéterminé",
	    parentid: null,
	    id: '1'
	},
	{
	    name: "Néolithique",
	    parentid: null,
	    id: '2'
	},
	{
	    name: "Age du Bronze",
	    parentid: null,
	    id: '3'
	},
	{
	    name: "Bronze Indéterminé (1800 – 800 av.JC)",
	    parentid: 3,
	    id: '4'
	},
	{
	    name: "Bronze ancien (BRA 1800 – 1500 av.JC)",
	    parentid: 3,
	    id: '5'
	},
	{
	    name: "BRA1",
	    parentid: 5,
	    id: '6'
	},
	{
	    name: "BRA1a",
	    parentid: 6,
	    id: '7'
	},
	{
	    name: "BRA1b",
	    parentid: 6,
	    id: '8'
	},
	{
	    name: "BRA2",
	    parentid: 5,
	    id: '9'
	},
	{
	    name: "BRA2a",
	    parentid: 9,
	    id: '10'
	},
	{
	    name: "BRA2b",
	    parentid: 9,
	    id: '11'
	},
    ];
*/
    new Request.JSON({
	'url': '/ajax/call/arkeogis/periodlist',
	'onSuccess': function(periodlist) {
	    var menutest = new PlusMinusItem("Choix de la période", null, null);
	    for (var i=0; i<periodlist.length; i++)
		menutest.addJsonItem(periodlist[i]);
	    menutest.inject($('menutest'));
	}
    }).get();

});

