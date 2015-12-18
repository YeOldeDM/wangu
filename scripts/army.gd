
extends Panel

### GLOBALS ###

#links
var population
var equipment

#army attributes
var troops = 1		#current no. of troops
var unit_damage = 3		#base damage per trooper
var damage_var = 0.4	#variation +- base damage
var unit_health= 10		#base HP per trooper
var skill = {0:0, 1:0, 2:0}

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



func get_total_health():
	pass
func set_total_health():
	pass

func get_shields():
	pass
func set_shields():
	pass

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

func _set_troopers():
	pass
func _set_skills():
	pass

func _damage():
	pass
func _die():
	pass

### CHILD FUNCTIONS ###

