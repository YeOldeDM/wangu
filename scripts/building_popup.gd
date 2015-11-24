
extends Popup



var format 
var building

func _ready():
	format = get_node('/root/formats')


func _on_Popup_about_to_show():
	#Get
	building = get_parent().building
	var panel = get_node('Panel')
	var costpan = get_node('Panel/costs')
	
	#Set
	var name = building.name
	var level = str(building.level)
	var costs = building.get_cost(building.level+1)
	var desc = building.description

	#Show
	panel.get_node('name').set_text(name)
	panel.get_node('level').set_text(str("Level ",level))
	panel.get_node('description').clear()
	panel.get_node('description').add_text(desc)
	
	costpan.get_node('metal_cost').set_text(format._number(costs['metal']))
	costpan.get_node('crystal_cost').set_text(format._number(costs['crystal']))
	costpan.get_node('nanium_cost').set_text(format._number(costs['nanium']))
	costpan.get_node('tech_cost').set_text(format._number(costs['tech']))
	
	#get position for popup (lower right corner of parent)
	var pos = get_parent().get_global_pos() + get_parent().get_size()
	var res = get_node('/root').get_rect()
	
	#clamp popup to screen edges
	pos.x = clamp(pos.x, 0, res.size.width - panel.get_size().x)
	pos.y = clamp(pos.y, 0, res.size.height - panel.get_size().y)
	#set that pos!
	set_pos(pos)