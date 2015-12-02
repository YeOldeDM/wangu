
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

var structure_button = load('res://building.xml')

#########################
#	PRIVATE FUNCTIONS	#
#########################
func _add_structure(category, structure):
	structures[category].append(structure)
	var grid = str('Buildings/cont/'+category+'/cont/cont')
	get_node(grid).add_child(structure)
	structure.draw_button()

func _structure_factory(name, description, category, structure_category, material, factor, base_cost):
	var structure = structure_button.instance()
	if structure.building:
		var b = structure.building
		b.name = name
		b.description = description
		b.category = structure_category
		b.material = material
		b.factor = factor
		b.base_cost = base_cost
	else:
		print("BUILDING OBJECT NOT CREATED!")
	_add_structure(category,structure)
	
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
	#housing
	make_shack()
	make_garage()
	make_hangar()
	
	#storage
	make_scrapyard()
	make_crystalcaves()
	make_naniteservers()

	#boost
	make_metallurgy()
	make_attunement()
	make_synthesis()
	make_gnosis()
	make_enlightenment()
	
	#equipment
	make_shields()
	make_claws()
	make_hardplate()

#########################
#	HOUSING STRUCTURES	#
# material: N/A			#
# factor: +pop/lvl		#
#########################
func make_shack():
	var name = "Shack"
	var description = "Basic housing for Bots. Each Shack provides living space for 2 Bots."
	var category = "Buildings"
	var structure_category = "Housing"
	var material = 0
	var factor = 2
	var base_cost = {0:10,
		1:0,2:0,3:0}
	_structure_factory(name,description,category,structure_category,material,factor,base_cost)

func make_garage():
	var name = "Garage"
	var description = "Roomy housing for Bots. Each Shack provides living space for 5 Bots."
	var category = "Buildings"
	var structure_category = "Housing"
	var material = 0
	var factor = 5
	var base_cost = {0:45, 
					1:12,
			2:0,3:0}
	_structure_factory(name,description,category,structure_category,material,factor,base_cost)

func make_hangar():
	var name = "Hangar"
	var description = "Luxurious housing for Bots. Each Shack provides living space for 10 Bots."
	var category = "Buildings"
	var structure_category = "Housing"
	var material = 0
	var factor = 10
	var base_cost = {0:80, 
					1:40,
					2:22,
			3:0}
	_structure_factory(name,description,category,structure_category,material,factor,base_cost)
	
#########################
#	STORAGE STRUCTURES	#
# material:				#
# 0=metal				#
# 1=crystal				#
# 2=nanium				#
#########################
func make_scrapyard():
	var name = "Scrapyard"
	var description = "Storage for scrap Metal."
	var category = "Facilities"
	var structure_category = "Storage"
	var material = 0
	var factor = 100
	var base_cost = {0:0, 
					1:0,
					2:0,
					3:0}
	_structure_factory(name,description,category,structure_category,material,factor,base_cost)

func make_crystalcaves():
	var name = "Crystal Caves"
	var description = "Storage for Crystal."
	var category = "Facilities"
	var structure_category = "Storage"
	var material = 1
	var factor = 100
	var base_cost = {0:0, 
					1:0,
					2:0,
					3:0}
	_structure_factory(name,description,category,structure_category,material,factor,base_cost)

func make_naniteservers():
	var name = "Nanite Servers"
	var description = "Storage for Nanium."
	var category = "Facilities"
	var structure_category = "Storage"
	var material = 2
	var factor = 100
	var base_cost = {0:0, 
					1:0,
					2:0,
					3:0}
	_structure_factory(name,description,category,structure_category,material,factor,base_cost)

#########################
#	BOOST STRUCTURES	#
# material				#
# 0=metal				#
# 1=crystal				#
# 2=nanium				#
# 3=tech				#
# 4=all					#
#########################
func make_metallurgy():
	var name = "Metallurgy"
	var description = "Base production of Metal is increased by 25% per level of Metallurgy."
	var category = "Science"
	var structure_category = "Boost"
	var material = 0
	var factor = 0
	var base_cost = {0:50, 
					1:0,
					2:0,
					3:50}
	_structure_factory(name,description,category,structure_category,material,factor,base_cost)

func make_attunement():
	var name = "Attunement"
	var description = "Base production of Crystal is increased by 25% per level of Attunement."
	var category = "Science"
	var structure_category = "Boost"
	var material = 1
	var factor = 0
	var base_cost = {0:0, 
					1:50,
					2:0,
					3:55}
	_structure_factory(name,description,category,structure_category,material,factor,base_cost)

func make_synthesis():
	var name = "Synthesis"
	var description = "Base production of Nanium is increased by 25% per level of Synthesis."
	var category = "Science"
	var structure_category = "Boost"
	var material = 2
	var factor = 0
	var base_cost = {0:0, 
					1:50,
					2:0,
					3:55}
	_structure_factory(name,description,category,structure_category,material,factor,base_cost)

func make_gnosis():
	var name = "Gnosis"
	var description = "Base production of Tech is increased by 25% per level of Gnosis."
	var category = "Science"
	var structure_category = "Boost"
	var material = 3
	var factor = 0
	var base_cost = {0:0, 
					1:50,
					2:0,
					3:55}
	_structure_factory(name,description,category,structure_category,material,factor,base_cost)

func make_enlightenment():
	var name = "Enlightenment"
	var description = "Increases the production of Metal, Crystal, Nanium and Tech by 10% each level."
	var category = "Science"
	var structure_category = "Boost"
	var material = 4
	var factor = 0
	var base_cost = {0:20, 
					1:20,
					2:20,
					3:65}
	_structure_factory(name,description,category,structure_category,material,factor,base_cost)

#########################
#	BOOST STRUCTURES	#
# material:				#
# 0=weapon(dmg)			#
# 1=armor(HP)			#
# 2=shield				#
#						#
# Factor: points/lvl	#
#########################

func make_shields():
	var name = "Shields"
	var description = "Each level of Shields blocks 6 points of damage to each Trooper."
	var category = "Equipment"
	var structure_category = "Equipment"
	var material = 2
	var factor = 6
	var base_cost = {0:0, 
							1:7,
					2:0,
					3:0}
	_structure_factory(name,description,category,structure_category,material,factor,base_cost)

func make_claws():
	var name = "Claws"
	var description = "Each level of Claws adds 4 points of damage to each Trooper."
	var category = "Equipment"
	var structure_category = "Equipment"
	var material = 0
	var factor = 4
	var base_cost = {
							0:5, 
					1:0,
					2:0,
					3:0}
	_structure_factory(name,description,category,structure_category,material,factor,base_cost)

func make_hardplate():
	var name = "Hard Plate"
	var description = "Each level of Hard Plate adds 6 HP to each Trooper."
	var category = "Equipment"
	var structure_category = "Equipment"
	var material = 1
	var factor = 6
	var base_cost = {
							0:6, 
					1:0,
					2:0,
					3:0}
	_structure_factory(name,description,category,structure_category,material,factor,base_cost)