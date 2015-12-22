
extends Panel

### GLOBALS ###

#Preloads
var map_cell = preload('res://map_cell.xml')

#links
var combat = get_node('/root/Game/combat')	#link to combat node
var grid


var sector = 0			#current sector
var zone = 1			#current zone
var current_cell = 0	#current zone cell


### INIT ###
func _ready():
	grid = get_node('grid')		#link to map grid object
	get_node('/root/Game/combat').map = self

###	COMBAT MAP FUNCTIONS	###

### PUBLIC FUNCTIONS ###
func generate_map():
	if grid.get_children().size() > 0:
		_clear_map()
	for l in range(100):
		_draw_cell(l)
	
func regenerate_map():
	pass


func next_cell():
	_collect_loot()
	current_cell += 1
	if current_cell > 99:
		_next_zone()

func set_cells(cellsList):
	pass

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
	var L = (sector*1000) + (zone*100) + l
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
	
func _collect_loot():
	pass
	
func _next_zone():
	current_cell = 0
	zone += 1
	if zone > 10:
		_next_sector()
	else:
		generate_map()

func _next_sector():
	zone = 1
	sector += 1
	generate_map()
### CHILD FUNCTIONS ###




