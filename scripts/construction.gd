
extends Control

var building_button = load('res://building.xml')

var buildings = []

func _ready():
	for i in range(1):
		var shack = Shack()
		add_building(shack)
		var warehouse = Warehouse()
		add_building(warehouse)


func add_building(building):
	buildings.append(building)
	building.draw_button()
	get_node('Buildings/cont/Buildings/cont/cont').add_child(building)


#BUILDINGS#

func Shack():
	var b = building_button.instance()
	b.building = b.Building.new()
	b.building.name = "Shack"
	b.building.level = 0
	b.building.description = "Meager accomidations for your bots.\n Each Shack increases your maximum population by 3 Bots."
	b.building.add_production('population',3)
	b.building.base_cost['metal'] = 45
	return b
	
func Warehouse():
	var b = building_button.instance()
	b.building = b.Building.new()
	b.building.name = "Warehouse"
	b.building.level = 0
	b.building.description = "Storage, service bays, and other accomidations for robotic life-forms. Each Warehouse increases your population by 5 Bots."
	b.building.add_production('population', 5)
	b.building.base_cost['metal'] = 75
	b.building.base_cost['crystal'] = 45
	return b