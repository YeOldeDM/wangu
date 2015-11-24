
extends Control

var building_button = preload('res://building.xml')

var buildings = []

func _ready():
	for i in range(1):
		var shack = Shack()
		add_building(shack)


func add_building(building):
	buildings.append(building)
	building.draw_button()
	get_node('Buildings/cont/Buildings/cont/cont').add_child(building)

func Shack():
	var b = building_button.instance()
	b._ready()
	b.building.name = "Shack"
	b.building.description = "Meager accomidations for your bots.\n Each Shack increases your maximum population by 5 Bots."
	b.building.add_production('population',5)
	b.building.base_cost['Metal'] = 75
	
	return b