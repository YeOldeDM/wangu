
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
	if 'population' in structure.building:
		structure.building.population = get_node('/root/Game/population')
	if 'construction' in structure.building:
		structure.building.construction = self
	if 'bank' in structure.building:
		structure.building.bank = get_node('/root/Game/Bank')
	if 'combat' in structure.building:
		structure.building.combat = get_node('/root/Game/combat')
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
	make_shack()
	make_garage()
	make_hangar()
	
	make_scrapyard()
	make_crystalcaves()
	make_naniteservers()

	make_metallurgy()
	
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

func make_metallurgy():
	var name = "Metallurgy"
	var description = "Base production of Metal is increased by 125% per level of Metallurgy."
	var category = "Science"
	var structure_category = "Boost"
	var material = 0
	var factor = 0
	var base_cost = {0:50, 
					1:0,
					2:0,
					3:50}
	_structure_factory(name,description,category,structure_category,material,factor,base_cost)