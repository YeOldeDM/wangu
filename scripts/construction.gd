
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

var structure_button = load('res://building.xml')


#############################
#	SAVE/RESTORE FUNCTIONS	#
#############################
#SAVE#
func save():
	var saveDict = {
		'structures': []
	}
	for cat in structures:
		for struct in structures[cat]:
			if 'structID' in struct.building:
				var structDict = {'ID': "", 'lvl': 0}
				structDict['ID'] = struct.building.structID
				structDict['lvl'] = struct.building.level
				saveDict['structures'].append(structDict)
	return saveDict


#RESTORE#
func restore(source):
	var struct_source = source['structures']
	print('STRUCTURES')
	
	_clear_structures()
	for struct in struct_source:
		var call_str = "make_"+struct['ID']
		if has_method(call_str):
			call(call_str,int(struct['lvl']))
		else:
			print("\n\n INVALID STRUCTURE CANNOT BE RESTORED \n "+struct['ID'])



#########################
#	PRIVATE FUNCTIONS	#
#########################
func _add_structure(category, structure):
	structures[category].append(structure)
	var grid = str('Buildings/cont/'+category+'/cont/cont')
	get_node(grid).add_child(structure)
	structure.draw_button()

func _structure_factory(name, structID, description, category, structure_category, level, material, factor, base_cost):
	var structure = structure_button.instance()
	if structure.building:
		var b = structure.building
		b.name = name
		b.description = description
		b.structID = structID
		b.category = structure_category
		b.level = level
		b.material = material
		b.factor = factor
		b.base_cost = base_cost
	else:
		print("BUILDING OBJECT NOT CREATED!")
	_add_structure(category,structure)
	
func _clear_structures():
	for cat in structures:
		for struct in structures[cat]:
			struct.queue_free()
	structures = {
	'Buildings':	[],
	'Facilities':	[],
	'Science':		[],
	'Equipment':	[]
				}



#############
#	INIT	#
#############

func _ready():
	#All this should be replaced by Restore/New functions
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
	make_lasers()
	make_hardplate()
	make_nanoplate()
	
	#tactics
	make_battletactics()

#########################
#	HOUSING STRUCTURES	#
# material: N/A			#
# factor: +pop/lvl		#
#########################
#!!!!!!!!!!!!!!!!!!!!!!!#
#	Add argument 'l':	#
#	set initial 		#
#	structure lvl		#
#						#
#	Add structID:		#
#	=func name - 'make_'#
#	prefix.				#
#########################
func make_shack(l=0):
	var name = "Shack"
	var structID = "shack"
	var description = "Basic housing for Bots. Each Shack provides living space for 2 Bots."
	var category = "Buildings"
	var structure_category = "Housing"
	var level = l
	var material = 0
	var factor = 2
	var base_cost = {0:10,
		1:0,2:0,3:0}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)

#UPDATE HERE DOWN
func make_garage(l=0):
	var name = "Garage"
	var structID = "garage"
	var description = "Roomy housing for Bots. Each Shack provides living space for 5 Bots."
	var category = "Buildings"
	var structure_category = "Housing"
	var level = l
	var material = 0
	var factor = 5
	var base_cost = {0:45, 
					1:12,
			2:0,3:0}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)

func make_hangar(l=0):
	var name = "Hangar"
	var structID = "hangar"
	var description = "Luxurious housing for Bots. Each Shack provides living space for 10 Bots."
	var category = "Buildings"
	var structure_category = "Housing"
	var level = l
	var material = 0
	var factor = 10
	var base_cost = {0:80, 
					1:40,
					2:22,
			3:0}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)
	
#########################
#	STORAGE STRUCTURES	#
# material:				#
# 0=metal				#
# 1=crystal				#
# 2=nanium				#
#########################
func make_scrapyard(l=0):
	var name = "Scrapyard"
	var structID = "scrapyard"
	var description = "Storage for scrap Metal."
	var category = "Facilities"
	var structure_category = "Storage"
	var level = l
	var material = 0
	var factor = 100
	var base_cost = {0:0, 
					1:0,
					2:0,
					3:0}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)

func make_crystalcaves(l=0):
	var name = "Crystal Caves"
	var structID = "crystalcaves"
	var description = "Storage for Crystal."
	var category = "Facilities"
	var structure_category = "Storage"
	var level = l
	var material = 1
	var factor = 100
	var base_cost = {0:0, 
					1:0,
					2:0,
					3:0}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)

