
extends Panel

### GLOBALS ###

#links
var population
var construction = get_node('/root/Game/construction')

#army attributes
var troops = 1				#current no. of troops
var unit_damage = 3			#base damage per trooper
var damage_var = 0.4		#variation +- base damage
var unit_health= 10			#base HP per trooper
var unit_skills = {0:0, 1:0, 2:0}	#0=damage, 1=armor, 2=shields

var current_health
var total_health

var is_dead = true
var is_ready = false
var is_auto = false

### INIT ###
func _ready():
	# Initialization here
	pass

###	COMBAT ARMY FUNCTIONS	###

### PUBLIC FUNCTIONS ###
func new_army():
	pass

func attack():
	pass

func take_damage(dmg):
	pass

func set_total_health():
	set_armor()
	total_health = get_total_health()

func get_total_health():
	return (unit_health+unit_skills[1]) * troops

## get equipment lists
func get_weapons():
	_get_skill(0)

func get_armor():
	_get_skill(1)

func get_shields():
	_get_skill(2)

## set equipment
func set_weapons():
	_set_skill(0)

func set_armor():
	_set_skill(1)

func set_shields():
	_set_skill(2)



func set_autofight(auto):
	is_auto = auto
func is_autofighting():
	return is_auto

func set_combat_ready(ready):
	is_ready = ready
func is_combat_ready():
	return is_ready

### PRIVATE FUNCTIONS ###
func _draw_healthbar():
	pass
func _draw_damage():
	pass
func _draw_shields():
	pass
func _draw_troopers():
	pass

func _get_skill(skill):
	var data = []
	for cat in construction.structures:
		for struct in construction.structures[cat]:
			if struct.building.level > 0:
				if struct.building.category == "Equipment":
					if struct.building.material == skill:
						var B = struct.building
						data.append({'name':B.name, 'lvl':B.level, 'factor':B.factor})
	return data

func _set_skill(skill):
	var value = 0
	for cat in construction.structures:
		for struct in construction.structures[cat]:
			if struct.building.category == 'Equipment':
				if struct.building.material == skill:
					value += (struct.building.factor * struct.building.level)
	unit_skills[int(skill)] = value


func _set_troopers():
	var value = 0
	for cat in construction.structures:
		for struct in construction.structures[cat]:
			if struct.building.category == "Tactics":
				value += struct.building.level
	var T = 1
	while value > 0:
		T += ceil(troops * 0.25)
		value -= 1
	troops = T

func _damage_range():
	pass

func _die():
	pass

### CHILD FUNCTIONS ###

