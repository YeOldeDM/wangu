
extends Panel

### GLOBALS ###
var format	#number formatting
#links
var combat	#combat node
var rng		#random name generator


#attributes
var name = "Bob the Mob"
var boss = 0			#BOSS status; 0=non-boss, 1=Mini-Boss, 2=Mega-Boss

var level = 0			#mob level

var damage_base = 1			#mob base damage
var health_base = 1			#mob base HP

var damage_factor = 1.6	#DMG/strength
var health_factor = 4.0 #HP/vitality

var damage_var = 0.6	#variation +- base DMG
var health_var = 0.05	#variation +- base HP

var current_health		#current HP
var total_health		#max HP

var is_dead = true		#Death flag

###############################
###	COMBAT MOB FUNCTIONS	###
###############################

### INIT ###
func _ready():
	format = get_node('/root/formats')
	#links
	combat = get_node('/root/Game/combat')	#link to combat node
	rng = get_node('/root/random')			#random name generator
	get_node('/root/Game/combat').mob = self

### PRIVATE FUNCTIONS ###
func _draw_healthbar():
	pass
func _draw_damage():
	pass
func _draw_name():
	pass

func _set_total_health():
	var base_health = (health_base*health_factor) ^ ceil(level*0.05)
	if boss == 2:
		base_health *= 5.0
	elif boss == 1:
		base_health *= 2.0
	
	var min_health = base_health * health_var
	var max_health = base_health * (1.0+health_var)

func _damage_range():
	var base_dmg = (damage_base*damage_factor) ^ (level+1)
	var min_dmg = max(1, base_dmg * damage_var)
	var max_dmg = max(2, base_dmg * (1.0+damage_var))
	return [int(min_dmg), int(max_dmg)]

func _die():
	pass


### PUBLIC FUNCTIONS ###
func new_mob():
	level += 1
	

func attack():
	var dmg = _damage_range()
	randomize()
	return round(rand_range(dmg[0],dmg[1]))

func take_damage(dmg):
	var damage = max(0,dmg-get_shields())
	var new_health = self.current_health - damage
	if new_health <= 0:
		self.current_health = 0
		self._die()
	else:
		self.current_health = new_health


### CHILD FUNCTIONS ###


