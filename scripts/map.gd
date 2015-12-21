
extends Panel

### GLOBALS ###

#Preloads
var map_cell = preload('res://map_cell.xml')

#links
var combat = get_node('/root/Game/combat')	#link to combat node
var grid = get_node('grid')		#link to map grid object


var sector = 0			#current sector
var zone = 1			#current zone
var current_cell = 0	#current zone cell


### INIT ###
func _ready():
	# Initialization here
	pass

###	COMBAT MAP FUNCTIONS	###

### PUBLIC FUNCTIONS ###
func generate_map():
	pass
	
func regenerate_map():
	pass


func next_cell():
	pass

func set_cells(cellsList):
	pass

func get_cell(n):
	return cells[n].cell
	
### PRIVATE FUNCTIONS ###
func _clear_map():
	#clear all map cells from the grid
	for cell in grid.get_children():
		cell.queue_free()

func _draw_cell():
	#instanciate a map cell
	var cell = map_cell.instance()
	#define cell attributes..
	
	#add instance to grid
	grid.add_child(cell)
	
func _collect_loot():
	pass
	
func _next_zone():
	pass

func _next_sector():
	pass
### CHILD FUNCTIONS ###




