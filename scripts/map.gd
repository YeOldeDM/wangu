
extends Panel

### GLOBALS ###
var format

var bank
#Preloads
var map_cell = preload('res://map_cell.xml')

#links
var combat	#link to combat node
var grid


var sector = 0			#current sector
var zone = 1			#current zone
var current_cell = 0	#current zone cell
var level = 1

var material_ref = {
	0:	'Metal',
	1:	'Crystal',
	2:	'Nanium',
	3:	'Tech'
		}

### INIT ###
func _ready():
	format = get_node('/root/formats')
	
	bank = get_node('/root/Game/Bank')
	combat = get_node('/root/Game/combat')	#link to combat node
	grid = get_node('grid')		#link to map grid object
	combat.map = self

	get_node('sector_bar').set_max(format.greek_abc.size())
	
	_draw_sector()
	_draw_zone()
	
###	COMBAT MAP FUNCTIONS	###

### PUBLIC FUNCTIONS ###
func generate_map():

	_clear_map()
	for l in range(100):
		_draw_cell(l)
	
func regenerate_map():
	pass


func next_cell(dropper):
	_collect_loot(dropper)
	grid.get_children()[current_cell].make_conquered()
	current_cell += 1
	if current_cell > 99:
		_next_zone()
	grid.get_children()[current_cell].make_active()
	level += 1

func get_cell(n):
	return grid.get_children()[n]
	
### PRIVATE FUNCTIONS ###
func _clear_map():
	#clear all map cells from the grid
	for cell in grid.get_children():
		cell.queue_free()

func _draw_cell(l):
	#instanciate a map cell
	var cell = map_cell.instance()
	#define cell attributes..
	var L = (sector*1000) + ((zone-1)*100) + l
	cell.level = L
	cell.make_loot()
	if l == current_cell:
		cell.make_active()
	elif l < current_cell:
		cell.make_conquered()
	else:
		cell.make_wild()

	#add instance to grid
	grid.add_child(cell)
	
func _collect_loot(mob_name):
	var cell = grid.get_children()[current_cell]
	if cell.loot_type <= 3:
		bank.gain_resource(int(cell.loot_type),int(cell.loot_amt))
		var loot_txt = str(cell.loot_amt) +" "+ material_ref[int(cell.loot_type)]
		combat.news.message("The "+ mob_name +" drops [b]" +loot_txt+ "[/b]!")
	elif cell.loot_type == 4:
		combat.population.gain_land(round(rand_range(1,3)))
	
func _next_zone():
	current_cell = 0
	zone += 1
	if zone > 10:
		_next_sector()
	else:
		generate_map()
	_draw_zone()

func _draw_zone():
	get_node('zone_bar').set_value(zone)
	get_node('zone_bar/zone').set_text("Zone "+ str(zone) +"/10")

func _next_sector():
	zone = 1
	sector += 1
	_draw_sector()
	generate_map()
	
	
func _draw_sector():
	get_node('sector_bar').set_value(sector)
	get_node('sector_bar/sector').set_text(format.greek_abc[sector] +" Sector")



func reset():
	sector = 0
	zone = 1
	current_cell = 0
	level = 1
	printt(sector, zone, current_cell, level)
	generate_map()

func save():
	var saveDict = {
		'sector':	sector,
		'zone':		zone,
		'current_cell':	current_cell,
		'level':		level
	}
	return saveDict
	
func restore(source):
	current_cell = source['current_cell']
	zone = source['zone']
	sector = source['sector']
	level = source['level']
	generate_map()
### CHILD FUNCTIONS ###




