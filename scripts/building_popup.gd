
extends Popup



var format 

func _ready():
	format = get_node('/root/formats')


func _on_Popup_about_to_show():
	var building = get_parent().building
	var name = building.name
	var level = str(building.level)
	var costs = building.get_cost(building.level+1)
	var desc = building.description
	
	var panel = get_node('Panel')
	var costpan = get_node('Panel/costs')
	
	panel.get_node('name').set_text(name)
	panel.get_node('level').set_text(str("Level ",level))
	panel.get_node('description').clear()
	panel.get_node('description').add_text(desc)
	
	costpan.get_node('metal_cost').set_text(format._number(costs['metal']))
	
	var pos = get_parent().get_global_pos() + get_parent().get_size()

	set_pos(pos)