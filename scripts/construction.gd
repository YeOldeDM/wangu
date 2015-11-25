
extends Control



var building_button = load('res://building.xml')

var buildings = []
var facilities = []

func _ready():
	for i in range(1):
		var shack = Shack()
		add_building(shack)
		var hangar = Hangar()
		add_building(hangar)
		var cargo = CargoBay()
		add_building(cargo)
		
		var yard = Scrapyard()
		add_facility(yard)

func add_building(building):
	building.building.construction = self
	building.building.bank = get_node('/root/Game/Bank')
	buildings.append(building)
	building.draw_button()
	get_node('Buildings/cont/Buildings/cont/cont').add_child(building)
	
func add_facility(facility):
	facility.building.construction = self
	facility.building.bank = get_node('/root/Game/Bank')
	facilities.append(facility)
	facility.draw_button()
	get_node('Buildings/cont/Facilities/cont/cont').add_child(facility)
	

func set_population():
	var n = 0
	for b in buildings:
		if 'population' in b.building.base_production:
			n += b.building.get_production('population',b.building.level)
	get_node('/root/Game').population.set_max_pop(n)

func set_storage():
	var amts = {
		0:	0,
		1:	0,
		2:	0}

	for b in facilities:
		var a = b.building.get_storage()
		for i in range(3):
			amts[i] += a[i]
	get_node('/root/Game/Bank').set_storage(amts)

#BUILDINGS#

func Shack():
	var b = building_button.instance()
	b.building = b.Building.new()
	b.building.name = "Shack"
	b.building.level = 0
	b.building.description = "Meager accomidations for your bots.\n Each Shack increases your maximum population by 3 Bots."
	b.building.add_production('population',3)
	b.building.base_cost['metal'] = 25
	return b
	
func Hangar():
	var b = building_button.instance()
	b.building = b.Building.new()
	b.building.name = "Hangar"
	b.building.level = 0
	b.building.description = "Storage, service bays, and other accomidations for robotic life-forms. Each Hangar increases your population by 5 Bots."
	b.building.add_production('population', 5)
	b.building.base_cost['metal'] = 150
	b.building.base_cost['crystal'] = 80
	return b

func CargoBay():
	var b = building_button.instance()
	b.building = b.Building.new()
	b.building.name = "Cargo Bay"
	b.building.level = 0
	b.building.description = "Cozy accomidations. Cozy for a Bot, at least. Each Cargo Bay increases your max population by 10 Bots."
	b.building.add_production('population', 10)
	b.building.base_cost['metal'] = 450
	b.building.base_cost['crystal'] = 225
	b.building.base_cost['nanium'] = 100
	return b
	
func Scrapyard():
	var b = building_button.instance()
	b.building = b.StorageBuilding.new()
	b.building.name = "Scrapyard"
	b.building.level = 0
	b.building.description = "Storage space for salvaged Metal. Each level of Scrapyard doubles your holding capacity for Metal."
	b.building.base_storage[0] = 100

	return b