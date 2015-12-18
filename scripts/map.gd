
extends Panel

### GLOBALS ###
#links
var combat = get_node('/root/Game/combat')	#link to combat node
var grid = get_node('grid')		#link to map grid object
var cells = null		#list of map cells

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
	
func draw_map():
	pass

func next_cell():
	pass

func set_cells(cellsList):
	cells = cellsList

func get_cell(n):
	return cells[n].cell
### PRIVATE FUNCTIONS ###
func _clear_map():
	pass

func _draw_cell():
	pass
	
func _collect_loot():
	pass
	
func _next_zone():
	pass

func _next_sector():
	pass
### CHILD FUNCTIONS ###




