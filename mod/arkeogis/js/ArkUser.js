var ArkUser = new Class({
    Extends: User,

    setUser: function(resJSON, uid) {
        this.parent(resJSON, uid);
        var prev_row=$$('#user_edit input[name=full_name]').getParent();

        var myStructureRow = new Element('div', {'class': 'row'});
	var myStructureLabel = new Element('label', {'for': 'structure', 'html': 'Structure'});
	var myStructureName = new Element('input', {'type': 'text', 'name': 'structure', 'class': 'large'});
	myStructureRow.adopt(myStructureLabel);
	myStructureRow.adopt(myStructureName);

        prev_row.grab(myStructureRow, 'after');

	if (resJSON) {
            $$('#user_edit input[name=structure]').set('value', resJSON.mod.arkeogis.structure);
        }
    }
});
