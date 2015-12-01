
extends Control

#################
#	GLOBALS		#
#################
var structures = {
	'Buildings':	[],
	'Facilities':	[],
	'Science':		[],
	'Equipment':	[]
				}

var buildings = []
var facilities = []
var sciences = []
var equipments = []

var building_button = load('res://building.xml')

#########################
#	PRIVATE FUNCTIONS	#
#########################
func _add_building(category, building):
	if 'construction' in building.building:
		building.building.construction = self
	if 'bank' in building.building:
		building.building.bank = get_node('/root/Game/Bank')
	if 'combat' in building.building:
		building.building.combat = get_node('/root/Game/combat')
	
	structures[category].append(building)
	var grid = str('Buildings/cont/'+category+'/cont/cont')
	grid.add_child(building)
	building.draw_button()

func _building_factory():
	pass
	#GENERIC FACTORY FUNC FOR DEFINING STRUCTURES
	#NEED GENERIC BUILDING CLASS FIRST
	
#########################
#	PUBLIC FUNCTIONS	#
#########################
func set_population():
	var n = 0
	for b in structures['Buildings']:
		if 'population' in b.building.base_production:
			n += b.building.get_production('population',b.building.level)
	get_node('/root/Game').population.set_max_pop(n)

func set_storage():
	var amts = {
		0:	0,
		1:	0,
		2:	0}

	for b in structures['Facilities']:
		var a = b.building.get_storage()
		for i in range(3):
			amts[i] += a[i]
	get_node('/root/Game/Bank').set_storage(amts)



#############
#	INIT	#
#############
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
		var caves = CrystalCaves()
		add_facility(caves)
		var bays = NanoBays()
		add_facility(bays)
		
		var metal = Metallurgy()
		add_science(metal)
		var tune = Attunement()
		add_science(tune)
		var synth = NanoSynth()
		add_science(synth)
		var know = Knowledge()
		add_science(know)
		var tact = Tactics()
		add_science(tact)

		var shields = Shields()
		add_equipment(shields)
		var claws = Claws()
		add_equipment(claws)
		var lasers = Lasers()
		add_equipment(lasers)
		var armor = Armor()
		add_equipment(armor)
		var hard = HardPlate()
		add_equipment(hard)


#################################################
#	REPLACE THIS CRAP WITH FACTORIES PLZ KTHX	#
#################################################
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
	
func add_science(science):
	science.building.construction = self
	science.building.bank = get_node('/root/Game/Bank')
	sciences.append(science)
	science.draw_button()
	get_node('Buildings/cont/Science/cont/cont').add_child(science)

func add_equipment(equip):
	equip.building.construction = self
	equip.building.bank = get_node('/root/Game/Bank')
	equip.building.combat = get_node('/root/Game/combat')
	equipments.append(equip)
	equip.draw_button()
	get_node('Buildings/cont/Equipment/cont/cont').add_child(equip)




#BOT HOUSING
func Shack():
	var b = building_button.instance()
	b.building = b.Building.new()
	b.building.name = "Shack"
	b.building.level = 0
	b.building.description = "Meager accomidations for your bots.\n Each Shack increases your maximum population by 3 Bots."
	b.building.add_production('population',3)
	b.building.base_cost['metal'] = 10
	return b
	
func Hangar():
	var b = building_button.instance()
	b.building = b.Building.new()
	b.building.name = "Hangar"
	b.building.level = 0
	b.building.description = "Storage, service bays, and other accomidations for robotic life-forms. Each Hangar increases your population by 5 Bots."
	b.building.add_production('population', 5)
	b.building.base_cost['metal'] = 60
	b.building.base_cost['crystal'] = 40
	return b

func CargoBay():
	var b = building_button.instance()
	b.building = b.Building.new()
	b.building.name = "Cargo Bay"
	b.building.level = 0
	b.building.description = "Cozy accomidations. Cozy for a Bot, at least. Each Cargo Bay increases your max population by 10 Bots."
	b.building.add_production('population', 10)
	b.building.base_cost['metal'] = 320
	b.building.base_cost['crystal'] = 150
	b.building.base_cost['nanium'] = 60
	return b

#RESOURCE STORAGE FACILITIES
func Scrapyard():
	var b = building_button.instance()
	b.building = b.StorageBuilding.new()
	b.building.name = "Scrapyard"
	b.building.level = 0
	b.building.description = "Storage space for salvaged Metal. Each level of Scrapyard doubles your holding capacity for Metal."
	b.building.base_storage[0] = 100
	return b

func CrystalCaves():
	var b = building_button.instance()
	b.building = b.StorageBuilding.new()
	b.building.name = "Crystal Caves"
	b.building.level = 0
	b.building.description = "Storage space for harvested Crystal. Each level of Caves doubles your holding capacity for Crystal."
	b.building.base_storage[1] = 100
	return b

