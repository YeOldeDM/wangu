
extends Control

var building_button = preload('res://building.xml')

var buildings = []

func _ready():
	for i in range(6):
		var shack = Shack()
		add_building(shack)


func add_building(building):
	buildings.append(building)
	building.draw_button()
	get_node('Buildings/cont/Buildings/cont/cont').add_child(building)

func Shack():
	var building = building_button.instance()
	building._ready()
	building.set_building_name("Shack")
	var desc = "The humble Shack provides storage, supplies, and maintenance for your Bots.\n Each Shack allows you to control up to 5 Bots."
	building.set_building_description(desc)
	building.set_cost(25,0,0,0)
	building.add_production('population',5)
	return building