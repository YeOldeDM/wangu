
extends Control

var building_button = preload('res://building.xml')

var buildings = []

func _ready():
	for i in range(6):
		var shack = building_button.instance()
		shack._ready()
		shack.set_building_name("Shack")
		add_building(shack)


func add_building(building):
	buildings.append(building)
	building.draw_button()
	get_node('Buildings/cont/Buildings/cont/cont').add_child(building)
	