func NanoBays():
	var b = building_button.instance()
	b.building = b.StorageBuilding.new()
	b.building.name = "Nano-Bays"
	b.building.level = 0
	b.building.description = "Storage space for Nanium. Each level of Nano-Bays doubles your holding capacity for Nanium."
	b.building.base_storage[2] = 100
	return b
	
#SCIENCE
func Metallurgy():
	var b = building_button.instance()
	b.building = b.BuffBuilding.new()
	b.building.name = "Metallurgy"
	b.building.description = "Increased knowledge of the nature of metals allows you to salvage the stuff faster."
	b.building.level = 0
	b.building.skill_buffed = 0
	b.building.base_cost[0] = 30
	b.building.base_cost[3] = 25
	return b

func Attunement():
	var b = building_button.instance()
	b.building = b.BuffBuilding.new()
	b.building.name = "Attunement"
	b.building.description = "Increased attunement to the vibration of Crystals allows you to harvest the stuff faster."
	b.building.level = 0
	b.building.skill_buffed = 1
	b.building.base_cost[0] = 20
	b.building.base_cost[1] = 30
	b.building.base_cost[3] = 30
	return b

func NanoSynth():
	var b = building_button.instance()
	b.building = b.BuffBuilding.new()
	b.building.name = "Nano-Synthesis"
	b.building.description = "Increased ability to synthesis Nanium allows you to mine the stuff faster."
	b.building.level = 0
	b.building.skill_buffed = 2
	b.building.base_cost[1] = 40
	b.building.base_cost[2] = 50
	b.building.base_cost[3] = 35
	return b

func Knowledge():
	var b = building_button.instance()
	b.building = b.BuffBuilding.new()
	b.building.name = "Knowledge"
	b.building.description = "Increased general knowledge allows you to research more efficiently."
	b.building.level = 0
	b.building.skill_buffed = 3
	b.building.base_cost[3] = 40
	return b

func Tactics():
	var b = building_button.instance()
	b.building = b.TacticsBuilding.new()
	b.building.combat = get_node('/root/Game/combat')
	b.building.name = "Battle Tactics"
	b.building.description = "Tactical software upgrades increases the total number of Troopers you can control by one-quarter."
	b.building.level = 0
	b.building.base_cost[0] = 20
	b.building.base_cost[1] = 40
	b.building.base_cost[2] = 40
	b.building.base_cost[3] = 10
	return b
	
#EQUIPMENT
func Shields():
	var b = building_button.instance()
	b.building = b.EquipmentBuilding.new()
	b.building.name = "Shields"
	b.building.description = "Each level of Shields increases your Shields by 6 points per Trooper."
	b.building.level = 0
	b.building.skill_buffed = 'shields'
	b.building.buff_factor = 6
	b.building.base_cost[1] = 10
	return b

func Claws():
	var b = building_button.instance()
	b.building = b.EquipmentBuilding.new()
	b.building.name = "Claws"
	b.building.description = "The better to rip you shreds with, my dear!\n Each level of Claws adds 4 points to your Troopers' base damage."
	b.building.level = 0
	b.building.skill_buffed = 'weapon'
	b.building.buff_factor = 4
	b.building.base_cost[0] = 4
	b.building.base_cost[2] = 8
	return b

func Lasers():
	var b = building_button.instance()
	b.building = b.EquipmentBuilding.new()
	b.building.name = "Lasers"
	b.building.description = "Emitted radiation of amplified light! Each level of Lasers increases your Troopers damage by 8 points."
	b.building.level = 0
	b.building.skill_buffed = 'weapon'
	b.building.buff_factor = 8
	b.building.base_cost[1] = 6
	b.building.base_cost[2] = 11
	return b

func Armor():
	var b = building_button.instance()
	b.building = b.EquipmentBuilding.new()
	b.building.name = "Armor Plating"
	b.building.description = "Rudimentary Bot protection. Each level of Armor Plating adds 6 Health to each Trooper."
	b.building.level = 0
	b.building.skill_buffed = 'armor'
	b.building.buff_factor = 6
	b.building.base_cost[0] = 6
	b.building.base_cost[2] = 9
	return b
	
func HardPlate():
	var b = building_button.instance()
	b.building = b.EquipmentBuilding.new()
	b.building.name = "Hardened Plating"
	b.building.description = "Each level adds 12 Health to each Trooper."
	b.building.level = 0
	b.building.skill_buffed = 'armor'
	b.building.buff_factor = 12
	b.building.base_cost[2] = 10
	b.building.base_cost[1] = 10
	return b