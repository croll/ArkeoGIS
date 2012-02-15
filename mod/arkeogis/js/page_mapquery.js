window.addEvent('domready', function() {
    var pmmenu=new PlusMinusMenu($('menutest'), {
	0: {
	    text: "Choix de la période",
	    value: 0,
	    submenu : {
		0: {
		    text: "Indéterminé",
		    value: 1,
		},
		1: {
		    text: "Méolithique",
		    value: 2,
		},
		2: {
		    text: "Age du Bronze",
		    value: 3,
		    submenu: {
			0: {
			    text: "Test1",
			    value: 12,
			},
			1: {
			    text: "Test2",
			    value: 13,
			},
		    },
		},
		3: {
		    text: "Age du Fer",
		    value: 4,
		    submenu: {
			0: {
			    text: "Fer indéterminé",
			    value: 5,
			},
			1: {
			    text: "Hallstatt",
			    value: 6,
			},
			2: {
			    text: "Hallstatt C",
			    value: 7,
			    submenu: {
			    },
			}
		    },
		},
		4: {
		    text: "Age du Plastique",
		    value: 4,
		    submenu: {
			0: {
			    text: "Plastique mou",
			    value: 5,
			},
			1: {
			    text: "Plastique dur",
			    value: 6,
			},
			2: {
			    text: "Le plastique c'est fantastique",
			    value: 7,
			    submenu: {
				0: {
				    text: "Et le caoutchouc super mou",
				    value: 23,
				},
			    },
			}
		    },
		},
	    },
	},
    });
});
