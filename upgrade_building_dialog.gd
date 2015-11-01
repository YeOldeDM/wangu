
extends WindowDialog

var this_building = null
var this_colony = null

func draw_window(colony,building):
	this_building = building
	this_colony = colony
	
	var metal_cost = building.get('cost','metal',building.level+1)
	var crystal_cost = building.get('cost','crystal',building.level+1)
	var fuel_cost = building.get('cost','fuel',building.level+1)
	var energy_cost = building.get('upkeep','energy',building.level+1) - building.get('upkeep','energy',building.level)
	var free_energy = colony.my_energy - colony.energy_used
	
	if colony.my_metal < metal_cost or colony.my_crystal < crystal_cost or colony.my_fuel < fuel_cost or this_building.is_upgrading or energy_cost > free_energy:
		get_node('Upgrade').set_disabled(true)
	
	set_title(str("Lv",building.level," ",building.name))
	get_node('level').set_text(str("Level ",this_building.level))
	
	
	get_node('metal_cost').set_text(str(metal_cost))
	get_node('crystal_cost').set_text(str(crystal_cost))
	get_node('fuel_cost').set_text(str(fuel_cost))
	get_node('energy_cost').set_text(str(energy_cost))
	var g = load('res://global.gd')
	get_node('time').set_text(g.format_time(building.get_build_time(building.level+1)))
	
	get_node('description').clear()
	get_node('description').add_text(building.description)
	
	var metal_prod = building.get('production','metal',building.level) - building.get('upkeep','metal',building.level)
	var metal_prod1 = building.get('production','metal',building.level+1) - building.get('upkeep','metal',building.level+1)
	var metal_diff = metal_prod1 - metal_prod
	
	var crystal_prod = building.get('production','crystal',building.level) - building.get('upkeep','crystal',building.level)
	var crystal_prod1 = building.get('production','crystal',building.level+1) - building.get('upkeep','crystal',building.level+1)
	var crystal_diff = crystal_prod1 - crystal_prod
	
	var fuel_prod = building.get('production','fuel',building.level) - building.get('upkeep','fuel',building.level)
	var fuel_prod1 = building.get('production','fuel',building.level+1) - building.get('upkeep','fuel',building.level+1)
	var fuel_diff = fuel_prod1 - fuel_prod
	
	var energy_prod = building.get('production','energy',building.level) - building.get('upkeep','energy',building.level)
	var energy_prod1 = building.get('production','energy',building.level+1) - building.get('upkeep','energy',building.level+1)
	var energy_diff = energy_prod1 - energy_prod
	
	get_node('production/metal rate').set_text(str(metal_prod))
	get_node('production/crystal rate').set_text(str(crystal_prod))
	get_node('production/fuel rate').set_text(str(fuel_prod))
	get_node('production/energy rate').set_text(str(energy_prod))
	
	get_node('production/metal rate1').set_text(str(metal_prod1))
	get_node('production/crystal rate1').set_text(str(crystal_prod1))
	get_node('production/fuel rate1').set_text(str(fuel_prod1))
	get_node('production/energy rate1').set_text(str(energy_prod1))
	
	get_node('production/metal diff').set_text(str(metal_diff))
	get_node('production/crystal diff').set_text(str(crystal_diff))
	get_node('production/fuel diff').set_text(str(fuel_diff))
	get_node('production/energy diff').set_text(str(energy_diff))
func _ready():
	pass




func _on_Upgrade_pressed():
	
	this_colony.my_metal -= this_building.get('cost','metal',this_building.level+1)
	this_colony.my_crystal -= this_building.get('cost','crystal',this_building.level+1)
	this_colony.my_fuel -= this_building.get('cost','fuel',this_building.level+1)
	
	this_building.is_upgrading = true
	var t = this_building.get_build_time(this_building.level + 1)
	this_building.build_timer = t
	queue_free()
