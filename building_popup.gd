
extends PopupPanel




func _on_PopupPanel_about_to_show(name,level,description,cost):
	get_node('name').set_text(name)
	get_node('level').set_text(str("Level ",str(level)))
	get_node('text').clear()
	get_node('text').add_text(description)
	var costpan = get_node('costs')
	var form = get_node('/root/formats')
	costpan.get_node('metal_cost').set_text(form._number(cost['metal']))
	costpan.get_node('crystal_cost').set_text(form._number(cost['crystal']))
	costpan.get_node('nanium_cost').set_text(form._number(cost['nanium']))
	costpan.get_node('tech_cost').set_text(form._number(cost['tech']))