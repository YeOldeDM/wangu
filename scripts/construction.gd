
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
	prints("Restoring Construction:", source.keys() )
	var struct_source = source['structures']
	print(struct_source)
	_clear_structures()
	#look through base set of Structures
	#if its ID is in source, use that data
	#otherwise, use default starter data
	for struct in init_structures:
		var this_struct = struct

		for struct in struct_source:
			if struct['ID'] == this_struct['ID']:
				this_struct = struct
				#print("found "+struct['ID']+" in source")
		
		var call_str = "make_"+this_struct['ID']
		if has_method(call_str):
			call(call_str,int(this_struct['lvl']))
		else:
			print("\n\n INVALID STRUCTURE CANNOT BE RESTORED \n "+this_struct['ID'])
	




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

var init_structures = [
	{'ID':	'shack',	'lvl':	0},
	{'ID':	'garage',	'lvl':	0},
	{'ID':	'hangar',	'lvl':	0},
	{'ID':	'robodome',	'lvl':	0},

	{'ID':	'scrapyard',	'lvl':	0},
	{'ID':	'crystalcaves',	'lvl':	0},
	{'ID':	'naniteservers',	'lvl':	0},
	
	{'ID':	'metallurgy',	'lvl':	0},
	{'ID':	'attunement',	'lvl':	0},
	{'ID':	'synthesis',	'lvl':	0},
	{'ID':	'gnosis',		'lvl':	0},
	{'ID':	'enlightenment',	'lvl':	0},
	{'ID':	'battletactics',	'lvl':	0},
	
	
	{'ID':	'shields',	'lvl':	0},
	
	{'ID':	'claws',		'lvl':	0},
	{'ID':	'lasers',		'lvl':	0},
	{'ID':	'rockets',		'lvl':	0},
	{'ID':	'laserclaws',	'lvl':	0},
	
	{'ID':	'hardplate',	'lvl':	0},
	{'ID':	'nanoplate',	'lvl':	0},
	{'ID':	'impactjelly',	'lvl':	0},
	]



func _ready():
	for struct in init_structures:
		var call_str = "make_"+struct['ID']
		if has_method(call_str):
			call(call_str,int(struct['lvl']))
		else:
			print("\n\n INVALID STRUCTURE CANNOT BE CREATED \n "+struct['ID'])

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
	var description = "Roomy housing for Bots. Each Garage provides living space for 5 Bots."
	var category = "Buildings"
	var structure_category = "Housing"
	var level = l
	var material = 0
	var factor = 5
	var base_cost = {0:24, 
					1:20,
			2:0,3:0}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)

func make_hangar(l=0):
	var name = "Hangar"
	var structID = "hangar"
	var description = "Luxurious housing for Bots. Each Hangar provides living space for 10 Bots."
	var category = "Buildings"
	var structure_category = "Housing"
	var level = l
	var material = 0
	var factor = 10
	var base_cost = {0:68, 
					1:40,
					2:30,
			3:0}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)

func make_robodome(l=0):
	var name = "Robo-Dome"
	var structID = "robodome"
	var description = "A mini robo city! Each Robo-Dome packs an additional 25 Bots to your population."
	var category = "Buildings"
	var structure_category = "Housing"
	var level = l
	var material = 0
	var factor = 25
	var base_cost = {0:120, 
					1:70,
					2:100,
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
					1:0,
					2:50,
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
	var description = "Each level of Shields blocks 8 points of damage to each Trooper."
	var category = "Equipment"
	var structure_category = "Equipment"
	var level = l
	var material = 2
	var factor = 8
	var base_cost = {0:0, 
							1:4,
					2:0,
					3:0}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)

func make_claws(l=0):
	var name = "Claws"
	var structID = "claws"
	var description = "Each level of Claws adds 8 points of damage to each Trooper."
	var category = "Equipment"
	var structure_category = "Equipment"
	var level = l
	var material = 0
	var factor = 8
	var base_cost = {
							0:3, 
					1:0,
					2:0,
					3:0}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)

func make_lasers(l=0):
	var name = "Lasers"
	var structID = "lasers"
	var description = "Each level of Lasers adds 20 points of damage to each Trooper."
	var category = "Equipment"
	var structure_category = "Equipment"
	var level = l
	var material = 0
	var factor = 20
	var base_cost = {
							0:0, 
					1:2,
					2:5,
					3:0}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)

func make_rockets(l=0):
	var name = "Rockets"
	var structID = "rockets"
	var description = "Surface-to-Air-to-Surface destruction! Adds 40 points of damage to each Trooper per level."
	var category = "Equipment"
	var structure_category = "Equipment"
	var level = l
	var material = 0
	var factor = 40
	var base_cost = {
			0:	0,
			1:	0,
			2:	12,
			3:	0
		}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)

func make_laserclaws(l=0):
	var name = "Laser Claws"
	var structID = "laserclaws"
	var description = "Laser Claws!! Adds 90 points of damage to each trooper."
	var category = "Equipment"
	var structure_category = "Equipment"
	var level = l
	var material = 0
	var factor = 90
	var base_cost = {
					0:0, 
					1:0,
					2:20,
					3:0}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)


func make_hardplate(l=0):
	var name = "Hard Plate"
	var structID = "hardplate"
	var description = "Each level of Hard Plate adds 16 HP to each Trooper."
	var category = "Equipment"
	var structure_category = "Equipment"
	var level = l
	var material = 1
	var factor = 16
	var base_cost = {
							0:6, 
					1:0,
					2:0,
					3:0}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)

func make_nanoplate(l=0):
	var name = "Nano-Plate"
	var structID = "nanoplate"
	var description = "Each level of Nano-Plate adds 50 HP to each Trooper."
	var category = "Equipment"
	var structure_category = "Equipment"
	var level = l
	var material = 1
	var factor = 50
	var base_cost = {
							0:0, 
					1:0,
					2:10,
					3:0}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)
	
func make_impactjelly(l=0):
	var name = "Impact Jelly"
	var structID = "impactjelly"
	var description = "High-impact-resistant, variable-density smart gel. Increases the HP of each trooper by 110 points per level."
	var category = "Equipment"
	var structure_category = "Equipment"
	var level = l
	var material = 1
	var factor = 110
	var base_cost = {
			0:0,
			1:24,
			2:20,
			3:0}
	_structure_factory(name,structID,description,category,structure_category,level,material,factor,base_cost)