func make_naniteservers(l=0):
	var name = "Nanite Servers"
	var structID = "naniteservers"
	var description = "Storage for Nanium."
	var category = "Facilities"
	var structure_category = "Storage"
	var level = l
	var material = 2
	var factor = 100
	var base_cost = {0:0, 
					1:0,
					2:0,
					3:0}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)

#########################
#	BOOST STRUCTURES	#
# material				#
# 0=metal				#
# 1=crystal				#
# 2=nanium				#
# 3=tech				#
# 4=all					#
#########################
func make_metallurgy(l=0):
	var name = "Metallurgy"
	var structID = "metallurgy"
	var description = "Base production of Metal is increased by 25% per level of Metallurgy."
	var category = "Science"
	var structure_category = "Boost"
	var level = l
	var material = 0
	var factor = 0
	var base_cost = {0:50, 
					1:0,
					2:0,
					3:10}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)

func make_attunement(l=0):
	var name = "Attunement"
	var structID = "attunement"
	var description = "Base production of Crystal is increased by 25% per level of Attunement."
	var category = "Science"
	var structure_category = "Boost"
	var level = l
	var material = 1
	var factor = 0
	var base_cost = {0:0, 
					1:50,
					2:0,
					3:12}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)

func make_synthesis(l=0):
	var name = "Synthesis"
	var structID = "synthesis"
	var description = "Base production of Nanium is increased by 25% per level of Synthesis."
	var category = "Science"
	var structure_category = "Boost"
	var level = l
	var material = 2
	var factor = 0
	var base_cost = {0:0, 
					1:50,
					2:0,
					3:15}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)

func make_gnosis(l=0):
	var name = "Gnosis"
	var structID = "gnosis"
	var description = "Base production of Tech is increased by 25% per level of Gnosis."
	var category = "Science"
	var structure_category = "Boost"
	var level = l
	var material = 3
	var factor = 0
	var base_cost = {0:0, 
					1:0,
					2:0,
					3:50}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)

func make_enlightenment(l=0):
	var name = "Enlightenment"
	var structID = "enlightenment"
	var description = "Increases the production of Metal, Crystal, Nanium and Tech by 10% each level."
	var category = "Science"
	var structure_category = "Boost"
	var level = l
	var material = 4
	var factor = 0
	var base_cost = {0:20, 
					1:20,
					2:20,
					3:35}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)

func make_battletactics(l=0):
	var name = "Battle Tactics"
	var structID = "battletactics"
	var description = "Increases the number of Troopers in your combat forces by 25%"
	var category = "Science"
	var structure_category = "Tactics"
	var level = l
	var material = 0
	var factor = 0
	var base_cost = {0:20,
					1:20,
					2:20,
					3:40}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)


#########################
#	BOOST STRUCTURES	#
# material:				#
# 0=weapon(dmg)			#
# 1=armor(HP)			#
# 2=shield				#
#						#
# Factor: points/lvl	#
#########################

func make_shields(l=0):
	var name = "Shields"
	var structID = "shields"
	var description = "Each level of Shields blocks 6 points of damage to each Trooper."
	var category = "Equipment"
	var structure_category = "Equipment"
	var level = l
	var material = 2
	var factor = 6
	var base_cost = {0:0, 
							1:4,
					2:0,
					3:0}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)

func make_claws(l=0):
	var name = "Claws"
	var structID = "claws"
	var description = "Each level of Claws adds 4 points of damage to each Trooper."
	var category = "Equipment"
	var structure_category = "Equipment"
	var level = l
	var material = 0
	var factor = 4
	var base_cost = {
							0:3, 
					1:0,
					2:0,
					3:0}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)

func make_lasers(l=0):
	var name = "Lasers"
	var structID = "lasers"
	var description = "Each level of Lasers adds 10 points of damage to each Trooper."
	var category = "Equipment"
	var structure_category = "Equipment"
	var level = l
	var material = 0
	var factor = 10
	var base_cost = {
							0:0, 
					1:2,
					2:5,
					3:0}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)

func make_hardplate(l=0):
	var name = "Hard Plate"
	var structID = "hardplate"
	var description = "Each level of Hard Plate adds 6 HP to each Trooper."
	var category = "Equipment"
	var structure_category = "Equipment"
	var level = l
	var material = 1
	var factor = 6
	var base_cost = {
							0:6, 
					1:0,
					2:0,
					3:0}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)

func make_nanoplate(l=0):
	var name = "Nano-Plate"
	var structID = "nanoplate"
	var description = "Each level of Nano-Plate adds 14 HP to each Trooper."
	var category = "Equipment"
	var structure_category = "Equipment"
	var level = l
	var material = 1
	var factor = 14
	var base_cost = {
							0:0, 
					1:0,
					2:10,
					3:0}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)