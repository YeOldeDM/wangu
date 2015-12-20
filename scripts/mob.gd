
extends Panel

### GLOBALS ###
#links
var combat = get_node('/root/Game/combat')	#link to combat node
var rng = get_node('/root/random')			#random name generator


#attributes
var name = "Bob the Mob"
var boss = 0			#BOSS status; 0=non-boss, 1=Mini-Boss, 2=Mega-Boss

var level = 0			#mob level

var damage_base = 1			#mob base damage
var health_base = 1		#mob base HP

var damage_factor = 1.6	#DMG/strength
var health_factor = 4.0 #HP/vitality

var damage_var = 0.6	#variation +- base DMG
var health_var = 0.05	#variation +- base HP

var current_health		#current HP
var total_health		#max HP

var is_dead = true		#Death flag

### INIT ###
func _ready():
	# Initialization here
	pass

###############################
###	COMBAT MOB FUNCTIONS	###
###############################
### PUBLIC FUNCTIONS ###
func new_mob():
	pass

func attack():
	pass

func take_damage(dmg):
	pass

### PRIVATE FUNCTIONS ###
func _draw_healthbar():
	pass
func _draw_damage():
	pass
func _draw_name():
	pass

func _set_total_health():
	var base_health = max(1.0,(vitality*0.5))*health_factor
	if boss == 2:
		base_health *= 5.0
	elif boss == 1:
		base_health *= 2.0
	
	var min_health = base_health * health_var
	var max_health = base_health * (1.0+health_var)
func _damage_range():
	pass

func _die():
	pass
### CHILD FUNCTIONS ###


