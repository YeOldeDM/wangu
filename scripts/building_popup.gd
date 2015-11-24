
extends Popup



var format 
var building

func _ready():
	format = get_node('/root/formats')


func _on_Popup_about_to_show():
	building = get_parent().building
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
	costpan.get_node('crystal_cost').set_text(format._number(costs['crystal']))
	costpan.get_node('nanium_cost').set_text(format._number(costs['nanium']))
	costpan.get_node('tech_cost').set_text(format._number(costs['tech']))
	
	var pos = get_parent().get_global_pos() + get_parent().get_size()

	set_pos(pos)