
extends Panel

### GLOBALS ###
onready var metrics = get_node('/root/Game/Metrics')

var format	#number formatting
#links
var combat	#combat node
var rng		#random name generator


#attributes
var mob_name = "Bob the Mob"
var boss = 0			#BOSS status; 0=non-boss, 1=Mini-Boss, 2=Mega-Boss

var level = 0			#mob level

var damage_base = 1			#mob base damage
var health_base = 1			#mob base HP

var damage_factor = 1.6	#DMG/strength
var health_factor = 4.0 #HP/vitality

var damage_var = 0.6	#variation +- base DMG
var health_var = 0.05	#variation +- base HP

var current_health = 0		#current HP
var total_health = 0		#max HP

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
func _draw_healthbar(per):
	var bar = get_node('healthbar')
	var show_v = bar.get_value()
	if show_v <= 0.01:
		_die()
	if per-0.05 < show_v < per+0.05:	#clamp to value if within threshold
		show_v = per
	else:	#otherwise, slide bar up or down
		show_v += sign(per - show_v) * (abs(per - show_v)*0.05)*2
	bar.set_value(show_v)

	var health_txt = format.number(current_health) + "/" + format.number(total_health)
	get_node('healthbar/health').set_text(health_txt)

func _draw_panel():
	_draw_name()
	_draw_stats()
	_draw_level()
	var per = current_health*1.0 / total_health*1.0
	_draw_healthbar(per)
	_draw_damage()
	

func _draw_damage():
	var dmg = _damage_range()
	var dmg_txt = "Damage: " +format.number(dmg[0])+ "-" +format.number(dmg[1])
	get_node('damage').set_text(dmg_txt)

func _draw_name():
	get_node('mob').set_text(mob_name)

func _draw_stats():
	get_node('mob_stats').set_text("[ STR "+format.number(damage_base)+"    VIT "+format.number(health_base)+" ]")

func _draw_level():
	get_node('mob_lvl').set_text("Level "+format.number(level))

func _set_total_health():
	var base_health = int(health_base*health_factor) ^ int(ceil(level*0.05))

	
	var min_health = max(1,base_health * health_var)
	var max_health = max(1, base_health * (1.0+health_var))
	total_health = round(rand_range(min_health, max_health))
	
func _damage_range():
	var base_dmg = int(damage_base*damage_factor) ^ int(ceil(level*0.05))
	var min_dmg = max(1, base_dmg * damage_var)
	var max_dmg = max(2, base_dmg * (1.0+damage_var))
	return [int(min_dmg), int(max_dmg)]

func _die():
	is_dead = true
	metrics.total_kills += 1
	if boss == 1:
		metrics.total_miniboss_kills += 1
	if boss == 2:
		metrics.total_megaboss_kills += 1



### PUBLIC FUNCTIONS ###
func new(name=null):
	#increment level
	level = combat.map.level
	var minibosscheck = int(level)%10 == 0
	var megabosscheck = int(level)%100 == 0
	prints(minibosscheck,megabosscheck)
	#set base dmg and health
	damage_base = 1
	health_base = 1
	for i in range(level):
		damage_base += round(rand_range(1,6))
		health_base += round(rand_range(1,6))
	
	if minibosscheck:
		damage_base *= 5
		health_base *= 4
		boss = 1
	elif megabosscheck:
		damage_base *= 10
		health_base *= 10
		boss = 2
	
	_set_total_health()
	current_health = total_health
	if !name:
		mob_name = rng.random_animal()
	else:
		mob_name = name
	_draw_panel()
	
	is_dead = false


func attack():
	var dmg = _damage_range()
	randomize()
	return round(rand_range(dmg[0],dmg[1]))

func take_damage(dmg):
	var new_health = current_health - dmg
	if new_health <= 0:
		current_health = 0
#		_die()
	else:
		current_health = new_health
		print("Mob takes "+str(dmg)+" damage")

func blit_healthbar():
	var per = (current_health*1.0) / (total_health*1.0)
	_draw_healthbar(per)

#Reset/Save/Restore
func reset():
	new()
	_draw_panel()

func save():
	var saveDict = {
		'mob_name':		mob_name
	}
	return saveDict
	
func restore(source):
	new(source['mob_name'])
	_draw_panel()

### CHILD FUNCTIONS ###


